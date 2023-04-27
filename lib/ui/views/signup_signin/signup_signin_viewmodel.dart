import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';

class SignupSigninViewModel extends BaseViewModel {
  final _nav = sl<NavigationService>();

  void goToSignIn() {
    _nav.navigateTo(Routes.signInView);
  }

  void goToSignUp() {
    _nav.navigateTo(Routes.signUpView);
  }
}
