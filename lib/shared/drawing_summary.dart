import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../trainer/drawing_response.dart';

class DrawingSummary extends StatelessWidget {
  final Widget upperWidget;
  final DrawingResponse drawingResponse;
  final String imagePath;
  final String objectName;
  const DrawingSummary(
      {super.key,
      required this.upperWidget,
      required this.drawingResponse,
      required this.imagePath,
      required this.objectName});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _renderImage(),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [upperWidget, _renderTipsList()],
        )
      ],
    );
  }

  Widget _renderImage() {
    return imagePath.startsWith("https://firebasestorage.googleapis.com")
        ? CachedNetworkImage(
            imageUrl: imagePath,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress)),
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          )
        : Image.file(File(imagePath),
            alignment: Alignment.center,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover);
  }
  Widget _renderTipsList(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: drawingResponse.tips!.map((e) => Card(
        elevation: 3,
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Text(e[0].toUpperCase()+e.substring(1).toLowerCase()),
        ),
      )
      ).toList(),
    );
  }
}
