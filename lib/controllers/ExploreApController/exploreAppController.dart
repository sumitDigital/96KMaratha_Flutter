import 'dart:convert';

import 'package:get/get.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:http/http.dart' as http;
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/main.dart';

class ExploreAppController extends GetxController {
  String? token = sharedPreferences?.getString("token");
  var declinedLocalMembers = <int>{}.obs;
  var selectGenderInt = 0.obs;
  var listLimit = 0.obs;
  var isSubmited = false.obs;
  // Fetching After Login
  var recommendedmatchesListfetching = true.obs;
  var recommendedpage = 1.obs;

  String? language = sharedPreferences!.getString("Language");

  var recommendedmatchesList = [].obs;
  var matchesByReccomendationhasMore = true.obs;
  // Fetching Before Login
  var exploreMatchesListfetching = true.obs;
  var exploreMacthesPage = 1.obs;

  var exploreMatchesList = [].obs;
  var exploreMacthesHasMore = true.obs;
  var selectedGender = "".obs;
  void updateOption(String value) {
    selectedGender.value = value;
    int getGenderAsInt() {
      if (selectedGender.value == 'Male') {
        return 2;
      } else if (selectedGender.value == 'Female') {
        return 1;
      } else {
        return 0;
      }
    }

    selectGenderInt.value = getGenderAsInt();
  }

  Future<void> fetchRecommendedMatchesListBeforeLogin() async {
    final LocationController locationController =
        Get.find<LocationController>();
    int? ID = sharedPreferences?.getInt("UnregisteredID");
    print("THIS IS ID $ID");
    try {
      exploreMatchesListfetching(true); // Start loading

      final response = await http.post(
          Uri.parse(
              '${Appconstants.baseURL}/api/home/member-list/not-registered?lang=$language&page=${exploreMacthesPage.value}'),
          // https://digitalmarketingstudiogenix.com/96kmigration/web/api/home/member-list/not-registered?lang=mr
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "gender": selectGenderInt.value.toString(),
            // "state": _locationController.presentselectedState.value.id,
            "city": locationController.presentselectedCity.value.id,
            "UnregisteredID": ID,
          }));

      print(
          "This is responseisthe ${locationController.presentselectedCity.value.id}");

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        List<dynamic> responsebodyList = responseBody["data"]?["data"] ?? [];
        print("This is response request ${response.request}");
        print("This is response body ${response.headers}");
        print(
            "THis is length of Actual List fetched ${response.body} and List int ${exploreMatchesList.length}");
        print(
            "THISIS IS LENGTH OF LIST ${listLimit.value} and response list ${responsebodyList.length}");
        if (responsebodyList.isNotEmpty) {
          for (var element in responsebodyList) {
            // Check if the element already exists and if the list size is within the limit
            if (!exploreMatchesList.any((existing) =>
                    existing['member_id'] == element['member_id']) &&
                exploreMatchesList.length < listLimit.value) {
              exploreMatchesList.add(element);
            }
          }

          exploreMacthesPage.value++; // Increment page for the next API call
        }

        // If fewer than the limit (10 here) are fetched, set no more data
        if (responsebodyList.length < 10 ||
            exploreMatchesList.length >= listLimit.value) {
          print("INSIDE LIST LENGTH ${exploreMatchesList.length}");
          exploreMacthesHasMore.value = false;
          update(['no_more_data_for_reccomendation']);
        }
      } else {
        // Handle errors if response is not 200
        print("Failed to fetch data. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      // Handle exceptions
      print("Error fetching recommended matches: $e");
    } finally {
      exploreMatchesListfetching(false); // Stop loading
    }
  }

  Future<void> fetchRecommendedMatchesListAfterLogin() async {
    int? ID = sharedPreferences?.getInt("UnregisteredID");
    print("THIS IS ID $ID");
    try {
      recommendedmatchesListfetching(true); // Start loading
      final response = await http.post(
        //https://jainmatrimonybureau.com/jain_demo/api/member/expor-recommended
        Uri.parse(
            '${Appconstants.baseURL}/api/member/expor-recommended?page=${recommendedpage.value}&lang=$language'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        print("this is my response");
        var responseBody = jsonDecode(response.body);
        print("Thois is  intrest list1 Reponse success $responseBody");
        print("fetching data again list success");

        // Handle data from response
        List<dynamic> responsebodyList = responseBody["data"]?["data"] ?? [];

        if (responsebodyList.isNotEmpty) {
          print("Inside isnot empty ");
          //  recommendedmatchesList .addAll(responsebodyList); // Add new items to the list
          for (var element in responsebodyList) {
            if (!recommendedmatchesList.any(
                (existing) => existing['member_id'] == element['member_id'])) {
              recommendedmatchesList.add(element);
            }
          }
          recommendedpage.value++; // Increment page for next API call
        }
        if (responsebodyList.length < 10) {
          print("Inside less than 20");
          matchesByReccomendationhasMore.value = false;
          update(['no_more_data_for_reccomendation']);
        }
        print("PAGE NUMBER IS THIS FOR RECOMENDED ${recommendedpage.value}");
        // print("This is data ${usersList[0]["name"]}");
      } else {
        // Handle errors
        //Get.snackbar("Error", "Failed to fetch users");
      }
    } catch (e) {
      // Handle exceptions
      //Get.snackbar("Error", "Something went wrong");
    } finally {
      recommendedmatchesListfetching(false); // Stop loading
    }
  }

  Future<void> fetchNotRegisteredList() async {
    try {
      // URL of the API
      String url = "${Appconstants.baseURL}/api/count/not-registered/list";

      // Sending GET request
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print("API call success ${response.body}");
      // Check for a successful response
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        // Process the data as needed
        listLimit.value = responseBody["not_registered"];

        // Update your application state or variables here
        // Example: notRegisteredListController.updateList(notRegisteredList);
      } else {
        print("Failed to fetch data. Status code: ${response.statusCode}");
        // Handle errors or unsuccessful responses
      }
    } catch (e) {
      print("Error occurred while fetching not registered list: $e");
      // Handle exceptions like network issues
    }
  }

  bool hasdeclined(int memberID) {
    print("this is resp for check");
    return declinedLocalMembers.contains(memberID);
  }
}
