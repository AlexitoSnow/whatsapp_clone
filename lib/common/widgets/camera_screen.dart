import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

late List<CameraDescription> cameras;

/// CameraApp is the Main Application.
class CameraScreen extends StatefulWidget {
  /// Default Constructor
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      controller.setFlashMode(FlashMode.off);
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      body: Stack(children: [
        Center(
          child: CameraPreview(controller),
        ),
        SizedBox(
          height: kToolbarHeight,
          child: AppBar(
              leading: IconButton.filled(
                onPressed: context.pop,
                icon: const Icon(Icons.close),
              ),
              actions: [
                IconButton.filled(
                  onPressed: () => controller.setFlashMode(FlashMode.always),
                  icon: const Icon(Icons.flash_off),
                )
              ]),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton.filled(
                onPressed: () {},
                icon: const Icon(Icons.photo_outlined),
              ),
              IconButton.filled(
                onPressed: () async {
                  await controller.takePicture();
                },
                icon: const Icon(Icons.circle),
              ),
              IconButton.filled(
                onPressed: () {},
                icon: const Icon(Icons.switch_camera_outlined),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
