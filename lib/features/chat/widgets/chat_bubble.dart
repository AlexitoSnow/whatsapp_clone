import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/enums/message_type.dart';
import 'package:whatsapp_clone/features/chat/widgets/video_message.dart';
import 'package:whatsapp_clone/models/message.dart';
import 'package:whatsapp_clone/styles/app_theme.dart';

// TODO: FIX BUBBLES
class ChatBubble extends StatelessWidget {
  const ChatBubble(this.message, {super.key});
  final Message message;

  @override
  Widget build(BuildContext context) {
    switch (message.type) {
      case MessageType.image:
        return BubbleNormalImage(
          id: message.messageId,
          isSender: message.senderId == FirebaseAuth.instance.currentUser!.uid,
          image: CachedNetworkImage(
            imageUrl: message.text,
          ),
        );
      case MessageType.video:
        return BubbleNormalImage(
          id: message.messageId,
          isSender: message.senderId == FirebaseAuth.instance.currentUser!.uid,
          image: VideoItem(
            videoUrl: message.text,
          ),
        );
      default:
        return BubbleSpecialOne(
          text: message.text,
          isSender: message.senderId == FirebaseAuth.instance.currentUser!.uid,
          color: message.senderId == FirebaseAuth.instance.currentUser!.uid
              ? messageColor
              : senderMessageColor,
          textStyle: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
          seen: message.isSeen,
          //TODO: Acomodar la burbuja de mensaje cuando un usuario envia varios mensajes seguidos
        );
    }
  }
}
