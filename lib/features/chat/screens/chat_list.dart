import 'dart:developer';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/models/message.dart';
import 'package:whatsapp_clone/styles/app_theme.dart';

class ChatList extends ConsumerStatefulWidget {
  const ChatList(this.recieverUserId, {super.key});
  final String recieverUserId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream: ref
            .watch(chatControllerProvider)
            .getMessages(widget.recieverUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          SchedulerBinding.instance.addPostFrameCallback(
            (_) => scrollController
                .jumpTo(scrollController.position.maxScrollExtent),
          );
          final messages = snapshot.data!;
          return GroupedListView(
            physics: const ClampingScrollPhysics(),
            controller: scrollController,
            elements: messages,
            groupBy: (element) => DateFormat('yyyy-MM-dd HH:00')
                .format(element.timeSent), // Agrupa por día
            groupSeparatorBuilder: (String date) =>
                DateChip(date: DateTime.parse(date)), // Formatea la fecha
            indexedItemBuilder: (context, message, index) {
              log('Message Retrieved: ${messages[index].messageId}',
                  name: 'ChatList');
              return BubbleSpecialOne(
                text: message.text,
                isSender:
                    message.senderId == FirebaseAuth.instance.currentUser!.uid,
                color:
                    message.senderId == FirebaseAuth.instance.currentUser!.uid
                        ? messageColor
                        : senderMessageColor,
                textStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                seen: message.isSeen,
                //TODO: Acomodar la burbuja de mensaje cuando un usuario envia varios mensajes seguidos
              );
            },
          );
        });
  }
}
