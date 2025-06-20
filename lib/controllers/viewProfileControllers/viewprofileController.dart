import 'dart:async';
import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/commons/dialogues/apidialogues/registerCompleteDialogue.dart';
import 'package:_96kuliapp/commons/dialogues/forceblock.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationBlock.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationBlockController.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationScreen.dart';
import 'package:_96kuliapp/controllers/timer_controller/timer_controller.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/screens/ProfilePhotoRequestToChange/ProfilePhotoRequestToChangeScreen.dart';
import 'package:_96kuliapp/screens/plans/upgradeScreen.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepSix.dart';
import 'package:_96kuliapp/utils/bottomnavBar.dart';

class ViewProfileController extends GetxController {
  var loadingPage = false.obs;
  var userdetail = {}.obs;
  var matches = 0.obs;
  var foodDetails = [].obs;
  var hobbiesDetails = [].obs;
  var redirection = {}.obs;
  var interestDetails = [].obs;
  var favouriteMusic = [].obs;
  var dressStyle = [].obs;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

// CasteVerificationBlockController _casteVerificationBlockController = Get.put(CasteVerificationBlockController());

  String? token = sharedPreferences?.getString("token");
  // String? language = sharedPreferences?.getString("Language");

  int countOnes() {
    // Extract the 'PartnerPreferenceMatch' map from 'userdetail'
    var partnerPreferenceMatch = userdetail['PartnerPreferenceMatch'];

    // Initialize the count of '1's
    int count = 0;

    // Check if 'PartnerPreferenceMatch' exists and is a Map
    if (partnerPreferenceMatch != null && partnerPreferenceMatch is Map) {
      // Count individual '1's for keys except the grouped conditions
      count += partnerPreferenceMatch.entries
          .where((entry) =>
              entry.value == "1" &&
              ![
                "present_city",
                "permanent_city",
                "caste",
                "section",
                "subsection",
                "languages_known",
                "employed_in"
              ].contains(entry.key))
          .length;

      // Additional conditions for grouped keys
      // Count present_city and permanent_city together if both are "1"
      if (partnerPreferenceMatch["present_city"] == "1" &&
          partnerPreferenceMatch["permanent_city"] == "1") {
        count += 1;
      }

      // Count caste, section, and subsection together if all three are "1"
      if (partnerPreferenceMatch["caste"] == "1" &&
          partnerPreferenceMatch["section"] == "1" &&
          partnerPreferenceMatch["subsection"] == "1") {
        count += 1;
      }
    }

    return count;
  }

  Future<void> AddNotificationRead({
    required int notificationID,
  }) async {
    // The API URL where you want to send the POST request
    String url = '${Appconstants.baseURL}/api/notification-read';

    // The request body
    Map<String, dynamic> body = {
      "notification_id": notificationID,
    };

    try {
      String? token = sharedPreferences!.getString("token");

      // Sending the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      print("No segments ${response.body}");
      if (response.statusCode == 200) {
        // Handle success
        //  print('basic successful');
        // You can handle the response data here
        //  var data = jsonDecode(response.body);
        // Do something with the data if needed
        print('Response body: visitor ${response.body}');
        //  sharedPreferences!.setString("PageIndex" , "3");
        // Get.offAllNamed(AppRouteNames.userInfoStepTwo);
      } else {
        // Handle error
        print('Failed to register: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
    } finally {}
  }

  Future<void> AddVisitedByMeList({
    required int MemberID,
  }) async {
    // The API URL where you want to send the POST request
    String url = '${Appconstants.baseURL}/api/save-profile-visitor';

    // The request body
    Map<String, dynamic> body = {
      "visited_member_id": MemberID,
    };

    try {
      String? token = sharedPreferences!.getString("token");

      // Sending the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      print("No segments ${response.body}");
      if (response.statusCode == 200) {
        // Handle success
        //  print('basic successful');
        // You can handle the response data here
        //  var data = jsonDecode(response.body);
        // Do something with the data if needed
        print('Response body: visitor ${response.body}');
        //  sharedPreferences!.setString("PageIndex" , "3");
        // Get.offAllNamed(AppRouteNames.userInfoStepTwo);
      } else {
        // Handle error
        print('Failed to register: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
    } finally {}
  }

  final CasteVerificationBlockController _casteVerificationBlockController =
      Get.put(CasteVerificationBlockController());

  final TimerController timerController = Get.put(TimerController());

  Future<void> fetchUserInfo({required int memberid}) async {
    String? language = sharedPreferences?.getString("Language");
    loadingPage.value = true;
    final url = Uri.parse(
        '${Appconstants.baseURL}/api/member-detail/$memberid?lang=$language');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      print("This is user Profile data ${response.body}");

      if (response.statusCode == 200) {
        // Success
        final jsonResponse = jsonDecode(response.body);
        print('Success: $jsonResponse');
        // Get.snackbar('Success', 'Interest sent successfully!');
        var responseBody = jsonDecode(response.body);
        userdetail.value = responseBody;
        matches.value = countOnes();

        if (responseBody["interest"] is Map &&
            responseBody["interest"].isNotEmpty) {
          print("Inside interest map check");

          // Extracting interest map directly
          var interestData = responseBody["interest"];

          if (interestData.containsKey("favourite_food") &&
              interestData["favourite_food"].isNotEmpty) {
            foodDetails.value = interestData["favourite_food"];
          }
          if (interestData.containsKey("hobbies") &&
              interestData["hobbies"].isNotEmpty) {
            hobbiesDetails.value = interestData["hobbies"];
          }
          if (interestData.containsKey("interest") &&
              interestData["interest"].isNotEmpty) {
            interestDetails.value = interestData["interest"];
          }
          if (interestData.containsKey("favourite_music") &&
              interestData["favourite_music"].isNotEmpty) {
            favouriteMusic.value = interestData["favourite_music"];
          }
          if (interestData.containsKey("dress_style") &&
              interestData["dress_style"].isNotEmpty) {
            dressStyle.value = interestData["dress_style"];
          }
        } else {
          print("Interest data is empty or not a valid map.");
        }
        print("THIS IS REDIRECTION ${responseBody["redirection"]["pagename"]}");
        if (responseBody["redirection"]["pagename"] == "FORCEPOPUP") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.dialog(
                barrierColor: Colors.black.withOpacity(0.8),
                const ForceBlockDialogue(),
                barrierDismissible: false);
          });
        } else if (responseBody["redirection"]["pagename"].trim() ==
            "PENDING") {
          _casteVerificationBlockController.popup.value =
              responseBody["redirection"]["Popup"];
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const CasteVerificationBlock(),
              ),
              (route) => false,
            );
          });
        } else if (responseBody["redirection"]["pagename"].trim() ==
            "CASTE-VERIFICATION") {
          timerController.cancelTimer();

          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const CasteVerificationScreen(),
              ),
              (route) => false,
            );
          });
        } else if (responseBody["redirection"]["pagename"].trim() ==
            "DOCUMENT-REJECTED") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const UserInfoStepSix(),
              ),
              (route) => false,
            );
          });
        } else if (responseBody["redirection"]["pagename"].trim() == "PLAN") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const UpgradePlan(),
              ),
              (route) => false,
            );
          });
        } else if (responseBody["redirection"]["pagename"].trim() ==
            "UPDATE-PHOTO") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            timerController.cancelTimer();

            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const ProfilePhotoRequestToChangeScreen(),
              ),
              (route) => false,
            );
          });
        }
/*
if(responseBody["redirection"]["pagename"].trim() == "CASTE-VERIFICATION-PENDING"){
print("this is page name inside ${responseBody["redirection"]["pagename"]}");

  _casteVerificationBlockController.popup.value = responseBody["redirection"]["Popup"];
     navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const CasteVerificationBlock(),) ,   (route) => false,);
 
}else if (responseBody["redirection"]["pagename"].trim() == "CASTE-VERIFICATION"){
//  _casteVerificationBlockController.popup.value = basicInfoData["redirection"]["Popup"];
     navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const CasteVerificationScreen(),) ,   (route) => false,);
 
}*/

/*  Future.delayed(const Duration(milliseconds: 500), () {
    Get.dialog(const Registercompletedialogue(),
    
     barrierDismissible: false);
  }).then((value) {
  navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const BottomNavBar(),) ,   (route) => false,);
    
  },);*/

        print("This is my data for matches ${matches.value}");
      } else {
        // Error
        print('Error: in fetching ${response.statusCode}');
        //  Get.snackbar('Error', 'Failed to send interest');
      }
    } catch (e) {
      // Handle exception
      print('Exception: in fethching $e');
      //   Get.snackbar('Exception', 'Something went wrong');
    } finally {
      loadingPage.value = false;
    }
  }

  var checkContactdata = {}.obs;
  var checkContactdatafetching = false.obs;
  var statuscode = 0.obs;
  Future<void> checkContacts() async {
    try {
      checkContactdatafetching.value = true;

      // Fetch both education and specialization data in parallel

      final response = await http.post(headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      }, Uri.parse('${Appconstants.baseURL}/api/chack-contact'));
      print("This is new response ${response.statusCode}");
      if (response.statusCode == 200) {
        statuscode.value = 200;
        var responseBody = jsonDecode(response.body);
        var responsebody = responseBody;

        //  print("response body online  is this ${responsebody["data"]["data"]}");
        checkContactdata.value = responsebody["data"];
      } else if (response.statusCode == 429) {
        statuscode.value = 429;
        var responseBody = jsonDecode(response.body);
        var responsebody = responseBody;

        //  print("response body online  is this ${responsebody["data"]["data"]}");
        checkContactdata.value = responsebody;
      } else if (response.statusCode == 403) {
        statuscode.value = 403;
        var responseBody = jsonDecode(response.body);
        var responsebody = responseBody;

        //  print("response body online  is this ${responsebody["data"]["data"]}");
        checkContactdata.value = responsebody;
      } else if (response.statusCode == 409) {
        statuscode.value = 409;
        var responseBody = jsonDecode(response.body);
        var responsebody = responseBody;

        //  print("response body online  is this ${responsebody["data"]["data"]}");
        checkContactdata.value = responsebody;
      } else {
        //   Get.snackbar('Error', 'Failed to load data');
      }
    } catch (e) {
      print("Error is this $e");
      // Get.snackbar('Error', e.toString());
    } finally {
      checkContactdatafetching.value = false;
    }
  }

  var Contactdata = {}.obs;
  var Contactdatafetching = false.obs;

  Future<void> fetchContactDetails({required int memberid}) async {
    try {
      Contactdatafetching.value = true;

      // Fetch both education and specialization data in parallel
      String? language = sharedPreferences?.getString("Language");
      final response = await http.post(
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({
            'viewed_member_id': memberid,
          }),
          Uri.parse('${Appconstants.baseURL}/api/view-contact?lang=$language'));
      print("this is response ${response.body}");
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);

        analytics.logEvent(name: "app_96k_contact_viewed");

        var responsebody = responseBody;

        //  print("response body online  is this ${responsebody["data"]["data"]}");
        Contactdata.value = responsebody["contact_details"];
      } else {
        //    Get.snackbar('Error', 'Failed to load data');
      }
    } catch (e) {
      print("Error is this $e");
      analytics.logEvent(name: "app_contact_viewed_Failed");

      //   Get.snackbar('Error', e.toString());
    } finally {
      Contactdatafetching.value = false;
    }
  }
}
