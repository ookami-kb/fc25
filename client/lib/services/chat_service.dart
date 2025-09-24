import 'package:fluttercon25_client/services/stub_chat_service.dart';

import '../models/message.dart';
import '../models/user.dart';

abstract class ChatService {
  static ChatService? _instance;

  factory ChatService() {
    _instance ??= StubChatService();

    return _instance!;
  }

  Future<void> register(String name);

  Future<void> sendMessage(String message);

  Stream<Message> watchMessages();

  void logout();

  User? get currentUser;
}
