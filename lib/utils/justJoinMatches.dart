import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:_96kuliapp/checkupdateFunctions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/controllers/viewProfileControllers/viewprofileController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/profile_screens/user_details.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/bottomnavBar.dart';
import 'package:_96kuliapp/utils/newmatches.dart';
import 'package:_96kuliapp/utils/verificationTag.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:shimmer/shimmer.dart';

class JustJoinMatches extends StatelessWidget {
  const JustJoinMatches({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController =
        Get.find<DashboardController>();
    //   final BottomNavController bottomNavController = Get.put(BottomNavController());
    String? language = sharedPreferences?.getString("Language");
    dashboardController.fetchRecentlyJoinedMatches();

    return Obx(() {
      if (dashboardController.recentlyjoinedfetching.value) {
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
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white, // Placeholder color
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 6,
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              color: Colors.white, // Placeholder color
                            ),
                            width: 200,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              child: Container(
                                color: Colors
                                    .grey[300], // Placeholder color for image
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
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              color: Color.fromARGB(255, 235, 237, 239),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 15,
                                    color: Colors
                                        .grey[300], // Placeholder for text
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    height: 12,
                                    color: Colors
                                        .grey[300], // Placeholder for text
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Container(
                                        height: 12,
                                        width: 60,
                                        color: Colors
                                            .grey[300], // Placeholder for text
                                      ),
                                      const SizedBox(width: 4),
                                      Container(
                                        width: 1.0,
                                        height: 12.0,
                                        color: const Color.fromARGB(255, 80, 93,
                                            126), // Color of the separator
                                      ),
                                      const SizedBox(width: 4),
                                      Container(
                                        height: 12,
                                        width: 80,
                                        color: Colors
                                            .grey[300], // Placeholder for text
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    height: 12,
                                    color: Colors
                                        .grey[300], // Placeholder for text
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Container(
                                        height: 12,
                                        width: 100,
                                        color: Colors
                                            .grey[300], // Placeholder for text
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
        if (dashboardController.recentMatches.isEmpty) {
          return const SizedBox();
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.recentlyJoinMatches,
                style: CustomTextStyle.title,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 320, // Specify a fixed height for the ListView
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: dashboardController.recentMatches.length,
                  itemBuilder: (context, index) {
                    //    print("Match is ${match}");
                    if (dashboardController.recentMatches.length > 5) {
                      if (index <
                          dashboardController.recentMatches.length - 1) {
                        final match = dashboardController.recentMatches[index];
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: GestureDetector(
                            onTap: () async {
                              try {
                                print('Checking for Update');
                                AppUpdateInfo info =
                                    await InAppUpdate.checkForUpdate();

                                if (info.updateAvailability ==
                                    UpdateAvailability.updateAvailable) {
                                  print('Update available');
                                  await update();
                                } else {
                                  print('No update available');
                                  // _dashboardController.onItemTapped(value);
                                  navigatorKey.currentState!
                                      .push(MaterialPageRoute(
                                    builder: (context) => UserDetails(
                                        notificationID: 0,
                                        memberid: match["member_id"]),
                                  ));
                                }
                              } catch (e) {
                                print(
                                    'Error checking for update: ${e.toString()}');
                                navigatorKey.currentState!
                                    .push(MaterialPageRoute(
                                  builder: (context) => UserDetails(
                                      notificationID: 0,
                                      memberid: match["member_id"]),
                                ));
                              }
                            },
                            child: Container(
                              width: 200,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    flex: 6,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                      width: 200,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                        child: Image.network(
                                          alignment: Alignment.topCenter,
                                          match['photoUrl'] ??
                                              "${Appconstants.baseURL}/public/storage/images/download.png",
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
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
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                        color:
                                            Color.fromARGB(255, 235, 237, 239),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "${match["member_name"]} ",
                                                  style: CustomTextStyle
                                                      .bodytextbold,
                                                ),
                                                match["is_Document_Verification"] ==
                                                        1
                                                    ? const verificationTag()
                                                    : const SizedBox()
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            RichText(
                                              text:
                                                  TextSpan(children: <TextSpan>[
                                                TextSpan(
                                                    text: language == "en"
                                                        ? "Member ID - "
                                                        : "मेंबर आयडी - ",
                                                    style: CustomTextStyle
                                                        .bodytext),
                                                TextSpan(
                                                    text:
                                                        "${match["member_profile_id"]}",
                                                    style: CustomTextStyle
                                                        .bodytextbold),
                                              ]),
                                            ),
                                            const SizedBox(height: 5),
                                            RichText(
                                              text: TextSpan(
                                                children: <InlineSpan>[
                                                  TextSpan(
                                                    text:
                                                        "${match["age"]} Yrs, ${match["height"]} ",
                                                    style: CustomTextStyle
                                                        .bodytext
                                                        .copyWith(fontSize: 11),
                                                  ),
                                                  WidgetSpan(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal:
                                                              4.0), // Adjust the padding as needed
                                                      child: Container(
                                                        width:
                                                            1.0, // Adjust size for the circle
                                                        height: 12.0,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Color.fromARGB(
                                                              255,
                                                              80,
                                                              93,
                                                              126), // Set the color of the circle
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        " ${match["marital_status"]}",
                                                    style: CustomTextStyle
                                                        .bodytext
                                                        .copyWith(fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text("${match["subcaste"]}",
                                                style: CustomTextStyle.bodytext
                                                    .copyWith(fontSize: 12)),
                                            const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      //           _viewProfileController.fetchUserInfo(memberid: match["member_id"]);
                                                      navigatorKey.currentState!
                                                          .push(
                                                              MaterialPageRoute(
                                                        builder: (context) =>
                                                            UserDetails(
                                                                notificationID:
                                                                    0,
                                                                memberid: match[
                                                                    "member_id"]),
                                                      ));
                                                    },
                                                    child: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .viewProfile,
                                                        style: CustomTextStyle
                                                            .textbuttonRed)),
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
                      } else {
                        final match = dashboardController.recentMatches[index];

                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: GestureDetector(
                            onTap: () async {
                              try {
                                print('Checking for Update');
                                AppUpdateInfo info =
                                    await InAppUpdate.checkForUpdate();

                                if (info.updateAvailability ==
                                    UpdateAvailability.updateAvailable) {
                                  print('Update available');
                                  await update();
                                } else {
                                  print('No update available');

                                  dashboardController.updateMathcesScreen(4);
                                  dashboardController.onItemTapped(1);
                                }
                              } catch (e) {
                                print(
                                    'Error checking for update: ${e.toString()}');
                                dashboardController.updateMathcesScreen(4);
                                dashboardController.onItemTapped(1);
                              }
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: 200,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
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
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                          ),
                                          width: 200,
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                            child: Image.network(
                                              alignment: Alignment.topCenter,
                                              match['photoUrl'] ??
                                                  "${Appconstants.baseURL}/public/storage/images/download.png",
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
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
                                                bottomLeft: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10)),
                                            color: Color.fromARGB(
                                                255, 235, 237, 239),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${match["member_name"]} ",
                                                      style: CustomTextStyle
                                                          .bodytextbold,
                                                    ),
                                                    match["is_Document_Verification"] ==
                                                            1
                                                        ? const verificationTag()
                                                        : const SizedBox()
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                RichText(
                                                  text: TextSpan(
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text: language ==
                                                                    "en"
                                                                ? "Member ID - "
                                                                : "मेंबर आयडी - ",
                                                            style:
                                                                CustomTextStyle
                                                                    .bodytext),
                                                        TextSpan(
                                                            text:
                                                                "${match["member_profile_id"]}",
                                                            style: CustomTextStyle
                                                                .bodytextbold),
                                                      ]),
                                                ),
                                                const SizedBox(height: 5),
                                                RichText(
                                                  text: TextSpan(
                                                    children: <InlineSpan>[
                                                      TextSpan(
                                                        text:
                                                            "${match["age"]} Yrs, ${match["height"]} ",
                                                        style: CustomTextStyle
                                                            .bodytext
                                                            .copyWith(
                                                                fontSize: 11),
                                                      ),
                                                      WidgetSpan(
                                                        child: Padding(
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                              horizontal:
                                                                  4.0), // Adjust the padding as needed
                                                          child: Container(
                                                            width:
                                                                1.0, // Adjust size for the circle
                                                            height: 12.0,
                                                            decoration:
                                                                const BoxDecoration(
                                                              color: Color.fromARGB(
                                                                  255,
                                                                  80,
                                                                  93,
                                                                  126), // Set the color of the circle
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            " ${match["marital_status"]}",
                                                        style: CustomTextStyle
                                                            .bodytext
                                                            .copyWith(
                                                                fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text("${match["subcaste"]}",
                                                    style: CustomTextStyle
                                                        .bodytext
                                                        .copyWith(
                                                            fontSize: 12)),
                                                const SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    InkWell(
                                                        onTap: () {
                                                          //           _viewProfileController.fetchUserInfo(memberid: match["member_id"]);
                                                          navigatorKey
                                                              .currentState!
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder: (context) =>
                                                                UserDetails(
                                                                    notificationID:
                                                                        0,
                                                                    memberid: match[
                                                                        "member_id"]),
                                                          ));
                                                        },
                                                        child: Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .viewProfile,
                                                            style: CustomTextStyle
                                                                .textbuttonRed)),
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
                                // Full overlay
                                Positioned.fill(
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(
                                            0.7), // Dark overlay with opacity
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: Text(
                                              language == "en"
                                                  ? "View All!!"
                                                  : 'सर्व प्रोफाईल्स बघा',
                                              style: CustomTextStyle
                                                  .bodytextbold
                                                  .copyWith(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              "Matches",
                                              style: CustomTextStyle
                                                  .bodytextbold
                                                  .copyWith(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    } else {
                      final match = dashboardController.recentMatches[index];

                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: GestureDetector(
                          onTap: () async {
                            try {
                              print('Checking for Update');
                              AppUpdateInfo info =
                                  await InAppUpdate.checkForUpdate();

                              if (info.updateAvailability ==
                                  UpdateAvailability.updateAvailable) {
                                print('Update available');
                                await update();
                              } else {
                                print('No update available');
                                // _dashboardController.onItemTapped(value);
                                navigatorKey.currentState!
                                    .push(MaterialPageRoute(
                                  builder: (context) => UserDetails(
                                      notificationID: 0,
                                      memberid: match["member_id"]),
                                ));
                              }
                            } catch (e) {
                              print(
                                  'Error checking for update: ${e.toString()}');
                              navigatorKey.currentState!.push(MaterialPageRoute(
                                builder: (context) => UserDetails(
                                    notificationID: 0,
                                    memberid: match["member_id"]),
                              ));
                            }
                          },
                          child: Container(
                            width: 200,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  flex: 6,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                    width: 200,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                      child: Image.network(
                                        alignment: Alignment.topCenter,
                                        match['photoUrl'] ??
                                            "${Appconstants.baseURL}/public/storage/images/download.png",
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
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
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                      color: Color.fromARGB(255, 235, 237, 239),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${match["member_name"]} ",
                                                style: CustomTextStyle
                                                    .bodytextbold,
                                              ),
                                              match["is_Document_Verification"] ==
                                                      1
                                                  ? const verificationTag()
                                                  : const SizedBox()
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          RichText(
                                            text: TextSpan(children: <TextSpan>[
                                              TextSpan(
                                                  text: language == "en"
                                                      ? "Member ID - "
                                                      : "मेंबर आयडी - ",
                                                  style:
                                                      CustomTextStyle.bodytext),
                                              TextSpan(
                                                  text:
                                                      "${match["member_profile_id"]}",
                                                  style: CustomTextStyle
                                                      .bodytextbold),
                                            ]),
                                          ),
                                          const SizedBox(height: 5),
                                          RichText(
                                            text: TextSpan(
                                              children: <InlineSpan>[
                                                TextSpan(
                                                  text:
                                                      "${match["age"]} Yrs, ${match["height"]} ",
                                                  style: CustomTextStyle
                                                      .bodytext
                                                      .copyWith(fontSize: 11),
                                                ),
                                                WidgetSpan(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal:
                                                            4.0), // Adjust the padding as needed
                                                    child: Container(
                                                      width:
                                                          1.0, // Adjust size for the circle
                                                      height: 12.0,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Color.fromARGB(
                                                            255,
                                                            80,
                                                            93,
                                                            126), // Set the color of the circle
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      " ${match["marital_status"]}",
                                                  style: CustomTextStyle
                                                      .bodytext
                                                      .copyWith(fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text("${match["subcaste"]}",
                                              style: CustomTextStyle.bodytext
                                                  .copyWith(fontSize: 12)),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              InkWell(
                                                  onTap: () {
                                                    //           _viewProfileController.fetchUserInfo(memberid: match["member_id"]);
                                                    navigatorKey.currentState!
                                                        .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          UserDetails(
                                                              notificationID: 0,
                                                              memberid: match[
                                                                  "member_id"]),
                                                    ));
                                                  },
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .viewProfile,
                                                      style: CustomTextStyle
                                                          .textbuttonRed)),
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
                    }
                  },
                ),
              )
            ],
          );
        }
      }
    });
  }
}
