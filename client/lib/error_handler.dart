import 'package:flutter/material.dart';

abstract class ErrorHandler {
  static void displayError(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error), backgroundColor: Colors.red),
    );
  }
}
