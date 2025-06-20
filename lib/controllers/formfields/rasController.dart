import 'dart:convert';

import 'package:get/get.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';
import 'package:http/http.dart' as http;

class Rascontroller extends GetxController {
  var rassList = <FieldModel>[].obs;
  var rasSelected = FieldModel().obs;

  var isloading = true.obs;
  RxInt rasIndex = 0.obs;
  var selectedItem = ''.obs; // To store only one selected item

  Future<void> fetchRasFromApi() async {
    try {
      isloading(true);
      final response =
          await http.get(Uri.parse('${Appconstants.baseURL}/api/fetch/ras'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        rassList.value = data.map((e) => FieldModel.fromJson(e)).toList();
      } else {
        print("Error in country");
      }
    } finally {
      isloading(false); // Ensure the loading state is reset
    }
  }

  // Method to update the selected item (only one at a time)
  void selectItem(FieldModel item) {
    rasSelected.value = item; // Set the selected item
  }
}
