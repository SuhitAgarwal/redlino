import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:stacked/stacked.dart';

import '../../../utils/validation_msgs.dart';
import '../../shared/auth_button.dart';
import '../../shared/back_button.dart';
import '../../shared/big_button.dart';
import '../../shared/link_text.dart';
import '../../theme/globals.dart';
import 'signup_viewmodel.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignupViewModel>.reactive(
      viewModelBuilder: () => SignupViewModel(),
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
              padding: const EdgeInsets.only(bottom: 30),
              children: [
                Stack(
                  children: [
                    SvgPicture.asset(
                      "assets/signin-signup.svg",
                      fit: BoxFit.cover,
                      allowDrawingOutsideViewBox: true,
                    ),
                    // Image.asset(
                    //   'assets/signin-signup.png',
                    //   excludeFromSemantics: true,
                    // ),
                    const Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Create your account',
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
                          text: 'Sign up with Apple',
                          textColor: const Color(0xFF3F414E),
                          backgroundColor: Colors.white,
                          outlined: true,
                        ),
                      ),
                    // Positioned(
                    //   bottom: 20,
                    //   left: 20,
                    //   right: 20,
                    //   child: AuthButton(
                    //     onPressed: () {},
                    //     svgPath: 'assets/facebook-logo.svg',
                    //     text: 'CONTINUE WITH FACEBOOK',
                    //     textColor: const Color(0xFFF6F1FB),
                    //     backgroundColor: const Color(0xFF6A83FF),
                    //   ),
                    // ),
                  ],
                ),
                Padding(
                  padding: symHPadding20,
                  child: AuthButton(
                    onPressed: model.signInWithGoogle,
                    svgPath: 'assets/google-logo.svg',
                    text: 'Sign up with Google',
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
                    formControlName: 'name',
                    style: blackTextStyle,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF2F3F7),
                      border: OutlineInputBorder(
                        borderRadius: borderRadiusMd,
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Name',
                      hintStyle: GoogleFonts.sourceSansPro(
                        fontSize: 16,
                        color: gray,
                        letterSpacing: 0.5,
                      ),
                    ),
                    validationMessages: (_) => {
                      ValidationMessage.required:
                          FieldValidationMessages.nameRequired,
                    },
                  ),
                ),
                const SizedBox(height: 20),
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
                    style: blackTextStyle,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF2F3F7),
                      border: OutlineInputBorder(
                        borderRadius: borderRadiusMd,
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Password',
                      suffixIcon: const Icon(Icons.visibility),
                      hintStyle: GoogleFonts.sourceSansPro(
                        fontSize: 16,
                        color: gray,
                        letterSpacing: 0.5,
                      ),
                    ),
                    validationMessages: (_) => {
                      ValidationMessage.required:
                          FieldValidationMessages.passwordRequired,
                      ValidationMessage.minLength:
                          FieldValidationMessages.passwordMinLength,
                    },
                  ),
                ),
                Padding(
                  padding: symHPadding20,
                  child: ReactiveCheckboxListTile(
                    controlAffinity: ListTileControlAffinity.trailing,
                    formControlName: 'agreeToPrivacyPolicy',
                    contentPadding: EdgeInsets.zero,
                    title: LinkText(
                      normalText: 'I have read the ',
                      linkText: 'Privacy Policy',
                      linkColor: lilacBlue,
                      fontSize: 14,
                      center: false,
                      bold: false,
                      onPressed: model.goToPrivacyPolicy,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: symHPadding20,
                  child: BigButton(
                    text: 'GET STARTED',
                    loading: model.isBusy,
                    onPressed: model.submit,
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
