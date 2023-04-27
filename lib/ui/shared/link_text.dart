import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../theme/globals.dart';

class LinkText extends StatelessWidget {
  final String normalText;
  final String linkText;
  final Color linkColor;
  final VoidCallback onPressed;
  final bool center;
  final bool bold;
  final double? fontSize;

  const LinkText({
    Key? key,
    required this.normalText,
    required this.linkText,
    required this.linkColor,
    required this.onPressed,
    this.center = true,
    this.bold = true,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: normalText,
        style: TextStyle(
          color: gray,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
        children: [
          TextSpan(
            text: linkText,
            style: TextStyle(
              color: linkColor,
              fontSize: fontSize,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()..onTap = onPressed,
          ),
          const TextSpan(text: ' '), // to fix TapGestureRecognizer
        ],
      ),
      textAlign: center ? TextAlign.center : TextAlign.start,
    );
  }
}
