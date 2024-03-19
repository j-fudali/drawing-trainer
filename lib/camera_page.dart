import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraPage extends StatefulWidget{
  final List<CameraDescription> cameras;
 const CameraPage(this.cameras, {super.key});
  @override
  State<StatefulWidget> createState() => _CameraPageState();

}
class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver{
  late CameraController _cameraController;

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController cameraController = _cameraController;
    if (!cameraController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initCamera(cameraController.description);
    }
  }
  Future initCamera(CameraDescription cameraDescription) async {
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Drawing Trainer")),
      body: _renderBody(),
    );
  }
  Widget _renderBody(){
    if(_cameraController.value.isInitialized){
      return CameraPreview(_cameraController);
    }
    else{
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
  @override
  void initState() {
    super.initState();
    initCamera(widget.cameras[0]);
}
}