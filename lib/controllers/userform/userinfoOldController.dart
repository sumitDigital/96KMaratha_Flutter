import 'dart:convert';

import 'package:_96kuliapp/commons/dialogues/forceblock.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/models/forms/CityModel.dart';
import 'package:_96kuliapp/models/forms/CountryModel.dart';
import 'package:_96kuliapp/models/forms/StateModel.dart';
import 'package:_96kuliapp/screens/ProfilePhotoRequestToChange/ProfilePhotoRequestToChangeScreen.dart';
import 'package:_96kuliapp/screens/plans/upgradeScreen.dart';
import 'package:_96kuliapp/screens/userInfoForms/pendingForms/userinfoIncompleteForm.dart';
import 'package:_96kuliapp/screens/userInfoForms/pendingForms/userinfoIncompleteForm1.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepSix.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';
import 'package:_96kuliapp/utils/bottomnavBar.dart';

class userInfo_IncompletController extends GetxController {
  var isPageLoading = false.obs;
  var isloading = false.obs;
  var isSubmitted = false.obs;

  var employedInList = <FieldModel>[].obs;
  final selectedItems = <FieldModel>[].obs;
  var selectedAnnualIncome = Rxn<FieldModel>();
  var filteredItemsList = <FieldModel>[].obs; // Filtered list based on search
  var itemsList = <FieldModel>[].obs; // Original list of items
  var searchQuery = ''.obs; // Search query

  TextEditingController designationController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController jobLocation = TextEditingController();
  TextEditingController nativePlace = TextEditingController();
  TextEditingController othereducation = TextEditingController();
  TextEditingController otheroccupation = TextEditingController();
  TextEditingController otherspecialization = TextEditingController();
  final LocationController _locationController = Get.put(LocationController());

  String? language = sharedPreferences?.getString("Language");
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final facebookAppEvents = FacebookAppEvents();

  var selectedWorkMode = FieldModel().obs;
  var selectedWorkModeValidated = false.obs;
  var isSameAdress = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    loadItems();
    fetchemployeedInFromApi();
    super.onInit();
  }

  void loadItems() {
    String? language = sharedPreferences?.getString("Language");
    List<Map<String, dynamic>> jsonData = [
      {"id": 1, "name": "No Income"},
      {"id": 2, "name": "0 - 1 Lakh Per Annum"},
      {"id": 3, "name": "1 - 2 Lakhs Per Annum"},
      {"id": 4, "name": "2 - 3 Lakhs Per Annum"},
      {"id": 5, "name": "3 - 5 Lakhs Per Annum"},
      {"id": 6, "name": "5 - 7 Lakhs Per Annum"},
      {"id": 7, "name": "7 - 10 Lakhs Per Annum"},
      {"id": 8, "name": "10 - 15 Lakhs Per Annum"},
      {"id": 9, "name": "15 - 20 Lakhs Per Annum"},
      {"id": 10, "name": "16 - 18 Lakhs Per Annum"},
      {"id": 11, "name": "18 - 20 Lakhs Per Annum"},
      {"id": 13, "name": "20 - 40 Lakhs Per Annum"},
      {"id": 15, "name": "40 - 60 Lakhs Per Annum"},
      {"id": 17, "name": "60 - 80 Lakhs Per Annum"},
      {"id": 19, "name": "80 Lakhs - 1 Crore"},
      {"id": 20, "name": "1 Crore & Above"}
    ];

    List<Map<String, dynamic>> marjsonData = [
      {"id": 1, "name": "कोणतेही उत्पन्न नाही"},
      {"id": 2, "name": "0 - 1 लाख"},
      {"id": 3, "name": "1 - 2 लाख"},
      {"id": 4, "name": "2 - 3 लाख"},
      {"id": 5, "name": "3 - 5 लाख"},
      {"id": 6, "name": "5 - 7 लाख"},
      {"id": 7, "name": "7 - 10 लाख"},
      {"id": 8, "name": "10 - 15 लाख"},
      {"id": 9, "name": "15 - 20 लाख"},
      {"id": 10, "name": "16 - 18 लाख"},
      {"id": 11, "name": "18 - 20 लाख"},
      {"id": 13, "name": "20 - 40 लाख"},
      {"id": 15, "name": "40 - 60 लाख"},
      {"id": 17, "name": "60 - 80 लाख"},
      {"id": 19, "name": "80 लाख - 1 कोटी"},
      {"id": 20, "name": "1 कोटी वरील"}
    ];
    // Map jsonData to the list of items
    itemsList.value = language == "en"
        ? jsonData.map((item) => FieldModel.fromJson(item)).toList()
        : marjsonData.map((item) => FieldModel.fromJson(item)).toList();
    // Initially, set filteredItemsList to show all items
    filteredItemsList.value = itemsList;
  }

  // Method to filter items based on the search query
  void filterItems(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredItemsList.value =
          itemsList; // Show all items when search is empty
    } else {
      filteredItemsList.value = itemsList
          .where((item) => item.name!
              .toLowerCase()
              .contains(query.toLowerCase())) // Filter by name
          .toList();
    }
  }

  void selectAllItems() {
    selectedItems.clear();
    selectedItems.addAll(employedInList);
  }

  void clearAllSelections() {
    selectedItems.clear();
  }

  void toggleSelection(FieldModel item) {
    if (selectedItems.any((selectedItem) => selectedItem.id == item.id)) {
      //  selectedItems.remove(item)
      selectedItems
          .removeWhere((field) => item.id == field.id); // Remove if unselected
    } else {
      selectedItems.add(item);
    }
  }

  void updateWorkMode(FieldModel value) {
    selectedWorkMode.value = value;
    selectedWorkModeValidated.value = true;
  }

  // Method to select item based on ID
  void setSelectedAnnualIncome(FieldModel newItem) {
    selectedAnnualIncome.value = newItem;
  }

  Future<void> fetchemployeedInFromApi() async {
    try {
      isloading(true);
      final response = await http.get(Uri.parse(
          '${Appconstants.baseURL}/api/fetch/employeed_in?lang=$language'));
      if (response.statusCode == 200) {
        print("PartnerEmploye check");
        List<dynamic> data = jsonDecode(response.body);
        employedInList.value = data.map((e) => FieldModel.fromJson(e)).toList();
        print("PartnerEmploye check1 $data");
      } else {
        print("Error in emplyed in");
      }
    } finally {
      isloading(false); // Ensure the loading state is reset
    }
  }

  Future<void> EmployementForm({
    required int employedIn, // Int
    int? workMode, // Int
    required String designation,
    required String companyName,
    required int annualIncome, // Int
    required String currentJobLocation,
    required List<int> PatnerEMPIn,
    required int? presentCountry, // Int
    required int? presentState, // Int
    required int? presentCity, // Int
    required int? permanentCountry, // Int
    required int? permanentState, // Int
    required int? permanentCity, // Int
    required int? specialization, // Int
    required String? otherSpecialization,
    required int? occupation, // Int
    required String? otherOccupation,
    required int? highestEducation, // Int
    required String? otherEducation,
  }) async {
    String url = '${Appconstants.baseURL}/api/incomplete';
    isloading.value = true;

    // The request body
    Map<String, dynamic> body = {
      "employed_in": employedIn,
      "work_mode": workMode,
      "partner_employed_in": PatnerEMPIn,
      "designation": designation,
      "company_name": companyName,
      "annual_income": annualIncome,
      "current_job_location": currentJobLocation,
      "highest_education": highestEducation,
      "other_education": otherEducation,
      "specialization": specialization,
      "other_specialization": otherSpecialization,
      // "employed_in": employedIn,
      // "native_place": nativePlace,
      // "work_mode": workMode,
      "present_country": presentCountry,
      "present_state": presentState,
      "present_city": presentCity,
      "permanent_country": permanentCountry,
      "permanent_state": permanentState,
      "permanent_city": permanentCity,
      "occupation": occupation,
      // "other_occupation": otherOccupation,

      // "annual_income": annualIncome,
      // "current_job_location": currentJobLocation,
      // "same_address": sameAddress // 1 if checked, otherwise 0
    };
    /*
     "other_occupation": otherOccupation,
    "designation": designation,
    "company_name": companyName,*/
    // if (occupation != 0) {
    //   body["occupation"] = occupation;
    //   body["designation"] = designation;
    //   body["company_name"] = companyName;
    // }

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

      print('Registration successful $token');
      print('Registration successful $body');
      print('Response status: $response');

      if (response.statusCode == 200) {
        print('Registration successful');
        analytics.logEvent(name: "app_96k_pending_form_complete_event ").then(
          (value) {
            print("THIS IS SENT NOTIF");
          },
        );
        print("Check 1 ${response.body}");

        var data = jsonDecode(response.body);
        // sharedPreferences!.setString("PageIndex", "4");
        facebookAppEvents.logEvent(name: "Fb_96k_app_education_form_completed");
        print("Check 1 $data");
        print('Response body: ${response.body}');
        print("Check 2 Navigation");

        // if (data["redirection"]["pagename"] == "INCOMPLETEFORM") {
        //   WidgetsBinding.instance.addPostFrameCallback((_) {
        //     navigatorKey.currentState!.pushAndRemoveUntil(
        //       MaterialPageRoute(
        //         builder: (context) => const userIncomplete_userForm(),
        //       ),
        //       (route) => false,
        //     );
        //   });
        // } else if (data["redirection"]["pagename"] == "EDIT-PARTNER") {
        //   WidgetsBinding.instance.addPostFrameCallback((_) {
        //     navigatorKey.currentState!.pushAndRemoveUntil(
        //       MaterialPageRoute(
        //         builder: (context) => const userIncomplete_userFormOne(),
        //       ),
        //       (route) => false,
        //     );
        //   });
        // } else if (data["redirection"]["pagename"] == "PLAN") {
        //   sharedPreferences!.setString("PageIndex", "9");
        //   WidgetsBinding.instance.addPostFrameCallback((_) {
        //     navigatorKey.currentState!.pushAndRemoveUntil(
        //       MaterialPageRoute(
        //         builder: (context) => const UpgradePlan(),
        //       ),
        //       (route) => false,
        //     );
        //   });
        // } else if (data["redirection"]["pagename"] == "UPDATE-PHOTO") {
        //   WidgetsBinding.instance.addPostFrameCallback((_) {
        //     navigatorKey.currentState!.pushAndRemoveUntil(
        //       MaterialPageRoute(
        //         builder: (context) => const ProfilePhotoRequestToChangeScreen(),
        //       ),
        //       (route) => false,
        //     );
        //   });
        // }
        navigatorKey.currentState!.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const BottomNavBar(),
          ),
          (route) => false,
        );
      } else {
        print('Failed to register: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isloading.value = false;
    }
  }

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
}
