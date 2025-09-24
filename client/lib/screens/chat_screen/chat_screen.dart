import 'dart:async';

import 'package:flutter/material.dart';

import '../../services/chat_service.dart';
import '../../error_handler.dart';
import '../../models/message.dart';
import '../../routing.dart';
import 'widgets/decorated_area.dart';
import 'widgets/logout_button.dart';
import 'widgets/message_input.dart';
import 'widgets/message_list.dart';
import 'widgets/no_messages.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatService _chatService = ChatService();

  final List<Message> _messages = [];
  StreamSubscription<Message>? _messageSubscription;
  bool _isLoading = true;
  bool _isSending = false;

  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messageSubscription?.cancel();
    super.dispose();
  }

  void _startListening() {
    try {
      _messageSubscription = _chatService.watchMessages().listen(
        (message) {
          setState(() {
            _messages.add(message);
            _isLoading = false;
          });
          _scrollToBottom();
        },
        onError: (error) {
          if (mounted) {
            ErrorHandler.displayError(context, 'Connection error: $error');
            setState(() => _isLoading = false);
          }
        },
        onDone: () => setState(() => _isLoading = false),
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ErrorHandler.displayError(context, 'Failed to connect: $e');
      }
    }
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty || _isSending) return;

    setState(() => _isSending = true);

    try {
      await _chatService.sendMessage(content);
      _messageController.clear();
    } catch (e) {
      if (mounted) {
        ErrorHandler.displayError(context, 'Failed to send message: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  void _logout() {
    _chatService.logout();
    Routing.navigateToRegisterScreen(context);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _chatService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat - ${currentUser?.name ?? 'Unknown'}'),
        actions: [LogoutButton(onPressed: _logout)],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading && _messages.isNotEmpty
                ? const Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                    ? const NoMessages()
                    : MessageList(
                        scrollController: _scrollController,
                        currentUser: currentUser,
                        messages: _messages,
                      ),
          ),
          DecoratedArea(
            child: MessageInput(
              isSending: _isSending,
              messageController: _messageController,
              onSendPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
