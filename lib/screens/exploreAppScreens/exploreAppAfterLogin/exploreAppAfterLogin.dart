// ignore_for_file: deprecated_member_use

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:_96kuliapp/checkupdateFunctions.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/commons/dialogues/acceptInterestDialogue.dart';
import 'package:_96kuliapp/commons/dialogues/declineInterestDialogue.dart';
import 'package:_96kuliapp/commons/dialogues/expressInterest.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/ExploreApController/exploreAppController.dart';
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/controllers/planControllers/premiumPlanController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/screens/exploreAppScreens/plansBGSheet.dart';
import 'package:_96kuliapp/screens/homescreen.dart';
import 'package:_96kuliapp/screens/plans/upgradeScreen.dart';
import 'package:_96kuliapp/screens/profile_screens/user_details.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/newmatches.dart';
import 'package:_96kuliapp/utils/verificationTag.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExploreAppAfterLogin extends StatefulWidget {
  const ExploreAppAfterLogin({super.key});

  @override
  State<ExploreAppAfterLogin> createState() => _ExploreAppAfterLoginState();
}

class _ExploreAppAfterLoginState extends State<ExploreAppAfterLogin>
    with SingleTickerProviderStateMixin {
  final PremiumPlanController _premiumPlanController =
      Get.find<PremiumPlanController>();
  late Animation<double> _animation;
  late AnimationController _controller;

  final DashboardController _dashboardController =
      Get.put(DashboardController());
  final controller = ScrollController();
  final facebookAppEvents = FacebookAppEvents();
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final mybox = Hive.box('myBox');
  String? language = sharedPreferences?.getString("Language");

  var memberId = 0;
  List<String> imgURLS = [];

  @override
  void initState() {
    memberId = mybox.get('memberIDOTP');
    super.initState();
    print("THIS IS MEMBERID $memberId");

    _controller = AnimationController(
      duration: const Duration(seconds: 3), // Animation duration
      vsync: this,
    )..repeat(); // Repeat the animation

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    // Fetch data initially when the page loads
    _dashboardController.fetchProfileVisitors();
    _dashboardController.fetchIntrestReceivedList();
    _dashboardController.fetchRecommendedMatchesListForExplore();

    // Add scroll listener for pagination
    controller.addListener(() {
      print("LISTning scroll");
      print(
          "Scroll offset: ${controller.offset}, Max extent: ${controller.position.maxScrollExtent}");
      if (controller.position.maxScrollExtent - controller.offset <= 50) {
        _dashboardController.fetchRecommendedMatchesListForExplore();
      }
      print(
          "recommendation ${controller.position.maxScrollExtent - controller.offset}");
    });

    imgURLS = [
      "${Appconstants.baseURL}/image/plan-offer-img2/$memberId",
      "${Appconstants.baseURL}/image/plan-offer-img3/$memberId",
      "${Appconstants.baseURL}/image/plan-offer-img4/$memberId",
      "${Appconstants.baseURL}/image/plan-offer-img5/$memberId",
    ];
  }

  @override
  void dispose() {
    _controller.dispose();

    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (navigatorKey.currentState!.canPop()) {
          Get.back();
        } else {
          navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
            builder: (context) => const UpgradePlan(),
          ));
        }
        return false;
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _premiumPlanController.planListOffer.isNotEmpty
            ? PlanTimer(
                onPage: "FloatingAction",
                premiumPlanController: _premiumPlanController,
                animation: _animation)
            : const SizedBox(),
        body: SingleChildScrollView(
          controller: controller,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 70,
                  color: const Color.fromARGB(255, 222, 222, 226)
                      .withOpacity(0.25),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (navigatorKey.currentState!.canPop()) {
                                  Get.back();
                                } else {
                                  navigatorKey.currentState!
                                      .pushReplacement(MaterialPageRoute(
                                    builder: (context) => const UpgradePlan(),
                                  ));
                                }
                              },
                              child: SizedBox(
                                width: 25,
                                height: 40,
                                child: SvgPicture.asset(
                                  "assets/arrowback.svg",
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(AppLocalizations.of(context)!.exploreMatches,
                                style: CustomTextStyle.bodytextLarge),
                          ],
                        ),
                        // rgba(5, 28, 60, 1) rgba(255, 199, 56, 1) rgba(251, 214, 60, 1)
                        GestureDetector(
                          onTap: () {
                            analytics.logEvent(
                                name: "Explore_App_Upgrade_Plan_Button_Click");
                            facebookAppEvents.logEvent(
                                name:
                                    "FB_Explore_App_Upgrade_Plan_Button_Click");
                            showDialog(
                              barrierDismissible:
                                  true, // Allows dismissing the dialog by tapping outside
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        2), // Reduce the radius here
                                  ),
                                  insetPadding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 50),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              5)), // Match the dialog's border radius
                                    ),
                                    // Adjust width to take nearly the full screen width

                                    child: const PlanSlideSheet(
                                      memberId: 0,
                                    ), // Embed the PlansSlider here
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                color: const Color.fromARGB(255, 5, 28, 60),
                                border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 251, 214, 60))),
                            height: 36,
                            width: 115,
                            child: Center(// This centers the text
                                child: Obx(
                              () {
                                if (_premiumPlanController
                                    .planListOffer.isNotEmpty) {
                                  return Text(
                                    language == "en"
                                        ? "Grab Offer!!"
                                        : "ऑफर मिळवा!!",
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 255, 199, 56),
                                    ),
                                  );
                                } else {
                                  return Text(
                                    language == "en"
                                        ? "Grab Offer!!"
                                        : "ऑफर मिळवा!!",
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 255, 199, 56),
                                    ),
                                  );
                                }
                              },
                            )),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                // Horizontal scrolling section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // # Profile Visitors
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Obx(() {
                        if (_dashboardController
                            .profileVisitorsFetching.value) {
                          return SizedBox(
                            height: 221,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 8,
                              itemBuilder: (context, index) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                                  255, 80, 93, 127)
                                              .withOpacity(0.2),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Center(
                                              child: CircleAvatar(
                                                backgroundColor: Colors.grey,
                                                radius: 45,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Center(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    width: 80,
                                                    height: 16,
                                                    color: Colors.grey,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  SizedBox(
                                                    height: 15,
                                                    width: 15,
                                                    child: Container(
                                                        color: Colors.grey),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Center(
                                              child: Container(
                                                width: 100,
                                                height: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Center(
                                              child: Container(
                                                width: 100,
                                                height: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Image.asset(
                                                    height: 12,
                                                    "assets/heartoutlined.png"),
                                                const SizedBox(width: 5),
                                                Text(
                                                  language == "en"
                                                      ? "Connect Now"
                                                      : "इंटरेस्ट पाठवा",
                                                  style: const TextStyle(
                                                      color: Colors.red),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          if (_dashboardController.profilevisitors.isEmpty) {
                            return const SizedBox();
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.profileVisitors,
                                  // "Profile Visitors",
                                  style: CustomTextStyle.title,
                                ),
                                Text(
                                  language == "en"
                                      ? "Your profile got a visitor! Take a look and see if they interest you."
                                      : "तुमच्या प्रोफाईलला बऱ्याच सदस्यांनी भेट दिली आहे. कृपया त्यांचे प्रोफाईल्स बघा आणि आवडल्यास इंटरेस्ट पाठवा.",
                                  style: CustomTextStyle.bodytextSmall,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 260,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _dashboardController
                                                .profilevisitors.length >
                                            5
                                        ? 6
                                        : _dashboardController
                                            .profilevisitors.length,
                                    itemBuilder: (context, index) {
                                      //  print("THis is visitor ${visitor}");
                                      // Your actual visitor card widget goes here
                                      if (_dashboardController
                                              .profilevisitors.length >
                                          5) {
                                        /*      final FilterList = _dashboardController.recentMatches.sublist(0,6);
                                                if(index < FilterList.length - 1 ){
                                              final match = FilterList[index];*/
                                        final FilterList = _dashboardController
                                            .profilevisitors
                                            .sublist(0, 6);

                                        if (index < FilterList.length - 1) {
                                          final visitor = FilterList[index];

                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0,
                                                left: 8,
                                                right: 0,
                                                top: 8),
                                            child: GestureDetector(
                                              onTap: () async {
                                                try {
                                                  print('Checking for Update');
                                                  AppUpdateInfo info =
                                                      await InAppUpdate
                                                          .checkForUpdate();

                                                  if (info.updateAvailability ==
                                                      UpdateAvailability
                                                          .updateAvailable) {
                                                    print('Update available');
                                                    await update();
                                                  } else {
                                                    print(
                                                        'No update available');
                                                    // _dashboardController.onItemTapped(value);
                                                    showDialog(
                                                      barrierDismissible:
                                                          true, // Allows dismissing the dialog by tapping outside
                                                      context: context,
                                                      builder: (context) {
                                                        return Dialog(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        2), // Reduce the radius here
                                                          ),
                                                          insetPadding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      18,
                                                                  vertical: 50),
                                                          child: Container(
                                                            decoration:
                                                                const BoxDecoration(
                                                              color: Colors
                                                                  .transparent,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5)), // Match the dialog's border radius
                                                            ),
                                                            // Adjust width to take nearly the full screen width

                                                            child:
                                                                PlanSlideSheet(
                                                              memberId: visitor[
                                                                  "member_id"],
                                                            ), // Embed the PlansSlider here
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }
                                                } catch (e) {
                                                  print(
                                                      'Error checking for update: ${e.toString()}');
                                                  showDialog(
                                                    barrierDismissible:
                                                        true, // Allows dismissing the dialog by tapping outside
                                                    context: context,
                                                    builder: (context) {
                                                      return Dialog(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  2), // Reduce the radius here
                                                        ),
                                                        insetPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 18,
                                                                vertical: 50),
                                                        child: Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Colors
                                                                .transparent,
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        5)), // Match the dialog's border radius
                                                          ),
                                                          // Adjust width to take nearly the full screen width

                                                          child: PlanSlideSheet(
                                                            memberId: visitor[
                                                                "member_id"],
                                                          ), // Embed the PlansSlider here
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                              child: Container(
                                                width: 150,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                  border: Border.all(
                                                    color: const Color.fromARGB(
                                                            255, 80, 93, 127)
                                                        .withOpacity(0.2),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Center(
                                                        child: Container(
                                                          width:
                                                              110, // Diameter of the circle
                                                          height:
                                                              110, // Diameter of the circle
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            image:
                                                                DecorationImage(
                                                              image:
                                                                  NetworkImage(
                                                                visitor["photoUrl"] ??
                                                                    "${Appconstants.baseURL}/public/storage/images/download.png",
                                                              ),
                                                              fit: BoxFit
                                                                  .cover, // Ensures the image covers the circle
                                                              alignment: Alignment
                                                                  .topCenter, // Aligns the image to the top
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Center(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "${visitor["member_profile_id"]}",
                                                              style: CustomTextStyle
                                                                  .bodytextbold,
                                                            ),
                                                            visitor["is_Document_Verification"] ==
                                                                    1
                                                                ? Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            4.0,
                                                                        top: 4),
                                                                    child:
                                                                        SizedBox(
                                                                      height:
                                                                          13,
                                                                      width: 13,
                                                                      child: Image
                                                                          .asset(
                                                                              "assets/verified.png"),
                                                                    ),
                                                                  )
                                                                : const SizedBox()
                                                          ],
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Center(
                                                        child: Text(
                                                          "${visitor["age"]} Yrs, ${visitor["height"]},",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: CustomTextStyle
                                                              .bodytext
                                                              .copyWith(
                                                                  fontSize: 12),
                                                        ),
                                                      ),
                                                      Center(
                                                        child: Text(
                                                          "${visitor["present_city_name"]}, ${visitor["marital_status"]}",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: CustomTextStyle
                                                              .bodytext
                                                              .copyWith(
                                                                  fontSize: 12),
                                                        ),
                                                      ),
                                                      Center(
                                                        child: Text(
                                                          "${visitor["education"]}",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: CustomTextStyle
                                                              .bodytext
                                                              .copyWith(
                                                                  fontSize: 12),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Image.asset(
                                                              height: 12,
                                                              "assets/heartoutlined.png"),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                            language == "en"
                                                                ? "Connect Now"
                                                                : "इंटरेस्ट पाठवा",
                                                            style: CustomTextStyle
                                                                .textbuttonRed,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          //   final BottomNavController bottomNavController = Get.put(BottomNavController());
                                          final visitor = FilterList[index];

                                          return Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: GestureDetector(
                                              onTap: () async {
                                                try {
                                                  print('Checking for Update');
                                                  AppUpdateInfo info =
                                                      await InAppUpdate
                                                          .checkForUpdate();

                                                  if (info.updateAvailability ==
                                                      UpdateAvailability
                                                          .updateAvailable) {
                                                    print('Update available');
                                                    await update();
                                                  } else {
                                                    print(
                                                        'No update available');
                                                    // _dashboardController.onItemTapped(value);

                                                    showDialog(
                                                      barrierDismissible:
                                                          true, // Allows dismissing the dialog by tapping outside
                                                      context: context,
                                                      builder: (context) {
                                                        return Dialog(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        2), // Reduce the radius here
                                                          ),
                                                          insetPadding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      18,
                                                                  vertical: 50),
                                                          child: Container(
                                                            decoration:
                                                                const BoxDecoration(
                                                              color: Colors
                                                                  .transparent,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5)), // Match the dialog's border radius
                                                            ),
                                                            // Adjust width to take nearly the full screen width

                                                            child:
                                                                PlanSlideSheet(
                                                              memberId: visitor[
                                                                  "member_id"],
                                                            ), // Embed the PlansSlider here
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }
                                                } catch (e) {
                                                  print(
                                                      'Error checking for update: ${e.toString()}');
                                                  showDialog(
                                                    barrierDismissible:
                                                        true, // Allows dismissing the dialog by tapping outside
                                                    context: context,
                                                    builder: (context) {
                                                      return Dialog(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  2), // Reduce the radius here
                                                        ),
                                                        insetPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 18,
                                                                vertical: 50),
                                                        child: Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Colors
                                                                .transparent,
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        5)), // Match the dialog's border radius
                                                          ),
                                                          // Adjust width to take nearly the full screen width

                                                          child: PlanSlideSheet(
                                                            memberId: visitor[
                                                                "member_id"],
                                                          ), // Embed the PlansSlider here
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    width: 150,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  10)),
                                                      border: Border.all(
                                                        color: const Color
                                                                .fromARGB(255,
                                                                80, 93, 127)
                                                            .withOpacity(0.2),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Center(
                                                            child: Container(
                                                              width:
                                                                  110, // Diameter of the circle
                                                              height:
                                                                  110, // Diameter of the circle
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      NetworkImage(
                                                                    visitor["photoUrl"] ??
                                                                        "${Appconstants.baseURL}/public/storage/images/download.png",
                                                                  ),
                                                                  fit: BoxFit
                                                                      .cover, // Ensures the image covers the circle
                                                                  alignment:
                                                                      Alignment
                                                                          .topCenter, // Aligns the image to the top
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          Center(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "${visitor["member_profile_id"]}",
                                                                  style: CustomTextStyle
                                                                      .bodytextbold,
                                                                ),
                                                                visitor["is_Document_Verification"] ==
                                                                        1
                                                                    ? Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                4.0,
                                                                            top:
                                                                                4),
                                                                        child:
                                                                            SizedBox(
                                                                          height:
                                                                              13,
                                                                          width:
                                                                              13,
                                                                          child:
                                                                              Image.asset("assets/verified.png"),
                                                                        ),
                                                                      )
                                                                    : const SizedBox()
                                                              ],
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                          Center(
                                                            child: Text(
                                                              "${visitor["age"]} Yrs, ${visitor["height"]},",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: CustomTextStyle
                                                                  .bodytext
                                                                  .copyWith(
                                                                      fontSize:
                                                                          12),
                                                            ),
                                                          ),
                                                          Center(
                                                            child: Text(
                                                              "${visitor["present_city_name"]}, ${visitor["marital_status"]}",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: CustomTextStyle
                                                                  .bodytext
                                                                  .copyWith(
                                                                      fontSize:
                                                                          12),
                                                            ),
                                                          ),
                                                          Center(
                                                            child: Text(
                                                              "${visitor["education"]}",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: CustomTextStyle
                                                                  .bodytext
                                                                  .copyWith(
                                                                      fontSize:
                                                                          12),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Image.asset(
                                                                  height: 12,
                                                                  "assets/heartoutlined.png"),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Text(
                                                                language == "en"
                                                                    ? "Connect Now"
                                                                    : "इंटरेस्ट पाठवा",
                                                                style: CustomTextStyle
                                                                    .textbuttonRed,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  // Full overlay
                                                  Positioned.fill(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.black
                                                            .withOpacity(
                                                                0.7), // Dark overlay with opacity
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Center(
                                                          child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(18.0),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            Center(
                                                              child: Text(
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                "So many visitors for your profile!",
                                                                style: CustomTextStyle
                                                                    .bodytextbold
                                                                    .copyWith(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Center(
                                                              child: Text(
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                language == "en"
                                                                    ? "View All!!"
                                                                    : 'सर्व प्रोफाईल्स बघा',
                                                                style: CustomTextStyle
                                                                    .bodytextbold
                                                                    .copyWith(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                      } else {
                                        final visitor = _dashboardController
                                            .profilevisitors[index];

                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0,
                                              left: 8,
                                              right: 0,
                                              top: 8),
                                          child: GestureDetector(
                                            onTap: () async {
                                              try {
                                                print('Checking for Update');
                                                AppUpdateInfo info =
                                                    await InAppUpdate
                                                        .checkForUpdate();

                                                if (info.updateAvailability ==
                                                    UpdateAvailability
                                                        .updateAvailable) {
                                                  print('Update available');
                                                  await update();
                                                } else {
                                                  print('No update available');
                                                  // _dashboardController.onItemTapped(value);
                                                  showDialog(
                                                    barrierDismissible:
                                                        true, // Allows dismissing the dialog by tapping outside
                                                    context: context,
                                                    builder: (context) {
                                                      return Dialog(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  2), // Reduce the radius here
                                                        ),
                                                        insetPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 18,
                                                                vertical: 50),
                                                        child: Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Colors
                                                                .transparent,
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        5)), // Match the dialog's border radius
                                                          ),
                                                          // Adjust width to take nearly the full screen width

                                                          child: PlanSlideSheet(
                                                            memberId: visitor[
                                                                "member_id"],
                                                          ), // Embed the PlansSlider here
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }
                                              } catch (e) {
                                                print(
                                                    'Error checking for update: ${e.toString()}');
                                                showDialog(
                                                  barrierDismissible:
                                                      true, // Allows dismissing the dialog by tapping outside
                                                  context: context,
                                                  builder: (context) {
                                                    return Dialog(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                2), // Reduce the radius here
                                                      ),
                                                      insetPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 18,
                                                              vertical: 50),
                                                      child: Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Colors
                                                              .transparent,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      5)), // Match the dialog's border radius
                                                        ),
                                                        // Adjust width to take nearly the full screen width

                                                        child: PlanSlideSheet(
                                                          memberId: visitor[
                                                              "member_id"],
                                                        ), // Embed the PlansSlider here
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                            child: Container(
                                              width: 150,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                border: Border.all(
                                                  color: const Color.fromARGB(
                                                          255, 80, 93, 127)
                                                      .withOpacity(0.2),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Center(
                                                      child: Container(
                                                        width:
                                                            110, // Diameter of the circle
                                                        height:
                                                            110, // Diameter of the circle
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                              visitor["photoUrl"] ??
                                                                  "${Appconstants.baseURL}/public/storage/images/download.png",
                                                            ),
                                                            fit: BoxFit
                                                                .cover, // Ensures the image covers the circle
                                                            alignment: Alignment
                                                                .topCenter, // Aligns the image to the top
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Center(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "${visitor["member_profile_id"]}",
                                                            style: CustomTextStyle
                                                                .bodytextbold,
                                                          ),
                                                          visitor["is_Document_Verification"] ==
                                                                  1
                                                              ? Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              4.0,
                                                                          top:
                                                                              4),
                                                                  child:
                                                                      SizedBox(
                                                                    height: 13,
                                                                    width: 13,
                                                                    child: Image
                                                                        .asset(
                                                                            "assets/verified.png"),
                                                                  ),
                                                                )
                                                              : const SizedBox()
                                                        ],
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Center(
                                                      child: Text(
                                                        "${visitor["age"]} Yrs, ${visitor["height"]},",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: CustomTextStyle
                                                            .bodytext
                                                            .copyWith(
                                                                fontSize: 12),
                                                      ),
                                                    ),
                                                    Center(
                                                      child: Text(
                                                        "${visitor["present_city_name"]}, ${visitor["marital_status"]}",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: CustomTextStyle
                                                            .bodytext
                                                            .copyWith(
                                                                fontSize: 12),
                                                      ),
                                                    ),
                                                    Center(
                                                      child: Text(
                                                        "${visitor["education"]}",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: CustomTextStyle
                                                            .bodytext
                                                            .copyWith(
                                                                fontSize: 12),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Image.asset(
                                                            height: 12,
                                                            "assets/heartoutlined.png"),
                                                        const SizedBox(
                                                            width: 5),
                                                        Text(
                                                          language == "en"
                                                              ? "Connect Now"
                                                              : "इंटरेस्ट पाठवा",
                                                          style: CustomTextStyle
                                                              .textbuttonRed,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                )
                              ],
                            );
                          }
                        }
                      }),
                    ),

                    // # Accept Interest List
                    // var intrestreceivedList = [].obs;
                    /*
        var intrestreceivedhasMore = true.obs;
        var intrestReceivedfetching = true.obs;
        var intrestreceivedPage= 1.obs;
      
       */
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          barrierDismissible:
                              true, // Allows dismissing the dialog by tapping outside
                          context: context,
                          builder: (context) {
                            return Dialog(
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    2), // Reduce the radius here
                              ),
                              insetPadding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 50),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.all(Radius.circular(
                                      5)), // Match the dialog's border radius
                                ),
                                // Adjust width to take nearly the full screen width

                                child: const PlanSlideSheet(
                                    memberId: 0), // Embed the PlansSlider here
                              ),
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                5.0), // Set the corner radius
                            child: Image.network(
                              "${"${Appconstants.baseURL}/image/plan-offer-img1/$memberId"}?lang=$language",
                              // height: 200,
                              width: double.infinity,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const SizedBox();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Obx(() {
                        if (_dashboardController
                            .intrestReceivedfetching.value) {
                          return SizedBox(
                            height: 320,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 8,
                              itemBuilder: (context, index) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      width: 200,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        color:
                                            Colors.white, // Placeholder color
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            flex: 6,
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10)),
                                                color: Colors
                                                    .white, // Placeholder color
                                              ),
                                              width: 200,
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(
                                                                10)),
                                                child: Container(
                                                  color: Colors.grey[
                                                      300], // Placeholder color for image
                                                ),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 4,
                                            child: Container(
                                              width: 300,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10)),
                                                color: Color.fromARGB(
                                                    255, 235, 237, 239),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: 15,
                                                      color: Colors.grey[
                                                          300], // Placeholder for text
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Container(
                                                      height: 12,
                                                      color: Colors.grey[
                                                          300], // Placeholder for text
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          height: 12,
                                                          width: 60,
                                                          color: Colors.grey[
                                                              300], // Placeholder for text
                                                        ),
                                                        const SizedBox(
                                                            width: 4),
                                                        Container(
                                                          width: 1.0,
                                                          height: 12.0,
                                                          color: const Color
                                                              .fromARGB(
                                                              255,
                                                              80,
                                                              93,
                                                              126), // Color of the separator
                                                        ),
                                                        const SizedBox(
                                                            width: 4),
                                                        Container(
                                                          height: 12,
                                                          width: 80,
                                                          color: Colors.grey[
                                                              300], // Placeholder for text
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Container(
                                                      height: 12,
                                                      color: Colors.grey[
                                                          300], // Placeholder for text
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          height: 12,
                                                          width: 100,
                                                          color: Colors.grey[
                                                              300], // Placeholder for text
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          if (_dashboardController
                              .intrestreceivedList.isEmpty) {
                            return const SizedBox();
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  language == "en"
                                      ? "A New Connection Awaits!!"
                                      : "तुमच्या प्रोफाईलमध्ये इंटरेस्ट दाखवलेले सदस्य!",
                                  style: CustomTextStyle.title,
                                ),
                                Text(
                                  language == "en"
                                      ? "You've got someone interested! View their profile now."
                                      : "नवीन नाते बहरण्याची शक्यता आहे. आताच प्रोफाईल बघा!",
                                  style: CustomTextStyle.bodytextSmall,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height:
                                      340, // Specify a fixed height for the ListView
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _dashboardController
                                                .intrestreceivedList.length >
                                            5
                                        ? 6
                                        : _dashboardController
                                            .intrestreceivedList.length,
                                    itemBuilder: (context, index) {
                                      //    print("Match is ${match}");
                                      if (_dashboardController
                                              .intrestreceivedList.length >
                                          5) {
                                        final FilterList = _dashboardController
                                            .intrestreceivedList
                                            .sublist(0, 6);
                                        if (index < FilterList.length - 1) {
                                          final match = FilterList[index];
                                          return Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: GestureDetector(
                                              onTap: () async {
                                                try {
                                                  print('Checking for Update');
                                                  AppUpdateInfo info =
                                                      await InAppUpdate
                                                          .checkForUpdate();

                                                  if (info.updateAvailability ==
                                                      UpdateAvailability
                                                          .updateAvailable) {
                                                    print('Update available');
                                                    await update();
                                                  } else {
                                                    print(
                                                        'No update available');
                                                    // _dashboardController.onItemTapped(value);
                                                    showDialog(
                                                      barrierDismissible:
                                                          true, // Allows dismissing the dialog by tapping outside
                                                      context: context,
                                                      builder: (context) {
                                                        return Dialog(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        2), // Reduce the radius here
                                                          ),
                                                          insetPadding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      18,
                                                                  vertical: 50),
                                                          child: Container(
                                                            decoration:
                                                                const BoxDecoration(
                                                              color: Colors
                                                                  .transparent,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5)), // Match the dialog's border radius
                                                            ),
                                                            // Adjust width to take nearly the full screen width

                                                            child:
                                                                PlanSlideSheet(
                                                              memberId: match[
                                                                  "member_id"],
                                                            ), // Embed the PlansSlider here
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }
                                                } catch (e) {
                                                  print(
                                                      'Error checking for update: ${e.toString()}');
                                                  showDialog(
                                                    barrierDismissible:
                                                        true, // Allows dismissing the dialog by tapping outside
                                                    context: context,
                                                    builder: (context) {
                                                      return Dialog(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  2), // Reduce the radius here
                                                        ),
                                                        insetPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 18,
                                                                vertical: 50),
                                                        child: Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Colors
                                                                .transparent,
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        5)), // Match the dialog's border radius
                                                          ),
                                                          // Adjust width to take nearly the full screen width

                                                          child: PlanSlideSheet(
                                                            memberId: match[
                                                                "member_id"],
                                                          ), // Embed the PlansSlider here
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                              child: Container(
                                                width: 240,
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Flexible(
                                                      flex: 5,
                                                      child: Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10),
                                                          ),
                                                        ),
                                                        width: 240,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10),
                                                          ),
                                                          child: Image.network(
                                                            match['photoUrl'] ??
                                                                "${Appconstants.baseURL}/public/storage/images/download.png",
                                                            fit: BoxFit.cover,
                                                            width:
                                                                double.infinity,
                                                            height:
                                                                double.infinity,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      flex: 3,
                                                      child: Container(
                                                        width: 240,
                                                        decoration:
                                                            const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          10)),
                                                          color: Color.fromARGB(
                                                              255,
                                                              235,
                                                              237,
                                                              239),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              RichText(
                                                                text: TextSpan(
                                                                    children: [
                                                                      // rgba(80, 93, 126, 1)
                                                                      TextSpan(
                                                                          text: language == "en"
                                                                              ? "Member ID - "
                                                                              : "मेंबर आयडी - ",
                                                                          style: const TextStyle(
                                                                              fontFamily: "WORKSANS",
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Color.fromARGB(255, 80, 93, 126))),
                                                                      TextSpan(
                                                                          text:
                                                                              "${match["member_profile_id"]}",
                                                                          style: const TextStyle(
                                                                              fontFamily: "WORKSANSBOLD",
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Color.fromARGB(255, 80, 93, 126)))
                                                                    ]),
                                                              ),
                                                              Center(
                                                                child: Text(
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  language ==
                                                                          "en"
                                                                      ? "Hello, I like your Profile. Accept my request if my profile interests you too."
                                                                      : "मला तुमची प्रोफाईल आवडली. तुम्हालाही माझ्या प्रोफाईल मध्ये इंटरेस्ट असल्यास माझा इंटरेस्ट स्वीकारा.",
                                                                  style: CustomTextStyle
                                                                      .bodytextSmall
                                                                      .copyWith(
                                                                          fontSize:
                                                                              12),
                                                                ),
                                                              ),
                                                              const Divider(),
                                                              Center(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Flexible(
                                                                      child:
                                                                          SizedBox(
                                                                        width: double
                                                                            .infinity,
                                                                        child: TextButton
                                                                            .icon(
                                                                          onPressed:
                                                                              () {
                                                                            // Handle button 1 action
                                                                            showDialog(
                                                                              barrierDismissible: true, // Allows dismissing the dialog by tapping outside
                                                                              context: context,
                                                                              builder: (context) {
                                                                                return Dialog(
                                                                                  backgroundColor: Colors.transparent,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(2), // Reduce the radius here
                                                                                  ),
                                                                                  insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 50),
                                                                                  child: Container(
                                                                                    decoration: const BoxDecoration(
                                                                                      color: Colors.transparent,
                                                                                      borderRadius: BorderRadius.all(Radius.circular(5)), // Match the dialog's border radius
                                                                                    ),
                                                                                    // Adjust width to take nearly the full screen width

                                                                                    child: PlanSlideSheet(
                                                                                      memberId: match["member_id"],
                                                                                    ), // Embed the PlansSlider here
                                                                                  ),
                                                                                );
                                                                              },
                                                                            );
                                                                          },
                                                                          icon: Image.asset(
                                                                              height: 15,
                                                                              "assets/decline.png"),
                                                                          label: Text(
                                                                              AppLocalizations.of(context)!.decline,
                                                                              style: CustomTextStyle.bodytext.copyWith(fontSize: 15)),
                                                                          style:
                                                                              TextButton.styleFrom(
                                                                            padding:
                                                                                EdgeInsets.zero,
                                                                            minimumSize:
                                                                                const Size(0, 0),
                                                                            tapTargetSize:
                                                                                MaterialTapTargetSize.shrinkWrap,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width:
                                                                          1, // Width of the line
                                                                      height:
                                                                          15, // Height of the line
                                                                      color: Colors
                                                                          .grey, // Line color
                                                                      margin: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              10), // Space around the line
                                                                    ),
                                                                    Flexible(
                                                                      child:
                                                                          SizedBox(
                                                                        width: double
                                                                            .infinity,
                                                                        child: TextButton
                                                                            .icon(
                                                                          onPressed:
                                                                              () {
                                                                            // Handle button 2 action
                                                                            showDialog(
                                                                              barrierDismissible: true, // Allows dismissing the dialog by tapping outside
                                                                              context: context,
                                                                              builder: (context) {
                                                                                return Dialog(
                                                                                  backgroundColor: Colors.transparent,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(2), // Reduce the radius here
                                                                                  ),
                                                                                  insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 50),
                                                                                  child: Container(
                                                                                    decoration: const BoxDecoration(
                                                                                      color: Colors.transparent,
                                                                                      borderRadius: BorderRadius.all(Radius.circular(5)), // Match the dialog's border radius
                                                                                    ),
                                                                                    // Adjust width to take nearly the full screen width

                                                                                    child: PlanSlideSheet(
                                                                                      memberId: match["member_id"],
                                                                                    ), // Embed the PlansSlider here
                                                                                  ),
                                                                                );
                                                                              },
                                                                            );
                                                                          },
                                                                          icon: Image.asset(
                                                                              height: 15,
                                                                              "assets/accept.png"),
                                                                          label: Text(
                                                                              AppLocalizations.of(context)!.accept,
                                                                              style: CustomTextStyle.bodytextbold.copyWith(fontSize: 15)),
                                                                          style:
                                                                              TextButton.styleFrom(
                                                                            padding:
                                                                                EdgeInsets.zero,
                                                                            minimumSize:
                                                                                const Size(0, 0),
                                                                            tapTargetSize:
                                                                                MaterialTapTargetSize.shrinkWrap,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          final match = FilterList[index];

                                          return Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: GestureDetector(
                                              onTap: () async {
                                                try {
                                                  print('Checking for Update');
                                                  AppUpdateInfo info =
                                                      await InAppUpdate
                                                          .checkForUpdate();

                                                  if (info.updateAvailability ==
                                                      UpdateAvailability
                                                          .updateAvailable) {
                                                    print('Update available');
                                                    await update();
                                                  } else {
                                                    print(
                                                        'No update available');

                                                    showDialog(
                                                      barrierDismissible:
                                                          true, // Allows dismissing the dialog by tapping outside
                                                      context: context,
                                                      builder: (context) {
                                                        return Dialog(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        2), // Reduce the radius here
                                                          ),
                                                          insetPadding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      18,
                                                                  vertical: 50),
                                                          child: Container(
                                                            decoration:
                                                                const BoxDecoration(
                                                              color: Colors
                                                                  .transparent,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5)), // Match the dialog's border radius
                                                            ),
                                                            // Adjust width to take nearly the full screen width

                                                            child:
                                                                PlanSlideSheet(
                                                              memberId: match[
                                                                  "member_id"],
                                                            ), // Embed the PlansSlider here
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }
                                                } catch (e) {
                                                  print(
                                                      'Error checking for update: ${e.toString()}');
                                                  showDialog(
                                                    barrierDismissible:
                                                        true, // Allows dismissing the dialog by tapping outside
                                                    context: context,
                                                    builder: (context) {
                                                      return Dialog(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  2), // Reduce the radius here
                                                        ),
                                                        insetPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 18,
                                                                vertical: 50),
                                                        child: Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Colors
                                                                .transparent,
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        5)), // Match the dialog's border radius
                                                          ),
                                                          // Adjust width to take nearly the full screen width

                                                          child: PlanSlideSheet(
                                                            memberId: match[
                                                                "member_id"],
                                                          ), // Embed the PlansSlider here
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    width: 240,
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Flexible(
                                                          flex: 5,
                                                          child: Container(
                                                            decoration:
                                                                const BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10),
                                                              ),
                                                            ),
                                                            width: 240,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10),
                                                              ),
                                                              child:
                                                                  Image.network(
                                                                match['photoUrl'] ??
                                                                    "${Appconstants.baseURL}/public/storage/images/download.png",
                                                                fit: BoxFit
                                                                    .cover,
                                                                width: double
                                                                    .infinity,
                                                                height: double
                                                                    .infinity,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Flexible(
                                                          flex: 3,
                                                          child: Container(
                                                            width: 240,
                                                            decoration:
                                                                const BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          10)),
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      235,
                                                                      237,
                                                                      239),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  RichText(
                                                                    text: TextSpan(
                                                                        children: [
                                                                          // rgba(80, 93, 126, 1)
                                                                          TextSpan(
                                                                              text: language == "en" ? "Member ID - " : "मेंबर आयडी - ",
                                                                              style: const TextStyle(fontFamily: "WORKSANS", fontSize: 14, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 80, 93, 126))),
                                                                          TextSpan(
                                                                              text: "${match["member_profile_id"]}",
                                                                              style: const TextStyle(fontFamily: "WORKSANSBOLD", fontSize: 14, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 80, 93, 126)))
                                                                        ]),
                                                                  ),
                                                                  Text(
                                                                    language ==
                                                                            "en"
                                                                        ? "Hello, I like your Profile. Accept my request if my profile interests you too."
                                                                        : "मला तुमची प्रोफाईल आवडली. तुम्हालाही माझ्या प्रोफाईल मध्ये इंटरेस्ट असल्यास माझा इंटरेस्ट स्वीकारा.",
                                                                    style: CustomTextStyle
                                                                        .bodytextSmall
                                                                        .copyWith(
                                                                            fontSize:
                                                                                12),
                                                                  ),
                                                                  const Divider(),
                                                                  Center(
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Flexible(
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                double.infinity,
                                                                            child:
                                                                                TextButton.icon(
                                                                              onPressed: () {
                                                                                // Handle button 1 action
                                                                                showDialog(
                                                                                  barrierDismissible: true, // Allows dismissing the dialog by tapping outside
                                                                                  context: context,
                                                                                  builder: (context) {
                                                                                    return Dialog(
                                                                                      backgroundColor: Colors.transparent,
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(2), // Reduce the radius here
                                                                                      ),
                                                                                      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 50),
                                                                                      child: Container(
                                                                                        decoration: const BoxDecoration(
                                                                                          color: Colors.transparent,
                                                                                          borderRadius: BorderRadius.all(Radius.circular(5)), // Match the dialog's border radius
                                                                                        ),
                                                                                        // Adjust width to take nearly the full screen width

                                                                                        child: PlanSlideSheet(
                                                                                          memberId: match["member_id"],
                                                                                        ), // Embed the PlansSlider here
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                );
                                                                              },
                                                                              icon: Image.asset(height: 15, "assets/decline.png"),
                                                                              label: Text(AppLocalizations.of(context)!.decline, style: CustomTextStyle.bodytext.copyWith(fontSize: 15)),
                                                                              style: TextButton.styleFrom(
                                                                                padding: EdgeInsets.zero,
                                                                                minimumSize: const Size(0, 0),
                                                                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              1, // Width of the line
                                                                          height:
                                                                              15, // Height of the line
                                                                          color:
                                                                              Colors.grey, // Line color
                                                                          margin: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 10), // Space around the line
                                                                        ),
                                                                        Flexible(
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                double.infinity,
                                                                            child:
                                                                                TextButton.icon(
                                                                              onPressed: () {
                                                                                // Handle button 2 action
                                                                                showDialog(
                                                                                  barrierDismissible: true, // Allows dismissing the dialog by tapping outside
                                                                                  context: context,
                                                                                  builder: (context) {
                                                                                    return Dialog(
                                                                                      backgroundColor: Colors.transparent,
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(2), // Reduce the radius here
                                                                                      ),
                                                                                      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 50),
                                                                                      child: Container(
                                                                                        decoration: const BoxDecoration(
                                                                                          color: Colors.transparent,
                                                                                          borderRadius: BorderRadius.all(Radius.circular(5)), // Match the dialog's border radius
                                                                                        ),
                                                                                        // Adjust width to take nearly the full screen width

                                                                                        child: PlanSlideSheet(
                                                                                          memberId: match["member_id"],
                                                                                        ), // Embed the PlansSlider here
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                );
                                                                              },
                                                                              icon: Image.asset(height: 15, "assets/accept.png"),
                                                                              label: Text(AppLocalizations.of(context)!.accept, style: CustomTextStyle.bodytextbold.copyWith(fontSize: 15)),
                                                                              style: TextButton.styleFrom(
                                                                                padding: EdgeInsets.zero,
                                                                                minimumSize: const Size(0, 0),
                                                                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  // Full overlay
                                                  Positioned.fill(
                                                    child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.7), // Dark overlay with opacity
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(18.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Center(
                                                                child: Text(
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  "Interested Profiles are waiting for you!",
                                                                  style: CustomTextStyle
                                                                      .bodytextbold
                                                                      .copyWith(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                ),
                                                              ),
                                                              Center(
                                                                child: Text(
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  "Explore More Profiles!",
                                                                  style: CustomTextStyle
                                                                      .bodytextbold
                                                                      .copyWith(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                      } else {
                                        final match = _dashboardController
                                            .intrestreceivedList[index];

                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: GestureDetector(
                                            onTap: () async {
                                              try {
                                                print('Checking for Update');
                                                AppUpdateInfo info =
                                                    await InAppUpdate
                                                        .checkForUpdate();

                                                if (info.updateAvailability ==
                                                    UpdateAvailability
                                                        .updateAvailable) {
                                                  print('Update available');
                                                  await update();
                                                } else {
                                                  print('No update available');
                                                  // _dashboardController.onItemTapped(value);
                                                  showDialog(
                                                    barrierDismissible:
                                                        true, // Allows dismissing the dialog by tapping outside
                                                    context: context,
                                                    builder: (context) {
                                                      return Dialog(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  2), // Reduce the radius here
                                                        ),
                                                        insetPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 18,
                                                                vertical: 50),
                                                        child: Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Colors
                                                                .transparent,
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        5)), // Match the dialog's border radius
                                                          ),
                                                          // Adjust width to take nearly the full screen width

                                                          child: PlanSlideSheet(
                                                            memberId: match[
                                                                "member_id"],
                                                          ), // Embed the PlansSlider here
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }
                                              } catch (e) {
                                                print(
                                                    'Error checking for update: ${e.toString()}');
                                                showDialog(
                                                  barrierDismissible:
                                                      true, // Allows dismissing the dialog by tapping outside
                                                  context: context,
                                                  builder: (context) {
                                                    return Dialog(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                2), // Reduce the radius here
                                                      ),
                                                      insetPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 18,
                                                              vertical: 50),
                                                      child: Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Colors
                                                              .transparent,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      5)), // Match the dialog's border radius
                                                        ),
                                                        // Adjust width to take nearly the full screen width

                                                        child: PlanSlideSheet(
                                                          memberId: match[
                                                              "member_id"],
                                                        ), // Embed the PlansSlider here
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                            child: Container(
                                              width: 240,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Flexible(
                                                    flex: 5,
                                                    child: Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                        ),
                                                      ),
                                                      width: 240,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                        ),
                                                        child: Image.network(
                                                          match['photoUrl'] ??
                                                              "${Appconstants.baseURL}/public/storage/images/download.png",
                                                          fit: BoxFit.cover,
                                                          width:
                                                              double.infinity,
                                                          height:
                                                              double.infinity,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    flex: 3,
                                                    child: Container(
                                                      width: 240,
                                                      decoration:
                                                          const BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            10)),
                                                        color: Color.fromARGB(
                                                            255, 235, 237, 239),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            RichText(
                                                              text: TextSpan(
                                                                  children: [
                                                                    // rgba(80, 93, 126, 1)
                                                                    TextSpan(
                                                                        text: language == "en"
                                                                            ? "Member ID - "
                                                                            : "मेंबर आयडी - ",
                                                                        style: const TextStyle(
                                                                            fontFamily:
                                                                                "WORKSANS",
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight: FontWeight
                                                                                .w500,
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                80,
                                                                                93,
                                                                                126))),
                                                                    TextSpan(
                                                                        text:
                                                                            "${match["member_profile_id"]}",
                                                                        style: const TextStyle(
                                                                            fontFamily:
                                                                                "WORKSANSBOLD",
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight: FontWeight
                                                                                .w500,
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                80,
                                                                                93,
                                                                                126)))
                                                                  ]),
                                                            ),
                                                            Text(
                                                              language == "en"
                                                                  ? "Hello, I like your Profile. Accept my request if my profile interests you too."
                                                                  : "मला तुमची प्रोफाईल आवडली. तुम्हालाही माझ्या प्रोफाईल मध्ये इंटरेस्ट असल्यास माझा इंटरेस्ट स्वीकारा.",
                                                              style: CustomTextStyle
                                                                  .bodytextSmall
                                                                  .copyWith(
                                                                      fontSize:
                                                                          12),
                                                            ),
                                                            const Divider(),
                                                            Center(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Flexible(
                                                                    child:
                                                                        SizedBox(
                                                                      width: double
                                                                          .infinity,
                                                                      child: TextButton
                                                                          .icon(
                                                                        onPressed:
                                                                            () {
                                                                          // Handle button 1 action
                                                                          showDialog(
                                                                            barrierDismissible:
                                                                                true, // Allows dismissing the dialog by tapping outside
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (context) {
                                                                              return Dialog(
                                                                                backgroundColor: Colors.transparent,
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(2), // Reduce the radius here
                                                                                ),
                                                                                insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 50),
                                                                                child: Container(
                                                                                  decoration: const BoxDecoration(
                                                                                    color: Colors.transparent,
                                                                                    borderRadius: BorderRadius.all(Radius.circular(5)), // Match the dialog's border radius
                                                                                  ),
                                                                                  // Adjust width to take nearly the full screen width

                                                                                  child: PlanSlideSheet(
                                                                                    memberId: match["member_id"],
                                                                                  ), // Embed the PlansSlider here
                                                                                ),
                                                                              );
                                                                            },
                                                                          );
                                                                        },
                                                                        icon: Image.asset(
                                                                            height:
                                                                                15,
                                                                            "assets/decline.png"),
                                                                        label: Text(
                                                                            AppLocalizations.of(context)!
                                                                                .decline,
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(fontSize: 15)),
                                                                        style: TextButton
                                                                            .styleFrom(
                                                                          padding:
                                                                              EdgeInsets.zero,
                                                                          minimumSize: const Size(
                                                                              0,
                                                                              0),
                                                                          tapTargetSize:
                                                                              MaterialTapTargetSize.shrinkWrap,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width:
                                                                        1, // Width of the line
                                                                    height:
                                                                        15, // Height of the line
                                                                    color: Colors
                                                                        .grey, // Line color
                                                                    margin: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            10), // Space around the line
                                                                  ),
                                                                  Flexible(
                                                                    child:
                                                                        SizedBox(
                                                                      width: double
                                                                          .infinity,
                                                                      child: TextButton
                                                                          .icon(
                                                                        onPressed:
                                                                            () {
                                                                          // Handle button 2 action
                                                                          showDialog(
                                                                            barrierDismissible:
                                                                                true, // Allows dismissing the dialog by tapping outside
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (context) {
                                                                              return Dialog(
                                                                                backgroundColor: Colors.transparent,
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(2), // Reduce the radius here
                                                                                ),
                                                                                insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 50),
                                                                                child: Container(
                                                                                  decoration: const BoxDecoration(
                                                                                    color: Colors.transparent,
                                                                                    borderRadius: BorderRadius.all(Radius.circular(5)), // Match the dialog's border radius
                                                                                  ),
                                                                                  // Adjust width to take nearly the full screen width

                                                                                  child: PlanSlideSheet(
                                                                                    memberId: match["member_id"],
                                                                                  ), // Embed the PlansSlider here
                                                                                ),
                                                                              );
                                                                            },
                                                                          );
                                                                        },
                                                                        icon: Image.asset(
                                                                            height:
                                                                                15,
                                                                            "assets/accept.png"),
                                                                        label: Text(
                                                                            AppLocalizations.of(context)!
                                                                                .accept,
                                                                            style:
                                                                                CustomTextStyle.bodytextbold.copyWith(fontSize: 15)),
                                                                        style: TextButton
                                                                            .styleFrom(
                                                                          padding:
                                                                              EdgeInsets.zero,
                                                                          minimumSize: const Size(
                                                                              0,
                                                                              0),
                                                                          tapTargetSize:
                                                                              MaterialTapTargetSize.shrinkWrap,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            );
                          }
                        }
                      }),
                    ),
                    // Vertical Recommended List
                    Obx(
                      () {
                        if (_dashboardController.exploreListList.isEmpty) {
                          print(
                              "TitleShown ${_dashboardController.exploreListList.isEmpty}");
                          return const SizedBox();
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  language == "en"
                                      ? "Recommended Profiles"
                                      : "तुमच्यासाठी सुचवलेल्या प्रोफाईल्स",
                                  style: CustomTextStyle.title,
                                ),
                                Text(
                                  language == "en"
                                      ? "Discover a recommended profile! See if they meet your expectations."
                                      : "तुमच्यासाठी सुचवलेल्या प्रोफाईल्स बघा आणि शोधा तुमचा योग्य जोडीदार!",
                                  style: CustomTextStyle.bodytextSmall,
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                    Obx(
                      () {
                        if (_dashboardController.exploreListList.isEmpty &&
                            _dashboardController.exploreListFetching.value ==
                                false) {
                          return const SizedBox();
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _dashboardController
                                    .exploreListList.length +
                                (_dashboardController.exploreListList.length ~/
                                    5) +
                                1, // Adding space for images and loader
                            itemBuilder: (context, index) {
                              // Calculate the actual data index
                              int dataIndex = index - (index ~/ 6);
                              print("Index: $index, DataIndex: $dataIndex");
                              print(
                                  "Data Length: ${_dashboardController.exploreListList}");
                              // Insert an image every 5 items
                              if ((index + 1) % 6 == 0) {
                                final imageIndex =
                                    ((index ~/ 6) % imgURLS.length);
                                return GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      barrierDismissible:
                                          true, // Allows dismissing the dialog by tapping outside
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          backgroundColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                2), // Reduce the radius here
                                          ),
                                          insetPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 18, vertical: 50),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      5)), // Match the dialog's border radius
                                            ),
                                            // Adjust width to take nearly the full screen width

                                            child: const PlanSlideSheet(
                                                memberId:
                                                    0), // Embed the PlansSlider here
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 18, left: 18, right: 18),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          5.0), // Set the corner radius
                                      child: Image.network(
                                        imgURLS[imageIndex],
                                        height: 200,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const SizedBox();
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              } else {}

                              // Check if the index is within data length
                              if (dataIndex <
                                  _dashboardController.exploreListList.length) {
                                var matchData = _dashboardController
                                    .exploreListList[dataIndex];

                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        barrierDismissible:
                                            true, // Allows dismissing the dialog by tapping outside
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            backgroundColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  2), // Reduce the radius here
                                            ),
                                            insetPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 18,
                                                    vertical: 50),
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        5)), // Match the dialog's border radius
                                              ),
                                              // Adjust width to take nearly the full screen width

                                              child: PlanSlideSheet(
                                                memberId:
                                                    matchData["member_id"],
                                              ), // Embed the PlansSlider here
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 4),
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: 530,
                                            width: double.infinity,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                matchData["photoUrl"] ??
                                                    "${Appconstants.baseURL}/public/storage/images/download.png", // Replace with dynamic image if available
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          // Gradient overlay
                                          Container(
                                            height: 530,
                                            width: double.infinity,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                colors: [
                                                  Color(
                                                      0xFF0C0B0B), // #0C0B0B at 100%
                                                  Color(
                                                      0x800C0B0B), // rgba(12, 11, 11, 0.5) at 45.36%
                                                  Color(
                                                      0x00FFFFFF), // rgba(255, 255, 255, 0) at 0%
                                                ],
                                                stops: [0.0, 0.45, 1.0],
                                              ),
                                            ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: SizedBox(
                                              height: 530,
                                              width: double.infinity,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 360),

                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      RichText(
                                                        text: TextSpan(
                                                            children: <TextSpan>[
                                                              TextSpan(
                                                                text: language ==
                                                                        "en"
                                                                    ? "Member ID - "
                                                                    : "मेंबर आयडी - ",
                                                                style: CustomTextStyle
                                                                    .imageText
                                                                    .copyWith(
                                                                        fontSize:
                                                                            14),
                                                              ),
                                                              TextSpan(
                                                                text: matchData[
                                                                    "member_profile_id"], // Replace with dynamic ID
                                                                style: CustomTextStyle
                                                                    .imageText
                                                                    .copyWith(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                ),
                                                              ),
                                                            ]),
                                                      ),
                                                      matchData["is_Document_Verification"] ==
                                                              1
                                                          ? const verificationTag()
                                                          : const SizedBox(),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  // Details like age, marital status, location, etc.
                                                  buildRichText(
                                                      "${matchData["age"]} Yrs, ${matchData["height"]}",
                                                      "${matchData["marital_status"]}"), // Replace with dynamic values
                                                  buildRichText(
                                                      "${matchData["subcaste"]}",
                                                      "${matchData["present_city_name"]}, ${matchData["permanent_state_name"]}"), // Dynamic values
                                                  buildRichText(
                                                      "${matchData["occupation"]}",
                                                      "${matchData["annual_income"]}"), // Dynamic values
                                                  const Spacer(),
                                                  Divider(
                                                    height: 2,
                                                    color: const Color.fromARGB(
                                                            255, 215, 226, 242)
                                                        .withOpacity(.69),
                                                  ),
                                                  buildBottomActions(
                                                      matchData["member_id"],
                                                      matchData),
                                                  const SizedBox(
                                                    height: 15,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                // Show loader or 'End of List' when all items are loaded
                                if (_dashboardController
                                        .exploreListList.isEmpty &&
                                    _dashboardController
                                        .exploreListFetching.value) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        height: 530,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return GetBuilder<DashboardController>(
                                    id: 'no_more_data_for_reccomendation',
                                    builder: (controller) {
                                      return Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Center(
                                            child: _dashboardController
                                                    .explorelistHasMore.value
                                                ? Shimmer.fromColors(
                                                    baseColor:
                                                        Colors.grey[300]!,
                                                    highlightColor:
                                                        Colors.grey[100]!,
                                                    child: Container(
                                                      height: 530,
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                  )
                                                : Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          textAlign:
                                                              TextAlign.center,
                                                          language == "en"
                                                              ? "Discover 1000+ profiles! "
                                                              : "1000 पेक्षा जास्त प्रोफाईल्स तुमची वाट बघत आहेत.",
                                                          style: CustomTextStyle
                                                              .bodytextboldLarge,
                                                        ),
                                                        Text(
                                                          textAlign:
                                                              TextAlign.center,
                                                          language == "en"
                                                              ? "Upgrade to Premium and start connecting."
                                                              : 'प्रीमियम प्लॅन खरेदी करून नवीन स्थळांना भेट द्या',
                                                          style: CustomTextStyle
                                                              .bodytext
                                                              .copyWith(
                                                                  fontSize: 15),
                                                        ),
                                                        TextButton(
                                                            onPressed: () {
                                                              showDialog(
                                                                barrierDismissible:
                                                                    true, // Allows dismissing the dialog by tapping outside
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return Dialog(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              2), // Reduce the radius here
                                                                    ),
                                                                    insetPadding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            18,
                                                                        vertical:
                                                                            50),
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        color: Colors
                                                                            .transparent,
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(5)), // Match the dialog's border radius
                                                                      ),
                                                                      // Adjust width to take nearly the full screen width

                                                                      child:
                                                                          const PlanSlideSheet(
                                                                        memberId:
                                                                            0,
                                                                      ), // Embed the PlansSlider here
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            child: Text(
                                                              language == "en"
                                                                  ? "Upgrade to premium"
                                                                  : "प्रीमियम सदस्य व्हा",
                                                              style: CustomTextStyle
                                                                  .textbuttonRed,
                                                            ))
                                                      ],
                                                    ),
                                                  )),
                                      );
                                    },
                                  );
                                }
                              } /*Text(
                                    textAlign: TextAlign.center,
                                    "Discover 1000+ profiles! Upgrade to Premium and start connecting.",
                                    style: CustomTextStyle.bodytextboldLarge,
                                  ),*/
                            },
                          );
                        }
                      },
                    ),
                    const SizedBox(
                      height: 100,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  dynamic buildBottomActions(int memberid, dynamic memberdata) {
    return memberdata["interest_sent_status"] == "3"
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center, // Center the row
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Decline button

              // Accept button
              Expanded(
                // Use Expanded to ensure both buttons take equal space
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      barrierDismissible:
                          true, // Allows dismissing the dialog by tapping outside
                      context: context,
                      builder: (context) {
                        return Dialog(
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                2), // Reduce the radius here
                          ),
                          insetPadding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 50),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.all(Radius.circular(
                                  5)), // Match the dialog's border radius
                            ),
                            // Adjust width to take nearly the full screen width

                            child: PlanSlideSheet(
                              memberId: memberid,
                            ), // Embed the PlansSlider here
                          ),
                        );
                      },
                    );
                  },
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Center the content inside
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 22,
                          width: 22,
                          child: Image.asset("assets/accept.png"),
                        ),
                      ),
                      Text(
                        "Accepted",
                        style: CustomTextStyle.imageText.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        : memberdata["interest_sent_status"] == "1"
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                          barrierDismissible:
                              true, // Allows dismissing the dialog by tapping outside
                          context: context,
                          builder: (context) {
                            return Dialog(
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    2), // Reduce the radius here
                              ),
                              insetPadding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 50),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.all(Radius.circular(
                                      5)), // Match the dialog's border radius
                                ),
                                // Adjust width to take nearly the full screen width

                                child: PlanSlideSheet(
                                  memberId: memberid,
                                ), // Embed the PlansSlider here
                              ),
                            );
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Center the content inside
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SizedBox(
                              height: 22,
                              width: 22,
                              child: Image.asset("assets/icons/Interested.png"),
                            ),
                          ),
                          Text(
                            /* "Interest Sent", */ AppLocalizations.of(context)!
                                .interestSent,
                            style: CustomTextStyle.imageText.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 16,
                    color: const Color.fromARGB(255, 215, 226, 242)
                        .withOpacity(.69),
                    width: 1,
                  ),
                  Expanded(
                      child: TextButton(
                    onPressed: () {
                      showDialog(
                        barrierDismissible:
                            true, // Allows dismissing the dialog by tapping outside
                        context: context,
                        builder: (context) {
                          return Dialog(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  2), // Reduce the radius here
                            ),
                            insetPadding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 50),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.all(Radius.circular(
                                    5)), // Match the dialog's border radius
                              ),
                              // Adjust width to take nearly the full screen width

                              child: PlanSlideSheet(
                                memberId: memberid,
                              ), // Embed the PlansSlider here
                            ),
                          );
                        },
                      );
                    },
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Center the content inside
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 22,
                            width: 22,
                            child: Image.asset("assets/telephoneborder.png"),
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.contact,
                          // language == "en" ? "Contacts" : "संपर्क",
                          style: CustomTextStyle.imageText.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              )
            : memberdata["interest_received_status"] == "1"
                ? Obx(() {
                    if (_dashboardController
                        .hasaccepted(memberdata["member_id"])) {
                      return Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Center the row
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Accept button
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                  barrierDismissible:
                                      true, // Allows dismissing the dialog by tapping outside
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      backgroundColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            2), // Reduce the radius here
                                      ),
                                      insetPadding: const EdgeInsets.symmetric(
                                          horizontal: 18, vertical: 50),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  5)), // Match the dialog's border radius
                                        ),
                                        // Adjust width to take nearly the full screen width

                                        child: PlanSlideSheet(
                                          memberId: memberid,
                                        ), // Embed the PlansSlider here
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Center the content inside
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: Image.asset("assets/accept.png"),
                                    ),
                                  ),
                                  Text(
                                    "Accepted",
                                    style: CustomTextStyle.imageText.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (_dashboardController
                        .hasdeclined(memberdata["member_id"])) {
                      return Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Center the row
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Decline button
                          Expanded(
                            // Use Expanded to ensure both buttons take equal space
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                  barrierDismissible:
                                      true, // Allows dismissing the dialog by tapping outside
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      backgroundColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            2), // Reduce the radius here
                                      ),
                                      insetPadding: const EdgeInsets.symmetric(
                                          horizontal: 18, vertical: 50),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  5)), // Match the dialog's border radius
                                        ),
                                        // Adjust width to take nearly the full screen width

                                        child: PlanSlideSheet(
                                          memberId: memberid,
                                        ), // Embed the PlansSlider here
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Center the content inside
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: Image.asset("assets/decline.png"),
                                    ),
                                  ),
                                  Text(
                                    "Declined",
                                    style: CustomTextStyle.imageText.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Center the row
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Decline button
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                  barrierDismissible:
                                      true, // Allows dismissing the dialog by tapping outside
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      backgroundColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            2), // Reduce the radius here
                                      ),
                                      insetPadding: const EdgeInsets.symmetric(
                                          horizontal: 18, vertical: 50),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  5)), // Match the dialog's border radius
                                        ),
                                        // Adjust width to take nearly the full screen width

                                        child: PlanSlideSheet(
                                          memberId: memberid,
                                        ), // Embed the PlansSlider here
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Center the content inside
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: Image.asset("assets/decline.png"),
                                    ),
                                  ),
                                  Text(
                                    "Decline",
                                    style: CustomTextStyle.imageText.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Divider between buttons
                          Container(
                            height: 16,
                            color: const Color.fromARGB(255, 215, 226, 242)
                                .withOpacity(.69),
                            width: 1,
                          ),

                          // Accept button
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                  barrierDismissible:
                                      true, // Allows dismissing the dialog by tapping outside
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      backgroundColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            2), // Reduce the radius here
                                      ),
                                      insetPadding: const EdgeInsets.symmetric(
                                          horizontal: 18, vertical: 50),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  5)), // Match the dialog's border radius
                                        ),
                                        // Adjust width to take nearly the full screen width

                                        child: PlanSlideSheet(
                                          memberId: memberid,
                                        ), // Embed the PlansSlider here
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Center the content inside
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: Image.asset("assets/accept.png"),
                                    ),
                                  ),
                                  Text(
                                    "Accept",
                                    style: CustomTextStyle.imageText.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  })
                : memberdata["interest_received_status"] == "2"
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 234, 52, 74)
                                  .withOpacity(0.47),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: Image.asset("assets/heartbreak.png"),
                                  ),
                                ),
                                Text(
                                  textAlign: TextAlign.center,
                                  language == "en"
                                      ? "You Declined Their Invitation. This member cannot be contacted. !"
                                      : "तुम्ही त्यांचा इंटरेस्ट नाकारला आहे. त्यामुळे या मेंबरला जोडले जाऊ शकत नाही.",
                                  style: CustomTextStyle.imageText.copyWith(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: Obx(() {
                            return _dashboardController.hasExpressedInterest(
                                        memberdata["member_id"]) ==
                                    false
                                ? TextButton(
                                    onPressed: () {
                                      _dashboardController.sendInterest(
                                          memberid: memberid);
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center, // Center the content inside
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            height: 22,
                                            width: 22,
                                            child: Image.asset(
                                                "assets/Send_interest.png"),
                                          ),
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .interest /* "Interest" */,
                                          style: CustomTextStyle.imageText
                                              .copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : TextButton(
                                    onPressed: () {
                                      showDialog(
                                        barrierDismissible:
                                            true, // Allows dismissing the dialog by tapping outside
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            backgroundColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  2), // Reduce the radius here
                                            ),
                                            insetPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 18,
                                                    vertical: 50),
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        5)), // Match the dialog's border radius
                                              ),
                                              // Adjust width to take nearly the full screen width

                                              child: PlanSlideSheet(
                                                memberId: memberid,
                                              ), // Embed the PlansSlider here
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center, // Center the content inside
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: SizedBox(
                                            height: 22,
                                            width: 22,
                                            child: Image.asset(
                                                "assets/icons/Interested.png"),
                                          ),
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .interestSent /* "Interest Sent" */,
                                          style: CustomTextStyle.imageText
                                              .copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                          })),
                          Container(
                            height: 16,
                            color: const Color.fromARGB(255, 215, 226, 242)
                                .withOpacity(.69),
                            width: 1,
                          ),
                          Expanded(
                              child: TextButton(
                            onPressed: () {
                              showDialog(
                                barrierDismissible:
                                    true, // Allows dismissing the dialog by tapping outside
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    backgroundColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          2), // Reduce the radius here
                                    ),
                                    insetPadding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 50),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                5)), // Match the dialog's border radius
                                      ),
                                      // Adjust width to take nearly the full screen width

                                      child: PlanSlideSheet(
                                        memberId: memberid,
                                      ), // Embed the PlansSlider here
                                    ),
                                  );
                                },
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Center the content inside
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: Image.asset(
                                        "assets/telephoneborder.png"),
                                  ),
                                ),
                                Text(
                                  AppLocalizations.of(context)!.contact,
                                  // "Contacts",
                                  style: CustomTextStyle.imageText.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ],
                      );
  }

  RichText buildRichText(String leftText, String rightText) {
    return RichText(
      text: TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: leftText,
            style: CustomTextStyle.imageText,
          ),
          WidgetSpan(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4),
              child: Container(
                width: 6.0,
                height: 6.0,
                decoration: BoxDecoration(
                  color:
                      const Color.fromARGB(255, 215, 215, 215).withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          TextSpan(
            text: rightText,
            style: CustomTextStyle.imageText,
          ),
        ],
      ),
    );
  }
}
