import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/styles/app_theme.dart';
import 'package:whatsapp_clone/models/user_model.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key, required this.user});
  final UserModel? user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: backgroundColor,
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey,
                      //backgroundImage:,
                      child: Icon(Icons.person),
                    ),
                    Text(user?.name ?? '~'),
                    Text(user!.phoneNumber),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Icon(Icons.call_outlined),
                                Text('Llamar'),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Icon(Icons.videocam_outlined),
                                Text('Video'),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Icon(Icons.search_outlined),
                                Text('Buscar'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                color: backgroundColor,
                child: const Column(
                  children: [
                    ListTile(
                      title: Text('Notificaciones'),
                      leading: Icon(Icons.notifications_outlined),
                    ),
                    ListTile(
                      title: Text('Visibilidad de archivos multimedia'),
                      leading: Icon(Icons.photo_outlined),
                    ),
                  ],
                ),
              ),
              Container(
                color: backgroundColor,
                child: Column(
                  children: [
                    const ListTile(
                      title: Text('Cifrado'),
                      leading: Icon(Icons.lock_outlined),
                      subtitle: Text(
                        'Los mensajes y llamadas están cifradas de extremo a extremo. Toca para verificarlo.',
                      ),
                    ),
                    const ListTile(
                      title: Text('Mensajes Temporales'),
                      leading: Icon(Icons.timer_outlined),
                      subtitle: Text('Desactivados'),
                    ),
                    ListTile(
                      title: const Text('Restringir chat'),
                      leading: const Icon(Icons.lock_person_outlined),
                      subtitle: const Text(
                        'Restringe y oculta este chat en este dispositivo',
                      ),
                      trailing: Switch(
                        value: true,
                        onChanged: (value) {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
