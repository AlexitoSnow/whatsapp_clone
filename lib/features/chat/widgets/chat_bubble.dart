import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsapp_clone/common/enums/message_type.dart';
import 'package:whatsapp_clone/features/chat/widgets/video_message.dart';
import 'package:whatsapp_clone/models/message.dart';
import 'package:whatsapp_clone/styles/app_theme.dart';

import 'media_screen.dart';

// TODO: FIX BUBBLES
class ChatBubble extends StatelessWidget {
  const ChatBubble(this.message, {super.key});
  final Message message;

  @override
  Widget build(BuildContext context) {
    return SwipeTo(
      animationDuration: const Duration(milliseconds: 700),
      onLeftSwipe: (details) {
        showAboutDialog(context: context,
          applicationName: "WhatsApp Clone",
        );
      },
    child: _buildBubble(context),
    );
  }

  Widget _buildBubble(context) {
    switch (message.type) {
    case MessageType.image:
    return BubbleNormalImage(
    color: message.senderId == FirebaseAuth.instance.currentUser!.uid
    ? messageColor
        : senderMessageColor,
    id: message.messageId,
    isSender: message.senderId == FirebaseAuth.instance.currentUser!.uid,
    image: CachedNetworkImage(
    imageUrl: message.text,
    ),
    onTap: () {
    log('Tapped');
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => MediaScreen(
    user: message.senderId,
    timeSent: message.timeSent,
    imageUrl: message.text,
    message: message.text,
    ),
    ));
    },
    );
    case MessageType.video:
    return BubbleNormalImage(
    color: message.senderId == FirebaseAuth.instance.currentUser!.uid
    ? messageColor
        : senderMessageColor,
    id: message.messageId,
    isSender:
    message.senderId == FirebaseAuth.instance.currentUser!.uid,
    image: VideoItem(
    videoUrl: message.text,
    ),
    onTap: () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => MediaScreen(
    user: message.senderId,
    timeSent: message.timeSent,
    videoUrl: message.text,
    message: message.text,
    ),
    ));
    });
    case MessageType.audio:
    final player = AudioPlayer();
    player.setSourceUrl(message.text);
    return StatefulBuilder(builder: (context, setState) {
    var duration = 0.0;
    player.getDuration().then((value) {
    setState(() {
    duration = value?.inSeconds.toDouble() ?? 0.0;
    });
    });
    return BubbleNormalAudio(
    duration: duration,
    onSeekChanged: (value) {
    player.seek(Duration(seconds: value.toInt()));
    },
    isPlaying: player.state == PlayerState.playing,
    onPlayPauseButtonClick: () async {
    if (player.state != PlayerState.playing) {
    await player.resume();
    } else {
    await player.pause();
    }
    },
    isSender:
    message.senderId == FirebaseAuth.instance.currentUser!.uid,
    color: message.senderId == FirebaseAuth.instance.currentUser!.uid
    ? messageColor
        : senderMessageColor,
    textStyle: const TextStyle(
    fontSize: 16,
    color: Colors.white,
    ),
    );
    });
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
