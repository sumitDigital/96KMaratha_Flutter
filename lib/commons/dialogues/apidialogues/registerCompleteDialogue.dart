// Initial link:
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Registercompletedialogue extends StatelessWidget {
  const Registercompletedialogue({super.key});

  @override
  Widget build(BuildContext context) {
    // Close the dialog after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      Get.back();
    });

    return Dialog(
      backgroundColor:
          Colors.transparent, // Makes the dialog background transparent
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 330, // Restrict the dialog height
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/registerComplete.png"),
              fit: BoxFit
                  .contain, // Ensure the image scales within the container
            ),
          ),
        ),
      ),
    );
  }
}
