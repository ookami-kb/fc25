import 'package:connectrpc/connect.dart';
import 'package:connectrpc/protobuf.dart';
import 'package:connectrpc/protocol/connect.dart' as protocol;
import 'package:connectrpc/web.dart' if (dart.library.io) 'package:connectrpc/http2.dart' as t;

import '../gen/proto/chat.connect.client.dart' as client;
import '../gen/proto/chat.pb.dart' as proto;
import '../models/message.dart';
import '../models/user.dart';
import 'chat_service.dart';

class ConnectChatService implements ChatService {
  ConnectChatService({required String baseUrl}) {
    final transport = protocol.Transport(
      baseUrl: baseUrl,
      codec: const ProtoCodec(),
      httpClient: t.createHttpClient(),
      interceptors: [_AuthInterceptor(() => _token ?? '').call],
      // statusParser: StatusParser(),
    );
    _client = client.ChatServiceClient(transport);
  }

  late final client.ChatServiceClient _client;
  String? _token;
  User? _currentUser;

  @override
  User? get currentUser => _currentUser;

  @override
  void logout() {
    _currentUser = null;
    _token = null;
  }

  @override
  Future<void> register(String name) async {
    final request = proto.RegisterRequest(name: name);

    final response = await _client.register(request);
    _token = response.token;
    _currentUser = User(id: response.user.id, name: response.user.name, color: response.user.color);
  }

  @override
  Future<void> sendMessage(String message) async {
    final request = proto.SendMessageRequest(content: message);
    await _client.sendMessage(request);
  }

  @override
  Stream<Message> watchMessages() async* {
    final request = proto.WatchMessagesRequest();
    await for (final response in _client.watchMessages(request)) {
      yield Message(
        text: response.message.content,
        userId: response.message.userId,
        userName: response.message.userName,
        userColor: response.message.userColor,
        createdAt: DateTime.fromMillisecondsSinceEpoch(response.message.timestamp.toInt()),
      );
    }
  }
}

class _AuthInterceptor {
  const _AuthInterceptor(this.getToken);

  final String Function() getToken;

  AnyFn<I, O> call<I extends Object, O extends Object>(AnyFn<I, O> next) => (req) {
        final token = getToken();
        if (token.isNotEmpty) {
          req.headers['authorization'] = 'Bearer $token';
        }
        return next(req);
      };
}
