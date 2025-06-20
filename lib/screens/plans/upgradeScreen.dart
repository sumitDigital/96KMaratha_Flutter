// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:_96kuliapp/checkupdateFunctions.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/commons/dialogues/apidialogues/addonPLanDialogue.dart';
import 'package:_96kuliapp/commons/dialogues/apidialogues/upgradePlanDialogue.dart';
import 'package:_96kuliapp/commons/dialogues/logoutDialogoue.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/ExploreApController/exploreAppController.dart';
import 'package:_96kuliapp/controllers/planControllers/premiumPlanController.dart';
import 'package:_96kuliapp/controllers/razorpayController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/exploreAppScreens/exploreAppAfterLogin/Explorerecentvisitorsafterlogin.dart';
import 'package:_96kuliapp/screens/exploreAppScreens/exploreAppAfterLogin/exploreAppAfterLogin.dart';
import 'package:_96kuliapp/screens/exploreAppScreens/plansBGSheet.dart';
import 'package:_96kuliapp/screens/profile_screens/user_details.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/appDrawer.dart';
import 'package:_96kuliapp/utils/backHeader.dart';
import 'package:_96kuliapp/utils/bottomnavBar.dart';
import 'package:_96kuliapp/utils/formHeader.dart';
import 'package:_96kuliapp/utils/formtitletag.dart';
import 'package:_96kuliapp/utils/verificationTag.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class CarouselSyncController extends GetxController {
  var currentIndex = 0.obs;

  void updateIndex(int index) {
    currentIndex.value = index;
  }
}

class PaymentPremiumController extends GetxController {
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

class UpgradePlan extends StatefulWidget {
  const UpgradePlan({super.key});

  @override
  State<UpgradePlan> createState() => _UpgradePlanState();
}

class _UpgradePlanState extends State<UpgradePlan>
    with SingleTickerProviderStateMixin {
  final PremiumPlanController _premiumPlanController =
      Get.put(PremiumPlanController());
  final PaymentPremiumController _paymentController =
      Get.put(PaymentPremiumController());
  final ExploreAppController _exploreAppController =
      Get.put(ExploreAppController());

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  // final CarouselSyncController _carsouleController = Get.put(CarouselSyncController());
  late ScrollController _scrollController1;
  late ScrollController _scrollController2;
  final facebookAppEvents = FacebookAppEvents();

  final Razorpay _razorpay = Razorpay();
  late AnimationController _controller;
  late Animation<double> _animation;
  final GlobalKey _keyTarget = GlobalKey();
  final GlobalKey _keyTargetBasic = GlobalKey();

  final ScrollController _scrollControllerPlan = ScrollController();
  final ScrollController _scrollControllerBasicPlan = ScrollController();

  String? language = sharedPreferences?.getString("Language");

  void _scrollToTarget() {
    final RenderObject? renderObject =
        _keyTarget.currentContext?.findRenderObject();
    if (renderObject is RenderBox) {
      final offset = renderObject.localToGlobal(Offset.zero).dy +
          _scrollControllerPlan.offset;
      _scrollControllerPlan.animateTo(
        offset,
        duration: const Duration(seconds: 1),
        curve: Curves.decelerate,
      );
    }
  }

  void _scrollToTargetBasicPlan() {
    final RenderObject? renderObject =
        _keyTargetBasic.currentContext?.findRenderObject();
    if (renderObject is RenderBox) {
      final offset = renderObject.localToGlobal(Offset.zero).dy +
          _scrollControllerBasicPlan.offset;
      _scrollControllerBasicPlan.animateTo(
        offset,
        duration: const Duration(seconds: 1),
        curve: Curves.decelerate,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  _razorpaycontroller.fetchUserInfo();
    // _premiumPlanController.fetchPlans();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _exploreAppController.fetchRecommendedMatchesListAfterLogin();

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
    facebookAppEvents.logEvent(
        name: "Fb_96k_app_plan_purchase_successfully",
        parameters: {
          'PlanID': '${_premiumPlanController.selectedaddonPlanID.value}'
        });
    analytics.logEvent(name: "app_96k_plan_purchase_successfully", parameters: {
      'PlanID': '${_premiumPlanController.selectedaddonPlanID.value}'
    });
    print("Payment purchase_successfully: ${response.paymentId}");
    facebookAppEvents.logPurchase(
        amount: _premiumPlanController.planPrice.value, currency: "INR");
    analytics.logPurchase();
    _premiumPlanController.sendPaymentDataUpgradePlan(
      addonPlanID: _premiumPlanController.selectedaddonPlanID.value,
      orderID: response.orderId.toString(),
      paymentID: response.paymentId.toString(),
      signature: response.signature.toString(),
      discountID: response.discountId.toString(),
      conditionID: response.conditionId!,
    );
    // Reset the flag after payment is processed

    _paymentController.resetPaymentState();

/*
  Future.delayed(const Duration(milliseconds: 500), () {
    Get.dialog(const UpgradePlanDialogue(), barrierDismissible: false);
  });*/
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("THIS IS PLAN PRICE ${_premiumPlanController.planPrice.value}");
    print("Payment failed: ${response.message}");
    //  facebookAppEvents.logPurchase(amount: _premiumPlanController.planPrice.value, currency: "INR");

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
    "Trustworthy profiles to ensure you find a genuine match.",
    "Your Personal Information Is Protected At Every Step.",
    "Discover advanced filtering options for better matches.",
    "Easily instant contact with your selected matches.",
    "As a Premium member, your profile receives priority listing.",
    "Save time and find quality matches.",
    "Note: Premium plan will not be refunded for any reason after purchase.",
  ];

  List<FAQModel> faqData = [
    FAQModel(
        title: "Is my payment secure?",
        subtitle:
            "Yes, your payment is completely secure. All transactions are processed through encrypted payment gateways."),
    FAQModel(
        title: "What should I do if my payment fails?",
        subtitle:
            "In case your payment fails, do not worry. You can attempt the payment again using another payment method. Ensure that your internet connection is stable and that your card has sufficient balance. If the issue persists, feel free to contact our customer support team for further help and guidance."),
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
    Future<void> openEmail(String email) async {
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: email,
      );

      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        throw 'Could not launch $emailUri';
      }
    }

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
                textAlign: TextAlign.center,
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
                        child: Text(AppLocalizations.of(context)!.yes,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
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
                        child: Text(AppLocalizations.of(context)!.no,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
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
        body: Obx(() {
          if (_premiumPlanController.loadingplans.value) {
            return SafeArea(
                child: Center(
              child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FormsTitleTag(
                        pageName: "regularPlanPage",
                        title:
                            language == "en" ? "Upgrade PLan" : "प्लॅन निवडा",
                        arrowback: false,
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
            ));
          } else {
            if (_premiumPlanController.planListOffer.isNotEmpty) {
              return SafeArea(
                  child: _premiumPlanController.loadingplans.value
                      ? Center(
                          child: Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FormsTitleTag(
                                    pageName: "regularPlanPage",
                                    title: language == "en"
                                        ? "Upgrade PLan"
                                        : "प्लॅन निवडा",
                                    arrowback: false,
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
                        )
                      : RefreshIndicator(
                          onRefresh: () {
                            return Future(() {
                              _premiumPlanController.fetchPlans();
                            });
                          },
                          child: SingleChildScrollView(
                            controller: _scrollControllerPlan,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FormsTitleTag(
                                  pageName: "regularPlanPage",
                                  title: language == "en"
                                      ? "Upgrade PLan"
                                      : "प्लॅन निवडा",
                                  arrowback: false,
                                ),
                                Stack(
                                  children: [
                                    Container(
                                        child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: SizedBox(
                                              width: 162,
                                              height: 26,
                                              child: Image.asset(
                                                  "assets/offerplanhead.png")),
                                        ),
                                        // SizedBox(height: 550, width: double.infinity, child: Image.network(_premiumPlanController.planBGimg.value , fit: BoxFit.cover,),),
                                        SizedBox(
                                          height: 700,
                                          width: double.infinity,
                                          child: Image.asset(
                                            "assets/offerplanbg1.png",
                                            fit: BoxFit.cover,
                                          ),
                                        ),

                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                //  SizedBox(height: 26, child: Image.asset("assets/offerplanhead.png"),),
                                                Transform(
                                                  transform: Matrix4.skewX(
                                                      0.2), // Slant towards left
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft: Radius.circular(
                                                            0), // Adjust as needed
                                                        bottomRight:
                                                            Radius.circular(0),
                                                      ),
                                                      color: Color.fromRGBO(
                                                          255,
                                                          193,
                                                          22,
                                                          1), // Background color
                                                    ),
                                                    child: Transform(
                                                      transform: Matrix4.skewX(
                                                          -0.2), // Reverse skew to keep text straight
                                                      child: Text(
                                                        language == "en"
                                                            ? "Grab this exciting offer today!"
                                                            : "सर्व प्रीमियम प्लॅन्स वर",
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily:
                                                              "WORKSANSMEDIUM",
                                                          fontSize: 18,
                                                          color: Color.fromRGBO(
                                                              9,
                                                              39,
                                                              73,
                                                              1), // Text color
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    // height: 150,
                                                    width: double.infinity,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20.0),
                                                      child: Image.network(
                                                          fit: BoxFit.fitHeight,
                                                          language == "en"
                                                              ? "${Appconstants.baseURL}/public/storage/planImage/${_premiumPlanController.planListOffer[0]["discount_data"]["discount_image"]}"
                                                              : "${Appconstants.baseURL}/public/storage/planImage/${_premiumPlanController.planListOffer[0]["discount_data_mr"]["discount_image"]}"),
                                                    )),
                                                // const Padding(
                                                //   padding: EdgeInsets.symmetric(
                                                //       vertical: 8.0,
                                                //       horizontal: 28),
                                                //   child: Text(
                                                //     textAlign: TextAlign.center,
                                                //     "१ दिवसाची लग्नसराई ऑफर",
                                                //     style: TextStyle(
                                                //         color: Colors.white,
                                                //         fontSize: 41,
                                                //         fontWeight:
                                                //             FontWeight.w700),
                                                //   ),
                                                // ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(9.0),
                                                  child: Text(
                                                    textAlign: TextAlign.center,
                                                    language == "en"
                                                        ? "${_premiumPlanController.planListOffer[0]["discount_data"]["discount_heading"]}"
                                                        : "${_premiumPlanController.planListOffer[0]["discount_data_mr"]["discount_heading"]}",
                                                    // "अनुरूप मुलींची स्थळे बघण्यासाठी प्रीमियम सदस्य व्हा !!",
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 21,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),

                                                _premiumPlanController
                                                                    .planListOffer[0]
                                                                [
                                                                "Plan_End_Date_Time"] !=
                                                            "0000-00-00 00:00:00" ||
                                                        _premiumPlanController
                                                                    .planListOffer[0]
                                                                [
                                                                "Plan_End_Date_Time"] !=
                                                            null
                                                    ? PlanTimer(
                                                        key: _keyTarget,
                                                        onPage: "UpgradePlan2",
                                                        premiumPlanController:
                                                            _premiumPlanController,
                                                        animation: _animation,
                                                      )
                                                    : const SizedBox(),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15.0,
                                                          right: 15),
                                                  child: SizedBox(
                                                    height: 550,
                                                    child: ListView.builder(
                                                      controller:
                                                          _scrollController1,
                                                      itemCount:
                                                          _premiumPlanController
                                                              .planListOffer
                                                              .length,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemBuilder:
                                                          (context, index) {
                                                        print(
                                                            "THIS IS PLAN LIST ${Appconstants.baseURL}${_premiumPlanController.planListOffer[0]["discount_data"]["discount_image"]}");
                                                        final plan =
                                                            _premiumPlanController
                                                                    .planListOffer[
                                                                index];
                                                        return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Container(
                                                              width: 320,
                                                              // height: 500,
                                                              decoration: BoxDecoration(
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .grey
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
                                                                  color: Colors
                                                                      .white),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            18.0,
                                                                        bottom:
                                                                            10,
                                                                        right:
                                                                            10,
                                                                        top: 0),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Container(
                                                                          decoration: const BoxDecoration(
                                                                              // rgba(9, 39, 73, 1)
                                                                              color: Color.fromRGBO(9, 39, 73, 1)),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Text(
                                                                              "${plan["plan_popularity"] ?? ""}",
                                                                              style: const TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 10,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    RichText(
                                                                      text: TextSpan(
                                                                          children: [
                                                                            TextSpan(
                                                                              text: language == "en" ? (plan["discount_data"]["discount_name"]?.toString().toUpperCase() ?? "") : (plan["discount_data_mr"]["discount_name"]?.toString().toUpperCase() ?? ""),
                                                                              // text:
                                                                              //     "शुभमंगल",
                                                                              style: const TextStyle(
                                                                                fontSize: 45,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontFamily: "WORKSANSBOLD",
                                                                                // rgba(251, 160, 24, 1)
                                                                                color: Color.fromRGBO(251, 160, 24, 1),
                                                                              ),
                                                                            ),
                                                                          ]),
                                                                    ),
                                                                    Text(
                                                                      " ${language == 'en' ? 'Plan Validity :' : "प्लॅनचा कालावधी :"} ${plan["plan_duration_text"]}",
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontFamily:
                                                                              "WORKSANS",
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              80,
                                                                              93,
                                                                              126)),
                                                                    ),
                                                                    RichText(
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      text: TextSpan(
                                                                          children: [
                                                                            TextSpan(
                                                                                text: "₹ ${double.parse(plan["discount_price_without_gst"]).toInt()} ",
                                                                                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w500, fontFamily: "WORKSANSBOLD", color: Color.fromARGB(255, 80, 93, 126))),
                                                                            plan["show_gst"] == true
                                                                                ? const TextSpan(text: "+ GST", style: TextStyle(fontFamily: "WORKSANS", fontSize: 18, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 80, 93, 126)))
                                                                                : const TextSpan(text: "", style: TextStyle(fontFamily: "WORKSANS", fontSize: 18, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 80, 93, 126))),
                                                                          ]),
                                                                    ),
                                                                    language ==
                                                                            "en"
                                                                        ? Text(
                                                                            "Rs. ${double.parse(plan["plan_price_without_gst"].toString()).toInt()} /-",
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 22,
                                                                              fontWeight: FontWeight.w800,
                                                                              decoration: TextDecoration.lineThrough, // This is required to show the line above the text
                                                                              decorationColor: Color.fromRGBO(204, 40, 77, 0.62),
                                                                              decorationStyle: TextDecorationStyle.solid, // This applies the dashed effect
                                                                              color: Color.fromRGBO(204, 40, 77, 0.62),
                                                                            ),
                                                                          )
                                                                        : Text(
                                                                            "रु. ${double.parse(plan["plan_price_without_gst"].toString()).toInt()} /-",
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 22,
                                                                              fontWeight: FontWeight.w800,
                                                                              decoration: TextDecoration.lineThrough, // This is required to show the line above the text
                                                                              decorationColor: Color.fromRGBO(204, 40, 77, 0.62),
                                                                              decorationStyle: TextDecorationStyle.solid, // This applies the dashed effect
                                                                              color: Color.fromRGBO(204, 40, 77, 0.62),
                                                                            ),
                                                                          ),
                                                                    const SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    language ==
                                                                            "en"
                                                                        ? RichText(
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            text:
                                                                                TextSpan(children: [
                                                                              TextSpan(
                                                                                text: "₹ ${plan["plan_price_without_gst"] != null && plan["discount_price_without_gst"] != null ? (double.parse(plan["plan_price_without_gst"].toString()).toInt() ?? 0.0) - (double.parse(plan["discount_price_without_gst"].toString()).toInt() ?? 0.0) : 0.0}",
                                                                                style: const TextStyle(
                                                                                  fontSize: 14,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontFamily: "WORKSANSBOLD",
                                                                                  // rgba(109, 119, 132, 1)
                                                                                  // color: Color.fromRGBO(109, 119, 132, 1),
                                                                                  color: Color.fromRGBO(251, 160, 24, 1),
                                                                                ),
                                                                              ),
                                                                              TextSpan(
                                                                                text: language != "en" ? " पर्यंत बचत करा !!" : " Off just for you !!",
                                                                                style: const TextStyle(
                                                                                  fontSize: 14,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontFamily: "WORKSANSBOLD",
                                                                                  // rgba(109, 119, 132, 1)
                                                                                  color: Color.fromRGBO(109, 119, 132, 1),
                                                                                ),
                                                                              ),

                                                                              // plan_amount_per_month
                                                                            ]),
                                                                          )
                                                                        : RichText(
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            text:
                                                                                TextSpan(children: [
                                                                              TextSpan(
                                                                                text: "₹ ${plan["plan_price_without_gst"] != null && plan["discount_price_without_gst"] != null ? (double.parse(plan["plan_price_without_gst"].toString()).toInt() ?? 0.0) - (double.parse(plan["discount_price_without_gst"].toString()).toInt() ?? 0.0) : 0.0}",
                                                                                style: const TextStyle(
                                                                                  fontSize: 16,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontFamily: "WORKSANSBOLD",
                                                                                  // rgba(109, 119, 132, 1)
                                                                                  // color: Color.fromRGBO(109, 119, 132, 1),
                                                                                  color: Color.fromRGBO(251, 160, 24, 1),
                                                                                ),
                                                                              ),
                                                                              TextSpan(
                                                                                text: language != "en" ? " पर्यंत बचत करा !!" : " off just for you !!",
                                                                                style: const TextStyle(
                                                                                  fontSize: 16,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontFamily: "WORKSANSBOLD",
                                                                                  // rgba(109, 119, 132, 1)
                                                                                  color: Color.fromRGBO(109, 119, 132, 1),
                                                                                ),
                                                                              ),
                                                                              // plan_amount_per_month
                                                                            ]),
                                                                          ),
                                                                    Obx(
                                                                      () {
                                                                        return Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 8,
                                                                              vertical: 8.0),
                                                                          child:
                                                                              ElevatedButton.icon(
                                                                            style:
                                                                                ElevatedButton.styleFrom(
                                                                              elevation: 8, // Add elevation for shadow effect
                                                                              shadowColor: Colors.grey.withOpacity(0.5), // Color of the shadow
                                                                            ),
                                                                            onPressed: _paymentController.isPaymentInProgress.value
                                                                                ? null
                                                                                : () {
                                                                                    analytics.logEvent(name: "Purchase_Plan_Button_click");
                                                                                    facebookAppEvents.logEvent(name: "Fb_96k_Purchase_Plan_Button_click");
                                                                                    _paymentController.startPayment(); // Start payment

                                                                                    String discountPlanPrice = plan["plan_price_with_gst"];
                                                                                    double planPriceAsDouble = double.parse(discountPlanPrice);

                                                                                    // Assign it to your controller
                                                                                    _premiumPlanController.planPrice.value = planPriceAsDouble;

                                                                                    _premiumPlanController.selectedaddonPlanID.value = plan["plan_id"];
                                                                                    var options = {
                                                                                      'key': '${_premiumPlanController.userRazorPayKey}',
                                                                                      'amount': '${plan["discount_plan_price_with_gst"]}',
                                                                                      'order_id': '${plan["razorpay_order_id"]}',
                                                                                      'name': '96 Kuli Maratha Marriage',
                                                                                      'description': 'Premium Plan',
                                                                                    };
                                                                                    _razorpay.open(options);
                                                                                  },
                                                                            icon:
                                                                                SizedBox(
                                                                              height: 20,
                                                                              child: Image.asset("assets/premium1.png"),
                                                                            ),
                                                                            label:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Text(
                                                                                AppLocalizations.of(context)!.purchasePlan,
                                                                                style: CustomTextStyle.elevatedButton.copyWith(fontSize: 18, fontWeight: FontWeight.w700),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              5.0,
                                                                          vertical:
                                                                              5.0),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Html(
                                                                              data: plan["fechar_data"]),

                                                                          // Padding(
                                                                          //   padding: const EdgeInsets
                                                                          //       .symmetric(
                                                                          //       vertical: 8.0),
                                                                          //   child:
                                                                          //       Row(
                                                                          //     crossAxisAlignment:
                                                                          //         CrossAxisAlignment.center,
                                                                          //     children: [
                                                                          //       Image.asset(
                                                                          //         "assets/stargold.png",
                                                                          //         height: 10, // Adjust icon size
                                                                          //         width: 10, // Adjust icon size
                                                                          //       ),
                                                                          //       const SizedBox(width: 8), // Add spacing between the icon and the text
                                                                          //       Expanded(
                                                                          //         child: RichText(
                                                                          //           textAlign: TextAlign.start,
                                                                          //           text: TextSpan(
                                                                          //             children: [
                                                                          //               // rgba(9, 39, 73, 1)
                                                                          //               TextSpan(
                                                                          //                 text: 'वेरिफाइड प्रोफाईल्सचे ',
                                                                          //                 style: CustomTextStyle.bodytext.copyWith(fontSize: 14, color: const Color.fromRGBO(9, 39, 73, 1)),
                                                                          //               ),
                                                                          //               TextSpan(
                                                                          //                 text: ' मोबाईल नंबर',
                                                                          //                 style: CustomTextStyle.bodytext.copyWith(fontWeight: FontWeight.bold, fontFamily: "WORKSANSBOLD", fontSize: 14, color: const Color.fromRGBO(9, 39, 73, 1)),
                                                                          //               ),
                                                                          //               TextSpan(
                                                                          //                 text: ' मिळवा',
                                                                          //                 style: CustomTextStyle.bodytext.copyWith(fontSize: 14, color: const Color.fromRGBO(9, 39, 73, 1)),
                                                                          //               ),
                                                                          //             ],
                                                                          //           ),
                                                                          //         ),
                                                                          //       ),
                                                                          //     ],
                                                                          //   ),
                                                                          // ),
                                                                          // Padding(
                                                                          //   padding: const EdgeInsets
                                                                          //       .symmetric(
                                                                          //       vertical: 8.0),
                                                                          //   child:
                                                                          //       Row(
                                                                          //     crossAxisAlignment:
                                                                          //         CrossAxisAlignment.center,
                                                                          //     children: [
                                                                          //       Image.asset(
                                                                          //         "assets/stargold.png",
                                                                          //         height: 10, // Adjust icon size
                                                                          //         width: 10, // Adjust icon size
                                                                          //       ),
                                                                          //       const SizedBox(width: 8), // Add spacing between the icon and the text
                                                                          //       Expanded(
                                                                          //         child: RichText(
                                                                          //           textAlign: TextAlign.start,
                                                                          //           text: TextSpan(
                                                                          //             children: [
                                                                          //               // rgba(9, 39, 73, 1)
                                                                          //               TextSpan(
                                                                          //                 text: 'पसंत स्थळांना ',
                                                                          //                 style: CustomTextStyle.bodytext.copyWith(fontSize: 14, color: const Color.fromRGBO(9, 39, 73, 1)),
                                                                          //               ),
                                                                          //               TextSpan(
                                                                          //                 text: ' इंटरेस्ट ',
                                                                          //                 style: CustomTextStyle.bodytext.copyWith(fontWeight: FontWeight.bold, fontFamily: "WORKSANSBOLD", fontSize: 14, color: const Color.fromRGBO(9, 39, 73, 1)),
                                                                          //               ),
                                                                          //               TextSpan(
                                                                          //                 text: 'पाठवण्याची सोय',
                                                                          //                 style: CustomTextStyle.bodytext.copyWith(fontSize: 14, color: const Color.fromRGBO(9, 39, 73, 1)),
                                                                          //               ),
                                                                          //             ],
                                                                          //           ),
                                                                          //         ),
                                                                          //       ),
                                                                          //     ],
                                                                          //   ),
                                                                          // ),
                                                                          // Padding(
                                                                          //   padding: const EdgeInsets
                                                                          //       .symmetric(
                                                                          //       vertical: 8.0),
                                                                          //   child:
                                                                          //       Row(
                                                                          //     crossAxisAlignment:
                                                                          //         CrossAxisAlignment.center,
                                                                          //     children: [
                                                                          //       Image.asset(
                                                                          //         "assets/stargold.png",
                                                                          //         height: 10, // Adjust icon size
                                                                          //         width: 10, // Adjust icon size
                                                                          //       ),
                                                                          //       const SizedBox(width: 8), // Add spacing between the icon and the text
                                                                          //       Expanded(
                                                                          //         child: RichText(
                                                                          //           textAlign: TextAlign.start,
                                                                          //           text: TextSpan(
                                                                          //             children: [
                                                                          //               // rgba(9, 39, 73, 1)
                                                                          //               TextSpan(
                                                                          //                 text: 'मनपसंत अमर्यादित स्थळांसोबत',
                                                                          //                 style: CustomTextStyle.bodytext.copyWith(fontSize: 14, color: const Color.fromRGBO(9, 39, 73, 1)),
                                                                          //               ),
                                                                          //               TextSpan(
                                                                          //                 text: '  गुणमिलन',
                                                                          //                 style: CustomTextStyle.bodytext.copyWith(fontWeight: FontWeight.bold, fontFamily: "WORKSANSBOLD", fontSize: 14, color: const Color.fromRGBO(9, 39, 73, 1)),
                                                                          //               ),
                                                                          //               TextSpan(
                                                                          //                 text: ' बघण्याची सोय',
                                                                          //                 style: CustomTextStyle.bodytext.copyWith(fontSize: 14, color: const Color.fromRGBO(9, 39, 73, 1)),
                                                                          //               ),
                                                                          //             ],
                                                                          //           ),
                                                                          //         ),
                                                                          //       ),
                                                                          //     ],
                                                                          //   ),
                                                                          // ),
                                                                          // Padding(
                                                                          //   padding: const EdgeInsets
                                                                          //       .symmetric(
                                                                          //       vertical: 8.0),
                                                                          //   child:
                                                                          //       Row(
                                                                          //     crossAxisAlignment:
                                                                          //         CrossAxisAlignment.center,
                                                                          //     children: [
                                                                          //       Image.asset(
                                                                          //         "assets/stargold.png",
                                                                          //         height: 10, // Adjust icon size
                                                                          //         width: 10, // Adjust icon size
                                                                          //       ),
                                                                          //       const SizedBox(width: 8), // Add spacing between the icon and the text
                                                                          //       Expanded(
                                                                          //         child: RichText(
                                                                          //           textAlign: TextAlign.start,
                                                                          //           text: TextSpan(
                                                                          //             children: [
                                                                          //               // rgba(9, 39, 73, 1)

                                                                          //               TextSpan(
                                                                          //                 text: ' अमर्यादित स्थळे ',
                                                                          //                 style: CustomTextStyle.bodytext.copyWith(fontWeight: FontWeight.bold, fontFamily: "WORKSANSBOLD", fontSize: 14, color: const Color.fromRGBO(9, 39, 73, 1)),
                                                                          //               ),
                                                                          //               TextSpan(
                                                                          //                 text: 'बघण्याची सोय',
                                                                          //                 style: CustomTextStyle.bodytext.copyWith(fontSize: 14, color: const Color.fromRGBO(9, 39, 73, 1)),
                                                                          //               ),
                                                                          //             ],
                                                                          //           ),
                                                                          //         ),
                                                                          //       ),
                                                                          //     ],
                                                                          //   ),
                                                                          // ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    RichText(
                                                                        text: TextSpan(
                                                                            children: <TextSpan>[
                                                                          const TextSpan(
                                                                              text: "*",
                                                                              style: TextStyle(color: Colors.red)),
                                                                          TextSpan(
                                                                              text: language == "en" ? " Offer valid for limited time Period " : "ऑफर मर्यादित कालावधीसाठी",
                                                                              style: CustomTextStyle.fieldName.copyWith(color: AppTheme.primaryColor)),
                                                                          const TextSpan(
                                                                              text: "*",
                                                                              style: TextStyle(color: Colors.red))
                                                                        ])),
                                                                  ],
                                                                ),
                                                              ),
                                                            ));
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 30,
                                                ),

                                                // const SizedBox(
                                                //   height: 40,
                                                // ),
                                                Obx(
                                                  () {
                                                    if (_premiumPlanController
                                                        .showExploreList
                                                        .value) {
                                                      print(
                                                          "check plan value ${_premiumPlanController.showExploreList.value}");
                                                      return Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            language == "en"
                                                                ? "Discover What Awaits You!"
                                                                : "सर्वोत्तम स्थळ शोधण्याची हीच योग्य वेळ!",
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  "WORKSANS",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 20,
                                                              // rgba(80, 93, 126, 1)
                                                              color: Color
                                                                  .fromARGB(
                                                                255,
                                                                80,
                                                                93,
                                                                126,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        26.0),
                                                            child: Text(
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                language == "en"
                                                                    ? "Unlock & check out profiles that suit your expectations."
                                                                    : "तुमच्यासाठी अनुरूप असलेल्या सर्व  प्रोफाईल्स बघा.",
                                                                style: CustomTextStyle
                                                                    .bodytext),
                                                          ),
                                                          const SizedBox(
                                                            height: 30,
                                                          ),
                                                          Obx(() {
                                                            if (_exploreAppController
                                                                .recommendedmatchesListfetching
                                                                .value) {
                                                              return SizedBox(
                                                                height: 320,
                                                                child: ListView
                                                                    .builder(
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  itemCount: 8,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return Shimmer
                                                                        .fromColors(
                                                                      baseColor:
                                                                          Colors
                                                                              .grey[300]!,
                                                                      highlightColor:
                                                                          Colors
                                                                              .grey[100]!,
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            4.0),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              200,
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(10)),
                                                                            color:
                                                                                Colors.white, // Placeholder color
                                                                          ),
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              Flexible(
                                                                                flex: 6,
                                                                                child: Container(
                                                                                  decoration: const BoxDecoration(
                                                                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                                                                    color: Colors.white, // Placeholder color
                                                                                  ),
                                                                                  width: 200,
                                                                                  child: ClipRRect(
                                                                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                                                                    child: Container(
                                                                                      color: Colors.grey[300], // Placeholder color for image
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Flexible(
                                                                                flex: 5,
                                                                                child: Container(
                                                                                  width: 300,
                                                                                  decoration: const BoxDecoration(
                                                                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                                                                    color: Color.fromARGB(255, 235, 237, 239),
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Container(
                                                                                          height: 15,
                                                                                          color: Colors.grey[300], // Placeholder for text
                                                                                        ),
                                                                                        const SizedBox(height: 5),
                                                                                        Container(
                                                                                          height: 12,
                                                                                          color: Colors.grey[300], // Placeholder for text
                                                                                        ),
                                                                                        const SizedBox(height: 5),
                                                                                        Row(
                                                                                          children: [
                                                                                            Container(
                                                                                              height: 12,
                                                                                              width: 60,
                                                                                              color: Colors.grey[300], // Placeholder for text
                                                                                            ),
                                                                                            const SizedBox(width: 4),
                                                                                            Container(
                                                                                              width: 1.0,
                                                                                              height: 12.0,
                                                                                              color: const Color.fromARGB(255, 80, 93, 126), // Color of the separator
                                                                                            ),
                                                                                            const SizedBox(width: 4),
                                                                                            Container(
                                                                                              height: 12,
                                                                                              width: 80,
                                                                                              color: Colors.grey[300], // Placeholder for text
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        const SizedBox(height: 5),
                                                                                        Container(
                                                                                          height: 12,
                                                                                          color: Colors.grey[300], // Placeholder for text
                                                                                        ),
                                                                                        const SizedBox(height: 5),
                                                                                        Row(
                                                                                          children: [
                                                                                            Container(
                                                                                              height: 12,
                                                                                              width: 100,
                                                                                              color: Colors.grey[300], // Placeholder for text
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              );
                                                            } else {
                                                              if (_exploreAppController
                                                                  .recommendedmatchesList
                                                                  .isEmpty) {
                                                                return const SizedBox();
                                                              } else {
                                                                return Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          18.0,
                                                                      vertical:
                                                                          8),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      SizedBox(
                                                                        height:
                                                                            350, // Specify a fixed height for the ListView
                                                                        child: ListView
                                                                            .builder(
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          itemCount: _exploreAppController.recommendedmatchesList.length > 5
                                                                              ? 6
                                                                              : _exploreAppController.recommendedmatchesList.length,
                                                                          itemBuilder:
                                                                              (context, index) {
                                                                            //    print("Match is ${match}");
                                                                            if (_exploreAppController.recommendedmatchesList.length >
                                                                                5) {
                                                                              final FilterList = _exploreAppController.recommendedmatchesList.sublist(0, 6);

                                                                              if (index < FilterList.length - 1) {
                                                                                final match = FilterList[index];
                                                                                return Padding(
                                                                                  padding: const EdgeInsets.all(4.0),
                                                                                  child: GestureDetector(
                                                                                    onTap: () async {
                                                                                      try {
                                                                                        print('Checking for Update');
                                                                                        AppUpdateInfo info = await InAppUpdate.checkForUpdate();

                                                                                        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
                                                                                          print('Update available');
                                                                                          await update();
                                                                                        } else {
                                                                                          print('No update available');
                                                                                          // _dashboardController.onItemTapped(value);\
                                                                                          AddVisitedByMeList(MemberID: match["member_id"]);
                                                                                          _scrollToTarget();
                                                                                        }
                                                                                      } catch (e) {
                                                                                        print('Error checking for update: ${e.toString()}');
                                                                                        AddVisitedByMeList(MemberID: match["member_id"]);
                                                                                        _scrollToTarget();
                                                                                      }
                                                                                    },
                                                                                    child: Container(
                                                                                      width: 200,
                                                                                      decoration: const BoxDecoration(
                                                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                      ),
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        children: [
                                                                                          Flexible(
                                                                                            flex: 5,
                                                                                            child: Container(
                                                                                              decoration: const BoxDecoration(
                                                                                                borderRadius: BorderRadius.only(
                                                                                                  topLeft: Radius.circular(10),
                                                                                                  topRight: Radius.circular(10),
                                                                                                ),
                                                                                              ),
                                                                                              width: 200,
                                                                                              child: ClipRRect(
                                                                                                borderRadius: const BorderRadius.only(
                                                                                                  topLeft: Radius.circular(10),
                                                                                                  topRight: Radius.circular(10),
                                                                                                ),
                                                                                                child: Image.network(
                                                                                                  alignment: Alignment.topCenter,
                                                                                                  match['photoUrl'] ?? "${Appconstants.baseURL}/public/storage/images/download.png",
                                                                                                  fit: BoxFit.cover,
                                                                                                  width: double.infinity,
                                                                                                  height: double.infinity,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Flexible(
                                                                                            flex: 3,
                                                                                            child: Container(
                                                                                              width: 300,
                                                                                              decoration: const BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)), color: Colors.white),
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsets.all(8.0),
                                                                                                child: Column(
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children: [
                                                                                                    const SizedBox(
                                                                                                      height: 5,
                                                                                                    ),
                                                                                                    Center(
                                                                                                      child: Row(
                                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        children: [
                                                                                                          Text(
                                                                                                            /* Member ID :  */ "${match["member_profile_id"]}",
                                                                                                            style: CustomTextStyle.bodytextbold,
                                                                                                          ),
                                                                                                          match["is_Document_Verification"] == 1
                                                                                                              ? Padding(
                                                                                                                  padding: const EdgeInsets.only(left: 4.0, top: 4),
                                                                                                                  child: SizedBox(
                                                                                                                    height: 13,
                                                                                                                    width: 13,
                                                                                                                    child: Image.asset("assets/verified.png"),
                                                                                                                  ),
                                                                                                                )
                                                                                                              : const SizedBox()
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                    const Spacer(),
                                                                                                    Center(
                                                                                                      child: Text(
                                                                                                        "${match["age"]} Yrs, ${match["height"]},",
                                                                                                        overflow: TextOverflow.ellipsis,
                                                                                                        style: CustomTextStyle.bodytext.copyWith(fontSize: 12),
                                                                                                      ),
                                                                                                    ),
                                                                                                    Center(
                                                                                                      child: Text(
                                                                                                        "${match["present_city_name"]}, ${match["marital_status"]}",
                                                                                                        overflow: TextOverflow.ellipsis,
                                                                                                        style: CustomTextStyle.bodytext.copyWith(fontSize: 12),
                                                                                                      ),
                                                                                                    ),
                                                                                                    Center(
                                                                                                      child: Text(
                                                                                                        "${match["education"]}",
                                                                                                        overflow: TextOverflow.ellipsis,
                                                                                                        style: CustomTextStyle.bodytext.copyWith(fontSize: 12),
                                                                                                      ),
                                                                                                    ),
                                                                                                    const SizedBox(height: 10),
                                                                                                    Row(
                                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      children: [
                                                                                                        Image.asset(height: 14, "assets/heartoutlined.png"),
                                                                                                        const SizedBox(width: 5),
                                                                                                        Text(
                                                                                                          language == "en" ? "Connect Now" : "इंटरेस्ट पाठवा",
                                                                                                          style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w600),
                                                                                                        )
                                                                                                      ],
                                                                                                    )
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              } else {
                                                                                final match = FilterList[index];

                                                                                return Padding(
                                                                                  padding: const EdgeInsets.all(4.0),
                                                                                  child: GestureDetector(
                                                                                    onTap: () async {
                                                                                      try {
                                                                                        print('Checking for Update');
                                                                                        AppUpdateInfo info = await InAppUpdate.checkForUpdate();

                                                                                        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
                                                                                          print('Update available');
                                                                                          await update();
                                                                                        } else {
                                                                                          print('No update available');

                                                                                          AddVisitedByMeList(MemberID: match["member_id"]);
                                                                                          navigatorKey.currentState!.push(
                                                                                            MaterialPageRoute(builder: (context) => const ExploreAppAfterLogin()),
                                                                                          );
                                                                                        }
                                                                                      } catch (e) {
                                                                                        print('Error checking for update: ${e.toString()}');
                                                                                        AddVisitedByMeList(MemberID: match["member_id"]);
                                                                                        navigatorKey.currentState!.push(
                                                                                          MaterialPageRoute(builder: (context) => const ExploreAppAfterLogin()),
                                                                                        );
                                                                                      }
                                                                                    },
                                                                                    child: Stack(
                                                                                      children: [
                                                                                        Container(
                                                                                          width: 200,
                                                                                          decoration: const BoxDecoration(
                                                                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                          ),
                                                                                          child: Column(
                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                            children: [
                                                                                              Flexible(
                                                                                                flex: 5,
                                                                                                child: Container(
                                                                                                  decoration: const BoxDecoration(
                                                                                                    borderRadius: BorderRadius.only(
                                                                                                      topLeft: Radius.circular(10),
                                                                                                      topRight: Radius.circular(10),
                                                                                                    ),
                                                                                                  ),
                                                                                                  width: 200,
                                                                                                  child: ClipRRect(
                                                                                                    borderRadius: const BorderRadius.only(
                                                                                                      topLeft: Radius.circular(10),
                                                                                                      topRight: Radius.circular(10),
                                                                                                    ),
                                                                                                    child: Image.network(
                                                                                                      alignment: Alignment.topCenter,
                                                                                                      match['photoUrl'] ?? "${Appconstants.baseURL}/public/storage/images/download.png",
                                                                                                      fit: BoxFit.cover,
                                                                                                      width: double.infinity,
                                                                                                      height: double.infinity,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              Flexible(
                                                                                                flex: 3,
                                                                                                child: Container(
                                                                                                  width: 300,
                                                                                                  decoration: const BoxDecoration(
                                                                                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                                                                                    color: Color.fromARGB(255, 235, 237, 239),
                                                                                                  ),
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                                    child: Column(
                                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                      children: [
                                                                                                        const SizedBox(
                                                                                                          height: 5,
                                                                                                        ),
                                                                                                        Center(
                                                                                                          child: Row(
                                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                            children: [
                                                                                                              Text(
                                                                                                                "${match["member_profile_id"]}",
                                                                                                                style: CustomTextStyle.bodytextbold,
                                                                                                              ),
                                                                                                              match["is_Document_Verification"] == 1
                                                                                                                  ? Padding(
                                                                                                                      padding: const EdgeInsets.only(left: 4.0, top: 4),
                                                                                                                      child: SizedBox(
                                                                                                                        height: 13,
                                                                                                                        width: 13,
                                                                                                                        child: Image.asset("assets/verified.png"),
                                                                                                                      ),
                                                                                                                    )
                                                                                                                  : const SizedBox()
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                        const Spacer(),
                                                                                                        Center(
                                                                                                          child: Text(
                                                                                                            "${match["age"]} Yrs, ${match["height"]},",
                                                                                                            overflow: TextOverflow.ellipsis,
                                                                                                            style: CustomTextStyle.bodytext.copyWith(fontSize: 12),
                                                                                                          ),
                                                                                                        ),
                                                                                                        Center(
                                                                                                          child: Text(
                                                                                                            "${match["present_city_name"]}, ${match["marital_status"]}",
                                                                                                            overflow: TextOverflow.ellipsis,
                                                                                                            style: CustomTextStyle.bodytext.copyWith(fontSize: 12),
                                                                                                          ),
                                                                                                        ),
                                                                                                        Center(
                                                                                                          child: Text(
                                                                                                            "${match["education"]}",
                                                                                                            overflow: TextOverflow.ellipsis,
                                                                                                            style: CustomTextStyle.bodytext.copyWith(fontSize: 12),
                                                                                                          ),
                                                                                                        ),
                                                                                                        const SizedBox(height: 10),
                                                                                                        Row(
                                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                                          children: [
                                                                                                            Image.asset(height: 14, "assets/heartoutlined.png"),
                                                                                                            const SizedBox(width: 5),
                                                                                                            Text(
                                                                                                              language == "en" ? "Connect Now" : "इंटरेस्ट पाठवा",
                                                                                                              style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w600),
                                                                                                            )
                                                                                                          ],
                                                                                                        )
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        // Full overlay
                                                                                        Positioned.fill(
                                                                                          child: Container(
                                                                                              decoration: BoxDecoration(
                                                                                                color: Colors.black.withOpacity(0.7), // Dark overlay with opacity
                                                                                                borderRadius: BorderRadius.circular(10),
                                                                                              ),
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsets.all(18.0),
                                                                                                child: Column(
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  children: [
                                                                                                    const SizedBox(
                                                                                                      height: 20,
                                                                                                    ),
                                                                                                    Center(
                                                                                                      child: Text(
                                                                                                        textAlign: TextAlign.center,
                                                                                                        language == "en" ? "Discover more profiles to find your match!!" : "1000 पेक्षा जास्त प्रोफाईल्स तुमची वाट बघत आहेत.",
                                                                                                        style: CustomTextStyle.bodytextbold.copyWith(
                                                                                                          color: Colors.white,
                                                                                                          fontSize: 16,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                    Center(
                                                                                                      child: Text(
                                                                                                        textAlign: TextAlign.center,
                                                                                                        language == "en" ? "View All!!" : 'सर्व प्रोफाईल्स बघा',
                                                                                                        style: CustomTextStyle.bodytextbold.copyWith(
                                                                                                          color: const Color.fromRGBO(255, 231, 18, 1),
                                                                                                          fontSize: 16,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              )),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              }
                                                                            } else {
                                                                              final match = _exploreAppController.recommendedmatchesList[index];

                                                                              return Padding(
                                                                                padding: const EdgeInsets.all(4.0),
                                                                                child: GestureDetector(
                                                                                  onTap: () async {
                                                                                    try {
                                                                                      print('Checking for Update');
                                                                                      AppUpdateInfo info = await InAppUpdate.checkForUpdate();

                                                                                      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
                                                                                        print('Update available');
                                                                                        await update();
                                                                                      } else {
                                                                                        print('No update available');
                                                                                        // _dashboardController.onItemTapped(value);
                                                                                        _scrollToTarget();

                                                                                        AddVisitedByMeList(MemberID: match["member_id"]);
                                                                                      }
                                                                                    } catch (e) {
                                                                                      print('Error checking for update: ${e.toString()}');
                                                                                      _scrollToTarget();
                                                                                      AddVisitedByMeList(MemberID: match["member_id"]);
                                                                                    }
                                                                                  },
                                                                                  child: Container(
                                                                                    width: 200,
                                                                                    decoration: const BoxDecoration(
                                                                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                    ),
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        Flexible(
                                                                                          flex: 5,
                                                                                          child: Container(
                                                                                            decoration: const BoxDecoration(
                                                                                              borderRadius: BorderRadius.only(
                                                                                                topLeft: Radius.circular(10),
                                                                                                topRight: Radius.circular(10),
                                                                                              ),
                                                                                            ),
                                                                                            width: 200,
                                                                                            child: ClipRRect(
                                                                                              borderRadius: const BorderRadius.only(
                                                                                                topLeft: Radius.circular(10),
                                                                                                topRight: Radius.circular(10),
                                                                                              ),
                                                                                              child: Image.network(
                                                                                                match['photoUrl'] ?? "${Appconstants.baseURL}/public/storage/images/download.png",
                                                                                                fit: BoxFit.cover,
                                                                                                width: double.infinity,
                                                                                                height: double.infinity,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        Flexible(
                                                                                          flex: 3,
                                                                                          child: Container(
                                                                                            width: 300,
                                                                                            decoration: const BoxDecoration(
                                                                                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                                                                              color: Color.fromARGB(255, 235, 237, 239),
                                                                                            ),
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(8.0),
                                                                                              child: Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  const SizedBox(
                                                                                                    height: 5,
                                                                                                  ),
                                                                                                  Center(
                                                                                                    child: Row(
                                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          "${match["member_profile_id"]}",
                                                                                                          style: CustomTextStyle.bodytextbold,
                                                                                                        ),
                                                                                                        match["is_Document_Verification"] == 1
                                                                                                            ? Padding(
                                                                                                                padding: const EdgeInsets.only(left: 4.0, top: 4),
                                                                                                                child: SizedBox(
                                                                                                                  height: 13,
                                                                                                                  width: 13,
                                                                                                                  child: Image.asset("assets/verified.png"),
                                                                                                                ),
                                                                                                              )
                                                                                                            : const SizedBox()
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                  const Spacer(),
                                                                                                  Center(
                                                                                                    child: Text(
                                                                                                      "${match["age"]} Yrs, ${match["height"]},",
                                                                                                      overflow: TextOverflow.ellipsis,
                                                                                                      style: CustomTextStyle.bodytext.copyWith(fontSize: 12),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Center(
                                                                                                    child: Text(
                                                                                                      "${match["present_city_name"]}, ${match["marital_status"]}",
                                                                                                      overflow: TextOverflow.ellipsis,
                                                                                                      style: CustomTextStyle.bodytext.copyWith(fontSize: 12),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Center(
                                                                                                    child: Text(
                                                                                                      "${match["education"]}",
                                                                                                      overflow: TextOverflow.ellipsis,
                                                                                                      style: CustomTextStyle.bodytext.copyWith(fontSize: 12),
                                                                                                    ),
                                                                                                  ),
                                                                                                  const SizedBox(height: 10),
                                                                                                  Row(
                                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [
                                                                                                      Image.asset(height: 14, "assets/heartoutlined.png"),
                                                                                                      const SizedBox(width: 5),
                                                                                                      Text(
                                                                                                        language == "en" ? "Connect Now" : "इंटरेस्ट पाठवा",
                                                                                                        style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w600),
                                                                                                      )
                                                                                                    ],
                                                                                                  )
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            }
                                                                          },
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                );
                                                              }
                                                            }
                                                          }),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          Center(
                                                            child:
                                                                ElevatedButton(
                                                              onPressed: () {
                                                                analytics.logEvent(
                                                                    name:
                                                                        "Plan_Page_Explore_App_Button_Click");
                                                                facebookAppEvents
                                                                    .logEvent(
                                                                        name:
                                                                            "FB_Plan_Page_Explore_App_Button_Click");
                                                                navigatorKey
                                                                    .currentState!
                                                                    .push(
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              const ExploreAppAfterLogin()),
                                                                );
                                                              },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                elevation: 5,
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        48,
                                                                    vertical:
                                                                        18), // Horizontal padding inside the button
                                                                shape:
                                                                    const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10)), // Rectangular shape
                                                                ),
                                                              ),
                                                              child: Text(
                                                                language == "en"
                                                                    ? "Explore Profiles"
                                                                    : "एक्सप्लोर प्रोफाईल्स",
                                                                style: CustomTextStyle
                                                                    .elevatedButton,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                        ],
                                                      );
                                                    } else {
                                                      return const SizedBox();
                                                    }
                                                  },
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 28.0),
                                                  child: Text(
                                                    textAlign: TextAlign.center,
                                                    language == "en"
                                                        ? "All Premium Plan Features Plus More Exclusive Benefits"
                                                        : "सर्व सुविधांसोबतच प्रीमियम प्लॅनच्या अजून काही विशेष सुविधा ",
                                                    style: const TextStyle(
                                                      fontFamily: "WORKSANS",
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 20,
                                                      //rgba(9, 39, 73, 1)
                                                      // rgba(80, 93, 126, 1)
                                                      color: Color.fromARGB(
                                                          255, 80, 93, 126),
                                                      // Color.fromARGB(
                                                      //     255, 9, 39, 73)
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 28.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 8.0),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const CircleAvatar(
                                                              radius: 3,
                                                              // rgba(204, 40, 77, 1)
                                                              backgroundColor:
                                                                  Color
                                                                      .fromRGBO(
                                                                          204,
                                                                          40,
                                                                          77,
                                                                          1),
                                                            ),
                                                            const SizedBox(
                                                                width:
                                                                    8), // Add spacing between the icon and the text
                                                            Expanded(
                                                              child: RichText(
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                text: TextSpan(
                                                                  children: [
                                                                    // rgba(9, 39, 73, 1)
                                                                    TextSpan(
                                                                      text: language ==
                                                                              "en"
                                                                          ? "Shortlist"
                                                                          : 'पसंत असलेल्या स्थळांना',
                                                                      style: CustomTextStyle
                                                                          .bodytext
                                                                          .copyWith(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight: language ==
                                                                                "en"
                                                                            ? FontWeight.bold
                                                                            : FontWeight.w400,
                                                                        color: const Color
                                                                            .fromARGB(
                                                                          255,
                                                                          80,
                                                                          93,
                                                                          126,
                                                                        ),
                                                                        // const Color
                                                                        //     .fromRGBO(
                                                                        //     9,
                                                                        //     39,
                                                                        //     73,
                                                                        //     1)
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text: language ==
                                                                              "en"
                                                                          ? ""
                                                                          : ' शॉर्टलिस्ट',
                                                                      style: CustomTextStyle
                                                                          .bodytext
                                                                          .copyWith(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontFamily:
                                                                            "WORKSANSBOLD",
                                                                        fontSize:
                                                                            14,
                                                                        color: const Color
                                                                            .fromARGB(
                                                                          255,
                                                                          80,
                                                                          93,
                                                                          126,
                                                                        ),
                                                                        //  const Color
                                                                        //     .fromRGBO(
                                                                        //     9,
                                                                        //     39,
                                                                        //     73,
                                                                        //     1)
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text: language ==
                                                                              "en"
                                                                          ? " your favorite profiles"
                                                                          : ' करण्याची सोय',
                                                                      style: CustomTextStyle
                                                                          .bodytext
                                                                          .copyWith(
                                                                        fontSize:
                                                                            14,
                                                                        color: const Color
                                                                            .fromARGB(
                                                                          255,
                                                                          80,
                                                                          93,
                                                                          126,
                                                                        ),
                                                                        // const Color
                                                                        //     .fromRGBO(
                                                                        //     9,
                                                                        //     39,
                                                                        //     73,
                                                                        //     1)
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
                                                                vertical: 8.0),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const CircleAvatar(
                                                              radius: 3,
                                                              // rgba(204, 40, 77, 1)
                                                              backgroundColor:
                                                                  Color
                                                                      .fromRGBO(
                                                                          204,
                                                                          40,
                                                                          77,
                                                                          1),
                                                            ),
                                                            const SizedBox(
                                                                width:
                                                                    8), // Add spacing between the icon and the text
                                                            Expanded(
                                                              child: RichText(
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                text: TextSpan(
                                                                  children: [
                                                                    // rgba(9, 39, 73, 1)
                                                                    TextSpan(
                                                                      text: language ==
                                                                              "en"
                                                                          ? "Discover"
                                                                          : '१००% अमर्यादित',
                                                                      style: CustomTextStyle
                                                                          .bodytext
                                                                          .copyWith(
                                                                        fontSize:
                                                                            14,
                                                                        color: const Color
                                                                            .fromARGB(
                                                                          255,
                                                                          80,
                                                                          93,
                                                                          126,
                                                                        ),
                                                                        // const Color
                                                                        //     .fromRGBO(
                                                                        //     9,
                                                                        //     39,
                                                                        //     73,
                                                                        //     1)
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text: language ==
                                                                              "en"
                                                                          ? " advanced filtering"
                                                                          : ' मराठा प्रोफाईल्स',
                                                                      style: CustomTextStyle
                                                                          .bodytext
                                                                          .copyWith(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontFamily:
                                                                            "WORKSANSBOLD",
                                                                        fontSize:
                                                                            14,
                                                                        color: const Color
                                                                            .fromARGB(
                                                                          255,
                                                                          80,
                                                                          93,
                                                                          126,
                                                                        ),
                                                                        // const Color
                                                                        //     .fromRGBO(
                                                                        //     9,
                                                                        //     39,
                                                                        //     73,
                                                                        //     1)
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text: language ==
                                                                              "en"
                                                                          ? " options for better matches"
                                                                          : ' एक्सप्लोर करा',
                                                                      style: CustomTextStyle
                                                                          .bodytext
                                                                          .copyWith(
                                                                        fontSize:
                                                                            14,
                                                                        color: const Color
                                                                            .fromARGB(
                                                                          255,
                                                                          80,
                                                                          93,
                                                                          126,
                                                                        ),
                                                                        // const Color
                                                                        //     .fromRGBO(
                                                                        //     9,
                                                                        //     39,
                                                                        //     73,
                                                                        //     1)
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      // Padding(
                                                      //   padding: const EdgeInsets
                                                      //       .symmetric(
                                                      //       vertical: 8.0),
                                                      //   child: Row(
                                                      //     crossAxisAlignment:
                                                      //         CrossAxisAlignment
                                                      //             .center,
                                                      //     children: [
                                                      //       const CircleAvatar(
                                                      //         radius: 3,
                                                      //         // rgba(204, 40, 77, 1)
                                                      //         backgroundColor:
                                                      //             Color.fromRGBO(
                                                      //                 204,
                                                      //                 40,
                                                      //                 77,
                                                      //                 1),
                                                      //       ),
                                                      //       const SizedBox(
                                                      //           width:
                                                      //               8), // Add spacing between the icon and the text
                                                      //       Expanded(
                                                      //         child: RichText(
                                                      //           textAlign:
                                                      //               TextAlign
                                                      //                   .start,
                                                      //           text: TextSpan(
                                                      //             children: [
                                                      //               // rgba(9, 39, 73, 1)
                                                      //               TextSpan(
                                                      //                 text:
                                                      //                     'अमर्यादित ',
                                                      //                 style: CustomTextStyle.bodytext.copyWith(
                                                      //                     fontSize:
                                                      //                         14,
                                                      //                     color: const Color
                                                      //                         .fromRGBO(
                                                      //                         9,
                                                      //                         39,
                                                      //                         73,
                                                      //                         1)),
                                                      //               ),
                                                      //               TextSpan(
                                                      //                 text:
                                                      //                     ' उच्च शिक्षित व सामान्य स्थळ',
                                                      //                 style: CustomTextStyle.bodytext.copyWith(
                                                      //                     fontWeight:
                                                      //                         FontWeight
                                                      //                             .bold,
                                                      //                     fontFamily:
                                                      //                         "WORKSANSBOLD",
                                                      //                     fontSize:
                                                      //                         14,
                                                      //                     color: const Color
                                                      //                         .fromRGBO(
                                                      //                         9,
                                                      //                         39,
                                                      //                         73,
                                                      //                         1)),
                                                      //               ),
                                                      //               TextSpan(
                                                      //                 text:
                                                      //                     ' मिळवण्याची सोय',
                                                      //                 style: CustomTextStyle.bodytext.copyWith(
                                                      //                     fontSize:
                                                      //                         14,
                                                      //                     color: const Color
                                                      //                         .fromRGBO(
                                                      //                         9,
                                                      //                         39,
                                                      //                         73,
                                                      //                         1)),
                                                      //               ),
                                                      //             ],
                                                      //           ),
                                                      //         ),
                                                      //       ),
                                                      //     ],
                                                      //   ),
                                                      // ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 8.0),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const CircleAvatar(
                                                              radius: 3,
                                                              // rgba(204, 40, 77, 1)
                                                              backgroundColor:
                                                                  Color
                                                                      .fromRGBO(
                                                                          204,
                                                                          40,
                                                                          77,
                                                                          1),
                                                            ),
                                                            const SizedBox(
                                                                width:
                                                                    8), // Add spacing between the icon and the text
                                                            Expanded(
                                                              child: RichText(
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                text: TextSpan(
                                                                  children: [
                                                                    // rgba(9, 39, 73, 1)
                                                                    TextSpan(
                                                                      text: language ==
                                                                              "en"
                                                                          ? "Find the right match using "
                                                                          : 'शहर, वय शिक्षण, नोकरी, मंगळ इ. पर्यायांना वापरून ',
                                                                      style: CustomTextStyle
                                                                          .bodytext
                                                                          .copyWith(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        color: const Color
                                                                            .fromARGB(
                                                                          255,
                                                                          80,
                                                                          93,
                                                                          126,
                                                                        ),
                                                                        // const Color
                                                                        //     .fromRGBO(
                                                                        //     9,
                                                                        //     39,
                                                                        //     73,
                                                                        //     1)
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text: language ==
                                                                              "en"
                                                                          ? "Advanced search options "
                                                                          : 'अपेक्षित स्थळ',
                                                                      style: CustomTextStyle
                                                                          .bodytext
                                                                          .copyWith(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontFamily:
                                                                            "WORKSANSBOLD",
                                                                        fontSize:
                                                                            14,
                                                                        color: const Color
                                                                            .fromARGB(
                                                                          255,
                                                                          80,
                                                                          93,
                                                                          126,
                                                                        ),
                                                                        // const Color
                                                                        //     .fromRGBO(
                                                                        //     9,
                                                                        //     39,
                                                                        //     73,
                                                                        //     1)
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text: language ==
                                                                              "en"
                                                                          ? ""
                                                                          : ' निवडण्याची सोय',
                                                                      style: CustomTextStyle
                                                                          .bodytext
                                                                          .copyWith(
                                                                        fontSize:
                                                                            14,
                                                                        color: const Color
                                                                            .fromARGB(
                                                                          255,
                                                                          80,
                                                                          93,
                                                                          126,
                                                                        ),
                                                                        // const Color
                                                                        //     .fromRGBO(
                                                                        //     9,
                                                                        //     39,
                                                                        //     73,
                                                                        //     1)
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      // Padding(
                                                      //   padding: const EdgeInsets
                                                      //       .symmetric(
                                                      //       vertical: 8.0),
                                                      //   child: Row(
                                                      //     crossAxisAlignment:
                                                      //         CrossAxisAlignment
                                                      //             .center,
                                                      //     children: [
                                                      //       const CircleAvatar(
                                                      //         radius: 3,
                                                      //         // rgba(204, 40, 77, 1)
                                                      //         backgroundColor:
                                                      //             Color.fromRGBO(
                                                      //                 204,
                                                      //                 40,
                                                      //                 77,
                                                      //                 1),
                                                      //       ),
                                                      //       const SizedBox(
                                                      //           width:
                                                      //               8), // Add spacing between the icon and the text
                                                      //       Expanded(
                                                      //         child: RichText(
                                                      //           textAlign:
                                                      //               TextAlign
                                                      //                   .start,
                                                      //           text: TextSpan(
                                                      //             children: [
                                                      //               // rgba(9, 39, 73, 1)
                                                      //               TextSpan(
                                                      //                 text:
                                                      //                     'प्रतिनिधी तर्फे फोनवरून ',
                                                      //                 style: CustomTextStyle.bodytext.copyWith(
                                                      //                     fontSize:
                                                      //                         14,
                                                      //                     color: const Color
                                                      //                         .fromRGBO(
                                                      //                         9,
                                                      //                         39,
                                                      //                         73,
                                                      //                         1)),
                                                      //               ),
                                                      //               TextSpan(
                                                      //                 text:
                                                      //                     ' अपेक्षित मदत ',
                                                      //                 style: CustomTextStyle.bodytext.copyWith(
                                                      //                     fontWeight:
                                                      //                         FontWeight
                                                      //                             .bold,
                                                      //                     fontFamily:
                                                      //                         "WORKSANSBOLD",
                                                      //                     fontSize:
                                                      //                         14,
                                                      //                     color: const Color
                                                      //                         .fromRGBO(
                                                      //                         9,
                                                      //                         39,
                                                      //                         73,
                                                      //                         1)),
                                                      //               ),
                                                      //               TextSpan(
                                                      //                 text:
                                                      //                     ' मिळवण्याची सोय',
                                                      //                 style: CustomTextStyle.bodytext.copyWith(
                                                      //                     fontSize:
                                                      //                         14,
                                                      //                     color: const Color
                                                      //                         .fromRGBO(
                                                      //                         9,
                                                      //                         39,
                                                      //                         73,
                                                      //                         1)),
                                                      //               ),
                                                      //             ],
                                                      //           ),
                                                      //         ),
                                                      //       ),
                                                      //     ],
                                                      //   ),
                                                      // ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 8.0),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const CircleAvatar(
                                                              radius: 3,
                                                              // rgba(204, 40, 77, 1)
                                                              backgroundColor:
                                                                  Color
                                                                      .fromRGBO(
                                                                          204,
                                                                          40,
                                                                          77,
                                                                          1),
                                                            ),
                                                            const SizedBox(
                                                                width:
                                                                    8), // Add spacing between the icon and the text
                                                            Expanded(
                                                              child: RichText(
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                text: TextSpan(
                                                                  children: [
                                                                    // rgba(9, 39, 73, 1)
                                                                    TextSpan(
                                                                      text: language ==
                                                                              "en"
                                                                          ? "Receive "
                                                                          : 'ई-मेलद्वारे ',
                                                                      style: CustomTextStyle
                                                                          .bodytext
                                                                          .copyWith(
                                                                        fontSize:
                                                                            14,

                                                                        color: const Color
                                                                            .fromARGB(
                                                                          255,
                                                                          80,
                                                                          93,
                                                                          126,
                                                                        ),
                                                                        // const Color
                                                                        //     .fromRGBO(
                                                                        //     9,
                                                                        //     39,
                                                                        //     73,
                                                                        //     1)
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text: language ==
                                                                              "en"
                                                                          ? "free messages"
                                                                          : 'मोफत संदेश ',
                                                                      style: CustomTextStyle
                                                                          .bodytext
                                                                          .copyWith(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontFamily:
                                                                            "WORKSANSBOLD",
                                                                        fontSize:
                                                                            14,
                                                                        color: const Color
                                                                            .fromARGB(
                                                                          255,
                                                                          80,
                                                                          93,
                                                                          126,
                                                                        ),
                                                                        // const Color
                                                                        //     .fromRGBO(
                                                                        //     9,
                                                                        //     39,
                                                                        //     73,
                                                                        //     1)
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text: language ==
                                                                              "en"
                                                                          ? " via email"
                                                                          : 'मिळवण्याची सोय',
                                                                      style: CustomTextStyle
                                                                          .bodytext
                                                                          .copyWith(
                                                                        fontSize:
                                                                            14,
                                                                        color:
                                                                            // const Color
                                                                            //     .fromRGBO(
                                                                            //     9,
                                                                            //     39,
                                                                            //     73,
                                                                            //     1)
                                                                            const Color.fromARGB(
                                                                          255,
                                                                          80,
                                                                          93,
                                                                          126,
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

                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 8.0),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const CircleAvatar(
                                                              radius: 3,
                                                              backgroundColor:
                                                                  Color
                                                                      .fromRGBO(
                                                                          204,
                                                                          40,
                                                                          77,
                                                                          1),
                                                            ),
                                                            const SizedBox(
                                                                width: 8),
                                                            Expanded(
                                                              child: RichText(
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      text: language ==
                                                                              "en"
                                                                          ? "Once paid, the fee "
                                                                          : 'एकदा दिलेली ',
                                                                      style: CustomTextStyle
                                                                          .bodytext
                                                                          .copyWith(
                                                                        fontSize:
                                                                            14,
                                                                        color: const Color
                                                                            .fromARGB(
                                                                          255,
                                                                          80,
                                                                          93,
                                                                          126,
                                                                        ),
                                                                        // const Color
                                                                        //     .fromRGBO(
                                                                        //     9,
                                                                        //     39,
                                                                        //     73,
                                                                        //     1)
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text: language ==
                                                                              "en"
                                                                          ? "cannot be refunded."
                                                                          : ' फी परत केली जाणार नाही',
                                                                      style: CustomTextStyle
                                                                          .bodytext
                                                                          .copyWith(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontFamily:
                                                                            "WORKSANSBOLD",
                                                                        fontSize:
                                                                            14,
                                                                        color: const Color
                                                                            .fromARGB(
                                                                          255,
                                                                          80,
                                                                          93,
                                                                          126,
                                                                        ),
                                                                        // const Color
                                                                        //     .fromRGBO(
                                                                        //     9,
                                                                        //     39,
                                                                        //     73,
                                                                        //     1)
                                                                      ),
                                                                    ),
                                                                    // TextSpan(
                                                                    //   text:
                                                                    //       ' मिळवण्याची सोय',
                                                                    //   style: CustomTextStyle.bodytext.copyWith(
                                                                    //       fontSize:
                                                                    //           14,
                                                                    //       color: const Color
                                                                    //           .fromRGBO(
                                                                    //           9,
                                                                    //           39,
                                                                    //           73,
                                                                    //           1)),
                                                                    // ),
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
                                                                vertical: 8.0),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const CircleAvatar(
                                                              radius: 3,
                                                              // rgba(204, 40, 77, 1)
                                                              backgroundColor:
                                                                  Color
                                                                      .fromRGBO(
                                                                          204,
                                                                          40,
                                                                          77,
                                                                          1),
                                                            ),
                                                            const SizedBox(
                                                                width:
                                                                    8), // Add spacing between the icon and the text
                                                            Expanded(
                                                              child: RichText(
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                text: TextSpan(
                                                                  children: [
                                                                    // rgba(9, 39, 73, 1)
                                                                    TextSpan(
                                                                      text: language ==
                                                                              "en"
                                                                          ? "Only profiles from the "
                                                                          : 'फक्त',
                                                                      style: CustomTextStyle
                                                                          .bodytext
                                                                          .copyWith(
                                                                        fontSize:
                                                                            14,
                                                                        color: const Color
                                                                            .fromARGB(
                                                                          255,
                                                                          80,
                                                                          93,
                                                                          126,
                                                                        ),
                                                                        // const Color
                                                                        //     .fromRGBO(
                                                                        //     9,
                                                                        //     39,
                                                                        //     73,
                                                                        //     1)
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text: language ==
                                                                              "en"
                                                                          ? "Maratha community "
                                                                          : ' मराठा समाजातील',
                                                                      style: CustomTextStyle
                                                                          .bodytext
                                                                          .copyWith(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontFamily:
                                                                            "WORKSANSBOLD",
                                                                        fontSize:
                                                                            14,
                                                                        color: const Color
                                                                            .fromARGB(
                                                                          255,
                                                                          80,
                                                                          93,
                                                                          126,
                                                                        ),
                                                                        //  const Color
                                                                        //     .fromRGBO(
                                                                        //     9,
                                                                        //     39,
                                                                        //     73,
                                                                        //     1)
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text: language ==
                                                                              "en"
                                                                          ? "are accepted; others will be blocked"
                                                                          : ' प्रोफाईल्स स्वीकारल्या जातील अन्यथा प्रोफाईल',
                                                                      style: CustomTextStyle
                                                                          .bodytext
                                                                          .copyWith(
                                                                        fontSize:
                                                                            14,
                                                                        color: const Color
                                                                            .fromARGB(
                                                                          255,
                                                                          80,
                                                                          93,
                                                                          126,
                                                                        ),
                                                                        // const Color
                                                                        //     .fromRGBO(
                                                                        //     9,
                                                                        //     39,
                                                                        //     73,
                                                                        //     1)
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text: language ==
                                                                              "en"
                                                                          ? ""
                                                                          : ' ब्लॉक',
                                                                      style: CustomTextStyle
                                                                          .bodytext
                                                                          .copyWith(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontFamily:
                                                                            "WORKSANSBOLD",
                                                                        fontSize:
                                                                            14,
                                                                        color: const Color
                                                                            .fromARGB(
                                                                          255,
                                                                          80,
                                                                          93,
                                                                          126,
                                                                        ),
                                                                        //  const Color
                                                                        //     .fromRGBO(
                                                                        //     9,
                                                                        //     39,
                                                                        //     73,
                                                                        //     1)
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text: language ==
                                                                              "en"
                                                                          ? ""
                                                                          : ' केली जाईल',
                                                                      style: CustomTextStyle
                                                                          .bodytext
                                                                          .copyWith(
                                                                        fontSize:
                                                                            14,
                                                                        color: const Color
                                                                            .fromARGB(
                                                                          255,
                                                                          80,
                                                                          93,
                                                                          126,
                                                                        ),
                                                                        // const Color
                                                                        //     .fromRGBO(
                                                                        //     9,
                                                                        //     39,
                                                                        //     73,
                                                                        //     1)
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
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ))
                                  ],
                                ),
                                language == "en"
                                    ? Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              text:
                                                  "Need assistance? Reach out at ",
                                              style: CustomTextStyle.bodytext
                                                  .copyWith(
                                                letterSpacing: 0.5,
                                                height:
                                                    1.5, // Adjust height for spacing
                                              ),
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "info@96kulimarathamarriage.com",
                                                  style: TextStyle(
                                                    color:
                                                        AppTheme.primaryColor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    height:
                                                        1.5, // Ensure the same line height applies here
                                                  ),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          openEmail(
                                                              "info@96kulimarathamarriage.com");
                                                        },
                                                ),
                                                TextSpan(
                                                  text:
                                                      "\nSupport time: 10 am to 6 pm",
                                                  style: CustomTextStyle
                                                      .bodytext
                                                      .copyWith(
                                                    letterSpacing: 0.5,
                                                    height:
                                                        1.5, // Adjust height for spacing
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              text:
                                                  "मदतीसाठी दिलेल्या ई-मेल वर संपर्क करा",
                                              style: CustomTextStyle.bodytext
                                                  .copyWith(
                                                height:
                                                    1.5, // Adjust height for spacing
                                              ),
                                              children: [
                                                TextSpan(
                                                  text:
                                                      " info@96kulimarathamarriage.com",
                                                  style: TextStyle(
                                                    color:
                                                        AppTheme.primaryColor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    height:
                                                        1.5, // Ensure the same line height applies here
                                                  ),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          openEmail(
                                                              "info@96kulimarathamarriage.com");
                                                        },
                                                ),
                                                TextSpan(
                                                  text:
                                                      "\nसपोर्ट वेळ : स.१० ते संध्या.६ वाजेपर्यत",
                                                  style: CustomTextStyle
                                                      .bodytext
                                                      .copyWith(
                                                    height:
                                                        1.5, // Adjust height for spacing
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                              ],
                            ),
                          ),
                        ));
            } else {
              return SafeArea(
                child: _premiumPlanController.loadingplans.value
                    ? Center(
                        child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FormsTitleTag(
                                  pageName: "regularPlanPage",
                                  title: language == "en"
                                      ? "Upgrade PLan"
                                      : "प्लॅन निवडा",
                                  arrowback: false,
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
                      )
                    : RefreshIndicator(
                        onRefresh: () {
                          return Future(() {
                            _premiumPlanController.fetchPlans();
                          });
                        },
                        child: SingleChildScrollView(
                          controller: _scrollControllerBasicPlan,
                          child: Column(
                            children: [
                              FormsTitleTag(
                                pageName: "regularPlanPage",
                                title: language == "en"
                                    ? "Upgrade PLan"
                                    : "प्लॅन निवडा",
                                arrowback: false,
                              ),
                              Stack(
                                children: [
                                  Container(
                                      child: Stack(
                                    children: [
                                      SizedBox(
                                        height: 570,
                                        width: double.infinity,
                                        child: Image.asset(
                                          "assets/baseplanbg.png",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(18.0),
                                                child: Text(
                                                  language == "en"
                                                      ? "Take the next step in your journey!"
                                                      : "रजिस्ट्रेशन तर तुम्ही केलंय..!!",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 21,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 18.0),
                                                child: RichText(
                                                    textAlign: TextAlign.center,
                                                    text: TextSpan(children: [
                                                      TextSpan(
                                                        text: language == "en"
                                                            ? "Upgrade to Premium and get full access to profiles,"
                                                            : "परंतु ",
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.white,
                                                            height: 1.5),
                                                      ),
                                                      TextSpan(
                                                        text: language == "en"
                                                            ? " interests,"
                                                            : " मनपसंत स्थळे ",
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            // rgba(255, 199, 56, 1)
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    231,
                                                                    18,
                                                                    1)),
                                                      ),
                                                      TextSpan(
                                                        text: language == "en"
                                                            ? " and"
                                                            : "बघण्यासाठी व त्यांचा",
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      TextSpan(
                                                        text: language == "en"
                                                            ? " direct connections"
                                                            : " संपर्क क्रमांक ",
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    231,
                                                                    18,
                                                                    1)),
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
                                                            fontSize: 14,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ])),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              /* Container(
                            width: double.infinity, // Outer container takes full width
                            child: Stack(
                              clipBehavior: Clip.none, // Allows overlay to extend outside the container bounds
                              children: [
                                Align(
                                  alignment: Alignment.center, // Center the box inside the full-width container
                                  child: IntrinsicWidth(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Add padding for better spacing
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: const Color.fromRGBO(255, 199, 131, 81),
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      alignment: Alignment.center,
                                      child: Padding(
                                        
                                        child: Text(
                                          "खास ऑफर ",
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Positioned widget to overlay text on top border
                                Positioned(
                                  top: -10, // Adjust this value to position the overlay as needed
                                  left: 0,
                                  right: 0,
                                  child: Align(
                                    alignment: Alignment.center, // Centers the text
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2), // Add padding for better spacing
                                      color: Colors.white, // Optional background color for better visibility
                                      child: Text(
                                        "सर्व प्रीमियम प्लॅन्स वर",
                                     
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          */

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
                                              // OfferContainer(),
                                              _premiumPlanController.planList[0]
                                                              ["plan_data"]
                                                          ["plan_image"] !=
                                                      null
                                                  ? SizedBox(
                                                      // height: 20,
                                                      child: language == "en"
                                                          ? Image.network(
                                                              "https://96kulimarathamarriage.com/migration/web/public/storage/planImage/${_premiumPlanController.planList[0]["plan_data"]["plan_image"]}")
                                                          : Image.network(
                                                              "https://96kulimarathamarriage.com/migration/web/public/storage/planImage/${_premiumPlanController.planList[0]["plan_data_mr"]["plan_image"]}"))
                                                  : const SizedBox(),
                                              /* Regular Offer Image */
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0),
                                                child: Container(
                                                  constraints:
                                                      const BoxConstraints(
                                                    maxHeight:
                                                        500, // limit height, allow scroll
                                                  ),
                                                  child: ListView.builder(
                                                    itemCount:
                                                        _premiumPlanController
                                                            .planList.length,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final plan =
                                                          _premiumPlanController
                                                              .planList[index];
                                                      print(
                                                          "Regular Plan Image ${"https://96kulimarathamarriage.com/migration/web/public/storage/planImage/${_premiumPlanController.planList[0]["plan_data_mr"]["plan_image"]}"}");
                                                      return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Container(
                                                            width: 320,
                                                            decoration: BoxDecoration(
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.5),
                                                                    spreadRadius:
                                                                        2,
                                                                    blurRadius:
                                                                        5,
                                                                    offset:
                                                                        const Offset(
                                                                            3,
                                                                            3),
                                                                  ),
                                                                ],
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                        Radius.circular(
                                                                            10)),
                                                                color: Colors
                                                                    .white),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          18.0,
                                                                      bottom:
                                                                          10,
                                                                      right: 18,
                                                                      top: 10),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  RichText(
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    text:
                                                                        TextSpan(
                                                                      children: [
                                                                        WidgetSpan(
                                                                          child:
                                                                              Wrap(
                                                                            crossAxisAlignment:
                                                                                WrapCrossAlignment.center,
                                                                            spacing:
                                                                                4,
                                                                            children: [
                                                                              const Icon(Icons.star, color: Color.fromARGB(255, 225, 199, 56), size: 14),
                                                                              const Icon(Icons.star, color: Color.fromARGB(255, 225, 199, 56), size: 17),
                                                                              Text(
                                                                                "${plan["plan_popularity"] ?? ""}",
                                                                                style: const TextStyle(
                                                                                  color: Color.fromARGB(255, 198, 161, 41),
                                                                                  fontSize: 16,
                                                                                ),
                                                                              ),
                                                                              const Icon(Icons.star, color: Color.fromARGB(255, 225, 199, 56), size: 14),
                                                                              const Icon(Icons.star, color: Color.fromARGB(255, 225, 199, 56), size: 17),
                                                                            ],
                                                                          ),
                                                                          alignment:
                                                                              PlaceholderAlignment.middle,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  FittedBox(
                                                                    child:
                                                                        RichText(
                                                                      text: TextSpan(
                                                                          children: [
                                                                            plan["plan_data"]["plan_display_name"] != null
                                                                                ? TextSpan(
                                                                                    text: (language == "en" ? plan["plan_data"]["plan_display_name"]?.toString().toUpperCase() ?? "" : plan["plan_data_mr"]["plan_display_name"]?.toString().toUpperCase() ?? ""),
                                                                                    style: const TextStyle(
                                                                                      fontSize: 35,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      fontFamily: "WORKSANSBOLD",
                                                                                      color: Color.fromARGB(255, 157, 125, 20),
                                                                                    ),
                                                                                  )
                                                                                : TextSpan(
                                                                                    text: plan["plan_name"].toString(),
                                                                                    style: const TextStyle(
                                                                                      fontSize: 35,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      fontFamily: "WORKSANSBOLD",
                                                                                      color: Color.fromARGB(255, 157, 125, 20),
                                                                                    ),
                                                                                  ),
                                                                          ]),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Text(
                                                                    language ==
                                                                            "en"
                                                                        ? "Plan Duration : ${plan["plan_duration_text"]}"
                                                                        : " प्लॅनचा कालावधी : ${plan["plan_duration_text"]}",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontFamily:
                                                                            "WORKSANS",
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            80,
                                                                            93,
                                                                            126)),
                                                                  ),
                                                                  RichText(
                                                                    text:
                                                                        TextSpan(
                                                                      children: [
                                                                        TextSpan(
                                                                          text:
                                                                              "₹ ${double.parse(plan["discount_price_without_gst"]).toInt()} ",
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                35,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            fontFamily:
                                                                                "WORKSANSBOLD",
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                80,
                                                                                93,
                                                                                126),
                                                                          ),
                                                                        ),
                                                                        plan["show_gst"] ==
                                                                                true
                                                                            ? const TextSpan(
                                                                                text: "+ GST",
                                                                                style: TextStyle(fontFamily: "WORKSANS", fontSize: 18, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 80, 93, 126)))
                                                                            : const TextSpan(
                                                                                text: "",
                                                                                style: TextStyle(
                                                                                  fontFamily: "WORKSANS",
                                                                                  fontSize: 18,
                                                                                  fontWeight: FontWeight.w600,
                                                                                  color: Color.fromARGB(255, 80, 93, 126),
                                                                                ),
                                                                              ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            10.0),
                                                                    child:
                                                                        ElevatedButton
                                                                            .icon(
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        elevation:
                                                                            8,
                                                                        shadowColor: Colors
                                                                            .grey
                                                                            .withOpacity(0.5),
                                                                      ),
                                                                      onPressed: _paymentController
                                                                              .isPaymentInProgress
                                                                              .value
                                                                          ? null
                                                                          : () {
                                                                              facebookAppEvents.logEvent(name: "Fb_96k_Purchase_Plan_Button_click");
                                                                              analytics.logEvent(name: "Purchase_Plan_Button_click");
                                                                              _paymentController.startPayment();
                                                                              _paymentController.startPayment();
                                                                              String discountPlanPrice = plan["plan_price_with_gst"];
                                                                              double planPriceAsDouble = double.parse(discountPlanPrice);
                                                                              _premiumPlanController.planPrice.value = planPriceAsDouble;
                                                                              _premiumPlanController.selectedaddonPlanID.value = plan["plan_id"];
                                                                              var options = {
                                                                                'key': '${_premiumPlanController.userRazorPayKey}',
                                                                                'amount': '${plan["discount_plan_price_with_gst"]}',
                                                                                'order_id': '${plan["razorpay_order_id"]}',
                                                                                'name': '96 Kuli Maratha Marriage',
                                                                                'description': 'Premium Plan',
                                                                              };
                                                                              _razorpay.open(options);
                                                                            },
                                                                      icon:
                                                                          SizedBox(
                                                                        height:
                                                                            20,
                                                                        child: Image.asset(
                                                                            "assets/premium1.png"),
                                                                      ),
                                                                      label:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            Text(
                                                                          language == "en"
                                                                              ? "Buy Plan"
                                                                              : "प्लॅन खरेदी करा",
                                                                          style:
                                                                              CustomTextStyle.elevatedButton,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      const SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      // RichText(
                                                                      //   textAlign:
                                                                      //       TextAlign
                                                                      //           .center,
                                                                      //   text:
                                                                      //       const TextSpan(
                                                                      //     children: [
                                                                      //       TextSpan(
                                                                      //         text:
                                                                      //             "साप्ताहिक",
                                                                      //         style:
                                                                      //             TextStyle(
                                                                      //           fontSize: 14,
                                                                      //           fontWeight: FontWeight.w500,
                                                                      //           fontFamily: "WORKSANS",
                                                                      //           color: Color.fromARGB(255, 9, 39, 73),
                                                                      //         ),
                                                                      //       ),
                                                                      //       TextSpan(
                                                                      //         text:
                                                                      //             " 4 संपर्क ",
                                                                      //         style:
                                                                      //             TextStyle(
                                                                      //           fontSize: 14,
                                                                      //           fontWeight: FontWeight.bold,
                                                                      //           fontFamily: "WORKSANSBOLD",
                                                                      //           color: Color.fromARGB(255, 9, 39, 73),
                                                                      //         ),
                                                                      //       ),
                                                                      //       TextSpan(
                                                                      //         text:
                                                                      //             "क्रमांक नंबर",
                                                                      //         style:
                                                                      //             TextStyle(
                                                                      //           fontSize: 14,
                                                                      //           fontWeight: FontWeight.w500,
                                                                      //           fontFamily: "WORKSANSBOLD",
                                                                      //           color: Color.fromARGB(255, 9, 39, 73),
                                                                      //         ),
                                                                      //       ),
                                                                      //     ],
                                                                      //   ),
                                                                      // ),
                                                                      SizedBox(
                                                                        height:
                                                                            150,
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          child:
                                                                              Html(
                                                                            data:
                                                                                plan["fechar_data"],
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 20,
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
                                                height: 40,
                                              ),
                                              _premiumPlanController
                                                      .showExploreList.value
                                                  ? Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                            language == "en"
                                                                ? "Discover What Awaits You!"
                                                                : "सर्वोत्तम स्थळ शोधण्याची हीच योग्य वेळ!",
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    "WORKSANS",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 20,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        80,
                                                                        93,
                                                                        126))),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      26.0),
                                                          child: Text(
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              language == "en"
                                                                  ? "Unlock & check out profiles that suit your expectations."
                                                                  : "तुमच्यासाठी अनुरूप असलेल्या सर्व  प्रोफाईल्स बघा.",
                                                              style:
                                                                  CustomTextStyle
                                                                      .bodytext),
                                                        ),
                                                        const SizedBox(
                                                          height: 30,
                                                        ),
                                                        _exploreAppController
                                                                .recommendedmatchesListfetching
                                                                .value
                                                            ? SizedBox(
                                                                height: 320,
                                                                child: ListView
                                                                    .builder(
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  itemCount: 8,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return Shimmer
                                                                        .fromColors(
                                                                      baseColor:
                                                                          Colors
                                                                              .grey[300]!,
                                                                      highlightColor:
                                                                          Colors
                                                                              .grey[100]!,
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            4.0),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              200,
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(10)),
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              Flexible(
                                                                                flex: 6,
                                                                                child: Container(
                                                                                  decoration: const BoxDecoration(
                                                                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                  width: 200,
                                                                                  child: ClipRRect(
                                                                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                                                                    child: Container(
                                                                                      color: Colors.grey[300],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Flexible(
                                                                                flex: 5,
                                                                                child: Container(
                                                                                  width: 300,
                                                                                  decoration: const BoxDecoration(
                                                                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                                                                    color: Color.fromARGB(255, 235, 237, 239),
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Container(
                                                                                          height: 15,
                                                                                          color: Colors.grey[300],
                                                                                        ),
                                                                                        const SizedBox(height: 5),
                                                                                        Container(
                                                                                          height: 12,
                                                                                          color: Colors.grey[300],
                                                                                        ),
                                                                                        const SizedBox(height: 5),
                                                                                        Row(
                                                                                          children: [
                                                                                            Container(
                                                                                              height: 12,
                                                                                              width: 60,
                                                                                              color: Colors.grey[300],
                                                                                            ),
                                                                                            const SizedBox(width: 4),
                                                                                            Container(
                                                                                              width: 1.0,
                                                                                              height: 12.0,
                                                                                              color: const Color.fromARGB(255, 80, 93, 126),
                                                                                            ),
                                                                                            const SizedBox(width: 4),
                                                                                            Container(
                                                                                              height: 12,
                                                                                              width: 80,
                                                                                              color: Colors.grey[300],
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        const SizedBox(height: 5),
                                                                                        Container(
                                                                                          height: 12,
                                                                                          color: Colors.grey[300],
                                                                                        ),
                                                                                        const SizedBox(height: 5),
                                                                                        Row(
                                                                                          children: [
                                                                                            Container(
                                                                                              height: 12,
                                                                                              width: 100,
                                                                                              color: Colors.grey[300],
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              )
                                                            : _exploreAppController
                                                                    .recommendedmatchesList
                                                                    .isEmpty
                                                                ? const SizedBox()
                                                                : Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            18.0,
                                                                        vertical:
                                                                            8),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        SizedBox(
                                                                          height:
                                                                              350,
                                                                          child:
                                                                              ListView.builder(
                                                                            scrollDirection:
                                                                                Axis.horizontal,
                                                                            itemCount: _exploreAppController.recommendedmatchesList.length > 5
                                                                                ? 6
                                                                                : _exploreAppController.recommendedmatchesList.length,
                                                                            itemBuilder:
                                                                                (context, index) {
                                                                              if (_exploreAppController.recommendedmatchesList.length > 5) {
                                                                                final FilterList = _exploreAppController.recommendedmatchesList.sublist(0, 6);

                                                                                if (index < FilterList.length - 1) {
                                                                                  final match = FilterList[index];
                                                                                  return Padding(
                                                                                    padding: const EdgeInsets.all(4.0),
                                                                                    child: GestureDetector(
                                                                                      onTap: () async {
                                                                                        try {
                                                                                          print('Checking for Update');
                                                                                          AppUpdateInfo info = await InAppUpdate.checkForUpdate();

                                                                                          if (info.updateAvailability == UpdateAvailability.updateAvailable) {
                                                                                            print('Update available');
                                                                                            await update();
                                                                                          } else {
                                                                                            print('No update available');
                                                                                            AddVisitedByMeList(MemberID: match["member_id"]);
                                                                                            print("Scroll WorkMemeber");
                                                                                            _scrollToTargetBasicPlan();
                                                                                            print("Scroll Work");
                                                                                          }
                                                                                        } catch (e) {
                                                                                          AddVisitedByMeList(MemberID: match["member_id"]);
                                                                                          print('Error checking for update: ${e.toString()}');
                                                                                          _scrollToTargetBasicPlan();
                                                                                          print("Scroll WorkError");
                                                                                        }
                                                                                      },
                                                                                      child: Container(
                                                                                        width: 200,
                                                                                        decoration: const BoxDecoration(
                                                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                        ),
                                                                                        child: Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                          children: [
                                                                                            Flexible(
                                                                                              flex: 5,
                                                                                              child: Container(
                                                                                                decoration: const BoxDecoration(
                                                                                                  borderRadius: BorderRadius.only(
                                                                                                    topLeft: Radius.circular(10),
                                                                                                    topRight: Radius.circular(10),
                                                                                                  ),
                                                                                                ),
                                                                                                width: 200,
                                                                                                child: ClipRRect(
                                                                                                  borderRadius: const BorderRadius.only(
                                                                                                    topLeft: Radius.circular(10),
                                                                                                    topRight: Radius.circular(10),
                                                                                                  ),
                                                                                                  child: Image.network(
                                                                                                    match['photoUrl'] ?? "${Appconstants.baseURL}/public/storage/images/download.png",
                                                                                                    fit: BoxFit.cover,
                                                                                                    width: double.infinity,
                                                                                                    height: double.infinity,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            Flexible(
                                                                                              flex: 3,
                                                                                              child: Container(
                                                                                                width: 300,
                                                                                                decoration: const BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)), color: Colors.white),
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                                  child: Column(
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    children: [
                                                                                                      const SizedBox(
                                                                                                        height: 5,
                                                                                                      ),
                                                                                                      Center(
                                                                                                        child: Row(
                                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                          children: [
                                                                                                            Text(
                                                                                                              /* Member ID : */ " ${match["member_profile_id"]}",
                                                                                                              style: CustomTextStyle.bodytextbold,
                                                                                                            ),
                                                                                                            match["is_Document_Verification"] == 1
                                                                                                                ? Padding(
                                                                                                                    padding: const EdgeInsets.only(left: 4.0, top: 4),
                                                                                                                    child: SizedBox(
                                                                                                                      height: 13,
                                                                                                                      width: 13,
                                                                                                                      child: Image.asset("assets/verified.png"),
                                                                                                                    ),
                                                                                                                  )
                                                                                                                : const SizedBox()
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                      const Spacer(),
                                                                                                      Center(
                                                                                                        child: Text(
                                                                                                          "${match["age"]} Yrs, ${match["height"]},",
                                                                                                          overflow: TextOverflow.ellipsis,
                                                                                                          style: CustomTextStyle.bodytext.copyWith(fontSize: 12),
                                                                                                        ),
                                                                                                      ),
                                                                                                      Center(
                                                                                                        child: Text(
                                                                                                          "${match["present_city_name"]}, ${match["marital_status"]}",
                                                                                                          overflow: TextOverflow.ellipsis,
                                                                                                          style: CustomTextStyle.bodytext.copyWith(fontSize: 12),
                                                                                                        ),
                                                                                                      ),
                                                                                                      Center(
                                                                                                        child: Text(
                                                                                                          "${match["education"]}",
                                                                                                          overflow: TextOverflow.ellipsis,
                                                                                                          style: CustomTextStyle.bodytext.copyWith(fontSize: 12),
                                                                                                        ),
                                                                                                      ),
                                                                                                      const SizedBox(height: 10),
                                                                                                      Row(
                                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                                        children: [
                                                                                                          Image.asset(height: 14, "assets/heartoutlined.png"),
                                                                                                          const SizedBox(width: 5),
                                                                                                          Text(
                                                                                                            language == "en" ? "Connect Now" : "इंटरेस्ट पाठवा",
                                                                                                            style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w600),
                                                                                                          )
                                                                                                        ],
                                                                                                      )
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                } else {
                                                                                  final match = FilterList[index];

                                                                                  return Padding(
                                                                                    padding: const EdgeInsets.all(4.0),
                                                                                    child: GestureDetector(
                                                                                      onTap: () async {
                                                                                        try {
                                                                                          print('Checking for Update');
                                                                                          AppUpdateInfo info = await InAppUpdate.checkForUpdate();

                                                                                          if (info.updateAvailability == UpdateAvailability.updateAvailable) {
                                                                                            print('Update available');
                                                                                            await update();
                                                                                          } else {
                                                                                            print('No update available');

                                                                                            navigatorKey.currentState!.push(
                                                                                              MaterialPageRoute(builder: (context) => const ExploreAppAfterLogin()),
                                                                                            );
                                                                                          }
                                                                                        } catch (e) {
                                                                                          print('Error checking for update: ${e.toString()}');
                                                                                          navigatorKey.currentState!.push(
                                                                                            MaterialPageRoute(builder: (context) => const ExploreAppAfterLogin()),
                                                                                          );
                                                                                        }
                                                                                      },
                                                                                      child: Stack(
                                                                                        children: [
                                                                                          Container(
                                                                                            width: 200,
                                                                                            decoration: const BoxDecoration(
                                                                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                            ),
                                                                                            child: Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                                              children: [
                                                                                                Flexible(
                                                                                                  flex: 5,
                                                                                                  child: Container(
                                                                                                    decoration: const BoxDecoration(
                                                                                                      borderRadius: BorderRadius.only(
                                                                                                        topLeft: Radius.circular(10),
                                                                                                        topRight: Radius.circular(10),
                                                                                                      ),
                                                                                                    ),
                                                                                                    width: 200,
                                                                                                    child: ClipRRect(
                                                                                                      borderRadius: const BorderRadius.only(
                                                                                                        topLeft: Radius.circular(10),
                                                                                                        topRight: Radius.circular(10),
                                                                                                      ),
                                                                                                      child: Image.network(
                                                                                                        match['photoUrl'] ?? "${Appconstants.baseURL}/public/storage/images/download.png",
                                                                                                        fit: BoxFit.cover,
                                                                                                        width: double.infinity,
                                                                                                        height: double.infinity,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                Flexible(
                                                                                                  flex: 3,
                                                                                                  child: Container(
                                                                                                    width: 300,
                                                                                                    decoration: const BoxDecoration(
                                                                                                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                                                                                      color: Color.fromARGB(255, 235, 237, 239),
                                                                                                    ),
                                                                                                    child: Padding(
                                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                                      child: Column(
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        children: [
                                                                                                          const SizedBox(
                                                                                                            height: 5,
                                                                                                          ),
                                                                                                          Center(
                                                                                                            child: Row(
                                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                              children: [
                                                                                                                Text(
                                                                                                                  "${match["member_profile_id"]}",
                                                                                                                  style: CustomTextStyle.bodytextbold,
                                                                                                                ),
                                                                                                                match["is_Document_Verification"] == 1
                                                                                                                    ? Padding(
                                                                                                                        padding: const EdgeInsets.only(left: 4.0, top: 4),
                                                                                                                        child: SizedBox(
                                                                                                                          height: 13,
                                                                                                                          width: 13,
                                                                                                                          child: Image.asset("assets/verified.png"),
                                                                                                                        ),
                                                                                                                      )
                                                                                                                    : const SizedBox()
                                                                                                              ],
                                                                                                            ),
                                                                                                          ),
                                                                                                          const Spacer(),
                                                                                                          Center(
                                                                                                            child: Text(
                                                                                                              "${match["age"]} Yrs, ${match["height"]},",
                                                                                                              overflow: TextOverflow.ellipsis,
                                                                                                              style: CustomTextStyle.bodytext.copyWith(fontSize: 12),
                                                                                                            ),
                                                                                                          ),
                                                                                                          Center(
                                                                                                            child: Text(
                                                                                                              "${match["present_city_name"]}, ${match["marital_status"]}",
                                                                                                              overflow: TextOverflow.ellipsis,
                                                                                                              style: CustomTextStyle.bodytext.copyWith(fontSize: 12),
                                                                                                            ),
                                                                                                          ),
                                                                                                          Center(
                                                                                                            child: Text(
                                                                                                              "${match["education"]}",
                                                                                                              overflow: TextOverflow.ellipsis,
                                                                                                              style: CustomTextStyle.bodytext.copyWith(fontSize: 12),
                                                                                                            ),
                                                                                                          ),
                                                                                                          const SizedBox(height: 10),
                                                                                                          Row(
                                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                                            children: [
                                                                                                              Image.asset(height: 14, "assets/heartoutlined.png"),
                                                                                                              const SizedBox(width: 5),
                                                                                                              Text(
                                                                                                                language == "en" ? "Connect Now" : "इंटरेस्ट पाठवा",
                                                                                                                style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w600),
                                                                                                              )
                                                                                                            ],
                                                                                                          )
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          Positioned.fill(
                                                                                            child: Container(
                                                                                                decoration: BoxDecoration(
                                                                                                  color: Colors.black.withOpacity(0.7),
                                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                                ),
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsets.all(18.0),
                                                                                                  child: Column(
                                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [
                                                                                                      const SizedBox(
                                                                                                        height: 20,
                                                                                                      ),
                                                                                                      Center(
                                                                                                        child: Text(
                                                                                                          textAlign: TextAlign.center,
                                                                                                          language == "en" ? "Discover more profiles to find your match!!" : "1000 पेक्षा जास्त प्रोफाईल्स तुमची वाट बघत आहेत.",
                                                                                                          style: CustomTextStyle.bodytextbold.copyWith(
                                                                                                            color: Colors.white,
                                                                                                            fontSize: 16,
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                      const SizedBox(
                                                                                                        height: 10,
                                                                                                      ),
                                                                                                      Center(
                                                                                                        child: Text(
                                                                                                          textAlign: TextAlign.center,
                                                                                                          language == "en" ? "View All!!" : 'सर्व प्रोफाईल्स बघा',
                                                                                                          style: CustomTextStyle.bodytextbold.copyWith(
                                                                                                            color: const Color.fromRGBO(255, 231, 18, 1),
                                                                                                            fontSize: 16,
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                )),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                }
                                                                              } else {
                                                                                final match = _exploreAppController.recommendedmatchesList[index];

                                                                                return Padding(
                                                                                  padding: const EdgeInsets.all(4.0),
                                                                                  child: GestureDetector(
                                                                                    onTap: () async {
                                                                                      try {
                                                                                        print('Checking for Update');
                                                                                        AppUpdateInfo info = await InAppUpdate.checkForUpdate();

                                                                                        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
                                                                                          print('Update available');
                                                                                          await update();
                                                                                        } else {
                                                                                          print('No update available');
                                                                                          print("Scroll Check1Update");
                                                                                          _scrollToTargetBasicPlan();
                                                                                          print("Scroll Check1Update1");
                                                                                        }
                                                                                      } catch (e) {
                                                                                        print('Error checking for update: ${e.toString()}');
                                                                                        print("Scroll Check1Error");
                                                                                        _scrollToTargetBasicPlan();
                                                                                        print("Scroll Check1Error1");
                                                                                      }
                                                                                    },
                                                                                    child: Container(
                                                                                      width: 200,
                                                                                      decoration: const BoxDecoration(
                                                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                      ),
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        children: [
                                                                                          Flexible(
                                                                                            flex: 5,
                                                                                            child: Container(
                                                                                              decoration: const BoxDecoration(
                                                                                                borderRadius: BorderRadius.only(
                                                                                                  topLeft: Radius.circular(10),
                                                                                                  topRight: Radius.circular(10),
                                                                                                ),
                                                                                              ),
                                                                                              width: 200,
                                                                                              child: ClipRRect(
                                                                                                borderRadius: const BorderRadius.only(
                                                                                                  topLeft: Radius.circular(10),
                                                                                                  topRight: Radius.circular(10),
                                                                                                ),
                                                                                                child: Image.network(
                                                                                                  match['photoUrl'] ?? "${Appconstants.baseURL}/public/storage/images/download.png",
                                                                                                  fit: BoxFit.cover,
                                                                                                  width: double.infinity,
                                                                                                  height: double.infinity,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Flexible(
                                                                                            flex: 3,
                                                                                            child: Container(
                                                                                              width: 300,
                                                                                              decoration: const BoxDecoration(
                                                                                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                                                                                color: Color.fromARGB(255, 235, 237, 239),
                                                                                              ),
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsets.all(8.0),
                                                                                                child: Column(
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children: [
                                                                                                    const SizedBox(
                                                                                                      height: 5,
                                                                                                    ),
                                                                                                    Center(
                                                                                                      child: Row(
                                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        children: [
                                                                                                          Text(
                                                                                                            "${match["member_profile_id"]}",
                                                                                                            style: CustomTextStyle.bodytextbold,
                                                                                                          ),
                                                                                                          match["is_Document_Verification"] == 1
                                                                                                              ? Padding(
                                                                                                                  padding: const EdgeInsets.only(left: 4.0, top: 4),
                                                                                                                  child: SizedBox(
                                                                                                                    height: 13,
                                                                                                                    width: 13,
                                                                                                                    child: Image.asset("assets/verified.png"),
                                                                                                                  ),
                                                                                                                )
                                                                                                              : const SizedBox()
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                    const Spacer(),
                                                                                                    Center(
                                                                                                      child: Text(
                                                                                                        "${match["age"]} Yrs, ${match["height"]},",
                                                                                                        overflow: TextOverflow.ellipsis,
                                                                                                        style: CustomTextStyle.bodytext.copyWith(fontSize: 12),
                                                                                                      ),
                                                                                                    ),
                                                                                                    Center(
                                                                                                      child: Text(
                                                                                                        "${match["present_city_name"]}, ${match["marital_status"]}",
                                                                                                        overflow: TextOverflow.ellipsis,
                                                                                                        style: CustomTextStyle.bodytext.copyWith(fontSize: 12),
                                                                                                      ),
                                                                                                    ),
                                                                                                    Center(
                                                                                                      child: Text(
                                                                                                        "${match["education"]}",
                                                                                                        overflow: TextOverflow.ellipsis,
                                                                                                        style: CustomTextStyle.bodytext.copyWith(fontSize: 12),
                                                                                                      ),
                                                                                                    ),
                                                                                                    const SizedBox(height: 10),
                                                                                                    Row(
                                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      children: [
                                                                                                        Image.asset(height: 14, "assets/heartoutlined.png"),
                                                                                                        const SizedBox(width: 5),
                                                                                                        Text(
                                                                                                          language == "en" ? "Connect Now" : "इंटरेस्ट पाठवा",
                                                                                                          style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w600),
                                                                                                        )
                                                                                                      ],
                                                                                                    )
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              }
                                                                            },
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        Center(
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              analytics.logEvent(
                                                                  name:
                                                                      "Plan_Page_Explore_App_Button_Click");
                                                              facebookAppEvents
                                                                  .logEvent(
                                                                      name:
                                                                          "FB_Plan_Page_Explore_App_Button_Click");
                                                              navigatorKey
                                                                  .currentState!
                                                                  .push(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const ExploreAppAfterLogin()),
                                                              );
                                                            },
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              elevation: 5,
                                                              padding: const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      48,
                                                                  vertical:
                                                                      18), // Horizontal padding inside the button
                                                              shape:
                                                                  const RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)), // Rectangular shape
                                                              ),
                                                            ),
                                                            child: Text(
                                                              language == "en"
                                                                  ? "Explore Profiles"
                                                                  : "एक्सप्लोर प्रोफाईल्स",
                                                              style: CustomTextStyle
                                                                  .elevatedButton,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : const SizedBox(),

                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 28.0),
                                                child: Text(
                                                  textAlign: TextAlign.center,
                                                  language == "en"
                                                      ? "All Premium Plan Features Plus More Exclusive Benefits"
                                                      : "सर्व सुविधांसोबतच प्रीमियम प्लॅनच्या अजून काही विशेष सुविधा ",
                                                  style: const TextStyle(
                                                    fontFamily: "WORKSANS",
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 20,
                                                    //rgba(9, 39, 73, 1)
                                                    // rgba(80, 93, 126, 1)
                                                    color: Color.fromARGB(
                                                        255, 80, 93, 126),
                                                    // Color.fromARGB(
                                                    //     255, 9, 39, 73)
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 28.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 8.0),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          const CircleAvatar(
                                                            radius: 3,
                                                            // rgba(204, 40, 77, 1)
                                                            backgroundColor:
                                                                Color.fromRGBO(
                                                                    204,
                                                                    40,
                                                                    77,
                                                                    1),
                                                          ),
                                                          const SizedBox(
                                                              width:
                                                                  8), // Add spacing between the icon and the text
                                                          Expanded(
                                                            child: RichText(
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              text: TextSpan(
                                                                children: [
                                                                  // rgba(9, 39, 73, 1)
                                                                  TextSpan(
                                                                    text: language ==
                                                                            "en"
                                                                        ? "Shortlist"
                                                                        : 'पसंत असलेल्या स्थळांना',
                                                                    style: CustomTextStyle
                                                                        .bodytext
                                                                        .copyWith(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight: language ==
                                                                              "en"
                                                                          ? FontWeight
                                                                              .bold
                                                                          : FontWeight
                                                                              .w400,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                        255,
                                                                        80,
                                                                        93,
                                                                        126,
                                                                      ),
                                                                      // const Color
                                                                      //     .fromRGBO(
                                                                      //     9,
                                                                      //     39,
                                                                      //     73,
                                                                      //     1)
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: language ==
                                                                            "en"
                                                                        ? ""
                                                                        : ' शॉर्टलिस्ट',
                                                                    style: CustomTextStyle
                                                                        .bodytext
                                                                        .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          "WORKSANSBOLD",
                                                                      fontSize:
                                                                          14,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                        255,
                                                                        80,
                                                                        93,
                                                                        126,
                                                                      ),
                                                                      //  const Color
                                                                      //     .fromRGBO(
                                                                      //     9,
                                                                      //     39,
                                                                      //     73,
                                                                      //     1)
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: language ==
                                                                            "en"
                                                                        ? " your favorite profiles"
                                                                        : ' करण्याची सोय',
                                                                    style: CustomTextStyle
                                                                        .bodytext
                                                                        .copyWith(
                                                                      fontSize:
                                                                          14,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                        255,
                                                                        80,
                                                                        93,
                                                                        126,
                                                                      ),
                                                                      // const Color
                                                                      //     .fromRGBO(
                                                                      //     9,
                                                                      //     39,
                                                                      //     73,
                                                                      //     1)
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
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 8.0),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          const CircleAvatar(
                                                            radius: 3,
                                                            // rgba(204, 40, 77, 1)
                                                            backgroundColor:
                                                                Color.fromRGBO(
                                                                    204,
                                                                    40,
                                                                    77,
                                                                    1),
                                                          ),
                                                          const SizedBox(
                                                              width:
                                                                  8), // Add spacing between the icon and the text
                                                          Expanded(
                                                            child: RichText(
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              text: TextSpan(
                                                                children: [
                                                                  // rgba(9, 39, 73, 1)
                                                                  TextSpan(
                                                                    text: language ==
                                                                            "en"
                                                                        ? "Discover"
                                                                        : '१००% अमर्यादित',
                                                                    style: CustomTextStyle
                                                                        .bodytext
                                                                        .copyWith(
                                                                      fontSize:
                                                                          14,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                        255,
                                                                        80,
                                                                        93,
                                                                        126,
                                                                      ),
                                                                      // const Color
                                                                      //     .fromRGBO(
                                                                      //     9,
                                                                      //     39,
                                                                      //     73,
                                                                      //     1)
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: language ==
                                                                            "en"
                                                                        ? " advanced filtering"
                                                                        : ' मराठा प्रोफाईल्स',
                                                                    style: CustomTextStyle
                                                                        .bodytext
                                                                        .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          "WORKSANSBOLD",
                                                                      fontSize:
                                                                          14,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                        255,
                                                                        80,
                                                                        93,
                                                                        126,
                                                                      ),
                                                                      // const Color
                                                                      //     .fromRGBO(
                                                                      //     9,
                                                                      //     39,
                                                                      //     73,
                                                                      //     1)
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: language ==
                                                                            "en"
                                                                        ? " options for better matches"
                                                                        : ' एक्सप्लोर करा',
                                                                    style: CustomTextStyle
                                                                        .bodytext
                                                                        .copyWith(
                                                                      fontSize:
                                                                          14,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                        255,
                                                                        80,
                                                                        93,
                                                                        126,
                                                                      ),
                                                                      // const Color
                                                                      //     .fromRGBO(
                                                                      //     9,
                                                                      //     39,
                                                                      //     73,
                                                                      //     1)
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // Padding(
                                                    //   padding: const EdgeInsets
                                                    //       .symmetric(
                                                    //       vertical: 8.0),
                                                    //   child: Row(
                                                    //     crossAxisAlignment:
                                                    //         CrossAxisAlignment
                                                    //             .center,
                                                    //     children: [
                                                    //       const CircleAvatar(
                                                    //         radius: 3,
                                                    //         // rgba(204, 40, 77, 1)
                                                    //         backgroundColor:
                                                    //             Color.fromRGBO(
                                                    //                 204,
                                                    //                 40,
                                                    //                 77,
                                                    //                 1),
                                                    //       ),
                                                    //       const SizedBox(
                                                    //           width:
                                                    //               8), // Add spacing between the icon and the text
                                                    //       Expanded(
                                                    //         child: RichText(
                                                    //           textAlign:
                                                    //               TextAlign
                                                    //                   .start,
                                                    //           text: TextSpan(
                                                    //             children: [
                                                    //               // rgba(9, 39, 73, 1)
                                                    //               TextSpan(
                                                    //                 text:
                                                    //                     'अमर्यादित ',
                                                    //                 style: CustomTextStyle.bodytext.copyWith(
                                                    //                     fontSize:
                                                    //                         14,
                                                    //                     color: const Color
                                                    //                         .fromRGBO(
                                                    //                         9,
                                                    //                         39,
                                                    //                         73,
                                                    //                         1)),
                                                    //               ),
                                                    //               TextSpan(
                                                    //                 text:
                                                    //                     ' उच्च शिक्षित व सामान्य स्थळ',
                                                    //                 style: CustomTextStyle.bodytext.copyWith(
                                                    //                     fontWeight:
                                                    //                         FontWeight
                                                    //                             .bold,
                                                    //                     fontFamily:
                                                    //                         "WORKSANSBOLD",
                                                    //                     fontSize:
                                                    //                         14,
                                                    //                     color: const Color
                                                    //                         .fromRGBO(
                                                    //                         9,
                                                    //                         39,
                                                    //                         73,
                                                    //                         1)),
                                                    //               ),
                                                    //               TextSpan(
                                                    //                 text:
                                                    //                     ' मिळवण्याची सोय',
                                                    //                 style: CustomTextStyle.bodytext.copyWith(
                                                    //                     fontSize:
                                                    //                         14,
                                                    //                     color: const Color
                                                    //                         .fromRGBO(
                                                    //                         9,
                                                    //                         39,
                                                    //                         73,
                                                    //                         1)),
                                                    //               ),
                                                    //             ],
                                                    //           ),
                                                    //         ),
                                                    //       ),
                                                    //     ],
                                                    //   ),
                                                    // ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 8.0),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          const CircleAvatar(
                                                            radius: 3,
                                                            // rgba(204, 40, 77, 1)
                                                            backgroundColor:
                                                                Color.fromRGBO(
                                                                    204,
                                                                    40,
                                                                    77,
                                                                    1),
                                                          ),
                                                          const SizedBox(
                                                              width:
                                                                  8), // Add spacing between the icon and the text
                                                          Expanded(
                                                            child: RichText(
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              text: TextSpan(
                                                                children: [
                                                                  // rgba(9, 39, 73, 1)
                                                                  TextSpan(
                                                                    text: language ==
                                                                            "en"
                                                                        ? "Find the right match using "
                                                                        : 'शहर, वय शिक्षण, नोकरी, मंगळ इ. पर्यायांना वापरून ',
                                                                    style: CustomTextStyle
                                                                        .bodytext
                                                                        .copyWith(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                        255,
                                                                        80,
                                                                        93,
                                                                        126,
                                                                      ),
                                                                      // const Color
                                                                      //     .fromRGBO(
                                                                      //     9,
                                                                      //     39,
                                                                      //     73,
                                                                      //     1)
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: language ==
                                                                            "en"
                                                                        ? "Advanced search options "
                                                                        : 'अपेक्षित स्थळ',
                                                                    style: CustomTextStyle
                                                                        .bodytext
                                                                        .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          "WORKSANSBOLD",
                                                                      fontSize:
                                                                          14,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                        255,
                                                                        80,
                                                                        93,
                                                                        126,
                                                                      ),
                                                                      // const Color
                                                                      //     .fromRGBO(
                                                                      //     9,
                                                                      //     39,
                                                                      //     73,
                                                                      //     1)
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: language ==
                                                                            "en"
                                                                        ? ""
                                                                        : ' निवडण्याची सोय',
                                                                    style: CustomTextStyle
                                                                        .bodytext
                                                                        .copyWith(
                                                                      fontSize:
                                                                          14,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                        255,
                                                                        80,
                                                                        93,
                                                                        126,
                                                                      ),
                                                                      // const Color
                                                                      //     .fromRGBO(
                                                                      //     9,
                                                                      //     39,
                                                                      //     73,
                                                                      //     1)
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // Padding(
                                                    //   padding: const EdgeInsets
                                                    //       .symmetric(
                                                    //       vertical: 8.0),
                                                    //   child: Row(
                                                    //     crossAxisAlignment:
                                                    //         CrossAxisAlignment
                                                    //             .center,
                                                    //     children: [
                                                    //       const CircleAvatar(
                                                    //         radius: 3,
                                                    //         // rgba(204, 40, 77, 1)
                                                    //         backgroundColor:
                                                    //             Color.fromRGBO(
                                                    //                 204,
                                                    //                 40,
                                                    //                 77,
                                                    //                 1),
                                                    //       ),
                                                    //       const SizedBox(
                                                    //           width:
                                                    //               8), // Add spacing between the icon and the text
                                                    //       Expanded(
                                                    //         child: RichText(
                                                    //           textAlign:
                                                    //               TextAlign
                                                    //                   .start,
                                                    //           text: TextSpan(
                                                    //             children: [
                                                    //               // rgba(9, 39, 73, 1)
                                                    //               TextSpan(
                                                    //                 text:
                                                    //                     'प्रतिनिधी तर्फे फोनवरून ',
                                                    //                 style: CustomTextStyle.bodytext.copyWith(
                                                    //                     fontSize:
                                                    //                         14,
                                                    //                     color: const Color
                                                    //                         .fromRGBO(
                                                    //                         9,
                                                    //                         39,
                                                    //                         73,
                                                    //                         1)),
                                                    //               ),
                                                    //               TextSpan(
                                                    //                 text:
                                                    //                     ' अपेक्षित मदत ',
                                                    //                 style: CustomTextStyle.bodytext.copyWith(
                                                    //                     fontWeight:
                                                    //                         FontWeight
                                                    //                             .bold,
                                                    //                     fontFamily:
                                                    //                         "WORKSANSBOLD",
                                                    //                     fontSize:
                                                    //                         14,
                                                    //                     color: const Color
                                                    //                         .fromRGBO(
                                                    //                         9,
                                                    //                         39,
                                                    //                         73,
                                                    //                         1)),
                                                    //               ),
                                                    //               TextSpan(
                                                    //                 text:
                                                    //                     ' मिळवण्याची सोय',
                                                    //                 style: CustomTextStyle.bodytext.copyWith(
                                                    //                     fontSize:
                                                    //                         14,
                                                    //                     color: const Color
                                                    //                         .fromRGBO(
                                                    //                         9,
                                                    //                         39,
                                                    //                         73,
                                                    //                         1)),
                                                    //               ),
                                                    //             ],
                                                    //           ),
                                                    //         ),
                                                    //       ),
                                                    //     ],
                                                    //   ),
                                                    // ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 8.0),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          const CircleAvatar(
                                                            radius: 3,
                                                            // rgba(204, 40, 77, 1)
                                                            backgroundColor:
                                                                Color.fromRGBO(
                                                                    204,
                                                                    40,
                                                                    77,
                                                                    1),
                                                          ),
                                                          const SizedBox(
                                                              width:
                                                                  8), // Add spacing between the icon and the text
                                                          Expanded(
                                                            child: RichText(
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              text: TextSpan(
                                                                children: [
                                                                  // rgba(9, 39, 73, 1)
                                                                  TextSpan(
                                                                    text: language ==
                                                                            "en"
                                                                        ? "Receive "
                                                                        : 'ई-मेलद्वारे ',
                                                                    style: CustomTextStyle
                                                                        .bodytext
                                                                        .copyWith(
                                                                      fontSize:
                                                                          14,

                                                                      color: const Color
                                                                          .fromARGB(
                                                                        255,
                                                                        80,
                                                                        93,
                                                                        126,
                                                                      ),
                                                                      // const Color
                                                                      //     .fromRGBO(
                                                                      //     9,
                                                                      //     39,
                                                                      //     73,
                                                                      //     1)
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: language ==
                                                                            "en"
                                                                        ? "free messages"
                                                                        : 'मोफत संदेश ',
                                                                    style: CustomTextStyle
                                                                        .bodytext
                                                                        .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          "WORKSANSBOLD",
                                                                      fontSize:
                                                                          14,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                        255,
                                                                        80,
                                                                        93,
                                                                        126,
                                                                      ),
                                                                      // const Color
                                                                      //     .fromRGBO(
                                                                      //     9,
                                                                      //     39,
                                                                      //     73,
                                                                      //     1)
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: language ==
                                                                            "en"
                                                                        ? " via email"
                                                                        : 'मिळवण्याची सोय',
                                                                    style: CustomTextStyle
                                                                        .bodytext
                                                                        .copyWith(
                                                                      fontSize:
                                                                          14,
                                                                      color:
                                                                          // const Color
                                                                          //     .fromRGBO(
                                                                          //     9,
                                                                          //     39,
                                                                          //     73,
                                                                          //     1)
                                                                          const Color
                                                                              .fromARGB(
                                                                        255,
                                                                        80,
                                                                        93,
                                                                        126,
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

                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 8.0),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          const CircleAvatar(
                                                            radius: 3,
                                                            backgroundColor:
                                                                Color.fromRGBO(
                                                                    204,
                                                                    40,
                                                                    77,
                                                                    1),
                                                          ),
                                                          const SizedBox(
                                                              width: 8),
                                                          Expanded(
                                                            child: RichText(
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text: language ==
                                                                            "en"
                                                                        ? "Once paid, the fee "
                                                                        : 'एकदा दिलेली ',
                                                                    style: CustomTextStyle
                                                                        .bodytext
                                                                        .copyWith(
                                                                      fontSize:
                                                                          14,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                        255,
                                                                        80,
                                                                        93,
                                                                        126,
                                                                      ),
                                                                      // const Color
                                                                      //     .fromRGBO(
                                                                      //     9,
                                                                      //     39,
                                                                      //     73,
                                                                      //     1)
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: language ==
                                                                            "en"
                                                                        ? "cannot be refunded."
                                                                        : ' फी परत केली जाणार नाही',
                                                                    style: CustomTextStyle
                                                                        .bodytext
                                                                        .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          "WORKSANSBOLD",
                                                                      fontSize:
                                                                          14,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                        255,
                                                                        80,
                                                                        93,
                                                                        126,
                                                                      ),
                                                                      // const Color
                                                                      //     .fromRGBO(
                                                                      //     9,
                                                                      //     39,
                                                                      //     73,
                                                                      //     1)
                                                                    ),
                                                                  ),
                                                                  // TextSpan(
                                                                  //   text:
                                                                  //       ' मिळवण्याची सोय',
                                                                  //   style: CustomTextStyle.bodytext.copyWith(
                                                                  //       fontSize:
                                                                  //           14,
                                                                  //       color: const Color
                                                                  //           .fromRGBO(
                                                                  //           9,
                                                                  //           39,
                                                                  //           73,
                                                                  //           1)),
                                                                  // ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 8.0),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          const CircleAvatar(
                                                            radius: 3,
                                                            // rgba(204, 40, 77, 1)
                                                            backgroundColor:
                                                                Color.fromRGBO(
                                                                    204,
                                                                    40,
                                                                    77,
                                                                    1),
                                                          ),
                                                          const SizedBox(
                                                              width:
                                                                  8), // Add spacing between the icon and the text
                                                          Expanded(
                                                            child: RichText(
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              text: TextSpan(
                                                                children: [
                                                                  // rgba(9, 39, 73, 1)
                                                                  TextSpan(
                                                                    text: language ==
                                                                            "en"
                                                                        ? "Only profiles from the "
                                                                        : 'फक्त',
                                                                    style: CustomTextStyle
                                                                        .bodytext
                                                                        .copyWith(
                                                                      fontSize:
                                                                          14,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                        255,
                                                                        80,
                                                                        93,
                                                                        126,
                                                                      ),
                                                                      // const Color
                                                                      //     .fromRGBO(
                                                                      //     9,
                                                                      //     39,
                                                                      //     73,
                                                                      //     1)
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: language ==
                                                                            "en"
                                                                        ? "Maratha community "
                                                                        : ' मराठा समाजातील',
                                                                    style: CustomTextStyle
                                                                        .bodytext
                                                                        .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          "WORKSANSBOLD",
                                                                      fontSize:
                                                                          14,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                        255,
                                                                        80,
                                                                        93,
                                                                        126,
                                                                      ),
                                                                      //  const Color
                                                                      //     .fromRGBO(
                                                                      //     9,
                                                                      //     39,
                                                                      //     73,
                                                                      //     1)
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: language ==
                                                                            "en"
                                                                        ? "are accepted; others will be blocked"
                                                                        : ' प्रोफाईल्स स्वीकारल्या जातील अन्यथा प्रोफाईल',
                                                                    style: CustomTextStyle
                                                                        .bodytext
                                                                        .copyWith(
                                                                      fontSize:
                                                                          14,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                        255,
                                                                        80,
                                                                        93,
                                                                        126,
                                                                      ),
                                                                      // const Color
                                                                      //     .fromRGBO(
                                                                      //     9,
                                                                      //     39,
                                                                      //     73,
                                                                      //     1)
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: language ==
                                                                            "en"
                                                                        ? ""
                                                                        : ' ब्लॉक',
                                                                    style: CustomTextStyle
                                                                        .bodytext
                                                                        .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          "WORKSANSBOLD",
                                                                      fontSize:
                                                                          14,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                        255,
                                                                        80,
                                                                        93,
                                                                        126,
                                                                      ),
                                                                      //  const Color
                                                                      //     .fromRGBO(
                                                                      //     9,
                                                                      //     39,
                                                                      //     73,
                                                                      //     1)
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: language ==
                                                                            "en"
                                                                        ? ""
                                                                        : ' केली जाईल',
                                                                    style: CustomTextStyle
                                                                        .bodytext
                                                                        .copyWith(
                                                                      fontSize:
                                                                          14,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                        255,
                                                                        80,
                                                                        93,
                                                                        126,
                                                                      ),
                                                                      // const Color
                                                                      //     .fromRGBO(
                                                                      //     9,
                                                                      //     39,
                                                                      //     73,
                                                                      //     1)
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
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ))
                                  /* Regular Offer */
                                ],
                              ),
                              language == "en"
                                  ? Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            text:
                                                "Need assistance? Reach out at ",
                                            style: CustomTextStyle.bodytext
                                                .copyWith(
                                              letterSpacing: 0.5,
                                              height: 1.5,
                                            ),
                                            children: [
                                              TextSpan(
                                                text:
                                                    "info@96kulimarathamarriage.com",
                                                style: TextStyle(
                                                  color: AppTheme.primaryColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.5,
                                                ),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        openEmail(
                                                            "info@96kulimarathamarriage.com");
                                                      },
                                              ),
                                              TextSpan(
                                                text:
                                                    "\nSupport time: 10 am to 6 pm",
                                                style: CustomTextStyle.bodytext
                                                    .copyWith(
                                                  letterSpacing: 0.5,
                                                  height: 1.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            text:
                                                "मदतीसाठी दिलेल्या ई-मेल वर संपर्क करा",
                                            style: CustomTextStyle.bodytext
                                                .copyWith(
                                              height: 1.5,
                                            ),
                                            children: [
                                              TextSpan(
                                                text:
                                                    " info@96kulimarathamarriage.com",
                                                style: TextStyle(
                                                  color: AppTheme.primaryColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.5,
                                                ),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        openEmail(
                                                            "info@96kulimarathamarriage.com");
                                                      },
                                              ),
                                              TextSpan(
                                                text:
                                                    "\nसपोर्ट वेळ : स.१० ते संध्या.६ वाजेपर्यत",
                                                style: CustomTextStyle.bodytext
                                                    .copyWith(
                                                  height: 1.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ),
              );
            }
          }
        }),
      ),
    );
  }
}

class PlanTimer extends StatefulWidget {
  const PlanTimer({
    super.key,
    required this.onPage,
    required PremiumPlanController premiumPlanController,
    required Animation<double> animation,
  })  : _premiumPlanController = premiumPlanController,
        _animation = animation;

  final PremiumPlanController _premiumPlanController;
  final Animation<double> _animation;
  final String onPage;
  @override
  State<PlanTimer> createState() => _PlanTimerState();
}

class _PlanTimerState extends State<PlanTimer> {
  String? language = sharedPreferences?.getString("Language");
  @override
  Widget build(BuildContext context) {
    if (widget.onPage == "UpgradePlan") {
      return Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  color: const Color(0xFF051C3C),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        language == "en"
                            ? "Offer Expires in"
                            : "ऑफर लवकरच संपणार",
                        style: CustomTextStyle.timerformattextHeading
                            .copyWith(fontSize: 20),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 40,
                            width: 40,
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
                              widget._premiumPlanController.fetchPlans();
                            },
                            colonsTextStyle: CustomTextStyle.timerformattext,
                            timeTextStyle: CustomTextStyle.timerformattext,
                            descriptionTextStyle:
                                CustomTextStyle.timerformattextDesc,
                            format: CountDownTimerFormat.hoursMinutesSeconds,
                            endTime: DateTime.now().add(Duration(
                              hours:
                                  widget._premiumPlanController.endhours.value,
                              minutes: widget
                                  ._premiumPlanController.endminutes.value,
                              seconds: widget
                                  ._premiumPlanController.endseconds.value,
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
              animation: widget._animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: AnimatedBorderPainter(
                    progress: widget._animation.value,
                  ),
                );
              },
            ),
          ),
        ],
      );
    } else if (widget.onPage == "FloatingAction") {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Shadow color
              blurRadius: 10, // Blur radius
              offset: const Offset(0, 4), // Shadow position (x, y)
              spreadRadius: 2, // Spread radius
            ),
          ]),
          width: double.infinity, // Specify width
          child: FittedBox(
            fit: BoxFit
                .scaleDown, // Or any fit type depending on your requirement
            child: Stack(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    // Now the Stack has a parent with size constraints.
                    return Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        // rgba(234, 52, 74, 1)
                        color: const Color.fromARGB(255, 234, 52, 74),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                                textAlign: TextAlign.center,
                                language == "en"
                                    ? "OFFER \n EXPIRES IN "
                                    : "ऑफर\n लवकरच संपणार",
                                style: CustomTextStyle
                                    .timerformattextHeadingWhite),
                            const SizedBox(width: 10),
                            TimerCountdown(
                              onEnd: () {
                                // widget._premiumPlanController.fetchPlans();
                              },
                              colonsTextStyle:
                                  CustomTextStyle.timerformattextWhite,
                              timeTextStyle:
                                  CustomTextStyle.timerformattextWhite,
                              descriptionTextStyle:
                                  CustomTextStyle.timerformattextDescWhite,
                              format: CountDownTimerFormat.hoursMinutesSeconds,
                              endTime: DateTime.now().add(Duration(
                                hours: widget
                                    ._premiumPlanController.endhours.value,
                                minutes: widget
                                    ._premiumPlanController.endminutes.value,
                                seconds: widget
                                    ._premiumPlanController.endseconds.value,
                              )),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    } else if (widget.onPage == "Popup") {
      return Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  color: const Color(0xFF051C3C),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        language == "en"
                            ? "Offer Expires in"
                            : "ऑफर लवकरच संपणार",
                        style: CustomTextStyle.timerformattextHeading
                            .copyWith(fontSize: 20),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 40,
                            width: 40,
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
                              // widget._premiumPlanController.fetchPlans();
                            },
                            colonsTextStyle: CustomTextStyle.timerformattext
                                .copyWith(fontSize: 12),
                            timeTextStyle: CustomTextStyle.timerformattext
                                .copyWith(fontSize: 12),
                            descriptionTextStyle: CustomTextStyle
                                .timerformattextDesc
                                .copyWith(fontSize: 12),
                            format: CountDownTimerFormat.hoursMinutesSeconds,
                            endTime: DateTime.now().add(Duration(
                              hours:
                                  widget._premiumPlanController.endhours.value,
                              minutes: widget
                                  ._premiumPlanController.endminutes.value,
                              seconds: widget
                                  ._premiumPlanController.endseconds.value,
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
              animation: widget._animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: AnimatedBorderPainter(
                    progress: widget._animation.value,
                  ),
                );
              },
            ),
          ),
        ],
      );
    } else if (widget.onPage == "UpgradePlan2") {
      return Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: const Color(0xFF051C3C),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        decoration:
                            const BoxDecoration(color: Colors.transparent),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            language == "en"
                                ? "Offer Expires in"
                                : "ऑफर लवकरच संपणार",
                            style: CustomTextStyle.timerformattextHeading
                                .copyWith(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                          ),
                        )),
                    Container(
                      decoration: const BoxDecoration(
                        // rgba(255, 199, 56, 1)
                        color: Color(0xFF051C3C),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 4, left: 8.0, bottom: 8, right: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 40,
                              width: 40,
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
                                // widget._premiumPlanController.fetchPlans();
                              },
                              colonsTextStyle: CustomTextStyle.timerformattext,
                              timeTextStyle: CustomTextStyle.timerformattext,
                              descriptionTextStyle:
                                  CustomTextStyle.timerformattextDesc,
                              format: CountDownTimerFormat.hoursMinutesSeconds,
                              endTime: DateTime.now().add(Duration(
                                hours: widget
                                    ._premiumPlanController.endhours.value,
                                minutes: widget
                                    ._premiumPlanController.endminutes.value,
                                seconds: widget
                                    ._premiumPlanController.endseconds.value,
                              )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned.fill(
            // Ensure the border overlays the entire child
            child: AnimatedBuilder(
              animation: widget._animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: AnimatedBorderPainter(
                    progress: widget._animation.value,
                  ),
                );
              },
            ),
          ),
        ],
      );
    } else {
      return Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  color: const Color(0xFF051C3C),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        language == "en"
                            ? "Offer Expires in"
                            : "ऑफर लवकरच संपणार",
                        style: CustomTextStyle.timerformattextHeading,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
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
                              // widget._premiumPlanController.fetchPlans();
                            },
                            colonsTextStyle: CustomTextStyle.timerformattext,
                            timeTextStyle: CustomTextStyle.timerformattext,
                            descriptionTextStyle:
                                CustomTextStyle.timerformattextDesc,
                            format: CountDownTimerFormat.hoursMinutesSeconds,
                            endTime: DateTime.now().add(Duration(
                              hours:
                                  widget._premiumPlanController.endhours.value,
                              minutes: widget
                                  ._premiumPlanController.endminutes.value,
                              seconds: widget
                                  ._premiumPlanController.endseconds.value,
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
              animation: widget._animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: AnimatedBorderPainter(
                    progress: widget._animation.value,
                  ),
                );
              },
            ),
          ),
        ],
      );
    }
  }
}

class FAQModel {
  final String title;
  final String subtitle;

  FAQModel({required this.title, required this.subtitle});
}

class OfferContainer extends StatelessWidget {
  const OfferContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        // Use Stack to layer widgets
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter, // Align the top text
        children: [
          Container(
            decoration: BoxDecoration(
              // rgba(9, 39, 73, 1)
              color: const Color.fromRGBO(9, 39, 73, 1),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                  color: const Color.fromRGBO(255, 199, 56, 1), width: 2.0),
            ),
            padding: const EdgeInsets.only(
                top: 20.0,
                bottom: 10,
                left: 20.0,
                right: 20), // Increased vertical padding
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'खास ऑफर',
                  style: TextStyle(
                    // rgba(255, 199, 56, 1)
                    color: Color.fromRGBO(255, 199, 56, 1),
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            // Position the top text
            top: -10,
            child: Container(
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(
                      255, 199, 56, 1), // Match background color
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(
                  horizontal: 10.0), // Add padding for background
              // rgba(255, 199, 56, 1)
              child: const Text(
                // rgba(9, 39, 73, 1)
                'सर्व प्रीमियम प्लॅन्स वर',
                style: TextStyle(
                  color: Color.fromRGBO(9, 39, 73, 1),
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
