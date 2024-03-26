import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawingPhase extends StatefulWidget {
  final String generatedObject;
  const DrawingPhase({super.key, required this.generatedObject});

  @override
  State<DrawingPhase> createState() => _DrawingPhaseState();
}

class _DrawingPhaseState extends State<DrawingPhase> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;

  void _initCamera(CameraDescription cameraDescription) {
    setState(() {
      _cameraController =
          CameraController(cameraDescription, ResolutionPreset.max);
      _initializeControllerFuture = _cameraController.initialize();
    });
  }

  Widget _renderCameraPreview() {
    return FutureBuilder(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Positioned.fill(
              child: AspectRatio(
                aspectRatio: _cameraController.value.aspectRatio,
                child: CameraPreview(_cameraController),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _renderCameraPreview(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Chip(label: Text(widget.generatedObject)),
              ),
              Container(
                  alignment: Alignment.bottomCenter,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: IconButton.outlined(
                      onPressed: () {},
                      iconSize: 32,
                      padding: const EdgeInsets.all(15),
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                      )))
            ],
          )

        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    availableCameras().then((cameras) {
      _initCamera(cameras.first);
    });
  }
}
