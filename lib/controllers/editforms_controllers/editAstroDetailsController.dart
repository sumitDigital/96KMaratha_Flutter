import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/controllers/viewProfileControllers/myprofileController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:http/http.dart' as http;
import 'package:_96kuliapp/models/forms/CountryModel.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/profile_screens/edit_profile.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';

class Editastrodetailscontroller extends GetxController {
  final LocationController _locationController = Get.put(LocationController());
  var selectedDate = Rx<DateTime?>(null);
  var maxSelectableDate = Rx<DateTime?>(null);

  var isSubmitted = false.obs;
  var dateofbirth = "".obs;
  var selectedManglikValidated = false.obs;
  var parentContactValidated = false.obs;

  var selected = false.obs;

  var isLoading = false.obs;

  var isvalidate = false.obs;
  var selected24HourFormat = "".obs;

  var isPageLoading = false.obs;
  var basicInfoData = {}.obs; // To hold the API response data
  var selectedDay = Rx<DateTime?>(null);
  @override
  void onInit() {
    super.onInit();
    fetchBasicInfo();
  }

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
              '${Appconstants.baseURL}/api/profile-data/Astronomic?lang=$language'));
      print("response is ${response.body}");
      if (response.statusCode == 200) {
        basicInfoData.value = jsonDecode(response.body);

        dateofbirth.value =
            basicInfoData["data"]["fields"]["date_of_birth"] ?? "DD/MM/YYYY";
        print("in section");

        if (basicInfoData["data"]["fields"]["birth_place"] != null) {
          await Future.wait([_locationController.fetchPlaces()]);
          print("This is dta ");
// Assuming phoneNumberController is a custom controller

          // rascontroller.rasSelected.value.id = rascontroller.rassList.where((e) => e.id == 2 ,).
          /*    rascontroller.rasSelected.value = rascontroller.rassList.firstWhere(
  (e) => e.id == basicInfoData["ras"],  // Replace '2' with the ID you want to preselect
  orElse: () => FieldModel(),  // In case the ID is not found, return an empty model
);*/

          var placeOfBirthId = basicInfoData["data"]["fields"]["birth_place"];

// Find the matching CountryModel based on the id
          var foundPlace = _locationController.places.firstWhere(
            (element) => element.id == placeOfBirthId,
            orElse: () => CountryModel(),
          );
          print("found place ${foundPlace.id}");
          if (foundPlace.id != null) {
            // Assign the found place to the selectedPlace's CountryModel reference
            _locationController.selectedPlace.value.id = foundPlace.id;
            _locationController.selectedPlace.value.name = foundPlace.name;
          }

          convertTo12HourFormat(
              basicInfoData["data"]["fields"]["time_of_birth"]);

          // print("This is contact details ${basicInfoData["contact_number_visibility"]}");
        } else {
          // here make values empty
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
  Future<void> pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDay.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDay.value) {
      selectedDay.value = DateTime(picked.year, picked.month, picked.day);
    }
  }

  void convertTo12HourFormat(String time24Hour) {
    // Parse the 24-hour format time
    DateTime dateTime = DateFormat("HH:mm").parse(time24Hour);

    // Convert to 12-hour AM/PM format
    String hour = DateFormat("hh").format(dateTime); // Hour in 12-hour format
    String minute = DateFormat("mm").format(dateTime); // Minute
    String timePeriod = DateFormat("a").format(dateTime); // AM/PM

    selectedHour.value = hour;
    selectedMinute.value = minute;
    selectedTimeFormat.value = timePeriod;
    selected24HourFormat.value = time24Hour;
  }

  var selectedTime = TimeOfDay.now().obs;
  var selectedHour = "".obs;
  var selectedMinute = "".obs;
  var selectedTime24 = TimeOfDay.now().obs;
  var selectedHour24 = "".obs;
  var selectedMinute24 = "".obs;
  var selectedTimeFormat = "".obs;

  void updateTime(TimeOfDay time, BuildContext context) {
    final int hourIn12Format =
        time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final String period = time.period == DayPeriod.am ? 'AM' : 'PM';

    selectedTime.value = time;
    selectedHour.value = hourIn12Format.toString().padLeft(2, '0');
    selectedMinute.value = time.minute.toString().padLeft(2, '0');
    selectedTimeFormat.value = period;
    final int hourIn24Format = time.hour; // 24-hour format
    final String formattedHour = hourIn24Format.toString().padLeft(2, '0');
    final String formattedMinute = time.minute.toString().padLeft(2, '0');

    selectedTime24.value = time;
    selectedHour24.value = hourIn24Format.toString().padLeft(2, '0');
    selectedMinute24.value = formattedMinute;
    selectedTimeFormat.value = time.period == DayPeriod.am ? 'AM' : 'PM';

    // Update the 24-hour format observable
    selected24HourFormat.value = "$formattedHour:$formattedMinute";
  }

  final MyProfileController _profileController = Get.put(MyProfileController());

  Future<void> BasicForm({
    required String timeOfBirth,
    required String placeOfBirth,
  }) async {
    // The API URL where you want to send the POST request
    String url = '${Appconstants.baseURL}/api/update/Astronomic';
    isLoading.value = true;
    // The request body
    Map<String, dynamic> body = {
      "time_of_birth": timeOfBirth,
      "birth_place": placeOfBirth,
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
    }
  }

  var genderageError = "".obs;
  var gendervalid = true.obs;
  var selectedGender = ''.obs;

  void updateSelectedDate(DateTime? date) {
    selectedDate.value = date;
    validateAge();

    print("Selected date is ${selectedDate.value}");
  }

  void validateAge() {
    // Check if selectedDate is null
    if (selectedDate.value == null) {
      // genderageError.value = "";
      gendervalid.value = false;
      return; // Exit early if the date is not selected
    }
    DateTime currentDate = DateTime.now();

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
}
