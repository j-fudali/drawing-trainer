import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawing_trainer/app_bar/app_bar_widget.dart';
import 'package:drawing_trainer/camera/drawing_response.dart';
import 'package:drawing_trainer/history/history_details.dart';
import 'package:drawing_trainer/util/firebase_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget{
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final ref = FirebaseFirestore.instance.collection(dotenv.env["DB_NAME_RATE"]!);
  List<String> resultsLinks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: "History"),
      body: _renderBody()
    );
  }
  Widget _renderBody(){
    return resultsLinks.isNotEmpty ?
        FutureBuilder(future: _renderList(), builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          else if (snapshot.hasError){
            print(snapshot.error);
            return const Center(child: Text('Something went wrong'),);
          }
          else{
            return ListView.builder(itemCount: snapshot.data!.length, itemBuilder: (context, index) => snapshot.data![index]);
          }
        })
        : const Center(child: Text("No history yet", style: TextStyle(fontSize: 24),));
  }
  void _initHistory () async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      resultsLinks = prefs.getStringList('history') ?? [];
    });
  }
  List<Future<DocumentSnapshot<Map<String, dynamic>>>> _mapDocIdToData(){
    return resultsLinks.map((e){
      final doc = ref.doc(e);
      return doc.get();
    }).toList();
  }
  Future<List<ListTile>> _renderList() async {
    List<ListTile> listTiles = [];
    final data = _mapDocIdToData();
    for(Future<DocumentSnapshot<Map<String, dynamic>>> docFuture in data){
       final tile = await _buildListTile(docFuture);
       listTiles.add(tile);

    }
    return listTiles;
  }

  Future<ListTile> _buildListTile(Future<DocumentSnapshot<Map<String, dynamic>>> docFuture) async {
    final doc = await docFuture;
    final objectImage = doc.get('publicImage');
    final avatar = CachedNetworkImage(
        imageUrl: objectImage,
        imageBuilder: (context, imageProvider) => CircleAvatar(backgroundImage: imageProvider,),
        progressIndicatorBuilder: (context, url, downloadProgress)
        => CircularProgressIndicator(value: downloadProgress.progress));
    final objectName = doc.get('object');
    final status = doc.get('status') as Map<String, dynamic>;
    final timestamp = status['completeTime'] as Timestamp;
    final date = timestamp.toDate();
    final dateFormatted = DateFormat("hh:mm dd-MM-yyyy").format(date).toString();
    final output = doc.get('output');
    final drawingResponseMap = FirebaseUtils.getJsonFromOutput(output);
    final drawingResponse = DrawingResponse.fromJson(drawingResponseMap);
    return ListTile(leading: avatar,
      title: Text(objectName),
      subtitle: Text(dateFormatted),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>
          HistoryDetails(objectName: objectName, objectImage: objectImage, drawingResponse: drawingResponse,))),
    );
  }

  @override
  void initState()  {
    super.initState();
    _initHistory();
  }
}