import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/models/mood.dart';
import 'features/mood_logging/screens/mood_logging_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MoodAdapter());
  await Hive.openBox<Mood>('moods');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Jar',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: const MoodLoggingScreen(), // Set MoodLoggingScreen as home!
    );
  }
}
