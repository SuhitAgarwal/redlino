import 'package:flutter/material.dart';

import '../theme/globals.dart';

class BigButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool loading;

  const BigButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = red,
    this.textColor = Colors.white,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        fixedSize: const Size.fromHeight(60),
        shape: maxBorderRadiusShape,
        backgroundColor: backgroundColor ?? red,
      ),
      child: !loading
          ? Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                letterSpacing: 0.5,
              ),
            )
          : const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator.adaptive(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            ),
    );
  }
}
