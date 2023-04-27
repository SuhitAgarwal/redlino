import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppLogo extends StatelessWidget {
  final bool centered;
  final bool small;

  const AppLogo({
    Key? key,
    this.centered = true,
    this.small = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: GoogleFonts.bungee(fontSize: !small ? 50 : 24),
        children: [
          TextSpan(
            text: !small ? 'RED' : 'R',
            style: const TextStyle(color: Color(0xFFF90E19)),
          ),
          TextSpan(
            text: !small ? 'LINO' : 'L',
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
      textAlign: centered ? TextAlign.center : TextAlign.left,
      maxLines: 1,
    );
  }
}
