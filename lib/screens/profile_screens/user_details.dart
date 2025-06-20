import 'package:flutter/services.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:_96kuliapp/commons/dialogues/acceptInterestDialogue.dart';
import 'package:_96kuliapp/commons/dialogues/declineInterestDialogue.dart';
import 'package:_96kuliapp/commons/dialogues/expressInterest.dart';
import 'package:_96kuliapp/commons/dialogues/forceblock.dart';
import 'package:_96kuliapp/commons/dialogues/ignoreProfileDialogue.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationBlock.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationBlockController.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationScreen.dart';
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/controllers/viewProfileControllers/viewprofileController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/inbox/contactView.dart';
import 'package:_96kuliapp/screens/plans/addOnPlan.dart';
import 'package:_96kuliapp/screens/plans/upgradeScreen.dart';
import 'package:_96kuliapp/screens/profile_screens/display_user_detail.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepSix.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/bottomnavBar.dart';
import 'package:_96kuliapp/utils/buttonContainer.dart';
import 'package:_96kuliapp/utils/detailcontainer.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SliderController extends GetxController {
  var currentIndex = 0.obs;
}

class ShowImages extends StatefulWidget {
  const ShowImages({super.key, this.images});
  final dynamic images;

  @override
  State<ShowImages> createState() => _ShowImagesState();
}

class _ShowImagesState extends State<ShowImages> {
  // Track current index

  bool get hasValidImages =>
      widget.images is List && (widget.images as List).isNotEmpty;
  final SliderController _sliderController = Get.put(SliderController());
  String? language = sharedPreferences?.getString("Language");

  @override
  Widget build(BuildContext context) {
    final mybox = Hive.box('myBox');

    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: EdgeInsets.zero, // Makes the dialog fullscreen
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Gives shape to the dialog
      ),
      child: Stack(
        children: [
          Column(
            children: [
              // Top bar with title and close button
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${mybox.get('gender') == 2 ? 'Her' : 'His'} Album",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: hasValidImages
                    ? CarouselSlider(
                        options: CarouselOptions(
                          viewportFraction: 1,
                          scrollDirection: Axis.horizontal,
                          enableInfiniteScroll: false,
                          enlargeCenterPage: true,
                          height: MediaQuery.of(context).size.height * 0.75,
                          onPageChanged: (index, reason) {
                            _sliderController.currentIndex.value = index;
                          },
                        ),
                        items: (widget.images as List).map<Widget>((imagePath) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Image.network(
                                  imagePath,
                                  fit: BoxFit.contain,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child; // Image has loaded
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                  Color>(Colors.white),
                                        ),
                                      );
                                    }
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Text(
                                        "Image not available",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        }).toList(),
                      )
                    : const Center(
                        child: Text(
                          "No images available",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
              ),
              Obx(() {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    hasValidImages
                        ? "${_sliderController.currentIndex.value + 1}/${(widget.images as List).length}"
                        : "",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}

class UserDetails extends StatefulWidget {
  const UserDetails(
      {super.key, required this.memberid, required this.notificationID});
  final int memberid;
  final int notificationID;
  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final ViewProfileController _viewProfileController =
      Get.put(ViewProfileController());
  final DashboardController _dashboardController =
      Get.find<DashboardController>();
  // final arguments = Get.arguments as Map<String, dynamic>;
  //late int memberid;
  late final mybox = Hive.box('myBox');
  late String gender;
  String? gender2;
  String? gender3;
  String? gender4;
  String? gender5;

  String selectgender() {
    // if (mybox.get("gender") == 2) {
    //   return "groom";
    // } else {
    //   return "bride";
    // }

    if (mybox.get("gender") == 2) {
      gender2 = "वर्षांचा";
      gender3 = "वराच्या";
      gender4 = "वराला";
      gender5 = "वराचे";
      return "वराची";
    } else {
      gender2 = "वर्षांची";
      gender3 = "वधूच्या";
      gender4 = "वधूला";
      gender5 = "वधूचे";

      return "वधूची";
    }
  }

  @override
  void initState() {
    super.initState();
    //  memberid = arguments["memberID"];
    _viewProfileController.fetchUserInfo(memberid: widget.memberid);
    _viewProfileController.AddVisitedByMeList(MemberID: widget.memberid);

    if (widget.notificationID != 0) {
      // notificationID = arguments["notificationID"];
      _viewProfileController.AddNotificationRead(
          notificationID: widget.notificationID);
    }
    selectgender();
  }

  @override
  Widget build(BuildContext context) {
    print("THIS IS USER DETAILS");

    return Obx(
      () {
        String? language = sharedPreferences?.getString("Language");
        if (_viewProfileController.loadingPage.value) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.7, // Set your desired width
                    height: 300, // Set your desired height
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color of the container
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          if (_viewProfileController.userdetail.isEmpty) {
            return const Scaffold(
              body: SafeArea(
                  child: Center(
                child: Text("Server Issue"),
              )),
            );
          } else {
            print(
                "this is member receoved status ${_viewProfileController.userdetail["memberData"]["interest_received_status"]}");
            final mybox = Hive.box('myBox');
            String gender = mybox.get("gender") == 2 ? "She" : "He";
            return WillPopScope(
              onWillPop: () async {
                if (navigatorKey.currentState!.canPop()) {
                  Get.delete<
                      ViewProfileController>(); // Deletes the controller to free up resources
                  Get.back(); // Navigates back to the previous screen
                } else {
                  Get.delete<
                      ViewProfileController>(); // Deletes the controller to free up resources

                  navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
                    builder: (context) => const BottomNavBar(),
                  ));
                }
                // Execute actions before the back button is pressed

                return false; // Allows the navigation to happen
              },
              child: Scaffold(
                  body: RefreshIndicator(
                    onRefresh: () {
                      return Future(
                        () {
                          //  int memberid = Get.arguments;
                          _viewProfileController.fetchUserInfo(
                              memberid: widget.memberid);
                        },
                      );
                    },
                    child: SingleChildScrollView(
                      child: SafeArea(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 60,
                            color: const Color.fromARGB(255, 222, 222, 226)
                                .withOpacity(0.25),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          // Execute actions before the back button is pressed
                                          if (navigatorKey.currentState!
                                              .canPop()) {
                                            Get.delete<
                                                ViewProfileController>(); // Deletes the controller to free up resources
                                            Get.back(); // Navigates back to the previous screen
                                          } else {
                                            Get.delete<
                                                ViewProfileController>(); // Deletes the controller to free up resources

                                            navigatorKey.currentState!
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                              builder: (context) =>
                                                  const BottomNavBar(),
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
                                      Obx(
                                        () {
                                          if (_viewProfileController
                                                      .userdetail["memberData"]
                                                  ["last_online_time"] ==
                                              "Online") {
                                            return Container(
                                              width:
                                                  10, // Size of the green symbol
                                              height: 10,
                                              decoration: const BoxDecoration(
                                                color: Color.fromARGB(255, 38,
                                                    193, 35), // Green color
                                                shape: BoxShape
                                                    .circle, // Circular shape
                                              ),
                                            );
                                          } else {
                                            return const SizedBox();
                                          }
                                        },
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          "${_viewProfileController.userdetail["memberData"]["last_online_time"]} ",
                                          style: CustomTextStyle.bodytext
                                              .copyWith(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          print("ONT AP");
                                          final String textUrl =
                                              "${_viewProfileController.userdetail["shereUrl"]}";
                                          Share.share(textUrl);
                                        },
                                        child: const Icon(
                                          size: 25,
                                          Icons.share,
                                          color:
                                              Color.fromARGB(255, 80, 93, 126),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      GestureDetector(
                                          onTapDown: (details) {
                                            showMenu<String>(
                                              color: Colors.white,
                                              shadowColor: Theme.of(context)
                                                  .primaryColor,
                                              context: context,
                                              position: RelativeRect.fromLTRB(
                                                details.globalPosition.dx,
                                                details.globalPosition.dy,
                                                0,
                                                0,
                                              ),
                                              items: [
                                                PopupMenuItem<String>(
                                                  value: 'ignore_profile',
                                                  child: Text(
                                                    language == 'en'
                                                        ? 'Ignore Profile'
                                                        : "प्रोफाईल दुर्लक्षित करा",
                                                    style: CustomTextStyle
                                                        .fieldName,
                                                  ),
                                                ),
                                              ],
                                              elevation: 3.0,
                                            ).then((value) {
                                              if (value == 'ignore_profile') {
                                                // Show confirmation dialog
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return IgnoreProfileDialogue(
                                                        matchid:
                                                            _viewProfileController
                                                                        .userdetail[
                                                                    "profile"]
                                                                ["member_id"]);
                                                  },
                                                );
                                              }
                                            });
                                          },
                                          child: const Icon(
                                            size: 27,
                                            Icons.more_vert,
                                            color: Color.fromARGB(
                                                255, 80, 93, 126),
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                UserProfileHeader(
                                  images: _viewProfileController
                                      .userdetail["PhotoUrl"],
                                  userdetail: _viewProfileController
                                      .userdetail["profile"],
                                  profileheader: _viewProfileController
                                      .userdetail["memberData"],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Obx(
                                  () {
                                    if (_viewProfileController
                                                .userdetail["profile"]
                                            ["isVerified"] ==
                                        "1") {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                            border: Border.all(
                                                width: 1,
                                                color: const Color.fromARGB(
                                                    255, 116, 225, 106)),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                          255, 153, 230, 153)
                                                      .withOpacity(0.59),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10),
                                                  ),
                                                ),
                                                width: double.infinity,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          textAlign:
                                                              TextAlign.center,
                                                          language == "en"
                                                              ? "Document Verification Complete"
                                                              : "कागदोपत्री व्हेरिफिकेशन पूर्ण ",
                                                          style: CustomTextStyle
                                                              .bodytextbold
                                                              .copyWith(
                                                            fontSize: 14,
                                                            color: const Color
                                                                .fromARGB(
                                                                255, 7, 150, 4),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 8.0),
                                                            child: SizedBox(
                                                              height: 35,
                                                              width: 35,
                                                              child: Image.asset(
                                                                  "assets/verified1.png"),
                                                            ),
                                                          ),
                                                          Flexible(
                                                            child: Text(
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .thisProfileIsValidatedUsingGovermentID,
                                                              style:
                                                                  CustomTextStyle
                                                                      .bodytext
                                                                      .copyWith(
                                                                color: const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    18,
                                                                    102,
                                                                    18),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      DisplayUserDetail(
                                          assetImage:
                                              "assets/icons/About_user.png",
                                          title:
                                              "${language == "en" ? "About" : ""} ${_viewProfileController.userdetail["profile"]["member_name"]} ${language == "mr" ? "बद्दल माहिती" : ""}",
                                          widget: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Obx(
                                                () {
                                                  if (_viewProfileController
                                                                  .userdetail[
                                                              "profile"]
                                                          ["about_me"] ==
                                                      "Not Filled") {
                                                    return Text(
                                                      language == "en"
                                                          ? "Hello! I have completed my ${_viewProfileController.userdetail["profile"]["highest_education_id"]} and am currently focused on ${_viewProfileController.userdetail["profile"]["employeed"]} I believe in respect, values, and self-development. I’m looking for a well-educated partner who shares these values and aims to build a meaningful connection, whether professionally settled or pursuing personal growth."
                                                          : "नमस्कार! मी माझे ${_viewProfileController.userdetail["profile"]["highest_education_id"]} पूर्ण केले आहे आणि सध्या ${_viewProfileController.userdetail["profile"]["employeed"]} वर लक्ष केंद्रित केले आहे. माझा आदर, मूल्ये आणि आत्म-विकासावर विश्वास आहे. मी एक सुशिक्षित भागीदार शोधत आहे जो ही मूल्ये सामायिक करतो आणि एक अर्थपूर्ण कनेक्शन तयार करण्याचे उद्दिष्ट ठेवतो, मग ते व्यावसायिकरित्या स्थायिक असो किंवा वैयक्तिक वाढीचा पाठपुरावा करत असो.",
                                                      style: CustomTextStyle
                                                          .bodytext,
                                                    );
                                                  } else {
                                                    return Text(
                                                      "${_viewProfileController.userdetail["profile"]["about_me"]}",
                                                      style: CustomTextStyle
                                                          .bodytext,
                                                    );
                                                  }
                                                },
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              )
                                            ],
                                          )),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .personalDetails,
                                        style: CustomTextStyle.fieldName
                                            .copyWith(fontSize: 14),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Wrap(
                                        spacing: 7,
                                        runSpacing: 7,
                                        children: [
                                          CustomContainer(
                                            height: 35,
                                            title:
                                                "${_viewProfileController.userdetail["profile"]["age"]} ${language == "en" ? "Year Old" : "वय वर्ष"}",
                                            width: 106,
                                            fontsize: 13,
                                          ),
                                          CustomContainer(
                                            height: 35,
                                            title:
                                                "${language == "en" ? "Height" : "उंची"} - ${_viewProfileController.userdetail["profile"]["height"]} ",
                                            width: 108,
                                            fontsize: 13,
                                          ),
                                          CustomContainer(
                                            height: 35,
                                            title:
                                                "${language == "en" ? "Blood Group" : "रक्तगट"} - ${_viewProfileController.userdetail["profile"]["blood_group"]}",
                                            width: 152,
                                            fontsize: 13,
                                          ),
                                          CustomContainer(
                                            height: 35,
                                            title:
                                                "${language == "en" ? "SubCaste" : "पोटजात"} - ${_viewProfileController.userdetail["profile"]["subcaste"]}",
                                            width: 152,
                                            fontsize: 13,
                                          ),
                                          // CustomContainer(
                                          //   height: 35,
                                          //   title:
                                          //       "Section - ${_viewProfileController.userdetail["profile"]["section"]}",
                                          //   width: 152,
                                          //   fontsize: 13,
                                          // ),
                                          // CustomContainer(
                                          //   height: 35,
                                          //   title:
                                          //       "Sub Section - ${_viewProfileController.userdetail["profile"]["subsection"]}",
                                          //   width: 152,
                                          //   fontsize: 13,
                                          // ),
                                          //      const CustomContainer(height: 35, title: "Skin Tone - Whiteish", width: 168 , fontsize: 13 ,),
                                          //CustomContainer(height: 35, title: "Manglik - ${_viewProfileController.userdetail["profile"]["manglik"]}", width: 152),
                                          CustomContainer(
                                              height: 35,
                                              title:
                                                  "${_viewProfileController.userdetail["profile"]["personal_marital_status"]}",
                                              width: 152),
                                          CustomContainer(
                                              height: 35,
                                              title:
                                                  "${language == "en" ? "Any Disability" : "अपंगत्व"} - ${_viewProfileController.userdetail["profile"]["disability"]}",
                                              width: 152),
                                          Obx(
                                            () {
                                              if (_viewProfileController
                                                          .userdetail["profile"]
                                                      ["complexion"] ==
                                                  "Not Filled") {
                                                return const SizedBox();
                                              } else {
                                                return CustomContainer(
                                                    height: 35,
                                                    title:
                                                        "${language == "en" ? "Skin Tone" : "रंग"} - ${_viewProfileController.userdetail["profile"]["complexion"]}",
                                                    width: 106);
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      DisplayUserDetail(
                                          assetImage:
                                              "assets/icons/Education.png",
                                          title: AppLocalizations.of(context)!
                                              .educationAndCarrerDetails,
                                          widget: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        displayFormat(
                                                            title: AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .highestEducation,
                                                            subtitle: _viewProfileController
                                                                        .userdetail[
                                                                    "profile"][
                                                                "highest_education_id"]),
                                                        displayFormat(
                                                            title: AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .employedIn,
                                                            subtitle: _viewProfileController
                                                                        .userdetail[
                                                                    "profile"]
                                                                ["employeed"]),
                                                        displayFormat(
                                                            title: AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .occupation,
                                                            subtitle: _viewProfileController
                                                                        .userdetail[
                                                                    "profile"][
                                                                "edu_occupation"]),
                                                        displayFormat(
                                                            title: AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .companyName,
                                                            subtitle: _viewProfileController
                                                                        .userdetail[
                                                                    "profile"][
                                                                "company_name"]),
                                                      ],
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        displayFormat(
                                                            title: AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .designation,
                                                            subtitle: _viewProfileController
                                                                        .userdetail[
                                                                    "profile"][
                                                                "designation"]),
                                                        displayFormat(
                                                            title: AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .annualIncome,
                                                            subtitle: _viewProfileController
                                                                        .userdetail[
                                                                    "profile"][
                                                                "edu_annual_income"]),
                                                        displayFormat(
                                                            title: AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .currentJobLocation,
                                                            subtitle: _viewProfileController
                                                                        .userdetail[
                                                                    "profile"][
                                                                "job_location"]),
                                                        displayFormat(
                                                            title: AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .workMode,
                                                            subtitle: _viewProfileController
                                                                        .userdetail[
                                                                    "profile"]
                                                                ["work_mode"]),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          )),
                                      DisplayUserDetail(
                                          assetImage:
                                              "assets/icons/Location.png",
                                          title: AppLocalizations.of(context)!
                                              .locationDetails,
                                          widget: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        displayFormat(
                                                            title: AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .presentCity,
                                                            subtitle: _viewProfileController
                                                                        .userdetail[
                                                                    "profile"][
                                                                "present_city"]),
                                                        displayFormat(
                                                            title: AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .presentState,
                                                            subtitle: _viewProfileController
                                                                        .userdetail[
                                                                    "profile"][
                                                                "present_state"]),
                                                        displayFormat(
                                                            title: AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .presentCountry,
                                                            subtitle: _viewProfileController
                                                                        .userdetail[
                                                                    "profile"][
                                                                "present_country"]),
                                                        displayFormat(
                                                            title: AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .nativePlace,
                                                            subtitle: _viewProfileController
                                                                        .userdetail[
                                                                    "profile"][
                                                                "native_place"]),
                                                      ],
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        displayFormat(
                                                            title: AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .permanentCity,
                                                            subtitle: _viewProfileController
                                                                        .userdetail[
                                                                    "profile"][
                                                                "permanent_city"]),
                                                        displayFormat(
                                                            title: AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .permanentState,
                                                            subtitle: _viewProfileController
                                                                        .userdetail[
                                                                    "profile"][
                                                                "permanent_state"]),
                                                        displayFormat(
                                                            title: AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .permanentCountry,
                                                            subtitle: _viewProfileController
                                                                        .userdetail[
                                                                    "profile"][
                                                                "permanent_country"]),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          )),
                                      SizedBox(
                                        width: double.infinity,
                                        child: Card(
                                          elevation: 2,
                                          color: Color.alphaBlend(
                                              const Color.fromARGB(
                                                      255, 37, 177, 144)
                                                  .withOpacity(0.1),
                                              Colors.white),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0,
                                                bottom: 22,
                                                right: 16,
                                                top: 12),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0,
                                                          top: 8.0,
                                                          bottom: 8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: 14,
                                                            width: 14,
                                                            child: Image.asset(
                                                                "assets/icons/ContactDetails.png"),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            language == "en"
                                                                ? "Get Direct Connection"
                                                                : "थेट संपर्क मिळवा",
                                                            style: CustomTextStyle
                                                                .bodytextbold,
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Divider(
                                                  color: const Color.fromARGB(
                                                          255, 80, 93, 128)
                                                      .withOpacity(0.5),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                /* RichText(
                    text: TextSpan(
            children: <InlineSpan>[
               
              WidgetSpan(
                child: Container(
                  width: 13.0, // Adjust size for the circle
                  height: 13.0,
                  child: Image.asset("assets/contacts.png"),
                            
                ),
              ),
              const TextSpan(
                text: " Self Mobile Number",
                style: CustomTextStyle.bodytext,
              ),
            ],
                    ),
              ),*/
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: SizedBox(
                                                        width:
                                                            13.0, // Adjust size for the circle
                                                        height: 13.0,
                                                        child: Image.asset(
                                                            "assets/contacts.png"),
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .selfContactNumber,
                                                          // "Self Mobile Number",
                                                          style: CustomTextStyle
                                                              .bodytext,
                                                        ),
                                                        Text(
                                                          "${_viewProfileController.userdetail["Contact"]["mobile"]}",
                                                          style: CustomTextStyle
                                                              .bodytextbold,
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: SizedBox(
                                                        width: 13.0,
                                                        height: 13.0,
                                                        child: Image.asset(
                                                            "assets/contacts.png"),
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          language == "en"
                                                              ? "Parents Mobile Number"
                                                              : "पालकांचा मोबाईल नंबर",
                                                          style: CustomTextStyle
                                                              .bodytext,
                                                        ),
                                                        Text(
                                                          "${_viewProfileController.userdetail["Contact"]["parents_contact_no"]}",
                                                          style: CustomTextStyle
                                                              .bodytextbold,
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: SizedBox(
                                                        width:
                                                            13.0, // Adjust size for the circle
                                                        height: 13.0,
                                                        child: Image.asset(
                                                            "assets/contacts.png"),
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .selfEmailAddress,
                                                          style: CustomTextStyle
                                                              .bodytext,
                                                        ),
                                                        Text(
                                                          "${_viewProfileController.userdetail["Contact"]["email"]}",
                                                          style: CustomTextStyle
                                                              .bodytextbold,
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      height: 12,
                                                      width: 12,
                                                      child: Image.asset(
                                                          "assets/telephonered.png"),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    InkWell(
                                                        onTap: () {
                                                          if (_viewProfileController
                                                                          .userdetail[
                                                                      "memberData"]
                                                                  [
                                                                  "ContactView"] ==
                                                              true) {
                                                            _viewProfileController
                                                                .fetchContactDetails(
                                                                    memberid: widget
                                                                        .memberid)
                                                                .then(
                                                              (value) {
                                                                showDialog(
                                                                  barrierDismissible:
                                                                      false,
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return ContactViewDetailsPopup(
                                                                        contactViewed: _viewProfileController.userdetail["memberData"]
                                                                            [
                                                                            "ContactView"],
                                                                        memberID:
                                                                            widget.memberid);
                                                                  },
                                                                );
                                                              },
                                                            );
                                                          } else {
                                                            showDialog(
                                                              barrierDismissible:
                                                                  false,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return ContactViewPopup(
                                                                  contactViewed:
                                                                      _viewProfileController
                                                                              .userdetail["memberData"]
                                                                          [
                                                                          "ContactView"],
                                                                  memberid: _viewProfileController
                                                                              .userdetail[
                                                                          "profile"]
                                                                      [
                                                                      "member_id"],
                                                                );
                                                              },
                                                            );
                                                          }
                                                        },
                                                        child: Text(
                                                          language == "en"
                                                              ? "Click to View Number"
                                                              : "संपर्क बघा ",
                                                          style: CustomTextStyle
                                                              .textbuttonRed,
                                                        ))
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      DisplayUserDetail(
                                          assetImage:
                                              "assets/icons/Family_details.png",
                                          title: AppLocalizations.of(context)!
                                              .familyDetails,
                                          widget: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        displayFormat(
                                                            title: AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .fatherName,
                                                            subtitle: _viewProfileController
                                                                        .userdetail[
                                                                    "profile"][
                                                                "father_name"]),
                                                        displayFormat(
                                                            title: AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .motherName,
                                                            subtitle: _viewProfileController
                                                                        .userdetail[
                                                                    "profile"][
                                                                "mother_name"]),
                                                        displayFormat(
                                                            title: AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .noOfbrothers,
                                                            subtitle: _viewProfileController
                                                                        .userdetail[
                                                                    "profile"][
                                                                "no_of_brothers"]),
                                                        displayFormat(
                                                            title: AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .noOfSisters,
                                                            subtitle: _viewProfileController
                                                                        .userdetail[
                                                                    "profile"][
                                                                "no_of_sisters"]),
                                                        displayFormat(
                                                            title: AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .familyType,
                                                            subtitle: _viewProfileController
                                                                        .userdetail[
                                                                    "profile"][
                                                                "family_type"]),
                                                        displayFormat(
                                                            title: AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .livingWithParents,
                                                            subtitle: _viewProfileController
                                                                        .userdetail[
                                                                    "profile"][
                                                                "living_with_parents"]),
                                                      ],
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        displayFormat(
                                                            title: AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .fatherOccupation,
                                                            subtitle: _viewProfileController
                                                                        .userdetail[
                                                                    "profile"][
                                                                "father_occupation"]),
                                                        displayFormat(
                                                            title: AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .motherOccupation,
                                                            subtitle: _viewProfileController
                                                                        .userdetail[
                                                                    "profile"][
                                                                "mother_occupation"]),
                                                        displayFormat(
                                                            title: AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .noOfMarriedBrothers,
                                                            subtitle: _viewProfileController
                                                                        .userdetail[
                                                                    "profile"][
                                                                "no_of_married_brothers"]),
                                                        displayFormat(
                                                            title: AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .noOfMarriedSisters,
                                                            subtitle: _viewProfileController
                                                                        .userdetail[
                                                                    "profile"][
                                                                "no_of_married_sisters"]),
                                                        displayFormat(
                                                            title: AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .familyAssets,
                                                            subtitle: _viewProfileController
                                                                        .userdetail[
                                                                    "profile"][
                                                                "family_assets"]),
                                                        displayFormat(
                                                            title: AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .familyStatus,
                                                            subtitle: _viewProfileController
                                                                        .userdetail[
                                                                    "profile"][
                                                                "family_status"]),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          )),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              border: Border.all(
                                                  width: 1,
                                                  color: const Color.fromARGB(
                                                      255, 255, 199, 56))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: DisplayUserDetail(
                                                assetImage:
                                                    "assets/icons/Astro_details.png",
                                                title: AppLocalizations.of(
                                                        context)!
                                                    .astroDetails,
                                                widget: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Flexible(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              displayFormat(
                                                                  title: AppLocalizations.of(
                                                                          context)!
                                                                      .bornOn,
                                                                  subtitle: _viewProfileController
                                                                              .userdetail[
                                                                          "profile"]
                                                                      [
                                                                      "date_of_birth"]),
                                                              displayFormat(
                                                                  title: AppLocalizations.of(
                                                                          context)!
                                                                      .timeofBirth,
                                                                  subtitle: _viewProfileController
                                                                              .userdetail[
                                                                          "profile"]
                                                                      [
                                                                      "time_of_birth"]),
                                                              displayFormat(
                                                                  title: AppLocalizations.of(
                                                                          context)!
                                                                      .placeofBirth,
                                                                  subtitle: _viewProfileController
                                                                              .userdetail[
                                                                          "profile"]
                                                                      [
                                                                      "birth_place"]),
                                                              displayFormat(
                                                                  title: AppLocalizations.of(
                                                                          context)!
                                                                      .gotra,
                                                                  subtitle: _viewProfileController
                                                                              .userdetail[
                                                                          "profile"]
                                                                      [
                                                                      "gotra"]),
                                                              displayFormat(
                                                                  title: AppLocalizations.of(
                                                                          context)!
                                                                      .nakshatra,
                                                                  subtitle: _viewProfileController
                                                                              .userdetail[
                                                                          "profile"]
                                                                      [
                                                                      "nakshtra"]),
                                                            ],
                                                          ),
                                                        ),
                                                        Flexible(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              displayFormat(
                                                                  title: AppLocalizations.of(
                                                                          context)!
                                                                      .manglik,
                                                                  subtitle: _viewProfileController
                                                                              .userdetail[
                                                                          "profile"]
                                                                      [
                                                                      "manglik"]),
                                                              displayFormat(
                                                                  title: AppLocalizations.of(
                                                                          context)!
                                                                      .gan,
                                                                  subtitle: _viewProfileController
                                                                              .userdetail[
                                                                          "profile"]
                                                                      ["gan"]),
                                                              displayFormat(
                                                                  title: AppLocalizations.of(
                                                                          context)!
                                                                      .ras,
                                                                  subtitle: _viewProfileController
                                                                              .userdetail[
                                                                          "profile"]
                                                                      ["ras"]),
                                                              displayFormat(
                                                                  title: AppLocalizations.of(
                                                                          context)!
                                                                      .nadi,
                                                                  subtitle: _viewProfileController
                                                                              .userdetail[
                                                                          "profile"]
                                                                      ["nadi"]),
                                                              displayFormat(
                                                                  title: AppLocalizations.of(
                                                                          context)!
                                                                      .charan,
                                                                  subtitle: _viewProfileController
                                                                              .userdetail[
                                                                          "profile"]
                                                                      [
                                                                      "charan"]),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      DisplayUserDetail(
                                        assetImage:
                                            "assets/icons/General_info.png",
                                        title: AppLocalizations.of(context)!
                                            .generalInfo,
                                        widget: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                displayFormat(
                                                    title: AppLocalizations.of(
                                                            context)!
                                                        .languagesKnown,
                                                    subtitle:
                                                        "${_viewProfileController.userdetail["profile"]["languages_known"]}"),
                                                displayFormat(
                                                    title: AppLocalizations.of(
                                                            context)!
                                                        .motherTongue,
                                                    subtitle:
                                                        "${_viewProfileController.userdetail["profile"]["mother_tongue"]}"),
                                              ],
                                            ),

                                            /*                                                                  
   /*                                                                         Obx(() {
               if(_viewProfileController.dressStyle.isEmpty){
                return const SizedBox();
               }else{
                return   
                Padding(
                  padding: const EdgeInsets.only( top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      SizedBox(height: 10,), 
                          Row(
                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                                                   children: [
                                                  Row(
                                                   mainAxisAlignment: MainAxisAlignment.start, 
                                                   children: [
                      Text("Dress Style" , style: CustomTextStyle.bodytextbold.copyWith(fontSize: 14 , fontWeight: FontWeight.w700),)
                                                   ],), 
                                          
                                                   ],), 
                                
                                                   const SizedBox(height: 10,) , 
                                
                                                   Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _viewProfileController.dressStyle.map((detail) {
                    return detailContainer(
                                assetimg: detail["icon_url"],
                                title: detail["name"],
                    );
                  }).toList(), // Convert the iterable to a list
                                )
                                         
                    ],),
                );
               }
             },),                           
                                              
            */
                                                                 Obx(() {
               if(_viewProfileController.favouriteMusic.isEmpty){
                return const SizedBox();
               }else{
                return   
                Padding(
                  padding: const EdgeInsets.only( top: 8.0 ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      SizedBox(height: 10,),
                          Row(
                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                                                   children: [
                                                  Row(
                                                   mainAxisAlignment: MainAxisAlignment.start, 
                                                   children: [
                      Text("Favourite Music" , style: CustomTextStyle.bodytextbold.copyWith(fontSize: 14 , fontWeight: FontWeight.w700),)
                                                   ],), 
                                          
                                                   ],), 
                
                                                   const SizedBox(height: 10,) , 
                
                                                   Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _viewProfileController.favouriteMusic.map((detail) {
                    return detailContainer(
                assetimg: detail["icon_url"],
                title: detail["name"],
                    );
                  }).toList(), // Convert the iterable to a list
                )
                                         
                    ],),
                );
               }
             },),
                                     Obx(() {
               if(_viewProfileController.foodDetails.isEmpty){
                return const SizedBox();
               }else{
                return   
                Padding(
                  padding: const EdgeInsets.only( top:  8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      SizedBox(height: 10,),
                          Row(
                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                                                   children: [
                                                  Row(
                                                   mainAxisAlignment: MainAxisAlignment.start, 
                                                   children: [
                      Text("Favourite Food" , style: CustomTextStyle.bodytextbold.copyWith(fontSize: 14 , fontWeight: FontWeight.w700),)
                                                   ],), 
                                          
                                                   ],), 
                
                                                   const SizedBox(height: 10,) , 
                
                                                   Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _viewProfileController.foodDetails.map((detail) {
                    return detailContainer(
                assetimg: detail["icon_url"],
                title: detail["name"],
                    );
                  }).toList(), // Convert the iterable to a list
                )
                                         
                    ],),
                );
               }
             },),
         */

                                            // SizedBox(
                                            //   height: 20,
                                            // )
                                          ],
                                        ),
                                      ),
                                      DisplayUserDetail(
                                        assetImage:
                                            "assets/icons/Lifestyle.png",
                                        title: AppLocalizations.of(context)!
                                            .lifestyleDetails,
                                        widget: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          language == "en"
                                                              ? "Dietry habits"
                                                              : "आहारविषयक माहिती",
                                                          style: CustomTextStyle
                                                              .bodytextbold
                                                              .copyWith(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Wrap(
                                                  spacing: 10,
                                                  runSpacing: 10,
                                                  children: [
                                                    Container(
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  230,
                                                                  232,
                                                                  235)),
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5))),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 8.0,
                                                                top: 8.0,
                                                                left: 12,
                                                                right: 12),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            SizedBox(
                                                              child: Image.asset(
                                                                  "assets/salad.png"),
                                                            )
                                                            //  networkImageWithFallback(assetimg , "assets/drink.png" ),
                                                            ,
                                                            const SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              "${_viewProfileController.userdetail["profile"]["diet_habit"]}",
                                                              style:
                                                                  CustomTextStyle
                                                                      .bodytext,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  230,
                                                                  232,
                                                                  235)),
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5))),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 8.0,
                                                                top: 8.0,
                                                                left: 12,
                                                                right: 12),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            SizedBox(
                                                              child: Image.asset(
                                                                  "assets/cheers.png"),
                                                            )
                                                            //  networkImageWithFallback(assetimg , "assets/drink.png" ),
                                                            ,
                                                            const SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              "${language == "en" ? "Drink" : "मद्यपान"} - ${_viewProfileController.userdetail["profile"]["drinking_habit"]}",
                                                              style:
                                                                  CustomTextStyle
                                                                      .bodytext,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  230,
                                                                  232,
                                                                  235)),
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5))),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 8.0,
                                                                top: 8.0,
                                                                left: 12,
                                                                right: 12),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            SizedBox(
                                                              child: Image.asset(
                                                                  "assets/no-smoking.png"),
                                                            )
                                                            //  networkImageWithFallback(assetimg , "assets/drink.png" ),
                                                            ,
                                                            const SizedBox(
                                                              width: 4,
                                                            ),
                                                            Text(
                                                              "${language == "en" ? "Smoking" : "धूम्रपान"} -${_viewProfileController.userdetail["profile"]["smoking_habit"]}",
                                                              style:
                                                                  CustomTextStyle
                                                                      .bodytext,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                            Obx(
                                              () {
                                                if (_viewProfileController
                                                    .interestDetails.isEmpty) {
                                                  return const SizedBox();
                                                } else {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Divider(),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Interest",
                                                                  style: CustomTextStyle
                                                                      .bodytextbold
                                                                      .copyWith(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Wrap(
                                                          spacing: 10,
                                                          runSpacing: 10,
                                                          children:
                                                              _viewProfileController
                                                                  .interestDetails
                                                                  .map(
                                                                      (detail) {
                                                            return detailContainer(
                                                              assetimg: detail[
                                                                  "icon_url"],
                                                              title: detail[
                                                                  "name"],
                                                            );
                                                          }).toList(), // Convert the iterable to a list
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                            Obx(
                                              () {
                                                if (_viewProfileController
                                                    .hobbiesDetails.isEmpty) {
                                                  return const SizedBox();
                                                } else {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Divider(),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Hobbies",
                                                                  style: CustomTextStyle
                                                                      .bodytextbold
                                                                      .copyWith(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Wrap(
                                                          spacing: 10,
                                                          runSpacing: 10,
                                                          children:
                                                              _viewProfileController
                                                                  .hobbiesDetails
                                                                  .map(
                                                                      (detail) {
                                                            return detailContainer(
                                                              assetimg: detail[
                                                                  "icon_url"],
                                                              title: detail[
                                                                  "name"],
                                                            );
                                                          }).toList(), // Convert the iterable to a list
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                            border: Border.all(
                                                color: const Color.fromARGB(
                                                    255, 230, 232, 235),
                                                width: 1)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 15,
                                                    width: 15,
                                                    child: Image.asset(
                                                        "assets/icons/MatchesByPartnerPreference.png"),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    language == "en"
                                                        ? "Who $gender is Looking For..."
                                                        : "तिच्या आवडीनिवडी जाणून घ्या",
                                                    style: CustomTextStyle
                                                        .bodytextbold
                                                        .copyWith(fontSize: 14),
                                                  )
                                                ],
                                              ),
                                              Divider(
                                                color: const Color.fromARGB(
                                                        255, 80, 93, 128)
                                                    .withOpacity(0.5),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Center(
                                                  child: Text(
                                                language == "en"
                                                    ? "These are ${mybox.get("gender") == 2 ? "Her" : "His"} desired partner qualities!"
                                                    : "तिच्या जोडीदाराबाबतच्या अपेक्षा खालीलप्रमाणे आहेत!",
                                                style: CustomTextStyle.bodytext
                                                    .copyWith(fontSize: 12),
                                                textAlign: TextAlign.center,
                                              )),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Center(
                                                child: Text(
                                                  language == "en"
                                                      ? "You match ${_viewProfileController.matches.value}/12 of ${mybox.get("gender") == 2 ? "Her" : "His"} Preferences"
                                                      : "तुम्ही 12 पैकी ${_viewProfileController.matches.value} अपेक्षांची पूर्तता करता. ",
                                                  style: CustomTextStyle
                                                      .fieldName
                                                      .copyWith(fontSize: 11),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    radius:
                                                        50, // Outer radius for the border effect
                                                    backgroundColor:
                                                        AppTheme.secondryColor,
                                                    child: CircleAvatar(
                                                      radius:
                                                          45, // Inner radius for the actual image
                                                      backgroundImage: NetworkImage(
                                                          _viewProfileController
                                                                      .userdetail[
                                                                  "memberData"][
                                                              "photoUrl"]), // The image
                                                      backgroundColor: Colors
                                                          .transparent, // Optional: Set to transparent
                                                    ),
                                                  ),
                                                  Expanded(
                                                    // Use Expanded to fill the remaining space
                                                    child: DottedLine(
                                                      direction:
                                                          Axis.horizontal,
                                                      lineThickness: 1.0,
                                                      dashLength: 4.0,
                                                      dashColor: const Color
                                                              .fromARGB(
                                                              255, 234, 52, 74)
                                                          .withOpacity(0.34),
                                                      dashGapLength: 4.0,
                                                      dashGapColor:
                                                          Colors.transparent,
                                                    ),
                                                  ),
                                                  Center(
                                                      child: SizedBox(
                                                    height: 18,
                                                    width: 18,
                                                    child: Image.asset(
                                                      "assets/smileee.png",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )),
                                                  Expanded(
                                                    // Use Expanded to fill the remaining space
                                                    child: DottedLine(
                                                      direction:
                                                          Axis.horizontal,
                                                      lineThickness: 1.0,
                                                      dashLength: 4.0,
                                                      dashColor: const Color
                                                              .fromARGB(
                                                              255, 234, 52, 74)
                                                          .withOpacity(0.34),
                                                      dashGapLength: 4.0,
                                                      dashGapColor:
                                                          Colors.transparent,
                                                    ),
                                                  ),
                                                  CircleAvatar(
                                                    radius:
                                                        50, // Outer radius for the border effect
                                                    backgroundColor:
                                                        AppTheme.secondryColor,
                                                    child: CircleAvatar(
                                                      radius:
                                                          45, // Inner radius for the actual image
                                                      backgroundImage: NetworkImage(
                                                          _viewProfileController
                                                                      .userdetail[
                                                                  "MyData"][
                                                              "photoUrl"]), // The image
                                                      backgroundColor: Colors
                                                          .transparent, // Optional: Set to transparent
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "${mybox.get("gender") == 2 ? language == "en" ? "Her" : "तिच्या" : language == "en" ? "His" : "त्याच्या"} ${language == "en" ? "Preference" : "अपेक्षा "}",
                                                    style: CustomTextStyle
                                                        .fieldName,
                                                  ),
                                                  Text(
                                                    "${mybox.get("gender") == 2 ? language == "en" ? "Your" : "तुमच्या" : language == "en" ? "Your" : "तुमच्या"} ${language == "en" ? "Preference" : "अपेक्षा "}",
                                                    style: CustomTextStyle
                                                        .fieldName,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    prefranceUserDetails(
                                                      Subtitle:
                                                          "${_viewProfileController.userdetail["profile"]["partner_min_age"]} to ${_viewProfileController.userdetail["profile"]["partner_max_age"]}",
                                                      title:
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .age,
                                                      assetimg:
                                                          "assets/icons/Age.png",
                                                      assetimgtrailing:
                                                          _viewProfileController
                                                                              .userdetail[
                                                                          "PartnerPreferenceMatch"]
                                                                      ["age"] ==
                                                                  "1"
                                                              ? "assets/tick.png"
                                                              : "assets/cross.png",
                                                    ),
                                                    prefranceUserDetails(
                                                      Subtitle:
                                                          "${_viewProfileController.userdetail["profile"]["partner_min_height"]} to ${_viewProfileController.userdetail["profile"]["partner_max_height"]}",
                                                      title:
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .height,
                                                      assetimg:
                                                          "assets/icons/Height.png",
                                                      assetimgtrailing: _viewProfileController
                                                                          .userdetail[
                                                                      "PartnerPreferenceMatch"]
                                                                  ["height"] ==
                                                              "1"
                                                          ? "assets/tick.png"
                                                          : "assets/cross.png",
                                                    ),
                                                    prefranceUserDetails(
                                                      Subtitle:
                                                          "${_viewProfileController.userdetail["profile"]["partner_marital_status"]} ",
                                                      title:
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .maritalstatus,
                                                      assetimg:
                                                          "assets/icons/Marital_status.png",
                                                      assetimgtrailing: _viewProfileController
                                                                          .userdetail[
                                                                      "PartnerPreferenceMatch"]
                                                                  [
                                                                  "marital_status"] ==
                                                              "1"
                                                          ? "assets/tick.png"
                                                          : "assets/cross.png",
                                                    ),
                                                    prefranceUserDetails(
                                                        Subtitle:
                                                            "${_viewProfileController.userdetail["profile"]["partner_subcaste"]} ",
                                                        /*   | ${_viewProfileController.userdetail["profile"]["partner_section"]} | ${{
                                                          _viewProfileController
                                                                      .userdetail[
                                                                  "profile"][
                                                              "partner_subsection"]
                                                        }} */
                                                        title:
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .subcaste,
                                                        assetimg:
                                                            "assets/icons/Religion.png",
                                                        assetimgtrailing: _viewProfileController
                                                                            .userdetail[
                                                                        "PartnerPreferenceMatch"]
                                                                    [
                                                                    "subcaste"] ==
                                                                "1" /* &&
                                                                _viewProfileController
                                                                            .userdetail["PartnerPreferenceMatch"]
                                                                        [
                                                                        "section"] ==
                                                                    "1" &&
                                                                _viewProfileController
                                                                            .userdetail["PartnerPreferenceMatch"]
                                                                        [
                                                                        "section"] ==
                                                                    "1" */
                                                            ? "assets/tick.png"
                                                            : "assets/cross.png"),
                                                    prefranceUserDetails(
                                                      Subtitle:
                                                          "${_viewProfileController.userdetail["profile"]["partner_manglik"]}",
                                                      title:
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .manglik,
                                                      assetimg:
                                                          "assets/icons/Manglik.png",
                                                      assetimgtrailing: _viewProfileController
                                                                          .userdetail[
                                                                      "PartnerPreferenceMatch"]
                                                                  ["manglik"] ==
                                                              "1"
                                                          ? "assets/tick.png"
                                                          : "assets/cross.png",
                                                    ),
                                                    prefranceUserDetails(
                                                      Subtitle:
                                                          "${_viewProfileController.userdetail["profile"]["partner_city"]} ",
                                                      title:
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .livingIn,
                                                      assetimg:
                                                          "assets/icons/Location.png",
                                                      assetimgtrailing: _viewProfileController
                                                                          .userdetail[
                                                                      "PartnerPreferenceMatch"]
                                                                  [
                                                                  "permanent_city"] ==
                                                              "1"
                                                          ? "assets/tick.png"
                                                          : "assets/cross.png",
                                                    ),
                                                    prefranceUserDetails(
                                                      Subtitle:
                                                          "${_viewProfileController.userdetail["profile"]["partner_education"]}",
                                                      title:
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .education,
                                                      assetimg:
                                                          "assets/icons/Education.png",
                                                      assetimgtrailing: _viewProfileController
                                                                          .userdetail[
                                                                      "PartnerPreferenceMatch"]
                                                                  [
                                                                  "education"] ==
                                                              "1"
                                                          ? "assets/tick.png"
                                                          : "assets/cross.png",
                                                    ),
                                                    prefranceUserDetails(
                                                      Subtitle:
                                                          "${_viewProfileController.userdetail["profile"]["partner_occupation"]}",
                                                      title:
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .occupation,
                                                      assetimg:
                                                          "assets/icons/Occupation.png",
                                                      assetimgtrailing: _viewProfileController
                                                                          .userdetail[
                                                                      "PartnerPreferenceMatch"]
                                                                  [
                                                                  "occupation"] ==
                                                              "1"
                                                          ? "assets/tick.png"
                                                          : "assets/cross.png",
                                                    ),
                                                    prefranceUserDetails(
                                                        Subtitle:
                                                            "INR ${_viewProfileController.userdetail["profile"]["partner_min_annual_income"]} - ${_viewProfileController.userdetail["profile"]["partner_max_annual_income"]} ${language == "en" ? "Per Annum" : "वार्षिक उत्पन्न"}",

                                                        // "INR ${_viewProfileController.userdetail["profile"]["partner_min_annual_income"]}- ${_viewProfileController.userdetail["profile"]["partner_max_annual_income"]} Per Annum",
                                                        title: AppLocalizations
                                                                .of(context)!
                                                            .annualIncome,
                                                        assetimg:
                                                            "assets/icons/Annual_income.png",
                                                        assetimgtrailing: _viewProfileController
                                                                            .userdetail[
                                                                        "PartnerPreferenceMatch"]
                                                                    [
                                                                    "annual_income"] ==
                                                                "1"
                                                            ? "assets/tick.png"
                                                            : "assets/cross.png"),

                                                    /*        prefranceUserDetails(
            Subtitle: "${_viewProfileController.userdetail["profile"]["partner_dietary_habits"]}",
            title: "Diet",
            assetimg: "assets/icons/Diet.png",
            assetimgtrailing: _viewProfileController.userdetail["PartnerPreferenceMatch"]["dietary_habits"] == "1"? "assets/tick.png" : "assets/cross.png"
                    ),
                    prefranceUserDetails(
            Subtitle: "${_viewProfileController.userdetail["profile"]["partner_smoking_habits"]}",
            title: "Smoke",
            assetimg: "assets/icons/Smoking_habit.png",
            assetimgtrailing:_viewProfileController.userdetail["PartnerPreferenceMatch"]["smoking_habits"] == "1"? "assets/tick.png" : "assets/cross.png"
                    ),
                    prefranceUserDetails(
            Subtitle: "${_viewProfileController.userdetail["profile"]["partner_drinking_habits"]}",
            title: "Drink",
            assetimg: "assets/icons/Drinking_habit.png",
            assetimgtrailing: _viewProfileController.userdetail["PartnerPreferenceMatch"]["drinking_habits"] == "1"? "assets/tick.png" : "assets/cross.png"
                    ),
                    */
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 80,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          )
                        ],
                      )),
                    ),
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerFloat,
                  floatingActionButton: Obx(() {
                    if (_viewProfileController.userdetail["memberData"]
                            ["interest_sent_status"] ==
                        "2") {
                      return Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: const BoxDecoration(),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 234, 52, 74)
                                    .withOpacity(0.8),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
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
                                        child: Image.asset(
                                            "assets/heartbreak.png"),
                                      ),
                                    ),
                                    Text(
                                      textAlign: TextAlign.center,
                                      "They Declined Your Invitation. !",
                                      style: CustomTextStyle.imageText.copyWith(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14),
                                    )
                                  ],
                                )),
                          ),
                        ),
                      );
                    } else if (_viewProfileController.userdetail["memberData"]
                            ["interest_sent_status"] ==
                        "3") {
                      return Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // First Button: Interest

                            // Divider

                            // Third Button: Contacts
                            Flexible(
                              flex: 4,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 1.0),
                                child: TextButton.icon(
                                  onPressed: () {
                                    // Handle Contacts action
                                    if (_viewProfileController
                                                .userdetail["memberData"]
                                            ["ContactView"] ==
                                        true) {
                                      _viewProfileController
                                          .fetchContactDetails(
                                              memberid: widget.memberid)
                                          .then(
                                        (value) {
                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return ContactViewDetailsPopup(
                                                  contactViewed:
                                                      _viewProfileController
                                                                  .userdetail[
                                                              "memberData"]
                                                          ["ContactView"],
                                                  memberID: widget.memberid);
                                            },
                                          );
                                        },
                                      );
                                    } else {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return ContactViewPopup(
                                            contactViewed:
                                                _viewProfileController
                                                            .userdetail[
                                                        "memberData"]
                                                    ["ContactView"],
                                            memberid: _viewProfileController
                                                    .userdetail["profile"]
                                                ["member_id"],
                                          );
                                        },
                                      );
                                    }
                                  },
                                  icon: SizedBox(
                                    height: 28,
                                    width: 28,
                                    child: Image.asset(
                                        "assets/contactinitcirclefilled.png"),
                                  ),
                                  label: const Text("Contacts",
                                      style: CustomTextStyle
                                          .elevatedButtonFABLarge),
                                ),
                              ),
                            ),
                            // Second Button: Shortlist
                            Container(
                                color: Colors.white, width: 1, height: 19),

                            Flexible(
                              flex: 4,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 1.0),
                                child: _viewProfileController
                                                .userdetail["memberData"]
                                            ["Shortlisted"] ==
                                        true
                                    ? TextButton.icon(
                                        onPressed: () {
                                          // Handle Shortlisted action

                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return ShortListedDialogue(
                                                memberid: _viewProfileController
                                                        .userdetail[
                                                    "memberData"]["member_id"],
                                              );
                                            },
                                          );
                                        },
                                        icon: SizedBox(
                                          height: 28,
                                          width: 28,
                                          child: Image.asset(
                                              "assets/shortlistcirclefilled.png"),
                                        ),
                                        label: const Text("Shortlisted",
                                            style: CustomTextStyle
                                                .elevatedButtonFABLarge),
                                      )
                                    : Obx(() {
                                        print(
                                            "THis is shortlisted bool ${_dashboardController.hasShortlisted(_viewProfileController.userdetail["memberData"]["member_id"])}");
                                        return _dashboardController
                                                .hasShortlisted(
                                                    _viewProfileController
                                                                .userdetail[
                                                            "memberData"]
                                                        ["member_id"])
                                            ? TextButton.icon(
                                                onPressed: () {
                                                  /*       _dashboardController.removeFromShortlistOnDetails(
                memberid: _viewProfileController.userdetail["memberData"]["member_id"],
              );*/
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return ShortListedDialogue(
                                                        memberid:
                                                            _viewProfileController
                                                                        .userdetail[
                                                                    "memberData"]
                                                                ["member_id"],
                                                      );
                                                    },
                                                  );
                                                },
                                                icon: SizedBox(
                                                  height: 28,
                                                  width: 28,
                                                  child: Image.asset(
                                                      "assets/shortlistcirclefilled.png"),
                                                ),
                                                label: const Text("Shortlisted",
                                                    style: CustomTextStyle
                                                        .elevatedButtonFABLarge),
                                              )
                                            : TextButton.icon(
                                                onPressed: () {
                                                  _dashboardController
                                                      .shortlistMember(
                                                    memberid:
                                                        _viewProfileController
                                                                    .userdetail[
                                                                "memberData"]
                                                            ["member_id"],
                                                  );
                                                  // Handle Shortlisted action
                                                },
                                                icon: SizedBox(
                                                  height: 28,
                                                  width: 28,
                                                  child: Image.asset(
                                                      "assets/shortlistcircle.png"),
                                                ),
                                                label: const Text("Shortlist",
                                                    style: CustomTextStyle
                                                        .elevatedButtonFABLarge),
                                              );
                                      }),
                              ),
                            ),

                            // Divider
                          ],
                        ),
                      );
                    } else {
                      if (_viewProfileController.userdetail["memberData"]
                              ["interest_received_status"] ==
                          "1") {
                        if (_dashboardController.hasaccepted(
                          _viewProfileController.userdetail["profile"]
                              ["member_id"],
                        )) {
                          return Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // First Button: Interest

                                // Divider

                                // Third Button: Contacts
                                Flexible(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 1.0),
                                    child: TextButton.icon(
                                      onPressed: () {
                                        // Handle Contacts action
                                        if (_viewProfileController
                                                    .userdetail["memberData"]
                                                ["ContactView"] ==
                                            true) {
                                          _viewProfileController
                                              .fetchContactDetails(
                                                  memberid: widget.memberid)
                                              .then(
                                            (value) {
                                              showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) {
                                                  return ContactViewDetailsPopup(
                                                      contactViewed:
                                                          _viewProfileController
                                                                      .userdetail[
                                                                  "memberData"]
                                                              ["ContactView"],
                                                      memberID:
                                                          widget.memberid);
                                                },
                                              );
                                            },
                                          );
                                        } else {
                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return ContactViewPopup(
                                                contactViewed:
                                                    _viewProfileController
                                                                .userdetail[
                                                            "memberData"]
                                                        ["ContactView"],
                                                memberid: _viewProfileController
                                                        .userdetail["profile"]
                                                    ["member_id"],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      icon: SizedBox(
                                        height: 28,
                                        width: 28,
                                        child: Image.asset(
                                            "assets/contactinitcirclefilled.png"),
                                      ),
                                      label: const Text("Contacts",
                                          style: CustomTextStyle
                                              .elevatedButtonFABLarge),
                                    ),
                                  ),
                                ),
                                // Second Button: Shortlist
                                Container(
                                    color: Colors.white, width: 1, height: 19),

                                Flexible(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 1.0),
                                    child: _viewProfileController
                                                    .userdetail["memberData"]
                                                ["Shortlisted"] ==
                                            true
                                        ? TextButton.icon(
                                            onPressed: () {
                                              // Handle Shortlisted action

                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return ShortListedDialogue(
                                                    memberid:
                                                        _viewProfileController
                                                                    .userdetail[
                                                                "memberData"]
                                                            ["member_id"],
                                                  );
                                                },
                                              );
                                            },
                                            icon: SizedBox(
                                              height: 28,
                                              width: 28,
                                              child: Image.asset(
                                                  "assets/shortlistcirclefilled.png"),
                                            ),
                                            label: const Text("Shortlisted",
                                                style: CustomTextStyle
                                                    .elevatedButtonFABLarge),
                                          )
                                        : Obx(() {
                                            print(
                                                "THis is shortlisted bool ${_dashboardController.hasShortlisted(_viewProfileController.userdetail["memberData"]["member_id"])}");
                                            return _dashboardController
                                                    .hasShortlisted(
                                                        _viewProfileController
                                                                    .userdetail[
                                                                "memberData"]
                                                            ["member_id"])
                                                ? TextButton.icon(
                                                    onPressed: () {
                                                      /*       _dashboardController.removeFromShortlistOnDetails(
                memberid: _viewProfileController.userdetail["memberData"]["member_id"],
              );*/
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return ShortListedDialogue(
                                                            memberid: _viewProfileController
                                                                        .userdetail[
                                                                    "memberData"]
                                                                ["member_id"],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    icon: SizedBox(
                                                      height: 28,
                                                      width: 28,
                                                      child: Image.asset(
                                                          "assets/shortlistcirclefilled.png"),
                                                    ),
                                                    label: const Text(
                                                        "Shortlisted",
                                                        style: CustomTextStyle
                                                            .elevatedButtonFABLarge),
                                                  )
                                                : TextButton.icon(
                                                    onPressed: () {
                                                      _dashboardController
                                                          .shortlistMember(
                                                        memberid:
                                                            _viewProfileController
                                                                        .userdetail[
                                                                    "memberData"]
                                                                ["member_id"],
                                                      );
                                                      // Handle Shortlisted action
                                                    },
                                                    icon: SizedBox(
                                                      height: 28,
                                                      width: 28,
                                                      child: Image.asset(
                                                          "assets/shortlistcircle.png"),
                                                    ),
                                                    label: const Text(
                                                        "Shortlist",
                                                        style: CustomTextStyle
                                                            .elevatedButtonFABLarge),
                                                  );
                                          }),
                                  ),
                                ),

                                // Divider
                              ],
                            ),
                          );
                        } else if (_dashboardController.hasdeclined(
                          _viewProfileController.userdetail["profile"]
                              ["member_id"],
                        )) {
                          return Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: const BoxDecoration(),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 234, 52, 74)
                                            .withOpacity(0.8),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: SizedBox(
                                            height: 22,
                                            width: 22,
                                            child: Image.asset(
                                                "assets/heartbreak.png"),
                                          ),
                                        ),
                                        Text(
                                          textAlign: TextAlign.center,
                                          language == "en"
                                              ? "You Declined ${mybox.get("gender") == 2 ? "Her" : "His"} Invitation. !"
                                              : "तुम्ही त्यांचा इंटरेस्ट नाकारला.",
                                          style: CustomTextStyle.imageText
                                              .copyWith(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 14),
                                        )
                                      ],
                                    )),
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              color: AppTheme.floatingActionBG,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 10.0),
                              child: Column(
                                mainAxisSize: MainAxisSize
                                    .min, // Adjust to content height
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    language == "en"
                                        ? "Hello, I like your Profile. Accept my request if my profile interests you too."
                                        : "मला तुमची प्रोफाईल आवडली. तुम्हालाही माझ्या प्रोफाईल मध्ये इंटरेस्ट असल्यास माझा इंटरेस्ट स्वीकारा.",
                                    textAlign: TextAlign.center,
                                    style: CustomTextStyle.bodytextSmall,
                                  ),
                                  const SizedBox(height: 5), // Reduced spacing
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Divider(
                                      height: 1,
                                      color: AppTheme.selectedOptionColor,
                                      thickness: 1, // Keep a visible divider
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Flexible(
                                        child: TextButton.icon(
                                          onPressed: () {
                                            showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) {
                                                return DeclineInterestDialogue(
                                                  matchid:
                                                      _viewProfileController
                                                                  .userdetail[
                                                              "profile"]
                                                          ["member_id"],
                                                );
                                              },
                                            );
                                          },
                                          label: Text(
                                            // "Decline",
                                            AppLocalizations.of(context)!
                                                .decline,
                                            style: CustomTextStyle
                                                .elevatedButtonFABDecline,
                                          ),
                                          icon: SizedBox(
                                            height: 15,
                                            width: 15,
                                            child: Image.asset(
                                                "assets/decline.png"),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        color: AppTheme.selectedOptionColor,
                                        height:
                                            16, // Slightly reduced separator height
                                        width: 1,
                                      ),
                                      Flexible(
                                        child: TextButton.icon(
                                          onPressed: () {
                                            showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) {
                                                return AcceptInterestDialogue(
                                                  matchid:
                                                      _viewProfileController
                                                                  .userdetail[
                                                              "profile"]
                                                          ["member_id"],
                                                );
                                              },
                                            );
                                          },
                                          label: Text(
                                            AppLocalizations.of(context)!
                                                .accept,
                                            style: CustomTextStyle
                                                .elevatedButtonFABAccept,
                                          ),
                                          icon: SizedBox(
                                            height: 15,
                                            width: 15,
                                            child: Image.asset(
                                                "assets/acceptDark.png"),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      } else if (_viewProfileController.userdetail["memberData"]
                              ["interest_received_status"] ==
                          "2") {
                        return Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: const BoxDecoration(),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 234, 52, 74)
                                      .withOpacity(0.8),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: SizedBox(
                                          height: 22,
                                          width: 22,
                                          child: Image.asset(
                                              "assets/heartbreak.png"),
                                        ),
                                      ),
                                      Text(
                                        textAlign: TextAlign.center,
                                        language == "en"
                                            ? "You Declined ${mybox.get("gender") == 2 ? "Her" : "His"} Invitation. !"
                                            : "तुम्ही त्यांचा इंटरेस्ट नाकारला.",
                                        style: CustomTextStyle.imageText
                                            .copyWith(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 14),
                                      )
                                    ],
                                  )),
                            ),
                          ),
                        );
                      } else if (_viewProfileController.userdetail["memberData"]
                              ["interest_received_status"] ==
                          "3") {
                        return Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30)),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // First Button: Interest

                                // Third Button: Contacts
                                Flexible(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 1.0),
                                    child: TextButton.icon(
                                      onPressed: () {
                                        // Handle Contacts action
                                        if (_viewProfileController
                                                    .userdetail["memberData"]
                                                ["ContactView"] ==
                                            true) {
                                          _viewProfileController
                                              .fetchContactDetails(
                                                  memberid: widget.memberid)
                                              .then(
                                            (value) {
                                              showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) {
                                                  return ContactViewDetailsPopup(
                                                      contactViewed:
                                                          _viewProfileController
                                                                      .userdetail[
                                                                  "memberData"]
                                                              ["ContactView"],
                                                      memberID:
                                                          widget.memberid);
                                                },
                                              );
                                            },
                                          );
                                        } else {
                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return ContactViewPopup(
                                                contactViewed:
                                                    _viewProfileController
                                                                .userdetail[
                                                            "memberData"]
                                                        ["ContactView"],
                                                memberid: _viewProfileController
                                                        .userdetail["profile"]
                                                    ["member_id"],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      icon: SizedBox(
                                        height: 32,
                                        width: 32,
                                        child: Image.asset(
                                            "assets/contactinitcirclefilled.png"),
                                      ),
                                      label: const Text("Contacts",
                                          style: CustomTextStyle
                                              .elevatedButtonFABLarge),
                                    ),
                                  ),
                                ),

                                Container(
                                    color: Colors.white, width: 1, height: 19),

                                // Second Button: Shortlist
                                Flexible(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 1.0),
                                    child: _viewProfileController
                                                    .userdetail["memberData"]
                                                ["Shortlisted"] ==
                                            true
                                        ? TextButton.icon(
                                            onPressed: () {
                                              /*             _dashboardController.removeFromShortlistOnDetails(          
                memberid: _viewProfileController.userdetail["memberData"]["member_id"],
              );*/
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return ShortListedDialogue(
                                                    memberid:
                                                        _viewProfileController
                                                                    .userdetail[
                                                                "memberData"]
                                                            ["member_id"],
                                                  );
                                                },
                                              );
                                              // Handle Shortlisted action
                                            },
                                            icon: SizedBox(
                                              height: 32,
                                              width: 32,
                                              child: Image.asset(
                                                  "assets/shortlistcirclefilled.png"),
                                            ),
                                            label: const Text("Shortlisted",
                                                style: CustomTextStyle
                                                    .elevatedButtonFABLarge),
                                          )
                                        : Obx(() {
                                            print(
                                                "THis is shortlisted bool ${_dashboardController.hasShortlisted(_viewProfileController.userdetail["memberData"]["member_id"])}");
                                            return _dashboardController
                                                    .hasShortlisted(
                                                        _viewProfileController
                                                                    .userdetail[
                                                                "memberData"]
                                                            ["member_id"])
                                                ? TextButton.icon(
                                                    onPressed: () {
                                                      /*  _dashboardController.removeFromShortlistOnDetails(
                memberid: _viewProfileController.userdetail["memberData"]["member_id"],
              );*/
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return ShortListedDialogue(
                                                            memberid: _viewProfileController
                                                                        .userdetail[
                                                                    "memberData"]
                                                                ["member_id"],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    icon: SizedBox(
                                                      height: 32,
                                                      width: 32,
                                                      child: Image.asset(
                                                          "assets/shortlistcirclefilled.png"),
                                                    ),
                                                    label: const Text(
                                                        "Shortlisted",
                                                        style: CustomTextStyle
                                                            .elevatedButtonFABLarge),
                                                  )
                                                : TextButton.icon(
                                                    onPressed: () {
                                                      // Handle Shortlisted action
                                                      _dashboardController
                                                          .shortlistMember(
                                                        memberid:
                                                            _viewProfileController
                                                                        .userdetail[
                                                                    "memberData"]
                                                                ["member_id"],
                                                      );
                                                    },
                                                    icon: SizedBox(
                                                      height: 32,
                                                      width: 32,
                                                      child: Image.asset(
                                                          "assets/shortlistcircle.png"),
                                                    ),
                                                    label: const Text(
                                                        "Shortlist",
                                                        style: CustomTextStyle
                                                            .elevatedButtonFABLarge),
                                                  );
                                          }),
                                  ),
                                ),

                                // Divider
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          //width: MediaQuery.of(context).size.width * 0.6,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 1.0),
                                    child: IconButton(
                                      onPressed: () {
                                        // Handle Contacts action
                                        if (_viewProfileController
                                                    .userdetail["memberData"]
                                                ["ContactView"] ==
                                            true) {
                                          _viewProfileController
                                              .fetchContactDetails(
                                                  memberid: widget.memberid)
                                              .then(
                                            (value) {
                                              showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) {
                                                  return ContactViewDetailsPopup(
                                                      contactViewed:
                                                          _viewProfileController
                                                                      .userdetail[
                                                                  "memberData"]
                                                              ["ContactView"],
                                                      memberID:
                                                          widget.memberid);
                                                },
                                              );
                                            },
                                          );
                                        } else {
                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return ContactViewPopup(
                                                contactViewed:
                                                    _viewProfileController
                                                                .userdetail[
                                                            "memberData"]
                                                        ["ContactView"],
                                                memberid: _viewProfileController
                                                        .userdetail["profile"]
                                                    ["member_id"],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      icon: SizedBox(
                                        height: 60,
                                        width: 60,
                                        child: Image.asset(
                                            "assets/contactinitcircle.png"),
                                      ),
                                    ),
                                  ),
                                ),
                                // First Button: Interest
                                Expanded(
                                  flex: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 1.0, vertical: 10),
                                    child: _viewProfileController
                                                    .userdetail["memberData"]
                                                ["express_interest"] ==
                                            true
                                        ? ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: const Size(
                                                  double.infinity, 60),
                                            ),
                                            onPressed: () {
                                              // Handle Interest sent action
                                            },
                                            icon: SizedBox(
                                              height: 18,
                                              width: 18,
                                              child: Image.asset(
                                                  "assets/interestSentfill.png"),
                                            ),
                                            label: Text(
                                                language == "en"
                                                    ? "Interest sent"
                                                    : "इंटरेस्ट पाठवले",
                                                style: CustomTextStyle
                                                    .elevatedButtonFABLarge),
                                          )
                                        : Obx(() {
                                            return _dashboardController
                                                    .hasExpressedInterest(
                                                        _viewProfileController
                                                                    .userdetail[
                                                                "memberData"]
                                                            ["member_id"])
                                                ? ElevatedButton.icon(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      minimumSize: const Size(
                                                          double.infinity, 60),
                                                    ),
                                                    onPressed: () {
                                                      // Handle Interest action
                                                    },
                                                    icon: SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child: Image.asset(
                                                          "assets/interestSentfill.png"),
                                                    ),
                                                    label: Text(
                                                        language == "en"
                                                            ? "Interest sent"
                                                            : "इंटरेस्ट पाठवले",
                                                        style: CustomTextStyle
                                                            .elevatedButtonFABLarge),
                                                  )
                                                : ElevatedButton.icon(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      minimumSize: const Size(
                                                          double.infinity, 60),
                                                    ),
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return ExpressInterestDialogue(
                                                            memberID: _viewProfileController
                                                                        .userdetail[
                                                                    "memberData"]
                                                                ["member_id"],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    icon: SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child: Image.asset(
                                                          "assets/sendInterestBorder.png"),
                                                    ),
                                                    label: Text(
                                                        language == "en"
                                                            ? "Send Interest"
                                                            : "इंटरेस्ट पाठवा",
                                                        style: CustomTextStyle
                                                            .elevatedButtonFABLarge),
                                                  );
                                          }),
                                  ),
                                ),

                                // Divider
                                Container(
                                    color: Colors.white, width: 1, height: 19),

                                // Second Button: Shortlist
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 1.0),
                                    child: _viewProfileController
                                                    .userdetail["memberData"]
                                                ["Shortlisted"] ==
                                            true
                                        ? IconButton(
                                            onPressed: () {
                                              /*   _dashboardController.removeFromShortlistOnDetails(
                memberid: _viewProfileController.userdetail["memberData"]["member_id"],
              );*/
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return ShortListedDialogue(
                                                    memberid:
                                                        _viewProfileController
                                                                    .userdetail[
                                                                "memberData"]
                                                            ["member_id"],
                                                  );
                                                },
                                              );
                                              print("THIS IS SHORTLISTED");
                                            },
                                            icon: SizedBox(
                                              height: 60,
                                              width: 60,
                                              child: Image.asset(
                                                  "assets/shortlistcirclefilled.png"),
                                            ),
                                          )
                                        : Obx(() {
                                            print(
                                                "THis is shortlisted bool ${_dashboardController.hasShortlisted(_viewProfileController.userdetail["memberData"]["member_id"])}");
                                            return _dashboardController
                                                    .hasShortlisted(
                                                        _viewProfileController
                                                                    .userdetail[
                                                                "memberData"]
                                                            ["member_id"])
                                                ? IconButton(
                                                    onPressed: () {
                                                      print(
                                                          "THIS IS SHORTLISTED");
                                                      /*            _dashboardController.removeFromShortlistOnDetails(
                memberid: _viewProfileController.userdetail["memberData"]["member_id"],
              );*/
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return ShortListedDialogue(
                                                            memberid: _viewProfileController
                                                                        .userdetail[
                                                                    "memberData"]
                                                                ["member_id"],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    icon: SizedBox(
                                                      height: 60,
                                                      width: 60,
                                                      child: Image.asset(
                                                          "assets/shortlistcirclefilled.png"),
                                                    ),
                                                  )
                                                : IconButton(
                                                    onPressed: () {
                                                      // Handle Shortlisted action
                                                      _dashboardController
                                                          .shortlistMember(
                                                        memberid:
                                                            _viewProfileController
                                                                        .userdetail[
                                                                    "memberData"]
                                                                ["member_id"],
                                                      );
                                                    },
                                                    icon: SizedBox(
                                                      height: 60,
                                                      width: 60,
                                                      child: Image.asset(
                                                          "assets/shortlistcircle.png"),
                                                    ),
                                                  );
                                          }),
                                  ),
                                ),

                                // Divider
                                //  Container(color: Colors.white, width: 1, height: 19),

                                // Third Button: Contacts
                              ],
                            ),
                          ),
                        );
                      }
                    }
                  })),
            );
          }
        }
      },
    );
  }

  Column displayFormat({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                overflow: TextOverflow.ellipsis,
                title,
                style: CustomTextStyle.bodytext,
              ),
              Text(
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  subtitle,
                  style: CustomTextStyle.bodytextbold.copyWith(
                    fontWeight: subtitle.toString() == 'Not Filled' ||
                            subtitle.toString() == 'माहिती नाही '
                        ? FontWeight.w400
                        : null,
                    fontSize: subtitle.toString() == 'Not Filled' ||
                            subtitle.toString() == 'माहिती नाही '
                        ? 11
                        : null,
                    fontStyle: subtitle.toString() == 'Not Filled' ||
                            subtitle.toString() == 'माहिती नाही '
                        ? FontStyle.italic
                        : null,
                  )),
              // style: CustomTextStyle.bodytextbold),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ],
    );
  }
}

class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader(
      {super.key, this.userdetail, this.profileheader, this.images});
  final dynamic userdetail;
  final dynamic profileheader;
  final dynamic images;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 500,
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              profileheader["photoUrl"],
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Gradient overlay
        Container(
          height: 500,
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color(0xFF0C0B0B), // #0C0B0B at 100%
                Color(0x800C0B0B), // rgba(12, 11, 11, 0.5) at 45.36%
                Color(0x00FFFFFF), // rgba(255, 255, 255, 0) at 0%
              ],
              stops: [0.0, 0.45, 1.0],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            height: 470,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey,
                      child: Stack(
                        clipBehavior: Clip
                            .none, // Allows the red dot to overflow the CircleAvatar
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                barrierDismissible: false,
                                barrierColor: Colors.black.withOpacity(0.9),
                                context: context,
                                builder: (context) {
                                  return ShowImages(
                                    images: images,
                                  );
                                },
                              );
                            },
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.grey,
                              child: ClipOval(
                                child: Image.asset("assets/images.png",
                                    fit: BoxFit.contain),
                              ),
                            ),
                          ),
                          Positioned(
                            top: -5, // Adjust the position of the red dot
                            right: -3, // Adjust the position of the red dot
                            child: Container(
                                height: 20,
                                width: 20,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    images is List
                                        ? images.length.toString()
                                        : '0', // Check if images is a List and get the length
                                    style: const TextStyle(
                                      fontSize:
                                          10, // Adjust the font size to make the number more visible
                                      color: Colors
                                          .white, // Make the text inside the dot white for better visibility
                                    ),
                                  ),
                                )),
                          ),
                          // Adding text to the outer CircleAvatar
                        ],
                      ),
                    )
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      profileheader["member_name"],
                      style: CustomTextStyle.imageText.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      height: 15,
                      width: 15,
                      child: Image.asset("assets/verified.png"),
                    )
                  ],
                ),
                RichText(
                    text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: "${AppLocalizations.of(context)!.memberid} - ",
                      style: CustomTextStyle.imageText.copyWith(fontSize: 14)),
                  TextSpan(
                      text: "${profileheader["member_profile_id"]} ",
                      style: CustomTextStyle.imageText
                          .copyWith(fontSize: 14, fontWeight: FontWeight.w800)),
                ])),
                const SizedBox(height: 10),
                buildRichText("${userdetail["age"]} , ${userdetail["height"]}",
                    "${userdetail["personal_marital_status"]} "),
                buildRichText(
                    /* "${userdetail["section"]} - */ "${userdetail["subcaste"]}",
                    "${userdetail["present_city"]} ${userdetail["present_state"]} "),
                buildRichText("${userdetail["edu_occupation"]}",
                    "${userdetail["edu_annual_income"]} "),
              ],
            ),
          ),
        ),
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

class prefranceUserDetails extends StatelessWidget {
  const prefranceUserDetails({
    super.key,
    required this.assetimg,
    required this.title,
    required this.Subtitle,
    required this.assetimgtrailing,
  });
  final String assetimg;
  final String title;
  final String Subtitle;
  final String assetimgtrailing;

  @override
  Widget build(BuildContext context) {
    String? language = sharedPreferences?.getString("Language");
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 13,
                      width: 13,
                      child: Image.asset(assetimg),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      title,
                      style: CustomTextStyle.bodytext,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                  width: 15,
                  child: Image.asset(assetimgtrailing),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: ReadMoreText(
                Subtitle,
                trimLines: 2,
                trimMode: TrimMode.Line,
                trimCollapsedText:
                    language == "en" ? ' Read more' : " अधिक वाचा",
                trimExpandedText: language == "en" ? ' Read less' : " कमी वाचा",
                style: CustomTextStyle.bodytextSmall
                    .copyWith(fontWeight: FontWeight.w700),
                moreStyle: TextStyle(
                    color: AppTheme.textColor, fontWeight: FontWeight.w500),
                lessStyle: TextStyle(
                    color: AppTheme.selectedOptionColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}

class ContactViewPopup extends StatelessWidget {
  const ContactViewPopup(
      {super.key, required this.contactViewed, required this.memberid});
  final int memberid;
  final bool contactViewed;
  @override
  Widget build(BuildContext context) {
    final ViewProfileController viewprofileController =
        Get.put(ViewProfileController());
    viewprofileController.checkContacts();
    String? language = sharedPreferences?.getString("Language");

    return Dialog(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Obx(() {
          if (viewprofileController.checkContactdatafetching.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (viewprofileController.statuscode.value == 200) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () {
                                if (viewprofileController.checkContactdata[
                                        "total_weekly_remain_contact"] ==
                                    1) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18.0, vertical: 8),
                                          child: Center(
                                            child: Text(
                                                textAlign: TextAlign.center,
                                                language == "en"
                                                    ? "Weekly Contact Limit Exhaust soon..!"
                                                    : "साप्ताहिक संपर्क मर्यादा लवकरच संपणार आहे ",
                                                style: CustomTextStyle
                                                    .headlineMain2Primary),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                                textAlign: TextAlign.center,
                                                language == "en"
                                                    ? "Only ${viewprofileController.checkContactdata["total_weekly_remain_contact"]} contact pending ."
                                                    : "शेवटचा ${viewprofileController.checkContactdata["total_weekly_remain_contact"]} संपर्क बघण्याचा शिल्लक.",
                                                style: CustomTextStyle
                                                    .contactviewPopup),
                                          ),
                                        ),
                                        Center(
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(8),
                                              ),
                                            ),
                                            height: 102,
                                            width: 92,
                                            child: SizedBox(
                                              height: 102,
                                              width: 92,
                                              child: Image.asset(
                                                  "assets/ContactView1Day.png"),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                                textAlign: TextAlign.center,
                                                language == "en"
                                                    ? "Increase your contact limit to add more weekly contacts."
                                                    : "संपर्क वाढवून तुमची साप्ताहिक संपर्क मर्यादा वाढवा ",
                                                style:
                                                    CustomTextStyle.bodytext),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Center(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5))),
                                            ),
                                            onPressed: () {
                                              print("Member id $memberid");
                                              navigatorKey.currentState
                                                  ?.pushReplacement(
                                                      MaterialPageRoute(
                                                builder: (context) {
                                                  return const Addonplan();
                                                },
                                              ));
                                              // rgba(251, 214, 60, 1)
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: SizedBox(
                                                    height: 16,
                                                    width: 16,
                                                    child: Image.asset(
                                                      "assets/add-contacts.png",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    language == "en"
                                                        ? "ADD CONTACTS "
                                                        : "संपर्क वाढवा",
                                                    style: CustomTextStyle
                                                        .elevatedButtonWhiteLarge),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Center(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5))),
                                            ),
                                            onPressed: () {
                                              print("Member id $memberid");
                                              viewprofileController
                                                  .fetchContactDetails(
                                                      memberid: memberid)
                                                  .then(
                                                (value) {
                                                  Get.back();
                                                  showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return ContactViewDetailsPopup(
                                                          contactViewed:
                                                              contactViewed,
                                                          memberID: memberid);
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: SizedBox(
                                                    height: 16,
                                                    width: 16,
                                                    child: Image.asset(
                                                      "assets/contactsborder.png",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    language == "en"
                                                        ? "VIEW CONTACT"
                                                        : "संपर्क पहा",
                                                    style: CustomTextStyle
                                                        .elevatedButtonWhiteLarge),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Center(
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.back();
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: SizedBox(
                                                    height: 16,
                                                    child: Image.asset(
                                                        "assets/no-thanks.png"),
                                                  ),
                                                ),
                                                Text(
                                                  // " No",
                                                  AppLocalizations.of(context)!
                                                      .no,
                                                  style: CustomTextStyle
                                                      .bodytextbold,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                              textAlign: TextAlign.center,
                                              language == "en"
                                                  ? "Great Choice!  \n  Contact with Your Match Now"
                                                  : "उत्तम निवड! \n तुमची निवड अगदी छान आहे.",
                                              style: CustomTextStyle
                                                  .headlineMain2Primary),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                              textAlign: TextAlign.center,
                                              language == "en"
                                                  ? "${viewprofileController.checkContactdata["total_weekly_remain_contact"]} contact pending in this week"
                                                  : "या आठवड्यात तुम्ही ${viewprofileController.checkContactdata["total_weekly_remain_contact"]} संपर्क बघू शकतात",
                                              style: CustomTextStyle
                                                  .contactviewPopup),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                              textAlign: TextAlign.center,
                                              language == "en"
                                                  ? "Take the first step toward meaningful connections and call the profile you like!"
                                                  : "स्थळ पसंत असल्यास आताच जोडीदारासोबत संपर्क करा. ",
                                              style: CustomTextStyle.bodytext),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                          ),
                                          onPressed: () {
                                            print("Member id $memberid");
                                            viewprofileController
                                                .fetchContactDetails(
                                                    memberid: memberid)
                                                .then(
                                              (value) {
                                                Get.back();
                                                showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (context) {
                                                    return ContactViewDetailsPopup(
                                                        contactViewed:
                                                            contactViewed,
                                                        memberID: memberid);
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: SizedBox(
                                                  height: 16,
                                                  width: 16,
                                                  child: Image.asset(
                                                    "assets/contactsborder.png",
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                  language == "en"
                                                      ? "VIEW CONTACT"
                                                      : "संपर्क पहा",
                                                  style: CustomTextStyle
                                                      .elevatedButtonWhiteLarge),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.back();
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: SizedBox(
                                                  height: 16,
                                                  child: Image.asset(
                                                      "assets/no-thanks.png"),
                                                ),
                                              ),
                                              Text(
                                                // " No",
                                                AppLocalizations.of(context)!
                                                    .no,
                                                style: CustomTextStyle
                                                    .bodytextbold,
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
                            /*  Obx(
                          () {
                            if (viewprofileController.checkContactdata[
                                    "total_weekly_remain_contact"] ==
                                1) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                      textAlign: TextAlign.center,
                                      "Only ${viewprofileController.checkContactdata["total_weekly_remain_contact"]} contact pending .",
                                      style: CustomTextStyle.headlineMain2),
                                ),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                      textAlign: TextAlign.center,
                                      "${viewprofileController.checkContactdata["total_weekly_remain_contact"]} contact pending in this week",
                                      style: CustomTextStyle.contactviewPopup),
                                ),
                              );
                            }
                          },
                        )*/

                            /*  Obx(
                          () {
                            if (viewprofileController.checkContactdata[
                                    "total_weekly_remain_contact"] ==
                                1) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                      textAlign: TextAlign.center,
                                      "Increase your contact limit to add more weekly contacts.",
                                      style: CustomTextStyle.bodytext),
                                ),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                      textAlign: TextAlign.center,
                                      "Take the first step toward meaningful connections and call the profile you like!",
                                      style: CustomTextStyle.bodytext),
                                ),
                              );
                            }
                          },
                        ),
                     */

                            const SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
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
                                      height: 24,
                                      width: 24,
                                      "assets/close-popup.png"),
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else if (viewprofileController.statuscode.value == 429) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 35,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: language == "en"
                                          ? "Great Choice! \n Weekly Contact Limit"
                                          : "तुमची निवड खूप छान आहे..!",
                                      style:
                                          CustomTextStyle.headlineMain2Primary),
                                  TextSpan(
                                    text: language == "en"
                                        ? "\nExhausted"
                                        : "\nतुमची या आठवड्यातील संपर्क मर्यादा संपली..!",
                                    style: CustomTextStyle.textbuttonRed
                                        .copyWith(fontSize: 17),
                                  )
                                ]),
                              ),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            height: 180,
                            width: 329,
                            child: SizedBox(
                              height: 180,
                              width: 286,
                              child:
                                  Image.asset("assets/contactLimitExpired.png"),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          color: Colors.black,
                          onPressed: () {
                            Get.back(); // Close dialog
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: Text(
                          textAlign: TextAlign.center,
                          language == "en"
                              ? "To connect this profile increase your weekly limit by adding more contacts today..!"
                              : "या प्रोफाईल सोबत लगेच कनेक्ट करण्यासाठी आणखी संपर्क खरेदी करून तुमची आठवड्याची संपर्क मर्यादा वाढवा..!",
                          style: CustomTextStyle.bodytext,
                        )),
                        const SizedBox(height: 10),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                            onPressed: () {
                              Get.back();
                              // navigatorKey.currentState!
                              //     .pushReplacement(MaterialPageRoute(
                              //   builder: (context) => Addonplan(),
                              // ));
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  language == "en"
                                      ? "Upgrade weekly limit"
                                      : "संपर्क वाढवा",
                                  style: CustomTextStyle.elevatedButton
                                      .copyWith(fontSize: 14),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: Image.asset(
                                      "assets/partnerexpectation.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
                                    height: 16,
                                    child: Image.asset("assets/no-thanks.png"),
                                  ),
                                ),
                                Text(
                                  // "No",
                                  AppLocalizations.of(context)!.no,
                                  style: CustomTextStyle.bodytextbold,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                ],
              );
            } else if (viewprofileController.statuscode.value == 403) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                          color: const Color.fromARGB(255, 240, 115, 151)
                              .withOpacity(0.3),
                        ),
                        height: 209,
                        width: 329,
                        child: SizedBox(
                          height: 180,
                          width: 286,
                          child: Image.asset("assets/cancel.png"),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          color: Colors.black,
                          onPressed: () {
                            Get.back(); // Close dialog
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "${viewprofileController.checkContactdata["message"]}!!!",
                              style: const TextStyle(
                                fontFamily: "WORKSANS",
                                color: Colors.red,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Get.back();
                              navigatorKey.currentState!
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => const Addonplan(),
                              ));
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Buy Add On",
                                  style: CustomTextStyle.elevatedButton
                                      .copyWith(fontSize: 14),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: Image.asset(
                                      "assets/partnerexpectation.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (viewprofileController.statuscode.value == 409) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        height: 209,
                        width: 329,
                        child: SizedBox(
                          height: 180,
                          width: 286,
                          child: Image.asset("assets/cancel.png"),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          color: Colors.black,
                          onPressed: () {
                            Get.back(); // Close dialog
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "${viewprofileController.checkContactdata["message"]}!!!",
                              style: const TextStyle(
                                fontFamily: "WORKSANS",
                                color: Colors.red,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Weekly Contact Limit :- ${viewprofileController.checkContactdata["plan_data"]["weekly_contact_limit"]}",
                            textAlign: TextAlign.center,
                            style: CustomTextStyle.bodytext,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Remaining Contacts for Plan :- ${viewprofileController.checkContactdata["plan_data"]["remain_contact"]}",
                            textAlign: TextAlign.center,
                            style: CustomTextStyle.bodytext,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "This week Total Contact Views :- ${viewprofileController.checkContactdata["plan_data"]["total_weekly_contact_view"]}",
                            textAlign: TextAlign.center,
                            style: CustomTextStyle.bodytext,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              navigatorKey.currentState!
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => const Addonplan(),
                              ));
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Buy Add On",
                                  style: CustomTextStyle.elevatedButton
                                      .copyWith(fontSize: 14),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: Image.asset(
                                      "assets/partnerexpectation.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text("Opps something went wrong"),
              );
            }
          }
        }),
      ),
    );
  }
}

class ContactViewDetailsPopup extends StatelessWidget {
  const ContactViewDetailsPopup(
      {super.key, required this.contactViewed, required this.memberID});
  final int memberID;
  final bool contactViewed;
  @override
  Widget build(BuildContext context) {
    final ViewProfileController viewprofileController =
        Get.put(ViewProfileController());
    String? language = sharedPreferences?.getString("Language");

    return Dialog(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Obx(() {
          if (viewprofileController.Contactdatafetching.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final mybox = Hive.box('myBox');
            String gender = mybox.get("gender") == 2 ? "Bride" : "Groom";
            String gender2 = mybox.get("gender") == 2 ? "वधूचा" : "वराचा";
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                                textAlign: TextAlign.center,
                                language == "en"
                                    ? "All Contact Details"
                                    : "संपूर्ण संपर्क माहिती ",
                                style: CustomTextStyle.headlineMain2Primary),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                          height: 180,
                          width: 329,
                          child: SizedBox(
                            height: 180,
                            width: 286,
                            child: Image.asset("assets/contactdetails.png"),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        color: Colors.black,
                        onPressed: () {
                          if (contactViewed == true) {
                            Get.back();
                          } else {
                            Get.back(); // Close dialog

                            viewprofileController.fetchUserInfo(
                                memberid: memberID);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Text(
                        textAlign: TextAlign.center,
                        language == "en"
                            ? "$gender Contact Number :-"
                            : "$gender2 संपर्क क्रमांक :-",
                        style: CustomTextStyle.bodytext,
                      )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppTheme.floatingActionBG,
                          ),
                          child: Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: CustomTextStyle
                                    .bodytext, // Base style for the text.
                                children: [
                                  TextSpan(
                                    text:
                                        "${viewprofileController.Contactdata["mobile_number"]} ",
                                  ),
                                  if (viewprofileController
                                          .Contactdata["mobile_number"] !=
                                      "Private")
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: GestureDetector(
                                        onTap: () {
                                          Clipboard.setData(
                                            ClipboardData(
                                              text: viewprofileController
                                                  .Contactdata["mobile_number"],
                                            ),
                                          ).then((value) {
                                            Get.snackbar(
                                              "Copied", // Title of the snackbar
                                              "Mobile number copied to clipboard", // Message
                                              snackPosition: SnackPosition
                                                  .BOTTOM, // Position of the snackbar
                                              backgroundColor:
                                                  Colors.black.withOpacity(0.7),
                                              colorText: Colors.white,
                                              margin: const EdgeInsets.all(10),
                                              duration:
                                                  const Duration(seconds: 2),
                                            );
                                          });
                                          print("Copied");
                                        },
                                        child: Icon(
                                          Icons.copy,
                                          color: AppTheme.textColor,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                          child: Text(
                        textAlign: TextAlign.center,
                        language == "en"
                            ? "$gender Parent's Contact Number :-"
                            : "$gender2 पालकांचा संपर्क क्रमांक :-",
                        style: CustomTextStyle.bodytext,
                      )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppTheme.floatingActionBG,
                          ),
                          child: Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: CustomTextStyle
                                    .bodytext, // Base style for the text.
                                children: [
                                  TextSpan(
                                    text:
                                        "${viewprofileController.Contactdata["parents_contact_no"]} ",
                                  ),
                                  if (viewprofileController
                                          .Contactdata["parents_contact_no"] !=
                                      "Private")
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: GestureDetector(
                                        onTap: () {
                                          Clipboard.setData(
                                            ClipboardData(
                                              text: viewprofileController
                                                      .Contactdata[
                                                  "parents_contact_no"],
                                            ),
                                          ).then((value) {
                                            Get.snackbar(
                                              "Copied", // Title of the snackbar
                                              "Parent's Number copied to clipboard", // Message
                                              snackPosition: SnackPosition
                                                  .BOTTOM, // Position of the snackbar
                                              backgroundColor:
                                                  Colors.black.withOpacity(0.7),
                                              colorText: Colors.white,
                                              margin: const EdgeInsets.all(10),
                                              duration:
                                                  const Duration(seconds: 2),
                                            );
                                          });
                                          print("Copied");
                                        },
                                        child: Icon(
                                          Icons.copy,
                                          color: AppTheme.textColor,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                          child: Text(
                        textAlign: TextAlign.center,
                        language == "en"
                            ? "$gender Email ID :-"
                            : "$gender2 ईमेल आयडी :-",
                        style: CustomTextStyle.bodytext,
                      )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppTheme.floatingActionBG,
                          ),
                          child: Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: CustomTextStyle
                                    .bodytext, // Base style for the text.
                                children: [
                                  TextSpan(
                                    text:
                                        "${viewprofileController.Contactdata["email_address"]} ",
                                  ),
                                  if (viewprofileController
                                          .Contactdata["email_address"] !=
                                      "Private")
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: GestureDetector(
                                        onTap: () {
                                          Clipboard.setData(
                                            ClipboardData(
                                              text: viewprofileController
                                                  .Contactdata["email_address"],
                                            ),
                                          ).then((value) {
                                            Get.snackbar(
                                              "Copied", // Title of the snackbar
                                              "Email ID copied to clipboard", // Message
                                              snackPosition: SnackPosition
                                                  .BOTTOM, // Position of the snackbar
                                              backgroundColor:
                                                  Colors.black.withOpacity(0.7),
                                              colorText: Colors.white,
                                              margin: const EdgeInsets.all(10),
                                              duration:
                                                  const Duration(seconds: 2),
                                            );
                                          });
                                          print("Copied");
                                        },
                                        child: Icon(
                                          Icons.copy,
                                          color: AppTheme.textColor,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}

/*

class InterestSentDialogue extends StatelessWidget {
  const InterestSentDialogue({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),), 
      
      child: Image.asset("assets/activeUser.png")
    ),);
  }
}
*/

class ShortListedDialogue extends StatelessWidget {
  const ShortListedDialogue({super.key, required this.memberid});
  final int memberid;
  @override
  Widget build(BuildContext context) {
    String? language = sharedPreferences?.getString("Language");

    final DashboardController viewProfileController =
        Get.find<DashboardController>();
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
                              viewProfileController
                                  .removeFromShortlistOnDetails(
                                memberid: memberid,
                              );
                            },
                            child: Text(
                              language == "en"
                                  ? "Remove From Shortlist"
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
                                language == "en" ? " Cancel" : "रद्द करा",
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


/*
Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
        Container(
          decoration: BoxDecoration(borderRadius: const BorderRadius.only( topLeft:  Radius.circular(8) , topRight: Radius.circular(8)), 
          
          
          ),
          height: 209, width: 329, 
        child: Stack(children: [
    
          SizedBox(height: 180, width: 286, child: Image.asset("assets/popup.png"),), 

          
        ],)
        ), 
     Padding(
       padding: const EdgeInsets.all(18.0),
       child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
             const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: Text(
              textAlign: TextAlign.center,
              "Remove from Shortlist?" , style: TextStyle(
              fontFamily: "WORKSANS",
              color: Colors.black , fontWeight: FontWeight.w700 , fontSize: 16),),),
          ), 
            const SizedBox(height: 10,), 
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                textAlign: TextAlign.center,
                "This will remove the profile from your shortlist. Click \"Remove\" to confirm or \"Cancel\" to keep it in your list. " , style: CustomTextStyle.bodytext,),
            ), 
            const SizedBox(height: 10,),
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
            Get.back();
                          viewProfileController.removeFromShortlistOnDetails(
              memberid: memberid,
            );
                    }, child: const Text("Remove" , style: CustomTextStyle.elevatedButtonSmall,))), 

                ],)
            )
        ],),
     )
      ],),*/