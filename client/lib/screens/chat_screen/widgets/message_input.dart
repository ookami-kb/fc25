import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  const MessageInput({
    super.key,
    required this.isSending,
    required this.messageController,
    required this.onSendPressed,
  });

  final bool isSending;
  final TextEditingController messageController;
  final VoidCallback onSendPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: messageController,
            decoration: InputDecoration(
              hintText: 'Type a message...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            maxLines: null,
            textInputAction: TextInputAction.send,
            onSubmitted: (_) => onSendPressed(),
            enabled: !isSending,
          ),
        ),
        const SizedBox(width: 8),
        FloatingActionButton(
          onPressed: isSending ? null : onSendPressed,
          mini: true,
          child: isSending
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.send),
        ),
      ],
    );
  }
}
