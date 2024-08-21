//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/contacts/controller/contacts_controller.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList(this.contacts, {super.key});
  final List<Contact> contacts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: contacts.length,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return ListTile(
          onTap: () {
            ref.read(contactsControllerProvider).selectContact(contact);
          },
          title: Text(
            contact.displayName,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          subtitle: const Padding(
            padding: EdgeInsets.only(top: 6.0),
            child: Text(
              // TODO: Get info from whatsapp account
              '',
              style: TextStyle(fontSize: 15),
            ),
          ),
          leading: const CircleAvatar(
            // TODO: Get image from whatsapp account
            //backgroundImage: CachedNetworkImageProvider(),
            radius: 30,
            foregroundColor: Colors.grey,
            child: Icon(Icons.person),
          ),
          // TODO: Only if isn't a WhatsApp user
          trailing: TextButton(
            onPressed: () {},
            child: const Text(
              'Invitar',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ),
        );
      },
    );
  }
}
