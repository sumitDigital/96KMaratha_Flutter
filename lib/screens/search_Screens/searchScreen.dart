import 'package:flutter/material.dart';
import 'package:_96kuliapp/screens/search_Screens/advanced_search.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      initialIndex: 0,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: SafeArea(
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
                  unselectedLabelColor:
                      Colors.white.withOpacity(.4), // Unselected tab text color
                  tabs: const [
                    Tab(child: Text("Advance Search")),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [AdvancedSearch()]),
      ),
    );
  }
}
