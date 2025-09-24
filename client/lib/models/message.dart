import 'package:flutter/foundation.dart';

@immutable
class Message {
  final String text;
  final String userId;
  final String userName;
  final String userColor;
  final DateTime createdAt;

  const Message({
    required this.text,
    required this.userId,
    required this.userName,
    required this.userColor,
    required this.createdAt,
  });
}
