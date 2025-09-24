//
//  Generated code. Do not modify.
//  source: proto/chat.proto
//

import "package:connectrpc/connect.dart" as connect;
import "chat.pb.dart" as protochat;

abstract final class ChatService {
  /// Fully-qualified name of the ChatService service.
  static const name = 'fluttercon25.chat.ChatService';

  static const register = connect.Spec(
    '/$name/Register',
    connect.StreamType.unary,
    protochat.RegisterRequest.new,
    protochat.RegisterResponse.new,
  );

  static const sendMessage = connect.Spec(
    '/$name/SendMessage',
    connect.StreamType.unary,
    protochat.SendMessageRequest.new,
    protochat.SendMessageResponse.new,
  );

  static const watchMessages = connect.Spec(
    '/$name/WatchMessages',
    connect.StreamType.server,
    protochat.WatchMessagesRequest.new,
    protochat.WatchMessagesResponse.new,
  );
}
