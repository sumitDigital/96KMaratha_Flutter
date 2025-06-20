import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:http/http.dart' as http;
import 'package:_96kuliapp/screens/auth_Screens/registerOTPScreen.dart';
import 'package:_96kuliapp/screens/plans/upgradeScreen.dart';
import 'package:_96kuliapp/screens/userInfoForms/userInfoStepOne.dart';
import 'package:_96kuliapp/screens/userInfoForms/userInfoStepTwo.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepFour.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepThree.dart';
import 'package:_96kuliapp/utils/bottomnavBar.dart';

class UpdatePasswordController extends GetxController {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  var isloading = false.obs;
  Future<void> newPasswordUpdate({
    required String password,
  }) async {
    // The API URL where you want to send the POST request

    isloading.value = true;
    String url = '${Appconstants.baseURL}/api/new-password';

    // The request body
    Map<String, dynamic> body = {
      "password": password,
    };

    try {
      String? token = sharedPreferences!.getString("token");
      print("Token is $token");
      // Sending the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );
      print("Response Body is ${response.body}");
      if (response.statusCode == 200) {
        // Handle success
        print('Registration successful');
        // You can handle the response data here
        var data = jsonDecode(response.body);
        sharedPreferences!.setString("token", data["token"]);

        var pagename = data["redirect"]["pagename"];
        // Handle success (e.g., navigate to the next screen)
        print("Login data  ${data["redirect"]["pagename"]}");
        if (pagename == "OTP-VERIFICATION") {
          sharedPreferences!.setString("PageIndex", "1");
// Get.offAllNamed(AppRouteNames.registerOTPScreen);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const RegisterOTPScreen(),
            ),
            (route) => false,
          );
        } else if (pagename == "BASIC-INFO") {
          sharedPreferences!.setString("PageIndex", "2");
          print("Shared pref ${sharedPreferences?.getString("PageIndex")}");

// Get.offAllNamed(AppRouteNames.userInfoStepOne);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const UserInfoStepOne(),
            ),
            (route) => false,
          );
        } else if (pagename == "EDUCATION-CAREER") {
          sharedPreferences!.setString("PageIndex", "3");

          // Get.offAllNamed(AppRouteNames.userInfoStepTwo);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const UserInfoStepTwo(),
            ),
            (route) => false,
          );
        } else if (pagename == "PARTNER") {
          sharedPreferences!.setString("PageIndex", "4");

// Get.offAllNamed(AppRouteNames.userInfoStepThree);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const UserInfoStepThree(),
            ),
            (route) => false,
          );
        } else if (pagename == "PHOTOS") {
          sharedPreferences!.setString("PageIndex", "5");

          // Get.offAllNamed(AppRouteNames.userInfoStepFour);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const UserInfoStepFour(),
            ),
            (route) => false,
          );
        } else if (pagename == "DASHBOARD") {
          sharedPreferences!.setString("PageIndex", "8");

          //  Get.offAllNamed(AppRouteNames.bottomNavBar);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const BottomNavBar(),
            ),
            (route) => false,
          );
        } else if (pagename == "PLAN") {
          sharedPreferences!.setString("PageIndex", "9");

          //  Get.offAllNamed(AppRouteNames.bottomNavBar);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const UpgradePlan(),
            ),
            (route) => false,
          );
        } else {
          sharedPreferences!.setString("PageIndex", "8");

          //    Get.offAllNamed(AppRouteNames.bottomNavBar);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const BottomNavBar(),
            ),
            (route) => false,
          );
        }
      } else {
        // errordata.value = jsonDecode(response.body);
        //  print("Error data is ${errordata}");

        // Handle error
        print('Failed to register: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
    } finally {
      isloading.value = false;
    }
  }

  var hidePassword = false.obs;

  void alterPasswordVisiblity() {
    hidePassword.value = !hidePassword.value;
  }
}
