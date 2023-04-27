import 'package:flutter/material.dart';

import '../../theme/globals.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Notifications', style: blackTextStyle),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFC5D0EC),
              Color(0xFFFFFFFF),
            ],
            stops: [0.70, 1.00],
          ),
        ),
        child: Center(
          child: Text(
            'Nothing new here!',
            textAlign: TextAlign.center,
            style: blackTextStyle,
          ),
        ),
      ),
    );
  }
}
