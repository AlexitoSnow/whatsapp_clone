import 'package:whatsapp_clone/common/enums/message_type.dart';

class Message {
  final String senderId;
  final String recieverid;
  final String text;
  final MessageType type;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;
  //final String repliedMessage;
  //final String repliedTo;
  //final MessageEnum repliedMessageType;

  Message({
    required this.senderId,
    required this.recieverid,
    required this.text,
    required this.type,
    required this.timeSent,
    required this.messageId,
    required this.isSeen,
    //required this.repliedMessage,
    //required this.repliedTo,
    //required this.repliedMessageType,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'recieverid': recieverid,
      'text': text,
      'type': type.name,
      'timeSent': timeSent,
      'messageId': messageId,
      'isSeen': isSeen,
      //'repliedMessage': repliedMessage,
      //'repliedTo': repliedTo,
      //'repliedMessageType': repliedMessageType.toString().split('.').last,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'],
      recieverid: map['recieverid'],
      text: map['text'],
      type: MessageType.values.byName(map['type']),
      timeSent: map['timeSent'].toDate(),
      messageId: map['messageId'],
      isSeen: map['isSeen'],
      //repliedMessage: map['repliedMessage'],
      //repliedTo: map['repliedTo'],
      /*repliedMessageType: MessageType.values.firstWhere(
        (element) => element.toString().split('.').last == map['repliedMessageType'],
      ),*/
    );
  }
}
