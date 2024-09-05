import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp_clone/router/router.dart';

import 'camera_icon.dart';

class WhatsappAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WhatsappAppBar({
    super.key,
    this.menuItems,
    this.onSearch,
    required this.title,
  });

  final List<PopupMenuItem>? menuItems;
  final VoidCallback? onSearch;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: false,
      actions: [
        const CameraIcon(),
        if (onSearch != null)
          IconButton(
            onPressed: onSearch,
            icon: const Icon(
              Icons.search,
            ),
          ),
        PopupMenuButton(
          itemBuilder: (context) => [
            ...?menuItems,
            PopupMenuItem(
              child: const Text('Ajustes'),
              onTap: () => context.push(AppRoutes.settings),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
