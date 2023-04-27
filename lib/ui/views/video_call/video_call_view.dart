// import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local;
import 'package:fcm_config/fcm_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

import '../../../models/user.dart';
import '../../theme/globals.dart';
import 'video_call_viewmodel.dart';
import 'widgets/animation.dart';
import 'widgets/video.dart';

class VideoCallView extends StatelessWidget {
  final AppUser celebrity;
  final String channelId;
  final String token;

  const VideoCallView({
    Key? key,
    required this.celebrity,
    required this.channelId,
    required this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return ViewModelBuilder<VideoCallViewModel>.reactive(
      viewModelBuilder: () => VideoCallViewModel(
        celebUser: celebrity,
        maxPeople: 4,
        channelId: channelId,
        token: token,
      ),
      fireOnModelReadyOnce: true,
      onModelReady: (model) => model.initializeModel(),
      builder: (context, model, _) {
        if (model.isBusy) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        Widget _renderLocalPreview() {
          if (model.joined) {
            return Positioned(
              bottom: height * 0.13,
              right: 20,
              child: SizedBox(
                width: 125,
                height: 175,
                child: ClipRRect(
                  borderRadius: borderRadiusSm,
                  child: VideoView(
                    hasAudio: model.audioEnabled,
                    hasVideo: model.videoEnabled,
                    photoURL: model.user.photoURL,
                    isLocal: true,
                  ),
                ),
              ),
            );
          }
          return Container();
        }

        Widget _videoView(view) {
          return Expanded(child: Container(child: view));
        }

        Widget _expandedVideoRow(List<Widget> views) {
          final wrappedViews = views.map<Widget>(_videoView).toList();
          return Expanded(
            child: Row(
              children: wrappedViews,
            ),
          );
        }

        Widget _viewGrid() {
          final List<Widget> views = [];
          views.addAll(model.uids.map(
            (e) => VideoView(
              uid: e,
              hasAudio: model.hasAudio(e),
              hasVideo: model.hasVideo(e),
              photoURL: model.agoraUidsToUsers[e]!.photoURL,
            ),
          ));
          if (model.uids.length > 1) {
            views.add(
              VideoView(
                hasAudio: model.audioEnabled,
                isLocal: true,
                hasVideo: model.videoEnabled,
                photoURL: model.user.photoURL,
              ),
            );
          }
          if (views.isEmpty) {
            return const ColoredBox(
              color: Colors.white,
              child: Center(
                child: Text(
                  'Waiting for other users to join...',
                  style: blackTextStyle,
                ),
              ),
            );
          }
          if (views.length == 1) {
            return Column(
              children: <Widget>[_videoView(views[0])],
            );
          } else if (views.length == 2) {
            return Column(
              children: <Widget>[
                _expandedVideoRow([views[0]]),
                _expandedVideoRow([views[1]])
              ],
            );
          } else if (views.length > 2 && views.length % 2 == 0) {
            return Column(
              children: [
                for (int i = 0; i < views.length; i = i + 2)
                  _expandedVideoRow(
                    views.sublist(i, i + 2),
                  ),
              ],
            );
          } else if (views.length > 2 && views.length % 2 != 0) {
            return Column(
              children: <Widget>[
                for (int i = 0; i < views.length; i = i + 2)
                  i == (views.length - 1)
                      ? _expandedVideoRow(views.sublist(i, i + 1))
                      : _expandedVideoRow(views.sublist(i, i + 2)),
              ],
            );
          }
          return Container();
        }

        return WillPopScope(
          onWillPop: () async {
            await model.leaveChannel();
            return true;
          },
          child: Scaffold(
            extendBody: true,
            backgroundColor: Colors.black,
            endDrawerEnableOpenDragGesture: false,
            appBar: AppBar(
              title: Text(model.title ?? ""),
              actions: [
                if (model.celebUser.uid != model.user.uid)
                  IconButton(
                    onPressed: model.transferCoins,
                    splashRadius: 20,
                    icon: Image.asset('assets/coin.png'),
                  ),
                IconButton(
                  onPressed: model.goToMessaging,
                  splashRadius: 20,
                  icon: const Icon(Icons.message_outlined),
                ),
              ],
              automaticallyImplyLeading: false,
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              centerTitle: false,
            ),
            bottomSheet: Container(
              margin: symHPadding20,
              padding: const EdgeInsets.only(
                bottom: 32,
                top: 16,
              ),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
                color: Colors.black54,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: model.swapCamera,
                    icon: const Icon(Icons.flip_camera_android),
                    iconSize: 36.0,
                    splashRadius: 28,
                    color: Colors.white,
                  ),
                  IconButton(
                    onPressed: model.toggleVideo,
                    icon: Icon(model.videoEnabled
                        ? Icons.videocam_rounded
                        : Icons.videocam_off_rounded),
                    iconSize: 36.0,
                    splashRadius: 28,
                    color: Colors.white,
                  ),
                  MaterialButton(
                    onPressed: () {
                      model.leaveChannel();
                      model.back();
                    },
                    child: const Icon(
                      Icons.call_end_outlined,
                      color: Colors.white,
                    ),
                    color: Colors.red,
                    height: 56,
                    minWidth: 56,
                    shape: borderRadiusMdShape,
                    elevation: 0,
                  ),
                  IconButton(
                    onPressed: model.toggleAudio,
                    icon: Icon(
                      model.audioEnabled ? Icons.mic : Icons.mic_off,
                    ),
                    iconSize: 36.0,
                    splashRadius: 28,
                    color: Colors.white,
                  ),
                  IconButton(
                    onPressed: model.findAnotherChannel,
                    icon: const Icon(Icons.switch_left_outlined),
                    iconSize: 36.0,
                    splashRadius: 28,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            body: FCMNotificationListener(
              onNotification: (msg, _) {
                if (msg.data["winnerUid"] != null) {
                  model.handleDrawingNotification(msg);
                  return;
                }
                if (msg.from == "/topics/drawings") {
                  model.handleDrawingNotification(msg);
                }
              },
              child: Stack(
                children: [
                  Positioned.fill(
                    child: _viewGrid(),
                  ),
                  if (model.uids.length < 2) _renderLocalPreview(),
                  if (model.drawing)
                    Positioned.fill(
                      child: LuckyFanAnim(
                        celebPhotoURL: celebrity.photoURL,
                        photoURLs: model.drawingPhotoURLs!,
                        winnerName: model.winnerUser!.name,
                        winnerPhotoURL: model.winnerUser!.photoURL,
                        onFinished: model.onDrawingAnimationFinished,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
