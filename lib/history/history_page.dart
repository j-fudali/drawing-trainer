import 'package:drawing_trainer/app_bar/app_bar_widget.dart';
import 'package:drawing_trainer/history/history_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget{
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String nowStr = DateFormat("dd.MM.yyyy").format(now);
    return Scaffold(
      appBar: const AppBarWidget(title: "History"),
      body: ListView(children:  [
        ListTile(title: Text("1. Draw name", style: Theme.of(context).textTheme.titleLarge,),subtitle: Text(nowStr,), onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryDetails()));
        },),
        ListTile(title: Text("2. Draw name", style: Theme.of(context).textTheme.titleLarge,),subtitle: Text(nowStr,), onTap: () => {},),
        ListTile(title: Text("3. Draw name", style: Theme.of(context).textTheme.titleLarge,),subtitle: Text(nowStr,), onTap: () => {},),
        ListTile(title: Text("4. Draw name", style: Theme.of(context).textTheme.titleLarge,),subtitle: Text(nowStr,), onTap: () => {},),
        ListTile(title: Text("5. Draw name", style: Theme.of(context).textTheme.titleLarge,),subtitle: Text(nowStr,), onTap: () => {},),

      ],),
    );
  }
}