import 'package:hive/hive.dart';

part 'mood.g.dart';

@HiveType(typeId: 0)
class Mood extends HiveObject {
  @HiveField(0)
  final String mood;

  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2) // Add a new HiveField for the note
  final String? note; // Make it optional (nullable)

  Mood({
    required this.mood,
    required this.timestamp,
    this.note,
  }); // Include note in constructor
}
