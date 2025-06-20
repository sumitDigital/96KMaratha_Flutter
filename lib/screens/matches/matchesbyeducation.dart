// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:_96kuliapp/commons/dialogues/acceptInterestDialogue.dart';
import 'package:_96kuliapp/commons/dialogues/declineInterestDialogue.dart';
import 'package:_96kuliapp/commons/dialogues/expressInterest.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/homescreen.dart';
import 'package:_96kuliapp/screens/profile_screens/user_details.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/screens/matches/RecommendedMatches.dart';
import 'package:_96kuliapp/utils/newmatches.dart';
import 'package:_96kuliapp/utils/verificationTag.dart';
import 'package:shimmer/shimmer.dart';

class MatchesByEducation extends StatefulWidget {
  const MatchesByEducation({super.key});

  @override
  State<MatchesByEducation> createState() => _MatchesByEducationState();
}

class _MatchesByEducationState extends State<MatchesByEducation> {
  final DashboardController _dashboardController =
      Get.find<DashboardController>();
  final controller = ScrollController();
  String? language = sharedPreferences?.getString("Language");

  @override
  void initState() {
    super.initState();

    // Fetch data initially when the page loads
    _dashboardController.fetchmatchesByEducation();

    // Add scroll listener for pagination
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        // Fetch more data when the user scrolls to the bottom, but only if not already fetching
        _dashboardController.fetchmatchesByEducation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //  _dashboardController.fetchIntrestReceivedList();
    // _dashboardController.fetchIntrestReceivedList();

    return Obx(
      () {
        if (_dashboardController.matchesbyEducationList.isEmpty &&
            _dashboardController.matchesbyeducationListfetching.value ==
                false) {
          return RefreshIndicator(
            onRefresh: () {
              return Future(() async {
                _dashboardController.recommendedbyEducationpage.value = 1;
                _dashboardController.matchesByEducationhasMore.value = true;
                _dashboardController.matchesbyEducationList.clear();
                _dashboardController.matchesbyeducationListfetching.value =
                    true;

                await _dashboardController.fetchmatchesByEducation();
              });
            },
            child: ListView(
              children: const [
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "No Data Found, ",
                          style: CustomTextStyle.title,
                        ),
                        SizedBox(height: 8),
                        Icon(
                          Icons.arrow_downward,
                          size: 24,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Scroll down to refresh",
                          style: CustomTextStyle.title,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return RefreshIndicator(
            onRefresh: () {
              return Future(
                () async {
                  _dashboardController.recommendedbyEducationpage.value = 1;
                  _dashboardController.matchesByEducationhasMore.value = true;
                  _dashboardController.matchesbyEducationList.clear();

                  await _dashboardController.fetchmatchesByEducation();
                },
              );
            },
            child: ListView.builder(
              controller: controller,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _dashboardController.matchesbyEducationList.length + 1,
              itemBuilder: (context, index) {
                // Check if the index is less than the data length
                if (index <
                    _dashboardController.matchesbyEducationList.length) {
                  // Access the current match data
                  var matchData =
                      _dashboardController.matchesbyEducationList[index];

                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: GestureDetector(
                      onTap: () {
                        navigatorKey.currentState!.push(MaterialPageRoute(
                          builder: (context) => UserDetails(
                              notificationID: 0,
                              memberid: matchData["member_id"]),
                        ));
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
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
                            matchData["is_premium"] == "1"
                                ? const Positioned(
                                    top: 15,
                                    right: 0,
                                    child: PremiumTag(),
                                  )
                                : const SizedBox(),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SizedBox(
                                height: 530,
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 320),
                                    Text(
                                      matchData[
                                          "last_online_time"], // Example date, replace with dynamic value
                                      style: CustomTextStyle.imageText,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          matchData["member_name"] +
                                              " ", // Replace with dynamic name
                                          style: CustomTextStyle.imageText
                                              .copyWith(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                          ),
                                        ),
                                        matchData["is_Document_Verification"] ==
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
                                          style: CustomTextStyle.imageText
                                              .copyWith(fontSize: 14),
                                        ),
                                        TextSpan(
                                          text: matchData[
                                              "member_profile_id"], // Replace with dynamic ID
                                          style: CustomTextStyle.imageText
                                              .copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ]),
                                    ),
                                    const SizedBox(height: 10),
                                    // Details like age, marital status, location, etc.
                                    buildRichText(
                                        "${matchData["age"]} Yrs, ${matchData["height"]}",
                                        "${matchData["marital_status"]}"), // Replace with dynamic values
                                    buildRichText("${matchData["subcaste"]}",
                                        "${matchData["present_city_name"]}, ${matchData["permanent_state_name"]}"), // Dynamic values
                                    buildRichText("${matchData["education"]}",
                                        "${matchData["annual_income"]}"), // Dynamic values
                                    const Spacer(),
                                    Divider(
                                      height: 2,
                                      color: const Color.fromARGB(
                                              255, 215, 226, 242)
                                          .withOpacity(.69),
                                    ),
                                    buildBottomActions(
                                        matchData["member_id"], matchData),
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
                  if (_dashboardController.matchesbyEducationList.isEmpty &&
                      _dashboardController
                          .matchesbyeducationListfetching.value) {
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
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return GetBuilder<DashboardController>(
                      id: 'no_more_data_for_education',
                      builder: (controller) {
                        return Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Center(
                              child: _dashboardController
                                      .matchesByEducationhasMore.value
                                  ? Shimmer.fromColors(
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
                                    )
                                  : const Padding(
                                      padding:
                                          EdgeInsets.only(top: 8.0, bottom: 18),
                                      child: Text.rich(
                                        textAlign: TextAlign.center,
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                                text:
                                                    "  End of the list! Come back later for New profiles. ",
                                                style: CustomTextStyle.title),
                                          ],
                                        ),
                                      ),
                                    )),
                        );
                      },
                    );
                  }
                }
              },
            ),
          );
        }
      },
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

  // Bottom action buttons for Interest and Shortlist
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
                  onPressed: () {},
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
                      onPressed: () {},
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
                            AppLocalizations.of(context)!.interestSent,
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
                    child: memberdata["Shortlisted"] == true
                        ? TextButton(
                            onPressed: () {},
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
                                        "assets/icons/Shortlisted.png"),
                                  ),
                                ),
                                Text(
                                  AppLocalizations.of(context)!.shortlisted,
                                  style: CustomTextStyle.imageText.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Obx(() {
                            return _dashboardController.hasShortlisted(
                                        memberdata["member_id"]) ==
                                    false
                                ? TextButton(
                                    onPressed: () {
                                      _dashboardController.shortlistMember(
                                          memberid: memberdata["member_id"]);
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
                                            child:
                                                Image.asset("assets/star.png"),
                                          ),
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .shortlist,
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
                                    onPressed: () {},
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
                                                "assets/icons/Shortlisted.png"),
                                          ),
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .shortlisted,
                                          style: CustomTextStyle.imageText
                                              .copyWith(
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
                              onPressed: () {},
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
                              onPressed: () {},
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
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return DeclineInterestDialogue(
                                      matchid: memberdata["member_id"],
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
                                    AppLocalizations.of(context)!.decline,
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
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return AcceptInterestDialogue(
                                      matchid: memberdata["member_id"],
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
                                    AppLocalizations.of(context)!.accept,
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
                          Expanded(
                            child: Obx(() {
                              return _dashboardController.hasExpressedInterest(
                                          memberdata["member_id"]) ==
                                      false
                                  ? TextButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return ExpressInterestDialogue(
                                              memberID: memberdata["member_id"],
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
                                                  "assets/heartborder.png"),
                                            ),
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .interest,
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
                                      onPressed: () {},
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
                                                .interestSent,
                                            style: CustomTextStyle.imageText
                                                .copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                            }),
                          ),
                          Container(
                            height: 16,
                            color: const Color.fromARGB(255, 215, 226, 242)
                                .withOpacity(.69),
                            width: 1,
                          ),
                          Expanded(
                            child: memberdata["Shortlisted"] == true
                                ? TextButton(
                                    onPressed: () {},
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
                                                "assets/icons/Shortlisted.png"),
                                          ),
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .shortlisted,
                                          style: CustomTextStyle.imageText
                                              .copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Obx(() {
                                    return _dashboardController.hasShortlisted(
                                                memberdata["member_id"]) ==
                                            false
                                        ? TextButton(
                                            onPressed: () {
                                              _dashboardController
                                                  .shortlistMember(
                                                      memberid: memberdata[
                                                          "member_id"]);
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    height: 15,
                                                    width: 22,
                                                    child: Image.asset(
                                                        "assets/star.png"),
                                                  ),
                                                ),
                                                Text(
                                                  // "Shortlist",
                                                  AppLocalizations.of(context)!
                                                      .shortlist,
                                                  style: CustomTextStyle
                                                      .imageText
                                                      .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : TextButton(
                                            onPressed: () {},
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center, // Center the content inside
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    height: 22,
                                                    width: 22,
                                                    child: Image.asset(
                                                        "assets/icons/Shortlisted.png"),
                                                  ),
                                                ),
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .shortlisted,
                                                  style: CustomTextStyle
                                                      .imageText
                                                      .copyWith(
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
                      );
  }
}
