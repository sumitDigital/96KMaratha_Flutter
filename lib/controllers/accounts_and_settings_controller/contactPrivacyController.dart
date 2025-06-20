import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/main.dart';
import 'package:http/http.dart' as http;
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';

class ContactPrivacyController extends GetxController {
  var isPageLoading = false.obs;
  var basicInfoData = {}.obs; // To hold the API response data
  var parentContactSelected = FieldModel().obs;
  var parentContactValidated = false.obs;
  var isSubmitted = false.obs;

  void updateParentContact(FieldModel value) {
    print("Update conatct for this ");
    parentContactSelected.value = value;

    parentContactValidated.value = true;
  }

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

      final response = await http.get(headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      }, Uri.parse('${Appconstants.baseURL}/api/profile-data/Setting'));
      print("response is for contact privacy ${response.body}");
      if (response.statusCode == 200) {
        basicInfoData.value = jsonDecode(response.body);

        //  dateofbirth.value = basicInfoData["data"]["fields"]["date_of_birth"] ?? "DD/MM/YYYY";
        print(
            "in section privacy ${basicInfoData["data"]["fields"]["contact_number_visibility"]}");
        String contactNumberVisibility = basicInfoData["data"]?["fields"]
                ?["contact_number_visibility"] ??
            "0";
        parentContactSelected.value.id =
            int.tryParse(contactNumberVisibility) ?? 0;
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

  var sendingdata = false.obs;

  Future<void> updateContactNumberVisibility(
      {required int contactNumberVisibility}) async {
    sendingdata.value = true;
    String? token = sharedPreferences!.getString("token");

    // API endpoint
    final String url = "${Appconstants.baseURL}/api/update/Setting";

    // JSON payload
    final Map<String, dynamic> payload = {
      "contact_number_visibility": contactNumberVisibility,
    };

    try {
      // Sending POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(payload),
      );

      // Checking the response
      if (response.statusCode == 200) {
        // Success
        print(
            "Contact number visibility updated successfully: ${response.body}");
        Get.back();
      } else {
        // Error
        print(
            "Failed to update contact number visibility: ${response.statusCode}");
        print("Error response: ${response.body}");
      }
    } catch (e) {
      // Exception handling
      print("An error occurred: $e");
    } finally {
      sendingdata.value = false;
    }
  }
}
