import 'dart:convert';

import 'package:get/get.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/main.dart';
import 'package:http/http.dart' as http;

class Razorpaycontroller extends GetxController {
  var userData = {}.obs;
  var userDataPlan = [].obs;

  String? token = sharedPreferences?.getString("token");
  var loadingPage = false.obs;

  Future<void> fetchUserInfo() async {
    loadingPage.value = true;
    final url = Uri.parse('${Appconstants.baseURL}/api/plan');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      print("This is razor pay data ${response.body}");

      if (response.statusCode == 200) {
        // Success
        final jsonResponse = jsonDecode(response.body);
        print('Success: $jsonResponse');
        // Get.snackbar('Success', 'Interest sent successfully!');
        var responseBody = jsonDecode(response.body);
        userData.value = responseBody;

        print("Razor pay key ${userData["plans"]}");

        userDataPlan.value = userData["plans"];
      } else {
        // Error
        print('Error: ${response.statusCode}');
        //  Get.snackbar('Error', 'Failed to send interest');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      Get.snackbar('Exception', 'Something went wrong');
    } finally {
      loadingPage.value = false;
    }
  }
}
