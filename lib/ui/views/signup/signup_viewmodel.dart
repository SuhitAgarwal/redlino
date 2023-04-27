import 'dart:io';

import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../models/failure.dart';
import '../../../services/auth_service.dart';
import '../../../services/user_data_service.dart';
import '../../shared/snackbar_service.dart';
import '../../theme/globals.dart';

class SignupViewModel extends BaseViewModel {
  final _navSv = sl<NavigationService>();
  final _snackSv = sl<SnackbarService>();
  final _authSv = sl<AuthService>();
  final _dataSv = sl<UserDataService>();

  final form = FormGroup({
    'name': FormControl<String>(validators: [Validators.required]),
    'email': FormControl<String>(
      validators: [Validators.required, Validators.email],
    ),
    'password': FormControl<String>(
      validators: [Validators.required, Validators.minLength(8)],
    ),
    'agreeToPrivacyPolicy': FormControl<bool>(
      validators: [Validators.requiredTrue],
    ),
  });

  bool appleSignInAvailable = false;

  FormControl<String> get name => form.control('name') as FormControl<String>;
  FormControl<String> get email => form.control('email') as FormControl<String>;
  FormControl<String> get password =>
      form.control('password') as FormControl<String>;
  FormControl<bool> get agreeToPrivacyPolicy =>
      form.control('agreeToPrivacyPolicy') as FormControl<bool>;

  void initializeModel() async {
    final appleAvailable = await _authSv.isAppleSignInAvailable;
    appleSignInAvailable = appleAvailable && Platform.isIOS;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    try {
      await _authSv.loginUserGoogle();
      if (_dataSv.user != null) {
        if (_dataSv.user!.seenWelcome) {
          _navSv.clearStackAndShow(Routes.navbarView);
        } else {
          final cUser = _dataSv.user!.copyWith(seenWelcome: true);
          await runBusyFuture(_dataSv.updateUserData(cUser));
          _navSv.clearStackAndShow(Routes.initialWelcomeView);
        }
      }
    } on Failure catch (e) {
      _snackSv.showCustomSnackBar(
        message: e.message,
        variant: SnackbarType.error,
        duration: kSnackbarDuration,
      );
    }
  }

  Future<void> signInWithApple() async {
    try {
      await runBusyFuture(_authSv.loginUserApple(), throwException: true);
      if (_dataSv.user != null) {
        if (_dataSv.user!.seenWelcome) {
          final isCelebrity = await _authSv.isCelebrity;
          _navSv.clearStackAndShow(
            Routes.navbarView,
            arguments: NavbarViewArguments(isCelebrity: isCelebrity),
          );
        } else {
          final cUser = _dataSv.user!.copyWith(seenWelcome: true);
          await runBusyFuture(_dataSv.updateUserData(cUser));
          _navSv.clearStackAndShow(Routes.initialWelcomeView);
        }
      }
    } on Failure catch (e) {
      _snackSv.showCustomSnackBar(
        message: e.message,
        variant: SnackbarType.error,
        duration: kSnackbarDuration,
      );
    } on PlatformException catch (e) {
      _snackSv.showCustomSnackBar(
        message: e.message ?? "An unknown error has occured",
        variant: SnackbarType.error,
        duration: kSnackbarDuration,
      );
    } on Exception {
      _snackSv.showCustomSnackBar(
        message: "An unknown error has occured",
        variant: SnackbarType.error,
        duration: kSnackbarDuration,
      );
    }
  }

  void goToPrivacyPolicy() {
    _navSv.navigateTo(Routes.privacyPolicyView);
  }

  Future<void> submit() async {
    if (!form.valid) {
      _snackSv.showCustomSnackBar(
        message: 'Signup form is invalid!',
        variant: SnackbarType.error,
        duration: kSnackbarDuration,
      );
      return;
    }
    try {
      await runBusyFuture(
        _authSv.registerUserEP(
          name: name.value!,
          email: email.value!,
          password: password.value!,
        ),
        throwException: true,
      );
      _navSv.clearStackAndShow(Routes.sentEmailVerificationView);
    } on Failure catch (e) {
      _snackSv.showCustomSnackBar(
        message: e.message,
        variant: SnackbarType.error,
        duration: kSnackbarDuration,
      );
    } on PlatformException catch (e) {
      _snackSv.showCustomSnackBar(
        message: e.message ?? "Unknown error",
        variant: SnackbarType.error,
        duration: kSnackbarDuration,
      );
    }
  }
}
