import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/main.dart';

class LogoutController extends GetxController {
  // Method to handle logout
  var isLoading = false.obs;
  Future<void> logout() async {
    isLoading.value = true;
    String? token = sharedPreferences?.getString("token");
    final String apiUrl = "${Appconstants.baseURL}/api/logout";

    try {
      // Send POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token', // Add the auth token here
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Successfully logged out
        print("Logout successful");
        // Perform post-logout actions like clearing user data
      } else {
        // Handle errors
        print("Logout failed: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      // Handle exceptions
      print("An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
