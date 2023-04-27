import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/user_data_service.dart';

class TutorialViewModel extends BaseViewModel {
  final _dataSv = sl<UserDataService>();
  final _navSv = sl<NavigationService>();

  void goToHome() {
    _navSv.clearStackAndShow(
      Routes.navbarView,
      arguments: NavbarViewArguments(isCelebrity: _dataSv.user!.isCelebrity),
    );
  }
}
