import 'package:animated_emoji/animated_emoji.dart';
import 'package:flutter/material.dart';

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
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: isSelected ? 72 : 54,
        height: isSelected ? 72 : 54,
        child: AnimatedEmoji(emojiData, size: isSelected ? 72 : 54),
      ),
    );
  }
}
