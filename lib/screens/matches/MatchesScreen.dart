// ignore_for_file: deprecated_member_use

import 'package:_96kuliapp/utils/selectlanguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/matches/allmatches.dart';
import 'package:_96kuliapp/screens/matches/matchesbyeducation.dart';
import 'package:_96kuliapp/screens/matches/matchesbylocation.dart';
import 'package:_96kuliapp/screens/matches/matchesbyoccupation.dart';
import 'package:_96kuliapp/screens/notifications/notificationScreen.dart';

import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/appDrawer.dart';
import 'package:_96kuliapp/screens/matches/RecommendedMatches.dart';
import 'package:_96kuliapp/utils/bottomnavBar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //  final BottomNavController bottomNavController = Get.put(BottomNavController());
    final DashboardController dashboardcontroller =
        Get.find<DashboardController>();
    return WillPopScope(
      onWillPop: () async {
        dashboardcontroller.onItemTapped(0);

        // Add your logic here
        // Return true to allow the screen to close
        // Return false to prevent the screen from closing
        return false; // For example, prevent closing
      },
      child: DefaultTabController(
        initialIndex: dashboardcontroller.selectedmatchsScreen.value,
        length: 5,
        child: Scaffold(
          drawer: const AppDrawer(),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: AppBar(
              centerTitle: true,
              leading: Builder(builder: (context) {
                return GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: CircleAvatar(
                      radius: 15, // Adjust the radius as per your requirement
                      backgroundColor: Colors
                          .transparent, // Optional: Set a background color
                      child: Icon(
                        Icons.menu,
                        color: AppTheme.secondryColor,
                      )),
                );
              }),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // SelectLanguage(),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          navigatorKey.currentState!.push(MaterialPageRoute(
                            builder: (context) => const NotificationScreen(),
                          ));
                        },
                        child: Stack(
                          clipBehavior: Clip
                              .none, // Allow the circle to overflow the bounds
                          children: [
                            CircleAvatar(
                              radius:
                                  15, // Adjust the radius as per your requirement
                              backgroundColor: Colors
                                  .transparent, // Optional: Set a background color
                              child: Image.asset(
                                "assets/notificationblue.png",
                                fit: BoxFit.cover,
                                width: 20, // Icon size
                                height: 20, // Icon size
                              ),
                            ),
                            // Check if the count for notifications is non-null and greater than 0
                            if (dashboardcontroller.countData["notification"] !=
                                    null &&
                                dashboardcontroller.countData["notification"] >
                                    0)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: 12, // Reduced size of the red circle
                                  height: 12, // Reduced size of the red circle
                                  decoration: const BoxDecoration(
                                    color:
                                        Colors.red, // Red color for the circle
                                    shape: BoxShape.circle, // Circle shape
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${dashboardcontroller.countData["notification"]}', // Display the count (e.g., number of new notifications)
                                      style: const TextStyle(
                                        color: Colors
                                            .white, // Text color inside the circle
                                        fontSize:
                                            8, // Smaller font size for the count
                                        fontWeight: FontWeight
                                            .bold, // Make the text bold
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  width: 100,
                  height: 33,
                  child: Image.asset("assets/applogo.png"),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: Container(
                  color: AppTheme
                      .secondryColor, // Set your TabBar background color here
                  child: TabBar(
                    tabAlignment: TabAlignment.center,
                    isScrollable: true,
                    labelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: "WORKSANS"),
                    indicatorColor: Colors.transparent, // Indicator color
                    labelColor: Colors.white, // Selected tab text color
                    unselectedLabelStyle: TextStyle(
                        fontFamily: "WORKSANS",
                        color: Colors.white.withOpacity(.8),
                        fontSize: 13),
                    unselectedLabelColor: Colors.white
                        .withOpacity(.4), // Unselected tab text color
                    tabs: [
                      Tab(
                          child: Text(AppLocalizations.of(context)!
                              .recommendedMatches)),
                      Tab(
                          child: Text(AppLocalizations.of(context)!
                              .matchesByEducation)),
                      Tab(
                          child: Text(
                              AppLocalizations.of(context)!.matchesByLocation)),
                      Tab(
                        child: Text(
                            AppLocalizations.of(context)!.matchesByOccupation),
                      ),
                      Tab(
                        child: Text(AppLocalizations.of(context)!.allMatches),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: const TabBarView(children: [
            RecommendedMatches(),
            MatchesByEducation(),
            MatchesByLocation(),
            MatchesbyOccupation(),
            AllMatches()
          ]),
        ),
      ),
    );
  }
}


/*
*/