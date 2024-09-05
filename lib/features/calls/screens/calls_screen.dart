import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/widgets/whatsapp_app_bar.dart';
import 'package:whatsapp_clone/styles/app_theme.dart';
import 'package:whatsapp_clone/features/contacts/widgets/favorites_list.dart';
import 'package:whatsapp_clone/features/calls/widgets/call_list.dart';

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: tabColor,
        child: const Icon(
          Icons.add_ic_call_outlined,
          color: Colors.white,
        ),
      ),
      appBar: const WhatsappAppBar(
        menuItems: [
          PopupMenuItem(
            child: Text('Borrar registro de llamadas'),
          ),
        ],
        title: 'Llamadas',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: const Text('Favoritos'),
              trailing: TextButton(
                onPressed: () {},
                child: const Text('Más'),
              ),
            ),
            const FavoritesList(),
            const ListTile(
              title: Text('Recientes'),
            ),
            const CallList(),
          ],
        ),
      ),
    );
  }
}
