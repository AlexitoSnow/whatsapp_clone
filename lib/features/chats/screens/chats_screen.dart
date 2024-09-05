import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp_clone/common/widgets/whatsapp_app_bar.dart';
import 'package:whatsapp_clone/router/router.dart';
import 'package:whatsapp_clone/features/chats/widgets/chats_list.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({
    super.key,
  });

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.contacts),
        child: const Icon(Icons.comment),
      ),
      appBar: const WhatsappAppBar(
        menuItems: [
          PopupMenuItem(
            child: Text('Nuevo grupo'),
          ),
          PopupMenuItem(
            child: Text('Nueva difusión'),
          ),
          PopupMenuItem(
            child: Text('Dispositivos vinculados'),
          ),
          PopupMenuItem(
            child: Text('Mensajes destacados'),
          ),
        ],
        title: 'WhatsApp',
      ),
      body: const ChatsList(),
    );
  }
}
