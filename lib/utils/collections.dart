import 'package:cloud_firestore/cloud_firestore.dart';

typedef ColRefMap = CollectionReference<Map<String, dynamic>>;
typedef DocRefMap = DocumentReference<Map<String, dynamic>>;

extension CustomCollections on FirebaseFirestore {
  ColRefMap get users => collection('users');

  ColRefMap getRoomsCol(String celebId) =>
      getUserDoc(celebId).collection('rooms');

  ColRefMap getFollowingCol(String uid) =>
      getUserDoc(uid).collection('following');

  ColRefMap getDrawingsCol(String celebId) =>
      getUserDoc(celebId).collection('drawings');

  ColRefMap getMsgsCol(String celebId, String roomId) =>
      getRoomDoc(celebId, roomId).collection('messages');

  DocRefMap getUserDoc(String uid) => users.doc(uid);

  DocRefMap getRoomDoc(String celebId, String roomId) =>
      getRoomsCol(celebId).doc(roomId);

  DocRefMap getMsgDoc(String celebId, String roomId, String msgId) =>
      getMsgsCol(celebId, roomId).doc(msgId);
}
