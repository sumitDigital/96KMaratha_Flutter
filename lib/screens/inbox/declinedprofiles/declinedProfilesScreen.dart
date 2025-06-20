import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/inbox/declinedprofiles/declinedByMe.dart';
import 'package:_96kuliapp/screens/inbox/declinedprofiles/declinedbythem.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeclinedProfileScreen extends StatelessWidget {
  const DeclinedProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController =
        Get.find<DashboardController>();
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: TabBar(
          labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: "WORKSANS"),
          indicatorColor: Colors.transparent, // Indicator color
          labelColor: AppTheme.primaryColor, // Selected tab text color
          unselectedLabelStyle: TextStyle(
              fontFamily: "WORKSANS",
              color: AppTheme.secondryColor,
              fontSize: 13),
          unselectedLabelColor:
              AppTheme.secondryColor, // Unselected tab text color
          tabs: [
            Obx(
              () {
                if (dashboardController.countData["rejected"] == 0) {
                  return Tab(text: AppLocalizations.of(context)!.iDeclined);
                } else {
                  return Tab(
                      text:
                          '${AppLocalizations.of(context)!.iDeclined} (${dashboardController.countData["rejected"]})');
                }
              },
            ),
            Obx(
              () {
                if (dashboardController.countData["getRejected"] == 0) {
                  return Tab(text: AppLocalizations.of(context)!.theyDeclined);
                } else {
                  return Tab(
                    text:
                        "${AppLocalizations.of(context)!.theyDeclined} (${dashboardController.countData["getRejected"]})",
                  );
                }
              },
            )
          ],
        ),
        body: const TabBarView(
          children: [
            // Replace the widgets below with the content of each tab
            DeclinedProfilesByMe(),
            DeclinedProfilesByThem()
          ],
        ),
      ),
    );
  }
}
