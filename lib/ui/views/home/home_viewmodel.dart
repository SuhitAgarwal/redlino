import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../models/user.dart';
import '../../../services/auth_service.dart';
import '../../../services/user_data_service.dart';

class HomeViewModel extends BaseViewModel {
  final _authSv = sl<AuthService>();
  final _navSv = sl<NavigationService>();
  final _dataSv = sl<UserDataService>();

  AppUser get user => _dataSv.user!;

  late List<AppUser> _celebrities;
  List<AppUser> get celebrities => _celebrities;

  void initializeModel() async {
    _celebrities = await runBusyFuture(_dataSv.getCelebrities());
  }

  Future<void> signOut() async {
    await _authSv.signOut();
    _navSv.clearStackAndShow(Routes.signupSigninView);
  }
}
