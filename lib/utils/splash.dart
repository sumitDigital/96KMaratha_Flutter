// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:math';

import 'package:app_links/app_links.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/controllers/pageRouteController/pagerouteController.dart';
import 'package:_96kuliapp/firebasenotifications.dart';
import 'package:_96kuliapp/languageSelectScreen.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/screens/editProfile_screens/editBasicInfo.dart';
import 'package:_96kuliapp/screens/editProfile_screens/editEducationForm.dart';
import 'package:_96kuliapp/screens/editProfile_screens/editFamilyDetails.dart';
import 'package:_96kuliapp/screens/editProfile_screens/editLifestyleDetails.dart';
import 'package:_96kuliapp/screens/editProfile_screens/editPersonalInfo.dart';
import 'package:_96kuliapp/screens/editProfile_screens/editSpiritualDetails.dart';
import 'package:_96kuliapp/screens/editProfile_screens/edit_about_me.dart';
import 'package:_96kuliapp/screens/plans/addOnPlan.dart';
import 'package:_96kuliapp/screens/plans/upgradeScreen.dart';
import 'package:_96kuliapp/screens/profile_screens/edit_profile.dart';
import 'package:_96kuliapp/screens/profile_screens/user_details.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/auth_Screens/loginScreen2.dart';
import 'package:_96kuliapp/screens/auth_Screens/registerOTPScreen.dart';
import 'package:_96kuliapp/screens/userInfoForms/userInfoStepOne.dart';
import 'package:_96kuliapp/screens/userInfoForms/userInfoStepTwo.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepFive.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepFour.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepSix.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepThree.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/bottomnavBar.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _shineController;
  late Animation<double> _shineAnimation;
  final NotificationServices _notificationServices = NotificationServices();
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final facebookAppEvents = FacebookAppEvents();

  @override
  void initState() {
    super.initState();

    // Rotating Circle - Slower (15 seconds)
    _rotationController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat(); // Continuous rotation

    // Shine Effect - Faster (2 seconds)
    _shineController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _shineAnimation = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(parent: _shineController, curve: Curves.easeInOut),
    );
    Future.delayed(const Duration(seconds: 2), () {
      handleSplashScreenEnd();
    });

    analytics.logEvent(name: "app_96k_welcome_screen_view");
    facebookAppEvents.logEvent(name: "Fb_96k_app_welcome_screen_view");
  }

  String? language = sharedPreferences?.getString("Language");
  void handleSplashScreenEnd() {
    print("This is Language $language");
    /* if(language != null){
    
  }else{
    navigatorKey.currentState!.pushReplacement(
            MaterialPageRoute(
              builder: (context) => LanguageSelectScreen()
            ),
          );
  }*/
    _notificationServices.firebaseInit(context);
    _notificationServices.setupInteractMessage(context);
    _initDeepLinkListener();

    Future.delayed(Duration.zero, () {
      checkUserTokenAndNavigate();
    });
  }

  Future<void> checkUserTokenAndNavigate() async {
    String? pageIndex = sharedPreferences?.getString("PageIndex");
    print("PAGE INDEX INIT $pageIndex");
    String? token = sharedPreferences?.getString("token");

    if (token == null) {
      // If no token, navigate to the welcome screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LanguageSelectScreen()),
      );
    } else {
      // Navigate based on page index
      switch (pageIndex) {
        case "1":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const RegisterOTPScreen()),
          );
          break;
        case "2":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserInfoStepOne()),
          );
          break;
        case "3":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserInfoStepTwo()),
          );
          break;
        case "4":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserInfoStepThree()),
          );
          break;
        case "5":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserInfoStepFour()),
          );
          break;
        case "6":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserInfoStepFive()),
          );
          break;
        case "7":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserInfoStepSix()),
          );
          break;
        case "8":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavBar()),
          );
          break;
        case "9":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UpgradePlan()),
          );
          break;
        default:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const LanguageSelectScreen()),
          );
          break;
      }
    }
  }

  String? pageIndex = sharedPreferences?.getString("PageIndex");

  void _initDeepLinkListener() async {
    try {
      // Listen for incoming links
      Uri? initialLink = await AppLinks().getInitialLink();
      if (initialLink != null) {
        print('Initial link: ${initialLink.toString()}');

        String? token = sharedPreferences
            ?.getString('token'); // replace 'token' with your key

        // Check if the path matches the format and extract the last segment
        if (token == null) {
          navigatorKey.currentState!.pushReplacement(
            MaterialPageRoute(
                builder: (context) => const LanguageSelectScreen()),
          );
        }
        {
          if (pageIndex == "8") {
            if (initialLink.pathSegments.isNotEmpty &&
                initialLink.path.startsWith("/home/member-detail")) {
              String lastSegment = initialLink.pathSegments.last;
              print("THIS IS LAST $lastSegment");
              // Convert the last segment to an integer if it's a valid number
              int? memberId = int.tryParse(lastSegment);
              print("THIS IS LAST me $memberId");
              if (memberId != null) {
                navigatorKey.currentState!.pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                        UserDetails(memberid: memberId, notificationID: 0),
                  ),
                );
              } else {
                print('Error: Last segment is not a valid number');
              }
            } else if (initialLink.path == "/home/profile") {
              navigatorKey.currentState!.pushReplacement(
                MaterialPageRoute(builder: (context) => const EditProfile()),
              );
            } else if (initialLink.path == "/home/edit/family") {
              navigatorKey.currentState!.pushReplacement(
                MaterialPageRoute(
                    builder: (context) => const EditFamilyDetailsScreen()),
              );
            } else if (initialLink.path == "/home/edit/spiritual") {
              navigatorKey.currentState!.pushReplacement(
                MaterialPageRoute(
                    builder: (context) => const EditSpiritualDetailsScreen()),
              );
            } else if (initialLink.path == "/home/edit/lifestyle") {
              navigatorKey.currentState!.pushReplacement(
                MaterialPageRoute(
                    builder: (context) => const EditLifestyleDetails()),
              );
            } else if (initialLink.path == "/home/edit/introduction") {
              navigatorKey.currentState!.pushReplacement(
                MaterialPageRoute(
                    builder: (context) => const EditAboutMeScreen()),
              );
            }
            // jain_demo/home/edit/personalinfo
            else if (initialLink.path == "/home/edit/personalinfo") {
              navigatorKey.currentState!.pushReplacement(
                MaterialPageRoute(
                    builder: (context) => const EditPersonalInfoScreen()),
              );
            } else if (initialLink.path == "/home/addon-plan") {
              navigatorKey.currentState!.pushReplacement(
                MaterialPageRoute(builder: (context) => const Addonplan()),
              );
            } else if (initialLink.path == "/home/plan") {
              navigatorKey.currentState!.pushReplacement(
                MaterialPageRoute(builder: (context) => const UpgradePlan()),
              );
            } else if (initialLink.path == "/home/edit/basic-info") {
              navigatorKey.currentState!.pushReplacement(
                MaterialPageRoute(
                    builder: (context) => const EditBasicInfoScreen()),
              );
            }
          } else {}
        }
      }
    } catch (e) {
      print('Error handling deep link: $e');
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _shineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(204, 40, 77, 1), // Background color
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Rotating Circular Image (15 seconds rotation)
            AnimatedBuilder(
              animation: _rotationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationController.value * 6.28, // Full rotation (2π)
                  child: child,
                );
              },
              child: AnimatedContainer(
                duration: const Duration(seconds: 2),
                width: 350,
                height: 350,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/splashbg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Shining Effect on Logo (2 seconds shine effect)
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0.0, end: 300.0),
              duration: const Duration(milliseconds: 800),
              builder: (context, value, child) {
                return Container(
                  child: AnimatedBuilder(
                    animation: _shineAnimation,
                    builder: (context, child) {
                      return ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              const Color.fromRGBO(204, 40, 77, 1)
                                  .withOpacity(0.2),
                              const Color.fromRGBO(204, 40, 77, 1),
                              const Color.fromRGBO(204, 40, 77, 1)
                                  .withOpacity(0.2),
                            ],
                            stops: [
                              _shineAnimation.value - 0.3,
                              _shineAnimation.value,
                              _shineAnimation.value + 0.3
                            ],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.srcATop,
                        child: Image.asset(
                          'assets/96klogo.png',
                          width: value,
                          height: value,
                        ),
                      );
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
