import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';
import 'package:http/http.dart' as http;
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/accounts_and_settings/deleteAccount.dart';
import 'package:_96kuliapp/screens/auth_Screens/loginScreen2.dart';

class DeleteAccountController extends GetxController {
  var selectedIndex = (-1).obs;
  var isSubmitted = false.obs;
  final TextEditingController descriptionController = TextEditingController();

  var selecteddeleteIndex =
      (-1).obs; // Set to -1 initially for hint text to show
  var selectedReasonId = (-1).obs;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  var ListReasonheadings = [
    "Close / Hide Account ",
    "I Found My Match",
    "Not Satisfied",
    "Change Marriage Plan"
  ];

  var ListReasons = [
    [
      FieldModel(id: 1, name: "For 7 Days"),
      FieldModel(id: 2, name: "For 15 Days"),
      FieldModel(id: 3, name: "For 1 Month"),
    ],
    [
      FieldModel(id: 4, name: "from 96 Kuli Maratha Marriage"),
      FieldModel(id: 5, name: "from other sources")
    ],
    [
      FieldModel(id: 6, name: "Irrelevant Matches"),
      FieldModel(id: 7, name: "Few Matches"),
      FieldModel(id: 8, name: "Fake Profiles"),
      FieldModel(id: 9, name: "Fake Profiles"),
      FieldModel(id: 10, name: "Technical Issue"),
      FieldModel(id: 11, name: "Privacy Issue"),
      FieldModel(id: 13, name: "Too Many Calls and Emails"),
      FieldModel(id: 12, name: "Too Many Notifications")
    ],
    [
      FieldModel(id: 14, name: "I want to take a break"),
    ]
  ];
  List<FieldModel> get selectedReasons => selecteddeleteIndex.value >= 0
      ? ListReasons[selecteddeleteIndex.value]
      : [];

  void selectReason(int reasonId) {
    print("Selected Reason ID: $reasonId"); // Debug print
    selectedReasonId.value = reasonId;
  }

  var isdeactivateLoading = false.obs;
  Future<void> deactivateAccount({required int reasonid}) async {
    String? token = sharedPreferences?.getString("token");
    print("Token is $token");

    if (token == null) {
      // Get.snackbar('Error', 'Token is not available. Please log in again.');
      return; // Exit if token is null
    }
    isdeactivateLoading.value = true;

    final String url = '${Appconstants.baseURL}/api/deactivate-account/submit';

    try {
      // Prepare the headers and body
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Assuming you use Bearer token
      };

      final body = jsonEncode({
        'sub_reason_id': reasonid,
      });

      // Show a loading indicator (optional)
      // Get.dialog(CircularProgressIndicator());

      // Make the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      // Check the response status
      if (response.statusCode == 200) {
        // Account deactivated successfully
        final responseData = jsonDecode(response.body);

        await sharedPreferences?.clear();
        Get.deleteAll();
        navigatorKey.currentState!.pushAndRemoveUntil(
          MaterialPageRoute(
            maintainState: false,
            builder: (context) => const LoginScreen2(),
          ),
          (route) => false,
        );
        Get.snackbar('Success', 'Account deactivated successfully!');
      } else {
        // Handle error response
        final errorData = jsonDecode(response.body);
        Get.snackbar(
            'Error', errorData['message'] ?? 'Failed to deactivate account.');
      }
    } catch (error) {
      // Handle any exceptions
      Get.snackbar('Error', 'An error occurred: $error');
    } finally {
      isdeactivateLoading.value = false;
    }
  }

  var isdeleteLoading = false.obs;

  Future<void> deleteAccount(
      {required String reasonDesc, required int reasonid}) async {
    String? token = sharedPreferences?.getString("token");
    print("Token is $token");

    if (token == null) {
      //  Get.snackbar('Error', 'Token is not available. Please log in again.');
      return; // Exit if token is null
    }
    isdeleteLoading.value = true;

    final String url = '${Appconstants.baseURL}/api/delete-reasons/submit';

    try {
      // Prepare the headers and body
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Assuming you use Bearer token
      };

      final body =
          jsonEncode({'sub_reason_id': reasonid, 'reason_text': reasonDesc});

      // Show a loading indicator (optional)
      // Get.dialog(CircularProgressIndicator());

      // Make the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      // Check the response status
      if (response.statusCode == 200) {
        // Account deactivated successfully
        final responseData = jsonDecode(response.body);

        analytics.logEvent(name: "app_96k_delete_account_completed");

        await sharedPreferences?.clear();
        Get.deleteAll();
        navigatorKey.currentState!.pushAndRemoveUntil(
          MaterialPageRoute(
            maintainState: false,
            builder: (context) => const LoginScreen2(),
          ),
          (route) => false,
        );
        Get.dialog(const DeleteAccountDialogue());
        //  Get.snackbar('Success', 'Account deleted successfully!');
      } else {
        // Handle error response
        final errorData = jsonDecode(response.body);
        //     Get.snackbar('Error', errorData['message'] ?? 'Failed to deactivate account.');
      }
    } catch (error) {
      // Handle any exceptions
      //  Get.snackbar('Error', 'An error occurred: $error');
    } finally {
      isdeleteLoading.value = false;
    }
  }
}
