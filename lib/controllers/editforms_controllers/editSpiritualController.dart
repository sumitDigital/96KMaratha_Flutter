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
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';
import 'package:_96kuliapp/screens/plans/upgradeScreen.dart';
import 'package:_96kuliapp/screens/profile_screens/edit_profile.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepSix.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditSpiritualController extends GetxController {
  var searchedHeightList = <FieldModel>[].obs;

  var isSubmitted = false.obs;

  var selectedManglikValidated = false.obs;

  var isLoading = false.obs;
  var manglikSelected = FieldModel().obs;

  TextEditingController gotraController = TextEditingController();

  // Selected blood group

  var isvalidate = false.obs;
  var selected24HourFormat = "".obs;

  var isPageLoading = false.obs;
  var basicInfoData = {}.obs; // To hold the API response data

  @override
  void onInit() {
    super.onInit();
    fetchBasicInfo();
    zodiacsigList();
    nakshatraList();

    ganListing();
    charanListing();
    nandiListing();
  }

  final CasteVerificationBlockController _casteVerificationBlockController =
      Get.put(CasteVerificationBlockController());

  Future<void> fetchBasicInfo() async {
    String? token = sharedPreferences!.getString("token");

    print("Token is $token");
    try {
      isPageLoading(true);
      String? language = sharedPreferences?.getString("Language");
      final response = await http.get(
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $token",
          },
          Uri.parse(
              '${Appconstants.baseURL}/api/profile-data/Spiritual?lang=$language'));
      print("response is ${response.body}");
      if (response.statusCode == 200) {
        basicInfoData.value = jsonDecode(response.body);
        print("basic info is  $basicInfoData");

        if (basicInfoData["data"]["fields"]["ras"] != null) {
          await Future.wait([
// _castController.fetchSectionFromApi()
          ]);
          print("This is dta ");

// Assuming phoneNumberController is a custom controller

          manglikSelected.value.id = basicInfoData["data"]["fields"]["manglik"];

          // rascontroller.rasSelected.value.id = rascontroller.rassList.where((e) => e.id == 2 ,).
          /*    rascontroller.rasSelected.value = rascontroller.rassList.firstWhere(
  (e) => e.id == basicInfoData["ras"],  // Replace '2' with the ID you want to preselect
  orElse: () => FieldModel(),  // In case the ID is not found, return an empty model
);*/
          selectedZodiacSign.value = zodiacSigns.firstWhere(
            (element) => element.id == basicInfoData["data"]["fields"]["ras"],
          );
          selectedNakshatra.value = Nakshatra.firstWhere(
            (element) =>
                element.id == basicInfoData["data"]["fields"]["nakshtra"],
          );
          selectedGan.value = Gan.firstWhere(
            (element) => element.id == basicInfoData["data"]["fields"]["gan"],
          );
          selectedCharan.value = Charan.firstWhere(
            (element) =>
                element.id == basicInfoData["data"]["fields"]["charan"],
          );
          selectedNadi.value = Nadi.firstWhere(
            (element) => element.id == basicInfoData["data"]["fields"]["nadi"],
          );

          if (basicInfoData["data"]["fields"]["gotra"] != null) {
            gotraController.text = basicInfoData["data"]["fields"]["gotra"];
          }

// Find the matching CountryModel based on the id
        } else {
          // here make values empty
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

        print("in section");
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

  void updateManglik(FieldModel value) {
    manglikSelected.value = value;

    selectedManglikValidated.value = true;
  }

  final DashboardController _dashboardController =
      Get.find<DashboardController>();

  final MyProfileController _profileController = Get.put(MyProfileController());

  Future<void> BasicForm({
    required int ras,
    required int manglik,
    required int nakshatra,
    required int gan,
    required String gotra,
    required int charan,
    required int nadi,
  }) async {
    // The API URL where you want to send the POST request
    String url = '${Appconstants.baseURL}/api/update/Spiritual';
    isLoading.value = true;
    // The request body
    Map<String, dynamic> body = {
      "nakshtra": nakshatra,
      "gan": gan,
      "charan": charan,
      "nadi": nadi,
      "gotra": gotra,
      "ras": ras,
      "manglik": manglik,
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
        print('basic successful');
        // You can handle the response data here
        //  var data = jsonDecode(response.body);
        // Do something with the data if needed
        print('Response body: ${response.body}');
        // sharedPreferences!.setString("PageIndex" , "3");
        // Get.offAllNamed(AppRouteNames.userInfoStepTwo);
        if (navigatorKey.currentState!.canPop()) {
          Get.back();
          _profileController.fetchUserInfo();
        } else {
          navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
            builder: (context) => const EditProfile(),
          ));
        }
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

// ras

  // final List<FieldModel> zodiacSigns = [
  //   FieldModel(id: 1, name: AppLocalizations.of(Get.context!)!.aries),
  //   FieldModel(id: 2, name: AppLocalizations.of(Get.context!)!.taurus),
  //   FieldModel(id: 3, name: AppLocalizations.of(Get.context!)!.gemini),
  //   FieldModel(id: 4, name: AppLocalizations.of(Get.context!)!.cancer),
  //   FieldModel(id: 5, name: AppLocalizations.of(Get.context!)!.leo),
  //   FieldModel(id: 6, name: AppLocalizations.of(Get.context!)!.virgo),
  //   FieldModel(id: 7, name: AppLocalizations.of(Get.context!)!.libra),
  //   FieldModel(id: 8, name: AppLocalizations.of(Get.context!)!.scorpio),
  //   FieldModel(id: 9, name: AppLocalizations.of(Get.context!)!.sagittarius),
  //   FieldModel(id: 10, name: AppLocalizations.of(Get.context!)!.capricorn),
  //   FieldModel(id: 11, name: AppLocalizations.of(Get.context!)!.aquarius),
  //   FieldModel(id: 12, name: AppLocalizations.of(Get.context!)!.pisces),
  // ];
  var zodiacSigns = <FieldModel>[].obs;

  void zodiacsigList() {
    String? language = sharedPreferences?.getString("Language");
    zodiacSigns.value = language == 'en'
        ? <FieldModel>[
            FieldModel(id: 1, name: 'Aries'),
            FieldModel(id: 2, name: 'Taurus'),
            FieldModel(id: 3, name: 'Gemini'),
            FieldModel(id: 4, name: 'Cancer'),
            FieldModel(id: 5, name: 'Leo'),
            FieldModel(id: 6, name: 'Virgo'),
            FieldModel(id: 7, name: 'Libra'),
            FieldModel(id: 8, name: 'Scorpio'),
            FieldModel(id: 9, name: 'Sagittarius'),
            FieldModel(id: 10, name: 'Capricorn'),
            FieldModel(id: 11, name: 'Aquarius'),
            FieldModel(id: 12, name: 'Pisces'),
          ]
        : <FieldModel>[
            FieldModel(id: 1, name: 'मेष'),
            FieldModel(id: 2, name: 'वृषभ'),
            FieldModel(id: 3, name: 'मिथुन'),
            FieldModel(id: 4, name: 'कर्क'),
            FieldModel(id: 5, name: 'सिंह'),
            FieldModel(id: 6, name: 'कन्या'),
            FieldModel(id: 7, name: 'तुळ'),
            FieldModel(id: 8, name: 'वृश्चिक'),
            FieldModel(id: 9, name: 'धनु'),
            FieldModel(id: 10, name: 'मकर'),
            FieldModel(id: 11, name: 'कुंभ'),
            FieldModel(id: 12, name: 'मीन'),
          ];
  }

  // Currently selected zodiac sign
  Rxn<FieldModel> selectedZodiacSign = Rxn<FieldModel>();

  // Method to update the selected zodiac sign
  void updateZodiacSign(FieldModel sign) {
    selectedZodiacSign.value = sign;
  }

  // nakshatra
  Rxn<FieldModel> selectedNakshatra = Rxn<FieldModel>();
  // Method to update the selected zodiac sign
  void updateNakshatra(FieldModel sign) {
    selectedNakshatra.value = sign;
  }

  // final List<FieldModel> Nakshatra = [
  //   FieldModel(id: 1, name: AppLocalizations.of(Get.context!)!.ashwini),
  //   FieldModel(id: 2, name: AppLocalizations.of(Get.context!)!.bharani),
  //   FieldModel(id: 3, name: AppLocalizations.of(Get.context!)!.krittika),
  //   FieldModel(id: 4, name: AppLocalizations.of(Get.context!)!.rohini),
  //   FieldModel(id: 5, name: AppLocalizations.of(Get.context!)!.mrigashirsha),
  //   FieldModel(id: 6, name: AppLocalizations.of(Get.context!)!.ardra),
  //   FieldModel(id: 7, name: AppLocalizations.of(Get.context!)!.punarvasu),
  //   FieldModel(id: 8, name: AppLocalizations.of(Get.context!)!.pushya),
  //   FieldModel(id: 9, name: AppLocalizations.of(Get.context!)!.ashlesha),
  //   FieldModel(id: 10, name: AppLocalizations.of(Get.context!)!.magha),
  //   FieldModel(id: 11, name: AppLocalizations.of(Get.context!)!.purvaphalguni),
  //   FieldModel(id: 12, name: AppLocalizations.of(Get.context!)!.uttaraphalguni),
  //   FieldModel(id: 13, name: AppLocalizations.of(Get.context!)!.hasta),
  //   FieldModel(id: 14, name: AppLocalizations.of(Get.context!)!.chitra),
  //   FieldModel(id: 15, name: AppLocalizations.of(Get.context!)!.swati),
  //   FieldModel(id: 16, name: AppLocalizations.of(Get.context!)!.vishakha),
  //   FieldModel(id: 17, name: AppLocalizations.of(Get.context!)!.anuradha),
  //   FieldModel(id: 18, name: AppLocalizations.of(Get.context!)!.jyeshtha),
  //   FieldModel(id: 19, name: AppLocalizations.of(Get.context!)!.mula),
  //   FieldModel(id: 20, name: AppLocalizations.of(Get.context!)!.purvaashadha),
  //   FieldModel(id: 21, name: AppLocalizations.of(Get.context!)!.uttaraashadha),
  //   FieldModel(id: 22, name: AppLocalizations.of(Get.context!)!.shravana),
  //   FieldModel(id: 23, name: AppLocalizations.of(Get.context!)!.dhanishta),
  //   FieldModel(id: 24, name: AppLocalizations.of(Get.context!)!.shatabhisha),
  //   FieldModel(
  //       id: 25, name: AppLocalizations.of(Get.context!)!.purvabhadrapada),
  //   FieldModel(
  //       id: 26, name: AppLocalizations.of(Get.context!)!.uttarabhadrapada),
  //   FieldModel(id: 27, name: AppLocalizations.of(Get.context!)!.revati),
  // ];

  var Nakshatra = <FieldModel>[].obs;

  void nakshatraList() {
    String? language = sharedPreferences?.getString("Language");
    Nakshatra.value = language == 'en'
        ? [
            FieldModel(id: 1, name: "Ashwini"),
            FieldModel(id: 2, name: "Bharani"),
            FieldModel(id: 3, name: "Krittika"),
            FieldModel(id: 4, name: "Rohini"),
            FieldModel(id: 5, name: "Mrigashirsha"),
            FieldModel(id: 6, name: "Ardra"),
            FieldModel(id: 7, name: "Punarvasu"),
            FieldModel(id: 8, name: "Pushya"),
            FieldModel(id: 9, name: "Ashlesha"),
            FieldModel(id: 10, name: "Magha"),
            FieldModel(id: 11, name: "Purva Phalguni"),
            FieldModel(id: 12, name: "Uttara Phalguni"),
            FieldModel(id: 13, name: "Hasta"),
            FieldModel(id: 14, name: "Chitra"),
            FieldModel(id: 15, name: "Swati"),
            FieldModel(id: 16, name: "Vishakha"),
            FieldModel(id: 17, name: "Anuradha"),
            FieldModel(id: 18, name: "Jyeshtha"),
            FieldModel(id: 19, name: "Mula"),
            FieldModel(id: 20, name: "Purva Ashadha"),
            FieldModel(id: 21, name: "Uttara Ashadha"),
            FieldModel(id: 22, name: "Shravana"),
            FieldModel(id: 23, name: "Dhanishta"),
            FieldModel(id: 24, name: "Shatabhisha"),
            FieldModel(id: 25, name: "Purva Bhadrapada"),
            FieldModel(id: 26, name: "Uttara Bhadrapada"),
            FieldModel(id: 27, name: "Revati"),
          ]
        : [
            FieldModel(id: 1, name: "अश्विनी"),
            FieldModel(id: 2, name: "भरणी"),
            FieldModel(id: 3, name: "कृत्तिका"),
            FieldModel(id: 4, name: "रोहिणी"),
            FieldModel(id: 5, name: "मृगशिरा"),
            FieldModel(id: 6, name: "आर्द्रा"),
            FieldModel(id: 7, name: "पुनर्वसू"),
            FieldModel(id: 8, name: "पुष्य"),
            FieldModel(id: 9, name: "आश्लेषा"),
            FieldModel(id: 10, name: "मेघा"),
            FieldModel(id: 11, name: "पूर्वा फाल्गुनी"),
            FieldModel(id: 12, name: "उत्तरा फाल्गुनी"),
            FieldModel(id: 13, name: "हस्त"),
            FieldModel(id: 14, name: "चित्रा"),
            FieldModel(id: 15, name: "स्वाती"),
            FieldModel(id: 16, name: "विशाखा"),
            FieldModel(id: 17, name: "अनुराधा"),
            FieldModel(id: 18, name: "ज्येष्ठा"),
            FieldModel(id: 19, name: "मूल"),
            FieldModel(id: 20, name: "पूर्वाषाढा"),
            FieldModel(id: 21, name: "उत्तराषाढा"),
            FieldModel(id: 22, name: "श्रवण"),
            FieldModel(id: 23, name: "धनिष्ठा"),
            FieldModel(id: 24, name: "शततारका"),
            FieldModel(id: 25, name: "पूर्वा भाद्रपदा"),
            FieldModel(id: 26, name: "उत्तर भाद्रपदा"),
            FieldModel(id: 27, name: "रेवती"),
          ];
  }
  // final List<FieldModel> Nakshatra = [
  //   FieldModel(id: 1, name: "Ashwini"),
  //   FieldModel(id: 2, name: "Bharani"),
  //   FieldModel(id: 3, name: "Krittika"),
  //   FieldModel(id: 4, name: "Rohini"),
  //   FieldModel(id: 5, name: "Mrigashirsha"),
  //   FieldModel(id: 6, name: "Ardra"),
  //   FieldModel(id: 7, name: "Punarvasu"),
  //   FieldModel(id: 8, name: "Pushya"),
  //   FieldModel(id: 9, name: "Ashlesha"),
  //   FieldModel(id: 10, name: "Magha"),
  //   FieldModel(id: 11, name: "Purva Phalguni"),
  //   FieldModel(id: 12, name: "Uttara Phalguni"),
  //   FieldModel(id: 13, name: "Hasta"),
  //   FieldModel(id: 14, name: "Chitra"),
  //   FieldModel(id: 15, name: "Swati"),
  //   FieldModel(id: 16, name: "Vishakha"),
  //   FieldModel(id: 17, name: "Anuradha"),
  //   FieldModel(id: 18, name: "Jyeshtha"),
  //   FieldModel(id: 19, name: "Mula"),
  //   FieldModel(id: 20, name: "Purva Ashadha"),
  //   FieldModel(id: 21, name: "Uttara Ashadha"),
  //   FieldModel(id: 22, name: "Shravana"),
  //   FieldModel(id: 23, name: "Dhanishta"),
  //   FieldModel(id: 24, name: "Shatabhisha"),
  //   FieldModel(id: 25, name: "Purva Bhadrapada"),
  //   FieldModel(id: 26, name: "Uttara Bhadrapada"),
  //   FieldModel(id: 27, name: "Revati"),
  // ];

// gan
  Rxn<FieldModel> selectedGan = Rxn<FieldModel>();
  // Method to update the selected zodiac sign
  void updateGan(FieldModel sign) {
    selectedGan.value = sign;
  }

  var Gan = <FieldModel>[].obs;

  void ganListing() {
    String? language = sharedPreferences?.getString("Language");
    Gan.value = language == 'en'
        ? [
            FieldModel(id: 1, name: 'Dev Gan'),
            FieldModel(id: 2, name: 'Manushya Gan'),
            FieldModel(id: 3, name: 'Rakshas Gan'),
          ]
        : [
            FieldModel(id: 1, name: 'देव गण'),
            FieldModel(id: 2, name: 'मनुष्य गण'),
            FieldModel(id: 3, name: 'राक्षस गण'),
          ];
  }

  // final List<FieldModel> Gan = [
  //   FieldModel(id: 1, name: AppLocalizations.of(Get.context!)!.devgan),
  //   FieldModel(id: 2, name: AppLocalizations.of(Get.context!)!.manushyagan),
  //   FieldModel(id: 3, name: AppLocalizations.of(Get.context!)!.rakshasgan),
  // ];
// charan
  Rxn<FieldModel> selectedCharan = Rxn<FieldModel>();
  // Method to update the selected zodiac sign
  void updateCharan(FieldModel sign) {
    selectedCharan.value = sign;
  }

  var Charan = <FieldModel>[].obs;

  void charanListing() {
    String? language = sharedPreferences?.getString("Language");
    Charan.value = language == 'en'
        ? [
            FieldModel(id: 1, name: "First"),
            FieldModel(id: 2, name: "Second"),
            FieldModel(id: 3, name: "Third"),
            FieldModel(id: 4, name: "Fourth"),
          ]
        : [
            FieldModel(id: 1, name: "पहिला"),
            FieldModel(id: 2, name: "दुसरा"),
            FieldModel(id: 3, name: "तिसरा"),
            FieldModel(id: 4, name: "चौथा"),
          ];
  }
  // final List<FieldModel> Charan = [
  //   FieldModel(id: 1, name: AppLocalizations.of(Get.context!)!.first),
  //   FieldModel(id: 2, name: AppLocalizations.of(Get.context!)!.second),
  //   FieldModel(id: 3, name: AppLocalizations.of(Get.context!)!.third),
  //   FieldModel(id: 4, name: AppLocalizations.of(Get.context!)!.fourth),
  // ];

  Rxn<FieldModel> selectedNadi = Rxn<FieldModel>();
  // Method to update the selected zodiac sign
  void updateNadi(FieldModel sign) {
    selectedNadi.value = sign;
  }

  var Nadi = <FieldModel>[].obs;

  void nandiListing() {
    String? language = sharedPreferences?.getString("Language");
    Nadi.value = language == 'en'
        ? [
            FieldModel(id: 1, name: "Adi"),
            FieldModel(id: 2, name: "Madhya"),
            FieldModel(id: 3, name: "Antya"),
          ]
        : [
            FieldModel(id: 1, name: "आदि"),
            FieldModel(id: 2, name: "मध्य"),
            FieldModel(id: 3, name: "अंत्य"),
          ];
  }

  // final List<FieldModel> Nadi = [
  //   FieldModel(id: 1, name: AppLocalizations.of(Get.context!)!.adi),
  //   FieldModel(id: 2, name: AppLocalizations.of(Get.context!)!.madhya),
  //   FieldModel(id: 3, name: AppLocalizations.of(Get.context!)!.antya),
  // ];

  var selectedGotra = "".obs;
}
