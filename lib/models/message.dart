import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String content;
  final DateTime timestamp;
  final String sentUid;
  final String name;
  final String? photoURL;

  Message({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.sentUid,
    required this.name,
    required this.photoURL,
  });

  Message copyWith({
    String? id,
    String? content,
    DateTime? timestamp,
    String? sentUid,
    String? name,
    String? photoURL,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      sentUid: sentUid ?? this.sentUid,
      name: name ?? this.name,
      photoURL: photoURL ?? this.photoURL,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
      'sentUid': sentUid,
      'name': name,
      'photoURL': photoURL,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      content: map['content'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      sentUid: map['sentUid'],
      name: map['name'],
      photoURL: map['photoURL'],
    );
  }
}
