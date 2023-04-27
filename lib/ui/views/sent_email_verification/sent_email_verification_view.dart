import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../shared/back_button.dart';
import '../../shared/big_button.dart';
import '../../theme/globals.dart';
import 'sent_email_verification_viewmodel.dart';

class SentEmailVerificationView extends StatelessWidget {
  const SentEmailVerificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SentEmailVerificationViewModel>.nonReactive(
      viewModelBuilder: () => SentEmailVerificationViewModel(),
      builder: (context, model, _) {
        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/email-sent.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Spacer(),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: CustomBackButton(),
                  ),
                  const Spacer(),
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      "We've sent you an email",
                      style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Please check your inbox to confirm your account. "
                      "Be sure to check your spam folder.",
                      style: TextStyle(
                        fontSize: 20,
                        height: 1.1,
                        color: gray,
                      ),
                    ),
                  ),
                  const Spacer(flex: 4),
                  BigButton(
                    text: 'GET STARTED',
                    onPressed: model.goToWelcome,
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
