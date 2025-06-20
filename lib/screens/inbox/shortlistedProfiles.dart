import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/commons/dialogues/expressInterest.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:_96kuliapp/screens/profile_screens/user_details.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/newmatches.dart';
import 'package:_96kuliapp/utils/userImageContainer.dart';
import 'package:_96kuliapp/utils/verificationTag.dart';
import 'package:shimmer/shimmer.dart';

class ShortListedProfiles extends StatefulWidget {
  const ShortListedProfiles({super.key});

  @override
  State<ShortListedProfiles> createState() => _ShortListedProfilesState();
}

class _ShortListedProfilesState extends State<ShortListedProfiles> {
  final DashboardController _dashboardController =
      Get.find<DashboardController>();
  final controller = ScrollController();

  String? language = sharedPreferences?.getString("Language");

  @override
  void initState() {
    super.initState();

    // Fetch data initially when the page loads
    _dashboardController.fetchShortlistedList();

    // Add scroll listener for pagination
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        // Fetch more data when the user scrolls to the bottom, but only if not already fetching
        _dashboardController.fetchShortlistedList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //  _dashboardController.fetchIntrestReceivedList();
    // _dashboardController.fetchIntrestReceivedList();

    return Obx(
      () {
        if (_dashboardController.shortlistedList.isEmpty &&
            _dashboardController.shortlistedListfetching.value == false) {
          return RefreshIndicator(
            onRefresh: () {
              return Future(() async {
                _dashboardController.shortlistedPage.value = 1;
                _dashboardController.shortlistedhasMore.value = true;
                _dashboardController.shortlistedList.clear();
                _dashboardController.shortlistedListfetching.value = true;

                await _dashboardController.fetchShortlistedList();
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
                          AppLocalizations.of(context)!
                              .scrolldowntorefresh, // Use localized string
                          /* language == "en"
                              ? "Scroll down to refresh"
                              : " रिफ्रेश करण्यासाठी स्क्रोल डाऊन करा. ", */
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
                _dashboardController.shortlistedPage.value = 1;
                _dashboardController.shortlistedhasMore.value = true;
                _dashboardController.shortlistedList.clear();
                _dashboardController.shortlistedListfetching.value = true;

                await _dashboardController.fetchShortlistedList();
              });
            },
            child: ListView.builder(
              controller: controller,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _dashboardController.shortlistedList.length + 1,
              itemBuilder: (context, index) {
                // Check if the index is less than the data length
                if (index < _dashboardController.shortlistedList.length) {
                  // Access the current match data
                  var matchData = _dashboardController.shortlistedList[index];

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
                                                    ? "You Shortlisted this Profile, want to connect with them ?"
                                                    : "तुम्ही सदर प्रोफाईल शॉर्टलिस्ट केली आहे. त्यांच्याशी संपर्क करायचा आहे का?",
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
                                    /*  Row(
                          mainAxisAlignment: MainAxisAlignment.start ,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          TextButton(onPressed: (){}, child: Row(children: [
                            const SizedBox(width: 7,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(height: 22, width: 22, child: Image.asset("assets/decline.png"),),
                            ) , 
                            Text("Decline" , style: CustomTextStyle.imageText.copyWith(fontWeight: FontWeight.w600 , fontSize: 16),) , 
                        
                          
                          
                          ],) ) , 
                                const SizedBox(width: 25,), 
                            Container(height: 16, color:  const Color.fromARGB(255, 215, 226, 242).withOpacity(.69),width: 1,), 
                              TextButton(onPressed: (){}, child: Row(children: [
                            const SizedBox(width: 7,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(height: 22, width: 22, child: Image.asset("assets/accept.png"),),
                            ) , 
                            Text("Accept" , style: CustomTextStyle.imageText.copyWith(fontWeight: FontWeight.w600 , fontSize: 16),) , 
                        
                          
                          
                          ],) ) , 
                          ],), */
                                    matchData["interest_sent_status"] == "3"
                                        ? Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: FittedBox(
                                                  child: TextButton.icon(
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return ShortListedDialogueForList(
                                                            memberid: matchData[
                                                                "member_id"],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    label: Text(
                                                      language == "en"
                                                          ? "Remove Shortlist"
                                                          : "शॉर्टलिस्टमधून काढा",
                                                      style: CustomTextStyle
                                                          .imageText
                                                          .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    icon: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: SizedBox(
                                                        height: 22,
                                                        width: 22,
                                                        child: Image.asset(
                                                            "assets/decline.png"),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 16,
                                                color: const Color.fromARGB(
                                                        255, 215, 226, 242)
                                                    .withOpacity(.69),
                                                width:
                                                    1, // Divider between buttons
                                              ),
                                              Expanded(
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
                                          )
                                        : matchData["interest_sent_status"] ==
                                                "1"
                                            ? Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween, // Space between buttons
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: FittedBox(
                                                      child: TextButton.icon(
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return ShortListedDialogueForList(
                                                                memberid: matchData[
                                                                    "member_id"],
                                                              );
                                                            },
                                                          );
                                                          /*      _dashboardController.removeFromShortlist(
                                memberid: matchData["member_id"],
                              );*/
                                                        },
                                                        label: Text(
                                                          language == "en"
                                                              ? "Remove Shortlist"
                                                              : "शॉर्टलिस्टमधून काढा",
                                                          style: CustomTextStyle
                                                              .imageText
                                                              .copyWith(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        icon: Padding(
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
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 16,
                                                    color: const Color.fromARGB(
                                                            255, 215, 226, 242)
                                                        .withOpacity(.69),
                                                    width:
                                                        1, // Divider between buttons
                                                  ),
                                                  Expanded(
                                                      child: TextButton(
                                                    onPressed: () {
                                                      // onInterestPressed!();
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center, // Center-align within the button
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: SizedBox(
                                                            height: 22,
                                                            width: 22,
                                                            child: Image.asset(
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
                                                                FontWeight.w600,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                                ],
                                              )
                                            : Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween, // Space between buttons
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: FittedBox(
                                                      child: TextButton.icon(
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return ShortListedDialogueForList(
                                                                memberid: matchData[
                                                                    "member_id"],
                                                              );
                                                            },
                                                          );
                                                          /*      _dashboardController.removeFromShortlist(
                                memberid: matchData["member_id"],
                              );*/
                                                        },
                                                        label: Text(
                                                          language == "en"
                                                              ? "Remove Shortlist"
                                                              : "शॉर्टलिस्टमधून काढा",
                                                          style: CustomTextStyle
                                                              .imageText
                                                              .copyWith(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        icon: Padding(
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
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 16,
                                                    color: const Color.fromARGB(
                                                            255, 215, 226, 242)
                                                        .withOpacity(.69),
                                                    width:
                                                        1, // Divider between buttons
                                                  ),
                                                  Expanded(
                                                    child: Obx(() {
                                                      return _dashboardController
                                                                  .hasExpressedInterest(
                                                                      matchData[
                                                                          "member_id"]) ==
                                                              false
                                                          ? TextButton(
                                                              onPressed: () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return ExpressInterestDialogue(
                                                                      memberID:
                                                                          matchData[
                                                                              "member_id"],
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center, // Center-align within the button
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
                                                                              "assets/heartborder.png"),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    AppLocalizations.of(
                                                                            context)!
                                                                        .interest,
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
                                                            )
                                                          : TextButton(
                                                              onPressed: () {
                                                                // onInterestPressed!();
                                                              },
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center, // Center-align within the button
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            4.0),
                                                                    child:
                                                                        SizedBox(
                                                                      height:
                                                                          22,
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
                                                            );
                                                    }),
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
                  if (_dashboardController.shortlistedList.isEmpty &&
                      _dashboardController.shortlistedListfetching.value) {
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
                      id: 'no_more_data_for_shortlisted',
                      builder: (controller) {
                        return Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Center(
                            child: _dashboardController.shortlistedhasMore.value
                                ? Shimmer.fromColors(
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
                                  )
                                : Text.rich(
                                    language == "en"
                                        ? TextSpan(
                                            children: [
                                              const TextSpan(
                                                  text: "  Seems Like ",
                                                  style: CustomTextStyle.title),
                                              const TextSpan(
                                                  text: "you reached the End! ",
                                                  style: CustomTextStyle.title),
                                              WidgetSpan(
                                                child: Icon(
                                                    Icons
                                                        .emoji_emotions_rounded,
                                                    color:
                                                        AppTheme.secondryColor,
                                                    size: 20),
                                              ),
                                            ],
                                          )
                                        : TextSpan(
                                            children: [
                                              const TextSpan(
                                                  text: "  तुम्ही पेजच्या ",
                                                  style: CustomTextStyle.title),
                                              const TextSpan(
                                                  text: "शेवटी आला आहात! ",
                                                  style: CustomTextStyle.title),
                                              WidgetSpan(
                                                child: Icon(
                                                    Icons
                                                        .emoji_emotions_rounded,
                                                    color:
                                                        AppTheme.secondryColor,
                                                    size: 20),
                                              ),
                                            ],
                                          ),
                                  ),
                          ),
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

class ShortListedDialogueForList extends StatelessWidget {
  const ShortListedDialogueForList({super.key, required this.memberid});
  final int memberid;
  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController =
        Get.find<DashboardController>();
    String? language = sharedPreferences?.getString("Language");

    return Dialog(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        language == "en"
                            ? "Remove from Shortlist?"
                            : "शॉर्टलिस्टमधून काढून टाकायचे आहे का?",
                        style: TextStyle(
                          fontFamily: "WORKSANS",
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 18.0, right: 18, bottom: 8, top: 8),
                    child: Text(
                      textAlign: TextAlign.center,
                      language == "en"
                          ? "This will remove the profile from your shortlist. Click \"Remove\" to confirm or \"Cancel\" to keep it in your list."
                          : 'प्रोफाईल शॉर्टलिस्ट मधून काढण्यासाठी "शॉर्टलिस्ट मधून काढा" बटन वर क्लिक करा',
                      style: CustomTextStyle.bodytext,
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    height: 109,
                    width: 329,
                    child: Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            height: 180,
                            width: 286,
                            child: Image.asset("assets/acceptInterest.png"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                            onPressed: () {
                              Get.back();
                              dashboardController.removeFromShortlist(
                                memberid: memberid,
                              );
                            },
                            child: Text(
                              language == "en"
                                  ? "Remove from Shortlist?"
                                  : "काढून टाका",
                              style: CustomTextStyle.elevatedButtonWhiteLarge,
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: SizedBox(
                                  height: 12,
                                  child: Image.asset("assets/no-thanks.png"),
                                ),
                              ),
                              Text(
                                // " Cancel",
                                AppLocalizations.of(context)!.cancel,
                                style: CustomTextStyle.bodytextbold,
                              ),
                            ],
                          ),
                        ),
                        /*    TextButton.icon(
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(5))),
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Get.back();
                          },
                          icon: Padding(
                            padding: const EdgeInsets.all(0),
                            child: SizedBox(height: 12, child: Image.asset("assets/no-thanks.png"),),
                          ),
                          label: const Text(
                            " No, Thanks",
                            style: CustomTextStyle.bodytextbold,
                          ),
                        ),*/
                      ],
                    ),
                  )
                ],
              ),
            ),
            // Close icon at the top right corner, half outside the dialog
            Positioned(
              top: -7,
              right: -7,
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        child: Image.asset(
                            height: 24, width: 24, "assets/close-popup.png"),
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
