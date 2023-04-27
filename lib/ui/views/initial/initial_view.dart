import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'initial_viewmodel.dart';

class InitialView extends StatelessWidget {
  const InitialView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InitialViewModel>.nonReactive(
      viewModelBuilder: () => InitialViewModel(),
      onModelReady: (model) => model.checkAuthStatus(),
      builder: (context, model, _) {
        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: Image.asset(
            'assets/splash-background.png',
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
