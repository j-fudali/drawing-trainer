import 'dart:io';

import 'package:drawing_trainer/camera/drawing_response.dart';
import 'package:drawing_trainer/shared/tips_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DrawingResult extends StatelessWidget {
  final DrawingResponse drawingResponse;
  final String imagePath;
  final String objectName;
  final Function restart;
  const DrawingResult(
      {super.key,
      required this.drawingResponse,
      required this.imagePath,
      required this.objectName, required this.restart});

  @override
  Widget build(BuildContext context) {
    return Stack(
          children: [
            Image.file(File(imagePath),
                alignment: Alignment.center,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(bottom: 10, top: 10),
                        child: FilledButton.icon(onPressed: (){
                          restart();
                        },
                            icon: const Icon(Icons.restart_alt),
                            label: Text(AppLocalizations.of(context)!.restart)
                        ),
                      ),
                      Chip(
                        avatar: Icon(drawingResponse.isValid ? Icons.done : Icons.close),
                        label: Text(objectName[0].toUpperCase()+objectName.substring(1).toLowerCase()),
                      ),
                      const SizedBox(height: 10,),
                      RichText(
                          text: TextSpan(
                              style: const TextStyle(color: Colors.white, fontSize: 18),
                              children: [
                                TextSpan(
                                    text: drawingResponse.rate.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w900)),
                                const TextSpan(text: "/100")
                              ])),
                    ],
                  ),
                ),
                TipsList(drawingResponse: drawingResponse)
              ],
            )

          ],
    );
  }



}
