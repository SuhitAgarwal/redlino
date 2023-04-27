import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/user_data_service.dart';

class InitialWelcomeViewModel extends BaseViewModel {
  final _navSv = sl<NavigationService>();
  final _dataSv = sl<UserDataService>();

  late String _displayName;
  String get firstName => _displayName.trim().split(' ')[0];

  void getDisplayName() {
    _displayName = _dataSv.user!.name;
  }

  void goToTutorial() {
    _navSv.replaceWith(Routes.tutorialView);
  }
}
