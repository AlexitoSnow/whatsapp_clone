import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart';
import 'package:whatsapp_clone/styles/app_theme.dart';

class MediaScreen extends ConsumerStatefulWidget {
  const MediaScreen({
    required this.user,
    required this.timeSent,
    this.imageUrl,
    this.videoUrl,
    this.message,
    super.key,
  }) : assert(imageUrl != null || videoUrl != null);

  final String user;
  final DateTime timeSent;
  final String? videoUrl;
  final String? imageUrl;
  final String? message;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MediaScreenState();
}

class _MediaScreenState extends ConsumerState<MediaScreen> {
  final showButtons = ValueNotifier<bool>(true);

  late CachedVideoPlayerPlusController controller;

  @override
  void initState() {
    super.initState();
    if (widget.videoUrl != null) {
      controller = CachedVideoPlayerPlusController.networkUrl(
        Uri.parse(widget.videoUrl!),
        httpHeaders: {'Connection': 'keep-alive'},
        invalidateCacheIfOlderThan: const Duration(minutes: 10),
      )..initialize().then((value) async {
          controller.setVolume(1);
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    if (widget.videoUrl != null) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => showButtons.value = !showButtons.value,
        child: Scaffold(
          body: Stack(
            children: [
              Center(
                child: widget.imageUrl != null
                    ? CachedNetworkImage(imageUrl: widget.imageUrl!)
                    : controller.value.isInitialized
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              CachedVideoPlayerPlus(controller),
                              if (widget.videoUrl != null)
                                ValueListenableBuilder(
                                  valueListenable: showButtons,
                                  builder: (context, visible, child) {
                                    return Visibility(
                                      visible: visible,
                                      child: IconButton(
                                        iconSize: 50,
                                        onPressed: () {
                                          if (controller.value.isPlaying) {
                                            controller.pause();
                                          } else {
                                            controller.play();
                                            showButtons.value = false;
                                          }
                                          setState(() {});
                                        },
                                        icon: Icon(
                                          controller.value.isPlaying
                                              ? Icons.pause_circle
                                              : Icons.play_circle,
                                          color: greyColor,
                                        ),
                                      ),
                                    );
                                  }
                                ),
                            ],
                          )
                        : const CircularProgressIndicator.adaptive(),
              ),
              ValueListenableBuilder(
                  valueListenable: showButtons,
                  builder: (context, visible, child) {
                    return Visibility(
                      visible: visible,
                      child: SizedBox(
                        height: kToolbarHeight,
                        child: AppBar(
                          title: ListTile(
                            title: Text(
                              widget.user,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(format(widget.timeSent)),
                          ),
                          actions: [
                            IconButton(
                              icon: const Icon(Icons.star_border),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.keyboard_double_arrow_right),
                              onPressed: () {},
                            ),
                            PopupMenuButton(
                              itemBuilder: (_) {
                                return [
                                  const PopupMenuItem(
                                    child: Text('Editar'),
                                  ),
                                  const PopupMenuItem(
                                    child: Text('Todos los archivos'),
                                  ),
                                  const PopupMenuItem(
                                    child: Text('Mostrar en el chat'),
                                  ),
                                  const PopupMenuItem(
                                    child: Text('Compartir'),
                                  ),
                                  const PopupMenuItem(
                                    child: Text('Guardar'),
                                  ),
                                  const PopupMenuItem(
                                    child: Text('Crear sticker'),
                                  ),
                                  const PopupMenuItem(
                                    child: Text('Establecer como...'),
                                  ),
                                  const PopupMenuItem(
                                    child: Text('Ver en galería'),
                                  ),
                                  const PopupMenuItem(
                                    child: Text('Rotar'),
                                  ),
                                  const PopupMenuItem(
                                    child: Text('Eliminar'),
                                  ),
                                ];
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              ValueListenableBuilder(
                  valueListenable: showButtons,
                  builder: (context, visible, child) {
                    return Visibility(
                      visible: visible,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: double.infinity,
                          color: Colors.black87,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.message != null) Text(widget.message!),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton.filled(
                                    icon: const Icon(
                                        Icons.emoji_emotions_outlined),
                                    onPressed: () {},
                                  ),
                                  TextButton.icon(
                                    label: const Text('Responde'),
                                    icon: const Icon(Icons.reply),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
