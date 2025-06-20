import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:_96kuliapp/checkupdateFunctions.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/commons/dialogues/acceptInterestDialogue.dart';
import 'package:_96kuliapp/commons/dialogues/declineInterestDialogue.dart';
import 'package:_96kuliapp/commons/dialogues/expressInterest.dart';
import 'package:_96kuliapp/commons/dialogues/forceupdatePopup.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/profile_screens/user_details.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/bottomnavBar.dart';
import 'package:_96kuliapp/utils/verificationTag.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:shimmer/shimmer.dart';

String ensureSemanticVersion(String version) {
  if (version.split('.').length == 2) {
    return "$version.0"; // Add patch version if missing
  }
  return version; // Return unchanged if already valid
}

class NewMatches extends StatelessWidget {
  const NewMatches({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController =
        Get.find<DashboardController>();
    // final BottomNavController bottomNavController = Get.put(BottomNavController());
    String? language = sharedPreferences?.getString("Language");

    dashboardController.fetchRecomendedMatches();
    return Obx(
      () {
        if (dashboardController.recommendedmatchesfetching.value) {
          return SizedBox(
            height: 530,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 8, // Show 8 shimmer placeholders
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 4, bottom: 2, top: 4),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 320,
                      height: 530,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          if (dashboardController.recommendedmatches.value.isEmpty) {
            return const SizedBox();
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.newRecommendedMatchesForYou,
                  style: CustomTextStyle.title,
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 530,
                  width: double.infinity,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: dashboardController.recommendedmatches.length,
                    itemBuilder: (context, index) {
                      if (dashboardController.recommendedmatches.length > 5) {
                        if (index <
                            dashboardController.recommendedmatches.length - 1) {
                          final recomendedmatch =
                              dashboardController.recommendedmatches[index];
                          return GestureDetector(
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
                                        memberid: recomendedmatch["member_id"]),
                                  ));
                                }
                              } catch (e) {
                                navigatorKey.currentState!
                                    .push(MaterialPageRoute(
                                  builder: (context) => UserDetails(
                                      notificationID: 0,
                                      memberid: recomendedmatch["member_id"]),
                                ));

                                print(
                                    'Error checking for update: ${e.toString()}');
                              }
                              /*  navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => UserDetails(
                notificationID: 0,
                memberid: recomendedmatch["member_id"]),));
*/
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 2, bottom: 2, top: 4),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 530,
                                    width: 320,
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        recomendedmatch["photoUrl"] ??
                                            "${Appconstants.baseURL}/public/storage/images/download.png",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  // Gradient overlay
                                  Container(
                                    height: 530,
                                    width: 320,
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Color(0xFF0C0B0B), // #0C0B0B at 100%
                                          Color(
                                              0x800C0B0B), // rgba(12, 11, 11, 0.5) at 45.36%
                                          Color(
                                              0x00FFFFFF), // rgba(255, 255, 255, 0) at 0%
                                        ],
                                        stops: [0.0, 0.45, 1.0],
                                      ),
                                    ),
                                  ),
                                  recomendedmatch["is_premium"] == "1"
                                      ? const Positioned(
                                          top: 15,
                                          right: 6,
                                          child: PremiumTag(),
                                        )
                                      : const SizedBox(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 530,
                                      width: 310,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 290),
                                          Text(
                                            recomendedmatch[
                                                    "last_online_time"] ??
                                                "",
                                            style: CustomTextStyle.imageText,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${recomendedmatch["member_name"]} ",
                                                style: CustomTextStyle.imageText
                                                    .copyWith(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: Colors.white),
                                              ),
                                              recomendedmatch[
                                                          "is_Document_Verification"] ==
                                                      1
                                                  ? const verificationTag()
                                                  : const SizedBox()
                                            ],
                                          ),

                                          RichText(
                                            text: TextSpan(children: <TextSpan>[
                                              TextSpan(
                                                  text: language == "en"
                                                      ? "Member ID - "
                                                      : "मेंबर आयडी - ",
                                                  style: CustomTextStyle
                                                      .imageText
                                                      .copyWith(fontSize: 14)),
                                              TextSpan(
                                                  text: recomendedmatch[
                                                      "member_profile_id"],
                                                  style: CustomTextStyle
                                                      .imageText
                                                      .copyWith(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w800)),
                                            ]),
                                          ),
                                          const SizedBox(height: 10),
                                          RichText(
                                            text: TextSpan(
                                              children: <InlineSpan>[
                                                TextSpan(
                                                  text:
                                                      "${recomendedmatch["age"]} Yrs, ${recomendedmatch["height"]} ",
                                                  style:
                                                      CustomTextStyle.imageText,
                                                ),
                                                WidgetSpan(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 4.0,
                                                        vertical: 4),
                                                    child: Container(
                                                      width: 6.0,
                                                      height: 6.0,
                                                      decoration: BoxDecoration(
                                                        color: const Color
                                                                .fromARGB(255,
                                                                215, 215, 215)
                                                            .withOpacity(0.5),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: recomendedmatch[
                                                      "marital_status"],
                                                  style:
                                                      CustomTextStyle.imageText,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 1),
                                          RichText(
                                            overflow: TextOverflow.ellipsis,
                                            text:
                                                TextSpan(children: <InlineSpan>[
                                              // TextSpan(
                                              //   text:
                                              //       recomendedmatch["section"],
                                              //   style:
                                              //       CustomTextStyle.imageText,
                                              // ),
                                              // const TextSpan(text: " - "),
                                              TextSpan(
                                                text:
                                                    recomendedmatch["subcaste"],
                                                style:
                                                    CustomTextStyle.imageText,
                                              ),
                                            ]),
                                          ),
                                          const SizedBox(height: 1),
                                          // Aligning the city and state name with the text above and below
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "${recomendedmatch["permanent_city_name"]}, ${recomendedmatch["permanent_state_name"]}",
                                                  style:
                                                      CustomTextStyle.imageText,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 1),
                                          RichText(
                                            text: TextSpan(
                                              children: <InlineSpan>[
                                                TextSpan(
                                                  text:
                                                      "${recomendedmatch["occupation"]} ",
                                                  style:
                                                      CustomTextStyle.imageText,
                                                ),
                                                WidgetSpan(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 4.0,
                                                        vertical: 4),
                                                    child: Container(
                                                      width: 6.0,
                                                      height: 6.0,
                                                      decoration: BoxDecoration(
                                                        color: const Color
                                                                .fromARGB(255,
                                                                215, 215, 215)
                                                            .withOpacity(0.5),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      "${recomendedmatch["annual_income"]}",
                                                  style:
                                                      CustomTextStyle.imageText,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                          Divider(
                                            height: 2,
                                            color: const Color.fromARGB(
                                                    255, 215, 226, 242)
                                                .withOpacity(.69),
                                          ),
                                          recomendedmatch[
                                                      "interest_sent_status"] ==
                                                  "3"
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center, // Center the row
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    // Decline button

                                                    // Accept button
                                                    Expanded(
                                                      // Use Expanded to ensure both buttons take equal space
                                                      child: TextButton(
                                                        onPressed: () {},
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center, // Center the content inside
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: SizedBox(
                                                                height: 22,
                                                                width: 22,
                                                                child: Image.asset(
                                                                    "assets/accept.png"),
                                                              ),
                                                            ),
                                                            Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .accepted,
                                                              style:
                                                                  CustomTextStyle
                                                                      .imageText
                                                                      .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : recomendedmatch[
                                                          "interest_sent_status"] ==
                                                      "1"
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                          child: TextButton(
                                                            onPressed: () {},
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround, // Center the content inside
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          0.0),
                                                                  child:
                                                                      SizedBox(
                                                                    height: 22,
                                                                    width: 22,
                                                                    child: Image
                                                                        .asset(
                                                                            "assets/icons/Interested.png"),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .interestSent,
                                                                  style: CustomTextStyle
                                                                      .imageText
                                                                      .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 16,
                                                          color: const Color
                                                                  .fromARGB(255,
                                                                  215, 226, 242)
                                                              .withOpacity(.69),
                                                          width: 1,
                                                        ),
                                                        Expanded(
                                                          child: recomendedmatch[
                                                                      "Shortlisted"] ==
                                                                  true
                                                              ? TextButton(
                                                                  onPressed:
                                                                      () {},
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center, // Center the content inside
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            SizedBox(
                                                                          height:
                                                                              22,
                                                                          width:
                                                                              22,
                                                                          child:
                                                                              Image.asset("assets/icons/Shortlisted.png"),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        AppLocalizations.of(context)!
                                                                            .shortlisted,
                                                                        // "Shortlisted",
                                                                        style: CustomTextStyle
                                                                            .imageText
                                                                            .copyWith(
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          fontSize:
                                                                              16,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              : Obx(() {
                                                                  return dashboardController
                                                                              .hasShortlisted(recomendedmatch["member_id"]) ==
                                                                          false
                                                                      ? TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            dashboardController.shortlistMember(memberid: recomendedmatch["member_id"]);
                                                                          },
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center, // Center the content inside
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: SizedBox(
                                                                                  height: 22,
                                                                                  width: 22,
                                                                                  child: Image.asset("assets/star.png"),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                AppLocalizations.of(context)!.shortlist,
                                                                                // "Shortlist",
                                                                                style: CustomTextStyle.imageText.copyWith(
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontSize: 16,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      : TextButton(
                                                                          onPressed:
                                                                              () {},
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center, // Center the content inside
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: SizedBox(
                                                                                  height: 22,
                                                                                  width: 22,
                                                                                  child: Image.asset("assets/icons/Shortlisted.png"),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                AppLocalizations.of(context)!.shortlisted,
                                                                                // "Shortlisted",
                                                                                style: CustomTextStyle.imageText.copyWith(
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontSize: 16,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                }),
                                                        ),
                                                      ],
                                                    )
                                                  : recomendedmatch[
                                                              "interest_received_status"] ==
                                                          "1"
                                                      ? Obx(
                                                          () {
                                                            if (dashboardController
                                                                .hasaccepted(
                                                                    recomendedmatch[
                                                                        "member_id"])) {
                                                              return Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center, // Center the row
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  // Decline button

                                                                  // Accept button
                                                                  Expanded(
                                                                    // Use Expanded to ensure both buttons take equal space
                                                                    child:
                                                                        TextButton(
                                                                      onPressed:
                                                                          () {},
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center, // Center the content inside
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                SizedBox(
                                                                              height: 22,
                                                                              width: 22,
                                                                              child: Image.asset("assets/accept.png"),
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            AppLocalizations.of(context)!.accepted,
                                                                            style:
                                                                                CustomTextStyle.imageText.copyWith(
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
                                                            } else if (dashboardController
                                                                .hasdeclined(
                                                                    recomendedmatch[
                                                                        "member_id"])) {
                                                              return Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center, // Center the row
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  // Decline button
                                                                  Expanded(
                                                                    // Use Expanded to ensure both buttons take equal space
                                                                    child:
                                                                        TextButton(
                                                                      onPressed:
                                                                          () {},
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center, // Center the content inside
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                SizedBox(
                                                                              height: 22,
                                                                              width: 22,
                                                                              child: Image.asset("assets/decline.png"),
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            "Declined",
                                                                            style:
                                                                                CustomTextStyle.imageText.copyWith(
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
                                                                    MainAxisAlignment
                                                                        .center, // Center the row
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  // Decline button
                                                                  Expanded(
                                                                    // Use Expanded to ensure both buttons take equal space
                                                                    child:
                                                                        TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        showDialog(
                                                                          barrierDismissible:
                                                                              false,
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return DeclineInterestDialogue(
                                                                              matchid: recomendedmatch["member_id"],
                                                                            );
                                                                          },
                                                                        );
                                                                        //  _dashboardController.declinerequest(memberid: matchData["member_id"]);
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center, // Center the content inside
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                SizedBox(
                                                                              height: 22,
                                                                              width: 22,
                                                                              child: Image.asset("assets/decline.png"),
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            "Decline",
                                                                            style:
                                                                                CustomTextStyle.imageText.copyWith(
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
                                                                    color: const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            215,
                                                                            226,
                                                                            242)
                                                                        .withOpacity(
                                                                            .69),
                                                                    width: 1,
                                                                  ),

                                                                  // Accept button
                                                                  Expanded(
                                                                    // Use Expanded to ensure both buttons take equal space
                                                                    child:
                                                                        TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        showDialog(
                                                                          barrierDismissible:
                                                                              false,
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return AcceptInterestDialogue(
                                                                              matchid: recomendedmatch["member_id"],
                                                                            );
                                                                          },
                                                                        );
                                                                        //  _dashboardController.acceptedrequest(memberid: matchData["member_id"]);
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center, // Center the content inside
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                SizedBox(
                                                                              height: 22,
                                                                              width: 22,
                                                                              child: Image.asset("assets/accept.png"),
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            "Accept",
                                                                            style:
                                                                                CustomTextStyle.imageText.copyWith(
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
                                                          },
                                                        )
                                                      : recomendedmatch[
                                                                  "interest_received_status"] ==
                                                              "2"
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 8.0,
                                                                      bottom:
                                                                          8.0),
                                                              child: Container(
                                                                height: 100,
                                                                decoration: BoxDecoration(
                                                                    color: const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            234,
                                                                            52,
                                                                            74)
                                                                        .withOpacity(
                                                                            0.47),
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .all(
                                                                            Radius.circular(10))),
                                                                child: Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              4.0),
                                                                          child:
                                                                              SizedBox(
                                                                            height:
                                                                                22,
                                                                            width:
                                                                                22,
                                                                            child:
                                                                                Image.asset("assets/heartbreak.png"),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          language == "en"
                                                                              ? "You Declined Their Invitation. This member cannot be contacted. !"
                                                                              : "तुम्ही त्यांचा इंटरेस्ट नाकारला आहे. त्यामुळे या मेंबरला जोडले जाऊ शकत नाही.",
                                                                          style: CustomTextStyle.imageText.copyWith(
                                                                              fontWeight: FontWeight.w800,
                                                                              fontSize: 14),
                                                                        )
                                                                      ],
                                                                    )),
                                                              ),
                                                            )
                                                          : Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Expanded(
                                                                    child: Obx(
                                                                  () {
                                                                    return dashboardController.hasExpressedInterest(recomendedmatch["member_id"]) ==
                                                                            false
                                                                        ? TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              showDialog(
                                                                                context: context,
                                                                                builder: (context) {
                                                                                  return ExpressInterestDialogue(
                                                                                    memberID: recomendedmatch["member_id"],
                                                                                  );
                                                                                },
                                                                              );
                                                                            },
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: SizedBox(
                                                                                    height: 22,
                                                                                    width: 22,
                                                                                    child: Image.asset("assets/heartborder.png"),
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  AppLocalizations.of(context)!.interest,
                                                                                  style: CustomTextStyle.imageText.copyWith(
                                                                                    fontWeight: FontWeight.w600,
                                                                                    fontSize: 16,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )
                                                                        : TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              //  onInterestPressed!();
                                                                            },
                                                                            child:
                                                                                Row(
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
                                                                                  AppLocalizations.of(context)!.interestSent,
                                                                                  style: CustomTextStyle.imageText.copyWith(
                                                                                    fontWeight: FontWeight.w600,
                                                                                    fontSize: 16,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          );
                                                                  },
                                                                )),
                                                                Container(
                                                                  height: 16,
                                                                  color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          215,
                                                                          226,
                                                                          242)
                                                                      .withOpacity(
                                                                          .69),
                                                                  width: 1,
                                                                ),
                                                                Expanded(
                                                                    child: recomendedmatch["Shortlisted"] ==
                                                                            true
                                                                        ? TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              //  onShortlistPressed!();
                                                                            },
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: SizedBox(
                                                                                    height: 22,
                                                                                    width: 22,
                                                                                    child: Image.asset("assets/icons/Shortlisted.png"),
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  AppLocalizations.of(context)!.shortlisted,
                                                                                  // "Shortlisted",
                                                                                  style: CustomTextStyle.imageText.copyWith(
                                                                                    fontWeight: FontWeight.w600,
                                                                                    fontSize: 16,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )
                                                                        : Obx(
                                                                            () {
                                                                              return dashboardController.hasShortlisted(recomendedmatch["member_id"]) == false
                                                                                  ? TextButton(
                                                                                      onPressed: () {
                                                                                        //   onShortlistPressed!();
                                                                                        dashboardController.shortlistMember(memberid: recomendedmatch["member_id"]);
                                                                                      },
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.all(8.0),
                                                                                            child: SizedBox(
                                                                                              height: 22,
                                                                                              width: 22,
                                                                                              child: Image.asset("assets/star.png"),
                                                                                            ),
                                                                                          ),
                                                                                          Text(
                                                                                            AppLocalizations.of(context)!.shortlist,
                                                                                            // "Shortlist",
                                                                                            style: CustomTextStyle.imageText.copyWith(
                                                                                              fontWeight: FontWeight.w600,
                                                                                              fontSize: 16,
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    )
                                                                                  : TextButton(
                                                                                      onPressed: () {
                                                                                        //  onShortlistPressed!();
                                                                                      },
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.all(8.0),
                                                                                            child: SizedBox(
                                                                                              height: 22,
                                                                                              width: 22,
                                                                                              child: Image.asset("assets/icons/Shortlisted.png"),
                                                                                            ),
                                                                                          ),
                                                                                          Text(
                                                                                            AppLocalizations.of(context)!.shortlisted,
                                                                                            // "Shortlisted",
                                                                                            style: CustomTextStyle.imageText.copyWith(
                                                                                              fontWeight: FontWeight.w600,
                                                                                              fontSize: 16,
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    );
                                                                            },
                                                                          )),
                                                              ],
                                                            )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        } else {
                          final recomendedmatch =
                              dashboardController.recommendedmatches[index];

                          return GestureDetector(
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
                                  dashboardController.updateMathcesScreen(0);
                                  dashboardController.onItemTapped(1);
                                }
                              } catch (e) {
                                dashboardController.updateMathcesScreen(0);
                                dashboardController.onItemTapped(1);

                                print(
                                    'Error checking for update: ${e.toString()}');
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 2, bottom: 2, top: 4),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 530,
                                    width: 320,
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        recomendedmatch["photoUrl"] ??
                                            "${Appconstants.baseURL}/public/storage/images/download.png",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  // Gradient overlay
                                  Container(
                                    height: 530,
                                    width: 320,
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Color(0xFF0C0B0B), // #0C0B0B at 100%
                                          Color(
                                              0x800C0B0B), // rgba(12, 11, 11, 0.5) at 45.36%
                                          Color(
                                              0x00FFFFFF), // rgba(255, 255, 255, 0) at 0%
                                        ],
                                        stops: [0.0, 0.45, 1.0],
                                      ),
                                    ),
                                  ),
                                  recomendedmatch["is_premium"] == "1"
                                      ? const Positioned(
                                          top: 15,
                                          right: 6,
                                          child: PremiumTag(),
                                        )
                                      : const SizedBox(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 530,
                                      width: 310,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 290),
                                          Text(
                                            recomendedmatch["last_online"] ??
                                                "Empty",
                                            style: CustomTextStyle.imageText,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${recomendedmatch["member_name"]} ",
                                                style: CustomTextStyle.imageText
                                                    .copyWith(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: Colors.white),
                                              ),
                                              recomendedmatch[
                                                          "is_Document_Verification"] ==
                                                      "1"
                                                  ? const verificationTag()
                                                  : const SizedBox()
                                            ],
                                          ),
                                          RichText(
                                            text: TextSpan(children: <TextSpan>[
                                              TextSpan(
                                                  text: language == "en"
                                                      ? "Member ID - "
                                                      : "मेंबर आयडी - ",
                                                  style: CustomTextStyle
                                                      .imageText
                                                      .copyWith(fontSize: 14)),
                                              TextSpan(
                                                  text: recomendedmatch[
                                                      "member_profile_id"],
                                                  style: CustomTextStyle
                                                      .imageText
                                                      .copyWith(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w800)),
                                            ]),
                                          ),
                                          const SizedBox(height: 10),
                                          RichText(
                                            text: TextSpan(
                                              children: <InlineSpan>[
                                                TextSpan(
                                                  text:
                                                      "${recomendedmatch["age"]} Yrs, ${recomendedmatch["height"]} ",
                                                  style:
                                                      CustomTextStyle.imageText,
                                                ),
                                                WidgetSpan(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 4.0,
                                                        vertical: 4),
                                                    child: Container(
                                                      width: 6.0,
                                                      height: 6.0,
                                                      decoration: BoxDecoration(
                                                        color: const Color
                                                                .fromARGB(255,
                                                                215, 215, 215)
                                                            .withOpacity(0.5),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: recomendedmatch[
                                                      "marital_status"],
                                                  style:
                                                      CustomTextStyle.imageText,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 1),
                                          RichText(
                                            overflow: TextOverflow.ellipsis,
                                            text:
                                                TextSpan(children: <InlineSpan>[
                                              TextSpan(
                                                text:
                                                    recomendedmatch["section"],
                                                style:
                                                    CustomTextStyle.imageText,
                                              ),
                                              const TextSpan(text: " - "),
                                              TextSpan(
                                                text:
                                                    recomendedmatch["subcaste"],
                                                style:
                                                    CustomTextStyle.imageText,
                                              ),
                                            ]),
                                          ),
                                          const SizedBox(height: 1),
                                          // Aligning the city and state name with the text above and below
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "${recomendedmatch["permanent_city_name"]}, ${recomendedmatch["permanent_state_name"]}",
                                                  style:
                                                      CustomTextStyle.imageText,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 1),
                                          RichText(
                                            text: TextSpan(
                                              children: <InlineSpan>[
                                                TextSpan(
                                                  text:
                                                      "${recomendedmatch["occupation"]} ",
                                                  style:
                                                      CustomTextStyle.imageText,
                                                ),
                                                WidgetSpan(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 4.0,
                                                        vertical: 4),
                                                    child: Container(
                                                      width: 6.0,
                                                      height: 6.0,
                                                      decoration: BoxDecoration(
                                                        color: const Color
                                                                .fromARGB(255,
                                                                215, 215, 215)
                                                            .withOpacity(0.5),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      "${recomendedmatch["annual_income"]}",
                                                  style:
                                                      CustomTextStyle.imageText,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                          Divider(
                                            height: 2,
                                            color: const Color.fromARGB(
                                                    255, 215, 226, 242)
                                                .withOpacity(.69),
                                          ),
                                          recomendedmatch[
                                                      "interest_received_status"] ==
                                                  "1"
                                              ? Obx(
                                                  () {
                                                    if (dashboardController
                                                        .hasaccepted(
                                                            recomendedmatch[
                                                                "member_id"])) {
                                                      return Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center, // Center the row
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          // Decline button

                                                          // Accept button
                                                          Expanded(
                                                            // Use Expanded to ensure both buttons take equal space
                                                            child: TextButton(
                                                              onPressed: () {},
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center, // Center the content inside
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child:
                                                                        SizedBox(
                                                                      height:
                                                                          22,
                                                                      width: 22,
                                                                      child: Image
                                                                          .asset(
                                                                              "assets/accept.png"),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    AppLocalizations.of(
                                                                            context)!
                                                                        .accepted,
                                                                    style: CustomTextStyle
                                                                        .imageText
                                                                        .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    } else if (dashboardController
                                                        .hasdeclined(
                                                            recomendedmatch[
                                                                "member_id"])) {
                                                      return Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center, // Center the row
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          // Decline button
                                                          Expanded(
                                                            // Use Expanded to ensure both buttons take equal space
                                                            child: TextButton(
                                                              onPressed: () {},
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center, // Center the content inside
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child:
                                                                        SizedBox(
                                                                      height:
                                                                          22,
                                                                      width: 22,
                                                                      child: Image
                                                                          .asset(
                                                                              "assets/decline.png"),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "Declined",
                                                                    style: CustomTextStyle
                                                                        .imageText
                                                                        .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          16,
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
                                                            MainAxisAlignment
                                                                .center, // Center the row
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          // Decline button
                                                          Expanded(
                                                            // Use Expanded to ensure both buttons take equal space
                                                            child: TextButton(
                                                              onPressed: () {
                                                                showDialog(
                                                                  barrierDismissible:
                                                                      false,
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return DeclineInterestDialogue(
                                                                      matchid:
                                                                          recomendedmatch[
                                                                              "member_id"],
                                                                    );
                                                                  },
                                                                );
                                                                //  _dashboardController.declinerequest(memberid: matchData["member_id"]);
                                                              },
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center, // Center the content inside
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child:
                                                                        SizedBox(
                                                                      height:
                                                                          22,
                                                                      width: 22,
                                                                      child: Image
                                                                          .asset(
                                                                              "assets/decline.png"),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "Decline",
                                                                    style: CustomTextStyle
                                                                        .imageText
                                                                        .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),

                                                          // Divider between buttons
                                                          Container(
                                                            height: 16,
                                                            color: const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    215,
                                                                    226,
                                                                    242)
                                                                .withOpacity(
                                                                    .69),
                                                            width: 1,
                                                          ),

                                                          // Accept button
                                                          Expanded(
                                                            // Use Expanded to ensure both buttons take equal space
                                                            child: TextButton(
                                                              onPressed: () {
                                                                showDialog(
                                                                  barrierDismissible:
                                                                      false,
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return AcceptInterestDialogue(
                                                                      matchid:
                                                                          recomendedmatch[
                                                                              "member_id"],
                                                                    );
                                                                  },
                                                                );
                                                                //  _dashboardController.acceptedrequest(memberid: matchData["member_id"]);
                                                              },
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center, // Center the content inside
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child:
                                                                        SizedBox(
                                                                      height:
                                                                          22,
                                                                      width: 22,
                                                                      child: Image
                                                                          .asset(
                                                                              "assets/accept.png"),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "Accept",
                                                                    style: CustomTextStyle
                                                                        .imageText
                                                                        .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                  },
                                                )
                                              : recomendedmatch[
                                                          "interest_received_status"] ==
                                                      "2"
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0,
                                                              bottom: 8.0),
                                                      child: Container(
                                                        height: 100,
                                                        decoration: BoxDecoration(
                                                            color: const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    234,
                                                                    52,
                                                                    74)
                                                                .withOpacity(
                                                                    0.47),
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                                    Radius.circular(
                                                                        10))),
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          4.0),
                                                                  child:
                                                                      SizedBox(
                                                                    height: 22,
                                                                    width: 22,
                                                                    child: Image
                                                                        .asset(
                                                                            "assets/heartbreak.png"),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  language ==
                                                                          "en"
                                                                      ? "You Declined Their Invitation. This member cannot be contacted. !"
                                                                      : "तुम्ही त्यांचा इंटरेस्ट नाकारला आहे. त्यामुळे या मेंबरला जोडले जाऊ शकत नाही.",
                                                                  style: CustomTextStyle
                                                                      .imageText
                                                                      .copyWith(
                                                                          fontWeight: FontWeight
                                                                              .w800,
                                                                          fontSize:
                                                                              14),
                                                                )
                                                              ],
                                                            )),
                                                      ),
                                                    )
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(child: Obx(
                                                          () {
                                                            return dashboardController
                                                                        .hasExpressedInterest(
                                                                            recomendedmatch["member_id"]) ==
                                                                    false
                                                                ? TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return ExpressInterestDialogue(
                                                                            memberID:
                                                                                recomendedmatch["member_id"],
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                    child: Row(
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              8.0),
                                                                          child:
                                                                              SizedBox(
                                                                            height:
                                                                                22,
                                                                            width:
                                                                                22,
                                                                            child:
                                                                                Image.asset("assets/heartborder.png"),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          AppLocalizations.of(context)!
                                                                              .interest,
                                                                          style: CustomTextStyle
                                                                              .imageText
                                                                              .copyWith(
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontSize:
                                                                                16,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                : TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      //  onInterestPressed!();
                                                                    },
                                                                    child: Row(
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              4.0),
                                                                          child:
                                                                              SizedBox(
                                                                            height:
                                                                                22,
                                                                            width:
                                                                                22,
                                                                            child:
                                                                                Image.asset("assets/icons/Interested.png"),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          AppLocalizations.of(context)!
                                                                              .interestSent,
                                                                          style: CustomTextStyle
                                                                              .imageText
                                                                              .copyWith(
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontSize:
                                                                                16,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                          },
                                                        )),
                                                        Container(
                                                          height: 16,
                                                          color: const Color
                                                                  .fromARGB(255,
                                                                  215, 226, 242)
                                                              .withOpacity(.69),
                                                          width: 1,
                                                        ),
                                                        Expanded(
                                                            child: recomendedmatch[
                                                                        "Shortlisted"] ==
                                                                    true
                                                                ? TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      //  onShortlistPressed!();
                                                                    },
                                                                    child: Row(
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              8.0),
                                                                          child:
                                                                              SizedBox(
                                                                            height:
                                                                                22,
                                                                            width:
                                                                                22,
                                                                            child:
                                                                                Image.asset("assets/icons/Shortlisted.png"),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          AppLocalizations.of(context)!
                                                                              .shortlisted,
                                                                          // "Shortlisted",
                                                                          style: CustomTextStyle
                                                                              .imageText
                                                                              .copyWith(
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontSize:
                                                                                16,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                : Obx(
                                                                    () {
                                                                      return dashboardController.hasShortlisted(recomendedmatch["member_id"]) ==
                                                                              false
                                                                          ? TextButton(
                                                                              onPressed: () {
                                                                                //   onShortlistPressed!();
                                                                                dashboardController.shortlistMember(memberid: recomendedmatch["member_id"]);
                                                                              },
                                                                              child: Row(
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: SizedBox(
                                                                                      height: 22,
                                                                                      width: 22,
                                                                                      child: Image.asset("assets/star.png"),
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    AppLocalizations.of(context)!.shortlist,
                                                                                    // "Shortlist",
                                                                                    style: CustomTextStyle.imageText.copyWith(
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontSize: 16,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            )
                                                                          : TextButton(
                                                                              onPressed: () {
                                                                                //  onShortlistPressed!();
                                                                              },
                                                                              child: Row(
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: SizedBox(
                                                                                      height: 22,
                                                                                      width: 22,
                                                                                      child: Image.asset("assets/icons/Shortlisted.png"),
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    AppLocalizations.of(context)!.shortlisted,
                                                                                    // "Shortlisted",
                                                                                    style: CustomTextStyle.imageText.copyWith(
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontSize: 16,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            );
                                                                    },
                                                                  )),
                                                      ],
                                                    )
                                        ],
                                      ),
                                    ),
                                  ),
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
                                                  ? "View All Recommended"
                                                  : "तुमच्यासाठी सुचवलेले ",
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
                                              language == "en"
                                                  ? "Matches"
                                                  : "सर्व प्रोफाईल्स बघा",
                                              style: CustomTextStyle
                                                  .bodytextbold
                                                  .copyWith(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 530,
                                      width: 310,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 290),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                      } else {
                        final recomendedmatch =
                            dashboardController.recommendedmatches[index];
                        return GestureDetector(
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
                                      memberid: recomendedmatch["member_id"]),
                                ));
                              }
                            } catch (e) {
                              navigatorKey.currentState!.push(MaterialPageRoute(
                                builder: (context) => UserDetails(
                                    notificationID: 0,
                                    memberid: recomendedmatch["member_id"]),
                              ));

                              print(
                                  'Error checking for update: ${e.toString()}');
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 2, bottom: 2, top: 4),
                            child: Stack(
                              children: [
                                Container(
                                  height: 530,
                                  width: 320,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      recomendedmatch["photoUrl"] ??
                                          "${Appconstants.baseURL}/public/storage/images/download.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                // Gradient overlay
                                Container(
                                  height: 530,
                                  width: 320,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Color(0xFF0C0B0B), // #0C0B0B at 100%
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 530,
                                    width: 310,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 290),
                                        Text(
                                          recomendedmatch["last_online_time"] ??
                                              "Empty",
                                          style: CustomTextStyle.imageText,
                                        ),
                                        Text(
                                          recomendedmatch["member_name"],
                                          style: CustomTextStyle.imageText
                                              .copyWith(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.white),
                                        ),
                                        RichText(
                                          text: TextSpan(children: <TextSpan>[
                                            TextSpan(
                                                text: language == "en"
                                                    ? "Member ID - "
                                                    : "मेंबर आयडी - ",
                                                style: CustomTextStyle.imageText
                                                    .copyWith(fontSize: 14)),
                                            TextSpan(
                                                text: recomendedmatch[
                                                    "member_profile_id"],
                                                style: CustomTextStyle.imageText
                                                    .copyWith(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w800)),
                                          ]),
                                        ),
                                        const SizedBox(height: 10),
                                        RichText(
                                          text: TextSpan(
                                            children: <InlineSpan>[
                                              TextSpan(
                                                text:
                                                    "${recomendedmatch["age"]} Yrs, ${recomendedmatch["height"]} ",
                                                style:
                                                    CustomTextStyle.imageText,
                                              ),
                                              WidgetSpan(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 4.0,
                                                      vertical: 4),
                                                  child: Container(
                                                    width: 6.0,
                                                    height: 6.0,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                                  255,
                                                                  215,
                                                                  215,
                                                                  215)
                                                              .withOpacity(0.5),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              TextSpan(
                                                text: recomendedmatch[
                                                    "marital_status"],
                                                style:
                                                    CustomTextStyle.imageText,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 1),
                                        RichText(
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(children: <InlineSpan>[
                                            TextSpan(
                                              text: recomendedmatch["section"],
                                              style: CustomTextStyle.imageText,
                                            ),
                                            const TextSpan(text: " - "),
                                            TextSpan(
                                              text: recomendedmatch["subcaste"],
                                              style: CustomTextStyle.imageText,
                                            ),
                                          ]),
                                        ),
                                        const SizedBox(height: 1),
                                        // Aligning the city and state name with the text above and below
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "${recomendedmatch["permanent_city_name"]}, ${recomendedmatch["permanent_state_name"]}",
                                                style:
                                                    CustomTextStyle.imageText,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 1),
                                        RichText(
                                          text: TextSpan(
                                            children: <InlineSpan>[
                                              TextSpan(
                                                text:
                                                    "${recomendedmatch["occupation"]} ",
                                                style:
                                                    CustomTextStyle.imageText,
                                              ),
                                              WidgetSpan(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 4.0,
                                                      vertical: 4),
                                                  child: Container(
                                                    width: 6.0,
                                                    height: 6.0,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                                  255,
                                                                  215,
                                                                  215,
                                                                  215)
                                                              .withOpacity(0.5),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    "${recomendedmatch["annual_income"]}",
                                                style:
                                                    CustomTextStyle.imageText,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        Divider(
                                          height: 2,
                                          color: const Color.fromARGB(
                                                  255, 215, 226, 242)
                                              .withOpacity(.69),
                                        ),
                                        recomendedmatch[
                                                    "interest_received_status"] ==
                                                "1"
                                            ? Obx(
                                                () {
                                                  if (dashboardController
                                                      .hasaccepted(
                                                          recomendedmatch[
                                                              "member_id"])) {
                                                    return Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center, // Center the row
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        // Decline button

                                                        // Accept button
                                                        Expanded(
                                                          // Use Expanded to ensure both buttons take equal space
                                                          child: TextButton(
                                                            onPressed: () {},
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center, // Center the content inside
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child:
                                                                      SizedBox(
                                                                    height: 22,
                                                                    width: 22,
                                                                    child: Image
                                                                        .asset(
                                                                            "assets/accept.png"),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .accepted,
                                                                  style: CustomTextStyle
                                                                      .imageText
                                                                      .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  } else if (dashboardController
                                                      .hasdeclined(
                                                          recomendedmatch[
                                                              "member_id"])) {
                                                    return Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center, // Center the row
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        // Decline button
                                                        Expanded(
                                                          // Use Expanded to ensure both buttons take equal space
                                                          child: TextButton(
                                                            onPressed: () {},
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center, // Center the content inside
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child:
                                                                      SizedBox(
                                                                    height: 22,
                                                                    width: 22,
                                                                    child: Image
                                                                        .asset(
                                                                            "assets/decline.png"),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "Declined",
                                                                  style: CustomTextStyle
                                                                      .imageText
                                                                      .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        16,
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
                                                          MainAxisAlignment
                                                              .center, // Center the row
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        // Decline button
                                                        Expanded(
                                                          // Use Expanded to ensure both buttons take equal space
                                                          child: TextButton(
                                                            onPressed: () {
                                                              showDialog(
                                                                barrierDismissible:
                                                                    false,
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return DeclineInterestDialogue(
                                                                    matchid:
                                                                        recomendedmatch[
                                                                            "member_id"],
                                                                  );
                                                                },
                                                              );
                                                              //  _dashboardController.declinerequest(memberid: matchData["member_id"]);
                                                            },
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center, // Center the content inside
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child:
                                                                      SizedBox(
                                                                    height: 22,
                                                                    width: 22,
                                                                    child: Image
                                                                        .asset(
                                                                            "assets/decline.png"),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "Decline",
                                                                  style: CustomTextStyle
                                                                      .imageText
                                                                      .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),

                                                        // Divider between buttons
                                                        Container(
                                                          height: 16,
                                                          color: const Color
                                                                  .fromARGB(255,
                                                                  215, 226, 242)
                                                              .withOpacity(.69),
                                                          width: 1,
                                                        ),

                                                        // Accept button
                                                        Expanded(
                                                          // Use Expanded to ensure both buttons take equal space
                                                          child: TextButton(
                                                            onPressed: () {
                                                              showDialog(
                                                                barrierDismissible:
                                                                    false,
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AcceptInterestDialogue(
                                                                    matchid:
                                                                        recomendedmatch[
                                                                            "member_id"],
                                                                  );
                                                                },
                                                              );
                                                              //  _dashboardController.acceptedrequest(memberid: matchData["member_id"]);
                                                            },
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center, // Center the content inside
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child:
                                                                      SizedBox(
                                                                    height: 22,
                                                                    width: 22,
                                                                    child: Image
                                                                        .asset(
                                                                            "assets/accept.png"),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "Accept",
                                                                  style: CustomTextStyle
                                                                      .imageText
                                                                      .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                },
                                              )
                                            : recomendedmatch[
                                                        "interest_received_status"] ==
                                                    "2"
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0,
                                                            bottom: 8.0),
                                                    child: Container(
                                                      height: 100,
                                                      decoration: BoxDecoration(
                                                          color: const Color
                                                                  .fromARGB(255,
                                                                  234, 52, 74)
                                                              .withOpacity(
                                                                  0.47),
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10))),
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        4.0),
                                                                child: SizedBox(
                                                                  height: 22,
                                                                  width: 22,
                                                                  child: Image
                                                                      .asset(
                                                                          "assets/heartbreak.png"),
                                                                ),
                                                              ),
                                                              Text(
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                language == "en"
                                                                    ? "You Declined Their Invitation. This member cannot be contacted. !"
                                                                    : "तुम्ही त्यांचा इंटरेस्ट नाकारला आहे. त्यामुळे या मेंबरला जोडले जाऊ शकत नाही.",
                                                                style: CustomTextStyle
                                                                    .imageText
                                                                    .copyWith(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w800,
                                                                        fontSize:
                                                                            14),
                                                              )
                                                            ],
                                                          )),
                                                    ),
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(child: Obx(
                                                        () {
                                                          return dashboardController
                                                                      .hasExpressedInterest(
                                                                          recomendedmatch[
                                                                              "member_id"]) ==
                                                                  false
                                                              ? TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return ExpressInterestDialogue(
                                                                          memberID:
                                                                              recomendedmatch["member_id"],
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            SizedBox(
                                                                          height:
                                                                              22,
                                                                          width:
                                                                              22,
                                                                          child:
                                                                              Image.asset("assets/heartborder.png"),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        AppLocalizations.of(context)!
                                                                            .interest,
                                                                        style: CustomTextStyle
                                                                            .imageText
                                                                            .copyWith(
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          fontSize:
                                                                              16,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              : TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    //  onInterestPressed!();
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            4.0),
                                                                        child:
                                                                            SizedBox(
                                                                          height:
                                                                              22,
                                                                          width:
                                                                              22,
                                                                          child:
                                                                              Image.asset("assets/icons/Interested.png"),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        AppLocalizations.of(context)!
                                                                            .interestSent,
                                                                        style: CustomTextStyle
                                                                            .imageText
                                                                            .copyWith(
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          fontSize:
                                                                              16,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                        },
                                                      )),
                                                      Container(
                                                        height: 16,
                                                        color: const Color
                                                                .fromARGB(255,
                                                                215, 226, 242)
                                                            .withOpacity(.69),
                                                        width: 1,
                                                      ),
                                                      Expanded(
                                                          child: recomendedmatch[
                                                                      "Shortlisted"] ==
                                                                  true
                                                              ? TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    //  onShortlistPressed!();
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            SizedBox(
                                                                          height:
                                                                              22,
                                                                          width:
                                                                              22,
                                                                          child:
                                                                              Image.asset("assets/icons/Shortlisted.png"),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        AppLocalizations.of(context)!
                                                                            .shortlisted,
                                                                        // "Shortlisted",
                                                                        style: CustomTextStyle
                                                                            .imageText
                                                                            .copyWith(
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          fontSize:
                                                                              16,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              : Obx(
                                                                  () {
                                                                    return dashboardController.hasShortlisted(recomendedmatch["member_id"]) ==
                                                                            false
                                                                        ? TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              //   onShortlistPressed!();
                                                                              dashboardController.shortlistMember(memberid: recomendedmatch["member_id"]);
                                                                            },
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: SizedBox(
                                                                                    height: 22,
                                                                                    width: 22,
                                                                                    child: Image.asset("assets/star.png"),
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  AppLocalizations.of(context)!.shortlist,
                                                                                  // "Shortlist",
                                                                                  style: CustomTextStyle.imageText.copyWith(
                                                                                    fontWeight: FontWeight.w600,
                                                                                    fontSize: 16,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )
                                                                        : TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              //  onShortlistPressed!();
                                                                            },
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: SizedBox(
                                                                                    height: 22,
                                                                                    width: 22,
                                                                                    child: Image.asset("assets/icons/Shortlisted.png"),
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  AppLocalizations.of(context)!.shortlisted,
                                                                                  // "Shortlisted",
                                                                                  style: CustomTextStyle.imageText.copyWith(
                                                                                    fontWeight: FontWeight.w600,
                                                                                    fontSize: 16,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          );
                                                                  },
                                                                )),
                                                    ],
                                                  )
                                      ],
                                    ),
                                  ),
                                )
                              ],
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
      },
    );
  }
}

class PremiumTag extends StatelessWidget {
  const PremiumTag({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 199, 56),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), // Sharp corner
            topRight: Radius.circular(0), // Sharp corner
            bottomLeft: Radius.circular(0), // Sharp corner
            bottomRight: Radius.circular(0), // Sharp corner
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 10,
              width: 10,
              child: Image.asset("assets/premiumblack.png"),
            ),
            const SizedBox(
              width: 5,
            ),
            const Text(
              "PREMIUM",
              style: TextStyle(
                fontSize: 10,
                fontFamily: "WORKSANS",
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 5, 28, 60),
              ),
            ),
          ],
        ));
  }
}
