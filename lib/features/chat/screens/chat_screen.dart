import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/router/router.dart';
import 'package:whatsapp_clone/styles/app_theme.dart';
import 'chat_list.dart';
import 'package:timeago/timeago.dart';

import '../widgets/chat_text_field.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.name, required this.uid});

  final String name;
  final String uid;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final isEmojisVisible = ValueNotifier<bool>(false);
  final showMicButton = ValueNotifier<bool>(true);
  final messageController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void dispose() {
    messageController.dispose();
    isEmojisVisible.dispose();
    showMicButton.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        titleSpacing: 0,
        title: StreamBuilder<UserModel>(
          stream: ref.read(authControllerProvider).getUserById(widget.uid),
          builder: (context, snapshot) {
            return ListTile(
              onTap: () {
                context.push(
                  AppRoutes.profile,
                  extra: snapshot.data,
                );
              },
              title: Text(
                widget.name,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(snapshot.data?.isOnline == true
                  ? 'En línea'
                  : snapshot.data?.lastSeen != null
                      ? 'Últ. vez ${format(snapshot.data!.lastSeen!)}'
                      : ''),
              leading: CircleAvatar(
                backgroundImage: snapshot.data?.profilePic != null
                    ? CachedNetworkImageProvider(
                        snapshot.data!.profilePic!,
                      )
                    : null,
                radius: 20,
                foregroundColor: Colors.white,
                backgroundColor: Colors.grey,
                child: const Icon(Icons.person),
              ),
            );
          },
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.videocam_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/backgroundImage.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: ChatList(widget.uid),
              ),
              ChatTextField(
                messageController: messageController,
                onEmojiIconPressed: () =>
                    isEmojisVisible.value = !isEmojisVisible.value,
                onSendPressed: () {
                  final message = messageController.text.trim();
                  if (message.isNotEmpty) {
                    ref.read(chatControllerProvider).sendTextMessage(
                          text: messageController.text,
                          recieverUserId: widget.uid,
                        );
                    messageController.clear();
                  } else {
                    Fluttertoast.showToast(
                        msg: 'No puedes enviar un mensaje vacío');
                  }
                },
              ),
              ValueListenableBuilder(
                valueListenable: isEmojisVisible,
                builder: (context, isVisible, child) => Offstage(
                  offstage: !isVisible,
                  child: EmojiPicker(
                    textEditingController: messageController,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
