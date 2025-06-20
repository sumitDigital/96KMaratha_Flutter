// ignore_for_file: deprecated_member_use

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/ExploreApController/exploreAppController.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/screens/auth_Screens/loginScreen2.dart';
import 'package:_96kuliapp/screens/auth_Screens/registerScreen.dart';
import 'package:_96kuliapp/utils/newmatches.dart';
import 'package:_96kuliapp/utils/verificationTag.dart';
import 'package:shimmer/shimmer.dart';
import 'package:text_divider/text_divider.dart';

class ExploReAppBeforeLoginScreen extends StatefulWidget {
  const ExploReAppBeforeLoginScreen({super.key});

  @override
  State<ExploReAppBeforeLoginScreen> createState() =>
      _ExploReAppBeforeLoginScreenState();
}

class _ExploReAppBeforeLoginScreenState
    extends State<ExploReAppBeforeLoginScreen> {
  final controller = ScrollController();

  final ExploreAppController _dashboardController =
      Get.put(ExploreAppController());
  List<String> imgURLS = [];
  final mybox = Hive.box('myBox');
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final facebookAppEvents = FacebookAppEvents();
  String? language = sharedPreferences?.getString("Language");

  @override
  void initState() {
    _dashboardController.fetchNotRegisteredList();
    _dashboardController.fetchRecommendedMatchesListBeforeLogin();
    controller.addListener(() {
      print("LISTning scroll");
      print(
          "Scroll offset: ${controller.offset}, Max extent: ${controller.position.maxScrollExtent}");
      if (controller.position.maxScrollExtent - controller.offset <= 50) {
        _dashboardController.fetchRecommendedMatchesListBeforeLogin();
      }
    });
    // TODO: implement initState
    imgURLS = [
      "${Appconstants.baseURL}/image/register-img2",
      "${Appconstants.baseURL}/image/register-img3",
      "${Appconstants.baseURL}/image/register-img4",
      "${Appconstants.baseURL}/image/register-img5",
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60,
              color: const Color.fromARGB(255, 222, 222, 226).withOpacity(0.25),
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
                            Get.back();
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
                        Text(AppLocalizations.of(context)!.browseProfiles,
                            style: CustomTextStyle.bodytextLarge),
                      ],
                    ),
                    // rgba(5, 28, 60, 1) rgba(255, 199, 56, 1) rgba(251, 214, 60, 1)
                    GestureDetector(
                      onTap: () {
                        analytics.logEvent(
                            name: "Explore_App_Register_Button_Click");
                        // You can handle the response data here
                        //  var data = jsonDecode(response.body);
                        // Do something with the data if needed
                        facebookAppEvents.logEvent(
                            name: "FB_Explore_96k_App_Register_Button_Click");
                        Get.delete<LocationController>();
                        Get.delete<ExploreAppController>();

                        navigatorKey.currentState!.pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            color: const Color.fromARGB(255, 5, 28, 60),
                            border: Border.all(
                                color:
                                    const Color.fromARGB(255, 251, 214, 60))),
                        height: 36,
                        width: 115,
                        child: Center(
                          // This centers the text
                          child: Text(
                            AppLocalizations.of(context)!.registerNow,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 255, 199, 56),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                showFullWidthDialog(context);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 18.0, horizontal: 18),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(5.0), // Set the corner radius
                  child: Image.network(
                    "${Appconstants.baseURL}/image/register-img1?lang=$language",
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
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.exploreMatches,
                    style: CustomTextStyle.title,
                  ),
                ],
              ),
            ),
            Obx(
              () {
                if (_dashboardController.exploreMatchesList.isEmpty &&
                    _dashboardController.exploreMatchesListfetching.value ==
                        false) {
                  return const SizedBox();
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _dashboardController.exploreMatchesList.length +
                        (_dashboardController.exploreMatchesList.length ~/ 5) +
                        1, // Adding space for images and loader
                    itemBuilder: (context, index) {
                      // Calculate the actual data index
                      int dataIndex = index - (index ~/ 6);

                      // Insert an image every 5 items
                      if ((index + 1) % 6 == 0) {
                        final imageIndex = ((index ~/ 6) % imgURLS.length);
                        return GestureDetector(
                          onTap: () {
                            showFullWidthDialog(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 18.0, horizontal: 18),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  5.0), // Set the corner radius
                              child: Image.network(
                                imgURLS[imageIndex],
                                height: 200,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const SizedBox();
                                },
                              ),
                            ),
                          ),
                        );
                      } else {}

                      // Check if the index is within data length
                      if (dataIndex <
                          _dashboardController.exploreMatchesList.length) {
                        var matchData =
                            _dashboardController.exploreMatchesList[dataIndex];

                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: GestureDetector(
                            onTap: () {
                              showFullWidthDialog(context);
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
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: language == "en"
                                                            ? "Member ID - "
                                                            : "मेंबर आयडी - ",
                                                        style: CustomTextStyle
                                                            .imageText
                                                            .copyWith(
                                                                fontSize: 14),
                                                      ),
                                                      TextSpan(
                                                        text: matchData[
                                                            "member_profile_id"], // Replace with dynamic ID
                                                        style: CustomTextStyle
                                                            .imageText
                                                            .copyWith(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w800,
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
                        if (_dashboardController.exploreMatchesList.isEmpty &&
                            _dashboardController
                                .exploreMatchesListfetching.value) {
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
                          return GetBuilder<ExploreAppController>(
                            id: 'no_more_data_for_reccomendation',
                            builder: (controller) {
                              return Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Center(
                                    child: _dashboardController
                                            .exploreMacthesHasMore.value
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
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 30,
                                                left: 18,
                                                right: 18),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  textAlign: TextAlign.center,
                                                  language == "en"
                                                      ? "Discover 1000+ profiles are waiting for you."
                                                      : "1000 पेक्षा जास्त प्रोफाईल्स तुमची वाट बघत आहेत.",
                                                  style: CustomTextStyle
                                                      .bodytextboldLarge,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextButton(
                                                    onPressed: () {
                                                      analytics.logEvent(
                                                          name:
                                                              "Explore_App_Register_Button_Click");
                                                      // You can handle the response data here
                                                      //  var data = jsonDecode(response.body);
                                                      // Do something with the data if needed
                                                      facebookAppEvents.logEvent(
                                                          name:
                                                              "FB_Explore_96k_App_Register_Button_Click");
                                                      navigatorKey.currentState!
                                                          .pushAndRemoveUntil(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const RegisterScreen(),
                                                        ),
                                                        (route) => false,
                                                      );
                                                    },
                                                    child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .registerNow,
                                                      style: CustomTextStyle
                                                          .textbuttonRed
                                                          .copyWith(
                                                              fontSize: 18),
                                                    ))
                                              ],
                                            ))),
                              );
                            },
                          );
                        }
                      }
                    },
                  );
                }
              },
            ),
          ],
        )),
      ),
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

  dynamic buildBottomActions(int memberid, dynamic memberdata) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: TextButton.icon(
            onPressed: () {
              // Action for the first button
              showFullWidthDialog(context);
            },
            icon: Image.asset(
                height: 20,
                "assets/telephoneborder.png"), // Add your desired icon
            label: Text(
              AppLocalizations.of(context)!.contact,
              style: CustomTextStyle.imageText.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ), // Add your desired text
          ),
        ),
        Container(
          width: 1, // Width of the line
          height: 24, // Height of the line
          color: Colors.grey, // Line color
          margin: const EdgeInsets.symmetric(
              horizontal: 8), // Spacing around the line
        ),
        Expanded(
          child: TextButton.icon(
            onPressed: () {
              // Action for the second button
              showFullWidthDialog(context);
            },
            icon: Image.asset(
                height: 20,
                "assets/Send_interest.png"), // Add your desired icon
            label: Text(
              AppLocalizations.of(context)!.interest,
              style: CustomTextStyle.imageText.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ), // Add your desired text
          ),
        ),
      ],
    );
  }

  void showFullWidthDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            width: MediaQuery.of(context).size.width, // Full screen width
            padding: const EdgeInsets.all(16), // Add padding inside the dialog
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Image.asset(
                  "assets/applogo.png",
                  height: 62,
                  width: double.infinity,
                ),
                const SizedBox(
                  height: 10,
                ),
                // rgba(5, 28, 60, 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    language == 'en'
                        ? "Looking to connect with your matches?"
                        : "या प्रोफाईलशी संपर्क करायचा आहे का?",
                    style: const TextStyle(
                        color: Color.fromARGB(
                          255,
                          5,
                          28,
                          60,
                        ),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: "WORKSANS"),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    language == 'en'
                        ? "Register your profile now to start meaningful conversations!"
                        : "तुमच्या प्रोफाईल चे रजिस्ट्रेशन पूर्ण करून आवडलेल्या प्रोफाईलशी संपर्क करा!",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Color.fromARGB(255, 80, 93, 126),
                        fontFamily: "WORKSANS"),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        analytics.logEvent(
                            name: "Explore_App_Register_Button_Click");
                        // You can handle the response data here
                        //  var data = jsonDecode(response.body);
                        // Do something with the data if needed
                        facebookAppEvents.logEvent(
                            name: "FB_Explore_96k_App_Register_Button_Click");
                        Get.delete<LocationController>();
                        Get.delete<ExploreAppController>();

                        navigatorKey.currentState!.pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.registerNow,
                        style: CustomTextStyle.elevatedButton,
                      )),
                ),
                Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextDivider.horizontal(
                    text: Text(
                      language == "en" ? "OR" : "किंवा",
                      style: CustomTextStyle.bodytext,
                    ),
                  ),
                )),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  textAlign: TextAlign.center,
                  language == "en"
                      ? "Already have a Account ?."
                      : "अकाउंट नोंदणीकृत असल्यास ",
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 80, 93, 126),
                      fontFamily: "WORKSANS"),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        facebookAppEvents.logEvent(
                            name: "FB_Explore_96k_App_Login_Button_Click");
                        analytics.logEvent(
                            name: "Explore_App_Login_Button_Click");
                        Get.delete<LocationController>();
                        Get.delete<ExploreAppController>();

                        navigatorKey.currentState!.pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen2(),
                          ),
                          (route) => false,
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.login,
                        style: CustomTextStyle.elevatedButton,
                      )),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
