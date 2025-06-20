import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/commons/dialogues/acceptInterestDialogue.dart';
import 'package:_96kuliapp/commons/dialogues/declineInterestDialogue.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/profile_screens/user_details.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/newmatches.dart';
import 'package:_96kuliapp/utils/verificationTag.dart';
import 'package:shimmer/shimmer.dart';

class InterestReceived extends StatefulWidget {
  const InterestReceived({super.key});

  @override
  State<InterestReceived> createState() => _InterestReceivedState();
}

class _InterestReceivedState extends State<InterestReceived> {
  final DashboardController _dashboardController =
      Get.find<DashboardController>();
  final controller = ScrollController();
  String? language; /* = sharedPreferences?.getString("Language"); */

  @override
  void initState() {
    super.initState();
    /* String? */ language = sharedPreferences?.getString("Language");
    print("languageMain $language");
    // Fetch data initially when the page loads
    _dashboardController.fetchIntrestReceivedList();

    // Add scroll listener for pagination
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        // Fetch more data when the user scrolls to the bottom, but only if not already fetching
        _dashboardController.fetchIntrestReceivedList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //  _dashboardController.fetchIntrestReceivedList();
    // _dashboardController.fetchIntrestReceivedList();

    return Obx(
      () {
        if (_dashboardController.intrestreceivedList.isEmpty &&
            _dashboardController.intrestReceivedfetching.value == false) {
          return RefreshIndicator(
            onRefresh: () {
              return Future(() async {
                _dashboardController.intrestreceivedPage.value = 1;
                _dashboardController.intrestreceivedhasMore.value = true;
                _dashboardController.intrestreceivedList.clear();
                _dashboardController.intrestReceivedfetching.value = true;

                await _dashboardController.fetchIntrestReceivedList();
              });
            },
            child: ListView(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.nodatafound,
                          style: CustomTextStyle.title,
                        ),
                        const SizedBox(height: 8),
                        const Icon(
                          Icons.arrow_downward,
                          size: 24,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.scrolldowntorefresh,
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
              return Future(() async {
                _dashboardController.intrestreceivedPage.value = 1;
                _dashboardController.intrestreceivedhasMore.value = true;
                _dashboardController.intrestreceivedList.clear();
                _dashboardController.intrestReceivedfetching.value = true;

                await _dashboardController.fetchIntrestReceivedList();
              });
            },
            child: ListView.builder(
              controller: controller,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _dashboardController.intrestreceivedList.length + 1,
              itemBuilder: (context, index) {
                // Check if the index is less than the data length
                if (index < _dashboardController.intrestreceivedList.length) {
                  // Access the current match data
                  var matchData =
                      _dashboardController.intrestreceivedList[index];

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
                        padding:
                            const EdgeInsets.only(right: 4, bottom: 4, top: 4),
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
                                      "${Appconstants.baseURL}/public/storage/images/download.png",
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
                                    const Spacer(),
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
                                              .copyWith(fontSize: 14)),
                                      TextSpan(
                                          text:
                                              "${matchData["member_profile_id"]} ",
                                          style: CustomTextStyle.imageText
                                              .copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w800)),
                                    ])),
                                    const SizedBox(height: 10),
                                    RichText(
                                      text: TextSpan(
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text:
                                                "${matchData["age"]} Yrs, ${matchData["height"]}",
                                            style: CustomTextStyle.imageText,
                                          ),
                                          WidgetSpan(
                                            child: Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 4.0,
                                                  vertical:
                                                      4), // Adjust the padding as needed
                                              child: Container(
                                                width:
                                                    6.0, // Adjust size for the circle
                                                height: 6.0,
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                          255, 215, 215, 215)
                                                      .withOpacity(
                                                          0.5), // Set the color of the circle
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                "${matchData["marital_status"]} ",
                                            style: CustomTextStyle.imageText,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 1,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text: "${matchData["subcaste"]}",
                                            style: CustomTextStyle.imageText,
                                          ),
                                          WidgetSpan(
                                            child: Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 4.0,
                                                  vertical:
                                                      4), // Adjust the padding as needed
                                              child: Container(
                                                width:
                                                    6.0, // Adjust size for the circle
                                                height: 6.0,
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                          255, 215, 215, 215)
                                                      .withOpacity(
                                                          0.4), // Set the color of the circle
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                "${matchData["present_city_name"]}, ${matchData["permanent_state_name"]}",
                                            style: CustomTextStyle.imageText,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 1,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                    255, 235, 237, 239)
                                                .withOpacity(0.37),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                                textAlign: TextAlign.center,
                                                language == "en"
                                                    ? "Hello, I like your Profile. Accept my request if my profile interests you too."
                                                    : "मला तुमची प्रोफाईल आवडली आहे. तुम्हाला देखील माझी प्रोफाईल आवडली असेल तर इंटरेस्ट स्वीकारा ",
                                                style:
                                                    CustomTextStyle.imageText),
                                          ),
                                        ),
                                      ),
                                    ),

                                    /*   Text("28 Years, 5'5    Shwetambar-Khandwal",
                                  style: CustomTextStyle.imageText),
                              Text(
                                "Never Married     Pune, Ahemadnagar",
                                style: CustomTextStyle.imageText,
                              ),
                              Text(
                                "Marketing Professional    30-35 Lakhs",
                                style: CustomTextStyle.imageText,
                              ),*/
                                    Divider(
                                      height: 2,
                                      color: const Color.fromARGB(
                                              255, 215, 226, 242)
                                          .withOpacity(.69),
                                    ),
                                    Obx(
                                      () {
                                        if (_dashboardController.hasaccepted(
                                            matchData["member_id"])) {
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center, // Center the row
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
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
                                                        style: CustomTextStyle
                                                            .imageText
                                                            .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
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
                                            .hasdeclined(
                                                matchData["member_id"])) {
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center, // Center the row
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
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
                                                                .all(8.0),
                                                        child: SizedBox(
                                                          height: 22,
                                                          width: 22,
                                                          child: Image.asset(
                                                              "assets/decline.png"),
                                                        ),
                                                      ),
                                                      Text(
                                                        "Declined",
                                                        style: CustomTextStyle
                                                            .imageText
                                                            .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
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
                                            mainAxisAlignment: MainAxisAlignment
                                                .center, // Center the row
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              // Decline button
                                              Expanded(
                                                // Use Expanded to ensure both buttons take equal space
                                                child: TextButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return DeclineInterestDialogue(
                                                          matchid: matchData[
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
                                                                .all(8.0),
                                                        child: SizedBox(
                                                          height: 22,
                                                          width: 22,
                                                          child: Image.asset(
                                                              "assets/decline.png"),
                                                        ),
                                                      ),
                                                      Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .decline,
                                                        style: CustomTextStyle
                                                            .imageText
                                                            .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
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
                                                color: const Color.fromARGB(
                                                        255, 215, 226, 242)
                                                    .withOpacity(.69),
                                                width: 1,
                                              ),

                                              // Accept button
                                              Expanded(
                                                // Use Expanded to ensure both buttons take equal space
                                                child: TextButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return AcceptInterestDialogue(
                                                          matchid: matchData[
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
                                                            .accept,
                                                        style: CustomTextStyle
                                                            .imageText
                                                            .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
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
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 15,
                              right: 0,
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 255, 199, 56),
                                    borderRadius: BorderRadius.only(
                                      topLeft:
                                          Radius.circular(15), // Sharp corner
                                      topRight:
                                          Radius.circular(0), // Sharp corner
                                      bottomLeft:
                                          Radius.circular(0), // Sharp corner
                                      bottomRight:
                                          Radius.circular(0), // Sharp corner
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                        width: 10,
                                        child: Image.asset(
                                            "assets/premiumblack.png"),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text(
                                        "Premium",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontFamily: "WORKSANS",
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 5, 28, 60),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  // Show loader or 'End of List' when all items are loaded
                  if (_dashboardController.intrestreceivedList.isEmpty &&
                      _dashboardController.intrestReceivedfetching.value) {
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
                      id: 'no_more_data_for_Intrest_received',
                      builder: (controller) {
                        return Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Center(
                              child: _dashboardController
                                      .intrestreceivedhasMore.value
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
                                  : Text.rich(
                                      language == "en"
                                          ? TextSpan(
                                              children: [
                                                const TextSpan(
                                                    text: "  Seems Like ",
                                                    style:
                                                        CustomTextStyle.title),
                                                const TextSpan(
                                                    text:
                                                        "you reached the End! ",
                                                    style:
                                                        CustomTextStyle.title),
                                                WidgetSpan(
                                                  child: Icon(
                                                      Icons
                                                          .emoji_emotions_rounded,
                                                      color: AppTheme
                                                          .secondryColor,
                                                      size: 20),
                                                ),
                                              ],
                                            )
                                          : TextSpan(
                                              children: [
                                                const TextSpan(
                                                    text: "  तुम्ही पेजच्या ",
                                                    style:
                                                        CustomTextStyle.title),
                                                const TextSpan(
                                                    text: "शेवटी आला आहात! ",
                                                    style:
                                                        CustomTextStyle.title),
                                                WidgetSpan(
                                                  child: Icon(
                                                      Icons
                                                          .emoji_emotions_rounded,
                                                      color: AppTheme
                                                          .secondryColor,
                                                      size: 20),
                                                ),
                                              ],
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
}
