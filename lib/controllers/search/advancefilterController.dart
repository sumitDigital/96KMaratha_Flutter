import 'dart:async';
import 'dart:convert';

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/controllers/formfields/castController.dart';
import 'package:_96kuliapp/controllers/formfields/educationController.dart';
import 'package:_96kuliapp/controllers/formfields/occupationController.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Advancefiltercontroller extends GetxController {
  late TextEditingController textController;
  final mybox = Hive.box('myBox');
  var genderValue = "".obs;
  var ageRange = <FieldModel>[].obs;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final facebookAppEvents = FacebookAppEvents();

  @override
  void onInit() {
    super.onInit();
    String gender = mybox.get("gender") == 2 ? "groom" : "bride";
    final String prefix = gender == "groom" ? "96KB" : "96KG";
    textController = TextEditingController(text: prefix);
    heightList();
    updateStatusOptions();
    // Listen for changes to prevent deletion of the prefix
    textController.addListener(() {
      if (!textController.text.startsWith(prefix)) {
        textController.text = prefix; // Reset text to prefix if modified
        textController.selection = TextSelection.fromPosition(
          TextPosition(offset: textController.text.length),
        );
      }
      print("texteditCTR ${textController.text}");
    });
    _castController.selectedCasteList.value = [];
    _castController.selectedSectionList.value = [];
    _castController.selectedSubSectionList.value = [];
    _educationController.selectedEducationList.value = [];
    _occupationController.selectedOccupations.value = [];
    locationController.selectedCities.value = [];
    locationController.selectedCountries.value = [];
    locationController.selectedStates.value = [];

    genderValue.value = mybox.get("gender") == 2 ? "groom" : "bride";
    // Initialize ageRange
    updateAgeRange();
  }

  void updateAgeRange() {
    String? language = sharedPreferences?.getString("Language");
    print("THis is gender ${genderValue.value}");
    ageRange.value = genderValue.value == "groom"
        ? List.generate(53, (index) {
            int age = index + 18; // Starting age for bride
            return FieldModel(
                id: index + 1,
                name: language == 'en'
                    ? '$age Years'
                    : "$age वर्षे"); // ID starts from 1
          })
        : List.generate(50, (index) {
            int age = index + 21; // Starting age for groom
            return FieldModel(
                id: index + 4,
                name: language == 'en'
                    ? '$age Years'
                    : "$age वर्षे"); // ID starts from 4
          });
  }

  var searchedMinAgeList = <FieldModel>[].obs;
  var searchedMAxAgeList = <FieldModel>[].obs;
  var searchedMAxHeightList = <FieldModel>[].obs;
  var searchedMinHeightList = <FieldModel>[].obs;
  var searchedMinAnnualIncomeList = <FieldModel>[].obs;
  var searchedMaxAnnualIncomeList = <FieldModel>[].obs;
  var selectedMinAge = FieldModel().obs;
  var selectedMaxAge = FieldModel().obs;
  var selectedMinHeight = FieldModel().obs;
  var selectedMaxHeight = FieldModel().obs;

  var annualIncomeRange = [
    FieldModel(id: 2, name: '0 Lakh'),
    FieldModel(id: 3, name: '1 Lakh'),
    FieldModel(id: 4, name: '2 Lakhs'),
    FieldModel(id: 5, name: '3 Lakhs'),
    FieldModel(id: 6, name: '5 Lakhs'),
    FieldModel(id: 7, name: '7 Lakhs'),
    FieldModel(id: 8, name: '10 Lakhs'),
    FieldModel(id: 9, name: '15 Lakhs'),
    FieldModel(id: 10, name: '16 Lakhs'),
    FieldModel(id: 11, name: '18 Lakhs'),
    FieldModel(id: 12, name: '20 Lakhs'),
    FieldModel(id: 13, name: '30 Lakhs'),
    FieldModel(id: 14, name: '40 Lakhs'),
    FieldModel(id: 15, name: '50 Lakhs'),
    FieldModel(id: 16, name: '60 Lakhs'),
    FieldModel(id: 17, name: '70 Lakhs'),
    FieldModel(id: 18, name: '80 Lakhs'),
    FieldModel(id: 19, name: '90 Lakhs'),
    // FieldModel(id: 19, name: '90 Lakhs - 1 Crore'),
    FieldModel(id: 20, name: '1 Crore & Above'),
  ].obs;
  // var heightRange = [
  //   {"height": "4' 0\"", "cm": 121.92},
  //   {"height": "4' 1\"", "cm": 124.46},
  //   {"height": "4' 2\"", "cm": 127.00},
  //   {"height": "4' 3\"", "cm": 129.54},
  //   {"height": "4' 4\"", "cm": 132.08},
  //   {"height": "4' 5\"", "cm": 134.62},
  //   {"height": "4' 6\"", "cm": 137.16},
  //   {"height": "4' 7\"", "cm": 139.70},
  //   {"height": "4' 8\"", "cm": 142.24},
  //   {"height": "4' 9\"", "cm": 144.78},
  //   {"height": "4' 10\"", "cm": 147.32},
  //   {"height": "4' 11\"", "cm": 149.86},
  //   {"height": "5' 0\"", "cm": 152.40},
  //   {"height": "5' 1\"", "cm": 154.94},
  //   {"height": "5' 2\"", "cm": 157.48},
  //   {"height": "5' 3\"", "cm": 160.02},
  //   {"height": "5' 4\"", "cm": 162.56},
  //   {"height": "5' 5\"", "cm": 165.10},
  //   {"height": "5' 6\"", "cm": 167.64},
  //   {"height": "5' 7\"", "cm": 170.18},
  //   {"height": "5' 8\"", "cm": 172.72},
  //   {"height": "5' 9\"", "cm": 175.26},
  //   {"height": "5' 10\"", "cm": 177.80},
  //   {"height": "5' 11\"", "cm": 180.34},
  //   {"height": "6' 0\"", "cm": 182.88},
  //   {"height": "6' 1\"", "cm": 185.42},
  //   {"height": "6' 2\"", "cm": 187.96},
  //   {"height": "6' 3\"", "cm": 190.50},
  //   {"height": "6' 4\"", "cm": 193.04},
  //   {"height": "6' 5\"", "cm": 195.58},
  //   {"height": "6' 6\"", "cm": 198.12},
  //   {"height": "6' 7\"", "cm": 200.66},
  //   {"height": "6' 8\"", "cm": 203.20},
  //   {"height": "6' 9\"", "cm": 205.74},
  //   {"height": "6' 10\"", "cm": 208.28},
  //   {"height": "6' 11\"", "cm": 210.82},
  //   {"height": "7' 0\"", "cm": 213.36},
  // ]
  //     .asMap()
  //     .entries
  //     .map((entry) => FieldModel(
  //         id: entry.key + 1,
  //         name: "${entry.value['height']} - ${entry.value['cm']} cm"))
  //     .toList()
  //     .obs;
  var heightRange = <FieldModel>[].obs;

  void heightList() {
    String? language = sharedPreferences?.getString("Language");
    heightRange = [
      {"height": "4' 0\"", 'cm': 121.92},
      {"height": "4' 1\"", 'cm': 124.46},
      {"height": "4' 2\"", 'cm': 127.00},
      {"height": "4' 3\"", 'cm': 129.54},
      {"height": "4' 4\"", 'cm': 132.08},
      {"height": "4' 5\"", 'cm': 134.62},
      {"height": "4' 6\"", 'cm': 137.16},
      {"height": "4' 7\"", 'cm': 139.70},
      {"height": "4' 8\"", 'cm': 142.24},
      {"height": "4' 9\"", 'cm': 144.78},
      {"height": "4' 10\"", 'cm': 147.32},
      {"height": "4' 11\"", 'cm': 149.86},
      {"height": "5' 0\"", 'cm': 152.40},
      {"height": "5' 1\"", 'cm': 154.94},
      {"height": "5' 2\"", 'cm': 157.48},
      {"height": "5' 3\"", 'cm': 160.02},
      {"height": "5' 4\"", 'cm': 162.56},
      {"height": "5' 5\"", 'cm': 165.10},
      {"height": "5' 6\"", 'cm': 167.64},
      {"height": "5' 7\"", 'cm': 170.18},
      {"height": "5' 8\"", 'cm': 172.72},
      {"height": "5' 9\"", 'cm': 175.26},
      {"height": "5' 10\"", 'cm': 177.80},
      {"height": "5' 11\"", 'cm': 180.34},
      {"height": "6' 0\"", 'cm': 182.88},
      {"height": "6' 1\"", 'cm': 185.42},
      {"height": "6' 2\"", 'cm': 187.96},
      {"height": "6' 3\"", 'cm': 190.50},
      {"height": "6' 4\"", 'cm': 193.04},
      {"height": "6' 5\"", 'cm': 195.58},
      {"height": "6' 6\"", 'cm': 198.12},
      {"height": "6' 7\"", 'cm': 200.66},
      {"height": "6' 8\"", 'cm': 203.20},
      {"height": "6' 9\"", 'cm': 205.74},
      {"height": "6' 10\"", 'cm': 208.28},
      {"height": "6' 11\"", 'cm': 210.82},
      {"height": "7' 0\"", 'cm': 213.36},
    ]
        .asMap()
        .entries
        .map((entry) => FieldModel(
            id: entry.key + 1,
            name:
                "${entry.value['height']} - ${entry.value['cm']} ${language == "en" ? 'cm' : 'सेमी'} "))
        .toList()
        .obs;
  }

  // Get filtered max age list based on the selected min age ID
  List<FieldModel> getFilteredMaxAgeList() {
    if (selectedMinAge.value.id == null) {
      return ageRange; // Return full range if Min Age is not selected
    }
    // Return only ages greater than or equal to the selected min age
    return ageRange
        .where((item) => item.id! >= selectedMinAge.value.id!)
        .toList();
  }

  var selectedMinIncome = FieldModel().obs;
  var selectedMaxIncome = FieldModel().obs;
  void updateMinIncome(FieldModel newValue) {
    selectedMinIncome.value = newValue;
    if (selectedMaxIncome.value.id != null) {
      if (selectedMinIncome.value.id! > selectedMaxIncome.value.id!) {
        selectedMaxIncome.value = FieldModel(id: null, name: null);
      }
    }
  }

  // Update max income
  void updateMaxIncome(FieldModel newValue) {
    selectedMaxIncome.value = newValue;
  }

  void searchMinAnnualIncome(String query) {
    if (query.isEmpty) {
      searchedMinAnnualIncomeList.value = annualIncomeRange;
    } else {
      searchedMinAnnualIncomeList.value = annualIncomeRange
          .where((item) => item.name!
              .toLowerCase()
              .startsWith(query.toLowerCase())) // Filter by name
          .toList();
    }
  }

  List<FieldModel> getFilteredMaxIncomeList() {
    if (selectedMinIncome.value.id == null) {
      return annualIncomeRange; // Return full list if no min income is selected
    }
    return annualIncomeRange
        .where((item) => item.id! >= selectedMinIncome.value.id!)
        .toList();
  }

  void searchMaxAnnualIncome(String query) {
    if (query.isEmpty) {
      searchedMaxAnnualIncomeList.value = getFilteredMaxIncomeList();
    } else {
      searchedMaxAnnualIncomeList.value = getFilteredMaxIncomeList()
          .where((item) => item.name!
              .toLowerCase()
              .startsWith(query.toLowerCase())) // Filter by name
          .toList();
    }
  }

  void searchMinAge(String query) {
    if (query.isEmpty) {
      searchedMinAgeList.value = ageRange;
    } else {
      searchedMinAgeList.value = ageRange
          .where((item) => item.name!
              .toLowerCase()
              .startsWith(query.toLowerCase())) // Filter by name
          .toList();
    }
  }

  void searchMaxAge(String query) {
    if (query.isEmpty) {
      searchedMAxAgeList.value = getFilteredMaxAgeList();
    } else {
      searchedMAxAgeList.value = getFilteredMaxAgeList()
          .where((item) => item.name!
              .toLowerCase()
              .startsWith(query.toLowerCase())) // Filter by name
          .toList();
    }
  }

  void updateMinAge(FieldModel newValue) {
    selectedMinAge.value = newValue;
    if (selectedMaxAge.value.id != null &&
        selectedMaxAge.value.id! < selectedMinAge.value.id!) {
      selectedMaxAge.value = FieldModel();
    }
  }

  // Update max age based on ID
  void updateMaxAge(FieldModel newValue) {
    selectedMaxAge.value = newValue;
  }

  void updateMinHeight(FieldModel newValue) {
    selectedMinHeight.value = newValue;
    selectedMinHeight.value = newValue;
    if (selectedMaxHeight.value.id != null &&
        selectedMaxHeight.value.id! < selectedMinHeight.value.id!) {
      selectedMaxHeight.value = FieldModel();
    }
  }

  // Update max height based on ID
  void updateMaxHeight(FieldModel newValue) {
    selectedMaxHeight.value = newValue;
  }

  void searchMaxHeight(String query) {
    if (query.isEmpty) {
      searchedMAxHeightList.value = getFilteredMaxHeightList();
    } else {
      searchedMAxHeightList.value = getFilteredMaxHeightList()
          .where((item) => item.name!
              .toLowerCase()
              .startsWith(query.toLowerCase())) // Filter by name
          .toList();
    }
  }

  void searchMinHeight(String query) {
    if (query.isEmpty) {
      searchedMinHeightList.value = heightRange;
    } else {
      searchedMinHeightList.value = heightRange
          .where((item) => item.name!
              .toLowerCase()
              .startsWith(query.toLowerCase())) // Filter by name
          .toList();
    }
  }

  List<FieldModel> getFilteredMaxHeightList() {
    if (selectedMinHeight.value.id == null) {
      return heightRange; // Return full range if Min Height is not selected
    }
    return heightRange
        .where((item) => item.id! >= selectedMinHeight.value.id!)
        .toList();
  }

  var employedInList = <FieldModel>[].obs;
  var isloading = true.obs;
  final selectedItems = <FieldModel>[].obs;
  void selectAllItems() {
    selectedItems.clear();
    selectedItems.addAll(employedInList);
  }

  void toggleSelection(FieldModel item) {
    if (selectedItems.contains(item)) {
      selectedItems.remove(item);
    } else {
      selectedItems.add(item);
    }
  }

  void clearAllSelections() {
    selectedItems.clear();
  }

  Future<void> fetchemployeedInFromApi() async {
    try {
      String? language = sharedPreferences?.getString("Language");
      isloading(true);
      final response = await http.get(Uri.parse(
          '${Appconstants.baseURL}/api/fetch/employeed_in?lang=$language'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        employedInList.value = data.map((e) => FieldModel.fromJson(e)).toList();
      } else {
        print("Error in emplyed in");
      }
    } finally {
      isloading(false); // Ensure the loading state is reset
    }
  }

  final eatingHabitOptions = {
    1: "Vegetarian",
    2: "Non-Vegetarian",
    3: "Occasionally Non-Veg",
    4: "Eggetarian",
    5: "Vegan",
    6: "jain",
    7: "Other",
  };

  void updateEatingHabits(int id) {
    if (selectedEatingHabitIds.contains(id)) {
      selectedEatingHabitIds.remove(id); // Deselect if already selected
    } else {
      selectedEatingHabitIds.add(id); // Select the option
    }
  }

  var selectedEatingHabitIds = <int>[].obs;
  var selectedSmokingHabit = <int>[].obs;

  var selectedDrinkingHabit = <int>[].obs;

  var manglikSelectedList = <int>[].obs;

  var manglikSelected = FieldModel().obs;

  void updateManglik(FieldModel value) {
    manglikSelected.value = value;
  }

  void updateDrinkingHabit(int value) {
    if (selectedDrinkingHabit.contains(value)) {
      selectedDrinkingHabit.remove(value); // Deselect if already selected
    } else {
      selectedDrinkingHabit.add(value); // Select the option
    }
  }

  final _selectedOccupationItems = <String>[].obs;

  List<String> get selectedOccupationItems => _selectedOccupationItems;

  void toggleOccupationSelection(String item) {
    if (_selectedOccupationItems.contains(item)) {
      _selectedOccupationItems.remove(item);
    } else {
      _selectedOccupationItems.add(item);
    }
  }

  void updateSmokingHabit(int value) {
    if (selectedSmokingHabit.contains(value)) {
      selectedSmokingHabit.remove(value); // Deselect if already selected
    } else {
      selectedSmokingHabit.add(value); // Select the option
    }
  }

  String? token = sharedPreferences?.getString("token");
  var searchfetching = false.obs;
  var searchpage = 1.obs;
  var searchList = [].obs;
  var searchListHasMore = true.obs;
  final CastController _castController = Get.put(CastController());
  final EducationController _educationController =
      Get.put(EducationController());
  final OccupationController _occupationController =
      Get.put(OccupationController());
  final LocationController locationController = Get.put(LocationController());

  // final List<Map<String, dynamic>> statusOptions = [
  //   {"label": AppLocalizations.of(Get.context!)!.neverMarried, "id": 1},
  //   {"label": AppLocalizations.of(Get.context!)!.divorced, "id": 3},
  //   {"label": AppLocalizations.of(Get.context!)!.separated, "id": 5},
  //   {"label": AppLocalizations.of(Get.context!)!.awaitingresponse, "id": 4},
  //   {"label": AppLocalizations.of(Get.context!)!.widoworwidower, "id": 2},
  // ];

  List<Map<String, dynamic>> statusOptions = [];
  void updateStatusOptions() {
    String? language = sharedPreferences?.getString("Language");
    statusOptions = language == 'en'
        ? [
            {"label": 'Never Married', "id": 1},
            {"label": 'Divorced', "id": 3},
            {"label": 'Separated', "id": 5},
            {"label": 'Awaiting Response', "id": 4},
            {"label": 'Widow / Widower', "id": 2},
          ]
        : [
            {"label": 'अविवाहित', "id": 1},
            {"label": 'घटस्फोटित', "id": 3},
            {"label": 'विभक्त', "id": 5},
            {"label": 'प्रतीक्षेत', "id": 4},
            {"label": 'विधवा/विधुर', "id": 2}
          ].obs;
  }

  Future<void> advanceSearch() async {
    String? language = sharedPreferences?.getString("Language");
    searchfetching.value = true;
    // API URL
    final String apiUrl =
        '${Appconstants.baseURL}/api/member/advanced_search?page=${searchpage.value}&lang=$language';

    try {
      final Map<String, dynamic> requestBody = {
        "min_age": selectedMinAge.value.id,
        "max_age": selectedMaxAge.value.id,
        "min_height": selectedMinHeight.value.id,
        "max_height": selectedMaxHeight.value.id,
        "caste": _castController.selectedCasteList
            .where((field) => field.id != null) // Filter out null ids
            .map((field) => field.id!)
            .toList(),
        "section": _castController.selectedSectionList
            .where((field) => field.id != null) // Filter out null ids
            .map((field) => field.id!)
            .toList(),
        "subsection": _castController.selectedSubSectionList
            .where((field) => field.id != null) // Filter out null ids
            .map((field) => field.id!)
            .toList(),
        "manglik": manglikSelectedList,
        "marital_status": selectedStatusIds,
        "employed_in": employedInList
            .where((field) => field.id != null) // Filter out null ids
            .map((field) => field.id!)
            .toList(),
        "education": _educationController.selectedEducationList
            .where((field) => field.id != null) // Filter out null ids
            .map((field) => field.id!)
            .toList(),
        "occupation": _occupationController.selectedOccupations
            .where((field) => field.id != null) // Filter out null ids
            .map((field) => field.id!)
            .toList(),
        "country": locationController.selectedCountries
            .where((field) => field.id != null) // Filter out null ids
            .map((field) => field.id!)
            .toList(),
        "state": locationController.selectedStates
            .where((field) => field.id != null) // Filter out null ids
            .map((field) => field.id!)
            .toList(),
        "city": locationController.selectedCities
            .where((field) => field.id != null) // Filter out null ids
            .map((field) => field.id!)
            .toList(),
        "min_annual_income": selectedMinIncome.value.id,
        "max_annual_income": selectedMaxIncome.value.id,
        "dietary_habits": selectedEatingHabitIds,
        "smoking_habits": selectedSmokingHabit,
        "drinking_habits": selectedDrinkingHabit
      };
      // Making POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestBody), // Encoding search data as JSON
      );
      print("Response is this adv search ${response.statusCode}");
      // Handling response
      if (response.statusCode == 200) {
        // Successful response
        print("THIS IS PAGE ID ${searchpage.value}");

        var responseBody = jsonDecode(response.body);

        // Handle data from response
        List<dynamic> responsebodyList = responseBody["data"]?["data"] ?? [];

        if (responsebodyList.isNotEmpty) {
          searchList.addAll(responsebodyList); // Add new items to the list
          searchpage.value++; // Increment page for next API call
        }
        if (responsebodyList.length < 10) {
          print("Inside less than 20");
          searchListHasMore.value = false;
          update(['no_more_data_for_search']);
        }
      } else {
        // Error response
        print('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Exception occurred: $e');
    } finally {
      searchfetching.value = false;
    }
  }

  var selectedStatusIds = <int>[].obs;

  void toggleStatusSelection(int id) {
    if (selectedStatusIds.contains(id)) {
      selectedStatusIds.remove(id);
      if (selectedStatusIds.isEmpty) {}
    } else {
      selectedStatusIds.add(id);
    }
  }

// basic Search
  var searchbyIDfetching = false.obs;
  var searchbyIDpage = 1.obs;
  var searchbyIDList = [].obs;
  var searchbyIDListHasMore = true.obs;

  Future<void> basicSearch() async {
    print("This is member_user_id ${textController.text.trim()}");
    searchbyIDfetching.value = true;
    // API URL
    final String apiUrl =
        '${Appconstants.baseURL}/api/member/searchbyid?page=${searchbyIDpage.value}';

    try {
      final Map<String, dynamic> requestBody = {
        "member_profile_id": textController.text.trim(),
      };
      // Making POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestBody), // Encoding search data as JSON
      );
      print("Response is this ${response.body}");
      // Handling response
      if (response.statusCode == 200) {
        // Successful response
        analytics.logEvent(name: "app_96k_welcome_screen_view");
        facebookAppEvents.logEvent(name: "Fb_96k_app_welcome_screen_view");

        var responseBody = jsonDecode(response.body);
        print("REsponse bodyLIst $responseBody");
        // Handle data from response
        List<dynamic> responsebodyList = responseBody["data"]?["data"] ?? [];
        print("SearchList $responsebodyList");
        if (responsebodyList.isNotEmpty) {
          searchbyIDList.addAll(responsebodyList); // Add new items to the list
          searchbyIDpage.value++; // Increment page for next API call
        }
        if (responsebodyList.length < 10) {
          print("Inside less than 20");
          searchbyIDListHasMore.value = false;
          update(['no_more_data_for_searchByID']);
        }
      } else {
        // Error response
        print('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Exception occurred: $e');
    } finally {
      searchbyIDfetching.value = false;
    }
  }
}
