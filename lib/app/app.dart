import 'package:drawing_trainer/history/history_page.dart';
import 'package:flutter/material.dart';

import '../camera/camera_page.dart';


class App extends StatefulWidget {
  final ThemeData lightTheme;
  final ThemeData darkTheme;

  const App({super.key, required this.lightTheme, required this.darkTheme});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int selectedPageIndex = 0;
  final screens = [
    const CameraPage(),
    const HistoryPage()
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drawing Trainer',
      themeMode: ThemeMode.system,
      theme: widget.lightTheme,
      home: _renderBody(context),
      darkTheme: widget.darkTheme,
    );
  }

  Widget _renderBody(BuildContext context){
    return Scaffold(
      body: screens[selectedPageIndex],
      bottomNavigationBar: _renderNavigationBar()
    );
  }
  Widget _renderNavigationBar(){
    return NavigationBar(
      selectedIndex: selectedPageIndex,
      destinations: const <Widget>[
        NavigationDestination(icon: Icon(Icons.draw_outlined), label: 'Trainer'),
        NavigationDestination(icon: Icon(Icons.history_outlined), label: 'History')
      ],
      onDestinationSelected: (int index){
        setState(() {
          selectedPageIndex = index;
        });
      },
    );
  }
   @override
  void initState() {
    super.initState();
  }

}