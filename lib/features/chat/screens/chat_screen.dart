import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp_clone/common/enums/message_type.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/router/router.dart';
import 'package:whatsapp_clone/styles/app_theme.dart';
import 'chat_list.dart';
import 'package:timeago/timeago.dart';

import '../widgets/chat_text_field.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen(
      {super.key, required this.name, required this.receiverUserId});

  final String name;
  final String receiverUserId;

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
          stream: ref
              .read(authControllerProvider)
              .getUserById(widget.receiverUserId),
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
                child: ChatList(widget.receiverUserId),
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
                          recieverUserId: widget.receiverUserId,
                        );
                    messageController.clear();
                  } else {
                    Fluttertoast.showToast(
                        msg: 'No puedes enviar un mensaje vacío');
                  }
                },
                onCameraPressed: () => attachFile(pickMediaFromGallery()),
                onAttachFilePressed: () => attachFile(pickFile()),
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

  void sendFileMessage(
    File file,
    MessageType messageType,
  ) {
    ref.read(chatControllerProvider).sendFileMessage(
          file: file,
          recieverUserId: widget.receiverUserId,
          messageType: messageType,
        );
  }

  void attachFile(Future<File?> action) async {
    File? doc = await action;
    if (doc != null) {
      if (mounted) {
        showAdaptiveDialog(
          context: context,
          builder: (context) => AlertDialog.adaptive(
            title: const Text('Adjuntar documento'),
            content: const Text('¿Desea enviar este archivo?'),
            actions: [
              TextButton(
                onPressed: context.pop,
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  context.pop();
                  final extension = doc.path.split('.').last;
                  if (extension == 'mp4') {
                    sendFileMessage(doc, MessageType.video);
                  } else if (extension == 'png' ||
                      extension == 'jpg' ||
                      extension == 'jpeg') {
                    sendFileMessage(doc, MessageType.image);
                  } else {
                    sendFileMessage(doc, MessageType.file);
                  }
                },
                child: const Text('Enviar'),
              ),
            ],
          ),
        );
      }
    }
  }
}
