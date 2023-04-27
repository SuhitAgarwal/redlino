import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote;
import 'package:flutter/material.dart';

import '../../../shared/profile_pic.dart';

class VideoView extends StatelessWidget {
  final int? uid;
  final bool isLocal;
  final bool hasVideo;
  final bool hasAudio;
  final String? photoURL;

  const VideoView({
    Key? key,
    required this.hasAudio,
    required this.hasVideo,
    required this.photoURL,
    this.uid,
    this.isLocal = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!hasVideo && !hasAudio) {
      return ColoredBox(
        color: Colors.grey.shade800,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: ProfilePic(url: photoURL, size: 24)),
            const SizedBox(height: 24),
            const Center(
              child: Icon(Icons.mic_off, color: Colors.white),
            ),
          ],
        ),
      );
    }

    if (!hasVideo) {
      return ColoredBox(
        color: Colors.grey.shade800,
        child: Center(
          child: ProfilePic(url: photoURL, size: 24),
        ),
      );
    }

    return Stack(
      children: [
        if (isLocal) ...[
          rtc_local.SurfaceView(),
        ] else ...[
          rtc_remote.SurfaceView(uid: uid!)
        ],
        if (!hasAudio) ...[
          const ColoredBox(
            color: Colors.black26,
            child: Center(
              child: Icon(Icons.mic_off, color: Colors.white),
            ),
          ),
        ],
      ],
    );
  }
}
