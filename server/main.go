package main

import (
	"context"
	"crypto/rand"
	"encoding/hex"
	"fmt"
	"log"
	"net/http"
	"sync"
	"time"

	"connectrpc.com/connect"
	"connectrpc.com/grpcreflect"
	"github.com/golang-jwt/jwt/v5"
	"github.com/rs/cors"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"

	chatv1 "github.com/ookami-kb/fluttercon25/server/gen/proto"
	"github.com/ookami-kb/fluttercon25/server/gen/proto/protoconnect"
)

const jwtSecret = "your-secret-key"

// In-memory storage
type Storage struct {
	mu       sync.RWMutex
	users    map[string]*chatv1.User
	messages []*chatv1.Message
	streams  []chan *chatv1.Message
}

func NewStorage() *Storage {
	return &Storage{
		users:   make(map[string]*chatv1.User),
		streams: make([]chan *chatv1.Message, 0),
	}
}

func (s *Storage) AddUser(user *chatv1.User) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.users[user.Id] = user
}

func (s *Storage) GetUser(id string) (*chatv1.User, bool) {
	s.mu.RLock()
	defer s.mu.RUnlock()
	user, exists := s.users[id]
	return user, exists
}

func (s *Storage) AddMessage(message *chatv1.Message) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.messages = append(s.messages, message)

	// Broadcast to all streams
	for _, stream := range s.streams {
		select {
		case stream <- message:
		default:
			// Stream is blocked, skip
		}
	}
}

func (s *Storage) GetMessages() []*chatv1.Message {
	s.mu.RLock()
	defer s.mu.RUnlock()
	return append([]*chatv1.Message{}, s.messages...)
}

func (s *Storage) AddStream(stream chan *chatv1.Message) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.streams = append(s.streams, stream)
}

func (s *Storage) RemoveStream(stream chan *chatv1.Message) {
	s.mu.Lock()
	defer s.mu.Unlock()
	for i, streamItem := range s.streams {
		if streamItem == stream {
			s.streams = append(s.streams[:i], s.streams[i+1:]...)
			break
		}
	}
}

// ChatServer implements the chat service
type ChatServer struct {
	storage *Storage
}

func NewChatServer() *ChatServer {
	return &ChatServer{
		storage: NewStorage(),
	}
}

// generateID creates a random hex ID
func generateID() string {
	bytes := make([]byte, 8)
	rand.Read(bytes)
	return hex.EncodeToString(bytes)
}

// generateColor creates a random hex color
func generateColor() string {
	bytes := make([]byte, 3)
	rand.Read(bytes)
	return fmt.Sprintf("#%02x%02x%02x", bytes[0], bytes[1], bytes[2])
}

// createJWT creates a JWT token for a user
func createJWT(userID string) (string, error) {
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"user_id": userID,
		"exp":     time.Now().Add(time.Hour * 24).Unix(),
	})
	return token.SignedString([]byte(jwtSecret))
}

// validateJWT validates a JWT token and returns user ID
func validateJWT(tokenString string) (string, error) {
	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}
		return []byte(jwtSecret), nil
	})

	if err != nil {
		return "", err
	}

	if claims, ok := token.Claims.(jwt.MapClaims); ok && token.Valid {
		userID, ok := claims["user_id"].(string)
		if !ok {
			return "", fmt.Errorf("invalid user_id claim")
		}
		return userID, nil
	}

	return "", fmt.Errorf("invalid token")
}

// Register endpoint - allows anonymous access
func (s *ChatServer) Register(
	ctx context.Context,
	req *connect.Request[chatv1.RegisterRequest],
) (*connect.Response[chatv1.RegisterResponse], error) {
	if req.Msg.Name == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("name is required"))
	}

	user := &chatv1.User{
		Id:    generateID(),
		Name:  req.Msg.Name,
		Color: generateColor(),
	}

	s.storage.AddUser(user)

	token, err := createJWT(user.Id)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to create token"))
	}

	return connect.NewResponse(&chatv1.RegisterResponse{
		Token: token,
		User:  user,
	}), nil
}

// SendMessage endpoint - requires authentication
func (s *ChatServer) SendMessage(
	ctx context.Context,
	req *connect.Request[chatv1.SendMessageRequest],
) (*connect.Response[chatv1.SendMessageResponse], error) {
	userID, err := s.authenticateRequest(req.Header())
	if err != nil {
		return nil, err
	}

	user, exists := s.storage.GetUser(userID)
	if !exists {
		return nil, connect.NewError(connect.CodeNotFound, fmt.Errorf("user not found"))
	}

	if req.Msg.Content == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("content is required"))
	}

	message := &chatv1.Message{
		Id:        generateID(),
		UserId:    user.Id,
		UserName:  user.Name,
		UserColor: user.Color,
		Content:   req.Msg.Content,
		Timestamp: time.Now().UnixMilli(),
	}

	s.storage.AddMessage(message)

	return connect.NewResponse(&chatv1.SendMessageResponse{
		Message: message,
	}), nil
}

// WatchMessages endpoint - returns a stream of messages
func (s *ChatServer) WatchMessages(
	ctx context.Context,
	req *connect.Request[chatv1.WatchMessagesRequest],
	stream *connect.ServerStream[chatv1.WatchMessagesResponse],
) error {
	_, err := s.authenticateRequest(req.Header())
	if err != nil {
		return err
	}

	// Send existing messages
	messages := s.storage.GetMessages()
	for _, message := range messages {
		if err := stream.Send(&chatv1.WatchMessagesResponse{Message: message}); err != nil {
			return err
		}
	}

	// Create stream for new messages
	messageStream := make(chan *chatv1.Message, 100)
	s.storage.AddStream(messageStream)
	defer s.storage.RemoveStream(messageStream)

	// Listen for new messages
	for {
		select {
		case <-ctx.Done():
			return ctx.Err()
		case message := <-messageStream:
			if err := stream.Send(&chatv1.WatchMessagesResponse{Message: message}); err != nil {
				return err
			}
		}
	}
}

// authenticateRequest validates JWT token from Authorization header
func (s *ChatServer) authenticateRequest(headers http.Header) (string, error) {
	auth := headers.Get("Authorization")
	if auth == "" {
		return "", connect.NewError(connect.CodeUnauthenticated, fmt.Errorf("authorization header required"))
	}

	if len(auth) < 7 || auth[:7] != "Bearer " {
		return "", connect.NewError(connect.CodeUnauthenticated, fmt.Errorf("invalid authorization format"))
	}

	token := auth[7:]
	userID, err := validateJWT(token)
	if err != nil {
		return "", connect.NewError(connect.CodeUnauthenticated, fmt.Errorf("invalid token: %v", err))
	}

	return userID, nil
}

func main() {
	server := NewChatServer()

	mux := http.NewServeMux()
	path, handler := protoconnect.NewChatServiceHandler(server)
	mux.Handle(path, handler)

	// Add gRPC reflection support
	reflector := grpcreflect.NewStaticReflector(
		protoconnect.ChatServiceName,
	)
	mux.Handle(grpcreflect.NewHandlerV1(reflector))
	mux.Handle(grpcreflect.NewHandlerV1Alpha(reflector))

	// Set up CORS
	c := cors.New(cors.Options{
		AllowedOrigins:   []string{"*"},
		AllowedMethods:   []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowedHeaders:   []string{"*"},
		AllowCredentials: true,
	})

	// Wrap with CORS and HTTP/2
	handler = c.Handler(mux)
	handler = h2c.NewHandler(handler, &http2.Server{})

	fmt.Println("Chat server starting on :8080")
	log.Fatal(http.ListenAndServe(":8080", handler))
}
