// ignore_for_file: deprecated_member_use

import 'package:_96kuliapp/main.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/planControllers/premiumPlanController.dart';
import 'package:_96kuliapp/screens/plans/upgradeScreen.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PlansSlider extends StatefulWidget {
  const PlansSlider({super.key});

  @override
  State<PlansSlider> createState() => _PlansSliderState();
}

class _PlansSliderState extends State<PlansSlider> {
  final PremiumPlanController _premiumPlanController =
      Get.find<PremiumPlanController>();
  final PaymentPremiumController _paymentController =
      Get.find<PaymentPremiumController>();
  final facebookAppEvents = FacebookAppEvents();
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  String? language = sharedPreferences?.getString("Language");

  final Razorpay _razorpay = Razorpay();

  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);

    // TODO: implement initState
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Process payment success
    facebookAppEvents.logEvent(
        name: "Fb_96k_app_plan_purchase_successfully",
        parameters: {
          'PlanID': '${_premiumPlanController.selectedaddonPlanID.value}'
        });
    facebookAppEvents.logPurchase(
        amount: /* _premiumPlanController.planPrice.value */ double.tryParse(
                _premiumPlanController.planPrice.value.toString()) ??
            0.0,
        currency: "INR");
    analytics.logEvent(name: "app_96k_plan_purchase_successfully", parameters: {
      'PlanID': '${_premiumPlanController.selectedaddonPlanID.value}'
    });
    print("Payment purchase_successfully: ${response.paymentId}");
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

  @override
  Widget build(BuildContext context) {
    // Sample data for the slider (colors for each container)

    if (_premiumPlanController.planListOffer.isNotEmpty) {
      return CarouselSlider.builder(
        options: CarouselOptions(
          height: 500.0,
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
          viewportFraction: 0.85,
        ),
        itemCount: _premiumPlanController.planListOffer.length,
        itemBuilder: (BuildContext context, int index, int realIndex) {
          final plan = _premiumPlanController.planListOffer[index];
          print("Plan name check ${plan["plan_data"]["plan_display_name"]}");
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Container(
              width: 320,
              height: 360,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey
                          .withOpacity(0.5), // Adjust the opacity as needed
                      spreadRadius: 2, // Controls how much the shadow spreads
                      blurRadius: 5, // Controls the blur effect
                      offset: const Offset(
                          3, 3), // Controls the position of the shadow (x, y)
                    ),
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18, top: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 4, // Adds spacing between the items
                              children: [
                                const Icon(Icons.star,
                                    color: Color.fromARGB(255, 216, 16, 89),
                                    size: 12),
                                const Icon(Icons.star,
                                    color: Color.fromARGB(255, 216, 16, 89),
                                    size: 15),
                                Text(
                                  "${plan["plan_popularity"] ?? ""}",
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 216, 16, 89),
                                    fontSize: 14,
                                  ),
                                ),
                                const Icon(Icons.star,
                                    color: Color.fromARGB(255, 216, 16, 89),
                                    size: 12),
                                const Icon(Icons.star,
                                    color: Color.fromARGB(255, 216, 16, 89),
                                    size: 15),
                              ],
                            ),
                            alignment: PlaceholderAlignment.middle,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: language == "en"
                              ? "${plan["plan_data"]["plan_display_name"]}"
                                  .toUpperCase()
                              : "${plan["plan_data_mr"]["plan_display_name"]}"
                                  .toUpperCase(),
                          style: const TextStyle(
                              fontSize: 30,
                              color: Color.fromARGB(255, 157, 125, 20))),
                    ])),
                    Text(
                      "${plan["plan_duration_text"]}",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          fontFamily: "WORKSANS",
                          color: Color.fromARGB(255, 80, 93, 126)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text:
                            "₹ ${double.parse(plan["discount_price_without_gst"]).toInt()} ", // Parse string to double and convert to int
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          fontFamily: "WORKSANSBOLD",
                          color: Color.fromARGB(255, 80, 93, 126),
                        ),
                      ),
                      plan["show_gst"] == true
                          ? const TextSpan(
                              text: "+ GST",
                              style: TextStyle(
                                  fontFamily: "WORKSANS",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(255, 80, 93, 126)))
                          : const TextSpan(
                              text: "",
                              style: TextStyle(
                                  fontFamily: "WORKSANS",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(255, 80, 93, 126))),
                    ])),
                    Text(
                      "₹ ${plan["plan_price_without_gst"]} /-",
                      style: TextStyle(
                        fontSize: 22,
                        decoration: TextDecoration
                            .lineThrough, // Adds the strikethrough
                        decorationColor: const Color.fromARGB(255, 234, 52, 74)
                            .withOpacity(
                                0.48), // Set the color of the line (strikethrough)
                        color: const Color.fromARGB(255, 234, 52, 74)
                            .withOpacity(0.48), // Color of the text itself
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                          text:
                              "₹ ${plan["plan_price_without_gst"] != null && plan["discount_price_without_gst"] != null ? (double.tryParse(plan["plan_price_without_gst"].toString()) ?? 0.0) - (double.tryParse(plan["discount_price_without_gst"].toString()) ?? 0.0) : 0.0}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            fontFamily: "WORKSANSBOLD",
                            color: Color.fromARGB(255, 157, 125, 20),
                          ),
                        ),
                        TextSpan(
                            text: language != "en"
                                ? " पर्यंत बचत करा !!"
                                : " Off just for you !!",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                fontFamily: "WORKSANS",
                                color: Color.fromARGB(255, 157, 125, 20))),

                        // plan_amount_per_month
                      ]),
                    ),
                    /*               RichText(
                                                     textAlign: TextAlign.center,
                                                     text: TextSpan(children: [ 
                                        TextSpan(text: "Save Upto " , style: const TextStyle(
                                   fontSize: 20,
                                   fontWeight: FontWeight.w500, 
                                   fontFamily: "WORKSANS",
                                   color: Color.fromARGB(255, 157, 125, 20))) , 
                                        TextSpan(text: "₹ ${plan["plan_price_without_gst"]}" , style: TextStyle(
                                        
                                   fontSize: 20,
                                   fontWeight: FontWeight.w500, 
                                   fontFamily: "WORKSANSBOLD",
                                   color: const Color.fromARGB(255, 157, 125, 20))) , 
                                        
                                        // plan_amount_per_month
                                   ])),*/
                    const SizedBox(
                      height: 5,
                    ),

                    Obx(
                      () {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              elevation: 8, // Add elevation for shadow effect
                              shadowColor: Colors.grey
                                  .withOpacity(0.5), // Color of the shadow
                            ),
                            onPressed:
                                _paymentController.isPaymentInProgress.value
                                    ? null
                                    : () {
                                        analytics.logEvent(
                                            name:
                                                "Explore_App_Popup_Purchase_plan_Button_Click");
                                        facebookAppEvents.logEvent(
                                            name:
                                                "FB_Explore_App_Popup_Purchase_plan_buton");
                                        _paymentController
                                            .startPayment(); // Start payment
                                        String discountPlanPrice =
                                            plan["plan_price_with_gst"];
                                        double planPriceAsDouble =
                                            double.parse(discountPlanPrice);

                                        // Assign it to your controller
                                        _premiumPlanController.planPrice.value =
                                            planPriceAsDouble;
                                        _premiumPlanController
                                            .selectedaddonPlanID
                                            .value = plan["plan_id"];
                                        var options = {
                                          'key':
                                              '${_premiumPlanController.userRazorPayKey}',
                                          'amount':
                                              '${plan["discount_plan_price_with_gst"]}',
                                          'order_id':
                                              '${plan["razorpay_order_id"]}',
                                          'name': '96 Kuli Maratha Marriage',
                                          'description': 'Premium Plan',
                                        };
                                        _razorpay.open(options);
                                      },
                            icon: SizedBox(
                              height: 15,
                              child: Image.asset("assets/premium1.png"),
                            ),
                            label: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .purchasePlan /* "PURCHASE PLAN" */,
                                style: CustomTextStyle.elevatedButtonMedium,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    // stargold
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SizedBox(
                        //   height: 10,
                        // ),
                        Html(data: plan["fechar_data"]),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       Image.asset(
                        //         "assets/stargold.png",
                        //         height: 10, // Adjust icon size
                        //         width: 10, // Adjust icon size
                        //       ),
                        //       const SizedBox(
                        //           width:
                        //               8), // Add spacing between the icon and the text
                        //       Expanded(
                        //         child: RichText(
                        //           textAlign: TextAlign.start,
                        //           text: TextSpan(
                        //             children: [
                        //               TextSpan(
                        //                 text: 'View Total',
                        //                 style:
                        //                     CustomTextStyle.bodytext.copyWith(
                        //                   fontWeight: FontWeight.w500,
                        //                   fontSize: 14,
                        //                 ),
                        //               ),
                        //               TextSpan(
                        //                 text: ' ${plan["plan_contact"]} ',
                        //                 style:
                        //                     CustomTextStyle.bodytext.copyWith(
                        //                   fontWeight: FontWeight.w600,
                        //                   fontSize: 14,
                        //                 ),
                        //               ),
                        //               TextSpan(
                        //                 text: 'Contacts',
                        //                 style:
                        //                     CustomTextStyle.bodytext.copyWith(
                        //                   fontWeight: FontWeight.w500,
                        //                   fontSize: 14,
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       Image.asset(
                        //         "assets/stargold.png",
                        //         height: 10, // Adjust icon size
                        //         width: 10, // Adjust icon size
                        //       ),
                        //       const SizedBox(
                        //           width:
                        //               8), // Add spacing between the icon and the text
                        //       Expanded(
                        //         child: RichText(
                        //           textAlign: TextAlign.start,
                        //           text: TextSpan(
                        //             children: [
                        //               TextSpan(
                        //                 text: 'Get Weekly',
                        //                 style:
                        //                     CustomTextStyle.bodytext.copyWith(
                        //                   fontWeight: FontWeight.w500,
                        //                   fontSize: 14,
                        //                 ),
                        //               ),
                        //               TextSpan(
                        //                 text:
                        //                     ' ${plan["plan_weekly_contact_limit"]} ',
                        //                 style:
                        //                     CustomTextStyle.bodytext.copyWith(
                        //                   fontWeight: FontWeight.w600,
                        //                   fontSize: 14,
                        //                 ),
                        //               ),
                        //               TextSpan(
                        //                 text: 'Contacts',
                        //                 style:
                        //                     CustomTextStyle.bodytext.copyWith(
                        //                   fontWeight: FontWeight.w500,
                        //                   fontSize: 14,
                        //                 ),
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
                    RichText(
                        text: TextSpan(children: <TextSpan>[
                      const TextSpan(
                          text: "*", style: TextStyle(color: Colors.red)),
                      TextSpan(
                          text: language == "en"
                              ? " Offer valid for limited time Period "
                              : "ऑफर मर्यादित कालावधीसाठी",
                          style: CustomTextStyle.fieldName.copyWith(
                              fontSize: 8, color: AppTheme.primaryColor)),
                      const TextSpan(
                          text: "*", style: TextStyle(color: Colors.red))
                    ])),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else {
      return CarouselSlider.builder(
        options: CarouselOptions(
          height: 450.0,
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
          viewportFraction: 0.85,
        ),
        itemCount: _premiumPlanController.planList.length,
        itemBuilder: (BuildContext context, int index, int realIndex) {
          final plan = _premiumPlanController.planList[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Container(
              width: 320,
              height: 450,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey
                          .withOpacity(0.5), // Adjust the opacity as needed
                      spreadRadius: 2, // Controls how much the shadow spreads
                      blurRadius: 5, // Controls the blur effect
                      offset: const Offset(
                          3, 3), // Controls the position of the shadow (x, y)
                    ),
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18, top: 10),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 4, // Adds spacing between the items
                                children: [
                                  const Icon(Icons.star,
                                      color: Color.fromARGB(255, 216, 16, 89),
                                      size: 12),
                                  const Icon(Icons.star,
                                      color: Color.fromARGB(255, 216, 16, 89),
                                      size: 15),
                                  Text(
                                    "${plan["plan_popularity"] ?? ""}",
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 216, 16, 89),
                                      fontSize: 16,
                                    ),
                                  ),
                                  const Icon(Icons.star,
                                      color: Color.fromARGB(255, 216, 16, 89),
                                      size: 12),
                                  const Icon(Icons.star,
                                      color: Color.fromARGB(255, 216, 16, 89),
                                      size: 15),
                                ],
                              ),
                              alignment: PlaceholderAlignment.middle,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: language == "en"
                                ? "${plan["plan_data"]["plan_display_name"]}"
                                    .toUpperCase()
                                : "${plan["plan_data_mr"]["plan_display_name"]}"
                                    .toUpperCase(),
                            style: const TextStyle(
                                fontSize: 30,
                                color: Color.fromARGB(255, 157, 125, 20))),
                      ])),
                      Text(
                        "${plan["plan_duration_text"]}",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            fontFamily: "WORKSANS",
                            color: Color.fromARGB(255, 80, 93, 126)),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text:
                              "₹ ${double.parse(plan["discount_price_with_gst"]).toInt()} ", // Parse string to double and convert to int
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            fontFamily: "WORKSANSBOLD",
                            color: Color.fromARGB(255, 80, 93, 126),
                          ),
                        ),
                        plan["show_gst"] == true
                            ? const TextSpan(
                                text: "+ GST",
                                style: TextStyle(
                                    fontFamily: "WORKSANS",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 80, 93, 126)))
                            : const TextSpan(
                                text: "",
                                style: TextStyle(
                                    fontFamily: "WORKSANS",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 80, 93, 126))),
                      ])),

                      /*               RichText(
                                                       textAlign: TextAlign.center,
                                                       text: TextSpan(children: [ 
                                          TextSpan(text: "Save Upto " , style: const TextStyle(
                                     fontSize: 20,
                                     fontWeight: FontWeight.w500, 
                                     fontFamily: "WORKSANS",
                                     color: Color.fromARGB(255, 157, 125, 20))) , 
                                          TextSpan(text: "₹ ${plan["plan_price_without_gst"]}" , style: TextStyle(
                                          
                                     fontSize: 20,
                                     fontWeight: FontWeight.w500, 
                                     fontFamily: "WORKSANSBOLD",
                                     color: const Color.fromARGB(255, 157, 125, 20))) , 
                                          
                                          // plan_amount_per_month
                                     ])),*/
                      const SizedBox(
                        height: 10,
                      ),

                      Obx(
                        () {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                elevation: 8, // Add elevation for shadow effect
                                shadowColor: Colors.grey
                                    .withOpacity(0.5), // Color of the shadow
                              ),
                              onPressed: _paymentController
                                      .isPaymentInProgress.value
                                  ? null
                                  : () {
                                      analytics.logEvent(
                                          name:
                                              "Explore_App_Popup_Purchase_plan_Button_Click");
                                      facebookAppEvents.logEvent(
                                          name:
                                              "FB_Explore_App_Popup_Purchase_plan_buton");
                                      _paymentController
                                          .startPayment(); // Start payment
                                      String discountPlanPrice =
                                          plan["plan_price_with_gst"];
                                      double planPriceAsDouble =
                                          double.parse(discountPlanPrice);

                                      // Assign it to your controller
                                      _premiumPlanController.planPrice.value =
                                          planPriceAsDouble;
                                      _premiumPlanController.selectedaddonPlanID
                                          .value = plan["plan_id"];
                                      var options = {
                                        'key':
                                            '${_premiumPlanController.userRazorPayKey}',
                                        'amount':
                                            '${plan["discount_plan_price_with_gst"]}',
                                        'order_id':
                                            '${plan["razorpay_order_id"]}',
                                        'name': '96 Kuli Maratha Marriage',
                                        'description': 'Premium Plan',
                                      };
                                      _razorpay.open(options);
                                    },
                              icon: SizedBox(
                                height: 15,
                                child: Image.asset("assets/premium1.png"),
                              ),
                              label: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Text(
                                  AppLocalizations.of(context)!.purchasePlan,
                                  style: CustomTextStyle.elevatedButtonMedium,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      // stargold
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Html(data: (plan["fechar_data"] ?? "")),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                          //   child: Row(
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       Image.asset(
                          //         "assets/stargold.png",
                          //         height: 10, // Adjust icon size
                          //         width: 10, // Adjust icon size
                          //       ),
                          //       const SizedBox(
                          //           width:
                          //               8), // Add spacing between the icon and the text
                          //       Expanded(
                          //         child: RichText(
                          //           textAlign: TextAlign.start,
                          //           text: TextSpan(
                          //             children: [
                          //               TextSpan(
                          //                 text: 'View Total',
                          //                 style:
                          //                     CustomTextStyle.bodytext.copyWith(
                          //                   fontWeight: FontWeight.w500,
                          //                   fontSize: 14,
                          //                 ),
                          //               ),
                          //               TextSpan(
                          //                 text: ' ${plan["plan_contact"]} ',
                          //                 style:
                          //                     CustomTextStyle.bodytext.copyWith(
                          //                   fontWeight: FontWeight.w600,
                          //                   fontSize: 14,
                          //                 ),
                          //               ),
                          //               TextSpan(
                          //                 text: 'Contacts',
                          //                 style:
                          //                     CustomTextStyle.bodytext.copyWith(
                          //                   fontWeight: FontWeight.w500,
                          //                   fontSize: 14,
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                          //   child: Row(
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       Image.asset(
                          //         "assets/stargold.png",
                          //         height: 10, // Adjust icon size
                          //         width: 10, // Adjust icon size
                          //       ),
                          //       const SizedBox(
                          //           width:
                          //               8), // Add spacing between the icon and the text
                          //       Expanded(
                          //         child: RichText(
                          //           textAlign: TextAlign.start,
                          //           text: TextSpan(
                          //             children: [
                          //               TextSpan(
                          //                 text: 'Get Weekly',
                          //                 style:
                          //                     CustomTextStyle.bodytext.copyWith(
                          //                   fontWeight: FontWeight.w500,
                          //                   fontSize: 14,
                          //                 ),
                          //               ),
                          //               TextSpan(
                          //                 text:
                          //                     ' ${plan["plan_weekly_contact_limit"]} ',
                          //                 style:
                          //                     CustomTextStyle.bodytext.copyWith(
                          //                   fontWeight: FontWeight.w600,
                          //                   fontSize: 14,
                          //                 ),
                          //               ),
                          //               TextSpan(
                          //                 text: 'Contacts',
                          //                 style:
                          //                     CustomTextStyle.bodytext.copyWith(
                          //                   fontWeight: FontWeight.w500,
                          //                   fontSize: 14,
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                          //   child: Row(
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       Image.asset(
                          //         "assets/stargold.png",
                          //         height: 10, // Adjust icon size
                          //         width: 10, // Adjust icon size
                          //       ),
                          //       const SizedBox(
                          //           width:
                          //               8), // Add spacing between the icon and the text
                          //       Expanded(
                          //         child: RichText(
                          //           maxLines: 2,
                          //           textAlign: TextAlign.start,
                          //           text: TextSpan(
                          //             children: [
                          //               TextSpan(
                          //                 text: 'Explore Unlimited ',
                          //                 style:
                          //                     CustomTextStyle.bodytext.copyWith(
                          //                   fontWeight: FontWeight.w500,
                          //                   fontSize: 14,
                          //                 ),
                          //               ),
                          //               TextSpan(
                          //                 text: '100% Jain Matches ',
                          //                 style:
                          //                     CustomTextStyle.bodytext.copyWith(
                          //                   fontWeight: FontWeight.w600,
                          //                   fontSize: 14,
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                          //   child: Row(
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       Image.asset(
                          //         "assets/stargold.png",
                          //         height: 10, // Adjust icon size
                          //         width: 10, // Adjust icon size
                          //       ),
                          //       const SizedBox(
                          //           width:
                          //               8), // Add spacing between the icon and the text
                          //       Expanded(
                          //         child: RichText(
                          //           textAlign: TextAlign.start,
                          //           text: TextSpan(
                          //             children: [
                          //               TextSpan(
                          //                 text: 'Shortlist ',
                          //                 style:
                          //                     CustomTextStyle.bodytext.copyWith(
                          //                   fontWeight: FontWeight.w600,
                          //                   fontSize: 14,
                          //                 ),
                          //               ),
                          //               TextSpan(
                          //                 text: 'Your Ideal Matches',
                          //                 style:
                          //                     CustomTextStyle.bodytext.copyWith(
                          //                   fontWeight: FontWeight.w500,
                          //                   fontSize: 14,
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                          //   child: Row(
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       Image.asset(
                          //         "assets/stargold.png",
                          //         height: 10, // Adjust icon size
                          //         width: 10, // Adjust icon size
                          //       ),
                          //       const SizedBox(
                          //           width:
                          //               8), // Add spacing between the icon and the text
                          //       Expanded(
                          //         child: RichText(
                          //           textAlign: TextAlign.start,
                          //           text: TextSpan(
                          //             children: [
                          //               TextSpan(
                          //                 text: 'Send Interest',
                          //                 style:
                          //                     CustomTextStyle.bodytext.copyWith(
                          //                   fontWeight: FontWeight.w600,
                          //                   fontSize: 14,
                          //                 ),
                          //               ),
                          //               TextSpan(
                          //                 text: ' to Profiles You Like',
                          //                 style:
                          //                     CustomTextStyle.bodytext.copyWith(
                          //                   fontWeight: FontWeight.w500,
                          //                   fontSize: 14,
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                          //   child: Row(
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       Image.asset(
                          //         "assets/stargold.png",
                          //         height: 10, // Adjust icon size
                          //         width: 10, // Adjust icon size
                          //       ),
                          //       const SizedBox(
                          //           width:
                          //               8), // Add spacing between the icon and the text
                          //       Expanded(
                          //         child: RichText(
                          //           maxLines: 2,
                          //           textAlign: TextAlign.start,
                          //           text: TextSpan(
                          //             children: [
                          //               TextSpan(
                          //                 text: 'Enhanced ',
                          //                 style:
                          //                     CustomTextStyle.bodytext.copyWith(
                          //                   fontWeight: FontWeight.w500,
                          //                   fontSize: 14,
                          //                 ),
                          //               ),
                          //               TextSpan(
                          //                 text: 'Profile Visibility ',
                          //                 style:
                          //                     CustomTextStyle.bodytext.copyWith(
                          //                   fontWeight: FontWeight.w600,
                          //                   fontSize: 14,
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }
}
