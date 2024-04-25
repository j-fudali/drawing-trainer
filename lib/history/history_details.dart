import 'package:drawing_trainer/app_bar/app_bar_widget.dart';
import 'package:drawing_trainer/shared/drawing_summary.dart';
import 'package:drawing_trainer/trainer/drawing_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryDetails extends StatelessWidget {
  final String objectImage;
  final String objectName;
  final DrawingResponse drawingResponse;
  const HistoryDetails(
      {super.key,
      required this.objectImage,
      required this.objectName,
      required this.drawingResponse});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: objectName[0].toUpperCase() +
              objectName.substring(1).toLowerCase(),
        ),
        body: DrawingSummary(
            upperWidget: _renderUpperWidget(context),
            drawingResponse: drawingResponse,
            imagePath: objectImage,
            objectName: objectName));
  }

  Widget _renderUpperWidget(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${drawingResponse.isValid ? AppLocalizations.of(context)!.historyUpperTextCorrect : AppLocalizations.of(context)!.historyUpperTextWrong} ${objectName.toLowerCase()}",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              Icon(
                drawingResponse.isValid ? Icons.done : Icons.close,
                color: Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 10),
          RichText(
              text: TextSpan(
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  children: [
                TextSpan(
                    text: drawingResponse.rate.toString(),
                    style: const TextStyle(fontWeight: FontWeight.w900)),
                const TextSpan(text: "/100")
              ])),
        ]));
  }
}
