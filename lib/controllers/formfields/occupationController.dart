import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/models/forms/EducationModel.dart';
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';
import 'package:http/http.dart' as http;

class OccupationController extends GetxController {
  var educationList = <NestedFieldsModel>[].obs;
  var filteredEducationList =
      <NestedFieldsModel>[].obs; // Filtered list for search results

  var selectedOccupations = <FieldModel>[].obs;
  var selectedOccupationsTemp = <FieldModel>[].obs;

  var selectedOccupationsID = <int>[].obs;
  var selectedOccupation = FieldModel().obs;
  var isloading = true.obs;
  void selectAll(List<FieldModel> items) {
    // Add only items that are not already in selectedEducationList
    final itemsToAdd = items.where((item) =>
        !selectedOccupations.any((selectedItem) => selectedItem.id == item.id));

    selectedOccupations.addAll(itemsToAdd);
  }

  // Clear all selected items in a section
  void clearSelection(List<FieldModel> items) {
    selectedOccupations.removeWhere((selectedItem) =>
        items.any((item) => item.id == selectedItem.id)); // Compare by ID
  }

  void toggleOccupationSelection(FieldModel item) {
    print("THIS IS OCC ${item.id}");
    if (selectedOccupations.contains(item)) {
      selectedOccupations.remove(item); // Remove the item if already selected
    } else {
      selectedOccupations.add(item); // Add the item if not selected
    }
  }

  void toggleOccupationSelectionTemp(FieldModel item) {
    print("THIS IS OCC ${item.id}");
    if (selectedOccupationsTemp.contains(item)) {
      selectedOccupationsTemp
          .remove(item); // Remove the item if already selected
    } else {
      selectedOccupationsTemp.add(item); // Add the item if not selected
    }
  }

  Future<void> fetchOccupationFromApi() async {
    String? language = sharedPreferences?.getString("Language");

    try {
      isloading(true);
      final response = await http.get(Uri.parse(
          '${Appconstants.baseURL}/api/fetch/with-group/occupation?lang=$language'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        educationList.value =
            data.map((e) => NestedFieldsModel.fromJson(e)).toList();
        filteredEducationList.value =
            educationList; // Initialize filtered list with original data
      } else {
        print("Error in fetching occupations");
      }
    } finally {
      isloading(false); // Ensure the loading state is reset
    }
  }

  void selectOccupation(FieldModel item) {
    selectedOccupation.value = item; // Set the selected item
    print("Selected occupation: ${item.id}");
  }

  String _normalizeString(String input) {
    return input.toLowerCase().replaceAll(RegExp(r'[.\s]+'),
        ''); // Convert to lower case and remove dots and spaces
  }

  // New method to search for occupations
  void searchOccupation(String query) {
    if (query.isEmpty) {
      filteredEducationList.value =
          educationList; // Reset to show all occupations if query is empty
    } else {
      // Normalize the search query
      String normalizedQuery = _normalizeString(query);

      // Create a temporary filtered list to store matching occupations
      List<NestedFieldsModel> tempFilteredList = [];

      for (var occupation in educationList) {
        // Check if any of the FieldModel's name in the value list matches the normalized search query
        List<FieldModel>? matchingFields = occupation.value?.where((field) {
          return _normalizeString(field.serchkey!).contains(normalizedQuery);
        }).toList();

        // If any field name matches, add the occupation to the filtered list with only the matching fields
        if (matchingFields != null && matchingFields.isNotEmpty) {
          tempFilteredList.add(NestedFieldsModel(
            id: occupation.id,
            name: occupation.name,
            value: matchingFields, // Include only matching fields
          ));
        }
      }

      // Update the filtered list
      filteredEducationList.value = tempFilteredList;
    }
  }
}
