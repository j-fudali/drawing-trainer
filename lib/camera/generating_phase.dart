import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeneratingPhase extends StatefulWidget{
  final Function setPhaseToDrawing;
  final Function(String object) setGeneratedObject;

  const GeneratingPhase({super.key, required this.setPhaseToDrawing, required this.setGeneratedObject});

  @override
  State<GeneratingPhase> createState() => _GeneratingPhaseState();
}

class _GeneratingPhaseState extends State<GeneratingPhase> {


  final ref = FirebaseFirestore.instance.collection(dotenv.env["DB_NAME_OBJECTS"]!);

  late DocumentReference<Map<String, dynamic>> addedObject;

  late String generatedObjectToDraw;

  bool isObjectGenerated = false;

  bool isObjectLoading = false;


  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          !isObjectGenerated
              ? FloatingActionButton.extended(
            elevation: 10,
            onPressed: (isObjectLoading || isObjectGenerated) ? null : () => _generateObjectToDraw(),
            label: const Text("Generate"),
            icon: const Icon(Icons.shuffle),
          )
              : FloatingActionButton.extended(
            onPressed: () => _startDrawingPhaser(),
            label: const Text("Start drawing"),
            icon: const Icon(Icons.draw),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: <Widget>[
                  !isObjectGenerated
                      ? const Text("Prepare pencil and paper to draw")
                      : const SizedBox.shrink(),
                  isObjectGenerated
                      ? const Text("Generated object is: ")
                      : const SizedBox.shrink(),
                  const SizedBox(
                    height: 20,
                  ),
                  _renderGeneratedObject()
                ],
              )),
        ],
      ),
    );
  }

  void _generateObjectToDraw() async {
    const prompt =
        'Return a one random object that human can draw on a piece of paper';
    addedObject = await ref.add({"prompt": prompt});
    setState(() {
      isObjectLoading = true;
    });
    ref.doc(addedObject.id).snapshots().listen((event) {
      setState(() {
        generatedObjectToDraw = event.get('response');
        isObjectLoading = false;
        isObjectGenerated = true;
      });
      widget.setGeneratedObject(generatedObjectToDraw);
    });
  }

  Widget _renderGeneratedObject() {
    if (isObjectLoading) {
      return const CircularProgressIndicator();
    }
    if (isObjectGenerated) {
      return Chip(label: Text(generatedObjectToDraw));
    }
    return const SizedBox.shrink();
  }

  void _startDrawingPhaser() {
    widget.setPhaseToDrawing();
  }
}