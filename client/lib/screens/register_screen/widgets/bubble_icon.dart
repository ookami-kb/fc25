import 'package:flutter/material.dart';

class BubbleIcon extends StatelessWidget {
  const BubbleIcon({super.key});

  @override
  Widget build(BuildContext context) => Icon(
        Icons.chat_bubble_outline,
        size: 80,
        color: Theme.of(context).colorScheme.primary,
      );
}
