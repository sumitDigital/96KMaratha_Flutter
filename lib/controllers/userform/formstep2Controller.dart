import 'dart:async';
import 'dart:convert';

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationBlock.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationBlockController.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationScreen.dart';
import 'package:_96kuliapp/controllers/formfields/educationController.dart';
import 'package:_96kuliapp/controllers/formfields/employedInController.dart';
import 'package:_96kuliapp/controllers/formfields/occupationController.dart';
import 'package:_96kuliapp/controllers/formfields/specializationController.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/main.dart';
import 'package:http/http.dart' as http;
import 'package:_96kuliapp/models/forms/CityModel.dart';
import 'package:_96kuliapp/models/forms/CountryModel.dart';
import 'package:_96kuliapp/models/forms/EducationModel.dart';
import 'package:_96kuliapp/models/forms/StateModel.dart';
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepThree.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';

class StepTwoController extends GetxController {
  var isSubmitted = false.obs;
  TextEditingController designationController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController jobLocation = TextEditingController();
  TextEditingController nativePlace = TextEditingController();
  TextEditingController othereducation = TextEditingController();
  TextEditingController otheroccupation = TextEditingController();

  TextEditingController otherspecialization = TextEditingController();

  final facebookAppEvents = FacebookAppEvents();

  final LocationController _locationController = Get.put(LocationController());
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

  // String? language = sharedPreferences?.getString("Language");

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

  var endhours = 0.obs;
  var endminutes = 0.obs;
  var endseconds = 0.obs;
  @override
  void onInit() {
    super.onInit();
    fetchEducationInfo(); // Your existing method, no change here
    loadItems(); // Load the list of items
    // print("language is $language");
    //  print("This is education value ${_educationController.selectedEducation.value.id } and for employed in ${_emplyedInController.selectedOption.value.id}");
  }

  // Method to load data into the list (you can fetch this from API instead)
  void loadItems() {
    String? language = sharedPreferences?.getString("Language");
    List<Map<String, dynamic>> jsonData = [
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

  FieldModel? selectedEducationField;
  FieldModel? selectedSpecializationField;
  FieldModel? selectedOccupation;
  // Observable list of items
  // var itemsList = <FieldModel>[].obs;

  // Observable selected item
  // var selectedAnnualIncome = Rxn<FieldModel>();

  // Initialize the list (normally you'd fetch this from an API)
  var headingText = "".obs;
  var headingImage = "".obs;

  final CasteVerificationBlockController _casteVerificationBlockController =
      Get.put(CasteVerificationBlockController());

  // Set selected item based on user's choice

  Future<void> fetchEducationInfo() async {
    String? token = sharedPreferences!.getString("token");

    try {
      String? language = sharedPreferences?.getString("Language");
      isPageLoading(true);
      // Fetch both education and specialization data in parallel
      final response = await http.get(
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $token",
          },
          Uri.parse(
              '${Appconstants.baseURL}/api/education-and-career-data?lang=$language'));

      if (response.statusCode == 200) {
        basicInfoData.value = jsonDecode(response.body);
        print("Response Step2 ${response.body}");
        print("Offer Image1 ${basicInfoData["Offer_Img"]}");
        headingText.value = basicInfoData["Offer_Heading"];
        headingImage.value = basicInfoData["Offer_Img"];
        if (basicInfoData["End_Date_time"] != null) {
          String dateTimeString = basicInfoData["End_Date_time"];

          // Define the format of the input string (YYYY-MM-DD HH:mm:ss)
          DateFormat inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

          // Parse the string into a DateTime object
          DateTime parsedDateTime = inputFormat.parse(dateTimeString);

          // Get the current DateTime
          DateTime currentDateTime = DateTime.now();

          // Calculate the difference (Duration)
          Duration difference = parsedDateTime.difference(currentDateTime);

          // Extract hours, minutes, and seconds from the Duration
          endhours.value = difference.inHours;
          endminutes.value = difference.inMinutes %
              60; // Get the remainder of minutes after hours
          endseconds.value = difference.inSeconds %
              60; // Get the remainder of seconds after minutes

          // Output the results
          print("Difference:");
          print("Hours: in time $endhours");
          print("Minutes: $endminutes");
          print("Seconds: $endseconds");
        }
        if (basicInfoData["highest_education"] != null) {
          await Future.wait([
            _educationController.fetcheducationFromApi(),
            _specializationController.fetchSpecializatiomFromApi(),
            _emplyedInController.fetchemployeedInFromApi(),
            _occupationController.fetchOccupationFromApi(),
            _locationController.fetchCountries(),
            _locationController
                .fetchState(basicInfoData["present_country"].toString()),
            _locationController
                .fetchCity(basicInfoData["present_state"].toString())
          ]);

          selectedWorkMode.value.id = basicInfoData["work_mode"];

          nativePlace.text = basicInfoData["native_place"];
          selectedAnnualIncome.value = itemsList.firstWhereOrNull(
            (element) => element.id == basicInfoData["annual_income"],
          );

          // Optimized search for selected education and specialization
          selectedEducationField = findFieldById(
              _educationController.educationList,
              basicInfoData["highest_education"]);
          _educationController.selectedEducation.value =
              selectedEducationField ?? FieldModel();
          selectedSpecializationField = findFieldById(
              _specializationController.specializationList,
              basicInfoData["specialization"]);

          _specializationController.selectedSpecialization.value =
              selectedSpecializationField ?? FieldModel();
          selectedOccupation = findFieldById(
              _occupationController.educationList, basicInfoData["occupation"]);
          _occupationController.selectedOccupation.value =
              selectedOccupation ?? FieldModel();
          _emplyedInController.selectedOption.value =
              _emplyedInController.employedInList.firstWhere(
            (element) => element.id == basicInfoData["employed_in"],
            orElse: () => FieldModel(),
          );
          _locationController.presentselectedCountry.value =
              _locationController.countries.firstWhere(
            (element) => element.id == basicInfoData["present_country"],
            orElse: () => CountryModel(),
          );
          _locationController.presentselectedState.value =
              _locationController.states.firstWhere(
            (element) => element.id == basicInfoData["present_state"],
            orElse: () => StateModel(),
          );
          _locationController.presentselectedCity.value =
              _locationController.cities.firstWhere(
            (element) => element.id == basicInfoData["present_city"],
            orElse: () => CityModel(),
          );
          print(
              "Select value step2 ${_locationController.presentselectedCity.value}");

          if (basicInfoData["present_city"] !=
              basicInfoData["permanent_city"]) {
            if (basicInfoData["present_state"] !=
                basicInfoData["permanent_state"]) {
              if (basicInfoData["present_country"] !=
                  basicInfoData["permanent_country"]) {
                _locationController.permanentSelectedCountry.value =
                    _locationController.countries.firstWhere(
                  (element) => element.id == basicInfoData["permanent_country"],
                  orElse: () => CountryModel(),
                );

                await _locationController
                    .fetchState(basicInfoData["permanent_country"]);

                _locationController.permanentSelectedState.value =
                    _locationController.states.firstWhere(
                  (element) => element.id == basicInfoData["permanent_state"],
                  orElse: () => StateModel(),
                );
                await _locationController
                    .fetchCity(basicInfoData["permanent_city"]);
                _locationController.permanentSelectedCity.value =
                    _locationController.cities.firstWhere(
                  (element) => element.id == basicInfoData["permanent_city"],
                );
              } else {
                _locationController.permanentSelectedCountry.value =
                    _locationController.presentselectedCountry.value;
                _locationController.permanentSelectedState.value =
                    _locationController.states.firstWhere(
                  (element) => element.id == basicInfoData["permanent_state"],
                  orElse: () => StateModel(),
                );
                await _locationController.fetchCity(_locationController
                    .permanentSelectedCity.value.id
                    .toString());
                _locationController.permanentSelectedCity.value =
                    _locationController.cities.firstWhere(
                  (element) => element.id == basicInfoData["permanent_city"],
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
                          element.id == basicInfoData["permanent_city"],
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
          if (basicInfoData["current_job_location"] != null) {
            print("THIS IS STRING location");
            jobLocation.text = basicInfoData["current_job_location"];
          }
          if (basicInfoData["designation"] != null) {
            designationController.text = basicInfoData["designation"];
          }
          if (basicInfoData["company_name"] != null) {
            companyNameController.text = basicInfoData["company_name"];
          }
          if (basicInfoData["other_education"] != null) {
            othereducation.text = basicInfoData["other_education"] ?? "";
          }

          if (basicInfoData["other_specialization"] != null) {
            otherspecialization.text =
                basicInfoData["other_specialization"] ?? "";
          }
          if (basicInfoData["other_occupation"] != null) {
            otheroccupation.text = basicInfoData["other_occupation"] ?? "";
          }
        }
        print("THIS IS PAGE ${basicInfoData["redirection"]["pagename"]}");
/*if(basicInfoData["redirection"]["pagename"].trim() == "CASTE-VERIFICATION-PENDING"){
print("this is page name inside ${basicInfoData["redirection"]["pagename"]}");

  _casteVerificationBlockController.popup.value = basicInfoData["redirection"]["Popup"];
     navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => CasteVerificationBlock(),) ,   (route) => false,);
 
}else if (basicInfoData["redirection"]["pagename"].trim() == "CASTE-VERIFICATION"){
 //  _casteVerificationBlockController.popup.value = basicInfoData["redirection"]["Popup"];
     navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => CasteVerificationScreen(),) ,   (route) => false,);
 
}*/
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

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<void> EducationForm({
    required int highestEducation, // Int
    required String otherEducation,
    required int specialization, // Int
    required String otherSpecialization,
    required int employedIn, // Int
    required String nativePlace,
    required int workMode, // Int
    required int presentCountry, // Int
    required int presentState, // Int
    required int presentCity, // Int
    required int permanentCountry, // Int
    required int permanentState, // Int
    required int permanentCity, // Int
    required int occupation, // Int
    required String otherOccupation,
    required String designation,
    required String companyName,
    required int annualIncome, // Int
    required String currentJobLocation,
    required int sameAddress,
  }) async {
    String url = '${Appconstants.baseURL}/api/education-and-career';
    isLoading.value = true;

    // The request body
    Map<String, dynamic> body = {
      "highest_education": highestEducation,
      "other_education": otherEducation,
      "specialization": specialization,
      "other_specialization": otherSpecialization,
      "employed_in": employedIn,
      "native_place": nativePlace,
      "work_mode": workMode,
      "present_country": presentCountry,
      "present_state": presentState,
      "present_city": presentCity,
      "permanent_country": permanentCountry,
      "permanent_state": permanentState,
      "permanent_city": permanentCity,
      "other_occupation": otherOccupation,
      "annual_income": annualIncome,
      "current_job_location": currentJobLocation,
      "same_address": sameAddress // 1 if checked, otherwise 0
    };
    /*
     "other_occupation": otherOccupation,
    "designation": designation,
    "company_name": companyName,*/
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

      if (response.statusCode == 200) {
        print('Registration successful');
        analytics.logEvent(name: "app_96k_education_form_completed").then(
          (value) {
            print("THIS IS SENT NOTIF");
          },
        );
        var data = jsonDecode(response.body);
        sharedPreferences!.setString("PageIndex", "4");
        facebookAppEvents.logEvent(name: "Fb_96k_app_education_form_completed");
        print('Response body: ${response.body}');

        // Get.toNamed(AppRouteNames.userInfoStepThree);
        navigatorKey.currentState!.push(MaterialPageRoute(
          builder: (context) => const UserInfoStepThree(),
        ));
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
