import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/screens/exploreAppScreens/ExploreAppScreen.dart';

import 'package:_96kuliapp/utils/Apptheme.dart';

class Exploreapptab extends StatelessWidget {
  Exploreapptab({super.key});

  final DashboardController _dashboardcontroller =
      Get.put(DashboardController());
  @override
  Widget build(BuildContext context) {
    //  final BottomNavController bottomNavController = Get.put(BottomNavController());
    return WillPopScope(
      onWillPop: () async {
        // Add your logic here
        // Return true to allow the screen to close
        // Return false to prevent the screen from closing
        return true; // For example, prevent closing
      },
      child: DefaultTabController(
        initialIndex: _dashboardcontroller.selectedmatchsScreen.value,
        length: 1,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: AppBar(
              centerTitle: true,
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
                    tabs: const [
                      Tab(child: Text("Recommended Matches")),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: const TabBarView(children: [
            ExploreAppScreen(),
          ]),
        ),
      ),
    );
  }
}


/*
*/