import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/profile_screens/user_details.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/newmatches.dart';
import 'package:_96kuliapp/utils/userImageContainer.dart';
import 'package:_96kuliapp/utils/verificationTag.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IgnoredProfilesScreen extends StatefulWidget {
  const IgnoredProfilesScreen({super.key});

  @override
  State<IgnoredProfilesScreen> createState() => _IgnoredProfilesScreenState();
}

class _IgnoredProfilesScreenState extends State<IgnoredProfilesScreen> {
  final DashboardController _dashboardController =
      Get.find<DashboardController>();
  final controller = ScrollController();
  String? language = sharedPreferences?.getString("Language");

  @override
  void initState() {
    super.initState();

    // Fetch data initially when the page loads
    _dashboardController.fetchIgnoredProfilesList();

    // Add scroll listener for pagination
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        // Fetch more data when the user scrolls to the bottom, but only if not already fetching
        _dashboardController.fetchIgnoredProfilesList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //  _dashboardController.fetchIntrestReceivedList();
    // _dashboardController.fetchIntrestReceivedList();

    return Obx(
      () {
        if (_dashboardController.ignoredProfilesList.isEmpty &&
            _dashboardController.ignoredProfilesListFetching.value == false) {
          return RefreshIndicator(
            onRefresh: () {
              return Future(() async {
                _dashboardController.ignoredProfilesPage.value = 1;
                _dashboardController.ignoredProfileshasMore.value = true;
                _dashboardController.ignoredProfilesList.clear();
                _dashboardController.ignoredProfilesListFetching.value = true;

                await _dashboardController.fetchIgnoredProfilesList();
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
                _dashboardController.ignoredProfilesPage.value = 1;
                _dashboardController.ignoredProfileshasMore.value = true;
                _dashboardController.ignoredProfilesList.clear();
                _dashboardController.ignoredProfilesListFetching.value = true;

                await _dashboardController.fetchIgnoredProfilesList();
              });
            },
            child: ListView.builder(
              controller: controller,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _dashboardController.ignoredProfilesList.length + 1,
              itemBuilder: (context, index) {
                // Check if the index is less than the data length
                if (index < _dashboardController.ignoredProfilesList.length) {
                  // Access the current match data
                  var matchData =
                      _dashboardController.ignoredProfilesList[index];

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
                                  matchData["photoUrl"],
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
                                        matchData["is_Document_Verificationed"] ==
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
                                                " ${matchData["present_city_name"]}, ${matchData["present_state_name"]}",
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
                                                    255, 91, 169, 131)
                                                .withOpacity(0.6),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                                textAlign: TextAlign.center,
                                                language == "en"
                                                    ? "Changed Your Mind ?"
                                                    : "ही प्रोफाईल अनब्लॉक  करायची आहे ?",
                                                style:
                                                    CustomTextStyle.imageText),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      height: 2,
                                      color: const Color.fromARGB(
                                              255, 215, 226, 242)
                                          .withOpacity(.69),
                                    ),
                                    SizedBox(
                                      height: 50,
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return UnblockDialogue(
                                                memberID:
                                                    matchData["member_id"],
                                              );
                                            },
                                          );
                                        },
                                        child: Center(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
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
                                                  width: 15,
                                                  child: Image.asset(
                                                      "assets/unblock.png"),
                                                ),
                                              ),
                                              Text(
                                                language == "en"
                                                    ? "Unblock Now"
                                                    : "अनब्लॉक करा",
                                                style: CustomTextStyle.imageText
                                                    .copyWith(
                                                        fontSize: 14,
                                                        fontFamily: "WORKSANS",
                                                        fontWeight:
                                                            FontWeight.w700),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
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
                  if (_dashboardController.ignoredProfilesList.isEmpty &&
                      _dashboardController.ignoredProfilesListFetching.value) {
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
                      id: 'no_more_data_for_ignoredbyMe',
                      builder: (controller) {
                        return Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Center(
                              child: _dashboardController
                                      .ignoredProfileshasMore.value
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
                                      TextSpan(
                                        children: [
                                          const TextSpan(
                                              text: "  Seems Like ",
                                              style: CustomTextStyle.title),
                                          const TextSpan(
                                              text: "you reached the End! ",
                                              style: CustomTextStyle.title),
                                          WidgetSpan(
                                            child: Icon(
                                                Icons.emoji_emotions_rounded,
                                                color: AppTheme.secondryColor,
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

class UnblockDialogue extends StatelessWidget {
  const UnblockDialogue({super.key, required this.memberID});
  final int memberID;
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
                            ? "Ready to reconnect?"
                            : "ही प्रोफाईल अनब्लॉक करायची आहे?",
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
                          ? "Unblock this profile to allow you to reconnect and view this profile again."
                          : "या प्रोफाईलशी पुन्हा कनेक्ट करण्यासाठी या प्रोफाईलला अनब्लॉक करा.",
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
                        Obx(() => ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                              ),
                              onPressed:
                                  dashboardController.unblockFetching.value
                                      ? null // Disable button when loading
                                      : () {
                                          dashboardController.unblockUser(
                                              memberid: memberID);
                                          Get.back();
                                        },
                              child: dashboardController.unblockFetching.value
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors
                                            .white, // Match button text color
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      language == "en"
                                          ? "Unblock Profile"
                                          : "प्रोफाईल अनब्लॉक करा",
                                      style: CustomTextStyle
                                          .elevatedButtonWhiteLarge,
                                    ),
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: GestureDetector(
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
/*
  Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
        backgroundColor: Colors.white , side: const BorderSide(color: Colors.red )  ), 
      onPressed: (){
      Get.back();
    }, child:  const Text("Cancel" , style: CustomTextStyle.elevatedButtonSmallRed,))),
    const SizedBox(width: 10,),
                  Expanded(child:Obx(() => ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      ),
      onPressed: _dashboardController.unblockFetching.value
          ? null // Disable button when loading
          : () {
              _dashboardController.unblockUser(memberid: memberID);
              Get.back();
            },
      child: _dashboardController.unblockFetching.value
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white, // Match button text color
                strokeWidth: 2,
              ),
            )
          : const Text(
              "Unblock",
              style: CustomTextStyle.elevatedButtonSmall,
            ),
    ))
), 

                ],)
            )

/*

class AcceptInterestDialogue extends StatelessWidget {
  const AcceptInterestDialogue({super.key, required this.matchid});
  final int matchid;

  @override
  Widget build(BuildContext context) {
    final DashboardController _dashboardController = Get.put(DashboardController());
    return Dialog(child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),), 
      
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
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        "Want to Acccept Interest?",
                        style: TextStyle(
                          fontFamily: "WORKSANS",
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                        left: 18.0, right: 18, bottom: 8, top: 8),
                    child: Text(
                      textAlign: TextAlign.center,
                      "Don't think..! Accept their interest & take steps toward a new match..",
                      style: CustomTextStyle.bodytext,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
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
                         SizedBox(height: 10),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(5))),
                          ),
                          onPressed: () {
                            print("this is Member ID \$memberID");
                             _dashboardController.acceptedrequest(memberid: matchid);
                Get.back();
                          },
                          icon: SizedBox(
                            height: 14,
                            width: 14,
                            child:
                                Image.asset("assets/Express-interest-button.png"),
                          ),
                          label: const Text(
                            " ACCEPT INTEREST",
                            style: CustomTextStyle.elevatedButtonWhiteLarge,
                          ),
                        ),
                        SizedBox(height: 10,),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Row( 
                            mainAxisAlignment: MainAxisAlignment.center, 
                            children: [
                              Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: SizedBox(height: 12, child: Image.asset("assets/no-thanks.png"),),
                            ),
                                              Text(
                              " Don't Accept",
                              style: CustomTextStyle.bodytextbold,
                            ),
                                              
                            ],),
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
                    child: SizedBox(child: Image.asset(
                      height: 24, 
                      width: 24,
                      "assets/close-popup.png"),),
                  )
                ),
              ),
            ),
          ],
        ),
    ),);
  }
}
/*

          SizedBox(height: 180, width: 286, child: Image.asset("assets/acceptInterest.png"),), 

    Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
        backgroundColor: Colors.white , side: const BorderSide(color: Colors.red )  ), 
      onPressed: (){
      Get.back();
    }, child:  const Text("Cancel" , style: CustomTextStyle.elevatedButtonSmallRed,))),
    const SizedBox(width: 10,),
                  Expanded(child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),

                    ),
                    onPressed: (){
                   _dashboardController.acceptedrequest(memberid: matchid);
                Get.back();
                    

                    }, child: const Text("Accept" , style: CustomTextStyle.elevatedButtonSmall,))), 

                ],)
            ),*/*/*/
