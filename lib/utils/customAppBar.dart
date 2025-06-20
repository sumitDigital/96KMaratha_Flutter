import 'package:flutter/material.dart';

class CustomMainAppBar extends StatelessWidget implements PreferredSizeWidget{
  const CustomMainAppBar({super.key, required this.title});
  final String title;
  @override
  Size get preferredSize =>  const Size.fromHeight(60.0);
  @override
  Widget build(BuildContext context) {
    return ClipRRect( borderRadius: const BorderRadius.only( bottomLeft:  Radius.circular(15) , bottomRight: Radius.circular(15) ), 
    child:  AppBar(
      title: Text(title, style: const TextStyle(color: Colors.white),),
    iconTheme: const IconThemeData(color: Colors.white),
     backgroundColor: Theme.of(context).appBarTheme.backgroundColor,));
  }
}