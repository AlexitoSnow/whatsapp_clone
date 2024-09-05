import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whatsapp_clone/router/router.dart';

class CameraIcon extends StatelessWidget {
  const CameraIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.camera_alt_outlined),
      onPressed: () => context.push(AppRoutes.camera),
    );
  }
}
