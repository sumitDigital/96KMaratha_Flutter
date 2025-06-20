import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppCloseScreen extends StatelessWidget {
  const AppCloseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child: Center(
        child: Text("APP Close Screen"),
      )),
    );
  }
}
