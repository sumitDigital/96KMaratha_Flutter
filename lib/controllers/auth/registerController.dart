import 'dart:async';
import 'dart:convert';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/controllers/timerControllerForOTP.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/models/forms/auth/registerErrorModel.dart';
import 'package:_96kuliapp/models/forms/auth/registerModel.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/auth_Screens/registerOTPScreen.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:phone_form_field/phone_form_field.dart';

class RegistrationScreenController extends GetxController {
  var selectedDate = Rx<DateTime?>(null);
  var maxSelectableDate = Rx<DateTime?>(null);
  final mybox = Hive.box('myBox');
  var showOTPLOG = false.obs;
  var showOTPLOGerror = false.obs;
  // String? language = sharedPreferences?.getString("Language");

  void updateOTPLOG() {
    final TimerControllerForOTP timerController =
        Get.put(TimerControllerForOTP());

    showOTPLOG.value = !showOTPLOG.value;
    resendOTP();
    timerController.startTimer();
  }

  PhoneController phoneNumberController =
      PhoneController(initialValue: PhoneNumber.parse('+91'));

  var phvalidation = true.obs;
  RxInt memid = 0.obs;
  var otdata = "".obs;
  var genderageError = "".obs;
  var gendervalid = false.obs;
  var selectedGender = ''.obs;
  var deviceId = "".obs;
  var isLoading = false.obs;
  var selectedCountryCode = "".obs;
  RxInt profileCreatedInt = 0.obs;
  var ishide = true.obs;
  var isvalidate = false.obs;
  var registerModel = {}.obs; // For successful registration
  var registrationErrorModel = RegisterErrorModel().obs; // For error

  var isLoadingForRegistration = false.obs;
  var showCheckBox = false.obs;
  // Observable for the selected profile created for
  RxString selectedProfileCreatedFor = ''.obs;

  // Method to update the selected profile created for
  void updateProfileCreatedFor(String value) {
    selectedProfileCreatedFor.value = value;
    int getProfileCreatedAsInt() {
      // Map the selected gender to an integer
      if (selectedProfileCreatedFor.value == 'Self') {
        return 1;
      } else if (selectedProfileCreatedFor.value == 'Son') {
        return 2;
      } else if (selectedProfileCreatedFor.value == 'Daughter') {
        return 3;
      } else if (selectedProfileCreatedFor.value == 'Brother') {
        return 4;
      } else if (selectedProfileCreatedFor.value == 'Sister') {
        return 5;
      } else if (selectedProfileCreatedFor.value == 'Relative') {
        return 6;
      } else if (selectedProfileCreatedFor.value == 'Friend') {
        return 7;
      } else {
        return 0; // Return 0 or some default value for other or unspecified genders
      }
    }

    profileCreatedInt.value = getProfileCreatedAsInt();
  }

  void showhidetext() {
    ishide.value = !ishide.value;
  }

  void altercheckBox() {
    showCheckBox.value = !showCheckBox.value;
  }

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

  RxInt genderInt = 0.obs;

  String get year => selectedDate.value?.year.toString() ?? '';

  String get month => selectedDate.value?.month.toString() ?? '';

  String get day => selectedDate.value?.day.toString() ?? '';
  String get birthDate =>
      DateFormat('yyyy-MM-dd').format(selectedDate.value ?? DateTime.now());

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

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final facebookAppEvents = FacebookAppEvents();

  Future<void> registerUser({
    required String firstName,
    required String middleName,
    required String lastName,
    required int gender,
    required String dateOfBirth,
    required String email,
    required String mobileCountryCode,
    required String mobile,
    required String password,
    required int onbehalf,
    required int section,
  }) async {
    isLoading.value = true;
    String? language = sharedPreferences?.getString("Language");
    String url = '${Appconstants.baseURL}/api/register?lang=$language';

    // Fetch device information
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceId.value = androidInfo.id;
    print("Device ID is ${deviceId.value}");

    // Prepare the request body
    Map<String, dynamic> body = {
      "first_name": firstName,
      "middle_name": middleName,
      "last_name": lastName,
      "gender": gender,
      "date_of_birth": dateOfBirth,
      "email": email,
      "mobile_countryCode": mobileCountryCode,
      "mobile": mobile,
      "password": password,
      "on_behalf": onbehalf,
      "device_id": deviceId.value,
      "subcastes": section
    };

    try {
      // Send the POST request
      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      print("subcast $body");

      print("Response Body is ${response.body}");

      if (response.statusCode == 200) {
        // Handle success
        print('Registration successful');
        print("This is response for register screen ${response.body}");
        var data = jsonDecode(response.body);
        analytics.logEvent(name: "app_96k_registration_form_complete");
        facebookAppEvents.logEvent(
            name: "Fb_96k_app_registration_form_complete");
        sharedPreferences?.setString("token", data["token"]);
        // Store important data in shared preferences
        print("THis is resp for memotp ${data["data"]["member_id"]}");
        sharedPreferences!.setString("PageIndex", "1");
        mybox.put("memberIDOTP", data["data"]["member_id"]);
        // sharedPreferences!.setInt("MemberID", registerModel["member_id"] );

        memid.value = data["data"]["member_id"];
        //  otdata.value = data["data"]["otp_value"];
        mybox.put("gender", data["data"]["gender"]);
        print("this is gender ${mybox.get("gender")}");
        print("THis is OTP FOR REG ${otdata.value}");

        // Navigate to OTP screen
        //  Get.offAllNamed(AppRouteNames.registerOTPScreen);
        navigatorKey.currentState!.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const RegisterOTPScreen(),
          ),
          (route) => false,
        );
      } else if (response.statusCode == 422) {
        print("Status printing");
        // Handle validation errors
        var errorData = jsonDecode(response.body);
        analytics.logEvent(name: "app_96k_registration_failed");
        facebookAppEvents.logEvent(name: "Fb_96k_app_registration_failed");

        // Update the registration error model with the parsed error response
        registrationErrorModel.value = RegisterErrorModel.fromJson(errorData);

        print('Failed to register: ${registrationErrorModel.value.message}');
        print('Error details: ${registrationErrorModel.value.errors}');

        // Optionally, you can show the error message in a snackbar or alert
        // Get.snackbar("Registration Error", registrationErrorModel.value.message ?? "Unknown error occurred");
        /* Get.snackbar(
  "Registration Error", 
 registrationErrorModel.value.message ?? "Unknown error occurred",
  snackPosition: SnackPosition.BOTTOM, // Show from the bottom
  backgroundColor: AppTheme.primaryColorLighter,         // Red background color
  colorText: Colors.white,             // White text color for contrast
  margin: EdgeInsets.all(10),          // Adds some margin around the snackbar
  borderRadius: 8,                     // Adds rounded corners
  icon: Icon(Icons.error, color: Colors.white), // Adds an icon for emphasis
  snackStyle: SnackStyle.FLOATING,     // Optional: floating style for better appearance
);*/
      } else {
        // Handle other unexpected response statuses
        print('Unexpected response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } on TimeoutException {
//Get.snackbar("Error", "Poor Internet Connection Please try again");
      Get.snackbar(
        "Error",
        "Poor Internet Connection Please try again",
        snackPosition: SnackPosition.BOTTOM, // Show from the bottom
        backgroundColor: AppTheme.primaryColor, // Red background color
        colorText: Colors.white, // White text color for contrast
        margin:
            const EdgeInsets.all(10), // Adds some margin around the snackbar
        borderRadius: 8, // Adds rounded corners
        icon: const Icon(Icons.error,
            color: Colors.white), // Adds an icon for emphasis
        snackStyle: SnackStyle
            .FLOATING, // Optional: floating style for better appearance
      );
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
      //  Get.snackbar("Error", "Unexpected Error Occurred");
    } finally {
      isLoading.value = false;
      String fcm = mybox.get("fcmtoken");
      sendToken(fcmToken: fcm);
    }
  }

  Future<void> sendToken({String? fcmToken}) async {
    String? token = sharedPreferences?.getString("token");

    try {
      // Fetch both education and specialization data in parallel
      print("Token will be sent this way in register");

      final response = await http.post(
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({
            'fcm_token': fcmToken,
          }),
          Uri.parse('${Appconstants.baseURL}/api/fcm/registered'));
      print("this is response for fcm reg ${response.body}");
      if (response.statusCode == 200) {
        print("Token will be sent");
        //  print("response body online  is this ${responsebody["data"]["data"]}");
      } else {
        //Get.snackbar('Error', 'Failed to load data');
        print("Token will not be sent");
      }
    } catch (e) {
      print("Error is this $e");
      //Get.snackbar('Error', e.toString());
    } finally {}
  }

  Future<void> resendOTP() async {
    print("Member id for resend ${mybox.get("memberIDOTP")}");
    int memid = mybox.get("memberIDOTP");
    print("Resend otp called");
    final String url =
        '${Appconstants.baseURL}/api/resend-otp?member_id=$memid';

    try {
      // Prepare the headers and body

      // Show a loading indicator (optional)
      // Get.dialog(CircularProgressIndicator());

      // Make the POST request
      final response = await http.get(
        Uri.parse(url),
      );
      print("Resend otp ka response  reg meaa ${response.body}");
      // Check the response status
      if (response.statusCode == 200) {
        // Account deactivated successfully
        final responseData = jsonDecode(response.body);
        analytics.logEvent(name: "app_96k_resend_otp");
        facebookAppEvents.logEvent(name: "Fb_96k_app_resend_otp");
        print("This is otppppp ");
        otdata.value = responseData["OTP"];

        //   Get.snackbar('Success', 'OTP sent ');
      } else {
        // Handle error response
        final errorData = jsonDecode(response.body);
        Get.snackbar('Error', errorData['message'] ?? '.');
      }
    } catch (error) {
      // Handle any exceptions
      // Get.snackbar('Error', 'An error occurred: $error');
    } finally {}
  }
}
