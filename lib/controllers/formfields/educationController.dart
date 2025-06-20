import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/models/forms/EducationModel.dart';
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';
import 'package:http/http.dart' as http;
import 'package:_96kuliapp/utils/Apptheme.dart';

class EducationController extends GetxController {
  var educationList = <NestedFieldsModel>[].obs;
  var filteredEducationList =
      <NestedFieldsModel>[].obs; // New observable for filtered list
  var selectedEducation = FieldModel().obs;
  RxInt selectEducationint = 0.obs;
  var isloading = true.obs;
  var selectedEducationList = <FieldModel>[].obs;
  var selectedEducationListTemp = <FieldModel>[].obs;

  // New observable for search query
  var searchQuery = ''.obs;
  void selectAll(List<FieldModel> items) {
    // Add only items that are not already in selectedEducationList
    final itemsToAdd = items.where((item) => !selectedEducationList
        .any((selectedItem) => selectedItem.id == item.id));

    // Combine existing and new items, then sort by name length
    selectedEducationList.addAll(itemsToAdd);
    selectedEducationList
        .sort((a, b) => (a.name?.length ?? 0).compareTo(b.name?.length ?? 0));
  }

  // Clear all selected items in a section
  void clearSelection(List<FieldModel> items) {
    selectedEducationList.removeWhere((selectedItem) =>
        items.any((item) => item.id == selectedItem.id)); // Compare by ID
  }

  void toggleEducationSelection(FieldModel item) {
    // Check if the item already exists in the list
    final existingIndex =
        selectedEducationList.indexWhere((element) => element.id == item.id);
    if (existingIndex != -1) {
      // If found, remove the item by its index
      selectedEducationList.removeAt(existingIndex);
    } else {
      // Otherwise, add the item
      selectedEducationList.add(item);
    }
  }

  void toggleEducationSelectionTemp(FieldModel item) {
    // Check if the item already exists in the list
    final existingIndex = selectedEducationListTemp
        .indexWhere((element) => element.id == item.id);
    if (existingIndex != -1) {
      // If found, remove the item by its index
      selectedEducationListTemp.removeAt(existingIndex);
    } else {
      // Otherwise, add the item
      selectedEducationListTemp.add(item);
    }
  }

  Future<void> fetcheducationFromApi() async {
    String? language = sharedPreferences?.getString("Language");
    try {
      isloading(true);
      final response = await http.get(Uri.parse(
          '${Appconstants.baseURL}/api/fetch/with-group/education?lang=$language'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        educationList.value =
            data.map((e) => NestedFieldsModel.fromJson(e)).toList();
        filteredEducationList.value =
            educationList; // Initialize filtered list with all education
        print("Education List Length: ${response.request}");
      } else {
        print("Error in fetching education data");
      }
    } finally {
      isloading(false); // Ensure the loading state is reset
    }
  }

  void selectEducation(FieldModel item) {
    selectedEducation.value = item; // Set the selected item
  }

  void filterEducationList() {
    String? language = sharedPreferences?.getString("Language");
    if (language == 'mr') {
      filterEducationListBySearchKey();
    } else {
      filterEducationListByName();
    }
  }

  // New method to filter the education list based on the search query
  void filterEducationListByName() {
    if (searchQuery.value.isEmpty) {
      filteredEducationList.value =
          educationList; // Show all if search is empty
    } else {
      // Normalize the search query
      String normalizedQuery = _normalizeString(searchQuery.value);

      // Filter the education list
      List<NestedFieldsModel> tempFilteredList = [];

      for (var education in educationList) {
        // Check if the education's name matches the normalized search query
        bool matchesEducationName =
            _normalizeString(education.name!).contains(normalizedQuery);

        // Check if any of the FieldModel's name in the value list matches the normalized search query
        List<FieldModel>? matchingFields = education.value?.where((field) {
          return _normalizeString(field.serchkey!).contains(normalizedQuery);
        }).toList();

        // If either the education name or any field name matches, add the education to the filtered list
        if (matchesEducationName ||
            (matchingFields != null && matchingFields.isNotEmpty)) {
          // Create a new NestedFieldsModel with the filtered fields
          tempFilteredList.add(NestedFieldsModel(
            id: education.id,
            name: education.name,
            value: matchingFields, // Include only matching fields
          ));
        }
      }

      // Update the filtered list
      filteredEducationList.value = tempFilteredList;
    }
  }

  void filterEducationListBySearchKey() {
    String? language = sharedPreferences?.getString("Language");
    if (searchQuery.value.isEmpty) {
      filteredEducationList.value = educationList;
    } else {
      String normalizedQuery = _normalizeString(searchQuery.value);

      List<NestedFieldsModel> tempFilteredList = [];

      for (var education in educationList) {
        bool matchesEducationName =
            _normalizeString(education.name ?? '').contains(normalizedQuery);

        List<FieldModel>? matchingFields = education.value?.where((field) {
          if (language == 'mr') {
            return _normalizeString(field.serchkey ?? '')
                .contains(normalizedQuery);
          } else {
            return _normalizeString(field.name ?? '').contains(normalizedQuery);
          }
        }).toList();

        if (matchesEducationName ||
            (matchingFields != null && matchingFields.isNotEmpty)) {
          tempFilteredList.add(NestedFieldsModel(
            id: education.id,
            name: education.name,
            value: matchingFields,
          ));
        }
      }

      filteredEducationList.value = tempFilteredList;
    }
  }

// Helper method to normalize strings
  String _normalizeString(String input) {
    return input.toLowerCase().replaceAll(RegExp(r'[.\s]+'),
        ''); // Convert to lower case and remove dots and spaces
  }
}
