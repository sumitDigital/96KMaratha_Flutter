// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/commons/dialogues/forceblock.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationBlock.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationBlockController.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationScreen.dart';
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/controllers/viewProfileControllers/myprofileController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:http/http.dart' as http;
import 'package:_96kuliapp/screens/plans/upgradeScreen.dart';
import 'package:_96kuliapp/screens/profile_screens/edit_profile.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepSix.dart';

class EditAboutmeController extends GetxController {
  TextEditingController aboutMe = TextEditingController();

  // final LocationController _locationController = Get.put(LocationController());

  var isLoading = false.obs;
  var isPageLoading = false.obs;
  var basicInfoData = {}.obs; // To hold the API response data

  var selectedWorkModeValidated = false.obs;
  var isSameAdress = false.obs;

  // Method to select item based on ID

  @override
  void onInit() {
    super.onInit();
    fetchAboutMeInfo(); // Your existing method, no change here
    // Load the list of items
    //  print("This is education value ${_educationController.selectedEducation.value.id } and for employed in ${_emplyedInController.selectedOption.value.id}");
  }

  // Observable list of items
  // var itemsList = <FieldModel>[].obs;

  // Observable selected item
  // var selectedAnnualIncome = Rxn<FieldModel>();

  // Initialize the list (normally you'd fetch this from an API)

  // Set selected item based on user's choice
  final CasteVerificationBlockController _casteVerificationBlockController =
      Get.put(CasteVerificationBlockController());

  Future<void> fetchAboutMeInfo() async {
    String? token = sharedPreferences!.getString("token");

    try {
      isPageLoading(true);
      String? language = sharedPreferences?.getString("Language");
      // Fetch both education and specialization data in parallel
      final response = await http.get(
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $token",
          },
          Uri.parse(
              '${Appconstants.baseURL}/api/profile-data/Introduction?lang=$language'));

      if (response.statusCode == 200) {
        basicInfoData.value = jsonDecode(response.body);
        print("Response is ${response.body}");
        if (basicInfoData["data"]["fields"]["about_me"] != null) {
          aboutMe.text = basicInfoData["data"]["fields"]["about_me"];
        } else {
          aboutMe.text = basicInfoData["data"]["fields"]["about_me_text"];
        }
        if (basicInfoData["redirection"]["pagename"] == "FORCEPOPUP") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.dialog(
                barrierColor: Colors.black.withOpacity(0.8),
                const ForceBlockDialogue(),
                barrierDismissible: false);
          });
        } else if (basicInfoData["redirection"]["pagename"].trim() ==
            "PENDING") {
          _casteVerificationBlockController.popup.value =
              basicInfoData["redirection"]["Popup"];
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const CasteVerificationBlock(),
              ),
              (route) => false,
            );
          });
        } else if (basicInfoData["redirection"]["pagename"].trim() ==
            "CASTE-VERIFICATION") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const CasteVerificationScreen(),
              ),
              (route) => false,
            );
          });
        } else if (basicInfoData["redirection"]["pagename"].trim() ==
            "DOCUMENT-REJECTED") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const UserInfoStepSix(),
              ),
              (route) => false,
            );
          });
        } else if (basicInfoData["redirection"]["pagename"].trim() == "PLAN") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const UpgradePlan(),
              ),
              (route) => false,
            );
          });
        }
        //  print("Work mode is ${selectedWorkMode.value}");
      } else {
        //    Get.snackbar('Error', 'Failed to load data');
      }
    } catch (e) {
      //  Get.snackbar('Error', e.toString());
    } finally {
      isPageLoading(false);
    }
  }

// Helper function to find the field by ID

  final DashboardController _dashboardController =
      Get.find<DashboardController>();

  final MyProfileController _profileController = Get.put(MyProfileController());

  Future<void> AboutMe(
      {
      // Int
      required String aboutme}) async {
    String url = '${Appconstants.baseURL}/api/update/Introduction';
    isLoading.value = true;

    // The request body
    Map<String, dynamic> body = {
      "about_me": aboutme,
    };
    /*
     "other_occupation": otherOccupation,
    "designation": designation,
    "company_name": companyName,*/

    try {
      String? token = sharedPreferences!.getString("token");

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('Registration successful');
        var data = jsonDecode(response.body);
        // sharedPreferences!.setString("PageIndex", "4");
        print('Response body: ${response.body}');
        if (navigatorKey.currentState!.canPop()) {
          Get.back();
          _profileController.fetchUserInfo();
        } else {
          navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
            builder: (context) => const EditProfile(),
          ));
        }

        // Get.toNamed(AppRouteNames.userInfoStepThree);
      } else {
        print('Failed to register: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
      _dashboardController.fetchIncompleteDetails();
    }
  }
}
