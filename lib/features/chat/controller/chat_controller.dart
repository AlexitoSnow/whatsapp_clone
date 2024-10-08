import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:whatsapp_clone/common/enums/message_type.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/chat/repository/chat_repository.dart';
import 'package:whatsapp_clone/models/chat_contact.dart';
import 'package:whatsapp_clone/models/message.dart';

final chatControllerProvider = Provider(
  (ref) => ChatController(
    chatRepository: ref.watch(chatRepositoryProvider),
    ref: ref,
  ),
);

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({required this.chatRepository, required this.ref});

  Stream<List<ChatContact>> getChatContacts() {
    return chatRepository.getChatContacts();
  }

  void sendTextMessage({
    required String text,
    required String recieverUserId,
  }) {
    ref.read(userDataProvider).whenData(
      (user) async {
        final response = await chatRepository.sendTextMessage(
          text: text,
          recieverUserId: recieverUserId,
          senderUser: user!,
          isGroupChat: false,
        );
        if (response != null) {
          Fluttertoast.showToast(msg: response);
        }
      },
    );
  }

  Future<void> cleanChat(String recieverUserId) async {
    final response = await chatRepository.cleanChat(recieverUserId);
    Fluttertoast.showToast(msg: response ?? 'Chat vaciado correctamente');
  }

  void sendFileMessage({
    required File file,
    required String recieverUserId,
    required MessageType messageType,
  }) {
    ref.read(userDataProvider).whenData(
      (user) async {
        final response = await chatRepository.sendFileMessage(
          file: file,
          recieverUserId: recieverUserId,
          messageType: messageType,
          senderUserData: user!,
          isGroupChat: false,
          ref: ref,
        );
        if (response != null) {
          Fluttertoast.showToast(msg: response);
        }
      },
    );
  }

  Stream<List<Message>> getMessages(String recieverUserId) {
    return chatRepository.getChatStream(recieverUserId);
  }
}
