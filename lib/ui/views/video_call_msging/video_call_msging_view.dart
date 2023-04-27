import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

import '../../../models/message.dart' as msg_model;
import '../../../models/user.dart';
import '../../theme/globals.dart';
import '../video_call/widgets/msg.dart';
import 'video_call_msging_viewmodel.dart';

class VideoCallMsgingView extends StatelessWidget {
  final Stream<List<msg_model.Message>> stream;
  final AppUser user;
  final String celebUid;
  final String channelId;

  const VideoCallMsgingView({
    Key? key,
    required this.stream,
    required this.user,
    required this.celebUid,
    required this.channelId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.nonReactive(
      viewModelBuilder: () => VideoCallMsgingViewModel(
        stream: stream,
        celebUid: celebUid,
        channelId: channelId,
        user: user,
      ),
      builder: (_, __, ___) {
        return _View();
      },
    );
  }
}

class _View extends HookViewModelWidget<VideoCallMsgingViewModel> {
  @override
  Widget buildViewModelWidget(
    BuildContext context,
    VideoCallMsgingViewModel model,
  ) {
    final controller = useTextEditingController();
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('Messaging'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: StreamBuilder<List<msg_model.Message>>(
              stream: model.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  primary: false,
                  shrinkWrap: true,
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (c, i) {
                    return ChatMessage(
                      msg: snapshot.data![i],
                      uid: model.user.uid,
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: controller,
              onSubmitted: (value) {
                if (value.trim().isEmpty) return;
                model.sendMessage(value);
                controller.clear();
              },
              textInputAction: TextInputAction.send,
              style: blackTextStyle,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                suffixIcon: IconButton(
                  onPressed: () {
                    if (controller.text.trim().isEmpty) return;
                    model.sendMessage(controller.text);
                    controller.clear();
                  },
                  splashRadius: 24,
                  icon: const Icon(Icons.send_outlined),
                ),
                hintText: 'Send message',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
