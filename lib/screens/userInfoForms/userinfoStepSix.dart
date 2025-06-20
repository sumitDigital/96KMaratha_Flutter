import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:_96kuliapp/commons/dialogues/logoutDialogoue.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/auth/casteverificationFetch.dart';
import 'package:_96kuliapp/controllers/userform/formstep6Controller.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/auth_Screens/loginScreen2.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/buttonContainer.dart';
import 'package:_96kuliapp/utils/customtextform.dart';
import 'package:_96kuliapp/utils/formHeader.dart';
import 'package:_96kuliapp/utils/formheaderbasic.dart';
import 'package:_96kuliapp/utils/formtitletag.dart';
import 'package:_96kuliapp/utils/selectlanguage.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class UserInfoStepSix extends StatefulWidget {
  const UserInfoStepSix({super.key});

  @override
  State<UserInfoStepSix> createState() => _UserInfoStepSixState();
}

class _UserInfoStepSixState extends State<UserInfoStepSix> {
  final StepSixController _stepsixController = Get.put(StepSixController());
  String? language = sharedPreferences?.getString("Language");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _stepsixController.fetcheDataFromApi();
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
        body: SingleChildScrollView(
          child: SafeArea(child: Obx(
            () {
              if (_stepsixController.loadingPage.value == true) {
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
                                  "Document Verification",
                                  style: CustomTextStyle.bodytextLarge,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      StepsFormHeaderBasic(
                        title: "Document Verification",
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
                      arrowback: false,
                      title: AppLocalizations.of(context)!.documentVerification,
                    ),
                    StepsFormHeaderBasic(
                      endhour: 0,
                      endminutes: 0,
                      endseconds: 0,
                      //   verificationStatus: "${_stepsixController.data["verification_status"]}",
                      title: "${_stepsixController.data["heading"]}",
                      // title: "आत्ताच तुमची प्रोफाईल व्हेरिफाय करून घ्या!",
                      desc: "${_stepsixController.data["message"]}",
                      // desc:
                      //     "तुमच्या कागदपत्रांचा कुठलाही गैरवापर होणार नाही याची आम्ही पूर्ण हमी देतो.",
                      image: "height",
                      statusdesc: "",
                      statusPercent: "",
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
                              height: 77,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: const Color.fromARGB(255, 7, 150, 4)
                                    .withOpacity(0.09),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      textAlign: TextAlign.center,
                                      AppLocalizations.of(context)!
                                          .verifyYourProfileNow,
                                      style: CustomTextStyle.bodytext.copyWith(
                                          fontSize: 16,
                                          color: const Color.fromARGB(
                                              255, 20, 113, 18),
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .yourIdentityDocumentsDetails,
                                      textAlign: TextAlign.center,
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
                            height: 20,
                          ),
                          Center(
                              child: Text(
                            textAlign: TextAlign.center,
                            AppLocalizations.of(context)!.iWantToVerifyUsing,
                            style: CustomTextStyle.fieldName
                                .copyWith(fontSize: 16),
                          )),
                          const SizedBox(
                            height: 20,
                          ),
                          Obx(
                            () {
                              return Center(
                                child: Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  alignment: WrapAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        _stepsixController
                                            .updateOption("Pan Card");
                                        _stepsixController.errordata.value = {};
                                      },
                                      child: CustomContainer(
                                        height: 60,
                                        width: 89,
                                        color: _stepsixController
                                                    .selectedOption.value ==
                                                "Pan Card"
                                            ? AppTheme.selectedOptionColor
                                            : null,
                                        title: AppLocalizations.of(context)!
                                            .panCard,
                                        textColor: _stepsixController
                                                    .selectedOption.value ==
                                                "Pan Card"
                                            ? Colors.white
                                            : null,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _stepsixController
                                            .updateOption("Driving Licence");
                                        _stepsixController.errordata.value = {};
                                      },
                                      child: CustomContainer(
                                        height: 60,
                                        width: 130,
                                        color: _stepsixController
                                                    .selectedOption.value ==
                                                "Driving Licence"
                                            ? AppTheme.selectedOptionColor
                                            : null,
                                        title: AppLocalizations.of(context)!
                                            .drivingLicence,
                                        textColor: _stepsixController
                                                    .selectedOption.value ==
                                                "Driving Licence"
                                            ? Colors.white
                                            : null,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _stepsixController
                                            .updateOption("Voter ID");
                                        _stepsixController.errordata.value = {};
                                      },
                                      child: CustomContainer(
                                        height: 60,
                                        width: 77,
                                        color: _stepsixController
                                                    .selectedOption.value ==
                                                "Voter ID"
                                            ? AppTheme.selectedOptionColor
                                            : null,
                                        title: language == "en"
                                            ? "Voter ID"
                                            : "मतदान ओळखपत्र",
                                        // AppLocalizations.of(context)!
                                        // .voterID,
                                        textColor: _stepsixController
                                                    .selectedOption.value ==
                                                "Voter ID"
                                            ? Colors.white
                                            : null,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _stepsixController
                                            .updateOption("Upload Manually");
                                        _stepsixController.errordata.value = {};
                                      },
                                      child: CustomContainer(
                                        height: 60,
                                        width: 130,
                                        color: _stepsixController
                                                    .selectedOption.value ==
                                                "Upload Manually"
                                            ? AppTheme.selectedOptionColor
                                            : null,
                                        title: AppLocalizations.of(context)!
                                            .uploadManually,
                                        textColor: _stepsixController
                                                    .selectedOption.value ==
                                                "Upload Manually"
                                            ? Colors.white
                                            : null,
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
                          Obx(
                            () {
                              if (_stepsixController.selectedOption.value ==
                                  "Pan Card") {
                                return PanCard();
                              } else if (_stepsixController
                                      .selectedOption.value ==
                                  "Driving Licence") {
                                return DrivingLicence();
                              } else if (_stepsixController
                                      .selectedOption.value ==
                                  "Voter ID") {
                                return VoterID();
                              } else if (_stepsixController
                                      .selectedOption.value ==
                                  "Adhar Card") {
                                return const AdharCard();
                              } else if (_stepsixController
                                      .selectedOption.value ==
                                  "Upload Manually") {
                                return UploadManuallyDoc();
                              }
                              {
                                return const SizedBox();
                              }
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
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
                                            text:
                                                "\nSupport time: 10 am to 6 pm",
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
                                            "मदतीसाठी दिलेल्या ई-मेल वर संपर्क करा",
                                        style:
                                            CustomTextStyle.bodytext.copyWith(
                                          height:
                                              1.5, // Adjust height for spacing
                                        ),
                                        children: [
                                          TextSpan(
                                            text:
                                                " info@96kulimarathamarriage.com",
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
                                                "\nसपोर्ट वेळ : स.१० ते संध्या.६ वाजेपर्यत",
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

class UploadManually extends StatefulWidget {
  const UploadManually({super.key});

  @override
  State<UploadManually> createState() => _UploadManuallyState();
}

class _UploadManuallyState extends State<UploadManually> {
  final CasteVerificationData _stepsixController =
      Get.put(CasteVerificationData());
  String? language = sharedPreferences?.getString("Language");

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: AppLocalizations.of(context)!.uploadYourDocument,
                style: CustomTextStyle.fieldName,
              ),
              const TextSpan(
                text: "*",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            margin: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: Colors.white, // Match the Card color
              border: Border.all(color: Colors.grey, width: 1), // Add border
              borderRadius: BorderRadius.circular(8), // Add border radius
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    _stepsixController
                        .selectFile(); // Call the selectFile method
                  },
                  child: Container(
                    height: 65,
                    width: 117,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(0),
                          topLeft: Radius.circular(8),
                          bottomRight: Radius.circular(0),
                          bottomLeft: Radius.circular(8)),
                      color: Colors.grey.shade300,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Choose File",
                          style:
                              CustomTextStyle.bodytext.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8), // Add some spacing
                Expanded(
                  child: Obx(() => Text(
                        _stepsixController.fileName.value,
                        overflow: TextOverflow.ellipsis,
                        maxLines:
                            1, // Ensure that the text doesn't exceed one line
                        style: CustomTextStyle.bodytext.copyWith(fontSize: 10),
                      )),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 30),
          child: Container(
            decoration: BoxDecoration(
                color: AppTheme.lightPrimaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                  text: TextSpan(children: <TextSpan>[
                const TextSpan(
                    text: "*",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.red)),
                TextSpan(
                    text: "${AppLocalizations.of(context)!.note} : ",
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.red)),
                TextSpan(
                    text: AppLocalizations.of(context)!
                        .yourDocumentWillBeSolelyUsedForCasteVerification,
                    style: CustomTextStyle.bodytextSmall),
              ])),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                return SizedBox(
                  height: 25,
                  width: 25,
                  child: Checkbox(
                    side: BorderSide(color: Colors.grey.shade500),
                    activeColor: const Color.fromARGB(255, 80, 93, 126),
                    value: _stepsixController.showCheckBox.value,
                    onChanged: (value) {
                      _stepsixController.altercheckBox();
                    },
                  ),
                );
              }),
              const SizedBox(width: 8), // Add spacing between checkbox and text
              Expanded(
                child: Text(AppLocalizations.of(context)!.iherbydeclare,
                    style: CustomTextStyle.bodytextSmall),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Obx(
          () {
            if (_stepsixController.selectedFile.value == null &&
                _stepsixController.submitted.value) {
              return Padding(
                padding: const EdgeInsets.only(
                    bottom: 18.0, left: 8, right: 8, top: 8),
                child: Text(
                  AppLocalizations.of(context)!
                      .pleaseUploadValidDocumentForVerification,
                  style: CustomTextStyle.errorText,
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
        const SizedBox(width: 10),
        Center(
          child: ElevatedButton(onPressed: () {
            _stepsixController.submitted.value = true;
            if (_stepsixController.selectedFile.value == null) {
              //   Get.snackbar("Error", "Please Select A Document to verify");
            } else {
              _stepsixController.uploadDocument();
            }
          }, child: Obx(
            () {
              if (_stepsixController.isLoading.value) {
                return const CircularProgressIndicator(
                  color: Colors.white,
                );
              } else {
                return Text(
                  language == "en" ? "Get Verified" : "व्हेरिफाय करा",
                  style: CustomTextStyle.elevatedButton,
                );
              }
            },
          )),
        ),
        const SizedBox(
          height: 30,
        )
      ],
    );
  }
}

class UploadManuallyDoc extends StatefulWidget {
  const UploadManuallyDoc({super.key});

  @override
  State<UploadManuallyDoc> createState() => _UploadManuallyDocState();
}

class _UploadManuallyDocState extends State<UploadManuallyDoc> {
  final StepSixController _stepsixController = Get.put(StepSixController());
  String? language = sharedPreferences?.getString("Language");

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: AppLocalizations.of(context)!.uploadYourDocument,
                style: CustomTextStyle.fieldName,
              ),
              const TextSpan(
                text: "*",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            margin: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: Colors.white, // Match the Card color
              border: Border.all(color: Colors.grey, width: 1), // Add border
              borderRadius: BorderRadius.circular(8), // Add border radius
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    _stepsixController
                        .selectFile(); // Call the selectFile method
                  },
                  child: Container(
                    height: 65,
                    width: 117,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(0),
                          topLeft: Radius.circular(8),
                          bottomRight: Radius.circular(0),
                          bottomLeft: Radius.circular(8)),
                      color: Colors.grey.shade300,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.chooseFile,
                          style:
                              CustomTextStyle.bodytext.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8), // Add some spacing
                Expanded(
                  child: Obx(() => Text(
                        _stepsixController.fileName.value,
                        overflow: TextOverflow.ellipsis,
                        maxLines:
                            1, // Ensure that the text doesn't exceed one line
                        style: CustomTextStyle.bodytext.copyWith(fontSize: 10),
                      )),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        const SizedBox(height: 20),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                return SizedBox(
                  height: 25,
                  width: 25,
                  child: Checkbox(
                    side: BorderSide(color: Colors.grey.shade500),
                    activeColor: const Color.fromARGB(255, 80, 93, 126),
                    value: _stepsixController.showCheckBox.value,
                    onChanged: (value) {
                      _stepsixController.altercheckBox();
                    },
                  ),
                );
              }),
              const SizedBox(width: 8), // Add spacing between checkbox and text
              Expanded(
                child: Text(AppLocalizations.of(context)!.iherbydeclare,
                    style: CustomTextStyle.bodytextSmall),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Obx(
          () {
            if (_stepsixController.submittedDoc.value == true &&
                _stepsixController.selectedFile.value == null) {
              return Padding(
                padding: const EdgeInsets.only(
                    bottom: 18.0, left: 8, right: 8, top: 8),
                child: Text(
                  AppLocalizations.of(context)!
                      .pleaseUploadValidDocumentForVerification,
                  style: CustomTextStyle.errorText,
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
        const SizedBox(width: 10),
        Center(
          child: ElevatedButton(onPressed: () {
            _stepsixController.submittedDoc.value = true;

            if (_stepsixController.selectedFile.value == null) {
              //    Get.snackbar("Error", "Please Select A Document to verify");
            } else {
              _stepsixController.uploadDocument();
            }
          }, child: Obx(
            () {
              if (_stepsixController.isLoading.value) {
                return const CircularProgressIndicator(
                  color: Colors.white,
                );
              } else {
                return Text(
                  language == "en" ? "Get Verified" : "व्हेरिफाय करा",
                  style: CustomTextStyle.elevatedButton,
                );
              }
            },
          )),
        ),
        const SizedBox(
          height: 30,
        )
      ],
    );
  }
}

class PanCard extends StatefulWidget {
  const PanCard({super.key});

  @override
  State<PanCard> createState() => _PanCardState();
}

class _PanCardState extends State<PanCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final mybox = Hive.box('myBox');
  String? language = sharedPreferences?.getString("Language");

  String selectgender() {
    if (language == "en") {
      if (mybox.get("gender") == 2) {
        return "groom";
      } else {
        return "bride";
      }
    } else {
      if (mybox.get("gender") == 2) {
        return "वराचे";
      } else {
        return "वधूचे";
      }
    }
  }

  final StepSixController stepFiveController = Get.put(StepSixController());
  @override
  Widget build(BuildContext context) {
    String? name = sharedPreferences?.getString("Full Name");
    TextEditingController namecontroller = TextEditingController(text: name);

    String gender = selectgender();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          RichText(
              text: TextSpan(children: <TextSpan>[
            TextSpan(
                text: language == "en"
                    ? "Name of $gender as Per Pan Card "
                    : "पॅन कार्डनुसार $gender संपूर्ण नाव:",
                style: CustomTextStyle.fieldName),
            const TextSpan(text: "*", style: TextStyle(color: Colors.red)),
          ])),
          CustomTextField(
            readonly: true,
            textEditingController: namecontroller,
            HintText: "Your Pan ID Name",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Enter Pan Number';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          RichText(
              text: TextSpan(children: <TextSpan>[
            TextSpan(
                text: AppLocalizations.of(context)!.yourPanIdNumber,
                style: CustomTextStyle.fieldName),
            const TextSpan(text: "*", style: TextStyle(color: Colors.red)),
          ])),
          CustomTextField(
            onChange: (p0) {
              stepFiveController.errordata["message"] = null;
              return null;
            },
            inputFormatters: [
              UpperCaseTextFormatter(), // Ensures all input is uppercase
              FilteringTextInputFormatter.allow(RegExp(
                  r'[A-Za-z0-9]')), // Allows only alphanumeric characters
            ],
            textEditingController: stepFiveController.panverificationController,
            HintText: AppLocalizations.of(context)!.enteryourPanIdNumber,
            validator: (value) {
              if (language == "en") {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Pan Number';
                }
              } else {
                if (value == null || value.isEmpty) {
                  return 'कृपया पॅन कार्ड क्रमांक टाका ';
                }
              }

              // Regex pattern for validating PAN ID
              RegExp panRegex = RegExp(r'^[A-Z]{5}\d{4}[A-Z]{1}$');
              if (language == "en") {
                if (!panRegex.hasMatch(value)) {
                  return 'Invalid Pan ID.';
                }
              } else {
                if (!panRegex.hasMatch(value)) {
                  return 'कृपया योग्य पॅन कार्ड क्रमांक टाका.';
                }
              }

              return null;
            },
          ),
          Obx(() {
            // Check if the error data has a 'message' field
            if (stepFiveController.errordata['message'] != null) {
              return Padding(
                padding: const EdgeInsets.only(left: 18.0, top: 6),
                child: Text(
                  stepFiveController
                      .errordata['message'], // Display the error message
                  style: CustomTextStyle.errorText,
                ),
              );
            } else {
              // Display a default message if there's no error data
              return const SizedBox();
            }
          }),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () {
                    return SizedBox(
                        height: 25,
                        width: 25,
                        child: Checkbox(
                          side: BorderSide(color: Colors.grey.shade500),
                          activeColor: const Color.fromARGB(
                            255,
                            80,
                            93,
                            126,
                          ),
                          value: stepFiveController.showCheckBox.value,
                          onChanged: (value) {
                            stepFiveController.altercheckBox();
                          },
                        ));
                  },
                ),
                Flexible(
                  child: Text(
                    textAlign: TextAlign.center,
                    AppLocalizations.of(context)!.iherbydeclare,
                    style: CustomTextStyle.bodytextSmall,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            width: 10,
          ),
          Center(
              child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                print("Valid");
                stepFiveController.sendDataPan(
                    panNumber: stepFiveController.panverificationController.text
                        .trim());
              }
              // Get.toNamed(AppRouteNames.bottomNavBar);
            },
            child: Obx(() {
              return stepFiveController.isLoading.value
                  ? const CircularProgressIndicator(
                      color: Colors.white, // Set the indicator color if needed
                    )
                  : Text(
                      language == "en" ? "Get Verified" : "व्हेरिफाय करा",
                      style: CustomTextStyle.elevatedButton,
                    );
            }),
          )),
        ],
      ),
    );
  }
}

class DrivingLicence extends StatefulWidget {
  const DrivingLicence({super.key});

  @override
  State<DrivingLicence> createState() => _DrivingLicenceState();
}

class _DrivingLicenceState extends State<DrivingLicence> {
  final StepSixController stepSixController = Get.put(StepSixController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final mybox = Hive.box('myBox');
  String? language = sharedPreferences?.getString("Language");

  String selectgender() {
    if (language == "en") {
      if (mybox.get("gender") == 2) {
        return "groom";
      } else {
        return "bride";
      }
    } else {
      if (mybox.get("gender") == 2) {
        return "वराचे";
      } else {
        return "वधूचे";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String? name = sharedPreferences?.getString("Full Name");
    TextEditingController namecontroller = TextEditingController(text: name);
    String gender = selectgender();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          RichText(
              text: TextSpan(children: <TextSpan>[
            TextSpan(
                text: language == "en"
                    ? "Name of $gender as Per Driving License "
                    : "ड्रायव्हिंग लायसन्सनुसार $gender संपूर्ण नाव:",
                style: CustomTextStyle.fieldName),
            const TextSpan(text: "*", style: TextStyle(color: Colors.red)),
          ])),
          CustomTextField(
              readonly: true,
              textEditingController: namecontroller,
              HintText: "Enter Name"),
          const SizedBox(
            height: 20,
          ),
          RichText(
              text: TextSpan(children: <TextSpan>[
            TextSpan(
                text: AppLocalizations.of(context)!.drivingLicanceNumber,
                style: CustomTextStyle.fieldName),
            const TextSpan(text: "*", style: TextStyle(color: Colors.red)),
          ])),
          CustomTextField(
            onChange: (p0) {
              stepSixController.errordata["message"] = null;
              return null;
            },
            inputFormatters: [
              UpperCaseTextFormatter(), // Convert input to uppercase
              FilteringTextInputFormatter.allow(
                  RegExp(r'[A-Za-z0-9]')), // Allow only alphanumeric characters
            ],
            textEditingController: stepSixController.drivingLicanceController,
            HintText: AppLocalizations.of(context)!.enterDrivingLicenceNumber,
            validator: (value) {
              if (language == "en") {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Driving License Number';
                }
              } else {
                if (value == null || value.isEmpty) {
                  return 'कृपया ड्रायव्हिंग लायसन्स क्रमांक टाका ';
                }
              }

              // Check if input length is exactly 15 characters and contains only alphanumeric characters
              RegExp licenseRegex = RegExp(r'^[A-Z0-9]{15}$');
              if (language == "en") {
                if (!licenseRegex.hasMatch(value)) {
                  return 'Invalid License Number.';
                }
              } else {
                if (!licenseRegex.hasMatch(value)) {
                  return 'कृपया योग्य ड्रायव्हिंग लायसन्स क्रमांक टाका.';
                }
              }

              return null;
            },
          ),
          Obx(() {
            // Check if the error data has a 'message' field
            if (stepSixController.errordata['message'] != null) {
              return Padding(
                padding: const EdgeInsets.only(left: 18.0, top: 6),
                child: Text(
                  stepSixController
                      .errordata['message'], // Display the error message
                  style: CustomTextStyle.errorText,
                ),
              );
            } else {
              // Display a default message if there's no error data
              return const SizedBox();
            }
          }),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () {
                    return SizedBox(
                        height: 25,
                        width: 25,
                        child: Checkbox(
                          side: BorderSide(color: Colors.grey.shade500),
                          activeColor: const Color.fromARGB(
                            255,
                            80,
                            93,
                            126,
                          ),
                          value: stepSixController.showCheckBox.value,
                          onChanged: (value) {
                            stepSixController.altercheckBox();
                          },
                        ));
                  },
                ),
                Flexible(
                  child: Text(
                      textAlign: TextAlign.center,
                      AppLocalizations.of(context)!.iherbydeclare,
                      style: CustomTextStyle.bodytextSmall),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            width: 10,
          ),
          Center(
              child: ElevatedButton(onPressed: () {
            if (_formKey.currentState!.validate()) {
              stepSixController.sendDataDrivingLicance(
                  drivingLicance:
                      stepSixController.drivingLicanceController.text.trim());
            }
          }, child: Obx(
            () {
              if (stepSixController.isLoading.value) {
                return const CircularProgressIndicator(
                  color: Colors.white,
                );
              } else {
                return Text(
                  language == "en" ? "Get Verified" : "व्हेरिफाय करा",
                  style: CustomTextStyle.elevatedButton,
                );
              }
            },
          ))),
        ],
      ),
    );
  }
}

class VoterID extends StatefulWidget {
  const VoterID({super.key});

  @override
  State<VoterID> createState() => _VoterIDState();
}

class _VoterIDState extends State<VoterID> {
  final StepSixController stepSixController = Get.put(StepSixController());
  final mybox = Hive.box('myBox');
  String? language = sharedPreferences?.getString("Language");

  String selectgender() {
    if (language == "en") {
      if (mybox.get("gender") == 2) {
        return "groom";
      } else {
        return "bride";
      }
    } else {
      if (mybox.get("gender") == 2) {
        return "वराचे";
      } else {
        return "वधूचे";
      }
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    String? name = sharedPreferences?.getString("Full Name");
    TextEditingController namecontroller = TextEditingController(text: name);
    String gender = selectgender();
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          RichText(
              text: TextSpan(children: <TextSpan>[
            TextSpan(
                text: language == "en"
                    ? "Name of $gender as Per VoterID "
                    : "मतदान कार्डनुसार $gender संपूर्ण नाव ",
                style: CustomTextStyle.fieldName),
            const TextSpan(text: "*", style: TextStyle(color: Colors.red)),
          ])),
          CustomTextField(
            textEditingController: namecontroller,
            HintText: "Enter Name",
            readonly: true,
          ),
          const SizedBox(
            height: 20,
          ),
          RichText(
              text: TextSpan(children: <TextSpan>[
            TextSpan(
                text: AppLocalizations.of(context)!.voterID,
                style: CustomTextStyle.fieldName),
            const TextSpan(text: "*", style: TextStyle(color: Colors.red)),
          ])),
          CustomTextField(
            onChange: (p0) {
              stepSixController.errordata["message"] = null;
              return null;
            },
            inputFormatters: [
              UpperCaseTextFormatter(), // Ensures all input is uppercase
              FilteringTextInputFormatter.allow(RegExp(
                  r'[A-Za-z0-9]')), // Allows only alphanumeric characters
            ],
            textEditingController: stepSixController.voterIDController,
            HintText: AppLocalizations.of(context)!.enterVoterID,
            validator: (value) {
              if (language == "en") {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Voter ID';
                }
              } else {
                if (value == null || value.isEmpty) {
                  return 'कृपया योग्य मतदान कार्ड क्रमांक टाका';
                }
              }

              // Regex pattern for Voter ID validation (3 letters followed by 7 digits)
              RegExp voterIdRegex = RegExp(r'^[A-Z]{3}\d{7}$');
              if (language == "en") {
                if (!voterIdRegex.hasMatch(value)) {
                  return 'Invalid Voter ID.';
                }
              } else {
                if (!voterIdRegex.hasMatch(value)) {
                  return 'कृपया योग्य मतदान कार्ड क्रमांक टाका.';
                }
              }

              return null;
            },
          ),
          Obx(() {
            // Check if the error data has a 'message' field
            if (stepSixController.errordata['message'] != null) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  stepSixController
                      .errordata['message'], // Display the error message
                  style: CustomTextStyle.errorText,
                ),
              );
            } else {
              // Display a default message if there's no error data
              return const SizedBox();
            }
          }),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () {
                    return SizedBox(
                        height: 25,
                        width: 25,
                        child: Checkbox(
                          side: BorderSide(color: Colors.grey.shade500),
                          activeColor: const Color.fromARGB(
                            255,
                            80,
                            93,
                            126,
                          ),
                          value: stepSixController.showCheckBox.value,
                          onChanged: (value) {
                            stepSixController.altercheckBox();
                          },
                        ));
                  },
                ),
                Flexible(
                  child: Text(
                      textAlign: TextAlign.center,
                      AppLocalizations.of(context)!.iherbydeclare,
                      style: CustomTextStyle.bodytextSmall),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            width: 10,
          ),
          Center(
              child: ElevatedButton(onPressed: () {
            if (_formKey.currentState!.validate()) {
              stepSixController.sendDataVoterID(
                  voterID: stepSixController.voterIDController.text.trim());
            }
            // Get.toNamed(AppRouteNames.bottomNavBar);
          }, child: Obx(
            () {
              if (stepSixController.isLoading.value) {
                return const CircularProgressIndicator(
                  color: Colors.white,
                );
              } else {
                return Text(
                  language == "en" ? "Get Verified" : "व्हेरिफाय करा",
                  style: CustomTextStyle.elevatedButton,
                );
              }
            },
          ))),
        ],
      ),
    );
  }
}

class AdharCard extends StatelessWidget {
  const AdharCard({super.key});

  @override
  Widget build(BuildContext context) {
    final StepSixController stepSixController = Get.put(StepSixController());
    String? language = sharedPreferences?.getString("Language");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            stepSixController.AadharCardVerification();
          },
          label: const Text(
            "Aadhar verification",
            style: CustomTextStyle.elevatedButton,
          ),
          icon: const Icon(
            Icons.document_scanner,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.red)),
                    onPressed: () {},
                    child: Text(
                      "Back",
                      style: CustomTextStyle.elevatedButton
                          .copyWith(color: Colors.red),
                    ))),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      language == "en" ? "Get Verified" : "व्हेरिफाय करा",
                      style: CustomTextStyle.elevatedButton,
                    ))),
          ],
        ),
      ],
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
