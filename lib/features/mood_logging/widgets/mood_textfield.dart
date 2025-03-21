import 'package:flutter/material.dart';

class MoodTextField extends StatelessWidget {
  const MoodTextField({
    super.key,
    required TextEditingController noteController,
  }) : _noteController = noteController;

  final TextEditingController _noteController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _noteController,
      decoration: const InputDecoration(
        labelText: 'Add a note (optional)',
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
    );
  }
}
