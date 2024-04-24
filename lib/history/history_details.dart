import 'package:cached_network_image/cached_network_image.dart';
import 'package:drawing_trainer/app_bar/app_bar_widget.dart';
import 'package:drawing_trainer/camera/drawing_response.dart';
import 'package:drawing_trainer/shared/tips_list.dart';
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
          title:objectName[0].toUpperCase()+objectName.substring(1).toLowerCase(),
        ),
        body: _renderBody(context));
  }

  Widget _renderBody(BuildContext context) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: objectImage,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${drawingResponse.isValid ? AppLocalizations.of(context)!.historyUpperTextCorrect : AppLocalizations.of(context)!.historyUpperTextWrong} ${objectName.toLowerCase()}",
                      style: const TextStyle(color: Colors.white, fontSize: 16),),
                    Icon(drawingResponse.isValid ? Icons.done : Icons.close, color: Colors.white,),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                          text: TextSpan(
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                              children: [
                                TextSpan(
                                    text: drawingResponse.rate.toString(),
                                    style:
                                    const TextStyle(fontWeight: FontWeight.w900)),
                                const TextSpan(text: "/100")
                              ])),
                    ],
                  ),
                ),
              ],
            ),
            TipsList(drawingResponse: drawingResponse)
          ],
        )
      ],
    );
  }
}
