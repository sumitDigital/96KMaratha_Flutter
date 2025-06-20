import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/models/forms/CityModel.dart';
import 'package:_96kuliapp/models/forms/CountryModel.dart';
import 'package:_96kuliapp/models/forms/StateModel.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:_96kuliapp/models/forms/cityfkmodel.dart';
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';
import 'package:_96kuliapp/models/forms/statefkmodel.dart';
import 'package:_96kuliapp/models/location/multicitymodel.dart';
import 'package:_96kuliapp/models/location/multiselectmodel.dart';
import 'package:_96kuliapp/models/location/multiselectmodelcity.dart';
import 'package:_96kuliapp/models/location/multistatemodel.dart';

class LocationController extends GetxController {
  var countries = <CountryModel>[].obs;
  var places = <CountryModel>[].obs;
  final TextEditingController birthplacesearchController =
      TextEditingController(); // Controller for search text
  // String? language = sharedPreferences?.getString("Language");
  var states = <StateModel>[].obs;
  var cities = <CityModel>[].obs;
  var countriesLoading = true.obs;
  var stateLoading = true.obs;
  var cityLoading = true.obs;
  final RxString selectedCity = ''.obs; // Observable to track the selected city
  final RxString selectedState =
      ''.obs; // Observable to track the selected state
  var selectedPlace = FieldModel().obs;

  // Observable to track the selected country
  RxInt countryID = 0.obs;
  RxInt stateID = 0.obs;
  RxInt cityID = 0.obs;
  final RxString PertnerCountryID = ''.obs;
  var presentselectedCity =
      CityModel().obs; // Observable to track the selected city
  var presentselectedState =
      StateModel().obs; // Observable to track the selected state
  var presentselectedCountry =
      CountryModel().obs; // Observable to track the selected country
  RxInt presentstateID = 0.obs;
  RxInt presentcityID = 0.obs;

  var permanentSelectedCity =
      CityModel().obs; // Observable to track the selected city
  var permanentSelectedState =
      StateModel().obs; // Observable to track the selected state
  var permanentSelectedCountry =
      CountryModel().obs; // Observable to track the selected country
  RxInt permanentCountryID = 0.obs;
  RxInt permanentStateID = 0.obs;
  RxInt permanentCityID = 0.obs;

  final RxString partnerSelectedCity =
      ''.obs; // Observable to track the selected city
  final RxString partnerSelectedState =
      ''.obs; // Observable to track the selected state
  final RxString partnerSelectedCountry =
      ''.obs; // Observable to track the selected country
  RxInt partnerCountryID = 0.obs;
  var presentCountryID = ''.obs;

  RxInt partnerStateID = 0.obs;
  RxInt partnerCityID = 0.obs;

  var multistates = <MultiStateModel>[].obs;
  var multiCities = <MultiCityModel>[].obs;

  Future<void> fetchCountries() async {
    countriesLoading.value = true;
    String? language = sharedPreferences?.getString("Language");
    try {
      final response = await http.get(Uri.parse(
          '${Appconstants.baseURL}/api/fetch/country?lang=$language'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        countries.value = data.map((e) => CountryModel.fromJson(e)).toList();
        print("Response is this Country ${response.body}");
      } else {
        print("Error in country");
      }
    } catch (e) {
      rethrow; // Pass the error up to fetchData
    } finally {
      countriesLoading.value = false;
    }
  }

  Future<void> fetchState(String id) async {
    stateLoading.value = true;
    String? language = sharedPreferences?.getString("Language");
    try {
      final response = await http.get(Uri.parse(
          '${Appconstants.baseURL}/api/fetch/list/state/$id?lang=$language'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        states.value = data.map((e) => StateModel.fromJson(e)).toList();
        print("Success in State ${response.request}");
        print("Response is this State ${response.body}");
      } else {
        print("Error in State");
      }
    } catch (e) {
      rethrow; // Pass the error up to fetchData
    } finally {
      stateLoading.value = false;
    }
  }

  Future<void> fetchCity(String id) async {
    String? language = sharedPreferences?.getString("Language");
    try {
      cityLoading.value = true;
      final response = await http.get(Uri.parse(
          '${Appconstants.baseURL}/api/fetch/list/city/$id?lang=$language'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        cities.value = data.map((e) => CityModel.fromJson(e)).toList();
      } else {
        print("Error in country");
      }
    } catch (e) {
      rethrow; // Pass the error up to fetchData
    } finally {
      cityLoading.value = false;
    }
  }

  var selectedCities =
      <MultiCityFKModel>[].obs; // List to hold selected city IDs
  var selectedCitiesTemp =
      <MultiCityFKModel>[].obs; // List to hold selected city IDs

  var selectedCountries =
      <CountryModel>[].obs; // List to hold selected city IDs
  var selectedCountriesTemp =
      <CountryModel>[].obs; // List to hold selected city IDs

  var selectedStates = <StatefkModel>[].obs; // List to hold selected city IDs
  var selectedStatesTemp =
      <StatefkModel>[].obs; // List to hold selected city IDs

  RxList<int?> countryids = <int?>[].obs;

  Future<void> fetchMultiState() async {
// countryids.value =  selectedCountries.map((element) => element.id).toList();
    stateLoading.value = true;
    String? language = sharedPreferences?.getString("Language");
    try {
      // Create a map to send in the body
      Map<String, dynamic> body = {
        'value': countryids,
      };
      final response = await http.post(
        Uri.parse(
            '${Appconstants.baseURL}/api/fetch/with-group/state?lang=$language'),
        headers: {
          'Content-Type': 'application/json', // Set the content type to JSON
        },
        body: jsonEncode(body), // Convert the map to JSON
      );

      if (response.statusCode == 200) {
        var responsedata = jsonDecode(response.body);
        print("Response is this $responsedata");

        // Assuming the response data is a list of states
        // Map the response data to MultiSelectModel
        List<MultiStateModel> statess = (responsedata as List)
            .map((item) => MultiStateModel.fromJson(item))
            .toList();

        // Store the list in the observable variable
        multistates.value = statess; // Assign the list to the observable
      } else {
        print("Error in State: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception occurred: $e"); // Print the error for debugging
      rethrow; // Pass the error up to fetchData
    } finally {
      stateLoading.value = false;
    }
  }

  RxList<int?> stateids = <int?>[].obs;

  Future<void> fetchMultiCity() async {
    //stateids.value =  selectedStates.map((element) => element.id).toList();
    String? language = sharedPreferences?.getString("Language");
    cityLoading.value = true;
    try {
      // Create a map to send in the body
      Map<String, dynamic> body = {
        'value': stateids,
      };
      final response = await http.post(
        Uri.parse(
            '${Appconstants.baseURL}/api/fetch/with-group/city?lang=$language'),
        headers: {
          'Content-Type': 'application/json', // Set the content type to JSON
        },
        body: jsonEncode(body), // Convert the map to JSON
      );

      if (response.statusCode == 200) {
        var responsedata = jsonDecode(response.body);
        print("Response is this City $responsedata");
        // Assuming the response data is a list of states
        // Map the response data to MultiSelectModel
        List<MultiCityModel> statess = (responsedata as List)
            .map((item) => MultiCityModel.fromJson(item))
            .toList();
        // Store the list in the observable variable
        multiCities.value = statess; // Assign the list to the observable
      } else {
        print("Error in State: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception occurred: $e"); // Print the error for debugging
      rethrow; // Pass the error up to fetchData
    } finally {
      cityLoading.value = false;
    }
  }

// List to hold selected city names

  // Method to handle city selection
  void toggleCitySelection(MultiCityFKModel city) {
    if (selectedCities.any(
      (element) => element.id == city.id,
    )) {
      selectedCities.remove(city); // Remove if already selected
      // Remove corresponding city name
    } else {
      selectedCities.add(city); // Add if not selected
    }
  }

  void toggleCitySelectionTemp(MultiCityFKModel city) {
    if (selectedCitiesTemp.any(
      (element) => element.id == city.id,
    )) {
      selectedCitiesTemp.remove(city); // Remove if already selected
      // Remove corresponding city name
    } else {
      selectedCitiesTemp.add(city); // Add if not selected
    }
  }

  void toggleCountrySelection(CountryModel country) {
    // Check if the country already exists in the list
    final existingIndex =
        selectedCountries.indexWhere((element) => element.id == country.id);

    if (existingIndex != -1) {
      // If found, remove the country from the list
      selectedCountries.removeAt(existingIndex);

      // Remove related states and cities
      selectedStates.removeWhere((element) => element.foreignKey == country.id);
      selectedCities
          .removeWhere((element) => element.subForeignKey == country.id);
    } else {
      // Find the correct position to insert the country based on the length of its name
      int insertIndex = selectedCountries.indexWhere(
        (element) => (element.name?.length ?? 0) > (country.name?.length ?? 0),
      );

      if (insertIndex == -1) {
        // If no larger name length is found, add to the end
        selectedCountries.add(country);
      } else {
        // Insert at the found index
        selectedCountries.insert(insertIndex, country);
      }

      // Optionally, add related states or cities logic here if needed
    }

    update(); // If you're using GetX, this updates the UI
  }

  void toggleCountrySelectionTemp(CountryModel country) {
    // Check if the country already exists in the list
    final existingIndex =
        selectedCountriesTemp.indexWhere((element) => element.id == country.id);

    if (existingIndex != -1) {
      // If found, remove the country from the list
      selectedCountriesTemp.removeAt(existingIndex);

      // Remove related states and cities
      selectedStates.removeWhere((element) => element.foreignKey == country.id);
      selectedCities
          .removeWhere((element) => element.subForeignKey == country.id);
    } else {
      // Find the correct position to insert the country based on the length of its name
      int insertIndex = selectedCountriesTemp.indexWhere(
        (element) => (element.name?.length ?? 0) > (country.name?.length ?? 0),
      );

      if (insertIndex == -1) {
        // If no larger name length is found, add to the end
        selectedCountriesTemp.add(country);
      } else {
        // Insert at the found index
        selectedCountriesTemp.insert(insertIndex, country);
      }

      // Optionally, add related states or cities logic here if needed
    }

    update(); // If you're using GetX, this updates the UI
  }

  void toggleStateSelection(StatefkModel state) {
    if (selectedStates.any(
      (element) => element.id == state.id,
    )) {
      selectedStates.remove(state); // Remove if already selected
      selectedCities.removeWhere(
        (element) => element.foreignKey == state.id,
      );
      // Remove corresponding city name
    } else {
      selectedStates.add(state); // Add if not selected
    }
  }

  void toggleStateSelectionTemp(StatefkModel state) {
    if (selectedStatesTemp.any(
      (element) => element.id == state.id,
    )) {
      selectedStatesTemp.remove(state); // Remove if already selected
      selectedStatesTemp.removeWhere(
        (element) => element.foreignKey == state.id,
      );
      // Remove corresponding city name
    } else {
      selectedStatesTemp.add(state); // Add if not selected
    }
  }

  Future<void> fetchPlaces() async {
    String? language = sharedPreferences?.getString("Language");
    print("THIS IS LANGUAGE $language");
    countriesLoading.value = true;
    try {
      final response = await http.get(Uri.parse(
          '${Appconstants.baseURL}/api/fetch/birth_cities?lang=$language'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        places.value = data.map((e) => CountryModel.fromJson(e)).toList();
        print("Response is this birthCity ${response.body}");
      } else {
        print("Error in country");
      }
    } catch (e) {
      rethrow; // Pass the error up to fetchData
    } finally {
      countriesLoading.value = false;
    }
  }
}
