import 'package:flutter/material.dart';

import '../../../models/message.dart';
import '../../../models/user.dart';

class MessageList extends StatelessWidget {
  const MessageList({
    super.key,
    required this.scrollController,
    required this.messages,
    this.currentUser,
  });

  final ScrollController scrollController;
  final List<Message> messages;
  final User? currentUser;

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dateTime.day}/${dateTime.month} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }

  Color _parseColor(String colorString) {
    try {
      final cleanColor = colorString.replaceAll('#', '');
      return Color(int.parse('FF$cleanColor', radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }

  Color _getTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isCurrentUser = message.userId == currentUser?.id;
        final backgroundColor = _parseColor(message.userColor);
        final textColor = _getTextColor(backgroundColor);

        final userNameStyle = TextStyle(
          fontWeight: FontWeight.bold,
          color: textColor,
          fontSize: 12,
        );
        final contentStyle = TextStyle(color: textColor, fontSize: 16);
        final createdAtStyle = TextStyle(color: textColor.withValues(alpha: 0.7), fontSize: 10);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isCurrentUser) Text(message.userName, style: userNameStyle),
                      if (!isCurrentUser) const SizedBox(height: 4),
                      Text(message.text, style: contentStyle),
                      const SizedBox(height: 4),
                      Text(_formatTime(message.createdAt), style: createdAtStyle),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
