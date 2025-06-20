import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/screens/inbox/intrestedprofiles/acceptedbyMe.dart';
import 'package:_96kuliapp/screens/inbox/intrestedprofiles/intrestAcceptedbythem.dart';
import 'package:_96kuliapp/screens/inbox/intrestedprofiles/intrest_received.dart';
import 'package:_96kuliapp/screens/inbox/intrestedprofiles/intrestsentbyme.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InterestedProfilesScreen extends StatefulWidget {
  const InterestedProfilesScreen({super.key});

  @override
  _InterestedProfilesScreenState createState() =>
      _InterestedProfilesScreenState();
}

class _InterestedProfilesScreenState extends State<InterestedProfilesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DashboardController _dashboardcontroller =
      Get.find<DashboardController>();

  @override
  void initState() {
    super.initState();
    gender = selectgender();

    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        handleTabSelection(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void handleTabSelection(int index) async {
    if (index == 0) {
      // Handle onTap for Interest Received tab
      _dashboardcontroller.fetchCountDetails();

      print("Interest Received tab tapped!");
      if (_dashboardcontroller.intrestreceivedList.length !=
          _dashboardcontroller.countData["received"]) {
        _dashboardcontroller.intrestreceivedPage.value = 1;
        _dashboardcontroller.intrestreceivedhasMore.value = true;
        _dashboardcontroller.intrestreceivedList.clear();
        _dashboardcontroller.intrestReceivedfetching.value = true;

        await _dashboardcontroller.fetchIntrestReceivedList();
      } else if (_dashboardcontroller.countData["received"] == 0) {
        await _dashboardcontroller.fetchIntrestReceivedList();
      }
    } else if (index == 1) {
      _dashboardcontroller.fetchCountDetails();

      // Handle onTap for Interest Sent tab
      print(
          "Interest Sent tab tapped! ${_dashboardcontroller.intrestSentByMeList.length}");
      if (_dashboardcontroller.intrestSentByMeList.length !=
          _dashboardcontroller.countData["sendinterest"]) {
        _dashboardcontroller.intrestSentbyMePage.value = 1;
        _dashboardcontroller.intrestSentByMehasMore.value = true;
        _dashboardcontroller.intrestSentByMeList.clear();
        _dashboardcontroller.intrestSentbyMefetching.value = true;

        await _dashboardcontroller.fetchIntrestSentByMeList();
        _dashboardcontroller.fetchCountDetails();
      } else if (_dashboardcontroller.countData["sendinterest"] == 0) {
        await _dashboardcontroller.fetchIntrestSentByMeList();
      }
    } else if (index == 2) {
      _dashboardcontroller.fetchCountDetails();

      // Handle onTap for Accepted by Me tab
      print("Accepted by Me tab tapped! 1");
      if (_dashboardcontroller.intrestAcceptedList.length !=
          _dashboardcontroller.countData["accepted"]) {
        _dashboardcontroller.intrestAcceptedPage.value = 1;
        _dashboardcontroller.intrestAcceptedhasMore.value = true;
        _dashboardcontroller.intrestAcceptedList.clear();
        _dashboardcontroller.intrestAcceptedfetching.value = true;

        await _dashboardcontroller.fetchIntrestAcceptedList();
        _dashboardcontroller.fetchCountDetails();
      } else if (_dashboardcontroller.countData["accepted"] == 0) {
        await _dashboardcontroller.fetchIntrestAcceptedList();
      } else {
        print("THis is print ${_dashboardcontroller.countData["accepted"]}");
      }
    } else if (index == 3) {
      _dashboardcontroller.fetchCountDetails();

      if (_dashboardcontroller.intrestAcceptedByThemList.length !=
          _dashboardcontroller.countData["getAccepted"]) {
        _dashboardcontroller.intrestAcceptedbythemPage.value = 1;
        _dashboardcontroller.intrestAcceptedByThemhasMore.value = true;
        _dashboardcontroller.intrestAcceptedByThemList.clear();
        _dashboardcontroller.intrestAcceptedbythemfetching.value = true;

        await _dashboardcontroller.fetchIntrestAcceptedbyThemList();
      } else if (_dashboardcontroller.countData["getAccepted"] == 0) {
        await _dashboardcontroller.fetchIntrestAcceptedbyThemList();
      }
      // Handle onTap for Accepted by Her/Him tab
      print("Accepted by Him/Her tab tapped!");
    }
  }

  late String gender;

  final mybox = Hive.box('myBox');
  String? language = sharedPreferences?.getString("Language");
  String? gender2;
  String? gender3;
  String? gender4;

  String selectgender() {
    if (language == "en") {
      if (mybox.get("gender") == 2) {
        return "groom";
      } else {
        return "bride";
      }
    } else {
      if (mybox.get("gender") == 2) {
        gender2 = "वराचा";
        gender3 = "वराच्या";
        gender4 = "वराला ";
        return "तिने";
      } else {
        gender2 == "वधूचा";
        gender3 = "वधूच्या";
        gender4 = "वधूला";

        return "त्याने";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        appBar: TabBar(
          controller: _tabController,
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
          tabAlignment: TabAlignment.center,
          isScrollable: true,
          tabs: [
            Obx(
              () => Tab(
                  text:
                      '${AppLocalizations.of(context)!.interestReceived} (${_dashboardcontroller.countData["received"]})'),
            ),
            Obx(
              () => Tab(
                  text:
                      '${AppLocalizations.of(context)!.interestSent} (${_dashboardcontroller.countData["sendinterest"]})'),
            ),
            Obx(
              () => Tab(
                  text:
                      '${AppLocalizations.of(context)!.acceptedByMe} (${_dashboardcontroller.countData["accepted"]})'),
            ),
            Obx(
              () => Tab(
                  text:
                      '${AppLocalizations.of(context)!.acceptedBy.replaceAll("[[gender]]", gender)} (${_dashboardcontroller.countData["getAccepted"]})'),
            )
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            InterestReceived(),
            InterestSentByMe(),
            IntrestAcceptedByMe(),
            IntrestAcceptedByThem(),
          ],
        ),
      ),
    );
  }
}
