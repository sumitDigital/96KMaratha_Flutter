import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/screens/inbox/profilevisitors/profilesVisitedByThem.dart';
import 'package:_96kuliapp/screens/inbox/profilevisitors/provilesVisitedByMe.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileVisitorsScreen extends StatefulWidget {
  const ProfileVisitorsScreen({super.key});

  @override
  State<ProfileVisitorsScreen> createState() => _ProfileVisitorsScreenState();
}

class _ProfileVisitorsScreenState extends State<ProfileVisitorsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DashboardController _dashboardcontroller =
      Get.find<DashboardController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Add a listener to handle tab changes
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        // Perform actions based on the selected tab
        print("Selected Tab Index: ${_tabController.index}");
      }
    });
  }

  @override
  void dispose() {
    // Dispose of the TabController when the widget is removed
    _tabController.dispose();
    super.dispose();
  }

  void handleTabSelection(int index) async {
    if (index == 0) {
      // Handle onTap for Interest Received tab
      _dashboardcontroller.fetchCountDetails();
    } else if (index == 1) {
      _dashboardcontroller.fetchCountDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        controller: _tabController,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontFamily: "WORKSANS",
        ),
        indicatorColor: Colors.transparent, // Indicator color
        labelColor: AppTheme.primaryColor, // Selected tab text color
        unselectedLabelStyle: TextStyle(
          fontFamily: "WORKSANS",
          color: AppTheme.secondryColor,
          fontSize: 13,
        ),
        unselectedLabelColor:
            AppTheme.secondryColor, // Unselected tab text color
        tabs: [
          Obx(() => Tab(
                text:
                    '${AppLocalizations.of(context)!.profileVisitors} (${_dashboardcontroller.countData["otherviewMe"] ?? 0})',
              )),
          Obx(() => Tab(
                text:
                    '${AppLocalizations.of(context)!.visitedByMe} (${_dashboardcontroller.countData["meviewother"] ?? 0})',
              )),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ProfilesVisitedByThem(),
          ProfileVisitedByMe(),
        ],
      ),
    );
  }
}
