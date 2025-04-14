import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MoodAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final String label;
  final List<Widget>? actions;
  const MoodAppbar({
    super.key,
    required this.label,
    this.actions,
    this.leading,
  });
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      backgroundColor: Color(0xFF328E6E),
      title: Text(label, style: GoogleFonts.lexend(color: Colors.white)),
      iconTheme: const IconThemeData(
        color: Colors.white, // Set the leading icon color to white
      ),
      actions: actions,
    );
  }
}
