import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/auth_service.dart';
import '../../../services/user_data_service.dart';

class InitialViewModel extends BaseViewModel {
  final _navSv = sl<NavigationService>();
  final _authSv = sl<AuthService>();
  final _dataSv = sl<UserDataService>();

  Future<void> checkAuthStatus() async {
    //! workaround to wait for app to finish building initial screen
    await Future.delayed(const Duration(seconds: 0));

    if (_authSv.firebaseUser == null) {
      _navSv.replaceWith(Routes.signupSigninView);
      return;
    }

    final isCelebrity = await _authSv.isCelebrity;
    final token = await _dataSv.getMessagingToken();
    await _dataSv.updateUserData(_dataSv.user!.copyWith(token: token));
    _navSv.replaceWith(
      Routes.navbarView,
      arguments: NavbarViewArguments(isCelebrity: isCelebrity),
    );
  }
}
