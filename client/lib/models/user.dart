import 'package:flutter/foundation.dart';

@immutable
class User {
  final String id;
  final String name;
  final String color;

  const User({required this.id, required this.name, required this.color});
}
