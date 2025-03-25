// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:animated_emoji/animated_emoji.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/mood_button.dart';
import '../../../core/models/mood.dart';

import '../widgets/mood_textfield.dart';

class MoodLoggingScreen extends StatefulWidget {
  const MoodLoggingScreen({super.key});

  @override
  State<MoodLoggingScreen> createState() => _MoodLoggingScreenState();
}

class _MoodLoggingScreenState extends State<MoodLoggingScreen> {
  String _selectedMood = '';
  final TextEditingController _noteController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

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
      _noteController.clear();
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Mood saved!')));
  }

  void _deleteMood(int index) async {
    final moodBox = Hive.box<Mood>('moods');
    await moodBox.deleteAt(index);
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
                  'How are you feeling today?',
                  style: GoogleFonts.lexend(
                    textStyle: const TextStyle(fontSize: 40, letterSpacing: .5),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  height: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MoodButton(
                        moodName: 'Happy',
                        emojiData: AnimatedEmojis.smile,
                        isSelected: _selectedMood == 'Happy',
                        onPressed: () {
                          setState(() {
                            _selectedMood = 'Happy';
                          });
                        },
                      ),
                      MoodButton(
                        moodName: 'Neutral',
                        emojiData: AnimatedEmojis.neutralFace,
                        isSelected: _selectedMood == 'Neutral',
                        onPressed: () {
                          setState(() {
                            _selectedMood = 'Neutral';
                          });
                        },
                      ),
                      MoodButton(
                        moodName: 'Sad',
                        emojiData: AnimatedEmojis.sad,
                        isSelected: _selectedMood == 'Sad',
                        onPressed: () {
                          setState(() {
                            _selectedMood = 'Sad';
                          });
                        },
                      ),
                    ],
                  ),
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
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      _selectedMood.isNotEmpty
                          ? Colors.deepPurpleAccent
                          : Colors.grey,
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
                // GestureDetector(
                //   onTap: () => FocusScope.of(context).unfocus(),
                //   child: ValueListenableBuilder(
                //     valueListenable: Hive.box<Mood>('moods').listenable(),
                //     builder: (context, Box<Mood> box, _) {
                //       List<Mood> filteredMoods = box.values.toList();
                //       if (_startDate != null) {
                //         filteredMoods =
                //             filteredMoods
                //                 .where(
                //                   (mood) => mood.timestamp.isAfter(_startDate!),
                //                 )
                //                 .toList();
                //       }
                //       if (_endDate != null) {
                //         DateTime endDateInclusive = _endDate!.add(
                //           const Duration(days: 1),
                //         );
                //         filteredMoods =
                //             filteredMoods
                //                 .where(
                //                   (mood) =>
                //                       mood.timestamp.isBefore(endDateInclusive),
                //                 )
                //                 .toList();
                //       }

                //       if (filteredMoods.isEmpty) {
                //         return const Center(
                //           child: Text('No moods logged for the selected dates.'),
                //         );
                //       }

                //       return ListView.builder(
                //         itemCount: filteredMoods.length,
                //         itemBuilder: (context, index) {
                //           final mood = filteredMoods[index];
                //           return ListTile(
                //             title: Text(
                //               '${mood.mood} - ${DateFormat.yMd().add_jms().format(mood.timestamp)}',
                //             ),
                //             subtitle: Text(mood.note ?? ''),
                //             trailing: IconButton(
                //               icon: const Icon(Icons.delete),
                //               onPressed: () {
                //                 _deleteMood(
                //                   box.keyAt(box.values.toList().indexOf(mood)),
                //                 );
                //               },
                //             ),
                //           );
                //         },
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
