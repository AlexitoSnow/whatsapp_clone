/// The model used to display chat contacts in the chat list.
class ChatContact {
  final String phone;
  final String? profilePic;
  final String contactId;
  final DateTime timeSent;
  final String lastMessage;
  final bool isTyping;

  ChatContact({
    required this.phone,
    required this.profilePic,
    required this.contactId,
    required this.timeSent,
    required this.lastMessage,
    this.isTyping = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'phone': phone,
      'profilePic': profilePic,
      'contactId': contactId,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'lastMessage': lastMessage,
      'isTyping': isTyping,
    };
  }

  factory ChatContact.fromMap(Map<String, dynamic> map) {
    return ChatContact(
      phone: map['phone'],
      profilePic: map['profilePic'],
      contactId: map['contactId'],
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      lastMessage: map['lastMessage'],
      isTyping: map['isTyping'],
    );
  }
}
