import 'dart:convert';
import 'dart:io';

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/commons/dialogues/apidialogues/documentVerificationDialogue.dart';
import 'package:_96kuliapp/commons/dialogues/apidialogues/registerCompleteDialogue.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationBlock.dart';
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:http/http.dart' as http;
import 'package:_96kuliapp/screens/auth_Screens/registerOTPScreen.dart';
import 'package:_96kuliapp/screens/userInfoForms/userInfoStepOne.dart';
import 'package:_96kuliapp/screens/userInfoForms/userInfoStepTwo.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepFour.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepThree.dart';
import 'package:_96kuliapp/utils/bottomnavBar.dart';
import 'package:mime/mime.dart';
import 'package:url_launcher/url_launcher.dart';

class StepSixController extends GetxController {
  var selectedOption = "".obs;
  var showCheckBox = true.obs;
  var loadingPage = false.obs;
  var data = {}.obs;
  String? token = sharedPreferences?.getString("token");
  final facebookAppEvents = FacebookAppEvents();

  Future<void> fetcheDataFromApi() async {
    print("THIS IS FETCHING");
    String? language = sharedPreferences?.getString("Language");
    try {
      loadingPage(true);
      final response = await http.get(
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $token",
          },
          Uri.parse(
              '${Appconstants.baseURL}/api/document-verification-data?lang=$language'));
      print(
          "THIS IS FETCHING Response ${response.body} and Sta ${response.statusCode}");

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
      loadingPage(false); // Ensure the loading state is reset
    }
  }

  TextEditingController panverificationController = TextEditingController();
  TextEditingController drivingLicanceController = TextEditingController();
  TextEditingController voterIDController = TextEditingController();
  var isLoading = false.obs;
  RxString fileName = "No File Chosen".obs;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Rx<File?> selectedFile = Rx<File?>(null);
  var submittedDoc = false.obs;

  // Method to select file and check its size
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

  var errordata = {}.obs;

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
      request.fields['Document_type'] = 1.toString();
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
      print("THIS IS MY RESPOMSE  for doc $responseBody");
      // Handle the response
      if (response.statusCode == 200) {
        analytics.logEvent(name: "app_96k_document_verification_completed");
        facebookAppEvents.logEvent(
            name: "Fb_96k_app_document_verification_compl");
        //    Get.snackbar("Success", "File uploaded successfully!");
        print("THIS IS RESPONSE FOR DOC $response");
        sharedPreferences!.setString("PageIndex", "8");
        Get.delete<StepSixController>();

        dashboardController.fetchUserInfo().then(
          (value) async {
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const BottomNavBar(),
              ),
              (route) => false,
            );
            //  await fetchDataredirect();
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

  void updateOption(String value) {
    selectedOption.value = value;
  }

  void altercheckBox() {
    showCheckBox.value = !showCheckBox.value;
  }

  var apiData = {}.obs;

  Future<void> fetchDataredirect() async {
    String? token = sharedPreferences!.getString("token");
    String url = '${Appconstants.baseURL}/api/redirect';
    print("THIS IS RESPONSE REDIRECT");
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
        apiData.value = json.decode(response.body);
        print("THIS IS RESPONSE REDIRECT ${response.body}");

        //  mybox.put("gender", responsedata["data"]["gender"] );

        //    sharedPreferences?.setString("token", responsedata["token"]);
        var pagename = apiData["redirect"]["pagename"];
        // Handle success (e.g., navigate to the next screen)
        print("Login data  ${apiData["redirect"]["pagename"]}");

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
          Future.delayed(const Duration(milliseconds: 500), () {
            Get.dialog(const Registercompletedialogue(),
                barrierDismissible: false);
          }).then(
            (value) {
              navigatorKey.currentState!.pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const BottomNavBar(),
                ),
                (route) => false,
              );
            },
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
        // Optionally handle errors here
        // Get.snackbar("Error", "Failed to load data from the server");
      }
    } catch (e) {
      // Optionally handle exceptions here
      // Get.snackbar("Error", "Something went wrong. $e");
    } finally {}
  }

  Future<void> sendDataVoterID({
    required String voterID,
  }) async {
    final url = Uri.parse('${Appconstants.baseURL}/api/verify-voter-id');

    // Prepare the request body dynamically
    final Map<String, dynamic> requestBody = {
      "voter_id_number": voterID,
    };

    try {
      isLoading.value = true;
      String? token = sharedPreferences!.getString("token");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print("Data sent successfully: ${response.body}");
        analytics.logEvent(name: "app_96k_document_verification_completed");
        facebookAppEvents.logEvent(
            name: "Fb_96k_app_document_verification_compl");

        sharedPreferences!.setString("PageIndex", "8");

        navigatorKey.currentState!.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const BottomNavBar(),
          ),
          (route) => false,
        );
      } else {
        print("Failed to send data: ${response.body}");
        errordata.value = jsonDecode(response.body);
      }
    } catch (e) {
      print("Error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendDataPan({
    required String panNumber,
  }) async {
    final url = Uri.parse('${Appconstants.baseURL}/api/verify-pan');

    // Prepare the request body dynamically
    final Map<String, dynamic> requestBody = {
      "pan_number": panNumber,
    };

    try {
      isLoading.value = true;
      String? token = sharedPreferences!.getString("token");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        facebookAppEvents.logEvent(
            name: "Fb_96k_app_document_verification_compl");
        print("Data sent successfully: ${response.body}");
        analytics.logEvent(name: "app_96k_document_verification_completed");
        sharedPreferences!.setString("PageIndex", "8");

        navigatorKey.currentState!.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const BottomNavBar(),
          ),
          (route) => false,
        );
      } else {
        print("Failed to send data: ${response.body}");
        errordata.value = jsonDecode(response.body);
      }
    } catch (e) {
      print("Error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendDataDrivingLicance({
    required String drivingLicance,
  }) async {
    final url = Uri.parse('${Appconstants.baseURL}/api/verify-driving-license');

    // Prepare the request body dynamically
    final Map<String, dynamic> requestBody = {
      "dl_number": drivingLicance,
    };

    try {
      isLoading.value = true;
      String? token = sharedPreferences!.getString("token");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print("Data sent successfully: ${response.body}");
        analytics.logEvent(name: "app_96k_document_verification_completed");
        facebookAppEvents.logEvent(
            name: "Fb_96k_app_document_verification_compl");

        sharedPreferences!.setString("PageIndex", "8");

        navigatorKey.currentState!.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const BottomNavBar(),
          ),
          (route) => false,
        );
      } else {
        print("Failed to send data: ${response.body}");
        errordata.value = jsonDecode(response.body);
      }
    } catch (e) {
      print("Error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  String? extractUrlFromResponse(String response) {
    final decodedJson = jsonDecode(response);
    return decodedJson['data']['result']['url'];
  }

  Future<void> AadharCardVerification() async {
    final url = Uri.parse('${Appconstants.baseURL}/api/create-aadhar-url');

    // Prepare the request body dynamically

    try {
      isLoading.value = true;
      String? token = sharedPreferences!.getString("token");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        print("Data : ${response.body}");

        final url = extractUrlFromResponse(response.body);
        _launchInAppWithBrowserOptions(Uri.parse(url ?? ""));
      } else {
        print("Failed to send data: ${response.body}");
      }
    } catch (e) {
      print("Error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _launchInAppWithBrowserOptions(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppBrowserView,
      browserConfiguration: const BrowserConfiguration(showTitle: true),
    )) {
      throw Exception('Could not launch $url');
    }
  }
}
