import 'package:drawing_trainer/app_bar/app_bar_widget.dart';
import 'package:drawing_trainer/camera/drawing_phase.dart';
import 'package:drawing_trainer/camera/generating_phase.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<StatefulWidget> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  String appBarTitle = "Drawing Trainer";

  bool drawingPhaseStarted = false;
  late String generatedObject;

  void _setPhaseToDrawing(){
    setState(() {
      drawingPhaseStarted = true;
    });
  }
  void _setGeneratedObject(String object){
    setState(() {
      generatedObject = object;
    });
  }
  Widget _renderBody() {
    if (!drawingPhaseStarted) {
      return GeneratingPhase(setPhaseToDrawing: _setPhaseToDrawing, setGeneratedObject: _setGeneratedObject);
    }
    return DrawingPhase(generatedObject: generatedObject);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: appBarTitle),
      body: _renderBody(),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
