// ignore_for_file: deprecated_member_use, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:_96kuliapp/checkupdateFunctions.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/screens/editProfile_screens/editBasicInfo.dart';
import 'package:_96kuliapp/screens/homescreen.dart';
import 'package:_96kuliapp/screens/inbox/inboxScreen.dart';
import 'package:_96kuliapp/screens/matches/MatchesScreen.dart';
import 'package:_96kuliapp/screens/search_Screens/basicSearch.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final DashboardController _dashboardController =
      Get.put(DashboardController());

  static final List<Widget> _widgetOptions = <Widget>[
    const Homescreen(),
    const MatchesScreen(),
    const InboxScreen(),
    const BasicSearch(),
  ];

/*
Consumer<LanguageChangeController>(
          builder: (context, value, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Center the Row of buttons vertically
                Expanded(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: value.appLocale.toString() == "en"
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              Provider.of<LanguageChangeController>(context, listen: false)
                                  .changeLanguage(const Locale('en'));
                                  sharedPreferences?.setString("language", "en");
                            },
                            child: const Text(
                              'English',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: value.appLocale.toString() == "mr"
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              Provider.of<LanguageChangeController>(context, listen: false)
                                  .changeLanguage(const Locale('mr'));
                                  sharedPreferences?.setString("language", "mr");

                            },
                            child: const Text(
                              'Marathi',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Continue button
                ElevatedButton(
                  onPressed: () {
                    // Your continue action
                                navigatorKey.currentState!.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) =>  WelcomeScreen()), (route) => false,);
                  },
                  child: Text(  AppLocalizations.of(context)!.continuebutton),
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        ),*/

  Future<void> sendPopupStateUpdate(int popupId) async {
    print("THIS IS POPUP ID $popupId");
    String? token = sharedPreferences?.getString("token");
    print("THIS IS ONE TIMNE POPUP");
    final url = '${Appconstants.baseURL}/api/update-popup-state';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token' // Include the token here
    };

    final body = json.encode({
      'popup_id': popupId,
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print("THIS IS ONE TIMNE POPUP Success ${response.body}");
        print('Request successful:  ${response.body}');
      } else {
        print(
            "THIS IS ONE TIMNE POPUP fail ${response.body} ${response.statusCode}");

        print('Failed to send request. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    _initialize();
  }

  Future<void> _initialize() async {
    await _dashboardController.fetchUserInfo();

    // Check if the widget is still mounted before performing any operations
    if (mounted) {
      if (_dashboardController.dashboardData["redirection"] != null &&
          _dashboardController.dashboardData["redirection"]["pagename"] ==
              "DASHBOARD") {
        if (_dashboardController.dashboardData["redirection"]
                .containsKey("Popup") &&
            _dashboardController.dashboardData["redirection"]["Popup"] is Map) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              // Ensure the widget is still mounted before showing the dialog
              _showCustomDialogSorryForDelay(context);
            }
          });
          print("Popup exists and is a Map");
        } else {
          print("Popup does not exist or is not a Map");
        }
      }
    }
  }

  bool _dialogVisible = false; // A flag to track if the dialog is already shown
// REQUEST_TO_CHANGEREQUEST_TO_CHANGE
  void _showCustomDialogSorryForDelay(BuildContext context) {
    // Send the popup state update
    sendPopupStateUpdate(
        _dashboardController.dashboardData["redirection"]["Popup"]["popup_id"]);

    // Show the dialog
    showDialog(
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.8),
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              if (_dashboardController.dashboardData["redirection"]["Popup"]
                      ["route"] !=
                  null) {
                if (_dashboardController.dashboardData["redirection"]["Popup"]
                        ["route"] ==
                    "REQUEST_TO_CHANGE") {
                  navigatorKey.currentState!.pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const EditBasicInfoScreen()),
                  );
                }
              }
            },
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.only(
                      left: 12.0, right: 12, top: 25, bottom: 25),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.network(
                        _dashboardController.dashboardData["redirection"]
                            ["Popup"]["imgUrl"],
                        height: 300,
                        width: MediaQuery.of(context).size.width * 0.7,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 8.0,
                  right: 8.0,
                  child: GestureDetector(
                    onTap: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop(); // Close the dialog
                      }
                    },
                    child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            child: Image.asset(
                                height: 24,
                                width: 24,
                                "assets/close-popup.png"),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      _dialogVisible = false; // Reset the flag when the dialog is closed
    });

    _dialogVisible = true; // Set the flag when the dialog is shown

    // Close the dialog automatically after 5 seconds
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_dashboardController.isPageLoading.value) {
        return Scaffold(
          appBar: AppBar(
            title: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 200,
                height: 20,
                color: Colors.white,
              ),
            ),
            backgroundColor: AppTheme.lightPrimaryColor,
          ),
          body: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                height: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppTheme.lightPrimaryColor,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Matches',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.message),
                  label: 'Inbox',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
              ],
              selectedItemColor: const Color.fromARGB(255, 234, 52, 74),
              unselectedItemColor: const Color.fromARGB(255, 83, 93, 126),
            ),
          ),
        );
      } else {
        return Scaffold(
          body: Center(
            child: _widgetOptions
                .elementAt(_dashboardController.selectedIndex.value),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppTheme.darkcolorBotomNav,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Image.asset(
                      "assets/homeBottomNav.png",
                      height: 20,
                      color: Colors.white,
                    ),
                  ),
                  activeIcon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Image.asset("assets/homeBottomNav.png", height: 20),
                  ),
                  label: AppLocalizations.of(context)!.home),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child:
                        Image.asset("assets/matchesBottomNav.png", height: 20),
                  ),
                  activeIcon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Image.asset(
                      "assets/matchesBottomNav.png",
                      height: 20,
                      color: const Color.fromRGBO(255, 199, 56, 1),
                    ),
                  ),
                  label: AppLocalizations.of(context)!.matches),
              BottomNavigationBarItem(
                  activeIcon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: Image.asset(
                        "assets/inboxBottomNav.png",
                        color: const Color.fromRGBO(255, 199, 56, 1),
                      ),
                    ),
                  ),
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Image.asset("assets/inboxBottomNav.png",
                            height: 20),
                      ),
                      if (_dashboardController.countData["received"] != null &&
                          _dashboardController.countData["received"] > 0)
                        Positioned(
                          right: -5,
                          top: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${_dashboardController.countData["received"]}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  label: AppLocalizations.of(context)!.inbox),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: SizedBox(
                        height: 20,
                        child: Image.asset("assets/searchBottomNav.png")),
                  ),
                  activeIcon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: SizedBox(
                        height: 20,
                        child: Image.asset(
                          "assets/icons/Search_partner_1.png",
                          color: const Color.fromRGBO(255, 199, 56, 1),
                        )),
                  ),
                  label: AppLocalizations.of(context)!.search),
            ],
            currentIndex: _dashboardController.selectedIndex.value,
            showUnselectedLabels: true,
            selectedFontSize: 25,
            unselectedFontSize: 25,
            iconSize: 28,
            selectedItemColor: const Color.fromRGBO(255, 199, 56, 1),
            unselectedItemColor: Colors.white,
            onTap: (value) async {
              try {
                print('Checking for Update');
                AppUpdateInfo info = await InAppUpdate.checkForUpdate();

                if (info.updateAvailability ==
                    UpdateAvailability.updateAvailable) {
                  print('Update available');
                  await update();
                } else {
                  print('No update available');
                  _dashboardController.onItemTapped(value);
                }
              } catch (e) {
                print('Error checking for update: ${e.toString()}');
                _dashboardController.onItemTapped(value);
              }
            },
            selectedIconTheme: const IconThemeData(size: 28),
            unselectedIconTheme: const IconThemeData(size: 28),
            selectedLabelStyle: CustomTextStyle.navbarlabel,
            unselectedLabelStyle: CustomTextStyle.navbarlabel,
          ),
        );
      }
    });
  }
}

// _dashboardController.onItemTapped
