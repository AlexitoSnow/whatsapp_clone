import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/router/router.dart';
import 'package:whatsapp_clone/styles/app_theme.dart';

class ContactBar extends ConsumerWidget implements PreferredSizeWidget {
  const ContactBar({
    super.key,
    required this.name,
    required this.receiverUserId,
  });

  final String name;
  final String receiverUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: appBarColor,
      titleSpacing: 0,
      title: StreamBuilder<UserModel>(
        stream: ref.read(authControllerProvider).getUserById(receiverUserId),
        builder: (context, snapshot) {
          return ListTile(
            onTap: () {
              context.push(
                AppRoutes.profile,
                extra: snapshot.data,
              );
            },
            title: Text(
              name,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(snapshot.data?.isOnline == true
                ? 'En línea'
                : snapshot.data?.lastSeen != null
                    ? 'Últ. vez ${format(snapshot.data!.lastSeen!)}'
                    : ''),
            leading: CircleAvatar(
              backgroundImage: snapshot.data?.profilePic != null
                  ? CachedNetworkImageProvider(
                      snapshot.data!.profilePic!,
                    )
                  : null,
              radius: 20,
              foregroundColor: Colors.white,
              backgroundColor: Colors.grey,
              child: const Icon(Icons.person),
            ),
          );
        },
      ),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.videocam_outlined),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.call_outlined),
        ),
        PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'view',
              child: Text('Ver contacto'),
            ),
            const PopupMenuItem(
              value: 'search',
              child: Text('Buscar'),
            ),
            const PopupMenuItem(
              value: 'mute',
              child: Text('Silenciar notificaciones'),
            ),
            PopupMenuItem(
              value: 'clean',
              onTap: () =>
                  ref.watch(chatControllerProvider).cleanChat(receiverUserId),
              child: const Text('Vaciar chat'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
