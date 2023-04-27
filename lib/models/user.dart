import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String email;
  final String uid;
  final String token;
  final String name;
  final String? photoURL;
  final int coins;
  final bool seenWelcome;
  final bool isCelebrity;
  final AppUserSocials? socials;
  final CelebrityInfo? celebrityInfo;

  AppUser({
    required this.email,
    required this.uid,
    required this.token,
    required this.name,
    this.photoURL,
    this.seenWelcome = false,
    this.isCelebrity = false,
    this.coins = 25,
    this.socials,
    this.celebrityInfo,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'uid': uid,
      'token': token,
      'name': name,
      'photoURL': photoURL,
      'socials': socials?.toMap(),
      'celebrityInfo': celebrityInfo?.toMap(),
      'seenWelcome': seenWelcome,
      'isCelebrity': isCelebrity,
      'coins': coins,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      email: map['email'],
      uid: map['uid'],
      token: map['token'],
      name: map['name'],
      photoURL: map['photoURL'],
      seenWelcome: map['seenWelcome'] ?? false,
      celebrityInfo: map['celebrityInfo'] == null
          ? null
          : CelebrityInfo.fromMap(map['celebrityInfo']),
      isCelebrity: map['isCelebrity'] ?? false,
      coins: map['coins'] ?? 0,
      socials: AppUserSocials.fromMap(map['socials']),
    );
  }

  AppUser copyWith({
    String? email,
    String? uid,
    String? token,
    String? name,
    String? photoURL,
    int? coins,
    bool? seenWelcome,
    bool? isCelebrity,
    CelebrityInfo? celebrityInfo,
    AppUserSocials? socials,
  }) {
    return AppUser(
      email: email ?? this.email,
      uid: uid ?? this.uid,
      token: token ?? this.token,
      name: name ?? this.name,
      photoURL: photoURL ?? this.photoURL,
      socials: socials ?? this.socials,
      celebrityInfo: celebrityInfo ?? this.celebrityInfo,
      coins: coins ?? this.coins,
      seenWelcome: seenWelcome ?? this.seenWelcome,
      isCelebrity: isCelebrity ?? this.isCelebrity,
    );
  }
}

class AppUserSocials {
  final String? snapchat;
  final String? tiktok;
  final String? instagram;

  AppUserSocials({
    this.snapchat,
    this.tiktok,
    this.instagram,
  });

  AppUserSocials copyWith({
    String? snapchat,
    String? tiktok,
    String? instagram,
  }) {
    return AppUserSocials(
      snapchat: snapchat ?? this.snapchat,
      tiktok: tiktok ?? this.tiktok,
      instagram: instagram ?? this.instagram,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'snapchat': snapchat,
      'tiktok': tiktok,
      'instagram': instagram,
    };
  }

  factory AppUserSocials.fromMap(Map<String, dynamic>? map) {
    if (map == null) return AppUserSocials();
    return AppUserSocials(
      snapchat: map['snapchat'],
      tiktok: map['tiktok'],
      instagram: map['instagram'],
    );
  }
}

class CelebrityInfo {
  final String? bio;
  final int favorites;
  final int calls;
  final int limboCoins;
  final DateTime? meetAndGreetStart;
  final bool isActive;

  CelebrityInfo({
    required this.favorites,
    required this.calls,
    required this.limboCoins,
    this.bio,
    this.meetAndGreetStart,
    this.isActive = false,
  });

  CelebrityInfo copyWith({
    String? bio,
    int? favorites,
    int? calls,
    int? limboCoins,
    DateTime? meetAndGreetStart,
    bool? isActive,
  }) {
    return CelebrityInfo(
      bio: bio ?? this.bio,
      favorites: favorites ?? this.favorites,
      calls: calls ?? this.calls,
      limboCoins: limboCoins ?? this.limboCoins,
      meetAndGreetStart: meetAndGreetStart ?? this.meetAndGreetStart,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bio': bio,
      'favorites': favorites,
      'calls': calls,
      'limboCoins': limboCoins,
      'meetAndGreetStart': meetAndGreetStart != null
          ? Timestamp.fromDate(meetAndGreetStart!)
          : null,
      'isActive': isActive,
    };
  }

  factory CelebrityInfo.fromMap(Map<String, dynamic> map) {
    return CelebrityInfo(
      bio: map['bio'],
      favorites: map['favorites'],
      calls: map['calls'],
      limboCoins: map['limboCoins'],
      meetAndGreetStart: (map['meetAndGreetStart'] as Timestamp?)?.toDate(),
      isActive: map['isActive'],
    );
  }
}
