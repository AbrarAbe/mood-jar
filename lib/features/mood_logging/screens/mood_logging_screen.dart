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
    // print('Mood saved to Hive: $moodName, Note: ${_noteController.text}');

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
      appBar: AppBar(title: const Text('Log Your Mood')),
      body: Column(
        children: <Widget>[
          // Mood Input Section
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'How are you feeling today?',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        // color: Colors.blue,
                        fontSize: 50,
                        letterSpacing: .5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  MoodTextField(noteController: _noteController),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        _selectedMood.isNotEmpty
                            ? Colors.deepPurpleAccent
                            : Colors.grey,
                      ),
                      foregroundColor: WidgetStatePropertyAll(
                        _selectedMood.isNotEmpty
                            ? Colors.white
                            : Colors.blueGrey,
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: const BorderSide(
                            width: 2.0,
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                      ),
                      padding: WidgetStatePropertyAll(
                        const EdgeInsets.symmetric(
                          horizontal: 100,
                          vertical: 25,
                        ),
                      ),
                    ),
                    onPressed:
                        _selectedMood.isNotEmpty
                            ? () {
                              _saveMoodToHive(_selectedMood);
                            }
                            : null,
                    child: const Text('Save Mood'),
                  ),
                ],
              ),
            ),
          ),

          // Mood History Section
          Expanded(
            flex: 1,
            child: ValueListenableBuilder(
              valueListenable: Hive.box<Mood>('moods').listenable(),
              builder: (context, Box<Mood> box, _) {
                // Filter the moods based on selected dates
                List<Mood> filteredMoods =
                    box.values.toList(); // Start with all moods
                if (_startDate != null) {
                  filteredMoods =
                      filteredMoods
                          .where((mood) => mood.timestamp.isAfter(_startDate!))
                          .toList();
                }
                if (_endDate != null) {
                  // We add one day to include the entire end date.
                  DateTime endDateInclusive = _endDate!.add(
                    const Duration(days: 1),
                  );
                  filteredMoods =
                      filteredMoods
                          .where(
                            (mood) => mood.timestamp.isBefore(endDateInclusive),
                          )
                          .toList();
                }

                if (filteredMoods.isEmpty) {
                  return const Center(
                    child: Text('No moods logged for the selected dates.'),
                  );
                }

                return ListView.builder(
                  itemCount: filteredMoods.length, // Use filteredMoods
                  itemBuilder: (context, index) {
                    final mood = filteredMoods[index]; // Use filteredMoods
                    return ListTile(
                      title: Text(
                        '${mood.mood} - ${DateFormat.yMd().add_jms().format(mood.timestamp)}',
                      ), //Improved date display
                      subtitle: Text(mood.note ?? ''),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deleteMood(
                            box.keyAt(box.values.toList().indexOf(mood)),
                          ); //find box key from filtered mood list
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
