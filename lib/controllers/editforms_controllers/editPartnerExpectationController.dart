// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'package:_96kuliapp/utils/bottomnavBar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/commons/dialogues/forceblock.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationBlock.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationBlockController.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationScreen.dart';
import 'package:_96kuliapp/controllers/viewProfileControllers/myprofileController.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:_96kuliapp/controllers/formfields/castController.dart';
import 'package:_96kuliapp/controllers/formfields/educationController.dart';
import 'package:_96kuliapp/controllers/formfields/occupationController.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/models/forms/cityfkmodel.dart';
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';
import 'package:_96kuliapp/models/forms/statefkmodel.dart';
import 'package:_96kuliapp/screens/plans/upgradeScreen.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepSix.dart';

class EditPartnerExpectation extends GetxController {
  var manglikSelected = FieldModel().obs;
  var listLengthValidate = false.obs;
  var selectedManglikValidated = false.obs;
  var isLoading = false.obs;
  var isSubmitted = false.obs;
  var dashboardData = {}.obs;

  void selectAllItems() {
    selectedItems.clear();
    selectedItems.addAll(employedInList);
  }

  // Clear all selections
  void clearAllSelections() {
    selectedItems.clear();
  }

  var genderValue = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    final mybox = Hive.box('myBox');

    genderValue.value = mybox.get("gender") == 2 ? "groom" : "bride";
    // Initialize ageRange
    updateAgeRange();
    updateStatusOptions();
    annualincomeRangeList();
    maxincomeRangeList();
    fetchPartnerExpectInfo();
  }

  var basicInfoData = {}.obs; // To hold the API response data

  var selectedStatus = "".obs;
  var selectedManglikInt = 0.obs;

  var selectedStatusIds = <int>[].obs;
  var selectedStatusValidated = false.obs;

  var selectedDrinkingHabitValidated = false.obs;

  var selectedEatingHabitIds = <int>[].obs;
  var eatingHabitValidated = false.obs;
  var selectedSmokingHabitValidated = false.obs;
  var selectedSmokingHabitInt = 0.obs;

  // Map of eating habits and their corresponding IDs
  final eatingHabitOptions = {
    1: "Vegetarian",
    2: "Non-Vegetarian",
    3: "Occasionally Non-Veg",
    4: "Eggetarian",
    5: "Vegan",
    6: "jain",
    7: "Other",
  };
  var selectedMinIncome = FieldModel().obs;
  var selectedMaxIncome = FieldModel().obs;

  var annualIncomeRange = <FieldModel>[].obs;
  var MaxannualIncomeRange = <FieldModel>[].obs;

  void annualincomeRangeList() {
    String? language = sharedPreferences?.getString("Language");
    annualIncomeRange.value = language == 'en'
        ? [
            FieldModel(id: 0, name: '0 Lakh'),
            FieldModel(id: 1, name: '1 Lakh'),
            FieldModel(id: 2, name: '2 Lakhs'),
            FieldModel(id: 3, name: '3 Lakhs'),
            FieldModel(id: 4, name: '5 Lakhs'),
            FieldModel(id: 5, name: '7 Lakhs'),
            FieldModel(id: 6, name: '10 Lakhs'),
            FieldModel(id: 7, name: '15 Lakhs'),
            FieldModel(id: 8, name: '16 Lakhs'),
            FieldModel(id: 9, name: '18 Lakhs'),
            FieldModel(id: 10, name: '20 Lakhs'),
            FieldModel(id: 11, name: '30 Lakhs'),
            FieldModel(id: 12, name: '40 Lakhs'),
            FieldModel(id: 13, name: '50 Lakhs'),
            FieldModel(id: 14, name: '60 Lakhs'),
            FieldModel(id: 15, name: '70 Lakhs'),
            FieldModel(id: 16, name: '80 Lakhs'),
            FieldModel(id: 17, name: '90 Lakhs'),
            FieldModel(id: 18, name: '1 Crore & Above'),
          ].obs
        : [
            FieldModel(id: 0, name: '0 लाख'),
            FieldModel(id: 1, name: '1 लाख'),
            FieldModel(id: 2, name: '2 लाख'),
            FieldModel(id: 3, name: '3 लाख'),
            FieldModel(id: 4, name: '5 लाख'),
            FieldModel(id: 5, name: '7 लाख'),
            FieldModel(id: 6, name: '10 लाख'),
            FieldModel(id: 7, name: '15 लाख'),
            FieldModel(id: 8, name: '16 लाख'),
            FieldModel(id: 9, name: '18 लाख'),
            FieldModel(id: 10, name: '20 लाख'),
            FieldModel(id: 11, name: '30 लाख'),
            FieldModel(id: 12, name: '40 लाख'),
            FieldModel(id: 13, name: '50 लाख'),
            FieldModel(id: 14, name: '60 लाख'),
            FieldModel(id: 15, name: '70 लाख'),
            FieldModel(id: 16, name: '80 लाख'),
            FieldModel(id: 17, name: '90 लाख'),
            FieldModel(id: 18, name: '1 कोटी वरील'),
          ].obs;
  }

  void maxincomeRangeList() {
    String? language = sharedPreferences?.getString("Language");
    MaxannualIncomeRange = language == 'en'
        ? [
            FieldModel(id: 2, name: '1 Lakh'),
            FieldModel(id: 3, name: '2 Lakhs'),
            FieldModel(id: 4, name: '3 Lakhs'),
            FieldModel(id: 5, name: '5 Lakhs'),
            FieldModel(id: 6, name: '7 Lakhs'),
            FieldModel(id: 7, name: '10 Lakhs'),
            FieldModel(id: 8, name: '15 Lakhs'),
            FieldModel(id: 9, name: '16 Lakhs'),
            FieldModel(id: 10, name: '18 Lakhs'),
            FieldModel(id: 11, name: '20 Lakhs'),
            FieldModel(id: 12, name: '30 Lakhs'),
            FieldModel(id: 13, name: '40 Lakhs'),
            FieldModel(id: 14, name: '50 Lakhs'),
            FieldModel(id: 15, name: '60 Lakhs'),
            FieldModel(id: 16, name: '70 Lakhs'),
            FieldModel(id: 17, name: '80 Lakhs'),
            FieldModel(id: 18, name: '90 Lakhs'),
            FieldModel(id: 19, name: '1 Crore'),
            FieldModel(id: 20, name: '1 Crore and above'),
          ].obs
        : [
            FieldModel(id: 2, name: '0 लाख'),
            FieldModel(id: 3, name: '1 लाख'),
            FieldModel(id: 4, name: '2 लाख'),
            FieldModel(id: 5, name: '3 लाख'),
            FieldModel(id: 6, name: '5 लाख'),
            FieldModel(id: 7, name: '7 लाख'),
            FieldModel(id: 8, name: '10 लाख'),
            FieldModel(id: 9, name: '15 लाख'),
            FieldModel(id: 10, name: '16 लाख'),
            FieldModel(id: 11, name: '18 लाख'),
            FieldModel(id: 12, name: '20 लाख'),
            FieldModel(id: 13, name: '30 लाख'),
            FieldModel(id: 14, name: '40 लाख'),
            FieldModel(id: 15, name: '50 लाख'),
            FieldModel(id: 16, name: '60 लाख'),
            FieldModel(id: 17, name: '70 लाख'),
            FieldModel(id: 18, name: '80 लाख'),
            FieldModel(id: 19, name: '90 लाख'),
            FieldModel(id: 20, name: '1 कोटी वरील'),
          ].obs;
  }

  // Annual Income Range using FieldModel
  // var annualIncomeRange = [
  //   FieldModel(id: 2, name: '0 Lakh'),
  //   FieldModel(id: 3, name: '1 Lakh'),
  //   FieldModel(id: 4, name: '2 Lakhs'),
  //   FieldModel(id: 5, name: '3 Lakhs'),
  //   FieldModel(id: 6, name: '5 Lakhs'),
  //   FieldModel(id: 7, name: '7 Lakhs'),
  //   FieldModel(id: 8, name: '10 Lakhs'),
  //   FieldModel(id: 9, name: '15 Lakhs'),
  //   FieldModel(id: 10, name: '16 Lakhs'),
  //   FieldModel(id: 11, name: '18 Lakhs'),
  //   FieldModel(id: 12, name: '20 Lakhs'),
  //   FieldModel(id: 13, name: '30 Lakhs'),
  //   FieldModel(id: 14, name: '40 Lakhs'),
  //   FieldModel(id: 15, name: '50 Lakhs'),
  //   FieldModel(id: 16, name: '60 Lakhs'),
  //   FieldModel(id: 17, name: '70 Lakhs'),
  //   FieldModel(id: 18, name: '80 Lakhs'),
  //   FieldModel(id: 19, name: '90 Lakhs'),
  //   // FieldModel(id: 19, name: '90 Lakhs - 1 Crore'),
  //   FieldModel(id: 20, name: '1 Crore & Above'),
  // ].obs;

  // Observables for selected min and max incomes
  // var MaxannualIncomeRange = [
  //   FieldModel(id: 2, name: '1 Lakh'),
  //   FieldModel(id: 3, name: '2 Lakhs'),
  //   FieldModel(id: 4, name: '3 Lakhs'),
  //   FieldModel(id: 5, name: '5 Lakhs'),
  //   FieldModel(id: 6, name: '7 Lakhs'),
  //   FieldModel(id: 7, name: '10 Lakhs'),
  //   FieldModel(id: 8, name: '15 Lakhs'),
  //   FieldModel(id: 9, name: '16 Lakhs'),
  //   FieldModel(id: 10, name: '18 Lakhs'),
  //   FieldModel(id: 11, name: '20 Lakhs'),
  //   FieldModel(id: 12, name: '30 Lakhs'),
  //   FieldModel(id: 13, name: '40 Lakhs'),
  //   FieldModel(id: 14, name: '50 Lakhs'),
  //   FieldModel(id: 15, name: '60 Lakhs'),
  //   FieldModel(id: 16, name: '70 Lakhs'),
  //   FieldModel(id: 17, name: '80 Lakhs'),
  //   FieldModel(id: 18, name: '90 Lakhs'),
  //   // FieldModel(id: 19, name: '90 Lakhs - 1 Crore'),
  //   FieldModel(id: 19, name: '1 Crore'),
  //   FieldModel(id: 20, name: '1 Crore and above'),
  // ].obs;

  // Update min income
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

  // Get filtered max income list based on selected min income
  List<FieldModel> getFilteredMaxIncomeList() {
    if (selectedMinIncome.value.id == null) {
      return annualIncomeRange; // Return full list if no min income is selected
    }
    return MaxannualIncomeRange.where(
        (item) => item.id! > selectedMinIncome.value.id!).toList();
  }

  // Preselect income based on IDs (if necessary)
  /* void preselectIncomes({int? minIncomeId, int? maxIncomeId}) {
    if (minIncomeId != null) {
      updateMinIncome(minIncomeId);
    }
    if (maxIncomeId != null) {
      updateMaxIncome(maxIncomeId);
    }
  }*/

  void updateEatingHabits(int id) {
    if (selectedEatingHabitIds.contains(id)) {
      selectedEatingHabitIds.remove(id); // Deselect if already selected
      if (selectedEatingHabitIds.isEmpty) {
        eatingHabitValidated.value = false;
      }
    } else {
      eatingHabitValidated.value = true;

      selectedEatingHabitIds.add(id); // Select the option
    }
  }

  void toggleStatusSelection(int id) {
    if (selectedStatusIds.contains(id)) {
      selectedStatusIds.remove(id);
      if (selectedStatusIds.isEmpty) {
        selectedStatusValidated.value = false;
      }
    } else {
      selectedStatusValidated.value = true;

      selectedStatusIds.add(id);
    }
  }

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

  var isloading = true.obs;
  var minAge = 18.obs;
  var maxAge = 60.obs;
  var selectedMinHeight = FieldModel().obs;
  var selectedMaxHeight = FieldModel().obs;
  var isPageLoading = false.obs;

  var heightRange = [
    {"height": "4' 0\"", "cm": 121.92},
    {"height": "4' 1\"", "cm": 124.46},
    {"height": "4' 2\"", "cm": 127.00},
    {"height": "4' 3\"", "cm": 129.54},
    {"height": "4' 4\"", "cm": 132.08},
    {"height": "4' 5\"", "cm": 134.62},
    {"height": "4' 6\"", "cm": 137.16},
    {"height": "4' 7\"", "cm": 139.70},
    {"height": "4' 8\"", "cm": 142.24},
    {"height": "4' 9\"", "cm": 144.78},
    {"height": "4' 10\"", "cm": 147.32},
    {"height": "4' 11\"", "cm": 149.86},
    {"height": "5' 0\"", "cm": 152.40},
    {"height": "5' 1\"", "cm": 154.94},
    {"height": "5' 2\"", "cm": 157.48},
    {"height": "5' 3\"", "cm": 160.02},
    {"height": "5' 4\"", "cm": 162.56},
    {"height": "5' 5\"", "cm": 165.10},
    {"height": "5' 6\"", "cm": 167.64},
    {"height": "5' 7\"", "cm": 170.18},
    {"height": "5' 8\"", "cm": 172.72},
    {"height": "5' 9\"", "cm": 175.26},
    {"height": "5' 10\"", "cm": 177.80},
    {"height": "5' 11\"", "cm": 180.34},
    {"height": "6' 0\"", "cm": 182.88},
    {"height": "6' 1\"", "cm": 185.42},
    {"height": "6' 2\"", "cm": 187.96},
    {"height": "6' 3\"", "cm": 190.50},
    {"height": "6' 4\"", "cm": 193.04},
    {"height": "6' 5\"", "cm": 195.58},
    {"height": "6' 6\"", "cm": 198.12},
    {"height": "6' 7\"", "cm": 200.66},
    {"height": "6' 8\"", "cm": 203.20},
    {"height": "6' 9\"", "cm": 205.74},
    {"height": "6' 10\"", "cm": 208.28},
    {"height": "6' 11\"", "cm": 210.82},
    {"height": "7' 0\"", "cm": 213.36},
  ]
      .asMap()
      .entries
      .map((entry) => FieldModel(
          id: entry.key + 1,
          name: "${entry.value['height']} - ${entry.value['cm']} cm"))
      .toList()
      .obs;

  // Observables for selected Min and Max Heights (holding ID of height)

  // Update min height based on ID
  void updateMinHeight(FieldModel newValue) {
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

  // Get filtered max height list based on the selected min height
  List<FieldModel> getFilteredMaxHeightList() {
    if (selectedMinHeight.value.id == null) {
      return heightRange; // Return full range if Min Height is not selected
    }
    return heightRange
        .where((item) => item.id! >= selectedMinHeight.value.id!)
        .toList();
  }

  // Pre-select heights based on IDs (if applicable)
  /*void preselectHeights({int? minHeightId, int? maxHeightId}) {
    if (minHeightId != null) {
      updateMinHeight(minHeightId);
    }
    if (maxHeightId != null) {
      updateMaxHeight(maxHeightId);
    }
  }*/

  var employedInList = <FieldModel>[].obs;

  // Observables for selected Min and Max Ages, these will hold the IDs

  // Update min age based on ID
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

  void preselectAges({required int minage, required int maxage}) {
    selectedMinAge.value = ageRange.firstWhere(
      (element) => element.id == minage,
    );
    selectedMaxAge.value = ageRange.firstWhere(
      (element) => element.id == maxage,
    );
  }

  void preselectHeights({required int minheight, required int maxheight}) {
    selectedMinHeight.value = heightRange.firstWhere(
      (element) => element.id == minheight,
    );
    selectedMaxHeight.value = heightRange.firstWhere(
      (element) => element.id == maxheight,
    );
  }

  void preselectAnnualIncome({required int minIncome, required int maxIncome}) {
    selectedMinIncome.value = annualIncomeRange.firstWhere(
      (element) => element.id == minIncome,
    );
    print("check MIN& $minIncome $maxIncome");
    selectedMaxIncome.value = MaxannualIncomeRange.firstWhere(
      (element) => element.id == maxIncome,
    );
  }
  // void preselectAnnualIncome({required int minIncome, required int maxIncome}) {
  //   final min = annualIncomeRange.firstWhere(
  //     (element) => element.id == minIncome,
  //     orElse: () => annualIncomeRange.first,
  //   );
  //   final max = annualIncomeRange.firstWhere(
  //     (element) => element.id == maxIncome,
  //     orElse: () => annualIncomeRange.last,
  //   );

  //   selectedMinIncome.value = min;
  //   selectedMaxIncome.value = max;
  // }

  // Pre-select values based on ID (if applicable)
  /* void preselectAges({int? minAgeId, int? maxAgeId}) {
    if (minAgeId != null) {
      updateMinAge(minAgeId);
    }
    if (maxAgeId != null) {
      updateMaxAge(maxAgeId);
    }
  }*/
  var ageRange = <FieldModel>[].obs;

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
        : List.generate(
            50,
            (index) {
              int age = index + 21; // Starting age for groom
              return FieldModel(
                  id: index + 4,
                  name: language == 'en'
                      ? '$age Years'
                      : "$age वर्षे"); // ID starts from 4
            },
          );
  }

  var searchedMinAgeList = <FieldModel>[].obs;
  var searchedMAxAgeList = <FieldModel>[].obs;
  var searchedMAxHeightList = <FieldModel>[].obs;
  var searchedMinHeightList = <FieldModel>[].obs;
  var searchedMinAnnualIncomeList = <FieldModel>[].obs;
  var searchedMaxAnnualIncomeList = <FieldModel>[].obs;

  var selectedMinAge = FieldModel().obs;
  var selectedMaxAge = FieldModel().obs;
  var cast = FieldModel().obs;

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

  final _items = ["Name 1", "Name 2", "Name 3", "Name 4", "Name 5"].obs;

  var selectedSmokingHabit = FieldModel().obs;
  var selectedDrinkingHabit = FieldModel().obs;

  var selectedEatingHabit = "".obs;
  final _educationItems =
      ["High School", "Bachelor's", "Master's", "PhD", "Diploma"].obs;
  final _occupationItems = [
    "Doctor",
    "Engineer",
    "Teacher",
    "Lawyer",
    "Artist",
    "Business",
  ].obs;

  final salaryList = [
    "0 LPA",
    "1 LPA",
    "2 LPA",
    "3 LPA",
    "5 LPA",
    "7 LPA",
    "10 LPA",
    "15 LPA",
    "16 LPA",
    "18 LPA",
    "20 LPA",
    "30 LPA",
    "40 LPA",
    "50 LPA",
    "60 LPA",
    "70 LPA",
    "80 LPA",
    "90 LPA",
    "1 CR",
    "1 CR+"
  ].obs;

  final _selectedOccupationItems = <String>[].obs;

  List<String> get occupationItems => _occupationItems;
  List<String> get selectedOccupationItems => _selectedOccupationItems;

  final _selectedEducationItems = <String>[].obs;

  // List of selected items
  final selectedItems = <FieldModel>[].obs;
  final selectedItemsID = <int>[].obs;

  List<String> get educationItems => _educationItems;
  List<String> get selectedEducationItems => _selectedEducationItems;
  List<String> get items => _items;
  List<String> get education => _items;

  void toggleOccupationSelection(String item) {
    if (_selectedOccupationItems.contains(item)) {
      _selectedOccupationItems.remove(item);
    } else {
      _selectedOccupationItems.add(item);
    }
  }

  // Method to clear selected occupations
  void clearOccupationSelection() {
    _selectedOccupationItems.clear();
  }

  void updateManglik(FieldModel value) {
    manglikSelected.value = value;
    print("Manglik Int ${selectedManglikInt.value}");
    selectedManglikValidated.value = true;
  }

  void updateStatus(String value) {
    selectedStatus.value = value;
  }

  void clearSelection() {
    selectedItems.clear();
  }

  void toggleSelection(FieldModel item) {
    if (selectedItems.contains(item)) {
      selectedItems.remove(item);
    } else {
      selectedItems.add(item);
    }
  }

  void toggleSelectionID(int item) {
    if (selectedItemsID.contains(item)) {
      selectedItemsID.remove(item);
    } else {
      selectedItemsID.add(item);
    }
  }

  void toggleEducationSelection(String item) {
    if (_selectedEducationItems.contains(item)) {
      _selectedEducationItems.remove(item);
    } else {
      _selectedEducationItems.add(item);
    }
  }

  // Method to clear selected education options
  void clearEducationSelection() {
    _selectedEducationItems.clear();
  }

  void updateSmokingHabit(FieldModel value) {
    selectedSmokingHabit.value = value;

    selectedSmokingHabitValidated.value = true;
  }

  void updateDrinkingHabit(FieldModel value) {
    selectedDrinkingHabit.value = value;

    selectedDrinkingHabitValidated.value = true;
  }

  void updateEatingHabit(String value) {
    selectedEatingHabit.value = value;
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

  final MyProfileController _profileController = Get.put(MyProfileController());

  Future<void> sendUpdateData({
    required int? minAge,
    required int? maxAge,
    required int? minHeight,
    required int? maxHeight,
    required List<int>? caste,
    // required List<int> section,
    // required List<int> subsection,
    required int? manglik,
    required List<int?>? maritalStatus,
    required List<int>? employedIn,
    required List<int>? education,
    required List<int>? occupation,
    required List<int>? country,
    required List<int>? state,
    required List<int>? city,
    required int? minAnnualIncome,
    required int? maxAnnualIncome,
    // required List<int> dietaryHabits,
    // required int smokingHabits,
    // required int drinkingHabits,
  }) async {
    final url =
        Uri.parse('${Appconstants.baseURL}/api/update/incomplete/partner');
    isLoading.value = true;
    // Prepare the request body dynamically
    final Map<String, dynamic> requestBody = {
      "min_age": minAge,
      "max_age": maxAge,
      "min_height": minHeight,
      "max_height": maxHeight,
      "subcaste": caste,
      // "section": section,
      // ""
      // "subsection": subsection,
      "manglik": manglik,
      "marital_status": maritalStatus,
      "employed_in": employedIn,
      "education": education,
      "occupation": occupation,
      "country": country,
      "state": state,
      "city": city,
      "min_annual_income": minAnnualIncome,
      "max_annual_income": maxAnnualIncome,
      // "dietary_habits": dietaryHabits,
      // "smoking_habits": smokingHabits,
      // "drinking_habits": drinkingHabits
    };

    try {
      String? token = sharedPreferences!.getString("token");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print("Data sent successfully: ${response.body}");
        var responseBody = jsonDecode(response.body);
        print("incomplet2 successfully: ${responseBody}");
        dashboardData.value = responseBody;
        navigatorKey.currentState!.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const BottomNavBar(),
          ),
          (route) => false,
        );
        // if (dashboardData["redirection"]["pagename"] == "FORCEPOPUP") {
        //   Get.dialog(
        //       barrierColor: Colors.black.withOpacity(
        //           0.6), // A lighter black color (using a hex value)

        //       const ForceBlockDialogue(),
        //       barrierDismissible: false);
        // } else if (dashboardData["redirection"]["pagename"] == "PENDING") {
        //   _casteVerificationBlockController.popup.value =
        //       dashboardData["redirection"]["Popup"];
        //   WidgetsBinding.instance.addPostFrameCallback((_) {
        //     navigatorKey.currentState!.pushAndRemoveUntil(
        //       MaterialPageRoute(
        //         builder: (context) => const CasteVerificationBlock(),
        //       ),
        //       (route) => false,
        //     );
        //   });
        // } else if (dashboardData["redirection"]["pagename"] ==
        //     "CASTE-VERIFICATION") {
        //   WidgetsBinding.instance.addPostFrameCallback((_) {
        //     navigatorKey.currentState!.pushAndRemoveUntil(
        //       MaterialPageRoute(
        //         builder: (context) => const CasteVerificationScreen(),
        //       ),
        //       (route) => false,
        //     );
        //   });
        // } else if (dashboardData["redirection"]["pagename"] ==
        //     "INCOMPLETEFORM") {
        //   WidgetsBinding.instance.addPostFrameCallback((_) {
        //     navigatorKey.currentState!.pushAndRemoveUntil(
        //       MaterialPageRoute(
        //         builder: (context) => const userIncomplete_userForm(),
        //       ),
        //       (route) => false,
        //     );
        //   });
        // } else if (dashboardData["redirection"]["pagename"] ==
        //     "DOCUMENT-REJECTED") {
        //   WidgetsBinding.instance.addPostFrameCallback((_) {
        //     navigatorKey.currentState!.pushAndRemoveUntil(
        //       MaterialPageRoute(
        //         builder: (context) => const UserInfoStepSix(),
        //       ),
        //       (route) => false,
        //     );
        //   });
        // } else if (dashboardData["redirection"]["pagename"] == "PLAN") {
        //   sharedPreferences!.setString("PageIndex", "9");
        //   WidgetsBinding.instance.addPostFrameCallback((_) {
        //     navigatorKey.currentState!.pushAndRemoveUntil(
        //       MaterialPageRoute(
        //         builder: (context) => const UpgradePlan(),
        //       ),
        //       (route) => false,
        //     );
        //   });
        // } else if (dashboardData["redirection"]["pagename"] == "UPDATE-PHOTO") {
        //   WidgetsBinding.instance.addPostFrameCallback((_) {
        //     navigatorKey.currentState!.pushAndRemoveUntil(
        //       MaterialPageRoute(
        //         builder: (context) => const ProfilePhotoRequestToChangeScreen(),
        //       ),
        //       (route) => false,
        //     );
        //   });
        // }

        // Get.back();
        // _profileController.fetchUserInfo();
      } else {
        print("Failed to send data: ${response.body}");
        print("Failed to send data: ${response.headers}");
      }
    } catch (e) {
      print("Error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendData({
    required int minAge,
    required int maxAge,
    required int minHeight,
    required int maxHeight,
    required List<int> caste,
    // required List<int> section,
    // required List<int> subsection,
    required String manglik,
    required List<int> maritalStatus,
    required List<int> employedIn,
    required List<int> education,
    required List<int> occupation,
    required List<int> country,
    required List<int> state,
    required List<int> city,
    required int minAnnualIncome,
    required int maxAnnualIncome,
    // required List<int> dietaryHabits,
    // required int smokingHabits,
    // required int drinkingHabits,
  }) async {
    final url = Uri.parse('${Appconstants.baseURL}/api/update/Partner');
    isLoading.value = true;
    // Prepare the request body dynamically
    final Map<String, dynamic> requestBody = {
      "min_age": minAge,
      "max_age": maxAge,
      "min_height": minHeight,
      "max_height": maxHeight,
      "subcaste": caste,
      // "section": section,
      // ""
      // "subsection": subsection,
      "manglik": manglik,
      "marital_status": maritalStatus,
      "employed_in": employedIn,
      "education": education,
      "occupation": occupation,
      "country": country,
      "state": state,
      "city": city,
      "min_annual_income": minAnnualIncome,
      "max_annual_income": maxAnnualIncome,
      // "dietary_habits": dietaryHabits,
      // "smoking_habits": smokingHabits,
      // "drinking_habits": drinkingHabits
    };

    try {
      String? token = sharedPreferences!.getString("token");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print("Data sent successfully: ${response.body}");
        // sharedPreferences!.setString("PageIndex", "5");

        //  Get.toNamed(AppRouteNames.userInfoStepFour);
        Get.back();
        _profileController.fetchUserInfo();
      } else {
        print("Failed to send data: ${response.body}");
        print("Failed to send data: ${response.headers}");
      }
    } catch (e) {
      print("Error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  final CastController _castController = Get.put(CastController());
  final EducationController _educationController =
      Get.put(EducationController());
  final OccupationController _occupationController =
      Get.put(OccupationController());
  final LocationController _locationController = Get.put(LocationController());

  final CasteVerificationBlockController _casteVerificationBlockController =
      Get.put(CasteVerificationBlockController());

  Future<void> fetchPartnerExpectInfo() async {
    String? token = sharedPreferences!.getString("token");
    try {
      isPageLoading(true);
      print("Edit check Form");
      // Fetch both education and specialization data in parallel
      print("this is token $token");
      print("this is tokenCheck $token");
      final response = await http.get(headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      }, Uri.parse('${Appconstants.baseURL}/api/profile-data/Partner'));
      print("Response is edit partner ${response.statusCode}");
      if (response.statusCode == 200) {
        basicInfoData.value = jsonDecode(response.body);
        print("Response is edit partner ${response.body}");
        if (basicInfoData["data"]["fields"]["min_age"] != null) {
          await Future.wait([
            _castController.fetchSectionFromApi(),
            _castController.fetchMultiSectionFromApi(),
            _castController.fetchMultiCasteFromApi(),
            fetchemployeedInFromApi(),
            _educationController.fetcheducationFromApi(),
            _occupationController.fetchOccupationFromApi(),
            _locationController.fetchCountries()
          ]);

          /*preselectAges(
                minAgeId: basicInfoData["min_age"],
                 maxAgeId: basicInfoData["max_age"]
                
                 );*/
          print("check1");
          preselectAges(
              minage: basicInfoData["data"]["fields"]["min_age"],
              maxage: basicInfoData["data"]["fields"]["max_age"]);
          preselectHeights(
              minheight: basicInfoData["data"]["fields"]["min_height"],
              maxheight: basicInfoData["data"]["fields"]["max_height"]);
          preselectAnnualIncome(
            minIncome: basicInfoData["data"]["fields"]["min_annual_income"],
            maxIncome: basicInfoData["data"]["fields"]["max_annual_income"],
          );
          print("check2");
          // selectedSmokingHabit.value.id =
          //     basicInfoData["data"]["fields"]["smoking_habits"];
          // selectedDrinkingHabit.value.id =
          //     basicInfoData["data"]["fields"]["drinking_habits"];
          // selectedEatingHabitIds.value =
          //     basicInfoData["data"]["fields"]["dietary_habits"].cast<int>();
          selectedStatusIds.value =
              basicInfoData["data"]["fields"]["marital_status"].cast<int>();
          manglikSelected.value.id = basicInfoData["data"]["fields"]["manglik"];
          // preselectHeights(minHeightId: basicInfoData["min_height"] , maxHeightId: basicInfoData["max_height"]);
          //  preselectIncomes( minIncomeId: basicInfoData["min_annual_income"], maxIncomeId: basicInfoData["max_annual_income"] );

          _castController.selectedSectionList.value = _castController
              .sectionList
              .where((element) => basicInfoData["data"]["fields"]["subcaste"]
                  .contains(element.id))
              .toList(); // Convert the filtered results back to a List<FieldModel>

          //
          //

          // print("Selected list is ${_castController.selectedSectionIntList}");
          // print("This is List ${_castController.selectedSectionList}");
          // _castController.selectedSubSectionList.value = _castController
          //     .sectionMultiList
          //     .where((element) => basicInfoData["data"]["fields"]["subsection"]
          //         .contains(element.id))
          //     .toList(); // Convert the filtered results back to a List<FieldModel>
          // print("Selected list is ${_castController.selectedSectionIntList}");
          // print("This is List ${_castController.selectedSubSectionList}");
          //
          //

          //
          //

          // _castController.selectedCasteList.value = _castController
          //     .casteMultiList
          //     .where((element) =>
          //         basicInfoData["data"]["fields"]["caste"].contains(element.id))
          //     .toList(); // Convert the filtered results back to a List<FieldModel>
          // print("Selected list is ${_castController.selectedSectionIntList}");
          //
          //

          selectedItems.value = employedInList
              .where(
                (e) => basicInfoData["data"]["fields"]["employed_in"]
                    .contains(e.id),
              )
              .toList();
          _educationController.selectedEducationList.value =
              _educationController.educationList
                  .where((nestedField) {
                    // Check if any FieldModel in the value list has an ID that is in idsToCheck
                    return nestedField.value?.any((field) =>
                            basicInfoData["data"]["fields"]["education"]
                                .contains(field.id)) ??
                        false;
                  })
                  .expand((nestedField) => nestedField.value!)
                  .cast<FieldModel>()
                  .toList(); // Cast to List<FieldModel>
          _occupationController.selectedOccupations.value =
              _occupationController.educationList
                  .where((nestedField) {
                    // Check if any FieldModel in the value list has an ID that is in idsToCheck
                    return nestedField.value?.any((field) =>
                            basicInfoData["data"]["fields"]["occupation"]
                                .contains(field.id)) ??
                        false;
                  })
                  .expand((nestedField) => nestedField.value!)
                  .cast<FieldModel>()
                  .toList();

          print(
              "this is in data data ${basicInfoData["data"]["fields"]["country"]}");

          _locationController.countryids.value =
              basicInfoData["data"]["fields"]["country"].cast<int?>();
          _locationController.stateids.value =
              basicInfoData["data"]["fields"]["state"].cast<int?>();

          _locationController.selectedCountries.value = _locationController
              .countries
              .where((element) => basicInfoData["data"]["fields"]["country"]
                  .contains(element.id))
              .toList(); // Convert the filtered results back to a List<FieldModel>
          print("this is in data controller ${_locationController.countryids}");
          print(
              "this is in data data state ${basicInfoData["data"]["fields"]["state"]}");
          await Future.wait([
            _locationController.fetchMultiState(),
            _locationController.fetchMultiCity()
          ]);
          print("THESE ARE STATES ${_locationController.states}");

          _locationController.selectedStates.value = _locationController
              .multistates
              .expand((element) => element.value ?? [])
              .where((state) =>
                  basicInfoData["data"]["fields"]["state"].contains(state.id))
              .map((state) =>
                  state as StatefkModel) // Cast each item to StateModel
              .toList();

          _locationController.selectedCities.value = _locationController
              .multiCities
              .expand(
                (element) => element.value ?? [],
              )
              .where(
                (city) =>
                    basicInfoData["data"]["fields"]["city"].contains(city.id),
              )
              .map(
                (city) => city as MultiCityFKModel,
              )
              .toList();

          print(
              "this is in data controller states ${_locationController.selectedStates}");
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
      } else {
        //  Get.snackbar('Error', 'Failed to load data');
      }
    } catch (e) {
      // Get.snackbar('Error', e.toString());
      print("Error editPartner: $e");
    } finally {
      isPageLoading(false);
    }
  }
}
