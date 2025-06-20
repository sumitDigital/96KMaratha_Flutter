import 'dart:convert';

import 'package:get/get.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/main.dart';
import 'package:http/http.dart' as http;

class MyPlanController extends GetxController {
  var activePlansList = [].obs;
  var combinedList = [].obs;
  String? language = sharedPreferences?.getString("Language");

  var AddOnPlansList = [].obs;
  var toTalRemainingContact = {}.obs;
  var isLoading = false.obs; // For loading indicator
  String? token = sharedPreferences?.getString("token");

  oninit() {
    fetchPlans();
  }

  Future<void> fetchPlans() async {
    String apiUrl = "${Appconstants.baseURL}/api/my-plan?lang=$language";
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );
      print("THIS IS PLAN RESPONSE ${response.body}");
      if (response.statusCode == 200) {
        // Parse the response
        var jsonData = json.decode(response.body);
        activePlansList.value = jsonData['plans']
            ['active_plans']; // Adjust based on the API response structure
        AddOnPlansList.value = jsonData["addonPlans"];
        combinedList.value = [
          ...jsonData['plans']['active_plans'],
          ...jsonData['addonPlans'],
        ];
        toTalRemainingContact.value = jsonData["TotalRemainContact"];
        print("THIS IS ACTIVE PLANS LIST $combinedList");
      } else {
        //   Get.snackbar("Error", "Failed to load addon plans: ${response.statusCode}");
      }
    } catch (e) {
      //  Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
