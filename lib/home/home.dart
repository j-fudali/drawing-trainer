import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../trainer/trainer_page.dart';
import '../history/history_page.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedPageIndex = 0;
  final screens = [
    const TrainerPage(),
    const HistoryPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[selectedPageIndex],
        bottomNavigationBar: _renderNavigationBar(context)
    );
  }

  Widget _renderNavigationBar(BuildContext context){
    return NavigationBar(
      selectedIndex: selectedPageIndex,
      destinations: <Widget>[
        NavigationDestination(icon: const Icon(Icons.draw_outlined), label: AppLocalizations.of(context)!.trainer,),
        NavigationDestination(icon: const Icon(Icons.history_outlined), label: AppLocalizations.of(context)!.history)
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