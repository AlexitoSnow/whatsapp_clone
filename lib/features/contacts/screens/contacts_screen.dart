import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/contacts/widgets/contacts_list.dart';

import '../controller/contacts_controller.dart';

class ContactsScreen extends ConsumerWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var contacts = ref.watch(getContactsProvider).when<List<Contact>>(
          data: (data) => data,
          loading: () => [],
          error: (error, _) => [],
        );
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: const Text('Contactos'),
          subtitle: Text('${contacts.length} contactos'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.group_add),
              ),
              title: const Text('Nuevo grupo'),
              onTap: () {},
            ),
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person_add),
              ),
              title: const Text('Nuevo contacto'),
              trailing: const Icon(Icons.qr_code),
              onTap: () {},
            ),
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.groups),
              ),
              title: const Text('Nueva comunidad'),
              onTap: () {},
            ),
            ContactsList(contacts),
            // TODO: Filtrar contactos y dividirlos en los que son de whatsapp y los que no
            const ListTile(
              title: Text('Contactos en WhatsApp'),
            ),
            const ListTile(
              title: Text('Invitar a WhatsApp'),
            ),
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.groups),
              ),
              title: const Text('Nueva comunidad'),
              onTap: () {},
            ),
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.share),
              ),
              title: const Text('Compartir enlace de invitación'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Ayuda'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
