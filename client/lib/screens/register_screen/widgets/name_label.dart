import 'package:flutter/material.dart';

class NameLabel extends StatelessWidget {
  const NameLabel({super.key});

  @override
  Widget build(BuildContext context) => Text(
        'Enter your name to join the chat',
        style: Theme.of(context).textTheme.headlineSmall,
        textAlign: TextAlign.center,
      );
}
