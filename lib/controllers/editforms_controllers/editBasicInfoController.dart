import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/viewProfileControllers/myprofileController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/models/forms/auth/registerErrorModel.dart';
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';
import 'package:_96kuliapp/screens/profile_screens/edit_profile.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:http/http.dart' as http;

class EditBasicInfoController extends GetxController {
  var selectedGender = ''.obs;
  var selectedGenderShow = ''.obs;

  var selectedDate = Rx<DateTime?>(null);
  var selectedDateShow = Rx<DateTime?>(null);

  var maxSelectableDate = Rx<DateTime?>(null);

  var genderageError = "".obs;

  void updateOption(String value) {
    selectedGender.value = value;
    int getGenderAsInt() {
      if (selectedGender.value == 'Male') {
        selectedDate.value = null;
        return 2;
      } else if (selectedGender.value == 'Female') {
        selectedDate.value = null;

        return 1;
      } else {
        return 0;
      }
    }

    genderInt.value = getGenderAsInt();
  }

  var gendervalid = true.obs;
  var hasTextChanged = false.obs;

  void validateAge() {
    // Check if selectedDate is null
    if (selectedDate.value == null) {
      // genderageError.value = "";
      gendervalid.value = false;
      return; // Exit early if the date is not selected
    }
    DateTime currentDate = DateTime.now();
    print("Valid age is ${selectedGender.value}");
    // If selectedDate is not null, proceed with the age validation
    if (selectedGender.value == "Male") {
      print("This is male ");
      maxSelectableDate.value =
          DateTime(currentDate.year - 21, currentDate.month, currentDate.day);
      if (DateTime.now().year - selectedDate.value!.year < 21) {
        genderageError.value =
            "Only those 21 years old grooms are permitted to register";
        gendervalid.value = false;
      } else {
        genderageError.value = "";
        gendervalid.value = true;
      }
    } else {
      if (DateTime.now().year - selectedDate.value!.year < 18) {
        maxSelectableDate.value =
            DateTime(currentDate.year - 18, currentDate.month, currentDate.day);

        genderageError.value =
            "Only those 18-year-old brides are allowed to register";
        gendervalid.value = false;
      } else {
        genderageError.value = "";
        gendervalid.value = true;
      }
    }
  }

  RxInt genderInt = 0.obs;

  String get year => selectedDate.value?.year.toString() ?? '';

  String get month => selectedDate.value?.month.toString() ?? '';

  String get day => selectedDate.value?.day.toString() ?? '';
  String get birthDate =>
      DateFormat('yyyy-MM-dd').format(selectedDate.value ?? DateTime.now());

  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();

  var selectedEditOption = false.obs;
  void updateEditOption() {
    selectedEditOption.value = !selectedEditOption.value;
  }

  var selectedOption = [].obs;
  final List<Map<String, dynamic>> optionsList = [
    {"label": "Name", "id": 1},
    {"label": "Gender and Date of Birth", "id": 2},
    {"label": "Email ID", "id": 3},
    {"label": "Mobile Number", "id": 4},
  ];
  var registrationErrorModel = RegisterErrorModel().obs; // For error

  void updateSelectedDate(DateTime? date) {
    selectedDate.value = date;
    print("THis is selected date ${selectedDate.value}");
    validateAge();

    print("Selected date is ${selectedDate.value}");
  }

  void updateSelectedOptionList(int id) {
    print("THIS IS ID OF SELCTED OPTIONS $id");
    print("THIS IS ID OF SELCTED OPTIONS $selectedOption");

    if (selectedOption.contains(id)) {
      selectedOption.remove(id);
      if (selectedOption.isEmpty) {}
    } else {
      selectedOption.add(id);
    }
  }

  PhoneController phoneNumberController =
      PhoneController(initialValue: PhoneNumber.parse('+91'));
  var showEditForm = false.obs;
  void updateShowEditForm() {
    showEditForm.value = !showEditForm.value;
  }

  var phvalidation = true.obs;
  var selectedCountryCode = "".obs;

  var searchedHeightList = <FieldModel>[].obs;

  var isSubmitted = false.obs;
  var dateofbirth = "".obs;
  var firstName = "".obs;
  var middleName = "".obs;
  var lastName = "".obs;
  var mobileNumber = "".obs;
  var emailAddress = "".obs;
  var gender = "".obs;

  var selectedManglikValidated = false.obs;
  var manglikSelected = FieldModel().obs;
  var parentContactValidated = false.obs;

  var selected = false.obs;

  var isLoading = false.obs;
  var parentContactSelected = FieldModel().obs;

  var isvalidate = false.obs;

  var selectedGenderShowInt = 0.obs;
  var isPageLoading = false.obs;
  var basicInfoData = {}.obs; // To hold the API response data
  var selectedDay = Rx<DateTime?>(null);
  @override
  void onInit() {
    super.onInit();
    loadData();
    //  fetchDocDetails();
  }

  Future<void> loadData() async {
    isPageLoading(true); // Set loading state
    try {
      await Future.wait([
        fetchBasicInfo(),
        fetchDocDetails(),
      ]);
      // Both functions have successfully fetched their data
      print("All data loaded successfully");
    } catch (e) {
      // Handle any errors that occurred during the fetching process
      print("Error while loading data: $e");
    } finally {
      isPageLoading(false); // Stop loading state
    }
  }

  var documentVerificationStatus = 0.obs;

  Future<void> fetchDocDetails() async {
    String? token = sharedPreferences!.getString("token");

    print("Token is $token");
    try {
      final response = await http.get(
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $token",
          },
          Uri.parse(
              '${Appconstants.baseURL}/api/member-data/data-type/document'));
      print("response is for doct ${response.body}");
      if (response.statusCode == 200) {
        final responsebody = jsonDecode(response.body);
        documentVerificationStatus.value =
            responsebody["data"]["is_Document_Verification"];
        print("Document veriiiiii ${documentVerificationStatus.value}");
      }
    } catch (e) {
      // Handle exception
      //  Get.snackbar('Error', e.toString());
    } finally {}
  }

  Future<void> fetchBasicInfo() async {
    String? token = sharedPreferences!.getString("token");
    String? language = sharedPreferences?.getString("Language");
    print("Token is $token");
    try {
      final response = await http.get(
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $token",
          },
          Uri.parse(
              '${Appconstants.baseURL}/api/profile-data/basic-info?lang=$language'));
      print("response is for basic ${response.statusCode}");

      print("response is for basic ${response.body}");
      if (response.statusCode == 200) {
        basicInfoData.value = jsonDecode(response.body);
        print("basic info is  $basicInfoData");

        if (basicInfoData["data"]["fields"]["gender"] == 2) {
          print("THIS IS GENDER ");
          updateOption(language == "en" ? "Male" : "पुरुष");
          selectedGenderShow.value = language == "en" ? "Male" : "पुरुष";
          selectedGenderShowInt.value = 2;
        } else {
          updateOption(language == "en" ? "Female" : "महिला");
          selectedGenderShow.value = language == "en" ? "Female" : "महिला";
          selectedGenderShowInt.value = 1;
        }
        firstName.value = basicInfoData["data"]["fields"]["first_name"];
        firstNameController.text =
            basicInfoData["data"]["fields"]["first_name"];
        middleName.value = basicInfoData["data"]["fields"]["middle_name"];
        middleNameController.text =
            basicInfoData["data"]["fields"]["middle_name"];
        lastName.value = basicInfoData["data"]["fields"]["last_name"];
        lastNameController.text = basicInfoData["data"]["fields"]["last_name"];
        mobileNumber.value = basicInfoData["data"]["fields"]["mobile_number"];
        phoneNumberController = PhoneController(
            initialValue: PhoneNumber(
                isoCode: IsoCode.IN,
                nsn: basicInfoData["data"]["fields"]["mobile_number"]));

        emailAddress.value = basicInfoData["data"]["fields"]["email_address"];
        emailAddressController.text =
            basicInfoData["data"]["fields"]["email_address"];
        //  gender.value = basicInfoData["data"]["fields"]["gender"];
        print(
            "date of birth for ${basicInfoData["data"]["fields"]["date_of_birth"]}");
        dateofbirth.value =
            basicInfoData["data"]["fields"]["date_of_birth"] ?? "";
        String? rawDate = basicInfoData["data"]["fields"]["date_of_birth"];
        if (rawDate != null && rawDate.isNotEmpty) {
          print("THIS IS RAWDATE");
          selectedDate.value = DateTime.parse(rawDate);
          selectedDateShow.value = DateTime.parse(rawDate);
          print("THIS IS SELECTED DATE $selectedDateShow");
        } else {
          print("Empty date passed");
          selectedDateShow.value = null; // Or assign a default date
          selectedDate.value = null; // Or assign a default date
        }
      } else {
        print("Fetched successfully Error");

        // Handle error if needed
        //     Get.snackbar('Error', 'Failed to load data');
      }
    } catch (e) {
      // Handle exception
      //  Get.snackbar('Error', e.toString());
    } finally {}
  }
  // Method to pick a date

  var selectedEatingHabitValidated = false.obs;

  var selectedChildrenInt = 0.obs;

  final MyProfileController _profileController = Get.put(MyProfileController());

  Future<void> BasicForm({
    required String firstnamefromform,
    required String middlenamefromform,
    required String lastnamefromform,
    required int genderfromformfromform,
    required String dateOfBirthfromform,
  }) async {
    String url = '${Appconstants.baseURL}/api/profile-change-requests';
    isLoading.value = true;

    // Build the body dynamically with changed fields
    Map<String, dynamic> body = {};
    if (firstName.value != firstnamefromform) {
      body['first_name'] = firstnamefromform;
    }
    if (middleName.value != middlenamefromform) {
      body['middle_name'] = middlenamefromform;
    }
    if (lastName.value != lastnamefromform) {
      body['last_name'] = lastnamefromform;
    }
    if (selectedGenderShowInt.value != genderfromformfromform) {
      body['gender'] = genderfromformfromform;
    }
    if (selectedDateShow.value.toString() != dateOfBirthfromform) {
      body['date_of_birth'] = dateOfBirthfromform;
    }

    if (body.isEmpty) {
      print("No fields have been changed.");
      isLoading.value = false;
      return;
    }

    print("Changed User Information: $body");

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

      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        print('Basic form successful');

        if (navigatorKey.currentState!.canPop()) {
          Get.delete<EditBasicInfoController>();
          Get.back();

          _profileController.fetchUserInfo();
        } else {
          navigatorKey.currentState!.pushReplacement(
            MaterialPageRoute(builder: (context) => const EditProfile()),
          );
        }
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
