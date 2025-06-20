import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/commons/dialogues/forceblock.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationScreen.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/screens/ProfilePhotoRequestToChange/ProfilePhotoRequestToChangeScreen.dart';
import 'package:_96kuliapp/screens/plans/upgradeScreen.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepSix.dart';
import 'package:http/http.dart' as http;
import 'package:_96kuliapp/utils/bottomnavBar.dart';

class CasteVerificationBlockController extends GetxController {
  var popup = {}.obs;
  String? language = sharedPreferences?.getString("Language");

  Future<void> fetchDataredirect() async {
    String? token = sharedPreferences!.getString("token");
    String url = '${Appconstants.baseURL}/api/redirect?lang=$language';
    print("INSIDE REDIRECT");
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token', // Add token in headers
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Parse and store the JSON data
        final dashboardData = json.decode(response.body);
        //  mybox.put("gender", responsedata["data"]["gender"] );
// print("THIS IS  RESPONSE INSIDE REDIRECT ${apiData}");
        //    sharedPreferences?.setString("token", responsedata["token"]);
        //  print("Login data page name for reg  ${apiData["redirect"]["pagename"]}");
// var pagename = dashboardData["redirect"]["pagename"];
        // Handle success (e.g., navigate to the next screen)

        if (dashboardData["redirection"]["pagename"] == "FORCEPOPUP") {
          Get.dialog(
              barrierColor: Colors.black.withOpacity(
                  0.6), // A lighter black color (using a hex value)

              const ForceBlockDialogue(),
              barrierDismissible: false);
        } else if (dashboardData["redirection"]["pagename"] ==
            "CASTE-VERIFICATION") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const CasteVerificationScreen(),
              ),
              (route) => false,
            );
          });
        } else if (dashboardData["redirection"]["pagename"] ==
            "DOCUMENT-REJECTED") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const UserInfoStepSix(),
              ),
              (route) => false,
            );
          });
        } else if (dashboardData["redirection"]["pagename"] == "PLAN") {
          sharedPreferences!.setString("PageIndex", "9");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const UpgradePlan(),
              ),
              (route) => false,
            );
          });
        } else if (dashboardData["redirection"]["pagename"] == "UPDATE-PHOTO") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const ProfilePhotoRequestToChangeScreen(),
              ),
              (route) => false,
            );
          });
        } else if (dashboardData["redirection"]["pagename"] == "DASHBOARD") {
          sharedPreferences!.setString("PageIndex", "8");

          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const BottomNavBar(),
              ),
              (route) => false,
            );
          });
        }
      } else {
        // Optionally handle errors here
        // Get.snackbar("Error", "Failed to load data from the server");
      }
    } catch (e) {
      // Optionally handle exceptions here
      // Get.snackbar("Error", "Something went wrong. $e");
    } finally {}
  }
}
