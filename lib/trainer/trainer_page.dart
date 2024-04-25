import 'package:drawing_trainer/app_bar/app_bar_widget.dart';
import 'package:drawing_trainer/trainer/drawing_phase.dart';
import 'package:drawing_trainer/trainer/drawing_response.dart';
import 'package:drawing_trainer/trainer/drawing_result.dart';
import 'package:drawing_trainer/trainer/generating_phase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class TrainerPage extends StatefulWidget {
  const TrainerPage({super.key});

  @override
  State<StatefulWidget> createState() => _TrainerPageState();

}

class _TrainerPageState extends State<TrainerPage>  {

  String phase = 'generating';
  late String generatedObject;
  late String imagePath;
  late DrawingResponse drawingResponse;


  void _setPhaseToDrawing(){
    setState(() {
      phase = 'drawing';
    });
  }

  void _setGeneratedObject(String object){
    setState(() {
      generatedObject = object;
    });
  }
  void _setImagePath(String imagePath){
    setState(() {
      this.imagePath = imagePath;
    });
  }
  void _setDrawingResponse(DrawingResponse drawingResponse){
    setState(() {
      this.drawingResponse = drawingResponse;
      phase = 'result';
    });
  }
  void _restart(){
    setState(() {
      phase = 'generating';
    });
      print(phase);
  }
  Widget _renderBody() {
    if (phase == 'generating') {
      return GeneratingPhase(setPhaseToDrawing: _setPhaseToDrawing, setGeneratedObject: _setGeneratedObject);
    }
    else if(phase == 'drawing'){
      return DrawingPhase(generatedObject: generatedObject, setImagePath: _setImagePath, setDrawingResponse: _setDrawingResponse);
    }
    else{
      return DrawingResult(drawingResponse: drawingResponse, imagePath: imagePath, objectName: generatedObject, restart: _restart,);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: AppLocalizations.of(context)!.appTitle),
      body: _renderBody(),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
