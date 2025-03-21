// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/models/mood.dart';
import 'package:intl/intl.dart';

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

  Widget _moodButton(String moodName, String emoji) {
    final isSelected = _selectedMood == moodName;

    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedMood = moodName;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue[100] : null,
      ),
      child: Text('$emoji $moodName'),
    );
  }

  void _saveMoodToHive(String moodName) async {
    final moodBox = Hive.box<Mood>('moods');
    final newMood = Mood(
      mood: moodName,
      timestamp: DateTime.now(),
      note: _noteController.text,
    );
    await moodBox.add(newMood);
    print('Mood saved to Hive: $moodName, Note: ${_noteController.text}');

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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'How are you feeling today?',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _moodButton('Happy', '😊'),
                    _moodButton('Neutral', '😐'),
                    _moodButton('Sad', '😞'),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _noteController,
                  decoration: const InputDecoration(
                    labelText: 'Add a note (optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
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

          // Mood History Section
          Expanded(
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
