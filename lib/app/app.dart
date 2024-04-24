import 'package:drawing_trainer/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class App extends StatefulWidget {
  final ThemeData lightTheme;
  final ThemeData darkTheme;

  const App({super.key, required this.lightTheme, required this.darkTheme});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: widget.lightTheme,
      home: const HomePage(),
      darkTheme: widget.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
    );
  }



}