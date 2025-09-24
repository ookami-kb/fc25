import 'dart:async';
import 'dart:math';

import 'package:grpc/grpc.dart';
import 'package:fixnum/fixnum.dart';

import 'package:server_dart/gen/proto/chat.pbgrpc.dart';

class _Storage {
  final Map<String, User> users = {};
  final List<Message> messages = [];
  final List<StreamController<WatchMessagesResponse>> streams = [];
}

final _storage = _Storage();
final _rand = Random();

String _generateId([int len = 8]) {
  const chars = 'abcdef0123456789';
  return List.generate(len * 2, (_) => chars[_rand.nextInt(chars.length)]).join();
}

String _generateColor() {
  final r = _rand.nextInt(256);
  final g = _rand.nextInt(256);
  final b = _rand.nextInt(256);
  String toHex(int v) => v.toRadixString(16).padLeft(2, '0');
  return '#${toHex(r)}${toHex(g)}${toHex(b)}';
}

String _createToken(String userId) => 'token:$userId';
String? _validateToken(String token) => token.startsWith('token:') ? token.substring(6) : null;

String _getUserIdFromCall(ServiceCall call) {
  final auth = call.clientMetadata?['authorization'] ?? call.clientMetadata?['Authorization'];
  if (auth == null || auth.isEmpty) {
    throw GrpcError.unauthenticated('authorization header required');
  }
  final prefix = 'Bearer ';
  if (!auth.startsWith(prefix)) {
    throw GrpcError.unauthenticated('invalid authorization format');
  }
  final token = auth.substring(prefix.length);
  final userId = _validateToken(token);
  if (userId == null) {
    throw GrpcError.unauthenticated('invalid token');
  }
  return userId;
}

class ChatService extends ChatServiceBase {
  @override
  Future<RegisterResponse> register(ServiceCall call, RegisterRequest request) async {
    if (request.name.isEmpty) {
      throw GrpcError.invalidArgument('name is required');
    }

    final user = User(id: _generateId(), name: request.name, color: _generateColor());
    _storage.users[user.id] = user;

    final token = _createToken(user.id);
    return RegisterResponse(token: token, user: user);
  }

  @override
  Future<SendMessageResponse> sendMessage(ServiceCall call, SendMessageRequest request) async {
    final userId = _getUserIdFromCall(call);
    final user = _storage.users[userId];
    if (user == null) {
      throw GrpcError.notFound('user not found');
    }
    if (request.content.isEmpty) {
      throw GrpcError.invalidArgument('content is required');
    }

    final msg = Message(
      id: _generateId(),
      userId: user.id,
      userName: user.name,
      userColor: user.color,
      content: request.content,
      timestamp: Int64(DateTime.now().millisecondsSinceEpoch),
    );

    _storage.messages.add(msg);

    // Broadcast to watchers
    for (final sc in List<StreamController<WatchMessagesResponse>>.from(_storage.streams)) {
      if (!sc.isClosed) {
        sc.add(WatchMessagesResponse(message: msg));
      }
    }

    return SendMessageResponse(message: msg);
  }

  @override
  Stream<WatchMessagesResponse> watchMessages(ServiceCall call, WatchMessagesRequest request) {
    // Authenticate
    _getUserIdFromCall(call);

    // Create a stream for this watcher
    final controller = StreamController<WatchMessagesResponse>();
    _storage.streams.add(controller);

    // Send existing messages first
    for (final m in _storage.messages) {
      controller.add(WatchMessagesResponse(message: m));
    }

    // Remove on cancel/close
    controller.onCancel = () {
      _storage.streams.remove(controller);
      controller.close();
    };

    return controller.stream;
  }
}
