import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/main.dart';

class ChangePasswordController extends GetxController {
  var updating = false.obs;
  var hidePassword = false.obs;
  void alterPasswordVisiblity() {
    hidePassword.value = !hidePassword.value;
  }

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  var errormsg = {}.obs;
  String? token = sharedPreferences!.getString("token");

  Future<void> updatePassword(
      {required String oldPassword, required String newPassword}) async {
    String apiUrl = "${Appconstants.baseURL}/api/update-password";
    updating.value = true;
    try {
      // JSON payload
      final Map<String, String> payload = {
        "old_password": oldPassword,
        "password": newPassword,
      };

      // API call
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer $token", // Add the token in the Authorization header
        },
        body: json.encode(payload),
      );
      print("THis is response for change ${response.body}");
      if (response.statusCode == 200) {
        // Handle success response
        final responseData = json.decode(response.body);
        print("THIS IS MY PASSWORD UPDATED ${response.body}");
        Get.back();
        oldPasswordController.text = "";
        newPasswordController.text = "";
        //  Get.snackbar("Success", responseData["message"] ?? "Password updated successfully");
      } else {
        // Handle failure response
        final errorData = json.decode(response.body);
        //  Get.snackbar("Error", errorData["message"] ?? "Failed to update password");
        errormsg.value = errorData;
      }
    } catch (e) {
      // Handle exceptions
      //   Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      updating.value = false;
    }
  }
}
