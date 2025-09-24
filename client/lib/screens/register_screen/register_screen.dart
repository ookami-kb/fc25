import 'package:flutter/material.dart';
import 'package:fluttercon25_client/error_handler.dart';
import 'package:fluttercon25_client/services/chat_service.dart';

import '../../routing.dart';
import 'widgets/bubble_icon.dart';
import 'widgets/name_field.dart';
import 'widgets/name_label.dart';
import 'widgets/submit_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _chatService = ChatService();

  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _chatService.register(_nameController.text.trim());

      if (mounted) {
        Routing.navigateToChatScreen(context);
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.displayError(context, 'Failed to register: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to Chat'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const BubbleIcon(),
                    const SizedBox(height: 32),
                    const NameLabel(),
                    const SizedBox(height: 32),
                    NameField(
                      isLoading: _isLoading,
                      onSubmit: _register,
                      controller: _nameController,
                    ),
                    const SizedBox(height: 24),
                    SubmitButton(onPressed: _register, isLoading: _isLoading),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
