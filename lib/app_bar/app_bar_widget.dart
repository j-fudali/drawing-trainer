import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  const AppBarWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
      return AppBar(title: Text(title), centerTitle: true, shadowColor: Colors.black, elevation: 2);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}