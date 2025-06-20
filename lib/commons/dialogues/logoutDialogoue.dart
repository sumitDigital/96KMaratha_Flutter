import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/auth/logoutController.dart';
import 'package:_96kuliapp/languageSelectScreen.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/screens/auth_Screens/loginScreen2.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Logout extends StatelessWidget {
  const Logout({
    super.key,
    required this.page,
  });
  final String page;
  @override
  Widget build(BuildContext context) {
    final LogoutController logoutController = Get.put(LogoutController());
    String? language = sharedPreferences?.getString("Language");
    if (page == "regularPlanPage") {
      return AlertDialog(
        insetPadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: Image.asset("assets/logoutPop.png"),
              ),
              const SizedBox(
                  height: 10), // Space between the icon and the title
              Text(
                language == "en"
                    ? 'Are you sure you want to log out?'
                    : "तुम्हाला खात्री आहे का की तुम्ही लॉग आउट करू इच्छिता?",
                // AppLocalizations.of(context)!
                //     .areYouSureYouWantToLogoutOnIncompleteForms,
                textAlign: TextAlign.center,
                style: CustomTextStyle.bodytext
                    .copyWith(letterSpacing: 0.5, fontSize: 16),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 10.0), // Padding at the bottom of the buttons
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(() {
                      if (logoutController.isLoading.value) {
                        return TextButton(
                          onPressed: null,
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
                          child: const CircularProgressIndicator(
                              color: Colors.white),
                        );
                      } else {
                        return TextButton(
                          onPressed: () async {
                            logoutController.logout().then((value) async {
                              String? language =
                                  sharedPreferences!.getString("Language");
                              Get.deleteAll();
                              await sharedPreferences?.clear();
                              sharedPreferences?.setString(
                                  "Language", language ?? "mr");
                              navigatorKey.currentState!.pushAndRemoveUntil(
                                MaterialPageRoute(
                                  maintainState: false,
                                  builder: (context) =>
                                      const LanguageSelectScreen(),
                                ),
                                (route) => false,
                              );
                            });
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
                          child: Text(
                              // 'Yes , Log Out',
                              AppLocalizations.of(context)!.yesLogout,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        );
                      }
                    }),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        child: Text(
                            // 'NO STAY',
                            AppLocalizations.of(context)!.noStay,
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(80, 93, 126, .66))),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else if (page == "offerPlanPage") {
      return AlertDialog(
        insetPadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: Image.asset("assets/logoutPop.png"),
              ),
              const SizedBox(
                  height: 10), // Space between the icon and the title
              Text(
                'Are you sure you want to log out?',
                textAlign: TextAlign.center,
                style: CustomTextStyle.bodytext
                    .copyWith(letterSpacing: 0.5, fontSize: 16),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 10.0), // Padding at the bottom of the buttons
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(() {
                      if (logoutController.isLoading.value) {
                        return TextButton(
                          onPressed: null,
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
                          child: const CircularProgressIndicator(
                              color: Colors.white),
                        );
                      } else {
                        return TextButton(
                          onPressed: () async {
                            logoutController.logout().then((value) async {
                              //  String? language =  sharedPreferences!.getString("Language");
                              Get.deleteAll();
                              await sharedPreferences?.clear();
                              //        sharedPreferences?.setString("Language", language!);
                              navigatorKey.currentState!.pushAndRemoveUntil(
                                MaterialPageRoute(
                                  maintainState: false,
                                  builder: (context) =>
                                      const LanguageSelectScreen(),
                                ),
                                (route) => false,
                              );
                            });
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
                          child: const Text('Yes , Log Out',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        );
                      }
                    }),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        child: Text('NO, STAY',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(80, 93, 126, .66))),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else if (page == "dashBoard") {
      return AlertDialog(
        insetPadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: Image.asset("assets/logoutPop.png"),
              ),
              const SizedBox(
                  height: 10), // Space between the icon and the title
              Text(
                // 'Are you sure you want to log out?',
                AppLocalizations.of(context)!
                    .areYouSureYouWantToLogoutOnIncompleteForms,
                textAlign: TextAlign.center,
                style: CustomTextStyle.bodytext
                    .copyWith(letterSpacing: 0.5, fontSize: 16),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 10.0), // Padding at the bottom of the buttons
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(() {
                      if (logoutController.isLoading.value) {
                        return TextButton(
                          onPressed: null,
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
                          child: const CircularProgressIndicator(
                              color: Colors.white),
                        );
                      } else {
                        return TextButton(
                          onPressed: () async {
                            logoutController.logout().then((value) async {
                              String? language =
                                  sharedPreferences!.getString("Language");
                              Get.deleteAll();
                              await sharedPreferences?.clear();
                              sharedPreferences?.setString(
                                  "Language", language ?? "mr");
                              navigatorKey.currentState!.pushAndRemoveUntil(
                                MaterialPageRoute(
                                  maintainState: false,
                                  builder: (context) =>
                                      const LanguageSelectScreen(),
                                ),
                                (route) => false,
                              );
                            });
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
                          child: Text(
                              // 'Yes , Log Out',
                              AppLocalizations.of(context)!.yesLogout,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        );
                      }
                    }),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        child: Text(
                            // 'NO, STAY',
                            AppLocalizations.of(context)!.noStay,
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(80, 93, 126, .66))),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else if (page == "incompleteForms") {
      return AlertDialog(
        insetPadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: Image.asset("assets/logoutPop.png"),
              ),
              const SizedBox(
                  height: 10), // Space between the icon and the title
              Text(
                AppLocalizations.of(context)!
                    .areYouSureYouWantToLogoutOnIncompleteForms,
                textAlign: TextAlign.center,
                style: CustomTextStyle.bodytext
                    .copyWith(letterSpacing: 0.5, fontSize: 16),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 10.0), // Padding at the bottom of the buttons
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(() {
                      if (logoutController.isLoading.value) {
                        return TextButton(
                          onPressed: null,
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
                          child: const CircularProgressIndicator(
                              color: Colors.white),
                        );
                      } else {
                        return TextButton(
                          onPressed: () async {
                            logoutController.logout().then((value) async {
                              String? language =
                                  sharedPreferences!.getString("Language");
                              Get.deleteAll();
                              await sharedPreferences?.clear();
                              sharedPreferences?.setString(
                                  "Language", language ?? "mr");
                              navigatorKey.currentState!.pushAndRemoveUntil(
                                MaterialPageRoute(
                                  maintainState: false,
                                  builder: (context) =>
                                      const LanguageSelectScreen(),
                                ),
                                (route) => false,
                              );
                            });
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
                          child: Text(AppLocalizations.of(context)!.yesLogout,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        );
                      }
                    }),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        child: Text(AppLocalizations.of(context)!.noStay,
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(80, 93, 126, .66))),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return AlertDialog(
        insetPadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: Image.asset("assets/logoutPop.png"),
              ),
              const SizedBox(
                  height: 10), // Space between the icon and the title
              Text(
                AppLocalizations.of(context)!.areYouSureYouWantToLogout,
                textAlign: TextAlign.center,
                style: CustomTextStyle.bodytext
                    .copyWith(letterSpacing: 0.5, fontSize: 16),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 10.0), // Padding at the bottom of the buttons
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(() {
                      if (logoutController.isLoading.value) {
                        return TextButton(
                          onPressed: null,
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
                          child: const CircularProgressIndicator(
                              color: Colors.white),
                        );
                      } else {
                        return TextButton(
                          onPressed: () async {
                            logoutController.logout().then((value) async {
                              String? language =
                                  sharedPreferences!.getString("Language");
                              Get.deleteAll();
                              await sharedPreferences?.clear();
                              sharedPreferences?.setString(
                                  "Language", language!);
                              navigatorKey.currentState!.pushAndRemoveUntil(
                                MaterialPageRoute(
                                  maintainState: false,
                                  builder: (context) =>
                                      const LanguageSelectScreen(),
                                ),
                                (route) => false,
                              );
                              // await sharedPreferences?.setString("Language", "en");
                            });
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
                          child: Text(AppLocalizations.of(context)!.yesLogout,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        );
                      }
                    }),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        child: Text(AppLocalizations.of(context)!.noStay,
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(80, 93, 126, .66))),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
