import 'package:flutter/material.dart';

import '../theme/globals.dart';

class CustomIconButton extends StatelessWidget {
  final Color backgroundColor;
  final VoidCallback? onTap;
  final IconData icon;
  final Color iconColor;

  const CustomIconButton({
    Key? key,
    required this.onTap,
    required this.icon,
    this.backgroundColor = Colors.transparent,
    this.iconColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: maxBorderRadius,
        side: backgroundColor == Colors.transparent
            ? const BorderSide(color: Color(0xFFEBEAEC))
            : const BorderSide(color: Colors.transparent),
      ),
      color: backgroundColor,
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: iconColor),
        splashRadius: 24,
      ),
    );
  }
}
