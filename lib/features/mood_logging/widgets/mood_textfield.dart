// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MoodTextField extends StatelessWidget {
  String? labelText;
  TextStyle? labelStyle;
  MoodTextField({
    super.key,
    this.labelText,
    this.labelStyle,
    required TextEditingController noteController,
  }) : _noteController = noteController;

  final TextEditingController _noteController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      minLines: 3,
      maxLines: 10,
      style: GoogleFonts.lexend(textStyle: const TextStyle(letterSpacing: .2)),
      controller: _noteController,
      decoration: InputDecoration(
        labelText: labelText,
        floatingLabelStyle: labelStyle,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
      ),
    );
  }
}
