import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/models/mood.dart';
import '../widgets/mood_history_card.dart';

class MoodHistoryScreen extends StatelessWidget {
  const MoodHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the leading icon color to white
        ),
        title: Text(
          'Mood History',
          style: GoogleFonts.lexend(color: Colors.white),
        ),
        backgroundColor: Color(0xFF328E6E),
      ),
      backgroundColor: Color(0xFF328E6E),
      body: Column(
        spacing: 15,
        children: [
          const SizedBox(height: 30),
          Text(
            "Your Mood History",
            style: GoogleFonts.lexend(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Your journey through emotions ✨',
            style: GoogleFonts.lexend(
              fontSize: 18,
              color: Color.fromARGB(255, 217, 229, 213),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box<Mood>('moods').listenable(),
              builder: (context, Box<Mood> box, _) {
                if (box.isEmpty) {
                  return Center(
                    child: Text(
                      'No moods added yet!',
                      style: GoogleFonts.lexend(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  );
                } else {
                  List<Mood> moods = box.values.toList();
                  moods.sort((b, a) => a.timestamp.compareTo(b.timestamp));
                  return ListView.builder(
                    itemCount: moods.length,
                    itemBuilder: (context, index) {
                      final mood = moods[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: MoodHistoryCard(mood: mood),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
