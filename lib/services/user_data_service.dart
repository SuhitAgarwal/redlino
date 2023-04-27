import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/user.dart';
import '../utils/collections.dart';

class UserDataService {
  final _db = FirebaseFirestore.instance;
  final _m = FirebaseMessaging.instance;
  final _a = FirebaseAuth.instance;
  final _s = FirebaseStorage.instance;
  final _rtcEngine = RtcEngine.instance;
  final _f = FirebaseFunctions.instance;

  late AppUser? _user;
  AppUser? get user => _user;

  UserDataService() {
    _a.userChanges().listen((newUser) {
      if (newUser != null) {
        checkOrRegisterAgoraAccount(newUser);
        _db.getUserDoc(newUser.uid).snapshots().listen((event) {
          final data = event.data();
          if (data != null) {
            _user = AppUser.fromMap(event.data()!);
          }
        });
      }
    });
    _m.onTokenRefresh.listen((newToken) {
      if (_user != null) {
        final newUser = _user!.copyWith(token: newToken);
        updateUserData(newUser);
      }
    });
  }

  void checkOrRegisterAgoraAccount(User newUser) async {
    await _rtcEngine?.registerLocalUserAccount(
      "16e15f5a4e63436bba27975da0d4285a",
      newUser.uid,
    );
  }

  Future<void> deleteUserData(String uid) {
    _user = null;
    return _db.getUserDoc(uid).delete();
  }

  Future<void> updateUserData(AppUser user) {
    return _db.getUserDoc(user.uid).set(user.toMap(), SetOptions(merge: true));
  }

  Future<String?> getMessagingToken() => _m.getToken();

  Future<void> updatePhotoURL(String? photoURL) {
    return _db.getUserDoc(user!.uid).update({'photoURL': photoURL});
  }

  Future<void> updateCelebrity(String uid, CelebrityInfo info) {
    return _db.getUserDoc(uid).set(
      {'celebrityInfo': info.toMap()},
      SetOptions(merge: true),
    );
  }

  Future<bool> isFavorited(String celebId) async {
    final followingCol = _db.getFollowingCol(_user!.uid);
    final q = await followingCol.where('celebrityId', isEqualTo: celebId).get();
    return q.size != 0;
  }

  Future<List<String?>> getPhotoURLs(List<String> uids) async {
    final List<String?> photoURLs = [];
    for (final uid in uids) {
      try {
        final url = await _s.ref('pfps/$uid').getDownloadURL();
        photoURLs.add(url);
      } catch (e) {
        photoURLs.add(null);
      }
    }
    return photoURLs;
  }

  Future<List<AppUser>> getCelebrities() async {
    final qSnap = await _db
        .collection('users')
        .where('isCelebrity', isEqualTo: true)
        .limit(8)
        .get();
    return qSnap.docs.map((e) => AppUser.fromMap(e.data())).toList();
  }

  Future<void> favorite(String celebUid) async {
    await _f.httpsCallable('changeFavoriteStatus').call({
      'celebUid': celebUid,
      'uid': _a.currentUser!.uid,
      'shouldFollow': true,
    });
  }

  Future<void> unfavorite(String celebUid) async {
    await _f.httpsCallable('changeFavoriteStatus').call({
      'celebUid': celebUid,
      'uid': _a.currentUser!.uid,
      'shouldFollow': false,
    });
  }

  Future<AppUser?> getUserFromFirestore(String uid) async {
    final snap = await _db.getUserDoc(uid).get();
    if (!snap.exists) return null;
    final data = snap.data();
    return AppUser.fromMap(data!);
  }
}
