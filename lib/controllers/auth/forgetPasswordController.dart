import 'dart:convert';

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/accounts_and_settings/newPassword.dart';
import 'package:_96kuliapp/screens/auth_Screens/forgetPasswordOTPScreen.dart';
import 'package:_96kuliapp/screens/auth_Screens/registerOTPScreen.dart';
import 'package:_96kuliapp/screens/plans/upgradeScreen.dart';
import 'package:_96kuliapp/screens/userInfoForms/userInfoStepOne.dart';
import 'package:_96kuliapp/screens/userInfoForms/userInfoStepTwo.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepFour.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepThree.dart';
import 'package:_96kuliapp/utils/bottomnavBar.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:http/http.dart' as http;

class ForgetPasswordcontroller extends GetxController {
  var selectedOption = 'Phone Number'.obs;
  PhoneController phoneNumberController =
      PhoneController(initialValue: PhoneNumber.parse('+91'));
  var isLoading = false.obs; // Observable to track loading state
  var errordata = {}.obs;
  var memberid = 0.obs;
  var errorMessage = ''.obs;
  var showOTPLOG = false.obs;
  var showOTPLOGError = false.obs;
  void updateOTPLOG() {
    showOTPLOG.value = !showOTPLOG.value;
  }

  TextEditingController otpController = TextEditingController();
  final mybox = Hive.box('myBox');
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final facebookAppEvents = FacebookAppEvents();

  @override
  void onInit() async {
    super.onInit();

    await analytics.logEvent(name: 'app_96k_forget_password_screenview');
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

  TextEditingController emailController = TextEditingController();

  void updateSelectedOption(String value) {
    selectedOption.value = value;
  }

  Future<void> emailOTP({String? email}) async {
    isLoading.value = true;
    errorMessage.value = '';

    final url = Uri.parse('${Appconstants.baseURL}/api/forgot');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'email': email}),
      );

      print("response data is ${response.body}");
      if (response.statusCode == 200) {
        // Handle successful login
        analytics.logEvent(name: 'app_96k_change_password_completed');
        final responseData = json.decode(response.body);
        // Example: String token = responseData['token'];
        // Get.offAll(HomeScreen());

        print("Befor route  ${responseData["data"]["member_id"]}");
        //  memberid.value = responseData["data"]["member_id"];
        mybox.put('memberid', responseData["data"]["member_id"]);
        errordata.value = {};
        // Get.toNamed(AppRouteNames.forgetPasswordOTP);
        navigatorKey.currentState!.push(MaterialPageRoute(
          builder: (context) => const ForgetPasswordOTP(),
        ));
        print("aftyer route");

        //  print("THESE ARE YOUR DUCKING VALUES ${values}");
        // updateEmailLoginOption("OTP");

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

  Future<void> phoneOTP({String? phoneNumber}) async {
    isLoading.value = true;
    errorMessage.value = '';

    final url = Uri.parse('${Appconstants.baseURL}/api/forgot');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'mobile_countryCode': 91,
          'mobile': phoneNumber,
          "login_method": "mobile",
        }),
      );

      print("response data is ${response.body}");
      if (response.statusCode == 200) {
        // Handle successful login
        await analytics.logEvent(name: 'app_96k_change_password_completed');
        final responseData = json.decode(response.body);
        // Example: String token = responseData['token'];
        // Get.offAll(HomeScreen());

        print("Befor route  ${responseData["data"]["member_id"]}");
        //  memberid.value = responseData["data"]["member_id"];
        mybox.put('memberid', responseData["data"]["member_id"]);
        errordata.value = {};
//  Get.toNamed(AppRouteNames.forgetPasswordOTP);
        navigatorKey.currentState!.push(MaterialPageRoute(
          builder: (context) => const ForgetPasswordOTP(),
        ));

        print("aftyer route");

        //  print("THESE ARE YOUR DUCKING VALUES ${values}");
        // updateEmailLoginOption("OTP");

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
    print("This is member id passed $memberId");

    print("Member ID is $memberId");

    final url = Uri.parse(
        '${Appconstants.baseURL}/api/forgot-password/verifyotp/$memberId');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'otp': otp,
        }),
      );
      print("response data is ${response.body}");
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        await analytics.logEvent(name: 'app_96k_change_password_completed');
        sharedPreferences?.setString("token", responseData["token"]);
        print("after print");
        //  Get.offAllNamed(AppRouteNames.changePassword);
        navigatorKey.currentState!.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const NewPasswordScreen(),
          ),
          (route) => false,
        );

        // Handle successful login
        //    sharedPreferences!.setString("PageIndex", "8");

        // Get.offAllNamed(AppRouteNames.bottomNavBar);
        // Example: String token = responseData['token'];
        // Get.offAll(HomeScreen());

        print("Response for Login is  ${response.body}");
        print("response is this for login ${response.body}");
        var responsedata = jsonDecode(response.body);
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
        // updatePhoneLoginOption("OTP");

        //   print("Response ${response.body}");
      } else {
        // Handle error
        otpController.text = "";
        final responseData = json.decode(response.body);
        errordata.value = jsonDecode(response.body);

        errorMessage.value = responseData['message'] ?? 'An error occurred';
      }
    } catch (e) {
      errorMessage.value = 'Failed to connect to the server';
    } finally {
      isLoading.value = false;
      String fcm = mybox.get("fcmtoken");

      sendToken(fcmToken: fcm);
    }
  }

  Future<void> resendOTP() async {
    errorMessage.value = '';
    var memberId = mybox.get('memberid');

    print("Tjhis is otp mem_id in orp $memberId");

    final String url =
        '${Appconstants.baseURL}/api/resend-otp?member_id=$memberId';

    try {
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
        //  OTPData.value = responseData;

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
