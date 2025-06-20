import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/commons/dialogues/apidialogues/addonPLanDialogue.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/planControllers/addOnPLanController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/bottomnavBar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PaymentController extends GetxController {
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

Future<void> sendPaymentData(
    {required int addonPlanID,
    required String orderID,
    required String paymentID,
    required String signature}) async {
  print("INSEIDE PAYMENT SEND");
  String? token = sharedPreferences?.getString("token");
  // Define the URL for the API endpoint
  String url = '${Appconstants.baseURL}/api/addon-plan/razorpay-payment';

  // Define the request body with your parameters
  Map<String, dynamic> requestBody = {
    "member_token": "$token",
    "addon_plan_id": addonPlanID,
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

class Addonplan extends StatefulWidget {
  const Addonplan({super.key});

  @override
  State<Addonplan> createState() => _AddonplanState();
}

class _AddonplanState extends State<Addonplan> {
  final AddOnPlanController _addOnPlanController =
      Get.put(AddOnPlanController());
  final PaymentController _paymentController = Get.put(PaymentController());
  final Razorpay _razorpay = Razorpay();
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final facebookAppEvents = FacebookAppEvents();

  @override
  void initState() {
    super.initState();
    // Initialize razorpay listeners once
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);

    // Fetch addon plans
    _addOnPlanController.fetchAddonPlans();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment success: ${response.paymentId}");
    // Process payment success

    sendPaymentData(
      addonPlanID: _addOnPlanController.selectedaddonPlanID.value,
      orderID: response.orderId.toString(),
      paymentID: response.paymentId.toString(),
      signature: response.signature.toString(),
    );
    facebookAppEvents.logEvent(
        name: "Fb_app_Addon_plan_purchase_sucessful",
        parameters: {
          'PlanID': '${_addOnPlanController.selectedaddonPlanID.value}'
        });
    analytics.logEvent(
        name: "app_Addon_plan_purchase_successfully",
        parameters: {
          'PlanID': '${_addOnPlanController.selectedaddonPlanID.value}'
        });
    // Reset the flag after payment is processed

    _paymentController.resetPaymentState();
    navigatorKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const BottomNavBar(),
      ),
      (route) => false,
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      Get.dialog(const AddonPlanDialogue(), barrierDismissible: false);
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment failed: ${response.message}");
    // Reset the flag after payment fails
    _paymentController.resetPaymentState();
    facebookAppEvents.logEvent(
        name: "Fb_96k_app_Addon_plan_purchase_failed",
        parameters: {
          'PlanID': '${_addOnPlanController.selectedaddonPlanID.value}'
        });
    analytics.logEvent(name: "app_Addon_plan_purchase_failed", parameters: {
      'PlanID': '${_addOnPlanController.selectedaddonPlanID.value}'
    });
  }

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
        if (navigatorKey.currentState!.canPop()) {
          Get.back(); // Navigates back to the previous screen
        } else {
          navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
            builder: (context) => const BottomNavBar(),
          ));
        }
        // Execute actions before the back button is pressed

        return false; // Allows the navigation to happen
      },
      child: Scaffold(
        body: SafeArea(
          child: Obx(() {
            if (_addOnPlanController.isLoading.value == true) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        color: Colors.white, // Placeholder color
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        color: Colors.white, // Placeholder color
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        color: Colors.white, // Placeholder color
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  //  Get.offNamed(AppRouteNames.userInfoStepOne);
                                  if (navigatorKey.currentState!.canPop()) {
                                    Get.back(); // Navigates back to the previous screen
                                  } else {
                                    navigatorKey.currentState!
                                        .pushReplacement(MaterialPageRoute(
                                      builder: (context) =>
                                          const BottomNavBar(),
                                    ));
                                  }
                                  // Execute actions before the back button is pressed
                                },
                                child: SizedBox(
                                  width: 25,
                                  height: 20,
                                  child: SvgPicture.asset(
                                    "assets/arrowback.svg",
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "Addon Contact",
                                style: CustomTextStyle.bodytextLarge,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/addonHeader.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  "Unlock Extra Contacts!!",
                                  style: CustomTextStyle.darkBlueH1,
                                ),
                              ),
                            ),
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 28.0, right: 28, bottom: 10),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  "Increase Your Contact Limit to Add More Weekly Contacts",
                                  style: CustomTextStyle.darkBlueH2,
                                ),
                              ),
                            ),
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 28.0,
                                  right: 28,
                                ),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  "So Why You Are Waiting?",
                                  style: CustomTextStyle.darkBlueH3,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {},
                                child: const Text(
                                  "Get Extra Contacts Now..!",
                                  style:
                                      CustomTextStyle.elevatedButtonSmallBOLD,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _addOnPlanController.addonPlans.length,
                            itemBuilder: (context, index) {
                              final plan =
                                  _addOnPlanController.addonPlans[index];
                              return Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 245, 248, 250)),
                                margin: const EdgeInsets.only(bottom: 8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    const TextSpan(
                                                        text: "WEEKLY",
                                                        style: CustomTextStyle
                                                            .darkBlueLightSmall),
                                                    TextSpan(
                                                        text:
                                                            " ${plan["contact_increase_per_week"]} CONTACTS ",
                                                        style: CustomTextStyle
                                                            .darkBlueDarkSmall),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                "FOR ${plan["total_Weeks"]} WEEKS",
                                                style:
                                                    CustomTextStyle.darkBlueH3,
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                            child: RichText(
                                              textAlign: TextAlign.end,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "₹",
                                                    style: CustomTextStyle
                                                        .darkBlueDarkSmall
                                                        .copyWith(
                                                            fontSize:
                                                                18), // Match font size to price
                                                  ),
                                                  WidgetSpan(
                                                    alignment:
                                                        PlaceholderAlignment
                                                            .baseline,
                                                    baseline:
                                                        TextBaseline.alphabetic,
                                                    child: Text(
                                                      "${plan["total_contact_price"]}",
                                                      style: CustomTextStyle
                                                          .darkBlueH1Large,
                                                    ),
                                                  ),
                                                  plan["show_gst"] == true
                                                      ? const TextSpan(
                                                          text: "(+GST) ",
                                                          style: CustomTextStyle
                                                              .darkBluelightextraSmall,
                                                        )
                                                      : const TextSpan(
                                                          text: "",
                                                          style: CustomTextStyle
                                                              .darkBluelightextraSmall,
                                                        )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(color: AppTheme.dividerDarkColor),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 4.0),
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              const TextSpan(
                                                  text: "View Total Numbers ",
                                                  style: CustomTextStyle
                                                      .darkGreylightextraSmall),
                                              TextSpan(
                                                  text:
                                                      "${plan["total_contact"]} Contact ",
                                                  style: CustomTextStyle
                                                      .darkGreyDarkextraSmall),
                                              const TextSpan(
                                                  text: "Numbers",
                                                  style: CustomTextStyle
                                                      .darkGreylightextraSmall),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 12.0),
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              const TextSpan(
                                                  text: "Get Numbers ",
                                                  style: CustomTextStyle
                                                      .darkGreylightextraSmall),
                                              TextSpan(
                                                  text:
                                                      "Weekly ${plan["contact_increase_per_week"]} Contact ",
                                                  style: CustomTextStyle
                                                      .darkGreyDarkextraSmall),
                                              const TextSpan(
                                                  text: "Numbers",
                                                  style: CustomTextStyle
                                                      .darkGreylightextraSmall),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        "Note: This add-on contacts is valid until the duration of your Premium plan.",
                                        style: CustomTextStyle
                                            .darkGreylightextraextraSmall,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: _paymentController
                                                  .isPaymentInProgress.value
                                              ? null
                                              : () {
                                                  _paymentController
                                                      .startPayment(); // Start payment

                                                  _addOnPlanController
                                                          .selectedaddonPlanID
                                                          .value =
                                                      plan["addon_plan_id"];
                                                  var options = {
                                                    'key':
                                                        '${_addOnPlanController.userRazorPayKey}',
                                                    'amount':
                                                        '${plan["total_contact_price_with_GST"]}',
                                                    'order_id':
                                                        '${plan["razorpay_order_id"]}',
                                                    'name':
                                                        '96 Kuli Maratha Marriage',
                                                    'description':
                                                        'Add On Contacts',
                                                  };
                                                  _razorpay.open(options);
                                                },
                                          icon: SizedBox(
                                            height: 15,
                                            child: Image.asset(
                                                "assets/premium1.png"),
                                          ),
                                          label: const Text(
                                            "ADD CONTACTS",
                                            style: CustomTextStyle
                                                .elevatedButtonSmall,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 30.0, right: 30.0, top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Center(
                                    child: Text(
                                  "Benifits of Add-On Contacts",
                                  style: CustomTextStyle.darkBlueH2,
                                )),
                                const SizedBox(
                                  height: 5,
                                ),
                                Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Left dot
                                      Container(
                                        width: 5, // Diameter of the dot
                                        height: 5,
                                        decoration: BoxDecoration(
                                          color: AppTheme.selectedOptionColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      // Divider
                                      SizedBox(
                                        width: 80, // Width of the divider
                                        child: Divider(
                                          color: AppTheme.selectedOptionColor,
                                          thickness:
                                              2, // Thickness of the divider
                                        ),
                                      ),
                                      // Right dot
                                      Container(
                                        width: 5, // Diameter of the dot
                                        height: 5,
                                        decoration: BoxDecoration(
                                          color: AppTheme.selectedOptionColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  "Enhanced Weekly Limit",
                                  style: CustomTextStyle.darkGreyDarkMedium,
                                  textAlign: TextAlign.center,
                                ),
                                const Text(
                                  "The Add-On Contact increases your weekly contact viewing limit.",
                                  style: CustomTextStyle
                                      .darkGreylightextraextraSmall,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  "Additional Contacts",
                                  style: CustomTextStyle.darkGreyDarkMedium,
                                  textAlign: TextAlign.center,
                                ),
                                const Text(
                                  "Gain extra contact numbers alongside those provided in your primary plan.",
                                  style: CustomTextStyle
                                      .darkGreylightextraextraSmall,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  "Find Compatibility",
                                  style: CustomTextStyle.darkGreyDarkMedium,
                                  textAlign: TextAlign.center,
                                ),
                                const Text(
                                  "Enjoy more chances to reach out to compatible profiles every week.",
                                  style: CustomTextStyle
                                      .darkGreylightextraextraSmall,
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
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
                            height: 5,
                          ),
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Left dot
                                Container(
                                  width: 5, // Diameter of the dot
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: AppTheme.selectedOptionColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                // Divider
                                SizedBox(
                                  width: 80, // Width of the divider
                                  child: Divider(
                                    color: AppTheme.selectedOptionColor,
                                    thickness: 2, // Thickness of the divider
                                  ),
                                ),
                                // Right dot
                                Container(
                                  width: 5, // Diameter of the dot
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: AppTheme.selectedOptionColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 215, 226, 242)
                                  .withOpacity(0.69),
                              borderRadius: BorderRadius.circular(
                                  8), // Optional: to add rounded corners
                            ),
                            child: ExpansionTile(
                              title: const Text(
                                  "1.What is the Add-On Contacts?",
                                  style: CustomTextStyle.bodytextbold),
                              trailing:
                                  const SizedBox(), // Removes the down arrow icon
                              tilePadding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              children: [
                                Container(
                                  color: Colors.white,
                                  child: const ListTile(
                                    title: Text(
                                      "The Add-On Contact allows you to increase your weekly contact limit and connect with more profiles beyond your main plan",
                                      style: CustomTextStyle.bodytext,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 215, 226, 242)
                                  .withOpacity(0.69),
                              borderRadius: BorderRadius.circular(
                                  8), // Optional: to add rounded corners
                            ),
                            child: ExpansionTile(
                              title: const Text(
                                  "2. Who can purchase an Add-On Contacts ?",
                                  style: CustomTextStyle.bodytextbold),
                              trailing:
                                  const SizedBox(), // Removes the down arrow icon
                              tilePadding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              children: [
                                Container(
                                  color: Colors.white,
                                  child: const ListTile(
                                    title: Text(
                                      "Any user with an active premium subscription can purchase an Add-On Contacts.",
                                      style: CustomTextStyle.bodytext,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 215, 226, 242)
                                  .withOpacity(0.69),
                              borderRadius: BorderRadius.circular(
                                  8), // Optional: to add rounded corners
                            ),
                            child: ExpansionTile(
                              title: const Text(
                                  "3. How does the Add-On Contacts work?",
                                  style: CustomTextStyle.bodytextbold),
                              trailing:
                                  const SizedBox(), // Removes the down arrow icon
                              tilePadding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              children: [
                                Container(
                                  color: Colors.white,
                                  child: const ListTile(
                                    title: Text(
                                      "Once activated, the Add-On Contacts provides additional contact limits alongside your existing plan.",
                                      style: CustomTextStyle.bodytext,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 215, 226, 242)
                                  .withOpacity(0.69),
                              borderRadius: BorderRadius.circular(
                                  8), // Optional: to add rounded corners
                            ),
                            child: ExpansionTile(
                              title: const Text(
                                  "4. How long is the Add-On Contacts valid?",
                                  style: CustomTextStyle.bodytextbold),
                              trailing:
                                  const SizedBox(), // Removes the down arrow icon
                              tilePadding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              children: [
                                Container(
                                  color: Colors.white,
                                  child: const ListTile(
                                    title: Text(
                                      "The Add-On Contacts is valid for the duration of your current premium subscription.",
                                      style: CustomTextStyle.bodytext,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 215, 226, 242)
                                  .withOpacity(0.69),
                              borderRadius: BorderRadius.circular(
                                  8), // Optional: to add rounded corners
                            ),
                            child: ExpansionTile(
                              title: const Text(
                                  "5. Can I use unused Add-On Contacts in the next week?",
                                  style: CustomTextStyle.bodytextbold),
                              trailing:
                                  const SizedBox(), // Removes the down arrow icon
                              tilePadding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              children: [
                                Container(
                                  color: Colors.white,
                                  child: const ListTile(
                                    title: Text(
                                      "Unused contacts from the Add-On Contacts do not roll over to the following week.",
                                      style: CustomTextStyle.bodytext,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 215, 226, 242)
                                  .withOpacity(0.69),
                              borderRadius: BorderRadius.circular(
                                  8), // Optional: to add rounded corners
                            ),
                            child: ExpansionTile(
                              title: const Text(
                                  "6. How can I purchase an Add-On Contacts?",
                                  style: CustomTextStyle.bodytextbold),
                              trailing:
                                  const SizedBox(), // Removes the down arrow icon
                              tilePadding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              children: [
                                Container(
                                  color: Colors.white,
                                  child: const ListTile(
                                    title: Text(
                                      "Simply go to the Add-On Contacts section in your app or website, select your preferred plan, and proceed with payment.",
                                      style: CustomTextStyle.bodytext,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 215, 226, 242)
                                  .withOpacity(0.69),
                              borderRadius: BorderRadius.circular(
                                  8), // Optional: to add rounded corners
                            ),
                            child: ExpansionTile(
                              title: const Text(
                                  "7. Who do I contact if I face issues with the Add-On Contacts?",
                                  style: CustomTextStyle.bodytextbold),
                              trailing:
                                  const SizedBox(), // Removes the down arrow icon
                              tilePadding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              children: [
                                Container(
                                  color: Colors.white,
                                  child: const ListTile(
                                    title: Text(
                                      "Reach out to our customer support team through email",
                                      style: CustomTextStyle.bodytext,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: "Need assistance? Reach out at ",
                                  style: CustomTextStyle.bodytext.copyWith(
                                    letterSpacing: 0.5,
                                    height: 1.5, // Adjust height for spacing
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "info@96kulimarathamarriage.com",
                                      style: TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        height:
                                            1.5, // Ensure the same line height applies here
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          openEmail(
                                              "info@96kulimarathamarriage.com");
                                        },
                                    ),
                                    TextSpan(
                                      text: "\nSupport time: 10 am to 6 pm",
                                      style: CustomTextStyle.bodytext.copyWith(
                                        letterSpacing: 0.5,
                                        height:
                                            1.5, // Adjust height for spacing
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}
