import 'package:flutter/material.dart';

class NameField extends StatelessWidget {
  const NameField({
    super.key,
    required this.isLoading,
    required this.onSubmit,
    required this.controller,
  });

  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Your Name',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.person),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter your name';
          }
          if (value.trim().length < 2) {
            return 'Name must be at least 2 characters';
          }
          return null;
        },
        onFieldSubmitted: (_) => onSubmit(),
        enabled: !isLoading,
      );
}
