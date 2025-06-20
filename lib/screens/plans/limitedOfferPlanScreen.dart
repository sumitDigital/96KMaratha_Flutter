// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/commons/dialogues/apidialogues/addonPLanDialogue.dart';
import 'package:_96kuliapp/commons/dialogues/apidialogues/upgradePlanDialogue.dart';
import 'package:_96kuliapp/commons/dialogues/logoutDialogoue.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/planControllers/premiumPlanController.dart';
import 'package:_96kuliapp/controllers/planControllers/premiumplanLimitedOfferController.dart';
import 'package:_96kuliapp/controllers/razorpayController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/auth_Screens/loginScreen2.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/appDrawer.dart';
import 'package:_96kuliapp/utils/backHeader.dart';
import 'package:_96kuliapp/utils/bottomnavBar.dart';
import 'package:_96kuliapp/utils/formHeader.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class PaymentPremiumOfferController extends GetxController {
  // Observable to track if payment is in progress
  var isPaymentInProgress = false.obs;

  // Method to start payment
  void startPayment() {
    if (!isPaymentInProgress.value) {
      isPaymentInProgress.value = true; // Start payment
    }
  }

  // Method to reset payment state
  void resetPaymentState() {
    isPaymentInProgress.value = false; // Reset payment flag
  }
}

Future<void> sendPaymentDataUpgradePlan(
    {required int addonPlanID,
    required String orderID,
    required String paymentID,
    required String signature}) async {
  print("INSEIDE PAYMENT SEND");
  String? token = sharedPreferences?.getString("token");
  // Define the URL for the API endpoint
  String url = '${Appconstants.baseURL}/api/razorpay-payment';

  // Define the request body with your parameters
  Map<String, dynamic> requestBody = {
    "member_token": "$token",
    "plan_id": addonPlanID,
    "order_id": orderID,
    "razorpay_payment_id": paymentID, // replace with actual payment ID
    "razorpay_signature": signature // replace with actual signature
  };

  // Set the Authorization token (if needed)

  // Set the headers
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $token", // Include the Authorization token
  };

  try {
    // Send the POST request to the API
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(requestBody), // Send data as JSON
    );
    print("Response for upgrade plan ${response.body}");
    // Check if the request was successful
    if (response.statusCode == 200) {
      // If successful, handle the response here
      print('Payment data sent successfully to backend');
      print('Response: ${response.body}');
    } else {
      // If there's an error, print the error message
      print('Failed to send payment data to backend');
      print('Error: ${response.body}');
    }
  } catch (e) {
    // Handle any exceptions (e.g., no internet connection)
    print('Error: $e');
  }
}

class PremiumLimitedOfferPlanScreen extends StatefulWidget {
  const PremiumLimitedOfferPlanScreen({super.key});

  @override
  State<PremiumLimitedOfferPlanScreen> createState() =>
      _PremiumLimitedOfferPlanScreenState();
}

class _PremiumLimitedOfferPlanScreenState
    extends State<PremiumLimitedOfferPlanScreen>
    with SingleTickerProviderStateMixin {
  final PremiumPlanLimitedOfferController _premiumPlanController =
      Get.put(PremiumPlanLimitedOfferController());
  final PaymentPremiumOfferController _paymentController =
      Get.put(PaymentPremiumOfferController());
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  late ScrollController _scrollController1;
  late ScrollController _scrollController2;
  final Razorpay _razorpay = Razorpay();
  late AnimationController _controller;
  late Animation<double> _animation;
  final facebookAppEvents = FacebookAppEvents();
  String? language = sharedPreferences?.getString("Language");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  _razorpaycontroller.fetchUserInfo();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);

    _premiumPlanController.fetchPlans();
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // Animation duration
      vsync: this,
    )..repeat(); // Repeat the animation

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _scrollController1 = ScrollController();
    _scrollController2 = ScrollController();

    // Synchronize the scroll of both controllers
    _scrollController1.addListener(() {
      if (_scrollController2.hasClients &&
          _scrollController1.offset != _scrollController2.offset) {
        _scrollController2.jumpTo(_scrollController1.offset);
      }
    });

    _scrollController2.addListener(() {
      if (_scrollController1.hasClients &&
          _scrollController2.offset != _scrollController1.offset) {
        _scrollController1.jumpTo(_scrollController2.offset);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController1.dispose();
    _scrollController2.dispose();

    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Process payment success
    sendPaymentDataUpgradePlan(
      addonPlanID: _premiumPlanController.selectedaddonPlanID.value,
      orderID: response.orderId.toString(),
      paymentID: response.paymentId.toString(),
      signature: response.signature.toString(),
    );
    // Reset the flag after payment is processed
    facebookAppEvents.logEvent(
        name: "Fb_96k_app_plan_purchase_successfully",
        parameters: {
          'PlanID': '${_premiumPlanController.selectedaddonPlanID.value}'
        });
    analytics.logEvent(name: "app_96k_plan_purchase_successfully", parameters: {
      'PlanID': '${_premiumPlanController.selectedaddonPlanID.value}'
    });
    print("Payment purchase_successfully: ${response.paymentId}");
    _paymentController.resetPaymentState();
    navigatorKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const BottomNavBar(),
      ),
      (route) => false,
    );
/*
  Future.delayed(const Duration(milliseconds: 500), () {
    Get.dialog(const UpgradePlanDialogue(), barrierDismissible: false);
  });*/
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment failed: ${response.message}");
    // Reset the flag after payment fails
    _paymentController.resetPaymentState();
    facebookAppEvents.logEvent(
        name: "Fb_96k_app_premium_plan_purchase_failed",
        parameters: {
          'PlanID': '${_premiumPlanController.selectedaddonPlanID.value}'
        });

    analytics.logEvent(
        name: "app_96k_premium_plan_purchase_failed",
        parameters: {
          'PlanID': '${_premiumPlanController.selectedaddonPlanID.value}'
        });
  }

  final List<String> lines = [
    "the right partner and family.",
    "profiles using government ID proofs",
    "Feel safe, we manually verify.",
    "the right partner and family."
  ];
  final List<String> whyMember = [
    "The ideal platform to find the perfect match within the Jain community.",
    "Trustworthy profiles to ensure you find a genuine match.",
    "Your Personal Information Is Protected At Every Step.",
    "Shortlist your favorite profiles and send interests with ease.",
    "Explore unlimited Jain brides & grooms.",
    "Discover advanced filtering options for better matches.",
    "Easily instant contact with your selected matches.",
    "As a Premium member, your profile receives priority listing.",
    "Save time and find quality matches.",
    "Special Savings on Premium Plans.",
    "Note: Premium plan will not be refunded for any reason after purchase.",
  ];

  List<FAQModel> faqData = [
    FAQModel(
        title: "Why should I purchase a premium plan?",
        subtitle:
            "Upgrading to a premium membership provides exclusive benefits that enhance your chances of finding the right match. With a premium plan, you can access contact details like phone numbers and email IDs, making it easier to connect with potential matches."),
    FAQModel(
        title: "Is my payment secure?",
        subtitle:
            "Yes, your payment is completely secure. All transactions are processed through encrypted payment gateways."),
    FAQModel(
        title: "Can I get a refund after purchasing the premium plan?",
        subtitle:
            "Membership fees are non-refundable. We encourage you to review the plan details carefully before making a payment to ensure it meets your expectations. Once the payment is completed, the membership cannot be canceled or refunded."),
    FAQModel(
        title: "What should I do if my payment fails?",
        subtitle:
            "In case your payment fails, do not worry. You can attempt the payment again using another payment method. Ensure that your internet connection is stable and that your card has sufficient balance. If the issue persists, feel free to contact our customer support team for further help and guidance."),
    FAQModel(
        title:
            "Does 96 Kuli Maratha Marriage ask for OTP or payment details over a call?",
        subtitle:
            "No, 96 Kuli Maratha Marriage never asks for OTPs, card details, or payment over a phone call. Please be cautious, as sharing such sensitive information with anyone can lead to fraud. If you receive any suspicious calls asking for personal or payment details, do not share anything and report the incident to our support team immediately."),
    FAQModel(
        title: "How do I upgrade to a premium membership?",
        subtitle:
            "You can upgrade to a premium membership by clicking on the \" Upgrade Membership \" button, selecting a plan, and completing the secure payment process."),
    FAQModel(
        title: "How do I contact customer support for help?",
        subtitle:
            "You can reach our customer support team via email. We’re here to assist with any questions or issues."),
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show the confirmation dialog
        bool? shouldExit = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
              ),
              title: Text(
                language == "en" ? 'Exit App' : "ॲपमधून बाहेर पडा",
                style: CustomTextStyle.bodytextLarge.copyWith(
                  color: Colors.black, // Title color
                  fontWeight: FontWeight.bold, // Bold title
                ),
              ),
              content: Text(
                language == "en"
                    ? 'Do you really want to exit the app?'
                    : "तुम्हाला ॲपमधून बाहेर पडायचे आहे का?",
                style: const TextStyle(
                  fontSize: 16, // Adjusted font size for content
                  color: Colors.black54, // Lighter color for content text
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 10.0), // Padding at the bottom of the buttons
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true); // User wants to exit
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              AppTheme.primaryColor, // White text color
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 12), // Button padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8), // Rounded corners for the button
                          ),
                        ),
                        child: const Text('Yes',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pop(false); // User doesn't want to exit
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              AppTheme.secondryColor, // White text color
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 12), // Button padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8), // Rounded corners for the button
                          ),
                        ),
                        child: const Text('No',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
        return shouldExit ?? false;
      },
      child: Scaffold(
        body: SafeArea(child: Obx(
          () {
            if (_premiumPlanController.loadingplans.value == true) {
              return Center(
                child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 70,
                          color: const Color.fromARGB(255, 222, 222, 226)
                              .withOpacity(0.25),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Upgrade Plan ",
                                    style: CustomTextStyle.bodytextLarge),
                                TextButton(
                                    onPressed: () async {
                                      //       Get.back();
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return const Logout(
                                            page: "offerPlanPage",
                                          );
                                        },
                                      );
                                    },
                                    child: const Text(
                                      "Logout",
                                      style: CustomTextStyle.textbuttonRed,
                                    ))
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 220.0,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 220.0,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 220.0,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 220.0,
                          color: Colors.white,
                        ),
                      ],
                    )),
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 70,
                      color: const Color.fromARGB(255, 222, 222, 226)
                          .withOpacity(0.25),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Upgrade Plan ",
                                style: CustomTextStyle.bodytextLarge),
                            TextButton(
                                onPressed: () async {
                                  //       Get.back();
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const Logout(
                                        page: "offerPlanPage",
                                      );
                                    },
                                  );
                                },
                                child: const Text(
                                  "Logout",
                                  style: CustomTextStyle.textbuttonRed,
                                ))
                          ],
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        Container(
                            child: Stack(
                          children: [
                            SizedBox(
                              height: 550,
                              width: double.infinity,
                              child: Image.asset(
                                "assets/limitedOfferPlan.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        "Your Soulmate Awaits Grab This Deal Now !!",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 21,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      height: 200,
                                      width: double.infinity,
                                      child: Image.network(
                                          _premiumPlanController.planimg.value),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Stack(
                                      children: [
                                        LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                    blurRadius: 10,
                                                    spreadRadius: 2,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                                color: const Color(0xFF051C3C),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(14.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      "Offer Expires in",
                                                      style: CustomTextStyle
                                                          .timerformattextHeading,
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        SizedBox(
                                                          height: 50,
                                                          width: 50,
                                                          child: Image.asset(
                                                            'assets/HourGlass.gif',
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        TimerCountdown(
                                                          onEnd: () {
                                                            print(
                                                                "THIS TIME END");
                                                          },
                                                          colonsTextStyle:
                                                              CustomTextStyle
                                                                  .timerformattext,
                                                          timeTextStyle:
                                                              CustomTextStyle
                                                                  .timerformattext,
                                                          descriptionTextStyle:
                                                              CustomTextStyle
                                                                  .timerformattextDesc,
                                                          format: CountDownTimerFormat
                                                              .hoursMinutesSeconds,
                                                          endTime:
                                                              DateTime.now()
                                                                  .add(Duration(
                                                            hours:
                                                                _premiumPlanController
                                                                    .endhours
                                                                    .value,
                                                            minutes:
                                                                _premiumPlanController
                                                                    .endminutes
                                                                    .value,
                                                            seconds:
                                                                _premiumPlanController
                                                                    .endseconds
                                                                    .value,
                                                          )),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        Positioned.fill(
                                          // Ensure the border overlays the entire child
                                          child: AnimatedBuilder(
                                            animation: _animation,
                                            builder: (context, child) {
                                              return CustomPaint(
                                                painter: AnimatedBorderPainter(
                                                  progress: _animation.value,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),

                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 25.0),
                                      child: SizedBox(
                                        height: 560,
                                        child: ListView.builder(
                                          controller: _scrollController1,
                                          itemCount: _premiumPlanController
                                              .planList.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            final plan = _premiumPlanController
                                                .planList[index];
                                            return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: 320,
                                                  height: 500,
                                                  decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.5), // Adjust the opacity as needed
                                                          spreadRadius:
                                                              2, // Controls how much the shadow spreads
                                                          blurRadius:
                                                              5, // Controls the blur effect
                                                          offset: const Offset(
                                                              3,
                                                              3), // Controls the position of the shadow (x, y)
                                                        ),
                                                      ],
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  10)),
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              245,
                                                              248,
                                                              250)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 18.0,
                                                            bottom: 10,
                                                            right: 18,
                                                            top: 10),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        RichText(
                                                          textAlign:
                                                              TextAlign.start,
                                                          text: TextSpan(
                                                            children: [
                                                              WidgetSpan(
                                                                child: Wrap(
                                                                  crossAxisAlignment:
                                                                      WrapCrossAlignment
                                                                          .center,
                                                                  spacing:
                                                                      4, // Adds spacing between the items
                                                                  children: [
                                                                    const Icon(
                                                                        Icons
                                                                            .star,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            216,
                                                                            16,
                                                                            89),
                                                                        size:
                                                                            14),
                                                                    const Icon(
                                                                        Icons
                                                                            .star,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            216,
                                                                            16,
                                                                            89),
                                                                        size:
                                                                            17),
                                                                    Text(
                                                                      "${plan["plan_popularity"]}",
                                                                      style:
                                                                          const TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            216,
                                                                            16,
                                                                            89),
                                                                        fontSize:
                                                                            16,
                                                                      ),
                                                                    ),
                                                                    const Icon(
                                                                        Icons
                                                                            .star,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            216,
                                                                            16,
                                                                            89),
                                                                        size:
                                                                            14),
                                                                    const Icon(
                                                                        Icons
                                                                            .star,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            216,
                                                                            16,
                                                                            89),
                                                                        size:
                                                                            17),
                                                                  ],
                                                                ),
                                                                alignment:
                                                                    PlaceholderAlignment
                                                                        .middle,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        RichText(
                                                            text: TextSpan(
                                                                children: [
                                                              TextSpan(
                                                                  text: "${plan["plan_name"]}"
                                                                      .toUpperCase(),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          30,
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          157,
                                                                          125,
                                                                          20))),
                                                            ])),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          "${plan["plan_duration_text"]}",
                                                          style: const TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  "WORKSANS",
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      80,
                                                                      93,
                                                                      126)),
                                                        ),
                                                        RichText(
                                                            text: TextSpan(
                                                                children: [
                                                              TextSpan(
                                                                  text:
                                                                      "₹ ${plan["discount_plan_price_without_gst"]} ",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          35,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontFamily:
                                                                          "WORKSANSBOLD",
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          80,
                                                                          93,
                                                                          126))),
                                                              const TextSpan(
                                                                  text: "+ GST",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          "WORKSANS",
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          80,
                                                                          93,
                                                                          126))),
                                                            ])),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        RichText(
                                                            textAlign: TextAlign
                                                                .center,
                                                            text: TextSpan(
                                                                children: [
                                                                  const TextSpan(
                                                                      text:
                                                                          "Save Upto ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontFamily:
                                                                              "WORKSANS",
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              157,
                                                                              125,
                                                                              20))),
                                                                  TextSpan(
                                                                    text:
                                                                        "₹ ${plan["plan_price_without_gst"] != null && plan["discount_plan_price_without_gst"] != null ? (double.tryParse(plan["plan_price_without_gst"].toString()) ?? 0.0) - (double.tryParse(plan["discount_plan_price_without_gst"].toString()) ?? 0.0) : 0.0}",
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontFamily:
                                                                          "WORKSANSBOLD",
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          157,
                                                                          125,
                                                                          20),
                                                                    ),
                                                                  )

                                                                  // plan_amount_per_month
                                                                ])),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),

                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: ElevatedButton
                                                              .icon(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              elevation:
                                                                  8, // Add elevation for shadow effect
                                                              shadowColor: Colors
                                                                  .grey
                                                                  .withOpacity(
                                                                      0.5), // Color of the shadow
                                                            ),
                                                            onPressed:
                                                                _paymentController
                                                                        .isPaymentInProgress
                                                                        .value
                                                                    ? null
                                                                    : () {
                                                                        _paymentController
                                                                            .startPayment(); // Start payment

                                                                        _premiumPlanController
                                                                            .selectedaddonPlanID
                                                                            .value = plan["plan_id"];
                                                                        var options =
                                                                            {
                                                                          'key':
                                                                              '${_premiumPlanController.userRazorPayKey}',
                                                                          'amount':
                                                                              '${plan["discount_plan_price_with_gst"]}',
                                                                          'order_id':
                                                                              '${plan["razorpay_order_id"]}',
                                                                          'name':
                                                                              'DMS',
                                                                          'description':
                                                                              'Add On Contacts',
                                                                        };
                                                                        _razorpay
                                                                            .open(options);
                                                                      },
                                                            icon: SizedBox(
                                                              height: 20,
                                                              child: Image.asset(
                                                                  "assets/premium1.png"),
                                                            ),
                                                            label:
                                                                const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                "Purchase Plan",
                                                                style: CustomTextStyle
                                                                    .elevatedButton,
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                        // stargold
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          8.0),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Image.asset(
                                                                    "assets/stargold.png",
                                                                    height:
                                                                        10, // Adjust icon size
                                                                    width:
                                                                        10, // Adjust icon size
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          8), // Add spacing between the icon and the text
                                                                  Expanded(
                                                                    child:
                                                                        RichText(
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      text:
                                                                          TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                                'View Total',
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                          TextSpan(
                                                                            text:
                                                                                ' ${plan["plan_contact"]} ',
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                          TextSpan(
                                                                            text:
                                                                                'Contact Numbers',
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          8.0),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Image.asset(
                                                                    "assets/stargold.png",
                                                                    height:
                                                                        10, // Adjust icon size
                                                                    width:
                                                                        10, // Adjust icon size
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          8), // Add spacing between the icon and the text
                                                                  Expanded(
                                                                    child:
                                                                        RichText(
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      text:
                                                                          TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                                'Get Weekly',
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                          TextSpan(
                                                                            text:
                                                                                ' ${plan["plan_weekly_contact_limit"]} ',
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                          TextSpan(
                                                                            text:
                                                                                'Contact Numbers',
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          8.0),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Image.asset(
                                                                    "assets/stargold.png",
                                                                    height:
                                                                        10, // Adjust icon size
                                                                    width:
                                                                        10, // Adjust icon size
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          8), // Add spacing between the icon and the text
                                                                  Expanded(
                                                                    child:
                                                                        RichText(
                                                                      maxLines:
                                                                          2,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      text:
                                                                          TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                                'Explore Unlimited ',
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                          TextSpan(
                                                                            text:
                                                                                '100% Jain Matches ',
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          8.0),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Image.asset(
                                                                    "assets/stargold.png",
                                                                    height:
                                                                        10, // Adjust icon size
                                                                    width:
                                                                        10, // Adjust icon size
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          8), // Add spacing between the icon and the text
                                                                  Expanded(
                                                                    child:
                                                                        RichText(
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      text:
                                                                          TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                                'Shortlist ',
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                          TextSpan(
                                                                            text:
                                                                                'Your Ideal Matches',
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          8.0),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Image.asset(
                                                                    "assets/stargold.png",
                                                                    height:
                                                                        10, // Adjust icon size
                                                                    width:
                                                                        10, // Adjust icon size
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          8), // Add spacing between the icon and the text
                                                                  Expanded(
                                                                    child:
                                                                        RichText(
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      text:
                                                                          TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                                'Send Interest',
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                          TextSpan(
                                                                            text:
                                                                                ' to Profiles You Like',
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          8.0),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Image.asset(
                                                                    "assets/stargold.png",
                                                                    height:
                                                                        10, // Adjust icon size
                                                                    width:
                                                                        10, // Adjust icon size
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          8), // Add spacing between the icon and the text
                                                                  Expanded(
                                                                    child:
                                                                        RichText(
                                                                      maxLines:
                                                                          2,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      text:
                                                                          TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                                'Enhanced ',
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                          TextSpan(
                                                                            text:
                                                                                'Profile Visibility ',
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        RichText(
                                                            text: const TextSpan(
                                                                children: <TextSpan>[
                                                              TextSpan(
                                                                  text: "*",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red)),
                                                              TextSpan(
                                                                  text:
                                                                      " Offer valid for limited time Period ",
                                                                  style: CustomTextStyle
                                                                      .fieldName),
                                                              TextSpan(
                                                                  text: "*",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red))
                                                            ])),
                                                      ],
                                                    ),
                                                  ),
                                                ));
                                          },
                                        ),
                                      ),
                                    ),
                                    //  SizedBox(height: 20 ,),
                                    /* CarouselSlider.builder(itemCount: _premiumPlanController.planList.length, itemBuilder: (context, index, realIndex) {
                              final plan = _premiumPlanController.planList[index];
                             return Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Container(
                                height: 500,
                                decoration: BoxDecoration(
                             boxShadow: [
                                           BoxShadow(
                                             color: Colors.grey.withOpacity(0.5), // Adjust the opacity as needed
                                             spreadRadius: 2, // Controls how much the shadow spreads
                                             blurRadius: 5, // Controls the blur effect
                                             offset: const Offset(3, 3), // Controls the position of the shadow (x, y)
                                           ),
                                         ],
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  color: const Color.fromARGB(255, 245, 248, 250)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only( left:  28.0 , bottom: 10 , right: 28 , top: 10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                                   RichText(
                                           textAlign: TextAlign.start,
                                           text: const TextSpan(
                                             children: [
                                               WidgetSpan(
                                         child: Wrap(
                                           crossAxisAlignment: WrapCrossAlignment.center,
                                           spacing: 4, // Adds spacing between the items
                                           children: [
                                             Icon(Icons.star, color: Color.fromARGB(255, 216, 16, 89), size: 14),
                                             Icon(Icons.star, color: Color.fromARGB(255, 216, 16, 89), size: 17),
                                             Text(
                                               "Best seller",
                                               style: TextStyle(
                                                 color: Color.fromARGB(255, 216, 16, 89),
                                                 fontSize: 16,
                                               ),
                                             ),
                                             Icon(Icons.star, color: Color.fromARGB(255, 216, 16, 89), size: 14),
                                             Icon(Icons.star, color: Color.fromARGB(255, 216, 16, 89), size: 17),
                                           ],
                                         ),
                                         alignment: PlaceholderAlignment.middle,
                                               ),
                                              
                                             ],
                                           ),
                                         ), 
                                         const SizedBox(height: 10,),
                                    RichText(text: TextSpan(children:  [ 
                                         TextSpan(text: "${plan["plan_name"]}" , style: const TextStyle(
                                    fontSize: 30,
                                    color: Color.fromARGB(255, 157, 125, 20))) , 
                                         
                                         
                                    ])),
                                    const SizedBox(height: 10,), 
                                    Text("${plan["plan_duration_text"]}" , style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500, 
                                    fontFamily: "WORKSANSBOLD",
                                    color: Color.fromARGB(255, 80, 93, 126)) ,),
                                                     RichText(text: TextSpan(children:  [ 
                                         TextSpan(text: "₹ ${plan["discount_plan_price_without_gst"]} " , style: const TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.w500, 
                                    fontFamily: "WORKSANSBOLD",
                                    color: Color.fromARGB(255, 80, 93, 126))) , 
                                         const TextSpan(text: "+ GST" , style: TextStyle(
                                           fontFamily: "WORKSANS",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                     color: Color.fromARGB(255, 80, 93, 126))) , 
                                         
                                         
                                    ])),
                                         const SizedBox(height: 10,), 
                                                     RichText(text: TextSpan(children: [ 
                                         TextSpan(text: "${plan["discount_percentage"]}% OFF " , style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500, 
                                    fontFamily: "WORKSANSBOLD",
                                    color: Color.fromARGB(255, 199, 164, 75))) , 
                                         TextSpan(text: "₹ ${plan["plan_price_without_gst"]}" , style: TextStyle(
                                           decoration: TextDecoration.lineThrough, 
                                         
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500, 
                                    fontFamily: "WORKSANSBOLD",
                                    color: const Color.fromARGB(255, 157, 126, 58).withOpacity(0.46))) , 
                                         
                                         // plan_amount_per_month
                                    ])),
                               const SizedBox(height: 10,),
                                  
                                 Padding(
                                           padding: const EdgeInsets.all(10.0),
                                           child: ElevatedButton.icon(
                                             style: ElevatedButton.styleFrom(
                                          
                                               elevation: 8, // Add elevation for shadow effect
                                               shadowColor: Colors.grey.withOpacity(0.5), // Color of the shadow
                                             ),
                                             onPressed: _paymentController.isPaymentInProgress.value
                                                ? null
                                                : () {
                                                    _paymentController.startPayment(); // Start payment
                                 
                                                    _premiumPlanController.selectedaddonPlanID.value =
                                                        plan["plan_id"];
                                                    var options = {
                                                    'key': '${_premiumPlanController.userRazorPayKey}',
                                                'amount': '${plan["discount_plan_price_with_gst"]}',
                                                'order_id': '${plan["razorpay_order_id"]}',
                                                'name': 'DMS',
                                                'description': 'Add On Contacts',
                                                   
                                                    };
                                                    _razorpay.open(options);
                                                  },
                                             icon: SizedBox(
                                               height: 20,
                                               child: Image.asset("assets/premium1.png"),
                                             ),
                                             label: const Padding(
                                               padding: EdgeInsets.all(8.0),
                                               child: Text(
                                         "Purchase Plan",
                                         style: CustomTextStyle.elevatedButton,
                                               ),
                                             ),
                                           ),
                                         ),
                                         
                                  // stargold
                                             Column(
                                               crossAxisAlignment: CrossAxisAlignment.start,
                                               children: [
                            Padding(
                                             padding: const EdgeInsets.symmetric(vertical: 8.0),
                                             child: RichText(
                                               textAlign: TextAlign.start,
                                               text: TextSpan(
                                                 children: [
                                                   WidgetSpan(
                            child: SizedBox(
                              height: 10, // Adjust icon size
                              width: 10, // Adjust icon size
                              child: Image.asset("assets/stargold.png"),
                            ),
                            alignment: PlaceholderAlignment.middle,
                                                   ),
                                                   TextSpan(
                            text: ' View Total',
                            style: CustomTextStyle.bodytext.copyWith(fontWeight: FontWeight.w500 , fontSize: 14)
                                                   ),
                              TextSpan(
                            text: ' ${plan["plan_contact"]} ',
                            style: CustomTextStyle.bodytext.copyWith(fontWeight: FontWeight.w600 , fontSize: 14)
                                                   ),
                              TextSpan(
                            text: ' Contact Numbers',
                            style: CustomTextStyle.bodytext.copyWith(fontWeight: FontWeight.w500 , fontSize: 14)
                                                   ),
                                                 ],
                                               ),
                                             ),
                                           ), 
                                            Padding(
                                             padding: const EdgeInsets.symmetric(vertical: 8.0),
                                             child: RichText(
                                               textAlign: TextAlign.start,
                                               text: TextSpan(
                                                 children: [
                                                   WidgetSpan(
                            child: SizedBox(
                              height: 10, // Adjust icon size
                              width: 10, // Adjust icon size
                              child: Image.asset("assets/stargold.png"),
                            ),
                            alignment: PlaceholderAlignment.middle,
                                                   ),
                                                   TextSpan(
                            text: ' Get Weekly',
                            style: CustomTextStyle.bodytext.copyWith(fontWeight: FontWeight.w500 , fontSize: 14)
                                                   ),
                              TextSpan(
                            text: ' ${plan["plan_weekly_contact_limit"]} ',
                            style: CustomTextStyle.bodytext.copyWith(fontWeight: FontWeight.w600 , fontSize: 14)
                                                   ),
                              TextSpan(
                            text: 'Contact Numbers',
                            style: CustomTextStyle.bodytext.copyWith(fontWeight: FontWeight.w500 , fontSize: 14)
                                                   ),
                                                 ],
                                               ),
                                             ),
                                           ), 
                                            Padding(
                                             padding: const EdgeInsets.symmetric(vertical: 8.0),
                                             child: RichText(
                                               textAlign: TextAlign.start,
                                               text: TextSpan(
                                                 children: [
                                                   WidgetSpan(
                            child: SizedBox(
                              height: 10, // Adjust icon size
                              width: 10, // Adjust icon size
                              child: Image.asset("assets/stargold.png"),
                            ),
                            alignment: PlaceholderAlignment.middle,
                                                   ),
                                                   TextSpan(
                            text: ' Explore Unlimited',
                            style: CustomTextStyle.bodytext.copyWith(fontWeight: FontWeight.w500 , fontSize: 14)
                                                   ),
                              TextSpan(
                            text: ' 100% ',
                            style: CustomTextStyle.bodytext.copyWith(fontWeight: FontWeight.w600 , fontSize: 14)
                                                   ),
                              TextSpan(
                            text: 'Jain Matches',
                            style: CustomTextStyle.bodytext.copyWith(fontWeight: FontWeight.w500 , fontSize: 14)
                                                   ),
                                                 ],
                                               ),
                                             ),
                                           ), 
                                           Padding(
                                             padding: const EdgeInsets.symmetric(vertical: 8.0),
                                             child: RichText(
                                               textAlign: TextAlign.start,
                                               text: TextSpan(
                                                 children: [
                                                   WidgetSpan(
                            child: SizedBox(
                              height: 10, // Adjust icon size
                              width: 10, // Adjust icon size
                              child: Image.asset("assets/stargold.png"),
                            ),
                            alignment: PlaceholderAlignment.middle,
                                                   ),
                                                
                              TextSpan(
                            text: ' Shortlist ',
                            style: CustomTextStyle.bodytext.copyWith(fontWeight: FontWeight.w600 , fontSize: 14)
                                                   ),
                              TextSpan(
                            text: 'Your Ideal Matches',
                            style: CustomTextStyle.bodytext.copyWith(fontWeight: FontWeight.w500 , fontSize: 14)
                                                   ),
                                                 ],
                                               ),
                                             ),
                                           ), 
                                            Padding(
                                             padding: const EdgeInsets.symmetric(vertical: 8.0),
                                             child: RichText(
                                               textAlign: TextAlign.start,
                                               text: TextSpan(
                                                 children: [
                                                   WidgetSpan(
                            child: SizedBox(
                              height: 10, // Adjust icon size
                              width: 10, // Adjust icon size
                              child: Image.asset("assets/stargold.png"),
                            ),
                            alignment: PlaceholderAlignment.middle,
                                                   ),
                                                
                              TextSpan(
                            text: ' Send Interest',
                            style: CustomTextStyle.bodytext.copyWith(fontWeight: FontWeight.w600 , fontSize: 14)
                                                   ),
                              TextSpan(
                            text: ' to Profiles You Like ',
                            style: CustomTextStyle.bodytext.copyWith(fontWeight: FontWeight.w500 , fontSize: 14)
                                                   ),
                                                 ],
                                               ),
                                             ),
                                           ), 
                                            Padding(
                                             padding: const EdgeInsets.symmetric(vertical: 8.0),
                                             child: RichText(
                                               textAlign: TextAlign.start,
                                               text: TextSpan(
                                                 children: [
                                                   WidgetSpan(
                            child: SizedBox(
                              height: 10, // Adjust icon size
                              width: 10, // Adjust icon size
                              child: Image.asset("assets/stargold.png"),
                            ),
                            alignment: PlaceholderAlignment.middle,
                                                   ),
                                                
                              TextSpan(
                            text: ' Enhanced Profile Visibility ',
                            style: CustomTextStyle.bodytext.copyWith(fontWeight: FontWeight.w500 , fontSize: 14)
                                                   ),
                                                 ],
                                               ),
                                             ),
                                           )
                                               ],), 
                                               const SizedBox(height: 20,),
                                         RichText(text: const TextSpan(children: <TextSpan>[
                                                   TextSpan( text: "*" , style: TextStyle(color: Colors.red))
                                 ,
                                                   TextSpan(text: " Offer valid for limited time Period " , style: CustomTextStyle.fieldName ) , 
                                                   TextSpan( text: "*" , style: TextStyle(color: Colors.red))
                                                  ])), 
                                  
                                  ],),
                                ),)
                             );
                         }, options: CarouselOptions(
                                                 
                              ) ,  ),*/

                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Text(
                                      textAlign: TextAlign.center,
                                      "Upgrade Now..!!!",
                                      style: CustomTextStyle.darkBlueHeading,
                                    ),
                                    const Text(
                                      textAlign: TextAlign.center,
                                      "Before Price Hikes Tomorrow!",
                                      style: CustomTextStyle.darkBlueHeading,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 28.0, right: 28.0),
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: const TextSpan(
                                          style: CustomTextStyle.bodytext,
                                          children: [
                                            TextSpan(
                                                text: "Take advantage of the "),
                                            TextSpan(
                                              text: "Offer Prices Above",
                                              style:
                                                  CustomTextStyle.bodytextbold,
                                            ),
                                            TextSpan(
                                                text:
                                                    ", Which is better than the regular plan price. Lock in the "),
                                            TextSpan(
                                              text: "Best Deal Today",
                                              style:
                                                  CustomTextStyle.bodytextbold,
                                            ),
                                            TextSpan(text: ", As "),
                                            TextSpan(
                                              text:
                                                  "as Prices are scheduled to rise tomorrow!",
                                              style:
                                                  CustomTextStyle.bodytextbold,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 20,
                                    ),

                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 25.0),
                                      child: SizedBox(
                                        height: 520,
                                        child: ListView.builder(
                                          controller: _scrollController2,
                                          itemCount: _premiumPlanController
                                              .planList.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            final plan = _premiumPlanController
                                                .planList[index];
                                            return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  height: 440,
                                                  width: 320,
                                                  decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.5), // Adjust the opacity as needed
                                                          spreadRadius:
                                                              2, // Controls how much the shadow spreads
                                                          blurRadius:
                                                              5, // Controls the blur effect
                                                          offset: const Offset(
                                                              3,
                                                              3), // Controls the position of the shadow (x, y)
                                                        ),
                                                      ],
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  10)),
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              245,
                                                              248,
                                                              250)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 18.0,
                                                            bottom: 10,
                                                            right: 18),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                            decoration: const BoxDecoration(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        216,
                                                                        170,
                                                                        53),
                                                                borderRadius: BorderRadius.only(
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            5),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            5))),
                                                            child:
                                                                const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                  "ORIGINAL PLAN",
                                                                  style: CustomTextStyle
                                                                      .elevatedButtonMedium),
                                                            )),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        RichText(
                                                            text: TextSpan(
                                                                children: [
                                                              TextSpan(
                                                                  text: "${plan["plan_name"]}"
                                                                      .toUpperCase(),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          30,
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          157,
                                                                          125,
                                                                          20))),
                                                            ])),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          "${plan["plan_duration_text"]}",
                                                          style: const TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  "WORKSANS",
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      80,
                                                                      93,
                                                                      126)),
                                                        ),
                                                        RichText(
                                                            text: TextSpan(
                                                                children: [
                                                              TextSpan(
                                                                  text:
                                                                      "₹ ${plan["plan_price_without_gst"]} ",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          35,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontFamily:
                                                                          "WORKSANSBOLD",
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          80,
                                                                          93,
                                                                          126))),
                                                              const TextSpan(
                                                                  text: "+ GST",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          "WORKSANS",
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          80,
                                                                          93,
                                                                          126))),
                                                            ])),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),

                                                        // stargold
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          8.0),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Image.asset(
                                                                    "assets/stargold.png",
                                                                    height:
                                                                        10, // Adjust icon size
                                                                    width:
                                                                        10, // Adjust icon size
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          8), // Add spacing between the icon and the text
                                                                  Expanded(
                                                                    child:
                                                                        RichText(
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      text:
                                                                          TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                                'View Total',
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                          TextSpan(
                                                                            text:
                                                                                ' ${plan["plan_contact"]} ',
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                          TextSpan(
                                                                            text:
                                                                                'Contact Numbers',
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          8.0),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Image.asset(
                                                                    "assets/stargold.png",
                                                                    height:
                                                                        10, // Adjust icon size
                                                                    width:
                                                                        10, // Adjust icon size
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          8), // Add spacing between the icon and the text
                                                                  Expanded(
                                                                    child:
                                                                        RichText(
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      text:
                                                                          TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                                'Get Weekly',
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                          TextSpan(
                                                                            text:
                                                                                ' ${plan["plan_weekly_contact_limit"]} ',
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                          TextSpan(
                                                                            text:
                                                                                'Contact Numbers',
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          8.0),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Image.asset(
                                                                    "assets/stargold.png",
                                                                    height:
                                                                        10, // Adjust icon size
                                                                    width:
                                                                        10, // Adjust icon size
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          8), // Add spacing between the icon and the text
                                                                  Expanded(
                                                                    child:
                                                                        RichText(
                                                                      maxLines:
                                                                          2,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      text:
                                                                          TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                                'Explore Unlimited ',
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                          TextSpan(
                                                                            text:
                                                                                '100% Jain Matches ',
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          8.0),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Image.asset(
                                                                    "assets/stargold.png",
                                                                    height:
                                                                        10, // Adjust icon size
                                                                    width:
                                                                        10, // Adjust icon size
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          8), // Add spacing between the icon and the text
                                                                  Expanded(
                                                                    child:
                                                                        RichText(
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      text:
                                                                          TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                                'Shortlist ',
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                          TextSpan(
                                                                            text:
                                                                                'Your Ideal Matches',
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          8.0),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Image.asset(
                                                                    "assets/stargold.png",
                                                                    height:
                                                                        10, // Adjust icon size
                                                                    width:
                                                                        10, // Adjust icon size
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          8), // Add spacing between the icon and the text
                                                                  Expanded(
                                                                    child:
                                                                        RichText(
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      text:
                                                                          TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                                'Send Interest',
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                          TextSpan(
                                                                            text:
                                                                                ' to Profiles You Like',
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          8.0),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Image.asset(
                                                                    "assets/stargold.png",
                                                                    height:
                                                                        10, // Adjust icon size
                                                                    width:
                                                                        10, // Adjust icon size
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          8), // Add spacing between the icon and the text
                                                                  Expanded(
                                                                    child:
                                                                        RichText(
                                                                      maxLines:
                                                                          2,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      text:
                                                                          TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                                'Enhanced ',
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                          TextSpan(
                                                                            text:
                                                                                'Profile Visibility ',
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        Container(
                                                          decoration: const BoxDecoration(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      216,
                                                                      170,
                                                                      53),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5))),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: RichText(
                                                                text: TextSpan(
                                                                    children: <TextSpan>[
                                                                  const TextSpan(
                                                                      text: "*",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          color:
                                                                              Colors.white)),
                                                                  TextSpan(
                                                                      text:
                                                                          "Note : ",
                                                                      style: CustomTextStyle.bodytextmd.copyWith(
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          color:
                                                                              Colors.white)),
                                                                  const TextSpan(
                                                                      text:
                                                                          "Compared to the regular plan price, the current offer is a great deal for you. Prices will increase tomorrow, so upgrade to a premium membership now and enjoy the best value! ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          color:
                                                                              Colors.white)),
                                                                ])),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ));
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Text(
                                      textAlign: TextAlign.center,
                                      "Why Become A Premium Member On 96 Kuli Maratha Marriage?",
                                      style: CustomTextStyle.darkBlueHeading,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ListView.builder(
                                      itemCount: whyMember.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        final why = whyMember[index];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 10),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const CircleAvatar(
                                                backgroundColor: Colors.black,
                                                radius: 4,
                                                //  child: Text("${index + 1}" , style: TextStyle(color: Colors.white , fontSize: 8),),
                                              ),
                                              const SizedBox(
                                                  width:
                                                      8), // Add space between the circle and text
                                              Expanded(
                                                child: Text(
                                                  why,
                                                  style: CustomTextStyle
                                                      .bodytextSmall,
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),

                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Center(
                                        child: Text(
                                      "FAQ",
                                      style: CustomTextStyle.darkBlueH2,
                                    )),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ListView.builder(
                                      itemCount: faqData.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        final faq = faqData[index];
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                    255, 215, 226, 242)
                                                .withOpacity(0.69),
                                            borderRadius: BorderRadius.circular(
                                                8), // Optional: to add rounded corners
                                          ),
                                          child: ExpansionTile(
                                            initiallyExpanded:
                                                index == 0 ? true : false,
                                            title: Text(faq.title,
                                                style: CustomTextStyle
                                                    .bodytextbold),
                                            trailing:
                                                const SizedBox(), // Removes the down arrow icon
                                            tilePadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 16.0),
                                            children: [
                                              Container(
                                                color: Colors.white,
                                                child: ListTile(
                                                  title: Text(
                                                    faq.subtitle,
                                                    style: CustomTextStyle
                                                        .bodytext,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
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
              );
            }
          },
        )),
      ),
    );
  }
}

class FAQModel {
  final String title;
  final String subtitle;

  FAQModel({required this.title, required this.subtitle});
}
