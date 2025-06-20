import 'dart:convert';
import 'dart:io';

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:http/http.dart' as http;
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/controllers/userform/formstep6Controller.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/utils/bottomnavBar.dart';
import 'package:mime/mime.dart';

class CasteVerificationData extends GetxController {
  var isloading = false.obs;
  var submitted = false.obs;

  var data = {}.obs;
  var showCheckBox = true.obs;
  void altercheckBox() {
    showCheckBox.value = !showCheckBox.value;
  }

  String? token = sharedPreferences?.getString("token");
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final facebookAppEvents = FacebookAppEvents();

  Future<void> fetcheDataFromApi() async {
    print("THIS IS FETCHING");
    try {
      isloading(true);
      final response = await http.get(headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      }, Uri.parse('${Appconstants.baseURL}/api/caste-verification-data'));
      print(
          "THIS IS FETCHING Response caste ${response.body} and Sta ${response.statusCode}");

      if (response.statusCode == 200) {
        final responsedata = jsonDecode(response.body);
        if (responsedata is Map<String, dynamic>) {
          data.value = responsedata;
          if (responsedata["verification_status"] == "ACCEPTED") {
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const BottomNavBar(),
              ),
              (route) => false,
            );
          }
        } else {
          print("The decoded response is not a valid Map.");
        }
      } else {
        print("Error in fetching education data");
      }
    } finally {
      isloading(false); // Ensure the loading state is reset
    }
  }

  Rx<File?> selectedFile = Rx<File?>(null);

  Future<void> selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf', 'doc'], // Allowed file types
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      // Check if the file size is within 2 MB
      if (file.size > 10 * 1024 * 1024) {
        Get.snackbar("Error", "File size exceeds 2 MB");
        return;
      }

      // Update the file information in the state
      fileName.value = file.name;
      selectedFile.value = File(file.path!);
    } else {
      // User canceled the picker
      fileName.value = "No File Chosen";
    }
  }

  var isLoading = false.obs;
  RxString fileName = "No File Chosen".obs;

  Future<void> uploadDocument() async {
    final DashboardController dashboardController =
        Get.put(DashboardController());
    if (selectedFile.value == null) {
      Get.snackbar("Error", "Please select a file first");
      return;
    }
    isLoading.value = true;
    // Retrieve the token from shared preferences
    String? token = sharedPreferences!.getString("token");
    if (token == null) {
      //  Get.snackbar("Error", "Token not found");
      return;
    }

    try {
      // API endpoint URL
      var uri = Uri.parse('${Appconstants.baseURL}/api/store-document');

      // Create the multipart request
      var request = http.MultipartRequest('POST', uri);

      // Set headers
      request.headers.addAll({
        "Content-Type": "multipart/form-data",
        "Authorization": "Bearer $token", // Use dynamic token here
      });

      // Determine the mime type of the file
      String? mimeType = lookupMimeType(selectedFile.value!.path);
      request.fields['Document_type'] = 2.toString();
      // Add the file to the request as 'Document_upload'
      request.files.add(
        await http.MultipartFile.fromPath(
          'Document_upload',
          selectedFile.value!.path,
          contentType: mimeType != null
              ? MediaType(mimeType.split('/')[0], mimeType.split('/')[1])
              : null, // Handle null mimeType case
        ),
      );

      // Send the request and wait for response
      var response = await request.send();
      String responseBody = await response.stream.bytesToString();
      print("THIS IS MY RESPOMSE $responseBody");
      // Handle the response
      if (response.statusCode == 200) {
        facebookAppEvents.logEvent(
            name: "Fb_96k_app_document_verification_compl");
        analytics.logEvent(name: "app_96k_document_verification_completed");
        //    Get.snackbar("Success", "File uploaded successfully!");
        print("THIS IS RESPONSE FOR DOC $response");
        Get.delete<CasteVerificationData>();

        dashboardController.fetchUserInfo().then(
          (value) async {
            //  await fetchDataredirect();
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const BottomNavBar(),
              ),
              (route) => false,
            );
          },
        );
      } else {
        Get.snackbar(
            "Error", "File upload failed. Status: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
