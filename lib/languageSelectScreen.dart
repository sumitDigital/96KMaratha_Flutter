// ignore_for_file: deprecated_member_use

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/auth/languageChangeController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/screens/onboarding/welcomeScreen.dart';
import 'package:_96kuliapp/screens/userInfoForms/pendingForms/userinfoIncompleteForm.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:math';

class LanguageSelectScreen extends StatefulWidget {
  const LanguageSelectScreen({super.key});

  @override
  State<LanguageSelectScreen> createState() => _LanguageSelectScreenState();
}

class _LanguageSelectScreenState extends State<LanguageSelectScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat(); // Continuous rotation
    // Show the dialog when the screen loads
    Future.delayed(Duration.zero, () {
      showLanguageDialog();
    });
  }

  void showLanguageDialog() {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            SystemNavigator.pop(); // Or exit(0);
            return false;
          },
          child: SimpleDialog(
            backgroundColor: Colors.white,
            titlePadding: EdgeInsets.zero, // Removes default padding
            title: Container(
              // rgba(204, 40, 77, 0.13)
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  vertical: 16), // Add padding for spacing
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(204, 40, 77, 0.13),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)!.selectLanguage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: "WORKSANSMEDIUM",
                      fontSize: 18,
                      color: Color.fromRGBO(9, 39, 73, 1),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      AppLocalizations.of(context)!
                          .selectYourLanguagePreferance,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: "WORKSANS",
                        fontSize: 14,
                        color: Color.fromRGBO(9, 39, 73, 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            children: [
              Consumer<LanguageChangeController>(
                builder: (context, value, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      // English Language Selection
                      InkWell(
                        onTap: () {
                          //  sharedPreferences?.setString("language", "en");
                          Provider.of<LanguageChangeController>(context,
                                  listen: false)
                              .changeLanguage(const Locale('en'));
                          analytics.logEvent(
                              name: 'Welcome_Screen_Eng_Language_Select');
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              child: SizedBox(
                                height: 30, // Adjust height as needed
                                width: 30, // Adjust width as needed
                                child: Radio(
                                  fillColor: WidgetStateProperty.all(
                                      AppTheme.primaryColor),
                                  value: "en",
                                  groupValue:
                                      Provider.of<LanguageChangeController>(
                                              context)
                                          .appLocale
                                          ?.languageCode,
                                  onChanged: (newValue) {
                                    //  sharedPreferences?.setString("language", "en");
                                    Provider.of<LanguageChangeController>(
                                            context,
                                            listen: false)
                                        .changeLanguage(const Locale('en'));
                                  },
                                ),
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.english,
                              style: const TextStyle(
                                fontFamily: "WORKSANSMEDIUM",
                                fontSize: 14,
                                color: Color.fromRGBO(9, 39, 73, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Marathi Language Selection
                      const SizedBox(
                        height: 5,
                      ),
                      InkWell(
                        onTap: () {
                          //   sharedPreferences?.setString("language", "mr");
                          Provider.of<LanguageChangeController>(context,
                                  listen: false)
                              .changeLanguage(const Locale('mr'));
                          analytics.logEvent(
                              name: 'Welcome_Screen_Marathi_Language_Select');
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: SizedBox(
                                height: 30, // Adjust height as needed
                                width: 30, // Adjust width as needed
                                child: Radio(
                                  fillColor: WidgetStateProperty.all(
                                      AppTheme.primaryColor),
                                  value: "mr",
                                  groupValue:
                                      Provider.of<LanguageChangeController>(
                                              context)
                                          .appLocale
                                          ?.languageCode,
                                  onChanged: (newValue) {
                                    //   sharedPreferences?.setString("language", "mr");
                                    Provider.of<LanguageChangeController>(
                                            context,
                                            listen: false)
                                        .changeLanguage(const Locale('mr'));
                                  },
                                ),
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.marathi,
                              style: const TextStyle(
                                fontFamily: "WORKSANSMEDIUM",
                                fontSize: 16,
                                color: Color.fromRGBO(9, 39, 73, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Continue button
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                          ),
                          onPressed: () {
                            // navigatorKey.currentState!.pushAndRemoveUntil(
                            //   MaterialPageRoute(
                            //       builder: (context) =>
                            //           const userIncomplete_InfoUser()),
                            //   (route) => false,
                            // );
                            navigatorKey.currentState!.pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => WelcomeScreen()),
                              (route) => false,
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context)!.save,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: "WORKSANS",
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(204, 40, 77, 1), // Background color
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // showLanguageDialog();
            // Top Rotation
            Positioned(
              top: -175, // Move half of the circle outside the top
              left: MediaQuery.of(context).size.width / 2 -
                  175, // Center horizontally
              child: AnimatedBuilder(
                animation: _rotationController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationController.value *
                        2 *
                        pi, // Full rotation (2π)
                    child: child,
                  );
                },
                child: Container(
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
            ),
            // Bottom Rotation
            Positioned(
              bottom: -175, // Move half of the circle outside the screen
              left: MediaQuery.of(context).size.width / 2 -
                  175, // Center horizontally
              child: AnimatedBuilder(
                animation: _rotationController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationController.value *
                        2 *
                        pi, // Full rotation (2π)
                    child: child,
                  );
                },
                child: Container(
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
            ),
          ],
        ),
      ),
    );
  }
}
