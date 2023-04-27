class Room {
  final String id;
  final List<String> uids;
  final bool isFull;
  final int maxMembers;
  final bool oneOnOne;

  Room({
    required this.id,
    required this.isFull,
    required this.maxMembers,
    required this.oneOnOne,
    required this.uids,
  });

  Room copyWith({
    String? id,
    List<String>? uids,
    bool? isFull,
    int? maxMembers,
    bool? oneOnOne,
  }) {
    return Room(
      id: id ?? this.id,
      uids: uids ?? this.uids,
      isFull: isFull ?? this.isFull,
      maxMembers: maxMembers ?? this.maxMembers,
      oneOnOne: oneOnOne ?? this.oneOnOne,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uids': uids,
      'isFull': isFull,
      'maxMembers': maxMembers,
      'oneOnOne': oneOnOne,
    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      id: map['id'],
      uids: List<String>.from(map['uids']),
      isFull: map['isFull'],
      maxMembers: map['maxMembers'],
      oneOnOne: map['oneOnOne'],
    );
  }
}
