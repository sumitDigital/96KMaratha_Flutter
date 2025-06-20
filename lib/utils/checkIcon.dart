import 'package:flutter/material.dart';

class IconCheck extends StatelessWidget {
  const IconCheck({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.check, // You can replace this with another icon if needed
      color: Colors.white, // Adjust the color based on your theme
      size: 22, // Adjust the size as needed
    );
  }
}
