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
  });

  final TextEditingController messageController;
  final VoidCallback? onEmojiIconPressed;
  final VoidCallback? onAttachFilePressed;
  final VoidCallback? onCameraPressed;
  final VoidCallback? onMicPressed;
  final VoidCallback? onSendPressed;
  final Function(String)? onChanged;

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  final ValueNotifier<bool> showMicButton = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              maxLines: null,
              controller: widget.messageController,
              keyboardType: TextInputType.multiline,
              onChanged: (value) {
                widget.onChanged?.call(value);
                showMicButton.value = value.isEmpty;
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: mobileChatBoxColor,
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
                    IconButton(
                      onPressed: widget.onCameraPressed,
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.grey,
                      ),
                    ),
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
