import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/models/forms/castemultiselectmodel.dart';
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';
import 'package:http/http.dart' as http;
import 'package:_96kuliapp/utils/Apptheme.dart';

class CastController extends GetxController {
  var castList = <FieldModel>[].obs;
  var selectedSectionList = <FieldModel>[].obs;
  var selectedSubSectionList = <CasteMultiSelectModel>[].obs;
  var sectionerror = false.obs;
  var subsectionerror = false.obs;

  var poorNetwork = false.obs;

  var selectedCasteList = <CasteMultiSelectModel>[].obs;

  // String? language = sharedPreferences?.getString("Language");

  var sectionList = <FieldModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    refreshSectionList();
    // sectionList.value = (language == "en"
    //     ? <FieldModel>[
    //         FieldModel(id: 34, name: "96 Kuli Maratha"),
    //         FieldModel(id: 35, name: "Deshahta Maratha"),
    //         FieldModel(id: 36, name: "Kokanasatha Maratha"),
    //         FieldModel(id: 37, name: "Maratha"),
    //       ]
    //     : <FieldModel>[
    //         FieldModel(id: 34, name: "96 कुळी मराठा"),
    //         FieldModel(id: 35, name: "देशस्थ मराठा"),
    //         FieldModel(id: 36, name: "कोकणस्थ मराठा"),
    //         FieldModel(id: 37, name: "मराठा"),
    //       ]);
  }

  void refreshSectionList() {
    String? language = sharedPreferences?.getString("Language");
    sectionList.value = (language == "en"
        ? <FieldModel>[
            FieldModel(id: 34, name: "96 Kuli Maratha"),
            FieldModel(id: 35, name: "Deshahta Maratha"),
            FieldModel(id: 36, name: "Kokanasatha Maratha"),
            FieldModel(id: 37, name: "Maratha"),
          ]
        : <FieldModel>[
            FieldModel(id: 34, name: "96 कुळी मराठा"),
            FieldModel(id: 35, name: "देशस्थ मराठा"),
            FieldModel(id: 36, name: "कोकणस्थ मराठा"),
            FieldModel(id: 37, name: "मराठा"),
          ]);
  }

  var sectionFKone = <CasteMultiSelectModel>[].obs;
  var casteFKone = <CasteMultiSelectModel>[].obs;
  var casteFKtwo = <CasteMultiSelectModel>[].obs;

  var sectionMultiList = <CasteMultiSelectModel>[].obs;
  var casteMultiList = <CasteMultiSelectModel>[].obs;

  var sectionFKtwo = <CasteMultiSelectModel>[].obs;

  var subSectionList = <FieldModel>[].obs;

  var isloading = true.obs;
  var selectedCast = FieldModel().obs; // To store only one selected item

  var selectedSubSection = FieldModel().obs; // To store only one selected item
  // To store only one selected item
  var selectedSubSectionValidated =
      false.obs; // To store only one selected item

  var selectedSection = FieldModel().obs; // To store only one selected item

  var selectedCastValidated = false.obs;

  RxString selectedSectionID = "".obs;
  RxInt selectedSectionInt = 0.obs;
  var selectedSectionValidated = false.obs;

  void updateSelectedSection({required FieldModel item}) {
//  selectedSection.value  = selectedsection;
    selectedSection.value = item;
    selectedSectionValidated.value = true;
  }

  // Fetch data from API
  Future<void> fetchSectionFromApi() async {
    try {
      String? language = sharedPreferences?.getString("Language");
      sectionerror.value = false;
      poorNetwork.value = false;

      isloading(true);
      final response = await http.get(Uri.parse(
          '${Appconstants.baseURL}/api/fetch/subcastes?lang=$language'));
      if (response.statusCode == 200) {
        print("Response is this ${response.body}");
        List<dynamic> data = jsonDecode(response.body);
        sectionList.value = data.map((e) => FieldModel.fromJson(e)).toList();
        sectionerror.value = false;
      } else {
        print("response body ${response.body}");
        sectionerror.value = true;
        print("Error in cast");
      }
    } finally {
      isloading(false); // Ensure the loading state is reset
    }
  }

  Future<void> fetchCastFromApi() async {
    int sectionid = sharedPreferences?.getInt("SectionInt") ?? 0;

    try {
      isloading(true);
      final response = await http.get(Uri.parse(
          '${Appconstants.baseURL}/api/fetch/list/caste/${selectedSection.value.id}'));
      if (response.statusCode == 200) {
        print("Caste resp ${response.body}");
        List<dynamic> data = jsonDecode(response.body);
        castList.value = data.map((e) => FieldModel.fromJson(e)).toList();
      } else {
        print("Error in section");
      }
    } finally {
      isloading(false); // Ensure the loading state is reset
    }
  }

  Future<void> fetchSubSectionFromApi() async {
    try {
      isloading(true);
      final response = await http.get(Uri.parse(
          '${Appconstants.baseURL}/api/fetch/subcastes')); /* /${/api/fetch/list/subcastesselectedSection.value.id} */
      if (response.statusCode == 200) {
        print("Sub Section is ${response.body}");
        List<dynamic> data = jsonDecode(response.body);
        subSectionList.value = data.map((e) => FieldModel.fromJson(e)).toList();
      } else {
        subsectionerror.value = true;
        print("Error in cast");
      }
    } finally {
      isloading(false); // Ensure the loading state is reset
    }
  }

  // Method to update the selected item (only one at a time)
  void selectItem(String item) {
    // selectedSection.value = item;  // Set the selected item
    int getSectionAsInt() {
      // Map the selected gender to an integer
      if (selectedSectionID.value == '1') {
        return 1;
      } else if (selectedSectionID.value == '2') {
        return 2;
      } else {
        return 0; // Return 0 or some default value for other or unspecified genders
      }
    }
  }

  void selectSection(String item) {
    //   selectedSection .value = item;  // Set the selected item
    selectedSectionValidated.value = true;
  }

  void selectSubSection(FieldModel item) {
    selectedSubSection.value = item; // Set the selected item
    selectedSubSectionValidated.value = true;
  }

  Future<void> fetchMultiSectionFromApi() async {
    try {
      isloading(true); // Start loading
      List<int> sectionIds =
          selectedSectionList.map((fieldModel) => fieldModel.id!).toList();

      // Prepare the request body
      Map<String, dynamic> requestBody = {
        "value": sectionIds, // The list you want to send
      };

      final response = await http.post(
        Uri.parse('${Appconstants.baseURL}/api/fetch/groupId/caste'),
        headers: {
          'Content-Type': 'application/json', // Specify the content type
        },
        body: jsonEncode(requestBody), // Convert the body to JSON
      );

      if (response.statusCode == 200) {
        print("Response: ${response.body}");
        List<dynamic> data = jsonDecode(response.body);

        sectionMultiList.value = data
            .map(
              (e) => CasteMultiSelectModel.fromJson(e),
            )
            .toList();
        sectionFKone.value = sectionMultiList
            .where(
              (element) => element.foreignKey == 1,
            )
            .toList();
        sectionFKtwo.value = sectionMultiList
            .where(
              (element) => element.foreignKey == 2,
            )
            .toList();

        // sectionMultiList.value = data.map((e) => FieldModel.fromJson(e)).toList();
      } else {
        print("Error fetching sections: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isloading(false); // Stop loading
    }
  }

  Future<void> fetchMultiCasteFromApi() async {
    try {
      isloading(true); // Start loading
      print("Response: caste init");
      List<int> sectionIds =
          selectedSectionList.map((fieldModel) => fieldModel.id!).toList();
      // Prepare the request body
      Map<String, dynamic> requestBody = {
        "value": sectionIds, // The list you want to send
      };

      final response = await http.post(
        Uri.parse('${Appconstants.baseURL}/api/fetch/groupId/caste'),
        headers: {
          'Content-Type': 'application/json', // Specify the content type
        },
        body: jsonEncode(requestBody), // Convert the body to JSON
      );

      if (response.statusCode == 200) {
        print("Response: caste ${response.body}");
        List<dynamic> data = jsonDecode(response.body);

        casteMultiList.value = data
            .map(
              (e) => CasteMultiSelectModel.fromJson(e),
            )
            .toList();
        casteFKone.value = casteMultiList
            .where(
              (element) => element.foreignKey == 1,
            )
            .toList();
        casteFKtwo.value = casteMultiList
            .where(
              (element) => element.foreignKey == 2,
            )
            .toList();

        // sectionMultiList.value = data.map((e) => FieldModel.fromJson(e)).toList();
      } else {
        print("Error fetching sections: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isloading(false); // Stop loading
    }
  }
}
