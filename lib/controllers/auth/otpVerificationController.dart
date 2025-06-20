import 'dart:convert';

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/userInfoForms/userInfoStepOne.dart';

class OtpVerificationController extends GetxController {
  var isOTPLoading = true.obs;
  var errordata = {}.obs;
  final facebookAppEvents = FacebookAppEvents();

  TextEditingController otpController = TextEditingController();

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<void> OTVerification({
    required String OTP,
  }) async {
    // The API URL where you want to send the POST request

    String url = '${Appconstants.baseURL}/api/verify-otp';

    // The request body
    Map<String, dynamic> body = {
      "otp": OTP,
    };

    try {
      isOTPLoading.value = true;
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
      print("Response Body is this for register otp ${response.body} ");
      print(
          "Response Body is this for register otp status ${response.statusCode} ");

      if (response.statusCode == 200) {
        // Handle success
        print('Registration successful');
        // You can handle the response data here
        var data = jsonDecode(response.body);
        facebookAppEvents.logEvent(name: "Fb_96k_app_verify_otp_completed");
        analytics.logEvent(name: "app_96k_verify_otp_completed");
        sharedPreferences!.setString("PageIndex", "2");

        // Get.offAllNamed(AppRouteNames.userInfoStepOne);
        navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const UserInfoStepOne(),
            ),
            (route) => false);

        print("Response body is ${response.body}");
      } else {
        otpController.text = "";
        errordata.value = jsonDecode(response.body);
        print("Error data is $errordata");

        // Handle error
        print('Failed to register: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
    } finally {
      isOTPLoading.value = false;
    }
  }
}
