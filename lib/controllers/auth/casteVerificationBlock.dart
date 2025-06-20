import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/dialogues/logoutDialogoue.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationBlockController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/formtitletag.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class CasteVerificationBlock extends StatelessWidget {
  const CasteVerificationBlock({super.key});

  @override
  Widget build(BuildContext context) {
    String? language = sharedPreferences?.getString("Language");

    final CasteVerificationBlockController casteVerificationBlockController =
        Get.find<CasteVerificationBlockController>();
    print("THIS IS DATA REDIRECT");
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
                    ? 'Are you sure you want to exit the app?'
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
        return shouldExit ??
            false; // Return whether the user wants to exit or not
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              // Top Section
              Align(
                  alignment: Alignment.topCenter,
                  child: FormsTitleTag(
                    pageName: "dashBoard",
                    title: language == "en"
                        ? "Verification Underway"
                        : "व्हेरिफिकेशन प्रक्रिया",
                    arrowback: false,
                  )),

              // Centered Image
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Image.network(
                        casteVerificationBlockController.popup["imgUrl"],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              // Positioned RichText at the bottom of the screen
              Positioned(
                  bottom: 20.0, // Distance from the bottom of the screen
                  left: 0,
                  right: 0,
                  child: language == "en"
                      ? Center(
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
                                    height: 1.5, // Adjust height for spacing
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "मदतीसाठी दिलेल्या ई-मेल वर संपर्क करा ",
                              style: CustomTextStyle.bodytext.copyWith(
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
                                  text:
                                      "\n वर संपर्क साधा. सपोर्ट वेळ : \n सकाळी 9:30 ते संध्याकाळी 6:30.",
                                  style: CustomTextStyle.bodytext.copyWith(
                                    height: 1.5, // Adjust height for spacing
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
            ],
          ),
        ),
      ),
    );
  }
}
