import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import '../../shared/big_button.dart';
import '../../shared/logo.dart';
import '../../theme/globals.dart';
import 'signup_signin_viewmodel.dart';

class SignupSigninView extends StatelessWidget {
  const SignupSigninView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignupSigninViewModel>.nonReactive(
      viewModelBuilder: () => SignupSigninViewModel(),
      builder: (context, model, _) {
        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: SafeArea(
            left: false,
            right: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                const AppLogo(),
                const Spacer(flex: 3),
                Image.asset('assets/pre-auth.png'),
                const Spacer(flex: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'Thousands of people use RedLino '
                    'to meet their dream celebrities',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.sourceSansPro(
                      color: gray,
                      fontSize: 20,
                      height: 1.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(flex: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: BigButton(
                    text: 'SIGN UP',
                    onPressed: model.goToSignUp,
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: model.goToSignIn,
                    child: const Text.rich(
                      TextSpan(
                        text: 'ALREADY HAVE AN ACCOUNT? ',
                        style: TextStyle(
                          color: gray,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                        children: [
                          TextSpan(
                            text: 'LOG IN',
                            style: TextStyle(color: red),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        );
      },
    );
  }
}
