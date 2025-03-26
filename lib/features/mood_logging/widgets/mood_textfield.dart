import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MoodTextField extends StatelessWidget {
  final String? labelText;
  final TextStyle? labelStyle;
  final Color? borderColor;
  final TextEditingController noteController;
  const MoodTextField({
    super.key,
    this.labelText,
    this.labelStyle,
    this.borderColor,
    required this.noteController,
  });
  @override
  Widget build(BuildContext context) {
    return TextField(
      minLines: 3,
      maxLines: 10,
      style: GoogleFonts.lexend(textStyle: const TextStyle(letterSpacing: .2)),
      controller: noteController,
      decoration: InputDecoration(
        labelText: labelText,
        floatingLabelStyle: labelStyle,
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          borderSide: BorderSide(color: borderColor ?? Colors.deepPurpleAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          borderSide: BorderSide(color: borderColor ?? Colors.deepPurpleAccent),
        ),
      ),
    );
  }
}
