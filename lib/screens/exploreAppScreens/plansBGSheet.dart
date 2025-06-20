import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:get/get_core/src/get_main.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/planControllers/premiumPlanController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/screens/exploreAppScreens/plansSlider.dart';
import 'package:_96kuliapp/screens/plans/upgradeScreen.dart';
import 'package:_96kuliapp/utils/formHeader.dart';

class PlanSlideSheet extends StatefulWidget {
  const PlanSlideSheet({super.key, required this.memberId});
  final int memberId;
  @override
  State<PlanSlideSheet> createState() => _PlanSlideSheetState();
}

Future<void> AddVisitedByMeList({
  required int MemberID,
}) async {
  // The API URL where you want to send the POST request
  String url = '${Appconstants.baseURL}/api/save-profile-visitor';

  // The request body
  Map<String, dynamic> body = {
    "visited_member_id": MemberID,
  };

  try {
    String? token = sharedPreferences!.getString("token");

    // Sending the POST request
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    print("No segments ${response.body}");
    if (response.statusCode == 200) {
      // Handle success
      //  print('basic successful');
      // You can handle the response data here
      //  var data = jsonDecode(response.body);
      // Do something with the data if needed
      print('Response body: visitor ${response.body}');
      //  sharedPreferences!.setString("PageIndex" , "3");
      // Get.offAllNamed(AppRouteNames.userInfoStepTwo);
    } else {
      // Handle error
      print('Failed to register: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    // Handle exceptions
    print('Error: $e');
  } finally {}
}

class _PlanSlideSheetState extends State<PlanSlideSheet>
    with SingleTickerProviderStateMixin {
  final PremiumPlanController _premiumPlanController =
      Get.find<PremiumPlanController>();
  late AnimationController _controller;
  late Animation<double> _animation;
  String? language = sharedPreferences?.getString("Language");

  @override
  void initState() {
    if (widget.memberId != 0) {
      AddVisitedByMeList(MemberID: widget.memberId);
    }
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // Animation duration
      vsync: this,
    )..repeat(); // Repeat the animation

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_premiumPlanController.planListOffer.isNotEmpty) {
      return SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                      color: Colors.transparent,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            child: SizedBox(
                              height: 450,
                              width: double.infinity,
                              child: Image.asset(
                                "assets/premiumPlanBG.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // ClipRRect(
                          //   borderRadius: BorderRadius.only(
                          //       topLeft: Radius.circular(10),
                          //       topRight: Radius.circular(
                          //           10)), // Set the corner radius to 15
                          //   child: Container(
                          //     height: 450,
                          //     width: double.infinity,
                          //     child: Image.network(
                          //       "${_premiumPlanController.planBGimg.value}",
                          //       fit: BoxFit.cover,
                          //     ),
                          //   ),
                          // ),
                          Container(
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Padding(
                                  //   padding: EdgeInsets.all(10.0),
                                  //   child: Text(
                                  //     textAlign: TextAlign.center,
                                  //     "${_premiumPlanController.planPopupHeading.value}",
                                  //     style: TextStyle(
                                  //         color: Colors.white,
                                  //         fontSize: 18,
                                  //         fontWeight: FontWeight.w700),
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      language == "en"
                                          ? "${_premiumPlanController.planListOffer[0]["discount_data"]["discount_heading"]}"
                                          : "${_premiumPlanController.planListOffer[0]["discount_data_mr"]["discount_heading"]}",
                                      // "अनुरूप मुलींची स्थळे बघण्यासाठी प्रीमियम सदस्य व्हा !!",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  // superSale
                                  Align(
                                    alignment: Alignment
                                        .centerLeft, // Aligns the image to the left
                                    child: SizedBox(
                                      height: 130,
                                      width: double.infinity,
                                      child: Image.network(
                                        language == "en"
                                            ? "${Appconstants.baseURL}/public/storage/planImage/${_premiumPlanController.planListOffer[0]["discount_data"]["discount_image"]}"
                                            : "${Appconstants.baseURL}/public/storage/planImage/${_premiumPlanController.planListOffer[0]["discount_data_mr"]["discount_image"]}",
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const SizedBox
                                              .shrink(); // Transparent placeholder
                                        },
                                      ),
                                    ),
                                  ),

                                  //   const Text("Exclusive Savings Up to 80%" , style: TextStyle(fontWeight: FontWeight.w600 , color: Color.fromARGB(255, 232, 255, 56) , fontSize: 16),),
                                  //        const SizedBox(height: 20,),
                                  /*          Container ( 
                              
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color.fromARGB(255, 255, 199, 56)),
                                borderRadius: const BorderRadius.all(Radius.circular(5))
                              
                              ,
                              color: const Color.fromARGB(255, 255, 199, 56)
                              
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text("Offer Expire Soon" , style: TextStyle(color: Colors.black , 
                                fontFamily: "WORKSANSBOLD",
                                fontWeight: FontWeight.w700 , fontSize: 14),),
                              ),) ,*/
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  // SizedBox(
                                  //   width: double.infinity,
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.all(20.0),
                                  //     child: Image.network(
                                  //         fit: BoxFit.fitHeight,
                                  //         language == "en"
                                  //             ? "${Appconstants.baseURL}/public/storage/planImage/${_premiumPlanController.planListOffer[0]["discount_data"]["discount_image"]}"
                                  //             : "${Appconstants.baseURL}/public/storage/planImage/${_premiumPlanController.planListOffer[0]["discount_data_mr"]["discount_image"]}"),
                                  //   ),
                                  // ),
                                  PlanTimer(
                                    onPage: "Popup",
                                    premiumPlanController:
                                        _premiumPlanController,
                                    animation: _animation,
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),

                                  const PlansSlider(),
                                ],
                              ),
                            ),
                          )
                        ],
                      ))
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    color: Colors.transparent,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: SizedBox(
                            height: 450,
                            width: double.infinity,
                            child: Image.asset(
                              "assets/premiumPlanBG.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 25,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    language == "en"
                                        ? "Take the next step in your journey! "
                                        // ? "Your perfect matches are waiting..!"
                                        : "रजिस्ट्रेशन तर तुम्ही केलंय..!!",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 5,
                                        height: 5,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        child: const Divider(
                                          color: Colors.white,
                                          thickness: 2,
                                        ),
                                      ),
                                      Container(
                                        width: 5,
                                        height: 5,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text: language == "en"
                                            ? "Upgrade to Premium and get full access to profiles,"
                                            : "परंतु ",
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                      TextSpan(
                                        text: language == "en"
                                            ? " interests,"
                                            : " मनपसंत स्थळे ",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            // rgba(255, 199, 56, 1)
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromRGBO(
                                                255, 231, 18, 1)),
                                      ),
                                      TextSpan(
                                        text: language == "en"
                                            ? " and"
                                            : "बघण्यासाठी व त्यांचा",
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                      TextSpan(
                                        text: language == "en"
                                            ? " direct connections"
                                            : " संपर्क क्रमांक ",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromRGBO(
                                                255, 231, 18, 1)),
                                      ),
                                      // TextSpan(
                                      //   text: " आणि ",
                                      //   style: TextStyle(
                                      //       fontSize: 14,
                                      //       color: Colors.white),
                                      // ),
                                      // TextSpan(
                                      //   text: "गुणमिलन ",
                                      //   style: TextStyle(
                                      //       fontSize: 14,
                                      //       color: Color.fromRGBO(
                                      //           255, 199, 56, 1)),
                                      // ),
                                      TextSpan(
                                        text: language == "en"
                                            ? ""
                                            : " बघण्यासाठी प्रीमियम प्लॅनचे सदस्य बना",
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                    ])),
                                // Text(
                                //   language == "en"
                                //       ? " Become a premium member to connect with your matches"
                                //       : "आजच प्रीमियम सदस्य बनून अनुरूप जोडीदार निवडा!",
                                //   textAlign: TextAlign.center,
                                //   style: TextStyle(
                                //     color: Colors.white,
                                //     fontSize: 14,
                                //     fontWeight: FontWeight.w600,
                                //   ),
                                // ),
                                const SizedBox(height: 10),
                                Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 5,
                                        height: 5,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        child: const Divider(
                                          color: Colors.white,
                                          thickness: 2,
                                        ),
                                      ),
                                      Container(
                                        width: 5,
                                        height: 5,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const PlansSlider(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}
