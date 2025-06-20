// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:_96kuliapp/commons/dialogues/logoutDialogoue.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/userform/formstep4Controller.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/auth_Screens/loginScreen2.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepFive.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepThree.dart';
import 'package:_96kuliapp/utils/formHeader.dart';
import 'package:_96kuliapp/utils/formheaderbasic.dart';
import 'package:_96kuliapp/utils/formtitletag.dart';
import 'package:_96kuliapp/utils/selectlanguage.dart';
import 'package:shimmer/shimmer.dart';

class UserInfoStepFour extends StatefulWidget {
  const UserInfoStepFour({super.key});

  @override
  State<UserInfoStepFour> createState() => _UserInfoStepFourState();
}

class _UserInfoStepFourState extends State<UserInfoStepFour> {
  final StepFourController _stepFourController = Get.put(StepFourController());
  // String? language = sharedPreferences?.getString("Language");

  List doos = [
    "Screenshots (of chats, photos, or anything else).",
    "Google Images (random pictures found online).",
    "Photos of Deities or Religious Figures.",
    "Cartoons or Drawings.",
    "Celebrities or Famous Personalities.",
    "Edited Photos (heavily filtered or altered images).",
    "Blurry or Unclear Photos.",
    "Group Photos (ensure only your face is visible).",
    "Nature or Object Photos (landscapes, animals, etc.).",
    "Placeholder Images (like 'Coming Soon' or blank photos).",
  ];
  void displayDialogue() {
    String? language = sharedPreferences?.getString("Language");
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(language == "en" ? "Choose an option" : "पर्याय निवडा",
              style: CustomTextStyle.headlineMain2),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                trailing: Icon(Icons.album_sharp, color: Colors.grey.shade500),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    await _stepFourController.selectImage(ImageSource.gallery);
                  } catch (e) {
                    print('Error selecting image from gallery: $e');
                  }
                },
                title: Text(
                    language == "en"
                        ? "Select from Gallery"
                        : "गॅलरीमधून फोटो निवडा",
                    style: CustomTextStyle.fieldName.copyWith(
                      fontStyle: FontStyle.italic,
                      fontSize: 14,
                    )),
              ),
              ListTile(
                trailing: Icon(Icons.camera_alt, color: Colors.grey.shade500),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    await _stepFourController.selectImage(ImageSource.camera);
                  } catch (e) {
                    print('Error selecting image from camera: $e');
                  }
                },
                title: Text(
                    language == "en"
                        ? "Click by Camera"
                        : "कॅमेऱ्यात फोटो घ्या ",
                    style: CustomTextStyle.fieldName.copyWith(
                      fontStyle: FontStyle.italic,
                      fontSize: 14,
                    )),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
          builder: (context) => const UserInfoStepThree(),
        ));

        return false; // Prevent default back navigation
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(child: Obx(
            () {
              String? language = sharedPreferences?.getString("Language");
              if (_stepFourController.isPageLoading.value == true) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
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
                                    navigatorKey.currentState!
                                        .pushReplacement(MaterialPageRoute(
                                      builder: (context) =>
                                          const UserInfoStepThree(),
                                    ));
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
                                Text(
                                  AppLocalizations.of(context)!.step4,
                                  style: CustomTextStyle.bodytextLarge,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const StepsFormHeaderBasic(
                        title: "Upload Your Photos",
                        desc:
                            "Increase Your Matches: Upload Photos to Complete Your Profile! Stand Out with 10x More Responses Add quality photos, your photos are safe with us!!",
                        image: "assets/formstep1.png",
                        statusdesc: "Great ! You have Completed",
                        statusPercent: "75%",
                      ),
                    ],
                  ),
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormsTitleTag(
                      pageName: "incompleteForms",
                      title: language == "en" ? "Step 4" : "चौथी पायरी",
                      lang: true,
                      onTap: () {
                        if (navigatorKey.currentState!.canPop()) {
                          Get.back();
                        } else {
                          navigatorKey.currentState!
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => const UserInfoStepThree(),
                          ));
                        }
                      },
                      onTaplang: () {
                        _stepFourController.fetchMemberPhotos();
                      },
                    ),
                    StepsFormHeader(
                      statusDescMarathiPrefix: AppLocalizations.of(context)!
                          .updateProfileAndBoostVisibilitypreffix,
                      statusPercentMarathi:
                          AppLocalizations.of(context)!.updatePercent75,
                      statusDescMarathiSuffix: AppLocalizations.of(context)!
                          .updateProfileAndBoostVisibilitySuffix,
                      endhour: _stepFourController.endhours.value,
                      endminutes: _stepFourController.endminutes.value,
                      endseconds: _stepFourController.endseconds.value,
                      title: AppLocalizations.of(context)!.uploadYourPhotos,
                      desc: _stepFourController.headingText.value,
                      image: _stepFourController.headingImage.value,
                      statusdesc: "Update profile & boost visibility by",
                      statusPercent: "75%",
                    ),
                    Form(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),

                            RichText(
                                text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .profilePhoto,
                                  style: CustomTextStyle.fieldName),
                              const TextSpan(
                                  text: "*",
                                  style: TextStyle(color: Colors.red))
                            ])),
                            const SizedBox(
                              height: 5,
                            ),
                            language == "en"
                                ? Text.rich(
                                    TextSpan(
                                      text:
                                          "A genuine and recent face photo is required. If your profile photo is fake or unrealistic, your profile may be restricted or ",
                                      style: CustomTextStyle.bodytext
                                          .copyWith(fontSize: 12),
                                      children: [
                                        TextSpan(
                                          text: "BLOCKED",
                                          style:
                                              CustomTextStyle.bodytext.copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Text.rich(
                                    TextSpan(
                                      text:
                                          "तुमचा स्वतःचा फोटो टाकणे आवश्यक आहे. जर तुमचा स्वतःचा फोटो नसेल किंवा अजून इतर कुठलेही फोटो तुम्ही अपलोड केले तर तुमची प्रोफाईल ",
                                      style: CustomTextStyle.bodytext
                                          .copyWith(fontSize: 12),
                                      children: [
                                        TextSpan(
                                          text: "ब्लॉक",
                                          style:
                                              CustomTextStyle.bodytext.copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: " केली जाईल.",
                                          style: CustomTextStyle.bodytext
                                              .copyWith(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                            const SizedBox(
                              height: 5,
                            ),

                            const SizedBox(height: 10),
                            //  Container(height: 200, width: 300, child: Image.network(_stepFourController.profilePhotos.first),),
                            Obx(() {
                              // Check if an image is selected
                              if (_stepFourController.selectedImage.value !=
                                  null) {
                                print(
                                    "THIS IS SELCTED IMAGE ${_stepFourController.selectedImage.value}");
                                return GestureDetector(
                                  onTap: displayDialogue,
                                  child: Center(
                                    child: Stack(
                                      alignment: Alignment
                                          .center, // Center the content
                                      children: [
                                        DottedBorder(
                                          strokeWidth: 1,
                                          dashPattern: const [
                                            5,
                                            6
                                          ], // Length of dash and gap between dashes
                                          borderType: BorderType.RRect,
                                          color: Colors.grey,
                                          radius: const Radius.circular(12),
                                          padding: const EdgeInsets.all(6),
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12)),
                                            child: SizedBox(
                                              height: 400,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Container(
                                                color: const Color.fromARGB(
                                                        255, 230, 232, 235)
                                                    .withOpacity(0.4),
                                                child: Image.file(
                                                  _stepFourController
                                                      .selectedImage.value!,
                                                  height: 400,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Show LinearProgressIndicator if loading
                                        if (_stepFourController.isLoading
                                            .value) // Check if loading
                                          const Positioned(
                                            bottom: 0, // Position at the bottom
                                            left: 0,
                                            right: 0,
                                            child:
                                                LinearProgressIndicator(), // Display LinearProgressIndicator
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                if (_stepFourController.profilePhotos.isEmpty) {
                                  return GestureDetector(
                                    onTap: displayDialogue,
                                    child: Center(
                                      child: DottedBorder(
                                        strokeWidth: 1,
                                        dashPattern: const [
                                          5,
                                          6
                                        ], // Length of dash and gap between dashes
                                        borderType: BorderType.RRect,
                                        color: Colors.grey,
                                        radius: const Radius.circular(12),
                                        padding: const EdgeInsets.all(6),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(12)),
                                          child: SizedBox(
                                            height: 200,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Container(
                                              color: const Color.fromARGB(
                                                      255, 230, 232, 235)
                                                  .withOpacity(0.4),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    height: 100,
                                                    width: 100,
                                                    child: Image.asset(
                                                        "assets/uploadImage.png"),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Center(
                                                    child: RichText(
                                                        text: language == "en"
                                                            ? TextSpan(
                                                                children: <TextSpan>[
                                                                  TextSpan(
                                                                    text:
                                                                        "Click here to Upload ",
                                                                    style: CustomTextStyle
                                                                        .bodytext
                                                                        .copyWith(
                                                                            fontSize:
                                                                                12),
                                                                  ),
                                                                  TextSpan(
                                                                    text:
                                                                        "Photo",
                                                                    style: CustomTextStyle
                                                                        .bodytext
                                                                        .copyWith(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          234,
                                                                          52,
                                                                          74),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : TextSpan(
                                                                children: <TextSpan>[
                                                                  TextSpan(
                                                                    text:
                                                                        "फोटो ",
                                                                    style: CustomTextStyle
                                                                        .bodytext
                                                                        .copyWith(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          234,
                                                                          52,
                                                                          74),
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text:
                                                                        "अपलोड करण्यासाठी येथे क्लिक करा",
                                                                    style: CustomTextStyle
                                                                        .bodytext
                                                                        .copyWith(
                                                                            fontSize:
                                                                                12),
                                                                  ),
                                                                ],
                                                              )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return GestureDetector(
                                    onTap: displayDialogue,
                                    child: Center(
                                      child: Stack(
                                        alignment: Alignment
                                            .center, // Center the content
                                        children: [
                                          DottedBorder(
                                            strokeWidth: 1,
                                            dashPattern: const [
                                              5,
                                              6
                                            ], // Length of dash and gap between dashes
                                            borderType: BorderType.RRect,
                                            color: Colors.grey,
                                            radius: const Radius.circular(12),
                                            padding: const EdgeInsets.all(6),
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(12)),
                                              child: SizedBox(
                                                height: 400,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Container(
                                                  color: const Color.fromARGB(
                                                          255, 230, 232, 235)
                                                      .withOpacity(0.4),
                                                  child: Image.network(
                                                    _stepFourController
                                                        .profilePhotos.first,
                                                    height: 400,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    fit: BoxFit.fitHeight,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Show LinearProgressIndicator if loading
                                          if (_stepFourController.isImageLoading
                                              .value) // Check if loading
                                            const Positioned(
                                              bottom:
                                                  0, // Position at the bottom
                                              left: 0,
                                              right: 0,
                                              child:
                                                  LinearProgressIndicator(), // Display LinearProgressIndicator
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              }
                            }),

                            const SizedBox(
                              height: 20,
                            ),
                            Obx(
                              () {
                                if (_stepFourController.selectedImage.value ==
                                        null &&
                                    _stepFourController.profilePhotos.isEmpty) {
                                  return const SizedBox();
                                } else {
                                  return GestureDetector(
                                    onTap: () {
                                      displayDialogue();
                                    },
                                    child: Center(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                              height: 14,
                                              width: 14,
                                              child: Image.asset(
                                                  "assets/editprofile.png")),
                                          // ignore: prefer_const_constructors
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              language == "en"
                                                  ? "Upload Photo"
                                                  : "येथे फोटो अपलोड करा ",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10,
                                                  color: Color.fromARGB(
                                                      255, 80, 93, 126)),
                                            ),
                                          ),
                                          //   const Text("Profile Photo" , style: TextStyle(fontWeight: FontWeight.w600 , fontSize: 10 , color: Color.fromARGB(255, 80, 93, 126)),)
                                        ],
                                      ),
                                    )),
                                  );
                                }
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Obx(
                              () {
                                if (_stepFourController.submited.value) {
                                  if (_stepFourController.selectedImage.value ==
                                          null &&
                                      _stepFourController
                                          .profilePhotos.isEmpty) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(left: 18.0),
                                      child: Text(
                                        language == "en"
                                            ? "Please upload profile photo"
                                            : "कृपया प्रोफाईल फोटो अपलोड करा ",
                                        style: CustomTextStyle.errorText,
                                      ),
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                } else {
                                  return const SizedBox();
                                }
                              },
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
                                            side: const BorderSide(
                                                color: Colors.red)),
                                        onPressed: () {
                                          navigatorKey.currentState!
                                              .pushReplacement(
                                                  MaterialPageRoute(
                                            builder: (context) =>
                                                const UserInfoStepThree(),
                                          ));
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)!.back,
                                          style: CustomTextStyle.elevatedButton
                                              .copyWith(color: Colors.red),
                                        ))),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _stepFourController.submited.value = true;
                                      if (_stepFourController
                                              .selectedImage.value ==
                                          null) {
                                        if (_stepFourController
                                            .profilePhotos.isEmpty) {
                                          //  Get.snackbar("Error", "Please Select Image First");
                                        } else {
                                          navigatorKey.currentState!
                                              .pushReplacement(
                                                  MaterialPageRoute(
                                            builder: (context) =>
                                                const UserInfoStepFive(),
                                          ));
                                        }
                                      } else {
                                        File file = File(_stepFourController
                                                .selectedImage.value?.path ??
                                            "profile");
                                        _stepFourController.Upload(
                                            photoType: "profile",
                                            pickedFile: XFile(file.path));
                                      }
                                      // Get.toNamed(AppRouteNames.userInfoStepFive);
                                    },
                                    child: Obx(() {
                                      return _stepFourController.isLoading.value
                                          ? const CircularProgressIndicator(
                                              color: Colors
                                                  .white, // Set the indicator color if needed
                                            )
                                          : Text(
                                              AppLocalizations.of(context)!
                                                  .save,
                                              style: CustomTextStyle
                                                  .elevatedButton);
                                    }),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            language == "en"
                                ? Center(
                                    child: RichText(
                                        text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                          text:
                                              "Please fill in all required fields marked with ",
                                          style: CustomTextStyle.bodytext
                                              .copyWith(fontSize: 12)),
                                      const TextSpan(
                                          text: "*",
                                          style: TextStyle(color: Colors.red)),
                                    ])),
                                  )
                                : Center(
                                    child: RichText(
                                        text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                          text: "सर्व ",
                                          style: CustomTextStyle.bodytext
                                              .copyWith(fontSize: 12)),
                                      const TextSpan(
                                          text: "*",
                                          style: TextStyle(color: Colors.red)),
                                      TextSpan(
                                          text:
                                              " मार्क फील्ड्स भरणे आवश्यक आहे",
                                          style: CustomTextStyle.bodytext
                                              .copyWith(fontSize: 12)),
                                    ])),
                                  ),
                            const SizedBox(
                              height: 30,
                            ),

                            language == "en"
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18.0),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text:
                                            'To maintain authenticity and trust, ',
                                        style:
                                            CustomTextStyle.fieldName.copyWith(
                                          fontSize: 14,
                                          height:
                                              1.5, // Adjust line height (e.g., 1.5 for increased spacing)
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'DO NOT',
                                            style: CustomTextStyle.fieldName
                                                .copyWith(
                                              fontSize: 14,
                                              color: const Color.fromARGB(
                                                  255, 234, 52, 74),
                                              height:
                                                  1.5, // Adjust line height for this part as well
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                ' upload the following types of images as your profile photo:',
                                            style: CustomTextStyle.fieldName
                                                .copyWith(
                                              fontSize: 14,
                                              height:
                                                  1.3, // Adjust line height for this part
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18.0),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text:
                                            'कृपया खालील प्रकारचे प्रोफाईल फोटो अपलोड करू नका अथवा प्रोफाईल ब्लॉक केली जाईल. ',
                                        style:
                                            CustomTextStyle.fieldName.copyWith(
                                          fontSize: 14,
                                          height:
                                              1.5, // Adjust line height (e.g., 1.5 for increased spacing)
                                        ),
                                      ),
                                    ),
                                  ),
                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                                child: Image.asset("assets/grouppedImage.png")),
                            const SizedBox(
                              height: 20,
                            ),
                            // ElevatedButton(
                            //     onPressed: () {
                            //       sharedPreferences?.setString(
                            //           "PageIndex", "6");
                            //       navigatorKey.currentState!
                            //           .push(MaterialPageRoute(
                            //         builder: (context) =>
                            //             const UserInfoStepFive(),
                            //       ));
                            //     },
                            //     child: const Text("NEXT PAGE"))
                          ],
                        ),
                      ),
                    ),
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
