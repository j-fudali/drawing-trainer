import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawing_trainer/trainer/drawing_response.dart';
import 'package:drawing_trainer/util/firebase_utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DrawingPhase extends StatefulWidget {
  final String generatedObject;
  final Function(String object) setImagePath;
  final Function(DrawingResponse object) setDrawingResponse;

  const DrawingPhase({super.key, required this.generatedObject, required this.setImagePath, required this.setDrawingResponse});

  @override
  State<DrawingPhase> createState() => _DrawingPhaseState();


}

class _DrawingPhaseState extends State<DrawingPhase>
    with WidgetsBindingObserver {
  final ref =
      FirebaseFirestore.instance.collection(dotenv.env['DB_NAME_RATE']!);
  final storageRef = FirebaseStorage.instance.ref();
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  bool cameraInitialized = false;
  String? imagePath;
  String? imageName;
  bool loadingResult = false;

  void _makePhoto() async {
    try {
      await _initializeControllerFuture;
      final image = await _cameraController.takePicture();
      if (!mounted) return;
      setState(() {
        imagePath = image.path;
        widget.setImagePath(image.path);
        imageName = image.name;
      });
    } catch (e) {
      print(e);
    }
  }


  void _acceptImage() async {
    try {
      setState(() {
        loadingResult = true;
      });
      final imagesRef = storageRef.child("images/${widget.generatedObject + DateTime.now().microsecond.toString()}.jpg");
      var gsFile = await imagesRef.putFile(File(imagePath!), SettableMetadata(contentType: 'image/jpeg'));
      final fileUrl = dotenv.env["IMAGES_STORAGE"]! + gsFile.ref.fullPath;
      final publicUrl = await imagesRef.getDownloadURL();
      final prompt = AppLocalizations.of(context)!.resultsPrompt(widget.generatedObject);
      final docRef = await ref.add({"prompt": prompt, "image": fileUrl});
      final prefs = await SharedPreferences.getInstance();
      var history = prefs.getStringList('history');
      if(history != null) {
        history.add(docRef.id);
      } else {
        history = [docRef.id];
      }
      await prefs.setStringList('history', history);
      docRef.snapshots().listen((event) {
        var output = event.data()!['output'] as String?;
        if (output != null) {
          setState(() {
            loadingResult = false;
          });
          final drawingResponseMap = FirebaseUtils.getJsonFromOutput(output);
          final drawingResponse = DrawingResponse.fromJson(drawingResponseMap);
          widget.setDrawingResponse(drawingResponse);
        }
      });
      await docRef.update({"object": widget.generatedObject, "publicImage": publicUrl});
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera(_cameraController.description);
    }
  }

  void _initCamera(CameraDescription cameraDescription) async {
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.max);
    _initializeControllerFuture = _cameraController.initialize();
    await _initializeControllerFuture;
    await _cameraController.setFlashMode(FlashMode.off);
    if (!mounted) {
      return;
    }
      setState(() => cameraInitialized = true);
  }

  Widget _renderCameraPreview() {
    if (cameraInitialized) {
      return Positioned.fill(
        child:
        AspectRatio(
          aspectRatio: _cameraController.value.aspectRatio ,
          child: CameraPreview(_cameraController),
        ),
      );
    }
    return const Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() async {
    super.dispose();
    await _cameraController.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          imagePath != null
              ? Image.file(File(imagePath!),
            alignment: Alignment.center,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          )
              : _renderCameraPreview(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Chip(label: Text(widget.generatedObject[0].toUpperCase()+widget.generatedObject.substring(1).toLowerCase() )),
              ),
              Container(
                  alignment: Alignment.bottomCenter,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: imagePath != null
                      ? loadingResult ? const CircularProgressIndicator() :Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton.filled(
                                onPressed: () => _acceptImage(),
                                icon: const Icon(Icons.check)),
                            const SizedBox(
                              width: 20,
                            ),
                            IconButton.outlined(
                                onPressed: () async {
                                  await _initializeControllerFuture;
                                  setState(() {
                                    imagePath = null;
                                  });
                                },
                                icon: const Icon(Icons.replay)),
                          ],
                        )
                      : IconButton.outlined(
                          onPressed: () => _makePhoto(),
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
