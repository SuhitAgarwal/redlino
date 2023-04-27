import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../models/user.dart';
import '../../../services/auth_service.dart';
import '../../../services/link_service.dart';
import '../../../services/user_data_service.dart';
import '../../shared/dialog_service.dart';

class ProfileViewModel extends BaseViewModel {
  final _authSv = sl<AuthService>();
  final _navSv = sl<NavigationService>();
  final _dialogSv = sl<DialogService>();
  final _dataService = sl<UserDataService>();
  final _linkSv = sl<LinkService>();
  final picker = ImagePicker();

  AppUser get appUser => _dataService.user!;
  User get user => _authSv.firebaseUser!;

  Future<void> signOut() async {
    final r = await _dialogSv.showCustomDialog(
      variant: kConfirmationDialog,
      title: 'Sign out',
      description: 'Would you like to sign out?',
      secondaryButtonTitle: 'Cancel',
      mainButtonTitle: 'Sign out',
    );
    if (r == null) return;
    if (!r.confirmed) return;
    await _authSv.signOut();
    _navSv.clearStackAndShow(Routes.signupSigninView);
  }

  void handleGetCoins() async {
    final c = await _dialogSv.showCustomDialog(
      variant: kNoCoinPurchaseDialog
    );
  }

  void goToBuyCoinsView() async {
    await _navSv.navigateTo(Routes.buyCoinsView);
    notifyListeners();
  }

  void edit() async {
    await _navSv.navigateTo(Routes.editProfileView);
    notifyListeners();
  }

  void launchInstagram() {
    final ig = appUser.socials!.instagram!;
    _linkSv.launchInstagram(ig);
  }

  void launchSnapchat() {
    final sc = appUser.socials!.snapchat!;
    _linkSv.launchSnapchat(sc);
  }

  void launchTikTok() {
    final tt = appUser.socials!.tiktok!;
    _linkSv.launchTikTok(tt);
  }

  void goToCelebDetailsView() {
    _navSv.navigateTo(
      Routes.celebrityDetailsView,
      arguments: CelebrityDetailsViewArguments(
        celebrity: appUser,
        showJoinRoomBtn: false,
      ),
    );
  }
}
