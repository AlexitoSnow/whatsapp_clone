import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/features/contacts/controller/contacts_controller.dart';
import 'package:whatsapp_clone/models/chat_contact.dart';
import 'package:whatsapp_clone/router/router.dart';
import 'package:intl/intl.dart';

class ChatsList extends ConsumerWidget {
  const ChatsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<ChatContact>>(
        stream: ref.watch(chatControllerProvider).getChatContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text('No chats available'),
            );
          }
          var contacts = ref.watch(getContactsProvider).when<List<Contact>>(
                data: (data) => data,
                loading: () => [],
                error: (error, _) => [],
              );
          return ListView.separated(
            shrinkWrap: true,
            itemCount: snapshot.data?.length ?? 0,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final chatContact = snapshot.data![index];
              final contact = contacts.indexWhere((element) =>
                  element.phones.firstOrNull?.normalizedNumber ==
                  chatContact.phone);
              return ChatContactTile(
                contactName: contact == -1
                    ? chatContact.phone
                    : contacts[contact].displayName,
                lastMessage: chatContact.lastMessage,
                avatarUrl: chatContact.profilePic,
                timeSent: chatContact.timeSent,
                onSelected: () => context.push(AppRoutes.chat, extra: {
                  'name': contact == -1
                      ? chatContact.phone
                      : contacts[contact].displayName,
                  'uid': chatContact.contactId,
                }),
              );
            },
          );
        });
  }
}

class ChatContactTile extends StatelessWidget {
  const ChatContactTile({
    super.key,
    required this.contactName,
    required this.lastMessage,
    required this.avatarUrl,
    required this.timeSent,
    this.onSelected,
  });

  final VoidCallback? onSelected;
  final String contactName;
  final String lastMessage;
  final String? avatarUrl;
  final DateTime timeSent;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onSelected,
      title: Text(contactName),
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.done_all),
          Expanded(
            child: Text(
              lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      leading: CircleAvatar(
        backgroundImage: avatarUrl != null
            ? CachedNetworkImageProvider(
                avatarUrl!,
              )
            : null,
        radius: 25,
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey,
        child: avatarUrl == null ? const Icon(Icons.person) : null,
      ),
      trailing: Text(
        DateFormat('HH:mm').format(timeSent),
      ),
    );
  }
}
