import 'package:flutter/material.dart';

class verificationTag extends StatelessWidget {
  const verificationTag({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 20, width: 20, child: Image.asset("assets/verified1.png"),);
  }
}