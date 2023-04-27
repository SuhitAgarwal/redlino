import 'dart:async';
import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wakelock/wakelock.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../models/message.dart';
import '../../../models/user.dart';
import '../../../services/coins_service.dart';
import '../../../services/room_service.dart';
import '../../../services/user_data_service.dart';
import '../../shared/dialog_service.dart';
import '../../shared/snackbar_service.dart';
import '../../theme/globals.dart';
import '../video_call_msging/video_call_msging_view.dart';

class VideoCallViewModel extends BaseViewModel {
  final AppUser celebUser;
  final int maxPeople;
  final String channelId;
  final String token;

  final _logger = getLogger("VideoCallViewModel");
  final _dataSv = sl<UserDataService>();
  final _roomSv = sl<RoomService>();
  final _dialogSv = sl<DialogService>();
  final _snackSv = sl<SnackbarService>();
  final _navSv = sl<NavigationService>();
  final _coinsSv = sl<CoinsService>();
  final engine = RtcEngine.instance!;
  final Map<int, AppUser> agoraUidsToUsers = {};
  final Set<int> uids = {};
  final Set<int> usersWithVideoEnabled = {};
  final Set<int> usersWithAudioEnabled = {};
  final msgController = TextEditingController();

  late String _eChannelId;
  late Stream<List<Message>> msgsStream;
  late Timer? timer;

  bool joined = false;
  bool videoEnabled = true;
  bool audioEnabled = true;
  bool drawingDialogOpen = false;
  bool drawing = false;
  bool receivedUserInfo = false;
  String? title;
  String? winnerUid;
  AppUser? winnerUser;
  List<String?>? drawingPhotoURLs;

  AppUser get user => _dataSv.user!;

  VideoCallViewModel({
    required this.celebUser,
    required this.maxPeople,
    required this.channelId,
    required this.token,
  });

  void _removeUidFromAll(int uid) {
    uids.remove(uid);
    agoraUidsToUsers.remove(uid);
    usersWithVideoEnabled.remove(uid);
    usersWithAudioEnabled.remove(uid);
  }

  void _addUidToAll(int uid, AppUser fbUser) {
    uids.add(uid);
    agoraUidsToUsers[uid] = fbUser;
    usersWithVideoEnabled.add(uid);
    usersWithAudioEnabled.add(uid);
  }

  bool hasVideo(int uid) {
    return usersWithVideoEnabled.contains(uid);
  }

  bool hasAudio(int uid) {
    return usersWithAudioEnabled.contains(uid);
  }

  void initializeModel() async {
    setBusy(true);
    _eChannelId = channelId;
    msgsStream = _roomSv.getMessagesStream(celebUser.uid, _eChannelId);
    title = "${celebUser.name.split(" ")[0]}'s Super Fans";
    final permissionsGranted = await requestPermissions();
    if (!permissionsGranted) {
      setBusy(false);
      return;
    }
    engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (channel, uid, elapsed) {
          joined = true;
          notifyListeners();
        },
        error: (error) {
          if (error == ErrorCode.LeaveChannelRejected) return;
          _logger.e(error);
          back();
          _snackSv.showCustomSnackBar(
            message: 'Something went wrong',
            variant: SnackbarType.error,
            duration: kSnackbarDuration,
          );
        },
        userJoined: (id, _) async {
          if (!receivedUserInfo) return;
          final userInfo = await engine.getUserInfoByUid(id);
          final fbUid = userInfo.userAccount;
          final fbUser = (await _dataSv.getUserFromFirestore(fbUid))!;

          _addUidToAll(id, fbUser);
          notifyListeners();
        },
        userInfoUpdated: (uid, userInfo) async {
          receivedUserInfo = true;
          final fbUid = userInfo.userAccount;
          final fbUser = (await _dataSv.getUserFromFirestore(fbUid))!;
          _addUidToAll(uid, fbUser);
          notifyListeners();
        },
        rejoinChannelSuccess: (channel, uid, _) {
          print('asdfjasdlkf');
        },
        userOffline: (uid, _) {
          _removeUidFromAll(uid);
          notifyListeners();
        },
        remoteVideoStateChanged: (uid, state, reason, elapsed) {
          if (reason == VideoRemoteStateReason.LocalMuted ||
              reason == VideoRemoteStateReason.RemoteMuted) {
            usersWithVideoEnabled.remove(uid);
            notifyListeners();
          } else if (reason == VideoRemoteStateReason.RemoteUnmuted) {
            usersWithVideoEnabled.add(uid);
            notifyListeners();
          }
        },
        remoteAudioStateChanged: (uid, state, reason, elapsed) {
          if (reason == AudioRemoteStateReason.LocalMuted ||
              reason == AudioRemoteStateReason.RemoteMuted) {
            usersWithAudioEnabled.remove(uid);
            notifyListeners();
          } else if (reason == AudioRemoteStateReason.RemoteUnmuted) {
            usersWithAudioEnabled.add(uid);
            notifyListeners();
          }
        },
      ),
    );
    await engine.enableVideo();
    await engine.enableAudio();
    await Wakelock.enable();
    timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _coinsSv.addCoins(1);
      _snackSv.showCustomSnackBar(
        message: 'You earned 1 coin',
        variant: SnackbarType.info,
        duration: kSnackbarDuration,
      );
      Vibrate.vibrate();
    });
    await engine.leaveChannel();
    await engine.joinChannelWithUserAccount(
      token,
      _eChannelId,
      user.uid,
    );
    setBusy(false);
  }

  @override
  void dispose() async {
    msgController.dispose();
    if (timer != null) {
      timer?.cancel();
    }
    super.dispose();
  }

  Future<void> leaveChannel() async {
    usersWithAudioEnabled.clear();
    usersWithVideoEnabled.clear();
    uids.clear();
    joined = false;
    if (timer != null) {
      timer?.cancel();
    }
    await Wakelock.disable();
    await engine.leaveChannel();
    receivedUserInfo = false;
    await Future.delayed(const Duration(seconds: 0));
    await _roomSv.removeUser(
      celebUid: celebUser.uid,
      channelId: _eChannelId,
      uid: user.uid,
    );
  }

  void back() {
    if ((_snackSv.isOpen ?? false)) {
      _navSv.back();
    }
    _navSv.back();
  }

  void swapCamera() => engine.switchCamera();

  void transferCoins() {
    _coinsSv.startCoinTransferFlow(
      celebUid: celebUser.uid,
      celebName: celebUser.name,
    );
  }

  void toggleVideo() async {
    videoEnabled = !videoEnabled;
    await engine.muteLocalVideoStream(!videoEnabled);
    notifyListeners();
  }

  void toggleAudio() async {
    audioEnabled = !audioEnabled;
    await engine.muteLocalAudioStream(!audioEnabled);
    notifyListeners();
  }

  Future<bool> requestPermissions() async {
    final permissions = await [
      Permission.camera,
      Permission.microphone,
    ].request();
    return permissions.values.every((element) => element.isGranted);
  }

  void handleDrawingNotification(RemoteMessage msg) async {
    final String celebUid = msg.data['celebUid'];
    winnerUid = msg.data['winnerUid'];
    if (celebUser.uid != celebUid) return;
    final allUids = List<String>.from(jsonDecode(msg.data['jsonUids']));
    drawingPhotoURLs = await _dataSv.getPhotoURLs(allUids);
    drawing = true;
    winnerUser = await _dataSv.getUserFromFirestore(winnerUid!);
    notifyListeners();
  }

  void onDrawingAnimationFinished() async {
    drawing = false;
    notifyListeners();
    if (winnerUid != _dataSv.user!.uid) return;
    drawingDialogOpen = true;
    final response = await _dialogSv.showCustomDialog(
      imageUrl: celebUser.photoURL,
      hasImage: true,
      variant: kMeetCelebDialog,
    );
    drawingDialogOpen = false;
    if (response == null) return;
    if (response.confirmed) {
      _roomSv.acceptDrawing(celebUser.uid);
      await leaveChannel();
      _eChannelId = celebUser.uid;
      title = "One on one with ${celebUser.name.split(" ")[0]}";
      msgsStream = _roomSv.getMessagesStream(celebUser.uid, _eChannelId);
      notifyListeners();
      final newToken = await _roomSv.joinRoom(_eChannelId, celebUser.uid);
      await engine.joinChannelWithUserAccount(
        newToken,
        _eChannelId,
        user.uid,
      );
    } else {
      await _coinsSv.removeDrawing(celebUser.uid);
      await _roomSv.drawLuckyUser(celebUser.uid);
    }
  }

  void findAnotherChannel() async {
    _dialogSv.showCustomDialog(variant: kLoadingDialog);
    final cId = await _roomSv.switchRoom(celebUser.uid, _eChannelId);
    await leaveChannel();
    _eChannelId = cId;
    msgsStream = _roomSv.getMessagesStream(celebUser.uid, _eChannelId);
    notifyListeners();
    final newToken = await _roomSv.joinRoom(_eChannelId, celebUser.uid);
    await engine.joinChannelWithUserAccount(
      newToken,
      _eChannelId,
      user.uid,
    );
    _navSv.back();
  }

  void goToMessaging() {
    _navSv.navigateToView(
      VideoCallMsgingView(
        stream: msgsStream,
        user: user,
        celebUid: celebUser.uid,
        channelId: _eChannelId,
      ),
      opaque: false,
      transition: Transition.rightToLeftWithFade,
    );
  }
}
