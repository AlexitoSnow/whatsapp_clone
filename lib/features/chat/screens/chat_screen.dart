import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp_clone/common/enums/message_type.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/router/router.dart';
import '../widgets/chat_background.dart';
import '../widgets/contact_bar.dart';
import 'chat_list.dart';

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
  final isRecording = ValueNotifier<bool>(false);
  final messageController = TextEditingController();
  final scrollController = ScrollController();
  final focusNode = FocusNode();
  final soundRecorder = FlutterSoundRecorder();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        isEmojisVisible.value = false;
      }
    });
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status == PermissionStatus.denied) {
      throw RecordingPermissionException('Permiso de grabación denegado');
    }
    await soundRecorder.openRecorder();
  }

  @override
  void dispose() {
    messageController.dispose();
    isEmojisVisible.dispose();
    scrollController.dispose();
    focusNode.dispose();
    isRecording.dispose();
    soundRecorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ContactBar(
        key: const ValueKey('ContactBar'),
        name: widget.name,
        receiverUserId: widget.receiverUserId,
      ),
      body: Stack(
        children: [
          const ChatBackground(),
          Column(
            children: [
              Expanded(
                child: ChatList(widget.receiverUserId),
              ),
              ChatTextField(
                key: const ValueKey('ChatTextField'),
                focusNode: focusNode,
                messageController: messageController,
                onMicPressed: () async {
                  try {
                    final tempDir = await getTemporaryDirectory();
                    var path = '${tempDir.path}/flutter_sound.aac';
                    if (isRecording.value) {
                      await soundRecorder.stopRecorder();
                      sendFileMessage(File(path), MessageType.audio);
                    } else {
                      await soundRecorder.startRecorder(toFile: path);
                    }
                    isRecording.value = !isRecording.value;
                  } catch (e) {
                    Fluttertoast.showToast(msg: e.toString());
                  }
                },
                onEmojiIconPressed: () {
                  isEmojisVisible.value = !isEmojisVisible.value;
                  if (isEmojisVisible.value) {
                    focusNode.unfocus();
                  } else {
                    focusNode.requestFocus();
                  }
                },
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
                //onCameraPressed: () => attachFile(pickMediaFromGallery()),
                onCameraPressed: () async {
                  final response = await Permission.camera.request();
                  if (response != PermissionStatus.denied) {
                    if (context.mounted) {
                      context.push(AppRoutes.camera);
                    }
                  }
                },
                onAttachFilePressed: () => attachFile(pickFile()),
              ),
              ValueListenableBuilder(
                valueListenable: isEmojisVisible,
                builder: (context, isVisible, child) => Offstage(
                  offstage: !isVisible,
                  child: EmojiPicker(
                    textEditingController: messageController,
                    config: const Config(swapCategoryAndBottomBar: true),
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
                  } else if (extension == 'aac') {
                    sendFileMessage(doc, MessageType.audio);
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
