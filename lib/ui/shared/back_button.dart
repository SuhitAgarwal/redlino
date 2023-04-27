import 'package:flutter/material.dart';

import 'icon_button.dart';

class CustomBackButton extends StatelessWidget {
  final Color backgroundColor;

  const CustomBackButton({
    Key? key,
    this.backgroundColor = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      onTap: () => Navigator.pop(context),
      icon: Icons.arrow_back,
      backgroundColor: backgroundColor,
    );
  }
}
