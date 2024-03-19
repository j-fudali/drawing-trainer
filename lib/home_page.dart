
import 'package:camera/camera.dart';
import 'package:drawing_trainer/camera_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _renderBody(context)
    );
  }
  Widget _renderBody(BuildContext context){
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Drawing Trainer",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            ElevatedButton(
                onPressed: () async => await availableCameras().then((value) =>
                    Navigator.push
                  (context, MaterialPageRoute(builder: (context) => CameraPage(value))),
                ),
                child: const Text("Start")
            )
          ],
        )
    );
  }
}
