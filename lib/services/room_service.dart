import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../models/failure.dart';
import '../models/message.dart';
import '../models/room.dart';
import '../utils/collections.dart';

class RoomService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final _functions = FirebaseFunctions.instance;

  Future<String> findOrCreateRoom(String celebId, [int maxMembers = 5]) async {
    final roomsCol = _db.getRoomsCol(celebId);
    final qSnap = await roomsCol
        .where('uids', whereNotIn: [_auth.currentUser!.uid])
        .where('isFull', isEqualTo: false)
        .where('oneOnOne', isEqualTo: false)
        .limit(1)
        .get();

    if (qSnap.size == 0) {
      final id = const Uuid().v4();
      final room = Room(
        id: id,
        isFull: false,
        maxMembers: maxMembers,
        oneOnOne: false,
        uids: [],
      );
      await roomsCol.doc(id).set(room.toMap());
      return id;
    } else {
      return qSnap.docs.first.id;
    }
  }

  Future<String> joinRoom(String channelId, String celebUid) async {
    final r = await _functions.httpsCallable('joinRoom').call({
      "uid": _auth.currentUser!.uid,
      "channelId": channelId,
      "celebUid": celebUid,
    });
    return r.data;
  }

  Future<String> switchRoom(String celebId, String oldChannelId) async {
    final roomsCol = _db.getRoomsCol(celebId);
    final qSnap = await roomsCol
        .where('__name__', isNotEqualTo: oldChannelId)
        .where('isFull', isEqualTo: false)
        .where('oneOnOne', isEqualTo: false)
        .limit(1)
        .get();
    if (qSnap.size == 0) {
      final id = const Uuid().v4();
      final room = Room(
        id: id,
        isFull: false,
        maxMembers: 5,
        oneOnOne: false,
        uids: [],
      );
      await roomsCol.doc(id).set(room.toMap());
      return id;
    } else {
      return qSnap.docs.first.id;
    }
  }

  Future<void> drawLuckyUser(String celebUid) async {
    final call = _functions.httpsCallable('draw');
    final r = await call(celebUid);
    if (r.data is String) {
      throw Failure(r.data);
    }
  }

  void acceptDrawing(String celebUid) {
    final call = _functions.httpsCallable('acceptDrawing');
    call(celebUid);
  }

  Stream<Room?> getRoomStream(
    String celebId,
    String roomId,
  ) {
    return _db.getRoomDoc(celebId, roomId).snapshots().map((event) {
      if (event.data() == null) return null;
      return Room.fromMap(event.data()!);
    });
  }

  Stream<List<Message>> getMessagesStream(String celebId, String roomId) {
    return _db
        .getMsgsCol(celebId, roomId)
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map(
          (snap) => snap.docs.map((e) => Message.fromMap(e.data())).toList(),
        );
  }

  Future<void> sendMessage(String celebId, String roomId, Message msg) {
    return _db.getMsgDoc(celebId, roomId, msg.id).set(msg.toMap());
  }

  Future<bool> hasMembers(String celebId, String channelId) async {
    final roomDoc = _db.getRoomDoc(celebId, channelId);
    final roomDocSnap = await roomDoc.get();
    final data = roomDocSnap.data();
    if (data == null) return false;
    final room = Room.fromMap(data);
    return room.uids.isNotEmpty;
  }

  Future<void> removeUser({
    required String uid,
    required String channelId,
    required String celebUid,
  }) async {
    await _functions.httpsCallable('leaveRoom').call({
      "uid": uid,
      "celebUid": celebUid,
      "channelId": channelId,
    });
  }
}
