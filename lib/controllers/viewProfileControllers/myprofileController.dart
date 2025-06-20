import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/commons/dialogues/forceblock.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationBlock.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationBlockController.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationScreen.dart';
import 'package:_96kuliapp/main.dart';
import 'package:http/http.dart' as http;
import 'package:_96kuliapp/screens/ProfilePhotoRequestToChange/ProfilePhotoRequestToChangeScreen.dart';
import 'package:_96kuliapp/screens/plans/upgradeScreen.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepSix.dart';

class MyProfileController extends GetxController {
  var userdetail = {}.obs;
  var loadingPage = false.obs;
  var basicInfoData = {}.obs; // To hold the API response data

  var matches = 0.obs;
  var foodDetails = [].obs;
  var hobbiesDetails = [].obs;
  var interestDetails = [].obs;
  var favouriteMusic = [].obs;

  var dressStyle = [].obs;

  String? token = sharedPreferences?.getString("token");

  int countOnes() {
    // Extract the 'PartnerPreferenceMatch' map from 'userdetail'
    var partnerPreferenceMatch = userdetail['PartnerPreferenceMatch'];

    // If 'PartnerPreferenceMatch' exists, count the number of '1's
    if (partnerPreferenceMatch != null && partnerPreferenceMatch is Map) {
      return partnerPreferenceMatch.values
          .where((value) => value == "1")
          .length;
    }

    return 0; // Return 0 if 'PartnerPreferenceMatch' is not found or is not a map
  }

  final CasteVerificationBlockController _casteVerificationBlockController =
      Get.put(CasteVerificationBlockController());

  Future<void> fetchUserInfo() async {
    print("EDIT PROFILE FETCHING AGAIN $token");
    String? language = sharedPreferences?.getString("Language");
    loadingPage.value = true;
    final url =
        Uri.parse('${Appconstants.baseURL}/api/my-profile?lang=$language');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      print("This is my Profile data ${response.body}");

      if (response.statusCode == 200) {
        // Success
        final jsonResponse = jsonDecode(response.body);
        print('Success: $jsonResponse');
        // Get.snackbar('Success', 'Interest sent successfully!');
        var responseBody = jsonDecode(response.body);
        userdetail.value = responseBody;
        matches.value = countOnes();
        var intrestList = [];
        print("This Profile response ${responseBody["interest"]}");

        print("Inside interest list check $responseBody");

        // Checking if the first item in the list is a map with the required keys

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

        print("THIS IS DATA ${responseBody["redirection"]["pagename"]}");
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
}
