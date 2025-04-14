import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewMoodsButton extends StatelessWidget {
  const ViewMoodsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        ),
        backgroundColor: WidgetStatePropertyAll(Colors.deepOrangeAccent),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/mood_history');
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          Text(
            'View Moods',
            style: GoogleFonts.lexend(
              textStyle: TextStyle(
                letterSpacing: .2,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          const Icon(Icons.history, size: 20, color: Colors.white),
        ],
      ),
    );
  }
}
