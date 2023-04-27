import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import '../../shared/back_button.dart';
import '../../shared/big_button.dart';
import '../../theme/globals.dart';
import 'tutorial_viewmodel.dart';

class TutorialView extends StatelessWidget {
  const TutorialView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: ViewModelBuilder<TutorialViewModel>.nonReactive(
        viewModelBuilder: () => TutorialViewModel(),
        builder: (context, model, _) {
          return DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFC5D0EC),
                  Color(0xFFFFFFFF),
                ],
                stops: [0.75, 1.00],
              ),
            ),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/tutorial-background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: CustomBackButton(),
                    ),
                    const Spacer(),
                    Text(
                      'An Authentic Red Carpet In Your Hands',
                      style: GoogleFonts.rubik(
                        fontWeight: FontWeight.w900,
                        fontSize: 30,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(flex: 2),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset('assets/phone.png'),
                          SizedBox(
                            width: width * 0.6,
                            child: const Text(
                              'Talk to strangers, fans, and friends in '
                              'celebrity waiting rooms. Earn Star Coins and '
                              'Meet People Throughout Your Day.',
                              style: blackTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset('assets/star.png'),
                          SizedBox(
                            width: width * 0.6,
                            child: const Text(
                              'Catch your favorite influencers online and send '
                              'them star coins. These will support them and will '
                              'increase your chances to win a private call.',
                              style: blackTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset('assets/gift.png'),
                          SizedBox(
                            width: width * 0.6,
                            child: const Text(
                              'The wait over, winner is randomly selected from '
                              'lottery pool. You will have access to a private '
                              'meet and greet experience with your favorite '
                              'celebrity.',
                              style: blackTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),
                    BigButton(
                      text: 'GET STARTED',
                      onPressed: model.goToHome,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
