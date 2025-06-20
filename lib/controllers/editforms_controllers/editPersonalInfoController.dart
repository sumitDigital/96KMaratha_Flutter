import 'dart:async';
import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/commons/dialogues/forceblock.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationBlock.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationBlockController.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationScreen.dart';
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/controllers/viewProfileControllers/myprofileController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';
import 'package:_96kuliapp/screens/plans/upgradeScreen.dart';
import 'package:_96kuliapp/screens/profile_screens/edit_profile.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepSix.dart';
import 'package:http/http.dart' as http;

class EditPersonalInfoController extends GetxController {
  TextEditingController numberchilren = TextEditingController();
  TextEditingController physicalStatus = TextEditingController();

  var phvalidation = true.obs;
  var selectedCountryCode = "".obs;
  var selectedPhysicalStatus = FieldModel().obs;
  var selectedPhysicalStatusValidated = false.obs;
  void updatePhysicalStatus(FieldModel value) {
    selectedPhysicalStatus.value = value;

    selectedPhysicalStatusValidated.value = true;
  }

  var selectedLens = FieldModel().obs;
  var selectedLensValidated = false.obs;
  void updateLensStatus(FieldModel value) {
    selectedLens.value = value;

    selectedLensValidated.value = true;
  }

  var selectedSpectackle = FieldModel().obs;
  var selectedSpectackleValidated = false.obs;
  void updateSpectackleStatus(FieldModel value) {
    selectedSpectackle.value = value;

    selectedSpectackleValidated.value = true;
  }

  void updateMaritalStatus(FieldModel value) {
    selectedMaritalStatus.value = value;

    selectedMaritialStatusValidated.value = true;
  }

  var searchedHeightList = <FieldModel>[].obs;
  var searchedWeightList = <FieldModel>[].obs;

  var isSubmitted = false.obs;

  var selected = false.obs;

  var isLoading = false.obs;

  void searchMinHeight(String query) {
    if (query.isEmpty) {
      searchedHeightList.value = heightInFeet;
    } else {
      searchedHeightList.value = heightInFeet
          .where((item) => item.name!
              .toLowerCase()
              .startsWith(query.toLowerCase())) // Filter by name
          .toList();
    }
  }

  void searchWeight(String query) {
    if (query.isEmpty) {
      searchedWeightList.value = weightList;
    } else {
      searchedWeightList.value = weightList
          .where((item) => item.name!
              .toLowerCase()
              .startsWith(query.toLowerCase())) // Filter by name
          .toList();
    }
  }

  var bloodGroups = [
    FieldModel(id: 1, name: 'A+ve'),
    FieldModel(id: 2, name: 'A-ve'),
    FieldModel(id: 3, name: 'B+ve'),
    FieldModel(id: 4, name: 'B-ve'),
    FieldModel(id: 5, name: 'AB+ve'),
    FieldModel(id: 6, name: 'AB-ve'),
    FieldModel(id: 7, name: 'O+ve'),
    FieldModel(id: 8, name: 'O-ve'),
  ].obs;

  // Selected blood group
  var selectedBloodGroup = Rxn<FieldModel>();
  // Selected blood index (for tracking purposes)
  var selectedBloodIndex = Rxn<int>();

  // Method to update the selected blood group
  void updateBloodGroup(FieldModel selectedItem) {
    selectedBloodGroup.value = selectedItem;
    selectedBloodIndex.value = bloodGroups.indexOf(selectedItem);
  }

  // Preselect blood group based on ID
  void preselectBloodGroup(int id) {
    FieldModel? selected = bloodGroups.firstWhere((element) => element.id == id,
        orElse: () => FieldModel());
    if (selected.id != null) {
      updateBloodGroup(selected);
    }
  }

  void preselectComplexion(int id) {
    FieldModel? selected = complexion.firstWhere((element) => element.id == id,
        orElse: () => FieldModel());
    if (selected.id != null) {
      updateZodiacSign(selected);
    }
  }

  void preselectWeight(int id) {
    FieldModel? selected = weightList.firstWhere((element) => element.id == id,
        orElse: () => FieldModel());
    if (selected.id != null) {
      updateWeight(selected);
    }
  }

  void preselectNumberOfChildren(int id) {
    FieldModel? selected = numberOfChildren
        .firstWhere((element) => element.id == id, orElse: () => FieldModel());
    if (selected.id != null) {
      updateNumberOfChildren(selected);
    }
  }

  var heightInFeet = <FieldModel>[].obs;

  void regenerateHeightList() {
    String? language = sharedPreferences?.getString("Language");

    heightInFeet.value = List<FieldModel>.generate(37, (index) {
      int feet = 4 + (index ~/ 12);
      int inches = index % 12;
      double totalInches = (feet * 12 + inches).toDouble();
      double heightInCm = totalInches * 2.54;

      return FieldModel(
        id: index + 1,
        name:
            '$feet\'$inches" - ${heightInCm.toStringAsFixed(2)} ${language == "en" ? 'cm' : "सेमी"}',
      );
    });
  }

  // var heightInFeet = List<FieldModel>.generate(37, (index) {
  //   int feet = 4 + (index ~/ 12); // Calculate feet starting from 4
  //   int inches = index % 12; // Calculate inches
  //   double totalInches = (feet * 12 + inches).toDouble(); // Convert to double
  //   double heightInCm = totalInches * 2.54; // Convert inches to centimeters

  //   // Return the FieldModel with both feet/inches and cm
  //   return FieldModel(
  //     id: index + 1,
  //     name: '$feet\'$inches" - ${heightInCm.toStringAsFixed(2)} cm',
  //   );
  // }).obs;

  var weightList = <FieldModel>[].obs;

  void weightlist() {
    String? language = sharedPreferences?.getString("Language");
    weightList.value = /* language == 'en' ? */ [
      FieldModel(id: 1, name: "20 - 25 kg"),
      FieldModel(id: 2, name: "26 - 30 kg"),
      FieldModel(id: 3, name: "31 - 35 kg"),
      FieldModel(id: 4, name: "36 - 40 kg"),
      FieldModel(id: 5, name: "41 - 45 kg"),
      FieldModel(id: 6, name: "46 - 50 kg"),
      FieldModel(id: 7, name: "51 - 55 kg"),
      FieldModel(id: 8, name: "56 - 60 kg"),
      FieldModel(id: 9, name: "61 - 65 kg"),
      FieldModel(id: 10, name: "66 - 70 kg"),
      FieldModel(id: 11, name: "71 - 75 kg"),
      FieldModel(id: 12, name: "76 - 80 kg"),
      FieldModel(id: 13, name: "81 - 85 kg"),
      FieldModel(id: 14, name: "86 - 90 kg"),
      FieldModel(id: 15, name: "91 - 95 kg"),
      FieldModel(id: 16, name: "96 - 100 kg"),
      FieldModel(id: 17, name: "101 - 105 kg"),
      FieldModel(id: 18, name: "106 - 110 kg"),
      FieldModel(id: 19, name: "111 - 115 kg"),
      FieldModel(id: 20, name: "116 - 120 kg"),
      FieldModel(id: 21, name: "121 - 125 kg"),
      FieldModel(id: 22, name: "126 - 130 kg"),
      FieldModel(id: 23, name: "131 - 135 kg"),
      FieldModel(id: 24, name: "136 - 140 kg"),
      FieldModel(id: 25, name: "141 - 145 kg"),
      FieldModel(id: 26, name: "146 - 150 kg"),
    ].obs(); /* : [] */
  }

  var selectedHeight = Rxn<FieldModel>();
  var selectedWeight = Rxn<FieldModel>();

  // Selected height index (for tracking purposes)
  var selectedHeightIndex = Rxn<int>();

  // Method to update the selected height
  void updateHeight(FieldModel selectedItem) {
    selectedHeight.value = selectedItem;
    selectedHeightIndex.value = heightInFeet.indexOf(selectedItem);
  }

  void updateWeight(FieldModel selectedItem) {
    selectedWeight.value = selectedItem;
    print("Selectedweight ${selectedWeight.value?.id}");
    // selectedHeightIndex.value = heightInFeet.indexOf(selectedItem);
  }

  // Preselect height based on ID
  void preselectHeight(int id) {
    FieldModel? selected = heightInFeet
        .firstWhere((element) => element.id == id, orElse: () => FieldModel());
    if (selected.id != null) {
      updateHeight(selected);
    }
  }

  var isvalidate = false.obs;
  var selected24HourFormat = "".obs;
  var selectedMaritalStatus = FieldModel().obs;
  var selectedMaritialStatusValidated = false.obs;
  var selectedChildren = FieldModel().obs;
  var selectedChildrenValidated = false.obs;

  var isPageLoading = false.obs;
  var basicInfoData = {}.obs; // To hold the API response data
  var selectedDay = Rx<DateTime?>(null);
  @override
  void onInit() {
    super.onInit();
    fetchBasicInfo();
    complexions();
    regenerateHeightList();
    weightlist();
  }

  final CasteVerificationBlockController _casteVerificationBlockController =
      Get.put(CasteVerificationBlockController());

  Future<void> fetchBasicInfo() async {
    print("THIS IS DATA FETCHED");
    String? token = sharedPreferences!.getString("token");
    print("Token is $token");
    String? language = sharedPreferences?.getString("Language");
    try {
      isPageLoading(true);

      final response = await http.get(
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $token",
          },
          Uri.parse(
              '${Appconstants.baseURL}/api/profile-data/PersonalInfo?lang=$language'));
      print("response is for personal info data ${response.body}");
      if (response.statusCode == 200) {
        basicInfoData.value = jsonDecode(response.body);
// print("basic info is  ${basicInfoData}");

        preselectComplexion(basicInfoData["data"]["fields"]["complexion"]);
        print("This is dta ${basicInfoData["data"]["fields"]["complexion"]}");
// Assuming phoneNumberController is a custom controller

        preselectWeight(basicInfoData["data"]["fields"]["weight"]);

        selectedMaritalStatus.value.id =
            basicInfoData["data"]["fields"]["marital_status"];

        // print("THIS IS COMPLEX ${basicInfoData["data"]["fileds"]["complexion"]}");
        preselectBloodGroup(basicInfoData["data"]["fields"]["blood_group"]);
        preselectHeight(basicInfoData["data"]["fields"]["height"]);
//print("children is this ${basicInfoData["data"]["fields"]["have_childs"]}");
        selectedChildren.value.id =
            basicInfoData["data"]["fields"]["have_childs"];
        if (basicInfoData["data"]["fields"]["no_of_chidls"] != null) {
          //  numberchilren.text = ;
          preselectNumberOfChildren(
              basicInfoData["data"]["fields"]["no_of_chidls"]);
        }
        print(
            "This is physical status ${basicInfoData["data"]["fields"]["disablity"]}");
        //  print("Basic info is this ${basicInfoData["data"]["other_disability"]}");
        if (basicInfoData["data"]["fields"]["other_disability"] != null) {
          physicalStatus.text =
              basicInfoData["data"]["fields"]["other_disability"];
        }
        //print("THIS IS DISSSS ${basicInfoData["data"]["fileds"]["complexion"]}");

        selectedPhysicalStatus.value.id =
            basicInfoData["data"]["fields"]["disablity"];
        // preselectComplexion(basicInfoData["data"]["fileds"]["complexion"]);
        selectedLens.value.id = basicInfoData["data"]["fields"]["lens"];
        selectedSpectackle.value.id =
            basicInfoData["data"]["fields"]["spectacles"];
// selectedComplexion.value?.id = basicInfoData["data"]["fileds"]["complexion"];
        // print("This is contact details ${basicInfoData["contact_number_visibility"]}");

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
      } else {
        print("Fetched successfully Error");

        // Handle error if needed
        //     Get.snackbar('Error', 'Failed to load data');
      }
    } catch (e) {
      // Handle exception
      //  Get.snackbar('Error', e.toString());
    } finally {
      isPageLoading(false);
    }
  }
  // Method to pick a date

  var selectedChildrenInt = 0.obs;

  void updateChildren(FieldModel value) {
    selectedChildren.value = value;
  }

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final MyProfileController _profileController = Get.put(MyProfileController());
  final DashboardController _dashboardController =
      Get.find<DashboardController>();
  Future<void> EditPersonalInfo({
    required int height,
    required int weight,
    required int spectacles,
    required int lens,
    required int complexion,
    required int bloodGroup,
    required int disability,
    required String disabilityDesc,
    required int maritalStatus,
    required int haveChildren,
    required int numberOfChildren,
  }) async {
    // The API URL where you want to send the POST request
    String url = '${Appconstants.baseURL}/api/update/PersonalInfo';
    isLoading.value = true;
    // The request body
    Map<String, dynamic> body = {
      "height": height,
      "weight": weight,
      "spectacles": spectacles,
      "lens": lens,
      "complexion": complexion,
      "blood_group": bloodGroup,
      "disability": disability,
      "other_disability": disabilityDesc,
      "marital_status": maritalStatus,
    };
    if (haveChildren == 2 || haveChildren == 3) {
      body["have_childs"] = haveChildren;
      body["no_of_chidls"] = numberOfChildren;
    }

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
        print('basic successful');
        //   analytics.logEvent(name: "app_basic_info_form_completed");
        // You can handle the response data here
        //  var data = jsonDecode(response.body);
        // Do something with the data if needed
        //  facebookAppEvents.logEvent(name: "Fb_app_basic_info_form_completed");
        Get.delete<MyProfileController>();
        Get.delete<EditPersonalInfoController>();

        // Replace the current page with a new page
        navigatorKey.currentState!.pushReplacement(
          MaterialPageRoute(builder: (context) => const EditProfile()),
        );

        _profileController.fetchUserInfo();
      } else {
        // Handle error
        print('Failed to register: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
    } finally {
      isLoading.value = false;
      _dashboardController.fetchIncompleteDetails();
    }
  }

  // Currently selected zodiac sign

  // number of children
  var numberOfChildren = [
    FieldModel(id: 1, name: '1'),
    FieldModel(id: 2, name: '2'),
    FieldModel(id: 3, name: '3+'),
  ].obs;

  var selectedNumberOfChildren = Rxn<FieldModel>();
  // Selected blood index (for tracking purposes)
  // var selectedBloodIndex = Rxn<int>();

  // Method to update the selected blood group
  void updateNumberOfChildren(FieldModel selectedItem) {
    selectedNumberOfChildren.value = selectedItem;
    //  selectedBloodIndex.value = bloodGroups.indexOf(selectedItem);
  }

  // final List<FieldModel> complexion = [
  //   FieldModel(id: 1, name: "Very Fair"),
  //   FieldModel(id: 2, name: "Fair"),
  //   FieldModel(id: 3, name: "Wheatish Fair"),
  //   FieldModel(id: 4, name: "Wheatish"),
  //   FieldModel(id: 5, name: "Wheatish Dark"),
  //   FieldModel(id: 6, name: "Dark"),
  // ];

  // final List<FieldModel> complexion = [
  //   FieldModel(id: 1, name: AppLocalizations.of(Get.context!)!.veryFair),
  //   FieldModel(id: 2, name: AppLocalizations.of(Get.context!)!.fair),
  //   FieldModel(id: 3, name: AppLocalizations.of(Get.context!)!.wheatishFair),
  //   FieldModel(id: 4, name: AppLocalizations.of(Get.context!)!.wheatish),
  //   FieldModel(id: 5, name: AppLocalizations.of(Get.context!)!.wheatishDark),
  //   FieldModel(id: 6, name: AppLocalizations.of(Get.context!)!.dark),
  // ];
  var complexion = <FieldModel>[].obs;

  void complexions() {
    String? language = sharedPreferences?.getString("Language");

    language == 'en'
        ? complexion.value = [
            FieldModel(id: 1, name: "Very Fair"),
            FieldModel(id: 2, name: "Fair"),
            FieldModel(id: 3, name: "Wheatish Fair"),
            FieldModel(id: 4, name: "Wheatish"),
            FieldModel(id: 5, name: "Wheatish Dark"),
            FieldModel(id: 6, name: "Dark"),
          ]
        : complexion.value = [
            FieldModel(id: 1, name: "अति गोरा"),
            FieldModel(id: 2, name: "गोरा"),
            FieldModel(id: 3, name: "गव्हाळ गोरा"),
            FieldModel(id: 4, name: "गव्हाळ"),
            FieldModel(id: 5, name: "सावळा"),
            FieldModel(id: 6, name: "काळा"),
          ];
  }

  // Currently selected zodiac sign
  Rxn<FieldModel> selectedComplexion = Rxn<FieldModel>();

  // Method to update the selected zodiac sign
  void updateZodiacSign(FieldModel sign) {
    selectedComplexion.value = sign;
  }
}
