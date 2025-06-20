// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/commons/dialogues/forceblock.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationBlock.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationBlockController.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationScreen.dart';
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/screens/ProfilePhotoRequestToChange/ProfilePhotoRequestToChangeScreen.dart';
import 'package:_96kuliapp/screens/plans/upgradeScreen.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepSix.dart';
import 'package:_96kuliapp/utils/bottomnavBar.dart';

class PremiumPlanController extends GetxController {
  // Observable list to store the fetched plans
  var planList = <Map<String, dynamic>>[].obs;
  var planListOffer = <Map<String, dynamic>>[].obs;
  String? token = sharedPreferences?.getString("token");
  // String? token =
  //     "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2RpZ2l0YWxtYXJrZXRpbmdzdHVkaW9nZW5peC5jb20vOTZrbWlncmF0aW9uL3dlYi9hcGkvbG9naW4td2l0aC1vdHAvdmVyaWZ5b3RwLzIxMjY0IiwiaWF0IjoxNzQ3NDcxNDY3LCJleHAiOjIwNTUwNTU0NjcsIm5iZiI6MTc0NzQ3MTQ2NywianRpIjoiMmRiOUc1UDE4SHVGM2haVyIsInN1YiI6IjIxMjY0IiwicHJ2IjoiODY2NWFlOTc3NWNmMjZmNmI4ZTQ5NmY4NmZhNTM2ZDY4ZGQ3MTgxOCJ9.oaZl65bmOI0Be3R9NNxgm6P8DBQb1YgqZnmW9UhI4YA";
  var loadingplans = false.obs;
  var showExploreList = true.obs;
  var userRazorPayKey = "".obs;
  var selectedaddonPlanID = 0.obs;
  var endhours = 0.obs;
  var planimg = "".obs;
  var planBGimg = "".obs;
  var planPopupimg = "".obs;
  var planHeading = "".obs;
  var planPopupHeading = "".obs;

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final facebookAppEvents = FacebookAppEvents();
  String? language = sharedPreferences?.getString("Language");

  var planPopularity = "".obs;
  var planPrice = 0.0.obs;
  var endminutes = 0.obs;
  var endseconds = 0.obs;
  var exploreLength = 0.obs;
  final CasteVerificationBlockController _casteVerificationBlockController =
      Get.put(CasteVerificationBlockController());

  @override
  void onInit() {
    super.onInit();
    fetchPlans();
  }

  Future<void> sendPaymentDataUpgradePlan(
      {required int addonPlanID,
      required String orderID,
      required String paymentID,
      required String signature,
      required String discountID,
      required List<dynamic> conditionID}) async {
    print("INSEIDE PAYMENT SEND");
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false, // Prevent back button dismissal
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      barrierDismissible: false, // Prevent tapping outside to dismiss
    );

    String? token = sharedPreferences?.getString("token");
    // Define the URL for the API endpoint
    String url = '${Appconstants.baseURL}/api/razorpay-payment';

    // Define the request body with your parameters
    Map<String, dynamic> requestBody = {
      "member_token": "$token",
      "plan_id": addonPlanID,
      "order_id": orderID,
      "razorpay_payment_id": paymentID, // replace with actual payment ID
      "razorpay_signature": signature, // replace with actual signature
      "discount_id": discountID, // replace with actual discount ID
      "condition_id": conditionID, // replace with actual condition IDs
    };

    // Set the Authorization token (if needed)

    // Set the headers
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token", // Include the Authorization token
    };

    try {
      // Send the POST request to the API
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(requestBody), // Send data as JSON
      );
      print("Response for upgrade plan ${response.body}");
      // Check if the request was successful
      if (response.statusCode == 200) {
        // If successful, handle the response here
        var data = jsonDecode(response.body);

        if (data["redirection"]["pagename"] == "FORCEPOPUP") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.dialog(
                barrierColor: Colors.black.withOpacity(0.8),
                const ForceBlockDialogue(),
                barrierDismissible: false);
          });
        } else if (data["redirection"]["pagename"].trim() == "PENDING") {
          _casteVerificationBlockController.popup.value =
              data["redirection"]["Popup"];
          WidgetsBinding.instance.addPostFrameCallback((_) {
            sharedPreferences!.setString("PageIndex", "8");
            analytics.logEvent(name: "app_96k_first_dashboard_landed");
            facebookAppEvents.logEvent(
                name: "Fb_96k_app_first_dashboard_landed");
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const CasteVerificationBlock(),
              ),
              (route) => false,
            );
          });
        } else if (data["redirection"]["pagename"].trim() ==
            "CASTE-VERIFICATION") {
          sharedPreferences!.setString("PageIndex", "8");
          analytics.logEvent(name: "app_96k_first_dashboard_landed");
          facebookAppEvents.logEvent(name: "Fb_96k_app_first_dashboard_landed");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const CasteVerificationScreen(),
              ),
              (route) => false,
            );
          });
        } else if (data["redirection"]["pagename"].trim() ==
            "DOCUMENT-REJECTED") {
          sharedPreferences!.setString("PageIndex", "8");
          analytics.logEvent(name: "app_96k_first_dashboard_landed");
          facebookAppEvents.logEvent(name: "Fb_96k_app_first_dashboard_landed");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const UserInfoStepSix(),
              ),
              (route) => false,
            );
          });
        } else if (data["redirection"]["pagename"].trim() == "DASHBOARD") {
          sharedPreferences!.setString("PageIndex", "8");
          analytics.logEvent(name: "app_96k_first_dashboard_landed");
          facebookAppEvents.logEvent(name: "Fb_96k_app_first_dashboard_landed");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const BottomNavBar(),
              ),
              (route) => false,
            );
          });
        }
        print('Payment data sent successfully to backend');
        print('Response: ${response.body}');
        sharedPreferences!.setString("PageIndex", "8");
        analytics.logEvent(name: "app_96k_first_dashboard_landed");
        facebookAppEvents.logEvent(name: "Fb_96k_app_first_dashboard_landed");
        navigatorKey.currentState!.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const BottomNavBar(),
          ),
          (route) => false,
        );
      } else {
        // If there's an error, print the error message
        print('Failed to send payment data to backend');
        print('Error: ${response.body}');
      }
    } catch (e) {
      // Handle any exceptions (e.g., no internet connection)
      print('Error: $e');
    }
  }

  // Method to fetch plans from the API
  Future<void> fetchPlans() async {
    // Define the API URL
    final url = Uri.parse('${Appconstants.baseURL}/api/plan?lang=$language');
    loadingplans.value = true;
    try {
      // Send a GET request with the auth token in the header
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print("THOS IS PLAN RESPONSE ${response.headers}");
      // Check for successful response
      if (response.statusCode == 200) {
        // Parse the response JSON
        final data = jsonDecode(response.body);
        print("THIS IS PLAN data $data");
        // print(
        //     "THIS IS Plan List ${data["plans"]["plan_data"]["plan_display_name"]}");
        // exploreLength.value = data["exploreData"]["explore_recommended"];
        // print("THIS IS APP ROUTE ${data["redirection"]["pagename"]}");
        // Extract the 'plans' part from the JSON response
        showExploreList.value = data["exploreListStatus"];
        print("explore check ${showExploreList.value}");
        if (data['plans'] != null && data['plans'].isNotEmpty) {
          print("INSIDE CONDITION");
          List<dynamic> plans = data['plans'];
          planList.value =
              plans.map((plan) => Map<String, dynamic>.from(plan)).toList();
          userRazorPayKey.value = data["razorpayKey"];
          showExploreList.value = data["exploreListStatus"];
          print("THIS IS Plan length ${planList.length}");
        } else {
          print("No plans found in the response.");
        }
        print("THIS PLAN OFFER ${data['offerPlans']}");
        if (data != null &&
            data['offerPlans'] != null &&
            data['offerPlans'].isNotEmpty) {
          print("INSIDE CONDITION");
          List<dynamic> plans = data['offerPlans'];
          planListOffer.value =
              plans.map((plan) => Map<String, dynamic>.from(plan)).toList();
          userRazorPayKey.value = data["razorpayKey"];
          print("Plan Timer1 $planListOffer");
          print("Plan Timer ${planListOffer[0]["Plan_End_Date_Time"]}");
          print("THIS IS RAZORPAY KEY ${userRazorPayKey.value}");
          print(
              "THIS IS VALUE FOR END TIME ${planListOffer[0]["discount_data"]["discount_image"]}");
          // planimg.value = planListOffer[0]["plan_img"];
          // planPopupimg.value = planListOffer[0]["plan_popup_img"];
          // planBGimg.value = planListOffer[0]["plan_bg_img"];
          // planPopupHeading.value = planListOffer[0]["plan_popup_heading"];
          // print("THis is heading ${planListOffer[0]["Plan_heading"]}");
          // planHeading.value = planListOffer[0]["Plan_heading"];
          // planPopularity.value = planListOffer[0]["plan_popularity"];
          print("THIS IS PLAN LISTss ${plans[0]["Plan_End_Date_Time"]}");

          // String dateTimeString =
          //     planListOffer[0]["offerPlans"]["Plan_End_Date_Time"];
          String dateTimeString = planListOffer[0]["Plan_End_Date_Time"];
          print("INSIDE PLAN END $dateTimeString");
          // Define the format of the input string (YYYY-MM-DD HH:mm:ss)
          DateFormat inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
          // Image.network(_premiumPlanController.planimg.value)

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
          // plan_img
        } else {
          print("No plans found in the response.");
        }
        print("THIS IS PLAN LIST ${planListOffer.value}");
        if (data["redirection"]["pagename"] == "FORCEPOPUP") {
          sharedPreferences!.setString("PageIndex", "8");
          analytics.logEvent(name: "app_96k_first_dashboard_landed");
          facebookAppEvents.logEvent(name: "Fb_96k_app_first_dashboard_landed");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.dialog(
                barrierColor: Colors.black.withOpacity(0.8),
                const ForceBlockDialogue(),
                barrierDismissible: false);
          });
        } else if (data["redirection"]["pagename"].trim() == "PENDING") {
          sharedPreferences!.setString("PageIndex", "8");
          analytics.logEvent(name: "app_96k_first_dashboard_landed");
          facebookAppEvents.logEvent(name: "Fb_96k_app_first_dashboard_landed");
          _casteVerificationBlockController.popup.value =
              data["redirection"]["Popup"];
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const CasteVerificationBlock(),
              ),
              (route) => false,
            );
          });
        } else if (data["redirection"]["pagename"].trim() ==
            "CASTE-VERIFICATION") {
          sharedPreferences!.setString("PageIndex", "8");
          analytics.logEvent(name: "app_96k_first_dashboard_landed");
          facebookAppEvents.logEvent(name: "Fb_96k_app_first_dashboard_landed");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const CasteVerificationScreen(),
              ),
              (route) => false,
            );
          });
        } else if (data["redirection"]["pagename"].trim() ==
            "DOCUMENT-REJECTED") {
          sharedPreferences!.setString("PageIndex", "8");
          analytics.logEvent(name: "app_96k_first_dashboard_landed");
          facebookAppEvents.logEvent(name: "Fb_96k_app_first_dashboard_landed");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const UserInfoStepSix(),
              ),
              (route) => false,
            );
          });
        } else if (data["redirection"]["pagename"].trim() == "DASHBOARD") {
          sharedPreferences!.setString("PageIndex", "8");
          analytics.logEvent(name: "app_96k_first_dashboard_landed");
          facebookAppEvents.logEvent(name: "Fb_96k_app_first_dashboard_landed");

          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const BottomNavBar(),
              ),
              (route) => false,
            );
          });
        } else if (data["redirection"]["pagename"] == "UPDATE-PHOTO") {
          sharedPreferences!.setString("PageIndex", "8");
          analytics.logEvent(name: "app_96k_first_dashboard_landed");
          facebookAppEvents.logEvent(name: "Fb_96k_app_first_dashboard_landed");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const ProfilePhotoRequestToChangeScreen(),
              ),
              (route) => false,
            );
          });
        }
        /*  if(data["redirection"]["pagename"].trim() == "CASTE-VERIFICATION-PENDING"){
         print("this is page name inside ${data["redirection"]["pagename"]}");
         
           _casteVerificationBlockController.popup.value = data["redirection"]["Popup"];
              navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const CasteVerificationBlock(),) ,   (route) => false,);
          
         }else if (data["redirection"]["pagename"].trim() == "CASTE-VERIFICATION"){
         //  _casteVerificationBlockController.popup.value = basicInfoData["redirection"]["Popup"];
              navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const CasteVerificationScreen(),) ,   (route) => false,);
          
         }*/
      } else {
        // Handle non-successful response
        print('Failed to fetch plans. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Handle any errors during the HTTP request
      print('An error occurred while fetching plans: $e');
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        loadingplans.value = false;
      });
      // loadingplans.value = false;
    }
  }
}
