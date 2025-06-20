import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:_96kuliapp/commons/dialogues/logoutDialogoue.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/auth/casteverificationFetch.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/screens/auth_Screens/loginScreen2.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:_96kuliapp/screens/userInfoForms/userinfoStepSix.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/formHeader.dart';
import 'package:_96kuliapp/utils/formheaderbasic.dart';
import 'package:_96kuliapp/utils/formtitletag.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class CasteVerificationScreen extends StatelessWidget {
  const CasteVerificationScreen({super.key});
// final StepSixController _stepsixController = Get.put(StepSixController());
  @override
  Widget build(BuildContext context) {
    String? language = sharedPreferences?.getString("Language");

    final CasteVerificationData casteVerificationData =
        Get.put(CasteVerificationData());
    casteVerificationData.fetcheDataFromApi();
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
                        child: const Text('Yes',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pop(false); // User doesn't want to exit
                          //Get.back();
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
        return shouldExit ??
            false; // Return whether the user wants to exit or not
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(child: Obx(
            () {
              if (casteVerificationData.isloading.value) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Caste Verification",
                                  style: CustomTextStyle.bodytextLarge,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      StepsFormHeaderBasic(
                        title: "Caste Verification",
                        desc: "",
                        image: "assets/formstep1.png",
                        statusPercent: "20%",
                        statusdesc: "Update profile & boost visibility by",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormsTitleTag(
                        pageName: "dashBoard",
                        title: AppLocalizations.of(context)!.casteVerification,
                        arrowback: false),
                    Obx(
                      () {
                        return StepsFormHeaderBasic(
                          endhour: 0,
                          endminutes: 0,
                          endseconds: 0,
                          //  verificationStatus: "${_casteVerificationData.data["verification_status"]}",
                          title: "${casteVerificationData.data["heading"]}",
                          desc: "${casteVerificationData.data["message"]}",
                          image: "assets/CasteScreen1.png",
                          statusdesc: "",
                          statusPercent: "",
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                        child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: const Color.fromARGB(255, 7, 150, 4)
                                    .withOpacity(0.09),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      textAlign: TextAlign.center,
                                      AppLocalizations.of(context)!
                                          .chooseOneDocument,
                                      style: CustomTextStyle.bodytext.copyWith(
                                          fontSize: 16,
                                          color: const Color.fromARGB(
                                              255, 20, 113, 18),
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "1) ${AppLocalizations.of(context)!.casteCertificate}",
                                      textAlign: TextAlign.left,
                                      style: CustomTextStyle.bodytext.copyWith(
                                          fontSize: 11,
                                          color: const Color.fromARGB(
                                              255, 10, 80, 9),
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "2) ${AppLocalizations.of(context)!.schoolCollegeLeavingCertificate}",
                                      textAlign: TextAlign.left,
                                      style: CustomTextStyle.bodytext.copyWith(
                                          fontSize: 11,
                                          color: const Color.fromARGB(
                                              255, 10, 80, 9),
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "3) ${AppLocalizations.of(context)!.anyDocumentMentioningName}",
                                      textAlign: TextAlign.left,
                                      style: CustomTextStyle.bodytext.copyWith(
                                          fontSize: 11,
                                          color: const Color.fromARGB(
                                              255, 10, 80, 9),
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "4) ${AppLocalizations.of(context)!.documentMentioningBloodRelation}",
                                      textAlign: TextAlign.left,
                                      style: CustomTextStyle.bodytext.copyWith(
                                          fontSize: 11,
                                          color: const Color.fromARGB(
                                              255, 10, 80, 9),
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          UploadManually(),
                          language == "en"
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text: "Need assistance? Reach out at ",
                                        style:
                                            CustomTextStyle.bodytext.copyWith(
                                          letterSpacing: 0.5,
                                          height:
                                              1.5, // Adjust height for spacing
                                        ),
                                        children: [
                                          TextSpan(
                                            text:
                                                "info@96kulimarathamarriage.com",
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
                                            text: "Support time: 10 am to 6 pm",
                                            style: CustomTextStyle.bodytext
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
                                    padding: const EdgeInsets.all(18.0),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text:
                                            "तुमच्या मदतीसाठी आम्ही आहोत! आमच्याशी ",
                                        style:
                                            CustomTextStyle.bodytext.copyWith(
                                          height:
                                              1.5, // Adjust height for spacing
                                        ),
                                        children: [
                                          TextSpan(
                                            text:
                                                "info@96kulimarathamarriage.com",
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
                                            style: CustomTextStyle.bodytext
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
                    ))
                  ],
                );
              }
            },
          )),
        ),
      ),
    );
  }
}
