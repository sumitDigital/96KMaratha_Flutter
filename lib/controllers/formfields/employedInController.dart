import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';

class EmplyedInController extends GetxController {
  var employedInList = <FieldModel>[].obs;
  var filteredEmployedInList =
      <FieldModel>[].obs; // New observable list for filtered results
  var selectedOption = FieldModel().obs;
  var isloading = true.obs;

  Future<void> fetchemployeedInFromApi() async {
    String? language = sharedPreferences?.getString("Language");

    try {
      isloading(true);
      // Intentionally short timeout (1 microsecond)
      final response = await http.get(Uri.parse(
          '${Appconstants.baseURL}/api/fetch/employeed_in?lang=$language'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        print("Employed LIsting $data");
        employedInList.value = data.map((e) => FieldModel.fromJson(e)).toList();
        filteredEmployedInList.value =
            employedInList; // Initialize filtered list with original data
      } else {
        print("Error in fetching employed in");
      }
    } catch (e) {
      // Log any other exceptions
      print("An unexpected error occurred: $e");
    } finally {
      isloading(false); // Ensure the loading state is reset
    }
  }

  void selectEmployeedIn(FieldModel item) {
    selectedOption.value = item; // Set the selected item
  }

  // New method to search for employed in options
  void searchEmployedIn(String query) {
    if (query.isEmpty) {
      filteredEmployedInList.value =
          employedInList; // Reset to original if query is empty
    } else {
      filteredEmployedInList.value = employedInList.where((item) {
        // Filter based on name (case insensitive)
        return item.serchkey!.toLowerCase().contains(query.toLowerCase());
      }).toList(); // Update filtered list based on search query
    }
  }
}
