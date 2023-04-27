import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../models/user.dart';
import '../../../services/room_service.dart';
import '../../../services/user_data_service.dart';
import '../../shared/dialog_service.dart';

class CelebrityDashboardViewModel extends BaseViewModel {
  final _dataSv = sl<UserDataService>();
  final _roomSv = sl<RoomService>();
  final _navSv = sl<NavigationService>();
  final _dialogSv = sl<DialogService>();

  AppUser get user => _dataSv.user!;
  CelebrityInfo get info => user.celebrityInfo!;

  bool get isActive => user.celebrityInfo!.isActive;

  String get firstName => user.name.trim().split(RegExp(r" +"))[0];

  bool _drawInitiated = false;

  void updateActiveStatus(bool newValue) async {
    await _dataSv.updateCelebrity(
      user.uid,
      user.celebrityInfo!.copyWith(isActive: newValue),
    );
    notifyListeners();
  }

  void handlePrivateRoomPress() async {
    final hasMembers = await _roomSv.hasMembers(user.uid, user.uid);
    if (hasMembers) {
      joinPrivateRoom();
      return;
    }
    final r = await _dialogSv.showCustomDialog(
      variant: kConfirmationDialog,
      title: 'Draw?',
      description: 'There are no users waiting in your private room. '
          'Would you like to draw a new user?',
      secondaryButtonTitle: 'Cancel',
      mainButtonTitle: 'Draw',
    );
    if (r == null) return;
    if (r.confirmed) {
      _drawInitiated = true;
      _dialogSv.showCustomDialog(
        variant: kLoadingDialog,
        barrierDismissible: false,
        data: {"long": true},
      );
      await _roomSv.drawLuckyUser(user.uid);
    }
  }

  void joinRandomRoom() async {
    _dialogSv.showCustomDialog(
      variant: kLoadingDialog,
      barrierDismissible: false,
    );
    final channelId = await _roomSv.findOrCreateRoom(user.uid);
    final token = await _roomSv.joinRoom(channelId, user.uid);
    _navSv.back();
    _navSv.navigateTo(
      Routes.videoCallView,
      arguments: VideoCallViewArguments(
        celebrity: user,
        token: token,
        channelId: channelId,
      ),
    );
  }

  void goToEditProfile() async {
    await _navSv.navigateTo(Routes.editProfileView);
    notifyListeners();
  }

  void handleWithdraw() {
    _dialogSv.showCustomDialog(variant: kNoWithdrawDialog);
  }

  void joinPrivateRoom() async {
    final token = await _roomSv.joinRoom(user.uid, user.uid);
    if (_drawInitiated) {
      _navSv.back();
      _drawInitiated = false;
    }
    _navSv.navigateTo(
      Routes.videoCallView,
      arguments: VideoCallViewArguments(
        celebrity: user,
        channelId: user.uid,
        token: token,
      ),
    );
  }

  void showNoDrawUserFoundDialog() {
    _navSv.back();
    _drawInitiated = false;
    _dialogSv.showCustomDialog(
      variant: kBasicDialog,
      title: 'No user found',
      description: 'Unfortunately, there were no users available to chat',
    );
  }
}
