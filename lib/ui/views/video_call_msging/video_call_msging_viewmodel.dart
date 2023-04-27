import 'package:stacked/stacked.dart';
import 'package:uuid/uuid.dart';

import '../../../app/app.locator.dart';
import '../../../models/message.dart' as msg_model;
import '../../../models/user.dart';
import '../../../services/room_service.dart';

class VideoCallMsgingViewModel extends BaseViewModel {
  final Stream<List<msg_model.Message>> stream;
  final AppUser user;
  final String channelId;
  final String celebUid;

  VideoCallMsgingViewModel({
    required this.stream,
    required this.user,
    required this.channelId,
    required this.celebUid,
  });

  final _roomSv = sl<RoomService>();

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    final msg = msg_model.Message(
      id: const Uuid().v4(),
      content: text,
      timestamp: DateTime.now(),
      sentUid: user.uid,
      name: user.name,
      photoURL: user.photoURL,
    );
    return _roomSv.sendMessage(celebUid, channelId, msg);
  }
}
