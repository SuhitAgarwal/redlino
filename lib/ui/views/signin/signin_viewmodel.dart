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

class SignInViewModel extends BaseViewModel {
  final _authSv = sl<AuthService>();
  final _snackSv = sl<SnackbarService>();
  final _navSv = sl<NavigationService>();
  final _dataSv = sl<UserDataService>();

  final form = FormGroup({
    'email': FormControl<String>(
        validators: [Validators.required, Validators.email]),
    'password': FormControl<String>(validators: [
      Validators.required,
      Validators.minLength(8),
    ]),
  });

  bool passwordVisible = false;
  bool appleSignInAvailable = false;

  FormControl<String> get email => form.control('email') as FormControl<String>;
  FormControl<String> get password =>
      form.control('password') as FormControl<String>;

  void initializeModel() async {
    final appleAvailable = await _authSv.isAppleSignInAvailable;
    appleSignInAvailable = appleAvailable && Platform.isIOS;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  void goToSignupView() {
    _navSv.replaceWith(Routes.signUpView);
  }

  Future<void> signInWithGoogle() async {
    try {
      await runBusyFuture(_authSv.loginUserGoogle(), throwException: true);
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

  Future<void> signInWithFacebook() async {}

  Future<void> signInWithEmail() async {
    if (!form.valid) {
      await _snackSv.showCustomSnackBar(
        message: 'Signin form is invalid!',
        variant: SnackbarType.error,
        duration: kSnackbarDuration,
      );
      return;
    }
    try {
      await runBusyFuture(
        _authSv.loginUserEP(email: email.value!, password: password.value!),
        throwException: true,
      );
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
}
