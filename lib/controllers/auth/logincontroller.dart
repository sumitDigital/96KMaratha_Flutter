import 'dart:async';
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationScreen.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/models/forms/auth/loginModel.dart';
import 'package:http/http.dart' as http;
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/auth_Screens/otpVerificationScreen.dart';
import 'package:_96kuliapp/screens/auth_Screens/registerOTPScreen.dart';
import 'package:_96kuliapp/screens/plans/upgradeScreen.dart';
import 'package:_96kuliapp/screens/userInfoForms/userInfoStepOne.dart';
import 'package:_96kuliapp/screens/userInfoForms/userInfoStepTwo.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepFour.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepThree.dart';
import 'package:_96kuliapp/utils/bottomnavBar.dart';
import 'package:phone_form_field/phone_form_field.dart';

class LoginController extends GetxController {
  var checkboxvalue = false.obs;
  var hidePassword = false.obs;
  var deviceId = "".obs;
  var showOTPLOG = false.obs;
  var showOTPLOGError = false.obs;
  void updateOTPLOG() {
    showOTPLOG.value = !showOTPLOG.value;
  }

  final facebookAppEvents = FacebookAppEvents();

  TextEditingController emailController = TextEditingController();
  TextEditingController phNumberController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  final mybox = Hive.box('myBox');
  PhoneController phoneNumberController =
      PhoneController(initialValue: PhoneNumber.parse('+91'));
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  TextEditingController passwordController = TextEditingController();
  var selectedOption = 'Phone Number'.obs;
  var phvalidation = true.obs;
  var phautovalidation = true.obs;

  String? language = sharedPreferences?.getString("Language");

  var selectedloginEmailOption = "".obs;
  var selectedloginPhoneOption = "".obs;

  // Method to change the selected value
  void updateEmailLoginOption(String value) {
    selectedloginEmailOption.value = value;
  }

  void updatePhoneLoginOption(String value) {
    selectedloginPhoneOption.value = value;
  }

  void updateSelectedOption(String value) {
    selectedOption.value = value;
  }

  var loginwithOTPClicked = false.obs;
  var isLoading = false.obs; // Observable to track loading state
  var loginData = {}.obs;
  void alterPasswordVisiblity() {
    hidePassword.value = !hidePassword.value;
  }

  void checkboxchange() {
    checkboxvalue.value = !checkboxvalue.value;
  }

  var errorMessage = ''.obs;
  var selectedCountryCode = "".obs;
  var errordata = {}.obs;
  var OTPData = {}.obs;

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

  Future<void> loginWithOtpEmail({String? email}) async {
    isLoading.value = true;
    errorMessage.value = '';

    final url = Uri.parse(
        '${Appconstants.baseURL}/api/login-with-otp/member?lang=$language');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          "login_method": "email",
        }),
      );
      print("response data is ${response.body}");
      if (response.statusCode == 200) {
        facebookAppEvents.logEvent(name: "Fb_96k_app_login_with_otp_complete");
        // Handle successful login
        final responseData = json.decode(response.body);
        // Example: String token = responseData['token'];
        // Get.offAll(HomeScreen());

        OTPData.value = jsonDecode(response.body);
        memberid.value = responseData["member_id"];
        mybox.put('memberid', responseData["member_id"]);
        mybox.put('memberIDOTP', responseData["data"]["member_id"]);

        //  print("THESE ARE YOUR DUCKING VALUES ${values}");
        // updateEmailLoginOption("OTP");
        // Get.toNamed(AppRouteNames.otpVerificationScreen);
        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => const VerificationScreen(),
          ),
        );
        //   print("Response ${response.body}");
      } else {
        // Handle error
        final responseData = json.decode(response.body);
        errordata.value = jsonDecode(response.body);

        errorMessage.value = responseData['message'] ?? 'An error occurred';
      }
    } catch (e) {
      errorMessage.value = 'Failed to connect to the server';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp({String? otp}) async {
    isLoading.value = true;
    errorMessage.value = '';
    var memberId = mybox.get('memberid');

    print("Member ID is $memberId");

    final url = Uri.parse(
        '${Appconstants.baseURL}/api/login-with-otp/verifyotp/$memberId?lang=$language');
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceId.value = androidInfo.id;
    print("Device ID is ${deviceId.value}");
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'otp': otp, "device_id": deviceId.value}),
      );
      print("response data is OTP ${response.body}");
      if (response.statusCode == 200) {
        // Handle successful login
        sharedPreferences!.setString("PageIndex", "8");

        // Get.offAllNamed(AppRouteNames.bottomNavBar);
        // Example: String token = responseData['token'];
        // Get.offAll(HomeScreen());
        analytics.logEvent(name: 'app_96k_login_with_otp_complete');
        //  analytics.logEvent(name: 'app_verify_otp_completed');

        print("Response for Login is  ${response.body}");
        print("response is this for login ${response.body}");
        var responsedata = jsonDecode(response.body);
        sharedPreferences?.setString("token", responsedata["token"]);
        mybox.put("gender", responsedata["data"]["gender"]);
        var pagename = responsedata["redirect"]["pagename"];
        // Handle success (e.g., navigate to the next screen)
        print("Login data  ${responsedata["redirect"]["pagename"]}");

        if (pagename == "OTP-VERIFICATION") {
          sharedPreferences!.setString("PageIndex", "1");
// Get.offAllNamed(AppRouteNames.registerOTPScreen);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const RegisterOTPScreen(),
            ),
            (route) => false,
          );
        } else if (pagename == "BASIC-INFO") {
          sharedPreferences!.setString("PageIndex", "2");
          print("Shared pref ${sharedPreferences?.getString("PageIndex")}");

// Get.offAllNamed(AppRouteNames.userInfoStepOne);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const UserInfoStepOne(),
            ),
            (route) => false,
          );
        } else if (pagename == "EDUCATION-CAREER") {
          sharedPreferences!.setString("PageIndex", "3");

          // Get.offAllNamed(AppRouteNames.userInfoStepTwo);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const UserInfoStepTwo(),
            ),
            (route) => false,
          );
        } else if (pagename == "PARTNER") {
          sharedPreferences!.setString("PageIndex", "4");

// Get.offAllNamed(AppRouteNames.userInfoStepThree);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const UserInfoStepThree(),
            ),
            (route) => false,
          );
        } else if (pagename == "PHOTOS") {
          sharedPreferences!.setString("PageIndex", "5");

          // Get.offAllNamed(AppRouteNames.userInfoStepFour);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const UserInfoStepFour(),
            ),
            (route) => false,
          );
        } else if (pagename == "DASHBOARD") {
          sharedPreferences!.setString("PageIndex", "8");
          print("This is pagename Dashboard");
          //  Get.offAllNamed(AppRouteNames.bottomNavBar);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const BottomNavBar(),
            ),
            (route) => false,
          );
        } else if (pagename == "PLAN") {
          sharedPreferences!.setString("PageIndex", "9");

          //  Get.offAllNamed(AppRouteNames.bottomNavBar);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const UpgradePlan(),
            ),
            (route) => false,
          );
        } else {
          sharedPreferences!.setString("PageIndex", "8");

          //    Get.offAllNamed(AppRouteNames.bottomNavBar);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const BottomNavBar(),
            ),
            (route) => false,
          );
        }
        // updatePhoneLoginOption("OTP");

        //   print("Response ${response.body}");
      } else {
        // Handle error
        otpController.text = "";
        final responseData = json.decode(response.body);
        errordata.value = jsonDecode(response.body);
        await analytics.logEvent(name: 'app_96k_login_failed');

        errorMessage.value = responseData['message'] ?? 'An error occurred';
      }
    } catch (e) {
      errorMessage.value = 'Failed to connect to the server';
    } finally {
      isLoading.value = false;
      _sendApiCall();
      String fcm = mybox.get("fcmtoken");
      sendToken(fcmToken: fcm);
    }
  }

  var memberid = 0.obs;

  Future<void> loginWithOtpMobile({String? mobile}) async {
    isLoading.value = true;
    errorMessage.value = '';
    print("URL CHECK ${Appconstants.baseURL}");
    final url = Uri.parse(
        '${Appconstants.baseURL}/api/login-with-otp/member?lang=$language');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'mobile_countryCode': "91",
          'mobile': mobile,
          "login_method": "mobile",
        }),
      );
      print("response data  for OTP is ${response.body}");
      if (response.statusCode == 200) {
        facebookAppEvents.logEvent(name: "Fb_96k_app_login_with_otp_complete");
        // Handle successful login
        //  sharedPreferences!.setString("PageIndex", "8");

        // Get.offAllNamed(AppRouteNames.bottomNavBar);
        final responseData = json.decode(response.body);
        // Example: String token = responseData['token'];
        // Get.offAll(HomeScreen());

        print("Response for OTP is this in login ${response.body}");
        print("Response for OTP is in Data  $responseData");
        // int memid = responseData["member_id"];
        // print("Thsi is member id ${memid}");
        // sharedPreferences!.setInt("MemberID", memid  );
        // int values = sharedPreferences?.getInt("MemberID")??0;
        memberid.value = responseData["member_id"];
        mybox.put('memberid', responseData["member_id"]);
        mybox.put('memberIDOTP', responseData["data"]["member_id"]);

        //  print("THESE ARE YOUR DUCKING VALUES ${values}");

        // updatePhoneLoginOption("OTP");
        //  Get.toNamed(AppRouteNames.otpVerificationScreen);
        navigatorKey.currentState!.push(MaterialPageRoute(
          builder: (context) => const VerificationScreen(),
        ));
        //   print("Response ${response.body}");
      } else {
        // Handle error
        final responseData = json.decode(response.body);
        errordata.value = jsonDecode(response.body);

        errorMessage.value = responseData['message'] ?? 'An error occurred';
      }
    } catch (e) {
      errorMessage.value = 'Failed to connect to the server';
    } finally {
      isLoading.value = false;
    }
  }

  void alterLoginWithOTP() {
    loginwithOTPClicked.value = !loginwithOTPClicked.value;
  }

  Future<void> loginwithPhonePassword(
      {String? phoneNumber, String? password}) async {
    isLoading.value = true; // Start loading

    final String url =
        '${Appconstants.baseURL}/api/login?lang=$language'; // Update with your API endpoint
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceId.value = androidInfo.id;
    print("Device ID is ${deviceId.value}");
    try {
      // Make the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'mobile_countryCode': "91",
          'mobile': phoneNumber,
          "login_method": "mobile",
          'password': password,
          "device_id": deviceId.value
        }),
      );
      print("response is this Login status ${response.statusCode}");
      print("response is this Login data 123 ${response.body}");

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Parse the JSON response
        // sharedPreferences!.setString("PageIndex" , "8");
        //  Get.offAllNamed(AppRouteNames.bottomNavBar);
        //    loginData.value = LoginDataModel.fromJson(json.decode(response.body));
        // Handle success (e.g., navigate to the next screen)
        print("response is this for login ${response.body}");
        var responsedata = jsonDecode(response.body);
        //  mybox.put("gender", data["data"]["gender"] );
        mybox.put('memberIDOTP', responsedata["data"]["member_id"]);

        mybox.put("gender", responsedata["data"]["gender"]);
        await analytics.logEvent(name: 'app_96k_login_with_pass_complete');
        facebookAppEvents.logEvent(name: "Fb_96k_app_login_with_pass_complete");

        sharedPreferences?.setString("token", responsedata["token"]);
        var pagename = responsedata["redirect"]["pagename"];
        // Handle success (e.g., navigate to the next screen)
        print("Login data  ${responsedata["redirect"]["pagename"]}");

        if (pagename == "OTP-VERIFICATION") {
          sharedPreferences!.setString("PageIndex", "1");
// Get.offAllNamed(AppRouteNames.registerOTPScreen);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const RegisterOTPScreen(),
            ),
            (route) => false,
          );
        } else if (pagename == "BASIC-INFO") {
          sharedPreferences!.setString("PageIndex", "2");
          print("Shared pref ${sharedPreferences?.getString("PageIndex")}");

// Get.offAllNamed(AppRouteNames.userInfoStepOne);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const UserInfoStepOne(),
            ),
            (route) => false,
          );
        } else if (pagename == "EDUCATION-CAREER") {
          sharedPreferences!.setString("PageIndex", "3");

          // Get.offAllNamed(AppRouteNames.userInfoStepTwo);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const UserInfoStepTwo(),
            ),
            (route) => false,
          );
        } else if (pagename == "PARTNER") {
          sharedPreferences!.setString("PageIndex", "4");

// Get.offAllNamed(AppRouteNames.userInfoStepThree);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const UserInfoStepThree(),
            ),
            (route) => false,
          );
        } else if (pagename == "PHOTOS") {
          sharedPreferences!.setString("PageIndex", "5");

          // Get.offAllNamed(AppRouteNames.userInfoStepFour);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const UserInfoStepFour(),
            ),
            (route) => false,
          );
        } else if (pagename == "DASHBOARD") {
          sharedPreferences!.setString("PageIndex", "8");

          //  Get.offAllNamed(AppRouteNames.bottomNavBar);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const BottomNavBar(),
            ),
            (route) => false,
          );
        } else if (pagename == "PLAN") {
          sharedPreferences!.setString("PageIndex", "9");

          //  Get.offAllNamed(AppRouteNames.bottomNavBar);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const UpgradePlan(),
            ),
            (route) => false,
          );
        } else {
          sharedPreferences!.setString("PageIndex", "8");

          //    Get.offAllNamed(AppRouteNames.bottomNavBar);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const BottomNavBar(),
            ),
            (route) => false,
          );
        }
      } else {
        print("Response is  Error ${response.body}");
        // Handle error response
        await analytics.logEvent(name: 'app_96k_login_failed');
        facebookAppEvents.logEvent(name: "Fb_96k_app_login_failed");
        errordata.value = jsonDecode(response.body);
        print("This is Response error $errordata");
        // Get.snackbar('Error', 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions
      //  Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      // print("${loginData.value.status} data madhi");
      isLoading.value = false; // Stop loading
      _sendApiCall();
      String fcm = mybox.get("fcmtoken");
      sendToken(fcmToken: fcm);
    }
  }

  Future<void> loginwithEmailPassword({String? email, String? password}) async {
    isLoading.value = true; // Start loading
    print("This is email and password $email and $password");
    final String url =
        '${Appconstants.baseURL}/api/login?lang=$language'; // Update with your API endpoint
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceId.value = androidInfo.id;
    print("Device ID is ${deviceId.value}");

    try {
      // Make the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          "device_id": deviceId.value,
        }),
      );
      // Check if the response is successful
      if (response.statusCode == 200) {
        // Parse the JSON response
        //   Get.offAllNamed(AppRouteNames.bottomNavBar);
        print("sTATUSSS");
        print("response is this for login ${response.body}");
        var responsedata = jsonDecode(response.body);
        sharedPreferences?.setString("token", responsedata["token"]);
        mybox.put('memberIDOTP', responsedata["data"]["member_id"]);
        var pagename = responsedata["redirect"]["pagename"];
        analytics.logEvent(
            name: 'app_96k_login_with_pass_complete',
            parameters: {
              'gender': responsedata["data"]["gender"] == 1 ? "female" : "male"
            });
        facebookAppEvents.logEvent(name: "Fb_96k_app_login_with_pass_complete");

        // Handle success (e.g., navigate to the next screen)
        mybox.put("gender", responsedata["data"]["gender"]);
        print("Login data  ${responsedata["redirect"]["pagename"]}");
        if (pagename == "OTP-VERIFICATION") {
          sharedPreferences!.setString("PageIndex", "1");
// Get.offAllNamed(AppRouteNames.registerOTPScreen);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const RegisterOTPScreen(),
            ),
            (route) => false,
          );
        } else if (pagename == "BASIC-INFO") {
          sharedPreferences!.setString("PageIndex", "2");
          print("Shared pref ${sharedPreferences?.getString("PageIndex")}");

// Get.offAllNamed(AppRouteNames.userInfoStepOne);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const UserInfoStepOne(),
            ),
            (route) => false,
          );
        } else if (pagename == "EDUCATION-CAREER") {
          sharedPreferences!.setString("PageIndex", "3");

          // Get.offAllNamed(AppRouteNames.userInfoStepTwo);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const UserInfoStepTwo(),
            ),
            (route) => false,
          );
        } else if (pagename == "PARTNER") {
          sharedPreferences!.setString("PageIndex", "4");

// Get.offAllNamed(AppRouteNames.userInfoStepThree);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const UserInfoStepThree(),
            ),
            (route) => false,
          );
        } else if (pagename == "PHOTOS") {
          sharedPreferences!.setString("PageIndex", "5");

          // Get.offAllNamed(AppRouteNames.userInfoStepFour);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const UserInfoStepFour(),
            ),
            (route) => false,
          );
        } else if (pagename == "DASHBOARD") {
          sharedPreferences!.setString("PageIndex", "8");

          //  Get.offAllNamed(AppRouteNames.bottomNavBar);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const BottomNavBar(),
            ),
            (route) => false,
          );
        } else if (pagename == "PLAN") {
          sharedPreferences!.setString("PageIndex", "9");

          //  Get.offAllNamed(AppRouteNames.bottomNavBar);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const UpgradePlan(),
            ),
            (route) => false,
          );
        } else {
          sharedPreferences!.setString("PageIndex", "8");

          //    Get.offAllNamed(AppRouteNames.bottomNavBar);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const BottomNavBar(),
            ),
            (route) => false,
          );
        }
      } else {
        print("Response is  Error ${response.body}");
        // Handle error response
        // app_login_failed
        //  passwordController.text = "";
        await analytics.logEvent(name: 'app_96k_login_failed');
        facebookAppEvents.logEvent(name: "Fb_96k_app_login_failed");

        errordata.value = jsonDecode(response.body);
        print("This is Response error $errordata");
        //  Get.snackbar('Error', 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions
      //  Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      //   print("${loginData.value.status} data madhi");
      isLoading.value = false; // Stop loading
      _sendApiCall();
      String fcm = mybox.get("fcmtoken");
      sendToken(fcmToken: fcm);
    }
  }

  Future<void> _sendApiCall() async {
    String? token =
        sharedPreferences?.getString('token'); // replace 'token' with your key

    try {
      // Example API call using the token
      final response = await http.get(
        Uri.parse('${Appconstants.baseURL}/api/update-online-status'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );
      print("TIME RESP ${response.body}");
      if (response.statusCode == 200) {
        print('API call successful');
      } else {
        print('Failed to call API');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> resendOTP() async {
    errorMessage.value = '';
    var memberId = mybox.get('memberid');
    print("Tjhis is otp mem_id ${memberid.value}");

    final String url =
        '${Appconstants.baseURL}/api/resend-otp?member_id=$memberId';

    try {
      // Prepare the headers and body

      // Show a loading indicator (optional)
      // Get.dialog(CircularProgressIndicator());

      // Make the POST request
      final response = await http.get(
        Uri.parse(url),
      );
      print("Resend otp ka response ${response.body}");
      // Check the response status
      if (response.statusCode == 200) {
        // Account deactivated successfully
        final responseData = jsonDecode(response.body);
        analytics.logEvent(name: "app_96k_resend_otp");
        facebookAppEvents.logEvent(name: "Fb_96k_app_resend_otp");

        print("This is otppppp ");
        OTPData.value = responseData;

        //   Get.snackbar('Success', 'OTP resent !');
      } else {
        // Handle error response
        final errorData = jsonDecode(response.body);
        //    Get.snackbar('Error', errorData['message'] ?? '');
      }
    } catch (error) {
      // Handle any exceptions
      //  Get.snackbar('Error', 'An error occurred: $error');
    } finally {}
  }
}
