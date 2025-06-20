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
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/plans/upgradeScreen.dart';
import 'package:_96kuliapp/screens/profile_screens/edit_profile.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepSix.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:http/http.dart' as http;

class EditFamilyFetailsController extends GetxController {
  TextEditingController motherNameController = TextEditingController();

  TextEditingController numberchilren = TextEditingController();
  TextEditingController physicalStatus = TextEditingController();
  PhoneController phoneNumberController =
      PhoneController(initialValue: PhoneNumber.parse('+91'));
  final DashboardController _dashboardController =
      Get.put(DashboardController());
  var phvalidation = true.obs;
  var selectedCountryCode = "".obs;

  var fatherName = "".obs;
  var parentContactValidated = false.obs;

  var searchedHeightList = <FieldModel>[].obs;

  var isSubmitted = false.obs;

  var selected = false.obs;

  var isLoading = false.obs;
  var parentContactSelected = FieldModel().obs;

// family type
  var selectedFamilyTypeValidated = false.obs;
  var SelectedFamilyType = FieldModel().obs;
  void updateFamilyType(FieldModel value) {
    SelectedFamilyType.value = value;

    selectedFamilyTypeValidated.value = true;
  }

// living with parents
  final CasteVerificationBlockController _casteVerificationBlockController =
      Get.put(CasteVerificationBlockController());

  var selectedLivingParentsValidated = false.obs;
  var selectedLivingParentType = FieldModel().obs;
  void updateLivingStatus(FieldModel value) {
    selectedLivingParentType.value = value;

    selectedLivingParentsValidated.value = true;
  }

// family class
  var selectedFamilyClassValidated = false.obs;
  var selectedFamilyClass = FieldModel().obs;
  void updateFamilyClass(FieldModel value) {
    selectedFamilyClass.value = value;

    selectedFamilyClassValidated.value = true;
  }

  var isvalidate = false.obs;

  var isPageLoading = false.obs;
  var basicInfoData = {}.obs; // To hold the API response data
  @override
  void onInit() {
    super.onInit();
    fetchBasicInfo();
    siblingList();
  }

  void preselectnoBrothers(int id) {
    FieldModel? selected = baseList.firstWhere((element) => element.id == id,
        orElse: () => FieldModel());
    if (selected.id != null) {
      updateNumberOfBrothers(selected);
    }
  }

  void preselectnoMarriedBrothers(int id) {
    FieldModel? selected = baseList.firstWhere((element) => element.id == id,
        orElse: () => FieldModel());
    if (selected.id != null) {
      updateMarriedNumberOfBrothers(selected);
    }
  }

  void preselectnoSisters(int id) {
    FieldModel? selected = baseList.firstWhere((element) => element.id == id,
        orElse: () => FieldModel());
    if (selected.id != null) {
      updateNumberOfSisters(selected);
    }
  }

  void preselectnoMarriedSisters(int id) {
    FieldModel? selected = baseList.firstWhere((element) => element.id == id,
        orElse: () => FieldModel());
    if (selected.id != null) {
      updateMarriedNumberOfSisters(selected);
    }
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
              '${Appconstants.baseURL}/api/profile-data/Family?lang=$language'));
      print("response is ${response.body}");
      if (response.statusCode == 200) {
        basicInfoData.value = jsonDecode(response.body);

        phoneNumberController = PhoneController(
            initialValue: PhoneNumber(
                isoCode: IsoCode.IN,
                nsn: basicInfoData["data"]["fields"]["parents_contact_no"]));
        fatherName.value = basicInfoData["data"]["fields"]["father_name"];

        if (basicInfoData["data"]["fields"]["mother_name"] != null) {
          await Future.wait([
            // api
            fetchFatherOccupationsFromApi(),
            fetchMotherOccupationsFromApi(),
            fetchfamilyAssetsFromApi()
          ]);
          print("This is dta ");
          fatherName.value = basicInfoData["data"]["fields"]["father_name"];

          motherNameController.text =
              basicInfoData["data"]["fields"]["mother_name"];
          preselectnoBrothers(
              basicInfoData["data"]["fields"]["no_of_brothers"]);
          preselectnoMarriedBrothers(
              basicInfoData["data"]["fields"]["no_of_married_brothers"]);
          preselectnoSisters(basicInfoData["data"]["fields"]["no_of_sisters"]);
          preselectnoMarriedSisters(
              basicInfoData["data"]["fields"]["no_of_married_sisters"]);
          selectedFatherOccupation.value = fatherOccupationsList.firstWhere(
            (element) =>
                element.id ==
                basicInfoData["data"]["fields"]["father_occupation"],
          );
          selectedMotherOccupation.value = motherrOccupationsList.firstWhere(
            (element) =>
                element.id ==
                basicInfoData["data"]["fields"]["mother_occupation"],
          );
          selectedFamilyAssetsList.value = familyAssetsList
              .where((element) => basicInfoData["data"]["fields"]
                      ["family_assets"]
                  .contains(element.id))
              .toList();

// selectedNumberOfBrothers.value?.id =  basicInfoData["data"]["fields"]["no_of_brothers"] ?? 0;
// selectedMarriedNumberOfBrothers.value?.id = basicInfoData["data"]["fields"]["no_of_married_brothers"] ?? 0;
          SelectedFamilyType.value.id =
              basicInfoData["data"]["fields"]["family_type"];
          selectedLivingParentType.value.id =
              basicInfoData["data"]["fields"]["living_with_parents"];
          selectedFamilyClass.value.id =
              basicInfoData["data"]["fields"]["family_status"];

          // print("This is contact details ${basicInfoData["contact_number_visibility"]}");
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

  void updateParentContact(FieldModel value) {
    print("Update conatct for this ");
    parentContactSelected.value = value;

    parentContactValidated.value = true;
  }

  final MyProfileController _profileController = Get.put(MyProfileController());

  Future<void> BasicForm({
    required String fatherName,
    required String motherName,
    required int contactNumberVisiblity,
    required String parentsContactNumber,
    required int fatherOccupation,
    required int motherOccupation,
    required int NoOfBrothers,
    required int NoOfMarriedBrothers,
    required int NoOfSisters,
    required int NoOfMarriedSisters,
    required int familyType,
    required int familyStatus,
    required String mobileCountryCode,
    required int livingWithParents,
    required List<int> familyAssets,
  }) async {
    print("Father's Name: $fatherName");
    print("Mother's Name: $motherName");
    print("Contact Number Visibility: $contactNumberVisiblity");
    print("Parents' Contact Number: $parentsContactNumber");
    print("Father's Occupation: $fatherOccupation");
    print("Mother's Occupation: $motherOccupation");
    print("Number of Brothers: $NoOfBrothers");
    print("Number of Married Brothers: $NoOfMarriedBrothers");
    print("Number of Sisters: $NoOfSisters");
    print("Number of Married Sisters: $NoOfMarriedSisters");
    print("Family Type: $familyType");
    print("Family Status: $familyStatus");
    print("Mobile Country Code: $mobileCountryCode");
    print("Living with Parents: $livingWithParents");
    print("Family Assets: $familyAssets");

    // The API URL where you want to send the POST request
    String url = '${Appconstants.baseURL}/api/update/Family';
    isLoading.value = true;
    // The request body
    Map<String, dynamic> body = {
      "father_name": fatherName,
      "mother_name": motherName,
      "father_occupation": fatherOccupation,
      "mother_occupation": motherOccupation,
      "no_of_brothers": NoOfBrothers,
      "no_of_married_brothers": NoOfMarriedBrothers,
      "no_of_sisters": NoOfSisters,
      "no_of_married_sisters": NoOfMarriedSisters,
      "family_type": familyType,
      "family_status": familyStatus,
      "mobile_countryCode": mobileCountryCode,
      "living_with_parents": livingWithParents,
      "contact_number_visibility": contactNumberVisiblity,
      "mobile": parentsContactNumber,
      "family_assets": familyAssets,
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
        //  sharedPreferences!.setString("PageIndex" , "3");
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

// father occupation
  var fatherOccupationsList = <FieldModel>[].obs;
  var isloadingFatherOccupations = false.obs;
  var selectedFatherOccupation = FieldModel().obs;

  Future<void> fetchFatherOccupationsFromApi() async {
    String? language = sharedPreferences?.getString("Language");
    try {
      isloadingFatherOccupations(true);
      final response = await http.get(Uri.parse(
          '${Appconstants.baseURL}/api/fetch/father_occupation?lang=$language'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        fatherOccupationsList.value =
            data.map((e) => FieldModel.fromJson(e)).toList();
        //  filteredEducationList.value = educationList; // Initialize filtered list with all education
      } else {
        // print("Error in fetching education data");
      }
    } finally {
      isloadingFatherOccupations(false); // Ensure the loading state is reset
    }
  }

  void updateFatherOccupation(FieldModel sign) {
    selectedFatherOccupation.value = sign;
  }

  var motherrOccupationsList = <FieldModel>[].obs;
  var isloadingMotherOccupations = false.obs;
  var selectedMotherOccupation = FieldModel().obs;

  Future<void> fetchMotherOccupationsFromApi() async {
    String? language = sharedPreferences?.getString("Language");
    try {
      isloadingMotherOccupations(true);
      final response = await http.get(Uri.parse(
          '${Appconstants.baseURL}/api/fetch/mother_occupation?lang=$language'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        motherrOccupationsList.value =
            data.map((e) => FieldModel.fromJson(e)).toList();
        //  filteredEducationList.value = educationList; // Initialize filtered list with all education
      } else {
        // print("Error in fetching education data");
      }
    } finally {
      isloadingMotherOccupations(false); // Ensure the loading state is reset
    }
  }

  void updateMotherOccupation(FieldModel sign) {
    selectedMotherOccupation.value = sign;
  }

  // number of brothers
  // Selected blood index (for tracking purposes)
  var selectedBloodIndex = Rxn<int>();
  var baseList = <FieldModel>[].obs;
  void siblingList() {
    String? language = sharedPreferences?.getString("Language");
    baseList = [
      FieldModel(id: 1, name: language == "en" ? 'None' : "एकही नाही "),
      FieldModel(id: 2, name: '1'),
      FieldModel(id: 3, name: '2'),
      FieldModel(id: 4, name: '3'),
      FieldModel(id: 5, name: '4+'),
    ].obs;
  }

  // var baseList = [
  //   FieldModel(id: 1, name: language == "en" ? 'None' : "एकही नाही "),
  //   FieldModel(id: 2, name: '1'),
  //   FieldModel(id: 3, name: '2'),
  //   FieldModel(id: 4, name: '3'),
  //   FieldModel(id: 5, name: '4+'),
  // ].obs;
// blood group
  var selectedNumberOfBrothers = Rxn<FieldModel>();
  void updateNumberOfBrothers(FieldModel selectedItem) {
    // Update the selected number of brothers
    selectedNumberOfBrothers.value = selectedItem;

    // Update the married brothers list based on the new selection
    updateMarriedBrothersList();

    // Ensure selectedMarriedNumberOfBrothers is valid compared to selectedItem
    int selectedItemId = selectedItem.id ?? 0; // Handle nullable `id`
    int currentMarriedId =
        selectedMarriedNumberOfBrothers.value?.id ?? 0; // Handle nullable `id`

    if (currentMarriedId > selectedItemId) {
      // Reset to a default value
      selectedMarriedNumberOfBrothers.value = FieldModel();
    }
  }

  var marriedNumberOfBrothersList = <FieldModel>[].obs;
  void updateMarriedBrothersList() {
    // Get the selected ID or default to 0 if null
    int selectedId = selectedNumberOfBrothers.value?.id ?? 0;

    // Filter the baseList based on the selected ID
    marriedNumberOfBrothersList.value =
        baseList.where((item) => item.id! <= selectedId).toList();
  }

  var marriedNumberOfSisterList = <FieldModel>[].obs;

  void updateMarriedSistersList() {
    // Get the selected ID or default to 0 if null
    int selectedId = selectedNumberOfSisters.value?.id ?? 0;

    // Filter the baseList based on the selected ID
    marriedNumberOfSisterList.value =
        baseList.where((item) => item.id! <= selectedId).toList();
  }

  var selectedMarriedNumberOfBrothers = Rxn<FieldModel>();
  void updateMarriedNumberOfBrothers(FieldModel selectedItem) {
    selectedMarriedNumberOfBrothers.value = selectedItem;
    //  selectedBloodIndex.value = numberofBrothers.indexOf(selectedItem);
  }

  var selectedMarriedNumberOfSisters = Rxn<FieldModel>();
  void updateMarriedNumberOfSisters(FieldModel selectedItem) {
    selectedMarriedNumberOfSisters.value = selectedItem;
    //  selectedBloodIndex.value = numberofBrothers.indexOf(selectedItem);
  }

  var selectedNumberOfSisters = Rxn<FieldModel>();
  void updateNumberOfSisters(FieldModel selectedItem) {
    selectedNumberOfSisters.value = selectedItem;
    updateMarriedSistersList();
    //  selectedBloodIndex.value = numberofBrothers.indexOf(selectedItem);
    int selectedItemId = selectedItem.id ?? 0; // Handle nullable `id`
    int currentMarriedId =
        selectedMarriedNumberOfSisters.value?.id ?? 0; // Handle nullable `id`

    if (currentMarriedId > selectedItemId) {
      // Reset to a default value
      selectedMarriedNumberOfSisters.value = FieldModel();
    }
  }

  // family assets
  var filteredFamilyAssetsList = <FieldModel>[].obs;
  var familyAssetsList = <FieldModel>[].obs;
  var isloadingfamilyAssets = false.obs;
  var selectedFamilyAssetsList = <FieldModel>[].obs;
  var allSelectedFamilyAssets = false.obs;

  void toggleSelectAllFamilyAssets() {
    if (allSelectedFamilyAssets.value) {
      selectedFamilyAssetsList.clear();
    } else {
      selectedFamilyAssetsList.assignAll(filteredFamilyAssetsList);
    }
    allSelectedFamilyAssets.value = !allSelectedFamilyAssets.value;
  }

  Future<void> fetchfamilyAssetsFromApi() async {
    try {
      String? language = sharedPreferences?.getString("Language");
      isloadingfamilyAssets(true);
      final response = await http.get(Uri.parse(
          '${Appconstants.baseURL}/api/fetch/family_assets?lang=$language'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        familyAssetsList.value =
            data.map((e) => FieldModel.fromJson(e)).toList();
        //  filteredEducationList.value = educationList; // Initialize filtered list with all education
        filteredFamilyAssetsList.value = data
            .map(
              (e) => FieldModel.fromJson(e),
            )
            .toList();
      } else {
        print("Error in fetching education data");
      }
    } finally {
      isloadingfamilyAssets(false); // Ensure the loading state is reset
    }
  }

  void toggleSelectionFamilyAssets(FieldModel item) {
    if (selectedFamilyAssetsList.any(
      (element) => element.id == item.id,
    )) {
      selectedFamilyAssetsList.remove(item);
    } else {
      selectedFamilyAssetsList.add(item);
    }
  }

  void filterFamilyAssets(String query) {
    if (query.isEmpty) {
      filteredFamilyAssetsList.value = familyAssetsList;
    } else {
      filteredFamilyAssetsList.value = familyAssetsList
          .where((hobby) =>
              hobby.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();
    }
  }
}
