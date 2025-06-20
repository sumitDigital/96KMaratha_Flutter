import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/main.dart';

import 'package:_96kuliapp/models/forms/EducationModel.dart';
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';

class SpecializationController extends GetxController {
  var specializationList = <NestedFieldsModel>[].obs;
  var filteredSpecializations =
      <NestedFieldsModel>[].obs; // Store filtered results
  var selectedSpecialization = FieldModel().obs;
  RxInt selectedSpecializationint = 0.obs;

  var isloading = true.obs;

  Future<void> fetchSpecializatiomFromApi() async {
    String? language = sharedPreferences?.getString("Language");
    try {
      isloading(true);
      final response = await http.get(Uri.parse(
          '${Appconstants.baseURL}/api/fetch/with-group/specialization?lang=$language'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        specializationList.value =
            data.map((e) => NestedFieldsModel.fromJson(e)).toList();
        filteredSpecializations.value =
            specializationList; // Initialize filtered list
      } else {
        print("Error in fetching specialization");
      }
    } finally {
      isloading(false); // Ensure the loading state is reset
    }
  }

  void filterSpecializations(String query) {
    if (query.isEmpty) {
      filteredSpecializations.value =
          specializationList; // Show all when query is empty
    } else {
      // Normalize the search query
      String normalizedQuery = _normalizeString(query);

      // Create a temporary filtered list to store matching specializations
      List<NestedFieldsModel> tempFilteredList = [];

      for (var specialization in specializationList) {
        // Check if the specialization's name matches the normalized search query
        bool matchesSpecializationName =
            _normalizeString(specialization.name!).contains(normalizedQuery);

        // Check if any of the FieldModel's name in the value list matches the normalized search query
        List<FieldModel>? matchingFields = specialization.value?.where((field) {
          return _normalizeString(field.serchkey!).contains(normalizedQuery);
        }).toList();

        // If either the specialization name or any field name matches, add the specialization to the filtered list
        if (matchesSpecializationName ||
            (matchingFields != null && matchingFields.isNotEmpty)) {
          // Create a new NestedFieldsModel with the filtered fields
          tempFilteredList.add(NestedFieldsModel(
            id: specialization.id,
            name: specialization.name,
            value: matchingFields, // Include only matching fields
          ));
        }
      }

      // Update the filtered list
      filteredSpecializations.value = tempFilteredList;
    }
  }

// Helper method to normalize strings
  String _normalizeString(String input) {
    return input.toLowerCase().replaceAll(RegExp(r'[.\s]+'),
        ''); // Convert to lower case and remove dots and spaces
  }

  void selectSpecialization(FieldModel item) {
    selectedSpecialization.value = item; // Set the selected item
  }
}
