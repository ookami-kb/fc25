//
//  Generated code. Do not modify.
//  source: proto/chat.proto
//

import "package:connectrpc/connect.dart" as connect;
import "chat.pb.dart" as protochat;
import "chat.connect.spec.dart" as specs;

extension type ChatServiceClient (connect.Transport _transport) {
  Future<protochat.RegisterResponse> register(
    protochat.RegisterRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ChatService.register,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<protochat.SendMessageResponse> sendMessage(
    protochat.SendMessageRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.ChatService.sendMessage,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Stream<protochat.WatchMessagesResponse> watchMessages(
    protochat.WatchMessagesRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.ChatService.watchMessages,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
