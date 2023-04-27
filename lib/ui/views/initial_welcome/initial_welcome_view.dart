import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../shared/big_button.dart';
import '../../shared/logo.dart';
import '../../theme/globals.dart';
import 'initial_welcome_viewmodel.dart';

class InitialWelcomeView extends StatelessWidget {
  const InitialWelcomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InitialWelcomeViewModel>.nonReactive(
      viewModelBuilder: () => InitialWelcomeViewModel(),
      fireOnModelReadyOnce: true,
      onModelReady: (model) => model.getDisplayName(),
      builder: (context, model, _) {
        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: DecoratedBox(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/welcome-initial.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                const AppLogo(),
                const Spacer(),
                Padding(
                  padding: symHPadding20,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Hi ${model.firstName}, ",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: "welcome to RedLino!"),
                      ],
                      style: const TextStyle(fontSize: 24, height: 1.3),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(flex: 4),
                Padding(
                  padding: symHPadding20,
                  child: BigButton(
                    text: "GET STARTED",
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    onPressed: model.goToTutorial,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
