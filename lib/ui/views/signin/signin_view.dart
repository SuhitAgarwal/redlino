import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:stacked/stacked.dart';

import '../../../utils/validation_msgs.dart';
import '../../shared/auth_button.dart';
import '../../shared/back_button.dart';
import '../../shared/big_button.dart';
import '../../theme/globals.dart';
import 'signin_viewmodel.dart';

class SignInView extends StatelessWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignInViewModel>.reactive(
      viewModelBuilder: () => SignInViewModel(),
      fireOnModelReadyOnce: true,
      onModelReady: (model) => model.initializeModel(),
      builder: (context, model, _) {
        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: ReactiveForm(
            formGroup: model.form,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                Stack(
                  children: [
                    SvgPicture.asset(
                      "assets/signin-signup.svg",
                      fit: BoxFit.cover,
                    ),
                    const Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Welcome Back!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 20,
                      top: 56,
                      child: CustomBackButton(),
                    ),
                    if (model.appleSignInAvailable)
                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: AuthButton(
                          onPressed: model.signInWithApple,
                          svgPath: 'assets/apple-logo.svg',
                          text: 'Sign in with Apple',
                          textColor: const Color(0xFF3F414E),
                          backgroundColor: Colors.white,
                          outlined: true,
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: symHPadding20,
                  child: AuthButton(
                    onPressed: model.signInWithGoogle,
                    svgPath: 'assets/google-logo.svg',
                    text: 'Sign in with Google',
                    textColor: const Color(0xFF3F414E),
                    backgroundColor: Colors.white,
                    outlined: true,
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'OR LOG IN WITH EMAIL',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: gray,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: symHPadding20,
                  child: ReactiveTextField(
                    formControlName: 'email',
                    style: blackTextStyle,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF2F3F7),
                      border: OutlineInputBorder(
                        borderRadius: borderRadiusMd,
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Email address',
                      hintStyle: GoogleFonts.sourceSansPro(
                        fontSize: 16,
                        color: gray,
                        letterSpacing: 0.5,
                      ),
                    ),
                    validationMessages: (_) => {
                      ValidationMessage.required:
                          FieldValidationMessages.emailRequired,
                      ValidationMessage.email:
                          FieldValidationMessages.emailInvalid,
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: symHPadding20,
                  child: ReactiveTextField(
                    formControlName: 'password',
                    obscureText: !model.passwordVisible,
                    style: blackTextStyle,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF2F3F7),
                      border: OutlineInputBorder(
                        borderRadius: borderRadiusMd,
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Password',
                      hintStyle: GoogleFonts.sourceSansPro(
                        fontSize: 16,
                        color: gray,
                        letterSpacing: 0.5,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () => model.togglePasswordVisibility(),
                        icon: model.passwordVisible
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                        splashRadius: 24,
                      ),
                    ),
                    validationMessages: (_) => {
                      ValidationMessage.minLength:
                          FieldValidationMessages.passwordMinLength,
                      ValidationMessage.required:
                          FieldValidationMessages.passwordRequired,
                    },
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: symHPadding20,
                  child: BigButton(
                    text: 'LOG IN',
                    loading: model.isBusy,
                    onPressed: model.signInWithEmail,
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        letterSpacing: 0.3,
                        color: darkGray,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: model.goToSignupView,
                    child: const Text.rich(
                      TextSpan(
                        text: "DON'T HAVE AN ACCOUNT? ",
                        style: TextStyle(
                          color: gray,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                        children: [
                          TextSpan(
                            text: 'SIGN UP',
                            style: TextStyle(color: lilacBlue),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
