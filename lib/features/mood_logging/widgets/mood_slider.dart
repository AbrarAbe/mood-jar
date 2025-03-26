import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reviews_slider/reviews_slider.dart';

class MoodSlider extends StatelessWidget {
  final List<String> options;
  final void Function(int) onChange;

  const MoodSlider({super.key, required this.options, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return ReviewSlider(
      options: options,
      optionStyle: GoogleFonts.lexend(letterSpacing: 1),
      onChange: onChange,
    );
  }
}
