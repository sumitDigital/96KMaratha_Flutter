import 'dart:convert';

import 'package:_96kuliapp/screens/plans/upgradeScreen.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/screens/auth_Screens/loginScreen2.dart';
import 'package:_96kuliapp/screens/auth_Screens/registerScreen.dart';
import 'package:_96kuliapp/screens/exploreAppScreens/exploreAppBeforeLogin/exploreAppForm.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final WelcomeController welcomeController = Get.put(WelcomeController());

  final WelcomeControllerData welcomeControllerdata =
      Get.put(WelcomeControllerData());

  final FirebaseDatabase database = FirebaseDatabase.instance;
  String? language = sharedPreferences?.getString("Language");

  @override
  Widget build(BuildContext context) {
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    final facebookAppEvents = FacebookAppEvents();
    print("THIS IS LANGUAGE SELDECTED $language");
    // Reference to the "exploreAppEnabled" flag in Firebase Realtime Database
    DatabaseReference exploreAppEnabledRef =
        database.ref('settings/exploreAppEnabled');
    print("THIS IS MY REFERENCE $exploreAppEnabledRef");
    database.ref('settings/exploreAppEnabled').get().then((value) {
      print("Value fetched: ${value.value}");
    }).catchError((error) {
      print("Error fetching value: $error");
    });
    return Scaffold(
      body: Stack(
        children: [
          // PageView with the sliding images
          PageView(
            controller: welcomeController.pageController,
            onPageChanged: welcomeController.onPageChanged,
            children: language == "en"
                ? [
                    Image.asset(
                      'assets/welcome-screen-mr1.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Image.asset(
                      'assets/welcome-screen-en2.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Image.asset(
                      'assets/welcome-screen-en3.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Image.asset(
                      'assets/welcome-screen-en4.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ]
                : [
                    Image.asset(
                      'assets/welcome-screen-mr1.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Image.asset(
                      'assets/welcome-screen-mr2.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Image.asset(
                      'assets/welcome-screen-mr3.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Image.asset(
                      'assets/welcome-screen-mr4.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ],
          ),
          // Positioned widget for buttons and animated dots
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // "Register Now" Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 45.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          backgroundColor: Colors.white),
                      onPressed: () {
                        print("Language is this $language");
                        //                 analytics.logEvent(name: "Welcome_Screen_Registration_Button_Click" );
                        //  facebookAppEvents.logEvent(name: "Welcome_Screen_Registration_Button_Click");
                        navigatorKey.currentState!.push(MaterialPageRoute(
                          builder: (context) => const ExploreAppForm(),
                        ));
                        // Replace with AppRouteNames.loginScreen2 if available
                      },
                      child: Text(AppLocalizations.of(context)!.exploreProfiles,
                          style: CustomTextStyle.elevatedButtonRed.copyWith(
                              fontSize:
                                  18) // Replace with your `CustomTextStyle.elevatedButton`
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Buttons Row with Firebase Realtime Database integration
                /*    Obx(() {
                    bool isExploreAppEnabled = welcomeControllerdata.exploreAppEnabled.value;
                  if(isExploreAppEnabled == true){
 return Padding(

                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // "Explore App" Button (conditionally shown)
                            Flexible(
                              child: SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    side: BorderSide(
                                      width: 1,
                                      color: AppTheme.primaryColor,
                                    ),
                                    minimumSize: const Size(0, 45),
                                  ),
                                  onPressed: () {
                                    analytics.logEvent(name: "Before_Login_Explore_App_Button_Click");
                                    facebookAppEvents.logEvent(name: "Before_Login_Explore_App_Button_Click");
                                    navigatorKey.currentState!.push(
                                      MaterialPageRoute(
                                        builder: (context) => const ExploreAppForm(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Explore App",
                                    style: CustomTextStyle.elevatedButton
                                        .copyWith(color: AppTheme.primaryColor),
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(width: 10),
                          // "Login" Button
                          Flexible(
                            child: SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  side: BorderSide(
                                    width: 1,
                                    color: AppTheme.primaryColor,
                                  ),
                                  minimumSize: const Size(0, 45),
                                ),
                                onPressed: () {
                                  analytics.logEvent(name: "Welcome_Screen_Login_Button_Click");
                                  facebookAppEvents.logEvent(name: "Welcome_Screen_Login_Button_Click");
                                  navigatorKey.currentState!.push(
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen2(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Login",
                                  style: CustomTextStyle.elevatedButton
                                      .copyWith(color: AppTheme.primaryColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                );
                  }else{
return Padding(

                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // "Explore App" Button (conditionally shown)
                           
                          // "Login" Button
                          Flexible(
                            child: SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  side: BorderSide(
                                    width: 1,
                                    color: AppTheme.primaryColor,
                                  ),
                                  minimumSize: const Size(0, 45),
                                ),
                                onPressed: () {
                                  analytics.logEvent(name: "Welcome_Screen_Login_Button_Click");
                                  facebookAppEvents.logEvent(name: "Welcome_Screen_Login_Button_Click");
                                  navigatorKey.currentState!.push(
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen2(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Login",
                                  style: CustomTextStyle.elevatedButton
                                      .copyWith(color: AppTheme.primaryColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                );
                  }
                },),
          
          */

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceEvenly, // Distribute buttons evenly
                    children: [
                      Flexible(
                        child: SizedBox(
                          width: double
                              .infinity, // Make button fill available space
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              side: const BorderSide(
                                width: 1,
                                color: Colors.white,
                              ), // Border color
                              minimumSize:
                                  const Size(0, 45), // Set the height to 50
                            ),
                            onPressed: () {
                              debugPrint("THIS IS LANGUAGE ");
                              analytics.logEvent(
                                  name: "app_96k_welcome_screen_view");
                              facebookAppEvents.logEvent(
                                  name: "Fb_96k_app_welcome_screen_view");
                              navigatorKey.currentState!.push(
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                              // Your first button action
                            },
                            child: FittedBox(
                              child: Text(
                                  AppLocalizations.of(context)!.registerNow,
                                  style: CustomTextStyle.elevatedButton
                                      .copyWith(color: Colors.white)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20), // Add spacing between buttons
                      Flexible(
                        child: SizedBox(
                          width: double
                              .infinity, // Make button fill available space
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              side: const BorderSide(
                                width: 1,
                                color: Colors.white,
                              ), // Border color
                              minimumSize:
                                  const Size(0, 45), // Set the height to 50
                            ),
                            onPressed: () {
                              // Your second button action

                              // navigatorKey.currentState!.push(
                              //   MaterialPageRoute(
                              //       builder: (context) => UpgradePlan()),
                              // );
                              navigatorKey.currentState!.push(
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen2()),
                              );
                            },
                            child: Text(AppLocalizations.of(context)!.login,
                                style: CustomTextStyle.elevatedButton
                                    .copyWith(color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Animated Dots
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          height: 10,
                          width: welcomeController.currentPage.value == index
                              ? 20
                              : 10,
                          decoration: BoxDecoration(
                            color: welcomeController.currentPage.value == index
                                ? Colors.white
                                : Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        );
                      }),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WelcomeController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  @override
  void onInit() {
    super.onInit();
    autoSlide();
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void autoSlide() {
    Future.delayed(const Duration(seconds: 5), () {
      if (pageController.hasClients) {
        if (currentPage.value < 2) {
          pageController.nextPage(
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeInOut,
          );
        } else {
          // Directly jump to the first page without showing the middle
          currentPage.value = 0;
          pageController.jumpToPage(0); // Instantly switch to the first page
        }
      }
      autoSlide(); // Continue the loop
    });
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class WelcomeControllerData extends GetxController {
  RxBool exploreAppEnabled = false.obs;

  final FirebaseDatabase database = FirebaseDatabase.instance;
  late DatabaseReference exploreAppEnabledRef;

  @override
  void onInit() {
    super.onInit();
    exploreAppEnabledRef = database.ref('settings/exploreAppEnabled');
    fetchExploreAppEnabled();
  }

  // Method to fetch the value from Firebase
  void fetchExploreAppEnabled() async {
    try {
      final DataSnapshot snapshot = await exploreAppEnabledRef.get();
      exploreAppEnabled.value = snapshot.value as bool? ?? false;
      print("Explore App Enabled:we ${exploreAppEnabled.value}");
    } catch (e) {
      print("Error fetching exploreAppEnabled: $e");
    }
  }
}
