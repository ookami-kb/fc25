import 'dart:async';

import '../models/message.dart';
import '../models/user.dart';
import 'chat_service.dart';

class StubChatService implements ChatService {
  final _controller = StreamController<Message>.broadcast();

  User? _currentUser;

  @override
  Future<void> register(String name) async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = User(id: 'stub-id', name: name, color: '#0000FF');
  }

  @override
  Future<void> sendMessage(String message) async {
    final newMessage = Message(
      text: message,
      userId: 'stub-id',
      userName: 'stub-name',
      userColor: '#0000FF',
      createdAt: DateTime.now(),
    );
    await Future.delayed(const Duration(milliseconds: 300));
    _controller.add(newMessage);
  }

  @override
  Stream<Message> watchMessages() {
    final botMessage = Message(
      text: 'Hello!',
      userId: 'bot',
      userName: 'Bot',
      userColor: '#00FF00',
      createdAt: DateTime.now(),
    );
    Future.delayed(const Duration(seconds: 1), () => _controller.add(botMessage));

    return _controller.stream;
  }

  @override
  void logout() {
    _currentUser = null;
  }

  @override
  User? get currentUser => _currentUser;
}
