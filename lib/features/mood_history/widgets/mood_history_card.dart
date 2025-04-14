import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/models/mood.dart';

class MoodHistoryCard extends StatelessWidget {
  const MoodHistoryCard({super.key, required this.mood});

  final Mood mood;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFE1EEBC),
      elevation: 3,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mood.mood,
              style: GoogleFonts.lexend(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${DateFormat.yMMMMd('en_US').format(mood.timestamp)}',
              style: GoogleFonts.lexend(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text('Note: ${mood.note}', style: GoogleFonts.lexend(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
