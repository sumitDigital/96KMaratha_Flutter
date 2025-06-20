// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/bottomnavBar.dart';

class PlanInterMediateScreen extends StatelessWidget {
  const PlanInterMediateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String? language = sharedPreferences?.getString("Language");

    return WillPopScope(
      onWillPop: () async {
        // Show the confirmation dialog
        bool? shouldExit = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
              ),
              title: Text(
                language == "en" ? 'Exit App' : "ॲपमधून बाहेर पडा",
                style: CustomTextStyle.bodytextLarge.copyWith(
                  color: Colors.black, // Title color
                  fontWeight: FontWeight.bold, // Bold title
                ),
              ),
              content: Text(
                language == "en"
                    ? 'Do you really want to exit the app?'
                    : "तुम्हाला ॲपमधून बाहेर पडायचे आहे का?",
                style: const TextStyle(
                  fontSize: 16, // Adjusted font size for content
                  color: Colors.black54, // Lighter color for content text
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 10.0), // Padding at the bottom of the buttons
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true); // User wants to exit
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              AppTheme.primaryColor, // White text color
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 12), // Button padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8), // Rounded corners for the button
                          ),
                        ),
                        child: const Text('Yes',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pop(false); // User doesn't want to exit
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              AppTheme.secondryColor, // White text color
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 12), // Button padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8), // Rounded corners for the button
                          ),
                        ),
                        child: const Text('No',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
        return shouldExit ?? false;
      },
      child: Scaffold(
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
                child: Image.asset(height: 25, width: 60, "assets/stars.png")),
            const SizedBox(
              height: 10,
            ),
            const Center(
              child: Text(
                textAlign: TextAlign.center,
                "Fantastic!  Your plan has been activated.",
                style: CustomTextStyle.darkBlueDarkLarge,
              ),
            ),
            Center(
                child: Image.asset(
                    height: 150, width: 150, "assets/PlanIntermediate.png")),
            const SizedBox(
              height: 10,
            ),
            //
            const Center(
              child: Text(
                textAlign: TextAlign.center,
                "Begin enjoying the advanced benefits today!.",
                style: CustomTextStyle.bodytextLarge,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: TextButton(
                onPressed: () async {
                  sharedPreferences!.setString("PageIndex", "8");

                  // Introduce a 2-second delay
                  await Future.delayed(const Duration(seconds: 2));

                  navigatorKey.currentState!.pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const BottomNavBar(),
                    ),
                    (route) => false,
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize
                      .min, // Ensure the Row takes only the required width
                  children: [
                    const Text(
                      "Enjoy benefits now!",
                      textAlign: TextAlign.center,
                      style: CustomTextStyle.textbuttonRedLarge,
                    ),
                    const SizedBox(
                        width:
                            8), // Add some space between the label and the icon
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppTheme.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  } // PlanIntermediate
}
