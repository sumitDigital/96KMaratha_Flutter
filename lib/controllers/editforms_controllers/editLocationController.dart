import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/commons/dialogues/forceblock.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationBlock.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationBlockController.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationScreen.dart';
import 'package:_96kuliapp/controllers/formfields/educationController.dart';
import 'package:_96kuliapp/controllers/formfields/employedInController.dart';
import 'package:_96kuliapp/controllers/formfields/occupationController.dart';
import 'package:_96kuliapp/controllers/formfields/specializationController.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/controllers/viewProfileControllers/myprofileController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/models/forms/CityModel.dart';
import 'package:_96kuliapp/models/forms/CountryModel.dart';
import 'package:_96kuliapp/models/forms/EducationModel.dart';
import 'package:_96kuliapp/models/forms/StateModel.dart';
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:http/http.dart' as http;
import 'package:_96kuliapp/screens/plans/upgradeScreen.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepSix.dart';

class EditLocationController extends GetxController {
  var isSubmitted = false.obs;

  TextEditingController nativePlace = TextEditingController();

  final LocationController _locationController = Get.put(LocationController());

  var isLoading = false.obs;
  var isPageLoading = false.obs;
  var basicInfoData = {}.obs; // To hold the API response data

  var selectedWorkModeValidated = false.obs;
  var isSameAdress = false.obs;

  // Method to select item based on ID

  @override
  void onInit() {
    super.onInit();
    fetchLocationInfo(); // Your existing method, no change here
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

  Future<void> fetchLocationInfo() async {
    String? token = sharedPreferences!.getString("token");
    String? language = sharedPreferences?.getString("Language");
    try {
      isPageLoading(true);
      // Fetch both education and specialization data in parallel
      final response = await http.get(
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $token",
          },
          Uri.parse(
              '${Appconstants.baseURL}/api/profile-data/Location?lang=$language'));

      if (response.statusCode == 200) {
        basicInfoData.value = jsonDecode(response.body);
        print("Response is ${response.body}");
        if (basicInfoData["data"]["fields"]["present_country"] != null) {
          await Future.wait([
            _locationController.fetchCountries(),
            _locationController.fetchState(
                basicInfoData["data"]["fields"]["present_country"].toString()),
            _locationController.fetchCity(
                basicInfoData["data"]["fields"]["present_state"].toString())
          ]);

          nativePlace.text = basicInfoData["data"]["fields"]["native_place"];

          _locationController.presentselectedCountry.value =
              _locationController.countries.firstWhere(
            (element) =>
                element.id ==
                basicInfoData["data"]["fields"]["present_country"],
            orElse: () => CountryModel(),
          );
          _locationController.presentselectedState.value =
              _locationController.states.firstWhere(
            (element) =>
                element.id == basicInfoData["data"]["fields"]["present_state"],
            orElse: () => StateModel(),
          );
          _locationController.presentselectedCity.value =
              _locationController.cities.firstWhere(
            (element) =>
                element.id == basicInfoData["data"]["fields"]["present_city"],
            orElse: () => CityModel(),
          );

          if (basicInfoData["data"]["fields"]["present_city"] !=
              basicInfoData["data"]["fields"]["permanent_city"]) {
            if (basicInfoData["data"]["fields"]["present_state"] !=
                basicInfoData["data"]["fields"]["permanent_state"]) {
              if (basicInfoData["data"]["fields"]["present_country"] !=
                  basicInfoData["data"]["fields"]["permanent_country"]) {
                _locationController.permanentSelectedCountry.value =
                    _locationController.countries.firstWhere(
                  (element) =>
                      element.id ==
                      basicInfoData["data"]["fields"]["permanent_country"],
                  orElse: () => CountryModel(),
                );

                await _locationController.fetchState(
                    basicInfoData["data"]["fields"]["permanent_country"]);

                _locationController.permanentSelectedState.value =
                    _locationController.states.firstWhere(
                  (element) =>
                      element.id ==
                      basicInfoData["data"]["fields"]["permanent_state"],
                  orElse: () => StateModel(),
                );
                await _locationController.fetchCity(
                    basicInfoData["data"]["fields"]["permanent_city"]);
                _locationController.permanentSelectedCity.value =
                    _locationController.cities.firstWhere(
                  (element) =>
                      element.id ==
                      basicInfoData["data"]["fields"]["permanent_city"],
                );
              } else {
                _locationController.permanentSelectedCountry.value =
                    _locationController.presentselectedCountry.value;
                _locationController.permanentSelectedState.value =
                    _locationController.states.firstWhere(
                  (element) =>
                      element.id ==
                      basicInfoData["data"]["fields"]["permanent_state"],
                  orElse: () => StateModel(),
                );
                await _locationController.fetchCity(_locationController
                    .permanentSelectedCity.value.id
                    .toString());
                _locationController.permanentSelectedCity.value =
                    _locationController.cities.firstWhere(
                  (element) =>
                      element.id ==
                      basicInfoData["data"]["fields"]["permanent_city"],
                  orElse: () => CityModel(),
                );
              }
            } else {
              _locationController.permanentSelectedState.value =
                  _locationController.presentselectedState.value;

              _locationController.permanentSelectedCountry.value =
                  _locationController.presentselectedCountry.value;
              _locationController.permanentSelectedCity.value =
                  _locationController.cities.firstWhere(
                      (element) =>
                          element.id ==
                          basicInfoData["data"]["fields"]["permanent_city"],
                      orElse: () => CityModel());
            }
          } else {
            _locationController.permanentSelectedCity.value =
                _locationController.presentselectedCity.value;
            _locationController.permanentSelectedCountry.value =
                _locationController.presentselectedCountry.value;
            _locationController.permanentSelectedState.value =
                _locationController.presentselectedState.value;
/*  if(basicInfoData["present_state"] == basicInfoData["permanent_state"]){
_locationController.permanentSelectedCity.value = _locationController.cities.firstWhere((element) => element.id == basicInfoData["permanent_city"], orElse: () =>  CityModel() );
  }else{
_locationController.fetchCity(basicInfoData["permanent_state"].toString()) ; 
_locationController.permanentSelectedCity.value = _locationController.cities.firstWhere((element) => element.id == basicInfoData["permanent_city"], orElse: () =>  CityModel() );

  } */
            /*
  _locationController.permanentSelectedCountry.value = _locationController.countries.firstWhere((element) => element.id == basicInfoData["permanent_country"] , orElse: () => CountryModel(),);
   _locationController.permanentSelectedState.value = _locationController.states.firstWhere((element) => element.id == basicInfoData["permanent_state"], orElse: () => StateModel(),);
   _locationController.permanentSelectedCity.value = _locationController.cities.firstWhere((element) => element.id == basicInfoData["permanent_city"], orElse: () => CityModel(),);
*/
          }
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

  void updateSameAddress() {
    isSameAdress.value = !isSameAdress.value;
    if (isSameAdress.value == true) {
      _locationController.permanentSelectedCity.value =
          _locationController.presentselectedCity.value;
      _locationController.permanentSelectedState.value =
          _locationController.presentselectedState.value;
      _locationController.permanentSelectedCountry.value =
          _locationController.presentselectedCountry.value;
    } else {
      _locationController.permanentSelectedCity.value = CityModel();
      _locationController.permanentSelectedState.value = StateModel();
      _locationController.permanentSelectedCountry.value = CountryModel();
    }
  }

  final MyProfileController _profileController = Get.put(MyProfileController());

  Future<void> LocationForm({
    // Int
    required String nativePlace,
    // Int
    required int presentCountry, // Int
    required int presentState, // Int
    required int presentCity, // Int
    required int permanentCountry, // Int
    required int permanentState, // Int
    required int permanentCity, // Int

    required int sameAddress,
  }) async {
    String url = '${Appconstants.baseURL}/api/update/Location';
    isLoading.value = true;

    // The request body
    Map<String, dynamic> body = {
      "native_place": nativePlace,

      "present_country": presentCountry,
      "present_state": presentState,
      "present_city": presentCity,
      "permanent_country": permanentCountry,
      "permanent_state": permanentState,
      "permanent_city": permanentCity,

      "same_address": sameAddress // 1 if checked, otherwise 0
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
        Get.back();
        _profileController.fetchUserInfo();
        // Get.toNamed(AppRouteNames.userInfoStepThree);
      } else {
        print('Failed to register: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
