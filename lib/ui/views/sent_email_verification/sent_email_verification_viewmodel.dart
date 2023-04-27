import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/user_data_service.dart';

class SentEmailVerificationViewModel extends BaseViewModel {
  final _navSv = sl<NavigationService>();
  final _userData = sl<UserDataService>();

  void goToWelcome() async {
    final cUser = _userData.user!.copyWith(seenWelcome: true);
    await _userData.updateUserData(cUser);
    _navSv.navigateTo(Routes.initialWelcomeView);
  }
}
