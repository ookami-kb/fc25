import 'package:flutter/material.dart';

import 'screens/chat_screen/chat_screen.dart';
import 'screens/register_screen/register_screen.dart';

abstract class Routing {
  static void navigateToRegisterScreen(BuildContext context) =>
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => RegisterScreen()),
      );

  static void navigateToChatScreen(BuildContext context) => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ChatScreen()),
      );
}
