import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';

class VideoItem extends StatefulWidget {
  const VideoItem({super.key, required this.videoUrl});

  final String videoUrl;

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late CachedVideoPlayerPlusController controller;
  bool showControls = true;

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
          ? CachedVideoPlayerPlus(controller)
          : const CircularProgressIndicator.adaptive(),
    );
  }
}
