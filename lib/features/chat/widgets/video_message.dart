import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/styles/app_theme.dart';

class VideoItem extends StatefulWidget {
  const VideoItem({super.key, required this.videoUrl});

  final String videoUrl;

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late CachedVideoPlayerPlusController controller;
  bool showControls = false;

  @override
  void initState() {
    super.initState();
    controller = CachedVideoPlayerPlusController.networkUrl(
      Uri.parse(widget.videoUrl),
      httpHeaders: {'Connection': 'keep-alive'},
      invalidateCacheIfOlderThan: const Duration(minutes: 10),
    )..initialize().then((value) async {
        controller.setVolume(1);
        setState(() {});
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: controller.value.isInitialized
          ? Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  child: CachedVideoPlayerPlus(controller),
                  onTap: () {
                    setState(() {
                      showControls = !showControls;
                    });
                  },
                ),
                Visibility(
                  visible: showControls,
                  child: IconButton(
                    iconSize: 50,
                    onPressed: () {
                      if (controller.value.isPlaying) {
                        controller.pause();
                      } else {
                        controller.play();
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
                ),
              ],
            )
          : const CircularProgressIndicator.adaptive(),
    );
  }
}
