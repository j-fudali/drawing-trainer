import 'package:drawing_trainer/camera/drawing_response.dart';
import 'package:flutter/material.dart';

class TipsList extends StatelessWidget{
  final DrawingResponse drawingResponse;

  const TipsList({super.key, required this.drawingResponse});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _renderTiles(),
    );
    }
  List<Widget> _renderTiles(){
    return drawingResponse.tips!.map((e) => Card(
      elevation: 3,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Text(e[0].toUpperCase()+e.substring(1).toLowerCase()),
      ),
    )
    ).toList();
  }
}