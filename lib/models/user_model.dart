class UserModel {
  final String? name;
  final String uid;
  final String? profilePic;
  final bool? isOnline;
  final String phoneNumber;
  final List<String> groupId;
  final DateTime? lastSeen;
  final String? info;

  UserModel({
    required this.name,
    required this.uid,
    required this.profilePic,
    required this.isOnline,
    required this.phoneNumber,
    required this.groupId,
    required this.lastSeen,
    this.info,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'phoneNumber': phoneNumber,
      'groupId': groupId,
      'lastSeen': lastSeen?.toIso8601String(),
      'info': info,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      uid: map['uid'],
      profilePic: map['profilePic'],
      isOnline: map['isOnline'],
      phoneNumber: map['phoneNumber'],
      groupId: List<String>.from(map['groupId']),
      lastSeen: DateTime.tryParse(map['lastSeen']),
      info: map['info'],
    );
  }
}
