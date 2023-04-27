import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/globals.dart';

class AuthButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String svgPath;
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final bool outlined;

  const AuthButton({
    Key? key,
    required this.onPressed,
    required this.svgPath,
    required this.text,
    required this.textColor,
    required this.backgroundColor,
    this.outlined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Ink(
        decoration: BoxDecoration(
          border: outlined ? Border.all(color: const Color(0xFFEBEAEC)) : null,
          borderRadius: maxBorderRadius,
          color: backgroundColor,
        ),
        height: 60,
        child: InkWell(
          onTap: onPressed,
          borderRadius: maxBorderRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              runAlignment: WrapAlignment.center,
              children: [
                SvgPicture.asset(svgPath, height: 24, width: 24),
                const SizedBox(width: 32),
                Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
