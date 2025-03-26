// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/models/mood.dart';

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

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Mood saved!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mood Jar', style: GoogleFonts.lexend())),
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
                    textStyle: const TextStyle(fontSize: 40, letterSpacing: .5),
                  ),
                ),
                const SizedBox(height: 40),
                MoodSlider(
                  options: ['Angry', 'Sad', 'Okay', 'Good', 'Great'],
                  onChange: (value) {
                    setState(() {
                      if (value == 0) {
                        _selectedMood = 'Angry';
                        _moodColor = Colors.red;
                      } else if (value == 1) {
                        _selectedMood = 'Sad';
                        _moodColor = Colors.orangeAccent.shade200;
                      } else if (value == 2) {
                        _selectedMood = 'Okay';
                        _moodColor = Colors.deepPurpleAccent;
                      } else if (value == 3) {
                        _selectedMood = 'Good';
                        _moodColor = Colors.deepPurpleAccent;
                      } else if (value == 4) {
                        _selectedMood = 'Great';
                        _moodColor = Colors.deepPurpleAccent;
                      } else {
                        _selectedMood = '';
                      }
                    });
                  },
                ),
                const SizedBox(height: 40),
                MoodTextField(
                  noteController: _noteController,
                  labelText:
                      _selectedMood.isNotEmpty
                          ? "What made you feel $_selectedMood today?"
                          : "Select a mood to tell your story",
                  labelStyle: GoogleFonts.lexend(
                    textStyle: const TextStyle(fontSize: 25, letterSpacing: .5),
                    color: _moodColor,
                  ),
                  borderColor: _moodColor,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      _selectedMood.isNotEmpty ? _moodColor : Colors.grey,
                    ),
                    foregroundColor: WidgetStatePropertyAll(
                      _selectedMood.isNotEmpty ? Colors.white : Colors.white,
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(
                          width: 2.0,
                          color:
                              _selectedMood.isNotEmpty
                                  ? Colors.lightBlueAccent
                                  : Colors.grey,
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
                  child: Text(
                    'Save Mood',
                    style: GoogleFonts.lexend(
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
