import '../models/message.dart';
import '../models/user.dart';
import 'connect_chat_service.dart';

abstract class ChatService {
  static ChatService? _instance;

  factory ChatService() {
    _instance ??= ConnectChatService(baseUrl: 'http://localhost:8080');

    return _instance!;
  }

  Future<void> register(String name);

  Future<void> sendMessage(String message);

  Stream<Message> watchMessages();

  void logout();

  User? get currentUser;
}
