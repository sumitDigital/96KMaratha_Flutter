import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/main.dart';

class PremiumPlanLimitedOfferController extends GetxController {
  // Observable list to store the fetched plans
  var planList = <Map<String, dynamic>>[].obs;
  String? token = sharedPreferences?.getString("token");
  var loadingplans = false.obs;
  var userRazorPayKey = "".obs;
  var selectedaddonPlanID = 0.obs;
  var endhours = 0.obs;
  var planimg = "".obs;
  var planPopularity = "".obs;

  var endminutes = 0.obs;
  var endseconds = 0.obs;
// CasteVerificationBlockController _casteVerificationBlockController = Get.put(CasteVerificationBlockController());

  // Method to fetch plans from the API
  Future<void> fetchPlans() async {
    // Define the API URL
    final url = Uri.parse('${Appconstants.baseURL}/api/plan');
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
      print("THOS IS PLAN RESPONSE ${response.body}");
      // Check for successful response
      if (response.statusCode == 200) {
        // Parse the response JSON
        final data = jsonDecode(response.body);

        // Extract the 'plans' part from the JSON response
        if (data != null && data['Offerplans'] != null) {
          List<dynamic> plans = data['Offerplans'];
          planList.value =
              plans.map((plan) => Map<String, dynamic>.from(plan)).toList();
          userRazorPayKey.value = data["razorpayKey"];
          print("THIS IS RAZORPAY KEY ${userRazorPayKey.value}");
          print("THIS IS VALUE FOR END TIME ${planList[0]["plan_img"]}");
          planimg.value = planList[0]["plan_img"];
          planPopularity.value = planList[0]["plan_popularity"];

          String dateTimeString = planList[0]["Plan_End_Date_Time"];
          print("INSIDE PLAN END ");
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
      loadingplans.value = false;
    }
  }
}
