import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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
import 'package:_96kuliapp/screens/plans/upgradeScreen.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepSix.dart';

class EditEducationController extends GetxController {
  var isSubmitted = false.obs;
  TextEditingController designationController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController jobLocation = TextEditingController();
  TextEditingController nativePlace = TextEditingController();
  TextEditingController othereducation = TextEditingController();
  TextEditingController otheroccupation = TextEditingController();

  TextEditingController otherspecialization = TextEditingController();

//   final LocationController _locationController = Get.put(LocationController());
  final EmplyedInController _emplyedInController =
      Get.put(EmplyedInController());
  final OccupationController _occupationController =
      Get.put(OccupationController());
  final SpecializationController _specializationController =
      Get.put(SpecializationController());
  final EducationController _educationController =
      Get.put(EducationController());
  var selectedCountry = "".obs;
  var selectedCountryPermanent = "".obs;
  var selectedState = "".obs;
  var isLoading = false.obs;
  var isPageLoading = false.obs;
  var basicInfoData = {}.obs; // To hold the API response data
  var selectedStatePermanent = "".obs;
  var selectedCity = "".obs;
  var selectedCityPermanent = "".obs;
  var selectedWorkMode = FieldModel().obs;

  var selectedWorkModeValidated = false.obs;
  var isSameAdress = false.obs;

  var itemsList = <FieldModel>[].obs; // Original list of items
  var filteredItemsList = <FieldModel>[].obs; // Filtered list based on search
  var selectedAnnualIncome = Rxn<FieldModel>(); // Selected item
  var searchQuery = ''.obs; // Search query

  // Method to select item based on ID
  void setSelectedAnnualIncome(FieldModel newItem) {
    selectedAnnualIncome.value = newItem;
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

  @override
  void onInit() {
    super.onInit();
    fetchEducationInfo(); // Your existing method, no change here
    loadItems(); // Load the list of items
    //  print("This is education value ${_educationController.selectedEducation.value.id } and for employed in ${_emplyedInController.selectedOption.value.id}");
  }

  // Method to load data into the list (you can fetch this from API instead)
  void loadItems() {
    String? language = sharedPreferences?.getString("Language");
    List<Map<String, dynamic>> jsonData = language == 'en'
        ? [
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
            // {"id": 1, "name": "No Income "},
            // {"id": 2, "name": "0 - 1 Lakh Per Annum"},
            // {"id": 3, "name": "1 - 2 Lakhs Per Annum"},
            // {"id": 4, "name": "2 - 3 Lakhs Per Annum"},
            // {"id": 5, "name": "3 - 5 Lakhs Per Annum"},
            // {"id": 6, "name": "5 - 7 Lakhs Per Annum"},
            // {"id": 7, "name": "7 - 10 Lakhs Per Annum"},
            // {"id": 8, "name": "10 - 15 Lakhs Per Annum"},
            // {"id": 9, "name": "15 - 20 Lakhs Per Annum"},
            // {"id": 10, "name": "16 - 18 Lakhs Per Annum"},
            // {"id": 11, "name": "18 - 20 Lakhs Per Annum"},
            // {"id": 12, "name": "20 - 30 Lakhs Per Annum"},
            // {"id": 13, "name": "30 - 40 Lakhs Per Annum"},
            // {"id": 14, "name": "40 - 50 Lakhs Per Annum"},
            // {"id": 15, "name": "50 - 60 Lakhs Per Annum"},
            // {"id": 16, "name": "60 - 70 Lakhs Per Annum"},
            // {"id": 17, "name": "70 - 80 Lakhs Per Annum"},
            // {"id": 18, "name": "80 - 90 Lakhs Per Annum"},
            // {"id": 19, "name": "90 Lakhs - 1 Crore Per Annum"},
            // {"id": 20, "name": "1 Crore & Above Per Annum"}
          ]
        : [
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
    itemsList.value =
        jsonData.map((item) => FieldModel.fromJson(item)).toList();

    // Initially, set filteredItemsList to show all items
    filteredItemsList.value = itemsList;
  }

  FieldModel? selectedEducationField;
  FieldModel? selectedSpecializationField;
  FieldModel? selectedOccupation;
  // Observable list of items
  // var itemsList = <FieldModel>[].obs;

  // Observable selected item
  // var selectedAnnualIncome = Rxn<FieldModel>();

  // Initialize the list (normally you'd fetch this from an API)

  // Set selected item based on user's choice
  final CasteVerificationBlockController _casteVerificationBlockController =
      Get.put(CasteVerificationBlockController());

  Future<void> fetchEducationInfo() async {
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
              '${Appconstants.baseURL}/api/profile-data/EducationCareer?lang=$language'));

      if (response.statusCode == 200) {
        basicInfoData.value = jsonDecode(response.body);
        print("Response is ${response.body}");
        if (basicInfoData["data"]["fields"]["highest_education_id"] != null) {
          await Future.wait([
            _educationController.fetcheducationFromApi(),
            _specializationController.fetchSpecializatiomFromApi(),
            _emplyedInController.fetchemployeedInFromApi(),
            _occupationController.fetchOccupationFromApi(),
          ]);

          // nativePlace.text = basicInfoData["data"]["fields"]["native_place"];
          selectedAnnualIncome.value = itemsList.firstWhereOrNull(
            (element) =>
                element.id == basicInfoData["data"]["fields"]["annual_income"],
          );

          // Optimized search for selected education and specialization
          selectedEducationField = findFieldById(
              _educationController.educationList,
              basicInfoData["data"]["fields"]["highest_education_id"]);
          print("Education id for education is  ${selectedEducationField?.id}");
          _educationController.selectedEducation.value =
              selectedEducationField ?? FieldModel();
          selectedSpecializationField = findFieldById(
              _specializationController.specializationList,
              basicInfoData["data"]["fields"]["specialization"]);
          selectedWorkMode.value.id =
              basicInfoData["data"]["fields"]["work_mode"];

          _specializationController.selectedSpecialization.value =
              selectedSpecializationField ?? FieldModel();
          selectedOccupation = findFieldById(
              _occupationController.educationList,
              basicInfoData["data"]["fields"]["occupation"]);
          _occupationController.selectedOccupation.value =
              selectedOccupation ?? FieldModel();
          _emplyedInController.selectedOption.value =
              _emplyedInController.employedInList.firstWhere(
            (element) =>
                element.id == basicInfoData["data"]["fields"]["employeed"],
            orElse: () => FieldModel(),
          );

          if (basicInfoData["data"]["fields"]["job_location"] != null) {
            print("THIS IS STRING location");
            jobLocation.text = basicInfoData["data"]["fields"]["job_location"];
          }
          if (basicInfoData["data"]["fields"]["designation"] != null) {
            designationController.text =
                basicInfoData["data"]["fields"]["designation"];
          }
          if (basicInfoData["data"]["fields"]["company_name"] != null) {
            companyNameController.text =
                basicInfoData["data"]["fields"]["company_name"];
          }
          if (basicInfoData["data"]["fields"]["other_education"] != null) {
            othereducation.text =
                basicInfoData["data"]["fields"]["other_education"] ?? "";
          }

          if (basicInfoData["data"]["fields"]["other_specialization"] != null) {
            otherspecialization.text =
                basicInfoData["data"]["fields"]["other_specialization"] ?? "";
          }
          if (basicInfoData["data"]["fields"]["other_occupation"] != null) {
            otheroccupation.text =
                basicInfoData["data"]["fields"]["other_occupation"] ?? "";
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
        print("Work mode is ${selectedWorkMode.value}");
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
  FieldModel? findFieldById(List<NestedFieldsModel> fieldsList, int? id) {
    for (var fieldGroup in fieldsList) {
      var foundField = fieldGroup.value?.firstWhere(
        (field) => field.id == id,
        orElse: () => FieldModel(), // Default if not found
      );
      if (foundField != null && foundField.id != null) {
        return foundField;
      }
    }
    return null;
  }

  void updateCountry(String value) {
    selectedCountry.value = value;
  }

  void updateCity(String? value) {
    selectedCity.value = value ?? "";
  }

  void updateState(String? value) {
    selectedState.value = value ?? "";
  }

  void updateCountryPermanent(String value) {
    selectedCountryPermanent.value = value;
  }

  void updateCityPermanent(String? value) {
    selectedCityPermanent.value = value ?? "";
  }

  void updateStatePermanent(String? value) {
    selectedStatePermanent.value = value ?? "";
  }

  void updateWorkMode(FieldModel value) {
    selectedWorkMode.value = value;
    selectedWorkModeValidated.value = true;
  }

  final MyProfileController _profileController = Get.put(MyProfileController());

  Future<void> EducationForm({
    required int highestEducation,
    required String otherEducation,
    required int specialization,
    required String otherSpecialization,
    required int employedIn,
    required int workMode,
    required int occupation,
    required String otherOccupation,
    required String? designation,
    required String? companyName,
    required int annualIncome,
    required String currentJobLocation,
  }) async {
    print("Inside the function");
    String url = '${Appconstants.baseURL}/api/update/EducationCareer';
    isLoading.value = true;

    // The request body
    Map<String, dynamic> body = {
      "highest_education_id": highestEducation,
      "other_education": otherEducation,
      "specialization": specialization,
      "other_specialization": otherSpecialization,
      "employeed": employedIn,
      "work_mode": workMode,
      "other_occupation": otherOccupation,
      "annual_income": annualIncome,
      "job_location": currentJobLocation,
    };

    // Adding occupation, designation, and company name only if occupation is not 0
    if (occupation != 0) {
      body["occupation"] = occupation;
      body["designation"] = designation;
      body["company_name"] = companyName;
    }

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
      print('Registration successful $body');
      if (response.statusCode == 200) {
        print('Registration successful');
        var data = jsonDecode(response.body);
        Get.back();
        _profileController.fetchUserInfo();

        print('Response body: ${response.body}');
      } else {
        print('Failed to register: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: in data $e');
    } finally {
      isLoading.value = false;
    }
  }
}
