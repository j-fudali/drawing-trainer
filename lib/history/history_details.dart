import 'package:drawing_trainer/app_bar/app_bar_widget.dart';
import 'package:flutter/material.dart';

class HistoryDetails extends StatelessWidget{
  const HistoryDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: "Object name",),
      body: Column(
        children: [
          Image.asset("assets/placeholder.jpg"),
          Text("Details", style: Theme.of(context).primaryTextTheme.titleLarge,)
        ],
      ),
    );
  }

}