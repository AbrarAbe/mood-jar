import 'package:animated_emoji/animated_emoji.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MoodButton extends StatelessWidget {
  final String moodName;
  final AnimatedEmojiData emojiData;
  final bool isSelected;
  final VoidCallback onPressed;

  const MoodButton({
    super.key,
    required this.moodName,
    required this.emojiData,
    this.isSelected = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        InkWell(
          enableFeedback: true,
          onTap: onPressed,
          borderRadius: BorderRadius.circular(50),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isSelected ? 72 : 54,
            height: isSelected ? 70 : 52,
            child: AnimatedEmoji(emojiData, size: isSelected ? 82 : 64),
          ),
        ),
        Text(
          moodName,
          style: GoogleFonts.lexend(
            textStyle: TextStyle(
              fontSize: isSelected ? 22 : 16,
              // letterSpacing: .5,
            ),
          ),
        ),
      ],
    );
  }
}
