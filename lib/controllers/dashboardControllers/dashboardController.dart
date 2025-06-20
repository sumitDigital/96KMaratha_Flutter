import 'dart:convert';

import 'package:_96kuliapp/screens/editProfile_screens/editEducationForm.dart';
import 'package:_96kuliapp/screens/editProfile_screens/editPartnerPrefrance.dart';
import 'package:_96kuliapp/screens/userInfoForms/pendingForms/userinfoIncompleteForm1.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/commons/dialogues/apidialogues/congratulationDialogue.dart';
import 'package:_96kuliapp/commons/dialogues/forceblock.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationBlock.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationBlockController.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationScreen.dart';
import 'package:_96kuliapp/controllers/auth/logoutController.dart';
import 'package:_96kuliapp/controllers/planControllers/premiumPlanController.dart';
import 'package:_96kuliapp/controllers/timer_controller/timer_controller.dart';
import 'package:_96kuliapp/controllers/viewProfileControllers/viewprofileController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:http/http.dart' as http;
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/ProfilePhotoRequestToChange/ProfilePhotoRequestToChangeScreen.dart';
import 'package:_96kuliapp/screens/auth_Screens/loginScreen2.dart';
import 'package:_96kuliapp/screens/plans/upgradeScreen.dart';
import 'package:_96kuliapp/screens/userInfoForms/pendingForms/userinfoIncompleteForm.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepSix.dart';

class DashboardController extends GetxController {
  String? token = sharedPreferences?.getString("token");
  final mybox = Hive.box('myBox');
  var dashboardData = {}.obs;
  var isPageLoading = true.obs;
  var intrestreceivedPage = 1.obs;
  var intrestAcceptedPage = 1.obs;
  var intrestAcceptedbythemPage = 1.obs;
  var intrestSentbyMePage = 1.obs;
  var shortlistedPage = 1.obs;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

// New code

  var allMatchesfetching = true.obs;
  var allMatchespage = 1.obs;
  var allMatchesList = [].obs;
  var allMatchesListhasMore = true.obs;

  var matchesbyeducationListfetching = true.obs;
  var recommendedbyEducationpage = 1.obs;
  var matchesbyEducationList = [].obs;
  var matchesByEducationhasMore = true.obs;

  var matchesbylocationListfetching = true.obs;
  var recommendedbyLocationpage = 1.obs;
  var matchesbyLocationList = [].obs;
  var matchesByLocationhasMore = true.obs;

  var matchesbyOccupationListfetching = true.obs;
  var recommendedbyOccupationpage = 1.obs;
  var matchesbyOccupationList = [].obs;
  var matchesByOccupationhasMore = true.obs;

  var recommendedmatchesListfetching = true.obs;
  var recommendedpage = 1.obs;
  var recommendedmatchesList = [].obs;
  var matchesByReccomendationhasMore = true.obs;

// ExploreProfiles

  var exploreListFetching = true.obs;
  var exploreListPage = 1.obs;
  var exploreListList = [].obs;
  var explorelistHasMore = true.obs;

  // Interest

  var intrestreceivedhasMore = true.obs;
  var intrestReceivedfetching = true.obs;

  var intrestAcceptedhasMore = true.obs;
  var intrestAcceptedfetching = true.obs;

  var intrestAcceptedByThemhasMore = true.obs;
  var intrestAcceptedbythemfetching = true.obs;

  var intrestSentByMehasMore = true.obs;
  var intrestSentbyMefetching = true.obs;

  var shortlistedListfetching = true.obs;
  var shortlistedhasMore = true.obs;

  var contactViewdListfetching = true.obs;
  var contactViewdpage = 1.obs;
  var contactViewdList = [].obs;
  var contactViewdhasMore = true.obs;

  var declinedprofilesListFetching = true.obs;
  var declinedProfilePage = 1.obs;
  var declinedProfilesList = [].obs;
  var declinedProfileshasMore = true.obs;

  var declinedbyThemprofilesListFetching = true.obs;
  var declinedbyThemProfilePage = 1.obs;
  var declinedbyThemProfilesList = [].obs;
  var declinedbyThemProfileshasMore = true.obs;

  var ignoredProfilesListFetching = true.obs;
  var ignoredProfilesPage = 1.obs;
  var ignoredProfilesList = [].obs;
  var ignoredProfileshasMore = true.obs;

  var profilesvisitedByMeListFetching = true.obs;
  var profilesvisitedByMePage = 1.obs;
  var profilesvisitedByMeList = [].obs;
  var profilesvisitedByMehasMore = true.obs;

  var profilesvisitedByThemListFetching = true.obs;
  var profilesvisitedByThemPage = 1.obs;
  var profilesvisitedByThemList = [].obs;
  var profilesvisitedByThemhasMore = true.obs;

  var onlineMembersFetching = true.obs;
  var recommendedmatchesfetching = true.obs;

  var sendInterestLoading = true.obs;

  var expressedInterestMembers = <int>{}.obs;
  var shortlistedLocalMembers = <int>{}.obs;
  var acceptedLocalMembers = <int>{}.obs;
  var declinedLocalMembers = <int>{}.obs;

  var recommendedListEnd = false.obs;
  var matchesByLocationListEnd = false.obs;
  var matchesByOccupationListEnd = false.obs;
  var intrestrecivedListEnd = false.obs;
  var intrestAcceptedListEnd = false.obs;
  var intrestAcceptedbyThemListEnd = false.obs;
  var intrestSentByMeListEnd = false.obs;
  var shortlistedListEnd = false.obs;

  var profileVisitorsFetching = true.obs;
  var recentlyjoinedfetching = true.obs;

  final TimerController timerController = Get.put(TimerController());
  var onlinemembers = [].obs;
  var recommendedmatches = [].obs;
  var intrestreceivedList = [].obs;
  var intrestAcceptedList = [].obs;
  var intrestAcceptedByThemList = [].obs;
  var intrestSentByMeList = [].obs;
  var shortlistedList = [].obs;

  var profilevisitors = [].obs;
  var recentMatches = [].obs;

/*
  @override
  void onInit() {
    super.onInit();
    fetchUserInfo(); // Call the function on initialization
  }*/

  Future<void> fetchOnlineMembers() async {
    String? token = sharedPreferences!.getString("token");
    print("Token is $token");
    String? language = sharedPreferences!.getString("Language");

    try {
      onlineMembersFetching.value = true;
      // Fetch both education and specialization data in parallel
      final response = await http.get(headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      }, Uri.parse('${Appconstants.baseURL}/api/member/online?lang=$language'));

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        var responsebody = responseBody;
        print("Response body for online members ${response.body}");
        print(
            "response body online  is this ${responsebody["data"]["data"] as List}");
        onlinemembers.value = responsebody["data"]["data"] as List;
        var isDocumentVerification =
            responseBody['memberData']['is_Document_Verification'];
        print("Is doc verif $isDocumentVerification");

        if (isDocumentVerification == 0) {
          print("implement");
          timerController.startTimer();
        } else {
          print("Nako no need");
        }
      } else {
        //  //Get.snackbar('Error', 'Failed to load data');
        //  Get.offAllNamed(AppRouteNames.loginScreen2);
      }
    } catch (e) {
      print("Error is this $e");
      //   //Get.snackbar('Error', e.toString());
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onlineMembersFetching.value = false;
      });
    }
  }

  Future<void> fetchRecomendedMatches() async {
    String? token = sharedPreferences!.getString("token");
    print("Token is $token");
    try {
      recommendedmatchesfetching.value = true;

      // Fetch both education and specialization data in parallel
      String? language = sharedPreferences?.getString("Language");

      final response = await http.post(
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $token",
          },
          Uri.parse(
              '${Appconstants.baseURL}/api/member/recommended?lang=$language'));

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        var responsebody = responseBody;

        print(
            "response body online  is this ${responsebody["data"]["data"] as List}");
        recommendedmatches.value = responsebody["data"]["data"] as List;
        var isDocumentVerification =
            responseBody['memberData']['is_Document_Verification'];
        print("Is doc verif $isDocumentVerification");

        if (isDocumentVerification == 0) {
          print("implement");
          timerController.startTimer();
        } else {
          print("Nako no need");
        }
      } else {
        //   //Get.snackbar('Error', 'Failed to load data');
      }
    } catch (e) {
      print("Error is this $e");
      //   //Get.snackbar('Error', e.toString());
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        recommendedmatchesfetching.value = false;
      });
    }
  }

  Future<void> fetchProfileVisitors() async {
    String? token = sharedPreferences!.getString("token");
    print("Token is $token");
    try {
      profileVisitorsFetching.value = true;
      String? language = sharedPreferences!.getString("Language");

      // Fetch both education and specialization data in parallel
      final response = await http.post(
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $token",
          },
          Uri.parse(
              '${Appconstants.baseURL}/api/member/otherviewMe?lang=$language'));

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        var responsebody = responseBody;
        print("Response body for profile visitor is ${response.body}");

        print(
            "response body profile visitor  is this ${responsebody["data"]["data"] as List}");
        profilevisitors.value = responsebody["data"]["data"] as List;
        var isDocumentVerification =
            responseBody['memberData']['is_Document_Verification'];
        print("Image find ${responsebody["data"]["data"][0]["photoUrl"]}");
        print("Is doc verif $isDocumentVerification");

        if (isDocumentVerification == 0) {
          print("implement");
          timerController.startTimer();
        } else {
          print("Nako no need");
        }
      } else {
        //  //Get.snackbar('Error', 'Failed to load data');
      }
    } catch (e) {
      print("Error is this $e");
      //  //Get.snackbar('Error', e.toString());
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        profileVisitorsFetching.value = false;
      });
    }
  }

  void resetAllListsforHome() {
    shortlistedLocalMembers.clear();
    expressedInterestMembers.clear();
  }

  void resetAllListsInterestHome() {
    acceptedLocalMembers.clear();
    declinedLocalMembers.clear();
  }

  Future<void> fetchRecentlyJoinedMatches() async {
    String? token = sharedPreferences!.getString("token");
    print("Token is $token");
    try {
      recentlyjoinedfetching.value = true;
      String? language = sharedPreferences!.getString("Language");

      // Fetch both education and specialization data in parallel

      final response = await http.post(
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        Uri.parse(
          'https://digitalmarketingstudiogenix.com/96kmigration/web/api/member/recentlyjoined?lang=$language',
        ),
      );
      print("Response body is for recent joined  ${response.request?.url}");
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        var responsebody = responseBody;
        print("Response for recent matches ${responseBody.body}");

        print(
            "response body recent matches  is this ${responsebody["data"]["data"] as List}");
        recentMatches.value = responsebody["data"]["data"] as List;
        var isDocumentVerification =
            responseBody['memberData']['is_Document_Verification'];
        print("Is doc verif matches ${recentMatches[0]['photoUrl']}");

        if (isDocumentVerification == 0) {
          print("implement");
          timerController.startTimer();
        } else {
          print("Nako no need");
        }
      } else {
        //    //Get.snackbar('Error', 'Failed to load data');
      }
    } catch (e) {
      print("Error is this $e");
      //   //Get.snackbar('Error', e.toString());
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        recentlyjoinedfetching.value = false;
      });
    }
  }

  final CasteVerificationBlockController _casteVerificationBlockController =
      Get.put(CasteVerificationBlockController());
  final LogoutController _logoutController = Get.put(LogoutController());

  Future<void> fetchUserInfo() async {
    print("INSIDE FETCH INFO AGAIN");
    String? token = sharedPreferences!.getString("token");
    print("Token is $token");
    try {
      isPageLoading(true);
      String? language = sharedPreferences!.getString("Language");

      // Fetch both education and specialization data in parallel

      final response = await http.get(headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      }, Uri.parse('${Appconstants.baseURL}/api/dashboard?lang=$language'));

      print("response body for member  dashboard ${response.body}");
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        dashboardData.value = responseBody;
        print("THIS IS {RONT ${dashboardData["redirection"]["pagename"]}}");
        mybox.put("gender", dashboardData["memberData"]["gender"]);

        var isDocumentVerification =
            responseBody['memberData']['is_Document_Verification'];
        //   print("Is doc verif ${dashboardData["photo"][0]['photo_name'] }");
        // timerController.startTimer();

        if (isDocumentVerification != 1) {
          if (dashboardData["redirection"]["pagename"] == "FORCEPOPUP") {
            timerController.cancelTimer();
          } else if (dashboardData["redirection"]["pagename"] == "PENDING") {
            timerController.cancelTimer();
          } else if (dashboardData["redirection"]["pagename"] ==
              "CASTE-VERIFICATION") {
            timerController.cancelTimer();
          } else if (dashboardData["redirection"]["pagename"] ==
              "DOCUMENT-REJECTED") {
            timerController.cancelTimer();
          } else if (dashboardData["redirection"]["pagename"] == "PLAN") {
            timerController.cancelTimer();
          } else if (dashboardData["redirection"]["pagename"] ==
              "UPDATE-PHOTO") {
            timerController.cancelTimer();
          } else if (dashboardData["redirection"]["pagename"] ==
              "INCOMPLETEFORM") {
            timerController.cancelTimer();
          } else {
            print("implement timer for doc parat deep ");
            timerController.startTimer();
          }
        } else {
          print("Nako no need");
        }
/*
print(" already reg ${dashboardData["memberData"]["user_register"]}");
if(dashboardData["memberData"]["user_register"] == 1){
    Future.delayed(const Duration(milliseconds: 500), () {
    Get.dialog(const Congratulationdialogue(), barrierDismissible: false);
  });
}*/

        // mybox.put("gender", data["data"]["gender"] );
        sharedPreferences!.setString("Full Name",
            "${dashboardData["memberData"]["first_name"]} ${dashboardData["memberData"]["middle_name"]} ${dashboardData["memberData"]["last_name"]} ");

        if (dashboardData["redirection"]["pagename"] == "FORCEPOPUP") {
          Get.dialog(
              barrierColor: Colors.black.withOpacity(
                  0.6), // A lighter black color (using a hex value)

              const ForceBlockDialogue(),
              barrierDismissible: false);
        } else if (dashboardData["redirection"]["pagename"] == "PENDING") {
          _casteVerificationBlockController.popup.value =
              dashboardData["redirection"]["Popup"];
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const CasteVerificationBlock(),
              ),
              (route) => false,
            );
          });
        } else if (dashboardData["redirection"]["pagename"] ==
            "CASTE-VERIFICATION") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const CasteVerificationScreen(),
              ),
              (route) => false,
            );
          });
        } else if (dashboardData["redirection"]["pagename"] ==
            "INCOMPLETEFORM") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const userIncomplete_userForm(),
              ),
              (route) => false,
            );
          });
        } else if (dashboardData["redirection"]["pagename"] == "EDIT-PARTNER") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const userIncomplete_userFormOne(),
              ),
              (route) => false,
            );
          });
        }
        /* else if (dashboardData["redirection"]["pagename"] ==
            "EDIT-EDUCATION-CAREER") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => EditEducationForm(
                  key: UniqueKey(),
                ),
              ),
              (route) => false,
            );
          });
        } else if (dashboardData["redirection"]["pagename"] == "EDIT-PARTNER") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => EditPartnerPrefrances(
                  key: UniqueKey(),
                ),
              ),
              (route) => false,
            );
          });
        }  */
        else if (dashboardData["redirection"]["pagename"] ==
            "DOCUMENT-REJECTED") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const UserInfoStepSix(),
              ),
              (route) => false,
            );
          });
        } else if (dashboardData["redirection"]["pagename"] == "PLAN") {
          sharedPreferences!.setString("PageIndex", "9");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const UpgradePlan(),
              ),
              (route) => false,
            );
          });
        } else if (dashboardData["redirection"]["pagename"] == "UPDATE-PHOTO") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const ProfilePhotoRequestToChangeScreen(),
              ),
              (route) => false,
            );
          });
        }
      } else if (response.statusCode == 404) {
      } else if (response.statusCode == 401) {
        _logoutController.logout().then((value) async {
          await sharedPreferences?.clear();
          Get.deleteAll();
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              maintainState: false,
              builder: (context) => const LoginScreen2(),
            ),
            (route) => false,
          );
        });
      } else {
        //   //Get.snackbar('Error', 'Failed to load data');
      }
    } catch (e) {
      print("Error is this $e");
    } finally {
      // isPageLoading(false);
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      isPageLoading(false);
      // });
    }
  }

  Future<void> fetchmatchesByEducation() async {
    try {
      String? language = sharedPreferences!.getString("Language");

      matchesbyeducationListfetching(true); // Start loading
      print("All matches page ${recommendedbyEducationpage.value}");
      final response = await http.post(
        Uri.parse(
            '${Appconstants.baseURL}/api/member/byeducation?page=${recommendedbyEducationpage.value}&lang=$language'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        print("this is my response");
        var responseBody = jsonDecode(response.body);
        print("Thois is  intrest list1 Reponse success");
        print("fetching data again list success");

        // Handle data from response
        List<dynamic> responsebodyList = responseBody["data"]?["data"] ?? [];

        if (responsebodyList.isNotEmpty) {
          //  matchesbyEducationList .addAll(responsebodyList);
          for (var element in responsebodyList) {
            if (!matchesbyEducationList.any(
                (existing) => existing['member_id'] == element['member_id'])) {
              matchesbyEducationList.add(element);
            }
          }
          recommendedbyEducationpage.value++;
        }
        if (responsebodyList.length < 10) {
          print("Inside less than 20");
          matchesByEducationhasMore.value = false;
          update(['no_more_data_for_education']);
        }

        // print("This is data ${usersList[0]["name"]}");
      } else {
        // Handle errors
        //  //Get.snackbar("Error", "Failed to fetch users");
      }
    } catch (e) {
      // Handle exceptions
      //  //Get.snackbar("Error", "Something went wrong");
    } finally {
      matchesbyeducationListfetching(false); // Stop loading
    }
  }

  Future<void> fetchRecommendedMatchesListForExplore() async {
    final PremiumPlanController premiumPlanController =
        Get.find<PremiumPlanController>();
    String? language = sharedPreferences!.getString("Language");

    try {
      exploreListFetching(true); // Start loading
      final response = await http.post(
        Uri.parse(
            '${Appconstants.baseURL}/api/member/expor-recommended?page=${exploreListPage.value}&lang=$language'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        print("Response body $responseBody");
        List<dynamic> responsebodyList = responseBody["data"]["data"] ?? [];
        print("Body of response for explore: $responsebodyList");
        if (responsebodyList.isNotEmpty) {
          for (var element in responsebodyList) {
            if (!exploreListList.any((existing) =>
                    existing['member_id'] ==
                    element[
                        'member_id']) /* &&
                exploreListList.length <
                    _premiumPlanController.exploreLength.value */
                ) {
              exploreListList.add(element);
            }
            print("Cehck11 $exploreListList");
          }
          exploreListPage.value++; // Increment page for next API call
        }

        if (responsebodyList.length < 10 ||
            exploreListList.length >=
                premiumPlanController.exploreLength.value) {
          explorelistHasMore.value = false;
          update(['no_more_data_for_reccomendation']);
        }
        print("Cehck2");
      }
    } catch (e) {
      print("Error fetching recommended matches for explore: $e");
      // Handle exceptions
    } finally {
      exploreListFetching(false); // Stop loading
    }
  }

  Future<void> fetchRecommendedMatchesList() async {
    try {
      String? language = sharedPreferences!.getString("Language");

      recommendedmatchesListfetching(true); // Start loading
      print("All matches page ${recommendedbyEducationpage.value}");
      final response = await http.post(
        Uri.parse(
            '${Appconstants.baseURL}/api/member/recommended?page=${recommendedpage.value}&lang=$language'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        print("this is my response ${response.body}");
        var responseBody = jsonDecode(response.body);
        print("Thois is  intrest list1 Reponse success $language");
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
        print("THIS IS LENGTH recom ${responsebodyList.length}");
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

/*
Future<void> fetchmatchesByEducation() async{

    try {
    matchesbyeducationListfetching(true); // Start loading
print("All matches page ${recommendedbyEducationpage.value}");
   final response = await http.post(
      Uri.parse('${Appconstants.baseURL}/api/member/byeducation?page=${recommendedbyEducationpage.value}'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      print("this is my response");
       var responseBody = jsonDecode(response.body);
print("Thois is  intrest list1 Reponse success");
    print("fetching data again list success");

      // Handle data from response
      List<dynamic> responsebodyList = responseBody["data"]?["data"] ?? [];

      if (responsebodyList.isNotEmpty) {
       matchesbyEducationList .addAll(responsebodyList); // Add new items to the list
        recommendedbyEducationpage .value++; // Increment page for next API call
      }
      if(allMatchesList.length < 10){
        print("Inside less than 20");
matchesByEducationhasMore.value = false;
 update(['no_more_data_for_education']);
      }

 // print("This is data ${usersList[0]["name"]}");
    } else {
      // Handle errors
      //Get.snackbar("Error", "Failed to fetch users");
    }
  } catch (e) {
    // Handle exceptions
    //Get.snackbar("Error", "Something went wrong");
  } finally {
    matchesbyeducationListfetching(false); // Stop loading
  }
}*/

  Future<void> fetchMatchesbyLocationList() async {
    String? language = sharedPreferences!.getString("Language");

    try {
      matchesbylocationListfetching(true); // Start loading
      print("All matches page ${recommendedbyEducationpage.value}");
      final response = await http.post(
        Uri.parse(
            '${Appconstants.baseURL}/api/member/bylocation?page=${recommendedbyLocationpage.value}&lang=$language'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        print("this is my response");
        var responseBody = jsonDecode(response.body);
        print("Thois is  intrest list1 Reponse success");
        print("fetching data again list success");

        // Handle data from response
        List<dynamic> responsebodyList = responseBody["data"]?["data"] ?? [];

        if (responsebodyList.isNotEmpty) {
          //  matchesbyLocationList .addAll(responsebodyList); // Add new items to the list
          for (var element in responsebodyList) {
            if (!matchesbyLocationList.any(
                (existing) => existing['member_id'] == element['member_id'])) {
              matchesbyLocationList.add(element);
            }
          }
          recommendedbyLocationpage.value++; // Increment page for next API call
        }
        if (responsebodyList.length < 10) {
          print("Inside less than 20");
          matchesByLocationhasMore.value = false;
          update(['no_more_data_for_Location']);
        }

        // print("This is data ${usersList[0]["name"]}");
      } else {
        // Handle errors
        //Get.snackbar("Error", "Failed to fetch users");
      }
    } catch (e) {
      // Handle exceptions
      //Get.snackbar("Error", "Something went wrong");
    } finally {
      matchesbylocationListfetching(false); // Stop loading
    }
  }

  Future<void> fetchMatchesbyOccupationList() async {
    try {
      String? language = sharedPreferences!.getString("Language");

      matchesbyOccupationListfetching(true); // Start loading
      print("All matches page ${recommendedbyEducationpage.value}");
      final response = await http.post(
        Uri.parse(
            '${Appconstants.baseURL}/api/member/byoccupation?page=${recommendedbyOccupationpage.value}&lang=$language'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        print("this is my response");
        var responseBody = jsonDecode(response.body);
        print("Thois is  intrest list1 Reponse success");
        print("fetching data again list success");

        // Handle data from response
        List<dynamic> responsebodyList = responseBody["data"]?["data"] ?? [];

        if (responsebodyList.isNotEmpty) {
          //  matchesbyOccupationList .addAll(responsebodyList); // Add new items to the list
          for (var element in responsebodyList) {
            if (!matchesbyOccupationList.any(
                (existing) => existing['member_id'] == element['member_id'])) {
              matchesbyOccupationList.add(element);
            }
          }
          recommendedbyOccupationpage
              .value++; // Increment page for next API call
        }
        if (responsebodyList.length < 10) {
          print("Inside less than 20");
          matchesByOccupationhasMore.value = false;
          update(['no_more_data_for_Occupation']);
        }

        // print("This is data ${usersList[0]["name"]}");
      } else {
        // Handle errors
        //Get.snackbar("Error", "Failed to fetch users");
      }
    } catch (e) {
      // Handle exceptions
      //Get.snackbar("Error", "Something went wrong");
    } finally {
      matchesbyOccupationListfetching(false); // Stop loading
    }
  }

  Future<void> fetchAllMatchesBYINT(int i) async {
    try {
      String? language = sharedPreferences!.getString("Language");

      allMatchesfetching(true); // Start loading
      print("All matches page ${allMatchespage.value}");
      final response = await http.post(
        Uri.parse(
            '${Appconstants.baseURL}/api/member/allmember?page=${allMatchespage.value}&lang=$language'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        print("this is my response");
        var responseBody = jsonDecode(response.body);
        print("Thois is  intrest list1 Reponse success ==== $i");
        //  print("fetching data again list success");

        // Handle data from response
        List<dynamic> responsebodyList = responseBody["data"]?["data"] ?? [];

        if (responsebodyList.isNotEmpty) {
          allMatchesList.addAll(responsebodyList); // Add new items to the list
          allMatchespage.value++; // Increment page for next API call
        }
        if (responsebodyList.length < 10) {
          print("Inside less than 20");
          allMatchesListhasMore.value = false;
          update(['no_more_data_BY_INT']);
        }

        // print("This is data ${usersList[0]["name"]}");
      } else {
        print("Errorrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
        // Handle errors
        //Get.snackbar("Error", "Failed to fetch users");
      }
    } catch (e) {
      // Handle exceptions
      //Get.snackbar("Error", "Something went wrong");
    } finally {
      allMatchesfetching(false); // Stop loading
    }
  }

  Future<void> fetchAllMatches() async {
    try {
      String? language = sharedPreferences!.getString("Language");

      allMatchesfetching(true); // Start loading
      print("All matches page ${allMatchespage.value}");
      final response = await http.post(
        Uri.parse(
            '${Appconstants.baseURL}/api/member/allmember?page=${allMatchespage.value}&lang=$language'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        print("this is my response");
        var responseBody = jsonDecode(response.body);
        print("Thois is  intrest list1 Reponse success");
        //  print("fetching data again list success");

        // Handle data from response
        List<dynamic> responsebodyList = responseBody["data"]?["data"] ?? [];
        print(
            "THIS is my all matches LIST data ${allMatchespage.value} ${responsebodyList.length}");
        if (responsebodyList.isNotEmpty) {
          print("ALL Matches List ${responsebodyList.length}");
          for (var element in responsebodyList) {
            if (!allMatchesList.any(
                (existing) => existing['member_id'] == element['member_id'])) {
              allMatchesList.add(element);
            }
          }
          allMatchespage.value++; // Increment page for next API call
        }
        if (responsebodyList.length < 10) {
          print("Inside less than 10");
          allMatchesListhasMore.value = false;
          update(['no_more_data']);
        }
        print("All matches List has length ${allMatchesList.length}");
        print("All matches List page ${allMatchespage.value}");

        // print("This is data ${usersList[0]["name"]}");
      } else {
        print("Errrrrrrrrrrrrrrrrrrrrrrrrr");
        // Handle errors
        //Get.snackbar("Error", "Failed to fetch users");
      }
    } catch (e) {
      // Handle exceptions
      //Get.snackbar("Error", "Something went wrong");
    } finally {
      allMatchesfetching(false); // Stop loading
    }
  }

/*
Future<void> fetchAllMatches() async {
  print("all matches received");
  String? token = sharedPreferences?.getString("token");
  if (token == null) {
    //Get.snackbar('Error', 'No authentication token found');
    return;
  }

  // Prevent multiple fetches at the same time
  if (allMatchesListfetching.value) return;

  try {
    print("fetching data again");
    allMatchesListfetching.value = true;

    final response = await http.post(
      Uri.parse('${Appconstants.baseURL}/api/member/allmember?limit=5?page=${allMatchespage.value}'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );
    print("fetching data again list");

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
print("Thois is  intrest list1 Reponse success");
    print("fetching data again list success");

      // Handle data from response
      List<dynamic> responsebodyList = responseBody["data"]?["data"] ?? [];
      
      if (responsebodyList.isNotEmpty) {
print("Thois is  intrest list1 is not empty ");
    print("fetching data again list empty");


        allMatchespage.value++;  // Increment page if there's more data
        allMatchesList.addAll(responsebodyList); // Add new items to the list

        // Check if we've reached the end of the list
        if (responsebodyList.length < 2) {
          allMatchesListEnd.value = true;  // Mark end of list if fewer than 10 items
        }
      } else {
print("Thois is  intrest list1 is empty");

        allMatchesListEnd.value = true;  // No more data
      //  //Get.snackbar('Info', 'No more data available.');
      }

      print("Intrest received list values in ${allMatchesListEnd.value}");
    } else {
      //Get.snackbar('Error', 'Failed to load data: ${response.statusCode}');
    }
  } catch (e) {
    //Get.snackbar('Error', e.toString());
  } finally {
  
  }
}*/

  Future<void> fetchIntrestReceivedList() async {
    try {
      String? language = sharedPreferences!.getString("Language");

      intrestReceivedfetching(true); // Start loading
      print("All matches page ${recommendedbyEducationpage.value}");
      final response = await http.post(
        Uri.parse(
            '${Appconstants.baseURL}/api/member/received?page=${intrestreceivedPage.value}&lang=$language'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      print("INterest madhi list ${response.body}");

      if (response.statusCode == 200) {
        print("this is my response");
        var responseBody = jsonDecode(response.body);
        print("Thois is  intrest list1 Reponse success");
        print("fetching data again list success");

        // Handle data from response
        List<dynamic> responsebodyList = responseBody["data"]?["data"] ?? [];

        if (responsebodyList.isNotEmpty) {
          //  intrestreceivedList .addAll(responsebodyList);
          for (var element in responsebodyList) {
            if (!intrestreceivedList.any(
                (existing) => existing['member_id'] == element['member_id'])) {
              intrestreceivedList.add(element);
            }
          }
          intrestreceivedPage.value++;
        }
        if (responsebodyList.length < 10) {
          print("Inside less than 10");
          intrestreceivedhasMore.value = false;
          update(['no_more_data_for_Intrest_received']);
        }

        // print("This is data ${usersList[0]["name"]}");
      } else {
        // Handle errors
        //Get.snackbar("Error", "Failed to fetch users");
      }
    } catch (e) {
      // Handle exceptions
      //Get.snackbar("Error", "Something went wrong");
    } finally {
      intrestReceivedfetching(false); // Stop loading
    }
  }

  Future<void> fetchIntrestAcceptedList() async {
    try {
      String? language = sharedPreferences!.getString("Language");

      intrestAcceptedfetching(true); // Start loading
      print("All matches page ${recommendedbyEducationpage.value}");
      final response = await http.post(
        Uri.parse(
            '${Appconstants.baseURL}/api/member/accepted?page=${intrestAcceptedPage.value}&lang=$language'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      print("INterest madhi list accept ${response.body}");

      if (response.statusCode == 200) {
        print("this is my response");
        var responseBody = jsonDecode(response.body);
        print("Thois is  intrest list1 Reponse success $responseBody");
        print("fetching data again list success");

        // Handle data from response
        List<dynamic> responsebodyList = responseBody["data"]?["data"] ?? [];

        if (responsebodyList.isNotEmpty) {
          //   intrestAcceptedList .addAll(responsebodyList);
          for (var element in responsebodyList) {
            if (!intrestAcceptedList.any(
                (existing) => existing['member_id'] == element['member_id'])) {
              intrestAcceptedList.add(element);
            }
          }
          intrestAcceptedPage.value++;
        }
        if (responsebodyList.length < 10) {
          print("Inside less than 10");
          intrestAcceptedhasMore.value = false;
          update(['no_more_data_for_Intrest_accepted']);
        }

        // print("This is data ${usersList[0]["name"]}");
      } else {
        // Handle errors
        //Get.snackbar("Error", "Failed to fetch users");
      }
    } catch (e) {
      // Handle exceptions
      //Get.snackbar("Error", "Something went wrong");
    } finally {
      intrestAcceptedfetching(false); // Stop loading
    }
  }

  Future<void> fetchIntrestAcceptedbyThemList() async {
    try {
      String? language = sharedPreferences!.getString("Language");

      intrestAcceptedbythemfetching(true); // Start loading
      print("All matches page ${recommendedbyEducationpage.value}");
      final response = await http.post(
        Uri.parse(
            '${Appconstants.baseURL}/api/member/getAccepted?page=${intrestAcceptedbythemPage.value}&lang=$language'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      print("INterest madhi list ${response.body}");

      if (response.statusCode == 200) {
        print("this is my response");
        var responseBody = jsonDecode(response.body);
        print("Thois is  intrest list1 Reponse success");
        print("fetching data again list success");

        // Handle data from response
        List<dynamic> responsebodyList = responseBody["data"]?["data"] ?? [];

        if (responsebodyList.isNotEmpty) {
          //    intrestAcceptedByThemList .addAll(responsebodyList);
          for (var element in responsebodyList) {
            if (!intrestAcceptedByThemList.any(
                (existing) => existing['member_id'] == element['member_id'])) {
              intrestAcceptedByThemList.add(element);
            }
          }
          intrestAcceptedbythemPage.value++;
        }
        if (responsebodyList.length < 10) {
          print("Inside less than 10");
          intrestAcceptedByThemhasMore.value = false;
          update(['no_more_data_for_Intrest_accepted_ByThem']);
        }

        // print("This is data ${usersList[0]["name"]}");
      } else {
        // Handle errors
        //Get.snackbar("Error", "Failed to fetch users");
      }
    } catch (e) {
      // Handle exceptions
      //Get.snackbar("Error", "Something went wrong");
    } finally {
      intrestAcceptedbythemfetching(false); // Stop loading
    }
  }

  Future<void> fetchIntrestSentByMeList() async {
    try {
      String? language = sharedPreferences!.getString("Language");

      intrestSentbyMefetching(true); // Start loading
      print("All matches page ${recommendedbyEducationpage.value}");
      final response = await http.post(
        Uri.parse(
            '${Appconstants.baseURL}/api/member/sendinterest?page=${intrestSentbyMePage.value}&lang=$language'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      print("INterest madhi list ${response.body}");

      if (response.statusCode == 200) {
        print("this is my response");
        var responseBody = jsonDecode(response.body);
        print("Thois is  intrest list1 Reponse success");
        print("fetching data again list success");

        // Handle data from response
        List<dynamic> responsebodyList = responseBody["data"]?["data"] ?? [];

        if (responsebodyList.isNotEmpty) {
          //   intrestSentByMeList .addAll(responsebodyList);
          for (var element in responsebodyList) {
            if (!intrestSentByMeList.any(
                (existing) => existing['member_id'] == element['member_id'])) {
              intrestSentByMeList.add(element);
            }
          }
          intrestSentbyMePage.value++;
        }
        if (responsebodyList.length < 10) {
          print("Inside less than 10");
          intrestSentByMehasMore.value = false;
          update(['no_more_data_for_Intrest_accepted_ByMe']);
        }

        // print("This is data ${usersList[0]["name"]}");
      } else {
        // Handle errors
        //Get.snackbar("Error", "Failed to fetch users");
      }
    } catch (e) {
      // Handle exceptions
      //Get.snackbar("Error", "Something went wrong");
    } finally {
      intrestSentbyMefetching(false); // Stop loading
    }
  }

  Future<void> fetchShortlistedList() async {
    try {
      String? language = sharedPreferences!.getString("Language");

      shortlistedListfetching(true); // Start loading
      print("All matches page ${recommendedbyEducationpage.value}");
      final response = await http.post(
        Uri.parse(
            '${Appconstants.baseURL}/api/member/shortlist?page=${shortlistedPage.value}&lang=$language'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      print("INterest madhi list ${response.body}");

      if (response.statusCode == 200) {
        print("this is my response");
        var responseBody = jsonDecode(response.body);
        print("Thois is  intrest list1 Reponse success");
        print("fetching data again list success");

        // Handle data from response
        List<dynamic> responsebodyList = responseBody["data"]?["data"] ?? [];

        if (responsebodyList.isNotEmpty) {
          //    shortlistedList .addAll(responsebodyList);
          for (var element in responsebodyList) {
            if (!shortlistedList.any(
                (existing) => existing['member_id'] == element['member_id'])) {
              shortlistedList.add(element);
            }
          }
          shortlistedPage.value++;
        }
        if (responsebodyList.length < 10) {
          print("Inside less than 10");
          shortlistedhasMore.value = false;
          update(['no_more_data_for_shortlisted']);
        }

        // print("This is data ${usersList[0]["name"]}");
      } else {
        // Handle errors
        //Get.snackbar("Error", "Failed to fetch users");
      }
    } catch (e) {
      // Handle exceptions
      //Get.snackbar("Error", "Something went wrong");
    } finally {
      shortlistedListfetching(false); // Stop loading
    }
  }

  Future<void> fetchContactViewdList() async {
    try {
      String? language = sharedPreferences!.getString("Language");

      contactViewdListfetching(true); // Start loading
      print("All matches page ${recommendedbyEducationpage.value}");
      final response = await http.post(
        Uri.parse(
            '${Appconstants.baseURL}/api/member/contactview?page=${contactViewdpage.value}&lang=$language'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      print("INterest madhi list ${response.body}");

      if (response.statusCode == 200) {
        print("this is my response");
        var responseBody = jsonDecode(response.body);
        print("Thois is  intrest list1 Reponse success");
        print("fetching data again list success");

        // Handle data from response
        List<dynamic> responsebodyList = responseBody["data"]?["data"] ?? [];

        if (responsebodyList.isNotEmpty) {
          //   contactViewdList .addAll(responsebodyList);
          for (var element in responsebodyList) {
            if (!contactViewdList.any(
                (existing) => existing['member_id'] == element['member_id'])) {
              contactViewdList.add(element);
            }
          }
          contactViewdpage.value++;
        }
        if (responsebodyList.length < 10) {
          print("Inside less than 10");
          contactViewdhasMore.value = false;
          update(['no_more_data_for_contactviewd']);
        }

        // print("This is data ${usersList[0]["name"]}");
      } else {
        // Handle errors
        //Get.snackbar("Error", "Failed to fetch users");
      }
    } catch (e) {
      // Handle exceptions
      //Get.snackbar("Error", "Something went wrong");
    } finally {
      contactViewdListfetching(false); // Stop loading
    }
  }

  Future<void> fetchDeclinedByMeList() async {
    try {
      String? language = sharedPreferences!.getString("Language");

      declinedprofilesListFetching(true); // Start loading
      print("All matches page ${recommendedbyEducationpage.value}");
      final response = await http.post(
        Uri.parse(
            '${Appconstants.baseURL}/api/member/rejected?page=${declinedProfilePage.value}&lang=$language'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      print("INterest madhi list ${response.body}");

      if (response.statusCode == 200) {
        print("this is my response");
        var responseBody = jsonDecode(response.body);
        print("Thois is  intrest list1 Reponse success");
        print("fetching data again list success");

        // Handle data from response
        List<dynamic> responsebodyList = responseBody["data"]?["data"] ?? [];

        if (responsebodyList.isNotEmpty) {
          //   declinedProfilesList .addAll(responsebodyList);
          for (var element in responsebodyList) {
            if (!declinedProfilesList.any(
                (existing) => existing['member_id'] == element['member_id'])) {
              declinedProfilesList.add(element);
            }
          }
          declinedProfilePage.value++;
        }
        if (responsebodyList.length < 10) {
          print("Inside less than 10");
          declinedProfileshasMore.value = false;
          update(['no_more_data_for_declinedbyme']);
        }

        // print("This is data ${usersList[0]["name"]}");
      } else {
        // Handle errors
        //Get.snackbar("Error", "Failed to fetch users");
      }
    } catch (e) {
      // Handle exceptions
      //Get.snackbar("Error", "Something went wrong");
    } finally {
      declinedprofilesListFetching(false); // Stop loading
    }
  }

  Future<void> fetchDeclinedByThemList() async {
    try {
      String? language = sharedPreferences!.getString("Language");
      declinedbyThemprofilesListFetching(true); // Start loading
      print("All matches page ${recommendedbyEducationpage.value}");
      final response = await http.post(
        Uri.parse(
            '${Appconstants.baseURL}/api/member/getRejected?page=${declinedbyThemProfilePage.value}&lang=$language'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      print("INterest madhi list ${response.body}");

      if (response.statusCode == 200) {
        print("this is my response");
        var responseBody = jsonDecode(response.body);
        print("Thois is  intrest list1 Reponse success");
        print("fetching data again list success");

        // Handle data from response
        List<dynamic> responsebodyList = responseBody["data"]?["data"] ?? [];

        if (responsebodyList.isNotEmpty) {
          //  declinedbyThemProfilesList .addAll(responsebodyList);
          for (var element in responsebodyList) {
            if (!declinedbyThemProfilesList.any(
                (existing) => existing['member_id'] == element['member_id'])) {
              declinedbyThemProfilesList.add(element);
            }
          }
          declinedbyThemProfilePage.value++;
        }
        if (responsebodyList.length < 10) {
          print("Inside less than 10");
          declinedbyThemProfileshasMore.value = false;
          update(['no_more_data_for_declinedbythem']);
        }

        // print("This is data ${usersList[0]["name"]}");
      } else {
        // Handle errors
        //Get.snackbar("Error", "Failed to fetch users");
      }
    } catch (e) {
      // Handle exceptions
      //Get.snackbar("Error", "Something went wrong");
    } finally {
      declinedbyThemprofilesListFetching(false); // Stop loading
    }
  }

  Future<void> fetchIgnoredProfilesList() async {
    try {
      String? language = sharedPreferences!.getString("Language");
      ignoredProfilesListFetching(true); // Start loading
      print("All matches page ${recommendedbyEducationpage.value}");
      final response = await http.post(
        Uri.parse(
            '${Appconstants.baseURL}/api/member/ignore?page=${ignoredProfilesPage.value}&lang=$language'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      print("INterest madhi list ${response.body}");

      if (response.statusCode == 200) {
        print("this is my response");
        var responseBody = jsonDecode(response.body);
        print("Thois is  intrest list1 Reponse success");
        print("fetching data again list success");

        // Handle data from response
        List<dynamic> responsebodyList = responseBody["data"]?["data"] ?? [];

        if (responsebodyList.isNotEmpty) {
          //   ignoredProfilesList .addAll(responsebodyList);
          for (var element in responsebodyList) {
            if (!ignoredProfilesList.any(
                (existing) => existing['member_id'] == element['member_id'])) {
              ignoredProfilesList.add(element);
            }
          }
          ignoredProfilesPage.value++;
        }
        if (responsebodyList.length < 10) {
          print("Inside less than 10");
          ignoredProfileshasMore.value = false;
          update(['no_more_data_for_ignoredbythem']);
        }

        // print("This is data ${usersList[0]["name"]}");
      } else {
        // Handle errors
        //Get.snackbar("Error", "Failed to fetch users");
      }
    } catch (e) {
      // Handle exceptions
      //Get.snackbar("Error", "Something went wrong");
    } finally {
      ignoredProfilesListFetching(false); // Stop loading
    }
  }

  Future<void> fetchProfilesVisitedByMeList() async {
    try {
      String? language = sharedPreferences!.getString("Language");
      profilesvisitedByMeListFetching(true); // Start loading
      print("All matches page ${recommendedbyEducationpage.value}");
      final response = await http.post(
        Uri.parse(
            '${Appconstants.baseURL}/api/member/meviewother?page=${profilesvisitedByMePage.value}&lang=$language'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      print("INterest madhi list ${response.body}");

      if (response.statusCode == 200) {
        print("this is my response");
        var responseBody = jsonDecode(response.body);
        print("Thois is  intrest list1 Reponse success");
        print("fetching data again list success");

        // Handle data from response
        List<dynamic> responsebodyList = responseBody["data"]?["data"] ?? [];

        if (responsebodyList.isNotEmpty) {
          //   profilesvisitedByMeList .addAll(responsebodyList);
          for (var element in responsebodyList) {
            if (!profilesvisitedByMeList.any(
                (existing) => existing['member_id'] == element['member_id'])) {
              profilesvisitedByMeList.add(element);
            }
          }
          profilesvisitedByMePage.value++;
        }
        if (responsebodyList.length < 10) {
          print("Inside less than 10");
          profilesvisitedByMehasMore.value = false;
          update(['no_more_data_for_profilesvisitedbyme']);
        }

        // print("This is data ${usersList[0]["name"]}");
      } else {
        // Handle errors
        //Get.snackbar("Error", "Failed to fetch users");
      }
    } catch (e) {
      // Handle exceptions
      //Get.snackbar("Error", "Something went wrong");
    } finally {
      profilesvisitedByMeListFetching(false); // Stop loading
    }
  }

  Future<void> fetchProfilesVisitedByThemList() async {
    try {
      String? language = sharedPreferences!.getString("Language");
      profilesvisitedByThemListFetching(true); // Start loading
      print("All matches page ${recommendedbyEducationpage.value}");
      final response = await http.post(
        Uri.parse(
            '${Appconstants.baseURL}/api/member/otherviewMe?page=${profilesvisitedByThemPage.value}&lang=$language'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      print("INterest madhi list ${response.body}");

      if (response.statusCode == 200) {
        print("this is my response");
        var responseBody = jsonDecode(response.body);
        print("Thois is  intrest list1 Reponse success $responseBody");
        print("fetching data again list success");

        // Handle data from response
        List<dynamic> responsebodyList = responseBody["data"]?["data"] ?? [];

        if (responsebodyList.isNotEmpty) {
          //  profilesvisitedByThemList .addAll(responsebodyList);
          for (var element in responsebodyList) {
            if (!profilesvisitedByThemList.any(
                (existing) => existing['member_id'] == element['member_id'])) {
              profilesvisitedByThemList.add(element);
            }
          }
          profilesvisitedByThemPage.value++;
        }
        if (responsebodyList.length < 10) {
          print("Inside less than 10");
          profilesvisitedByThemhasMore.value = false;
          update(['no_more_data_for_profilesvisitedbythem']);
        }

        // print("This is data ${usersList[0]["name"]}");
      } else {
        // Handle errors
        //Get.snackbar("Error", "Failed to fetch users");
      }
    } catch (e) {
      // Handle exceptions
      //Get.snackbar("Error", "Something went wrong");
    } finally {
      profilesvisitedByThemListFetching(false); // Stop loading
    }
  }

  Future<void> sendInterest({required int memberid}) async {
    expressedInterestMembers.add(memberid);

    final url = Uri.parse('${Appconstants.baseURL}/api/send-interest');
    sendInterestLoading.value = true;
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          'to_member_id': memberid,
        }),
      );

      print("This is send interest data ${response.body}");

      if (response.statusCode == 200) {
        // Success
        analytics.logEvent(name: "app_96k_send_interest");

        final jsonResponse = jsonDecode(response.body);
        print('Success: $jsonResponse');
        // //Get.snackbar('Success', 'Interest sent successfully!');
      } else {
        // Error
        print('Error: ${response.statusCode}');
        //  //Get.snackbar('Error', 'Failed to send interest');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      //Get.snackbar('Exception', 'Something went wrong');
    } finally {
      sendInterestLoading.value = false;
    }
  }

  Future<void> shortlistMember({required int memberid}) async {
    final url = Uri.parse('${Appconstants.baseURL}/api/shortlist/add');
    shortlistedLocalMembers.add(memberid);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          'shortlisted_member_id': memberid,
        }),
      );

      print("This is Short List data ${response.body}");

      if (response.statusCode == 200) {
        // Success
        final jsonResponse = jsonDecode(response.body);
        print('Success: $jsonResponse');
        // //Get.snackbar('Success', 'Interest sent successfully!');

        analytics.logEvent(name: "app_96k_short_list_profile");
      } else {
        // Error
        print('Error: ${response.statusCode}');
        //  //Get.snackbar('Error', 'Failed to send interest');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      //Get.snackbar('Exception', 'Something went wrong');
    } finally {}
  }

  final ViewProfileController _viewProfileController =
      Get.put(ViewProfileController());

  Future<void> removeFromShortlistOnDetails({required int memberid}) async {
    final url = Uri.parse('${Appconstants.baseURL}/api/shortlist/remove');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          'shortlisted_member_id': memberid,
        }),
      );

      print("This is Short List data ${response.body}");

      if (response.statusCode == 200) {
        // Success
        final jsonResponse = jsonDecode(response.body);
        print('Success: $jsonResponse');
        // //Get.snackbar('Success', 'Interest sent successfully!');
        shortlistedLocalMembers.remove(memberid);

        await _viewProfileController.fetchUserInfo(memberid: memberid);
      } else {
        // Error
        print('Error: ${response.statusCode}');
        //  //Get.snackbar('Error', 'Failed to send interest');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      //Get.snackbar('Exception', 'Something went wrong');
    } finally {}
  }

  Future<void> removeFromShortlist({required int memberid}) async {
    final url = Uri.parse('${Appconstants.baseURL}/api/shortlist/remove');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          'shortlisted_member_id': memberid,
        }),
      );

      print("This is Short List data ${response.body}");

      if (response.statusCode == 200) {
        // Success
        final jsonResponse = jsonDecode(response.body);
        print('Success: $jsonResponse');
        // //Get.snackbar('Success', 'Interest sent successfully!');
        shortlistedLocalMembers.remove(memberid);
        shortlistedPage.value = 1;
        shortlistedhasMore.value = true;
        shortlistedList.clear();
        shortlistedListfetching.value = true;

        await fetchShortlistedList();
      } else {
        // Error
        print('Error: ${response.statusCode}');
        //  //Get.snackbar('Error', 'Failed to send interest');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      //Get.snackbar('Exception', 'Something went wrong');
    } finally {}
  }

  bool hasExpressedInterest(int memberID) {
    print("this is resp for check");
    return expressedInterestMembers.contains(memberID);
  }

  bool hasShortlisted(int memberID) {
    print("this is resp for check");
    return shortlistedLocalMembers.contains(memberID);
  }

  bool hasaccepted(int memberID) {
    print("this is resp for check");
    return acceptedLocalMembers.contains(memberID);
  }

  bool hasdeclined(int memberID) {
    print("this is resp for check");
    return declinedLocalMembers.contains(memberID);
  }

  var acceptloading = false.obs;

  Future<void> acceptedrequest({required int memberid}) async {
    acceptloading.value = true;
    final url = Uri.parse('${Appconstants.baseURL}/api/accept-interest');
    acceptedLocalMembers.add(memberid);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          'from_member_id': memberid,
        }),
      );

      print("This is Short List data ${response.body}");

      if (response.statusCode == 200) {
        // Success
        final jsonResponse = jsonDecode(response.body);
        print('Success: $jsonResponse');
        // //Get.snackbar('Success', 'Interest sent successfully!');
      } else {
        // Error
        print('Error: ${response.statusCode}');
        //  //Get.snackbar('Error', 'Failed to send interest');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      //Get.snackbar('Exception', 'Something went wrong');
    } finally {
      acceptloading.value = false;
    }
  }

  var declineLoading = false.obs;
  Future<void> declinerequest({required int memberid}) async {
    final url = Uri.parse('${Appconstants.baseURL}/api/reject-interest');
    declinedLocalMembers.add(memberid);
    declineLoading.value = true;
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          'from_member_id': memberid,
        }),
      );

      print("This is Short List data ${response.body}");

      if (response.statusCode == 200) {
        // Success
        final jsonResponse = jsonDecode(response.body);
        print('Success: $jsonResponse');
        // //Get.snackbar('Success', 'Interest sent successfully!');
      } else {
        // Error
        print('Error: ${response.statusCode}');
        //  //Get.snackbar('Error', 'Failed to send interest');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      //Get.snackbar('Exception', 'Something went wrong');
    } finally {
      declineLoading.value = false;
    }
  }

  Future<void> ignoreProfiles({required int memberid}) async {
    final url = Uri.parse('${Appconstants.baseURL}/api/ignore-member');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          'ignored_member_id': memberid,
        }),
      );

      print("This is Short List data ${response.body}");

      if (response.statusCode == 200) {
        // Success
        final jsonResponse = jsonDecode(response.body);
        print('Success: $jsonResponse');

        analytics.logEvent(name: "app_96k_ignored_profile");

        // //Get.snackbar('Success', 'Interest sent successfully!');
        //  declinedLocalMembers .add(memberid);
        Get.back();
        Get.back();

        // //Get.snackbar("Success", "Profile Added to ignore List");
      } else if (response.statusCode == 422) {
        Get.back();
        Get.back();
        //  //Get.snackbar("Error", "Member already ignored");
      } else {
        // Error
        print('Error: ${response.statusCode}');
        //  //Get.snackbar('Error', 'Failed to send interest');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      //Get.snackbar('Exception', 'Something went wrong');
    } finally {}
  }

  Future<void> cancelInterest({required int memberid}) async {
    final url = Uri.parse('${Appconstants.baseURL}/api/cancel-interest');
    print("Cancle Interst called");
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          'to_member_id': memberid,
        }),
      );

      print("This is Short List data for cancel ${response.body}");

      if (response.statusCode == 200) {
        // Success
        expressedInterestMembers.remove(memberid);
        final jsonResponse = jsonDecode(response.body);
        print('Success: $jsonResponse');

        // analytics.logEvent(name: "app_ignored_profile");

        // //Get.snackbar('Success', 'Interest sent successfully!');
        //  declinedLocalMembers .add(memberid);
        Get.back();
        intrestSentbyMePage.value = 1;
        intrestSentByMehasMore.value = true;
        intrestSentByMeList.clear();
        intrestSentbyMefetching.value = true;
        fetchCountDetails();
        fetchIntrestSentByMeList();

        // //Get.snackbar("Success", "Profile Added to ignore List");
      } else if (response.statusCode == 422) {
        Get.back();

        //  //Get.snackbar("Error", "Member already ignored");
      } else {
        // Error
        print('Error: ${response.statusCode}');
        //  //Get.snackbar('Error', 'Failed to send interest');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
      //Get.snackbar('Exception', 'Something went wrong');
    } finally {}
  }
/*
Future<void> fetchShortlistedList() async {
  print("Intrerwt received");
  String? token = sharedPreferences?.getString("token");
  if (token == null) {
    //Get.snackbar('Error', 'No authentication token found');
    return;
  }

  // Prevent multiple fetches at the same time
  if (shortlistedListfetching.value) return;
  try {
    print("INTREST IN TRY ");
    shortlistedListfetching.value = true;
print("Interest sent page is ${shortlistedPage.value}");
    final response = await http.get(
      Uri.parse('${Appconstants.baseURL}/api/member/shortlist/?page=${shortlistedPage.value}'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
    );
print("Thois is  intrest list1");
print("response for int sent ${response.body}");
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
print("Thois is  intrest list1 Reponse success");

      // Handle data from response
      List<dynamic> responsebodyList = responseBody["data"]?["data"] ?? [];
      
      if (responsebodyList.isNotEmpty) {
print("Thois is  intrest list1 is not empty ");

        shortlistedPage.value++;  // Increment page if there's more data
        shortlistedList.addAll(responsebodyList); // Add new items to the list

        // Check if we've reached the end of the list
        if (shortlistedList.length < 10) {
          shortlistedListEnd.value = true;  // Mark end of list if fewer than 10 items
        }
      } else {
print("Thois is  intrest list1 is empty");

        shortlistedListEnd.value = true;  // No more data
      //  //Get.snackbar('Info', 'No more data available.');
      }

   //   print("Intrest received list values in ${intrestSentByMeList.value}");

   print("This is my list length ${intrestSentByMeList.length}");
    } else {
      //Get.snackbar('Error', 'Failed to load data: ${response.statusCode}');
    }
  } catch (e) {
    //Get.snackbar('Error', e.toString());
  } finally {
  
  }
}*/

  var Contactdata = {}.obs;
  var Contactdatafetching = false.obs;

  Future<void> fetchContactDetails({required int memberid}) async {
    try {
      Contactdatafetching.value = true;

      // Fetch both education and specialization data in parallel

      final response = await http.post(
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({
            'viewed_member_id': memberid,
          }),
          Uri.parse('${Appconstants.baseURL}/api/view-contact'));
      print("this is response ${response.body}");
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        var responsebody = responseBody;

        //  print("response body online  is this ${responsebody["data"]["data"]}");
        Contactdata.value = responsebody["contact_details"];
      } else {
        //Get.snackbar('Error', 'Failed to load data');
      }
    } catch (e) {
      print("Error is this $e");
      //Get.snackbar('Error', e.toString());
    } finally {
      Contactdatafetching.value = false;
    }
  }

  var countData = {}.obs;
  var countDataFetching = false.obs;

  Future<void> fetchCountDetails() async {
    try {
      countDataFetching.value = true;
      // Fetch both education and specialization data in parallel
      final response = await http.post(headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      }, Uri.parse('${Appconstants.baseURL}/api/member/list-count'));
      print("this is response ${response.body}");
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        var responsebody = responseBody;
        //  print("response body online  is this ${responsebody["data"]["data"]}");
        countData.value = responsebody["counts"];
      } else {
        //Get.snackbar('Error', 'Failed to load data');
      }
    } catch (e) {
      print("Error is this $e");
      //Get.snackbar('Error', e.toString());
    } finally {
      countDataFetching.value = false;
    }
  }

  var selectedIndex = 0.obs;
  var selectedmatchsScreen = 0.obs;
  var selectedInboxIndex = 0.obs;
  void updateMathcesScreen(int index) {
    selectedmatchsScreen.value = index;
  }

  void onItemTapped(int index) {
    selectedIndex.value = index;
    if (selectedIndex.value == 2) {
      fetchCountDetails();
    }
  }

  void onInboxItemTapped(int Index) {
    selectedInboxIndex.value = 2;
  }

  var incompleteData = [].obs;
  var percentage = 0.obs;

  var incomplteDataFetching = false.obs;

  Future<void> fetchIncompleteDetails() async {
    try {
      incomplteDataFetching.value = true;
      String? language = sharedPreferences!.getString("Language");
      final response = await http.get(
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        Uri.parse('${Appconstants.baseURL}/api/incomplete?lang=$language'),
      );

      print("this is response inc ${response.request}");
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);

        percentage.value = responseBody["data"]["percentages"];

        // Use assignAll to update the observable list
        incompleteData.assignAll(responseBody["data"]["incompletetable"] ?? []);

        print("Length of data is $responseBody");
      } else {
        print(
            "Error: Failed to fetch data. Status code: ${response.statusCode}");
        // Optionally show a snackbar or handle the error
      }
    } catch (e) {
      print("Error is this $e");
      // Optionally show a snackbar or handle the error
    } finally {
      incomplteDataFetching.value = false;
    }
  }

  var unblockFetching = false.obs;

  Future<void> unblockUser({required int memberid}) async {
    try {
      unblockFetching.value = true;

      // Fetch both education and specialization data in parallel

      final response = await http.post(
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({
            'ignored_member_id': memberid,
          }),
          Uri.parse('${Appconstants.baseURL}/api/remove-ignore'));
      print("this is response ignore ${response.body}");
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        var responsebody = responseBody;

        //  print("response body online  is this ${responsebody["data"]["data"]}");
        //  Contactdata.value =  responsebody["contact_details"];
        ignoredProfilesPage.value = 1;
        ignoredProfileshasMore.value = true;
        ignoredProfilesList.clear();
        ignoredProfilesListFetching.value = true;

        await fetchIgnoredProfilesList();
      } else {
        //Get.snackbar('Error', 'Failed to load data');
      }
    } catch (e) {
      print("Error is this $e");
      //Get.snackbar('Error', e.toString());
    } finally {
      unblockFetching.value = false;
    }
  }

  var loadingPhoto = false.obs;
  var fetchedPhotoURL = "".obs;

  Future<void> fetchMemberProfilePhoto() async {
    String apiUrl = "${Appconstants.baseURL}/api/member-profile-photo";

    loadingPhoto.value = true; // Start loading
    // errorMessage.value = ''; // Reset error message

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );
      print("THIs i show image ${response.body}");
      if (response.statusCode == 200) {
        // Parse the response data
        final responseData = json.decode(response.body);
        fetchedPhotoURL.value = responseData["photosURL"];
        print("THIs i show image ${fetchedPhotoURL.value}");
      } else {
        // Handle API errors
        //   final errorData = json.decode(response.body);
        //   errorMessage.value = errorData["message"] ?? "Failed to fetch data";
      }
    } catch (e) {
      // Handle unexpected errors
      //    errorMessage.value = "An error occurred: $e";
    } finally {
      loadingPhoto.value = false; // Stop loading
    }
  }
}
