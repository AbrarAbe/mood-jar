// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/models/mood.dart';

import '../../widgets/mood_appbar.dart';
import '../widgets/mood_slider.dart';
import '../widgets/mood_textfield.dart';

class MoodLoggingScreen extends StatefulWidget {
  const MoodLoggingScreen({super.key});

  @override
  State<MoodLoggingScreen> createState() => _MoodLoggingScreenState();
}

class _MoodLoggingScreenState extends State<MoodLoggingScreen> {
  String _selectedMood = '';
  Color? _moodColor;
  Color _moodLabelColor = Color(0xFF90C67C);
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _saveMoodToHive(String moodName) async {
    final moodBox = Hive.box<Mood>('moods');
    final newMood = Mood(
      mood: moodName,
      timestamp: DateTime.now(),
      note: _noteController.text,
    );
    await moodBox.add(newMood);
    setState(() {
      _selectedMood = '';
      _moodColor;
      _noteController.clear();
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Mood Saved!",
            style: GoogleFonts.lexend(fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Your mood has been successfully saved to the jar.",
            style: GoogleFonts.lexend(),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Color(0xFF328E6E)),
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/mood_history');
              },
              child: Text(
                "OK",
                style: GoogleFonts.lexend(
                  color: Colors.white,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MoodAppbar(
        label: 'Mood Jar',
        actions: [
          IconButton(
            icon: Icon(Icons.history, size: 26),
            onPressed: () {
              Navigator.pushNamed(context, '/mood_history');
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFF328E6E),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'How are you feelings today?',
                  style: GoogleFonts.lexend(
                    textStyle: const TextStyle(
                      fontSize: 40,
                      letterSpacing: .5,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                MoodSlider(
                  color: _moodLabelColor,
                  options: ['Angry', 'Sad', 'Okay', 'Good', 'Great'],
                  onChange: (value) {
                    setState(() {
                      if (value == 0) {
                        _selectedMood = 'Angry';
                        _moodColor = Colors.redAccent;
                        _moodLabelColor = Colors.redAccent;
                      } else if (value == 1) {
                        _selectedMood = 'Sad';
                        _moodColor = Colors.orangeAccent.shade100;
                        _moodLabelColor = Colors.orangeAccent.shade100;
                      } else if (value == 2) {
                        _selectedMood = 'Okay';
                        _moodColor = Color(0xFF90C67C);
                        _moodLabelColor = Colors.white;
                      } else if (value == 3) {
                        _selectedMood = 'Good';
                        _moodColor = Colors.yellow.shade700;
                        _moodLabelColor = Colors.yellow.shade700;
                      } else if (value == 4) {
                        _selectedMood = 'Great';
                        _moodColor = Colors.greenAccent;
                        _moodLabelColor = Colors.greenAccent;
                      } else {
                        _selectedMood = '';
                      }
                    });
                  },
                ),
                const SizedBox(height: 40),
                Column(
                  children: [
                    MoodTextField(
                      noteController: _noteController,
                      labelText:
                          _selectedMood.isNotEmpty
                              ? "What made you feel $_selectedMood today?"
                              : "Select a mood to tell your story",
                      labelStyle: GoogleFonts.lexend(
                        textStyle: const TextStyle(
                          fontSize: 25,
                          letterSpacing: .5,
                        ),
                        color: _moodLabelColor,
                      ),
                      borderColor: _moodLabelColor,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      _selectedMood.isNotEmpty ? _moodColor : Colors.white,
                    ),
                    foregroundColor: WidgetStatePropertyAll(
                      _selectedMood.isNotEmpty
                          ? Colors.white
                          : Colors.grey.shade500,
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(
                          width: 2.0,
                          color:
                              _selectedMood.isNotEmpty
                                  ? Colors.white
                                  : Color(0xFFE1EEBC),
                        ),
                      ),
                    ),
                    padding: const WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 100, vertical: 25),
                    ),
                  ),
                  onPressed:
                      _selectedMood.isNotEmpty
                          ? () {
                            _saveMoodToHive(_selectedMood);
                          }
                          : null,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 10,
                    children: [
                      Text(
                        'Save Mood',
                        style: GoogleFonts.lexend(
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                      ),
                      Icon(Icons.save_alt, size: 22),
                    ],
                  ),
                ),
                const SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
