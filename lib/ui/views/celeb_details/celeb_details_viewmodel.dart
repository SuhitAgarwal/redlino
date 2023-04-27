import 'package:firebase_auth/firebase_auth.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../models/user.dart';
import '../../../services/coins_service.dart';
import '../../../services/link_service.dart';
import '../../../services/room_service.dart';
import '../../../services/user_data_service.dart';
import '../../shared/dialog_service.dart';

class CelebrityDetailsViewModel extends BaseViewModel {
  final _auth = FirebaseAuth.instance;
  final _roomSv = sl<RoomService>();
  final _dataSv = sl<UserDataService>();
  final _navSv = sl<NavigationService>();
  final _coinsSv = sl<CoinsService>();
  final _linkSv = sl<LinkService>();
  final _dialogSv = sl<DialogService>();

  final AppUser celebrity;

  CelebrityInfo get info => celebrity.celebrityInfo!;

  CelebrityDetailsViewModel(this.celebrity);

  User get user => _auth.currentUser!;

  bool get isCelebrity => user.uid == celebrity.uid;

  bool isFavorited = false;

  void initializeModel() async {
    if (isCelebrity) return;
    isFavorited = await runBusyFuture(_dataSv.isFavorited(celebrity.uid));
  }

  void joinRoom() async {
    _dialogSv.showCustomDialog(
      variant: kLoadingDialog,
      barrierDismissible: false,
    );
    final channelId = await _roomSv.findOrCreateRoom(celebrity.uid);
    final token = await _roomSv.joinRoom(channelId, celebrity.uid);
    _navSv.back();
    _navSv.navigateTo(
      Routes.videoCallView,
      arguments: VideoCallViewArguments(
        celebrity: celebrity,
        channelId: channelId,
        token: token,
      ),
    );
  }

  Future<void> handleSendCoins() {
    return _coinsSv.startCoinTransferFlow(
      celebName: celebrity.name,
      celebUid: celebrity.uid,
    );
  }

  void launchInstagram() {
    final ig = celebrity.socials!.instagram!;
    _linkSv.launchInstagram(ig);
  }

  void launchSnapchat() {
    final sc = celebrity.socials!.snapchat!;
    _linkSv.launchSnapchat(sc);
  }

  void launchTikTok() {
    final tt = celebrity.socials!.tiktok!;
    _linkSv.launchTikTok(tt);
  }

  void toggleFavorite() {
    if (isFavorited) {
      _dataSv.unfavorite(celebrity.uid);
    } else {
      _dataSv.favorite(celebrity.uid);
    }
    isFavorited = !isFavorited;
    notifyListeners();
  }
}
