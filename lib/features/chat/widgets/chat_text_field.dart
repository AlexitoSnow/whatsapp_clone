import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/styles/app_theme.dart';

class ChatTextField extends StatefulWidget {
  const ChatTextField({
    super.key,
    required this.messageController,
    this.onEmojiIconPressed,
    this.onAttachFilePressed,
    this.onCameraPressed,
    this.onMicPressed,
    this.onSendPressed,
    this.onChanged,
    this.focusNode,
  });

  final TextEditingController messageController;
  final VoidCallback? onEmojiIconPressed;
  final VoidCallback? onAttachFilePressed;
  final VoidCallback? onCameraPressed;
  final VoidCallback? onMicPressed;
  final VoidCallback? onSendPressed;
  final Function(String)? onChanged;
  final FocusNode? focusNode;

  @override
  State<StatefulWidget> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  final ValueNotifier<bool> showMicButton = ValueNotifier<bool>(true);
  final ValueNotifier<bool> showCamButton = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    widget.messageController.addListener(() {
      showMicButton.value = widget.messageController.text.isEmpty;
      if (widget.messageController.text.isNotEmpty) {
        showCamButton.value = false;
      } else {
        showCamButton.value = true;
      }
    });
  }

  @override
  void dispose() {
    showMicButton.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 70,
                  decoration: const BoxDecoration(
                    color: mobileChatBoxColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Stack(
                    children: [
                      const ListTile(
                        title: Text('Contacto'),
                        subtitle: Text('Mensaje'),
                      ),
                      Positioned(
                        right: 0,
                        child: InkWell(
                          onTap: () =>
                              log('CloseEvent', name: 'ChatTextField Reply'),
                          child: const Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),
                ),
                TextField(
                  key: widget.key,
                  focusNode: widget.focusNode,
                  maxLines: null,
                  controller: widget.messageController,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: widget.onChanged,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: mobileChatBoxColor,
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    prefixIcon: IconButton(
                      onPressed: widget.onEmojiIconPressed,
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: Colors.grey,
                      ),
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: widget.onAttachFilePressed,
                          icon: const Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          ),
                        ),
                        ValueListenableBuilder(
                            valueListenable: showCamButton,
                            builder: (context, showCam, child) {
                              return Visibility(
                                visible: showCam,
                                child: IconButton(
                                  onPressed: widget.onCameraPressed,
                                  icon: const Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),
                    hintText: 'Type a message!',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ValueListenableBuilder(
              valueListenable: showMicButton,
              builder: (context, showMic, child) {
                return IconButton.filled(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(messageColor),
                  ),
                  onPressed:
                      showMic ? widget.onMicPressed : widget.onSendPressed,
                  icon: Icon(
                    showMic ? Icons.mic : Icons.send,
                    color: Colors.white,
                  ),
                );
              }),
        ],
      ),
    );
  }
}
