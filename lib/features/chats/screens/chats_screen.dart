import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  final ValueNotifier<int> currentChatState = ValueNotifier(0);
  final chatState = ['Todos', 'No leídos', 'Favoritos', 'Grupos'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.contacts),
        child: const Icon(Icons.comment),
      ),
      appBar: AppBar(
        title: const Text(
          'WhatsApp',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined),
            onPressed: () {},
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                child: Text('Nuevo grupo'),
              ),
              const PopupMenuItem(
                child: Text('Nueva difusión'),
              ),
              const PopupMenuItem(
                child: Text('Dispositivos vinculados'),
              ),
              const PopupMenuItem(
                child: Text('Mensajes destacados'),
              ),
              PopupMenuItem(
                child: const Text('Ajustes'),
                onTap: () => context.push(AppRoutes.settings),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight * 2),
          child: Column(
            children: [
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Preguntar a Meta AI o buscar',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              SizedBox(
                height: kToolbarHeight,
                width: double.infinity,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: chatState.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    return ValueListenableBuilder(
                        valueListenable: currentChatState,
                        builder: (context, value, child) {
                          return InputChip(
                            labelStyle: TextStyle(
                              fontSize: 14,
                              color:
                                  value == index ? Colors.green : Colors.grey,
                            ),
                            label: Text(chatState[index]),
                            onSelected: (value) =>
                                currentChatState.value = index,
                            selected: value == index,
                            showCheckmark: false,
                            selectedColor: Colors.greenAccent,
                            disabledColor: Colors.blueGrey,
                          );
                        });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: const ChatsList(),
    );
  }
}
