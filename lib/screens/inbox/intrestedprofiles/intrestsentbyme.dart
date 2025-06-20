import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/commons/dialogues/cancelInterestDialogue.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/profile_screens/user_details.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/newmatches.dart';
import 'package:_96kuliapp/utils/verificationTag.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InterestSentByMe extends StatefulWidget {
  const InterestSentByMe({super.key});

  @override
  State<InterestSentByMe> createState() => _InterestSentByMeState();
}

class _InterestSentByMeState extends State<InterestSentByMe> {
  final DashboardController _dashboardController =
      Get.find<DashboardController>();
  final controller = ScrollController();

  String? language = sharedPreferences?.getString("Language");

  @override
  void initState() {
    super.initState();
    //   _dashboardController.fetchCountDetails();

    // Fetch data initially when the page loads

    //     _dashboardController.fetchIntrestSentByMeList();

    // Add scroll listener for pagination
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        // Fetch more data when the user scrolls to the bottom, but only if not already fetching

        _dashboardController.fetchIntrestSentByMeList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //  _dashboardController.fetchIntrestReceivedList();
    // _dashboardController.fetchIntrestReceivedList();

    return Obx(
      () {
        if (_dashboardController.intrestSentByMeList.isEmpty &&
            _dashboardController.intrestSentbyMefetching.value == false) {
          return RefreshIndicator(
            onRefresh: () {
              return Future(() async {
                _dashboardController.intrestSentbyMePage.value = 1;
                _dashboardController.intrestSentByMehasMore.value = true;
                _dashboardController.intrestSentByMeList.clear();
                _dashboardController.intrestSentbyMefetching.value = true;
                _dashboardController.fetchCountDetails();

                await _dashboardController.fetchIntrestSentByMeList();
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
                _dashboardController.intrestSentbyMePage.value = 1;
                _dashboardController.intrestSentByMehasMore.value = true;
                _dashboardController.intrestSentByMeList.clear();
                _dashboardController.intrestSentbyMefetching.value = true;
                _dashboardController.fetchCountDetails();

                await _dashboardController.fetchIntrestSentByMeList();
              });
            },
            child: ListView.builder(
              controller: controller,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _dashboardController.intrestSentByMeList.length + 1,
              itemBuilder: (context, index) {
                // Check if the index is less than the data length
                if (index < _dashboardController.intrestSentByMeList.length) {
                  // Access the current match data
                  var matchData =
                      _dashboardController.intrestSentByMeList[index];
                  print("This is sent id ${matchData["member_id"]}");
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
                                          text: matchData["member_profile_id"],
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
                                                "${matchData["age"]} Yrs , ${matchData["height"]} ",
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
                                                "${matchData["marital_status"]}",
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
                                            text: matchData["subcaste"],
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
                                                " ${matchData["permanent_city_name"]}, ${matchData["permanent_state_name"]}",
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
                                                    ? "You sent interest to this profile. Look at other profiles till their reply."
                                                    : "आपण या प्रोफाईलला आवड पाठवली आहे. त्यांचे उत्तर येईपर्यंत इतर प्रोफाईल्स पहा.",
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
                                    Row(
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
                                                  return CancleInterestDialogue(
                                                    matchid:
                                                        matchData["member_id"],
                                                  );
                                                },
                                              );
                                            },
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
                                                        "assets/icons/Pending.png"),
                                                  ),
                                                ),
                                                Text(
                                                  language == "en"
                                                      ? "Pending"
                                                      : "प्रलंबित",
                                                  style: CustomTextStyle
                                                      .imageText
                                                      .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    )
                                  ],
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
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  // Show loader or 'End of List' when all items are loaded
                  if (_dashboardController.intrestSentByMeList.isEmpty &&
                      _dashboardController.intrestSentbyMefetching.value) {
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
                      id: 'no_more_data_for_Intrest_accepted_ByThem',
                      builder: (controller) {
                        return Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Center(
                              child: _dashboardController
                                      .intrestSentByMehasMore.value
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
