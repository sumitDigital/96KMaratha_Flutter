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

class EditLifestylecontroller extends GetxController {
  TextEditingController numberchilren = TextEditingController();
  TextEditingController physicalStatus = TextEditingController();

  var phvalidation = true.obs;
  var selectedCountryCode = "".obs;
  var isSubmitted = false.obs;
  var parentContactValidated = false.obs;
  var selected = false.obs;
  var isLoading = false.obs;

  var bloodGroups = [
    FieldModel(id: 1, name: 'A+ve'),
    FieldModel(id: 2, name: 'A-ve'),
    FieldModel(id: 3, name: 'B+ve'),
    FieldModel(id: 4, name: 'B-ve'),
    FieldModel(id: 5, name: 'O+ve'),
    FieldModel(id: 6, name: 'O-ve'),
    FieldModel(id: 7, name: 'AB+ve'),
    FieldModel(id: 8, name: 'AB-ve'),
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
    FieldModel? selected = motherTongueList
        .firstWhere((element) => element.id == id, orElse: () => FieldModel());
    if (selected.id != null) {
      updateMotherTongue(selected);
    }
  }

  var heightInFeet = List<FieldModel>.generate(37, (index) {
    int feet = 4 + (index ~/ 12); // Calculate feet starting from 4
    int inches = index % 12; // Calculate inches
    double totalInches = (feet * 12 + inches).toDouble(); // Convert to double
    double heightInCm = totalInches * 2.54; // Convert inches to centimeters

    // Return the FieldModel with both feet/inches and cm
    return FieldModel(
      id: index + 1,
      name: '$feet\'$inches" - ${heightInCm.toStringAsFixed(2)} cm',
    );
  }).obs;

  var selectedHeight = Rxn<FieldModel>();
  // Selected height index (for tracking purposes)
  var selectedHeightIndex = Rxn<int>();

  // Method to update the selected height
  void updateHeight(FieldModel selectedItem) {
    selectedHeight.value = selectedItem;
    selectedHeightIndex.value = heightInFeet.indexOf(selectedItem);
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
  final CasteVerificationBlockController _casteVerificationBlockController =
      Get.put(CasteVerificationBlockController());

  var isPageLoading = false.obs;
  var basicInfoData = {}.obs; // To hold the API response data
  var selectedDay = Rx<DateTime?>(null);
  @override
  void onInit() {
    super.onInit();
    mothertoughList();
    fetchBasicInfo();
    languageList();
  }

  Future<void> fetchBasicInfo() async {
    String? token = sharedPreferences!.getString("token");
    String? language = sharedPreferences?.getString("Language");
    print("Token is $token");
    try {
      isPageLoading(true);

      final response = await http.get(
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $token",
          },
          Uri.parse(
              '${Appconstants.baseURL}/api/profile-data/Lifestyle?lang=$language'));
      print("response is lifeStyle${response.body}");
      if (response.statusCode == 200) {
        basicInfoData.value = jsonDecode(response.body);
        print("basic info is lifeStyle $basicInfoData");
        /* await Future.wait([

// _castController.fetchSectionFromApi()
    ]
    ) ;*/

        //  dateofbirth.value = basicInfoData["date_of_birth"] ?? "DD/MM/YYYY";
        print("in section");
//_castController.selectedSection.value = _castController.sectionList.firstWhere((element) => element.id == basicInfoData["section"], orElse: () =>  FieldModel());
// print("This is sectoion ${_castController.selectedSection.value.name}");
        if (basicInfoData["data"]["fields"]["diet_habit"] != null) {
          await Future.wait([
            fetchhobbiesFromApi(),
            fetchInterestFromApi(),
            fetchSportsFromApi(),
            fetchMusicFromApi(),
            fetchFoodFromApi(),
            fetchdressStyleFromApi()
          ]);
          print("This is dta ");
// parentContactSelected.value.id = basicInfoData["contact_number_visibility"];
          print(
              "languages_known: ${basicInfoData["data"]["fields"]["languages_known"]}");
          print("hobbies: ${basicInfoData["data"]["fields"]["hobbies"]}");
          print("Languages list is ${languagesList.length}");

          selectedLanguages.value = languagesList
              .where((element) => basicInfoData["data"]["fields"]
                      ["languages_known"]
                  .contains(element.id))
              .toList();
          selectedHobbiesList.value = hobbiesList
              .where((element) => basicInfoData["data"]["fields"]["hobbies"]
                  .contains(element.id))
              .toList();
          selectedInterestList.value = interestList
              .where((element) => basicInfoData["data"]["fields"]["interest"]
                  .contains(element.id))
              .toList();
          selecteddressstyleList.value = dressStyleList
              .where((element) => basicInfoData["data"]["fields"]["dress_style"]
                  .contains(element.id))
              .toList();
          selectedSportsList.value = sportsList
              .where((element) => basicInfoData["data"]["fields"]["sports"]
                  .contains(element.id))
              .toList();

          selectedMusicList.value = musicList
              .where((element) => basicInfoData["data"]["fields"]
                      ["favourite_music"]
                  .contains(element.id))
              .toList();

          selectedFoodList.value = foodList
              .where((element) => basicInfoData["data"]["fields"]
                      ["favourite_food"]
                  .contains(element.id))
              .toList();

          selectedEatingHabit.value.id =
              basicInfoData["data"]["fields"]["diet_habit"];
          selectedSmokingHabit.value.id =
              basicInfoData["data"]["fields"]["smoking_habit"];
          selectedDrinkingHabit.value.id =
              basicInfoData["data"]["fields"]["drinking_habit"];

          preselectBloodGroup(basicInfoData["data"]["fields"]["mother_tongue"]);
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

  var selectedSmokingHabit = FieldModel().obs;
  var selectedDrinkingHabit = FieldModel().obs;

  var selectedSmokingHabitValidated = false.obs;

  var selectedDrinkingHabitValidated = false.obs;

  var selectedEatingHabit = FieldModel().obs;

  var selectedEatingHabitValidated = false.obs;

  void updateSmokingHabit(FieldModel value) {
    selectedSmokingHabit.value = value;

    selectedSmokingHabitValidated.value = true;
  }

  void updateDrinkingHabit(FieldModel value) {
    selectedDrinkingHabit.value = value;

    selectedDrinkingHabitValidated.value = true;
  }

  void updateEatingHabit(FieldModel value) {
    selectedEatingHabit.value = value;

    selectedEatingHabitValidated.value = true;
  }

  final MyProfileController _profileController = Get.put(MyProfileController());

  final DashboardController _dashboardController =
      Get.find<DashboardController>();

  Future<void> BasicForm({
    required int dietryHabits,
    required int smokingHabits,
    required int drinkingHabits,
    required int motherTongue,
    required List<int> languagesKnown,
    required List<int> hobbies,
    required List<int> interest,
    required List<int> dressStyle,
    required List<int> sports,
    required List<int> music,
    required List<int> food,
  }) async {
    // The API URL where you want to send the POST request
    String url = '${Appconstants.baseURL}/api/update/Lifestyle';
    isLoading.value = true;
    // The request body
    Map<String, dynamic> body = {
      "languages_known": languagesKnown,
      "hobbies": hobbies,
      "interest": interest,
      "dress_style": dressStyle,
      "sports": sports,
      "favourite_music": music,
      "favourite_food": food,
      "diet_habit": dietryHabits,
      "smoking_habit": smokingHabits,
      "drinking_habit": drinkingHabits,
      "mother_tongue": motherTongue
    };

    try {
      String? token = sharedPreferences!.getString("token");
      print("LIfestyle API test");
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
        //  Get.offAllNamed(AppRouteNames.userInfoStepTwo);
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

  // var languagesList = <FieldModel>[
  //   FieldModel(id: 1, name: AppLocalizations.of(Get.context!)!.english),
  //   FieldModel(id: 2, name: AppLocalizations.of(Get.context!)!.hindi),
  //   FieldModel(id: 3, name: AppLocalizations.of(Get.context!)!.marathi),
  //   FieldModel(id: 4, name: AppLocalizations.of(Get.context!)!.spanish),
  //   FieldModel(id: 5, name: AppLocalizations.of(Get.context!)!.french),
  //   FieldModel(id: 6, name: AppLocalizations.of(Get.context!)!.german),
  // ].obs;

  var languagesList = <FieldModel>[].obs;

  void languageList() {
    String? language = sharedPreferences?.getString("Language");
    languagesList.value = language == 'en'
        ? <FieldModel>[
            FieldModel(id: 1, name: "English"),
            FieldModel(id: 2, name: "Hindi"),
            FieldModel(id: 3, name: "Marathi"),
            FieldModel(id: 4, name: "Spanish"),
            FieldModel(id: 5, name: "French"),
            FieldModel(id: 6, name: "German"),
          ]
        : <FieldModel>[
            FieldModel(id: 1, name: "इंग्रजी"),
            FieldModel(id: 2, name: "हिंदी"),
            FieldModel(id: 3, name: "मराठी"),
            FieldModel(id: 4, name: "स्पॅनिश"),
            FieldModel(id: 5, name: "फ्रेंच"),
            FieldModel(id: 6, name: "जर्मन"),
          ];
  }

  final selectedLanguages = <FieldModel>[].obs;
  var listLengthValidate = false.obs;

  void selectAllItems() {
    selectedLanguages.clear();
    selectedLanguages.addAll(languagesList);
  }

  // Clear all selections
  void clearAllSelections() {
    selectedLanguages.clear();
  }

  void toggleSelection(FieldModel item) {
    if (selectedLanguages.contains(item)) {
      selectedLanguages.remove(item);
    } else {
      selectedLanguages.add(item);
    }
  }

  // var motherTongueList = <FieldModel>[
  //   FieldModel(id: 1, name: AppLocalizations.of(Get.context!)!.hindi),
  //   FieldModel(id: 2, name: AppLocalizations.of(Get.context!)!.marathi),
  //   FieldModel(id: 3, name: AppLocalizations.of(Get.context!)!.english),
  // ].obs;

  var motherTongueList = <FieldModel>[].obs;

  void mothertoughList() {
    String? language = sharedPreferences?.getString("Language");
    motherTongueList.value = language == 'en'
        ? <FieldModel>[
            FieldModel(id: 1, name: "Hindi"),
            FieldModel(id: 2, name: "Marathi"),
            FieldModel(id: 3, name: "English"),
          ]
        : [
            FieldModel(id: 1, name: "हिंदी"),
            FieldModel(id: 2, name: "मराठी"),
            FieldModel(id: 3, name: "इंग्रजी"),
          ];
  }
  // var motherTongueList = <FieldModel>[
  //   FieldModel(id: 1, name: AppLocalizations.of(Get.context!)!.hindi),
  //   FieldModel(id: 2, name: AppLocalizations.of(Get.context!)!.marathi),
  //   FieldModel(id: 3, name: AppLocalizations.of(Get.context!)!.english),
  // ].obs;

  var selectedMotherTongue = FieldModel().obs;

  void updateMotherTongue(FieldModel sign) {
    selectedMotherTongue.value = sign;
  }

  var filteredHobbiesList = <FieldModel>[].obs;
  var hobbiesList = <FieldModel>[].obs;
  var isloadingHobbies = false.obs;
  var selectedHobbiesList = <FieldModel>[].obs;
  var allSelected = false.obs;

  void toggleSelectAll() {
    if (allSelected.value) {
      selectedHobbiesList.clear();
    } else {
      selectedHobbiesList.assignAll(filteredHobbiesList);
    }
    allSelected.value = !allSelected.value;
  }

  Future<void> fetchhobbiesFromApi() async {
    try {
      String? language = sharedPreferences?.getString("Language");
      isloadingHobbies(true);
      final response = await http.get(Uri.parse(
          '${Appconstants.baseURL}/api/fetch/hobbies?lang=$language'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        hobbiesList.value = data.map((e) => FieldModel.fromJson(e)).toList();
        //  filteredEducationList.value = educationList; // Initialize filtered list with all education
        filteredHobbiesList.value = data
            .map(
              (e) => FieldModel.fromJson(e),
            )
            .toList();
      } else {
        print("Error in fetching education data");
      }
    } finally {
      isloadingHobbies(false); // Ensure the loading state is reset
    }
  }

  void toggleSelectionHobbies(FieldModel item) {
    if (selectedHobbiesList.any(
      (element) => element.id == item.id,
    )) {
      selectedHobbiesList.remove(item);
    } else {
      selectedHobbiesList.add(item);
    }
  }

  void filterHobbies(String query) {
    if (query.isEmpty) {
      filteredHobbiesList.value = hobbiesList;
    } else {
      filteredHobbiesList.value = hobbiesList
          .where((hobby) =>
              hobby.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();
    }
  }

  var filteredInterestsList = <FieldModel>[].obs;
  var interestList = <FieldModel>[].obs;
  var isloadinginterests = false.obs;
  var selectedInterestList = <FieldModel>[].obs;
  var allSelectedInterest = false.obs;

  Future<void> fetchInterestFromApi() async {
    try {
      String? language = sharedPreferences?.getString("Language");
      isloadinginterests(true);
      final response = await http.get(Uri.parse(
          '${Appconstants.baseURL}/api/fetch/interest?lang=$language'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        interestList.value = data.map((e) => FieldModel.fromJson(e)).toList();
        //  filteredEducationList.value = educationList; // Initialize filtered list with all education
        filteredInterestsList.value = data
            .map(
              (e) => FieldModel.fromJson(e),
            )
            .toList();
      } else {
        print("Error in fetching education data");
      }
    } finally {
      isloadinginterests(false); // Ensure the loading state is reset
    }
  }

  void toggleSelectAllInterest() {
    if (allSelectedInterest.value) {
      selectedInterestList.clear();
    } else {
      selectedInterestList.assignAll(filteredInterestsList);
    }
    allSelectedInterest.value = !allSelectedInterest.value;
  }

  void toggleSelectionInterest(FieldModel item) {
    if (selectedInterestList.any(
      (element) => element.id == item.id,
    )) {
      selectedInterestList.remove(item);
    } else {
      selectedInterestList.add(item);
    }
  }

  void filterInterests(String query) {
    if (query.isEmpty) {
      filteredInterestsList.value = interestList;
    } else {
      filteredInterestsList.value = interestList
          .where((hobby) =>
              hobby.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();
    }
  }
  // sports

  var filteredSportsList = <FieldModel>[].obs;
  var sportsList = <FieldModel>[].obs;
  var isloadingSports = false.obs;
  var selectedSportsList = <FieldModel>[].obs;
  var allSelectedSports = false.obs;

  Future<void> fetchSportsFromApi() async {
    try {
      String? language = sharedPreferences?.getString("Language");
      isloadingSports(true);
      final response = await http.get(
          Uri.parse('${Appconstants.baseURL}/api/fetch/sports?lang=$language'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        sportsList.value = data.map((e) => FieldModel.fromJson(e)).toList();
        //  filteredEducationList.value = educationList; // Initialize filtered list with all education
        filteredSportsList.value = data
            .map(
              (e) => FieldModel.fromJson(e),
            )
            .toList();
      } else {
        // print("Error in fetching education data");
      }
    } finally {
      isloadingSports(false); // Ensure the loading state is reset
    }
  }

  void toggleSelectAllSports() {
    if (allSelectedSports.value) {
      selectedSportsList.clear();
    } else {
      selectedSportsList.assignAll(filteredSportsList);
    }
    allSelectedSports.value = !allSelectedSports.value;
  }

  void toggleSelectionSports(FieldModel item) {
    if (selectedSportsList.any(
      (element) => element.id == item.id,
    )) {
      selectedSportsList.removeWhere((element) => element.id == item.id);
    } else {
      selectedSportsList.add(item);
    }
  }

  void filterSports(String query) {
    if (query.isEmpty) {
      filteredSportsList.value = sportsList;
    } else {
      filteredSportsList.value = sportsList
          .where((hobby) =>
              hobby.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();
    }
  }

// Music

  var filteredMusicList = <FieldModel>[].obs;
  var musicList = <FieldModel>[].obs;
  var isloadingMusic = false.obs;
  var selectedMusicList = <FieldModel>[].obs;
  var allSelectedMusic = false.obs;

  Future<void> fetchMusicFromApi() async {
    try {
      String? language = sharedPreferences?.getString("Language");
      isloadingMusic(true);
      final response = await http.get(
          Uri.parse('${Appconstants.baseURL}/api/fetch/music?lang=$language'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        musicList.value = data.map((e) => FieldModel.fromJson(e)).toList();
        //  filteredEducationList.value = educationList; // Initialize filtered list with all education
        filteredMusicList.value = data
            .map(
              (e) => FieldModel.fromJson(e),
            )
            .toList();
      } else {
        // print("Error in fetching education data");
      }
    } finally {
      isloadingMusic(false); // Ensure the loading state is reset
    }
  }

  void toggleSelectAllMusic() {
    if (allSelectedMusic.value) {
      selectedMusicList.clear();
    } else {
      selectedMusicList.assignAll(filteredMusicList);
    }
    allSelectedMusic.value = !allSelectedMusic.value;
  }

  void toggleSelectionMusic(FieldModel item) {
    if (selectedMusicList.any(
      (element) => element.id == item.id,
    )) {
      selectedMusicList.removeWhere((element) => element.id == item.id);
    } else {
      selectedMusicList.add(item);
    }
  }

  void filterMusic(String query) {
    if (query.isEmpty) {
      filteredMusicList.value = musicList;
    } else {
      filteredMusicList.value = musicList
          .where((hobby) =>
              hobby.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();
    }
  }

// food

  var filteredDressStyleList = <FieldModel>[].obs;
  var dressStyleList = <FieldModel>[].obs;
  var isloadingdressstyle = false.obs;
  var selecteddressstyleList = <FieldModel>[].obs;
  var allSelecteddressstyle = false.obs;

  Future<void> fetchdressStyleFromApi() async {
    try {
      String? language = sharedPreferences?.getString("Language");
      isloadingdressstyle(true);
      final response = await http.get(Uri.parse(
          '${Appconstants.baseURL}/api/fetch/dress_style?lang=$language'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        dressStyleList.value = data.map((e) => FieldModel.fromJson(e)).toList();
        //  filteredEducationList.value = educationList; // Initialize filtered list with all education
        filteredDressStyleList.value = data
            .map(
              (e) => FieldModel.fromJson(e),
            )
            .toList();
      } else {
        // print("Error in fetching education data");
      }
    } finally {
      isloadingdressstyle(false); // Ensure the loading state is reset
    }
  }

  void toggleSelectAllDressStyle() {
    if (allSelecteddressstyle.value) {
      selecteddressstyleList.clear();
    } else {
      selecteddressstyleList.assignAll(filteredDressStyleList);
    }
    allSelecteddressstyle.value = !allSelecteddressstyle.value;
  }

  void toggleSelectiondressStyle(FieldModel item) {
    if (selecteddressstyleList.any(
      (element) => element.id == item.id,
    )) {
      selecteddressstyleList.removeWhere((element) => element.id == item.id);
    } else {
      selecteddressstyleList.add(item);
    }
  }

  void filterdressStyle(String query) {
    if (query.isEmpty) {
      filteredDressStyleList.value = foodList;
    } else {
      filteredDressStyleList.value = foodList
          .where((hobby) =>
              hobby.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();
    }
  }
// food

  var filteredFoodList = <FieldModel>[].obs;
  var foodList = <FieldModel>[].obs;
  var isloadingFood = false.obs;
  var selectedFoodList = <FieldModel>[].obs;
  var allSelectedFood = false.obs;

  Future<void> fetchFoodFromApi() async {
    try {
      String? language = sharedPreferences?.getString("Language");
      isloadingFood(true);
      final response = await http.get(Uri.parse(
          '${Appconstants.baseURL}/api/fetch/favourite_food?lang=$language'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        foodList.value = data.map((e) => FieldModel.fromJson(e)).toList();
        //  filteredEducationList.value = educationList; // Initialize filtered list with all education
        filteredFoodList.value = data
            .map(
              (e) => FieldModel.fromJson(e),
            )
            .toList();
      } else {
        // print("Error in fetching education data");
      }
    } finally {
      isloadingFood(false); // Ensure the loading state is reset
    }
  }

  void toggleSelectAllFood() {
    if (allSelectedFood.value) {
      selectedFoodList.clear();
    } else {
      selectedFoodList.assignAll(filteredFoodList);
    }
    allSelectedFood.value = !allSelectedFood.value;
  }

  void toggleSelectionFood(FieldModel item) {
    if (selectedFoodList.any(
      (element) => element.id == item.id,
    )) {
      selectedFoodList.removeWhere((element) => element.id == item.id);
    } else {
      selectedFoodList.add(item);
    }
  }

  void filterFood(String query) {
    if (query.isEmpty) {
      filteredFoodList.value = foodList;
    } else {
      filteredFoodList.value = foodList
          .where((hobby) =>
              hobby.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();
    }
  }
}
