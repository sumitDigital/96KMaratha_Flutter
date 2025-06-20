import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:_96kuliapp/commons/dialogues/apidialogues/registerCompleteDialogue.dart';
import 'package:_96kuliapp/commons/dialogues/logoutDialogoue.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/userform/formstep4Controller.dart';
import 'package:_96kuliapp/controllers/userform/formstep5Controller.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/auth_Screens/loginScreen2.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepFour.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/bottomnavBar.dart';
import 'package:_96kuliapp/utils/formHeader.dart';
import 'package:_96kuliapp/utils/formheaderbasic.dart';
import 'package:_96kuliapp/utils/formtitletag.dart';
import 'package:_96kuliapp/utils/selectlanguage.dart';
import 'package:shimmer/shimmer.dart';

class UserInfoStepFive extends StatefulWidget {
  const UserInfoStepFive({super.key});

  @override
  State<UserInfoStepFive> createState() => _UserInfoStepFiveState();
}

class _UserInfoStepFiveState extends State<UserInfoStepFive> {
  List guidelinesData = [
    "assets/PhotoGuideline1.png",
    "assets/PhotoGuideline2.png",
    "assets/PhotoGuideline3.png",
    "assets/PhotoGuideline4.png",
    "assets/PhotoGuideline5.png",
    "assets/PhotoGuideline6.png",
  ];
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

  List donts = [
    "Avoid Watermarked or Enhanced Photos: Photos with logos, digital enhancements, or personal information will be rejected.",
    "No Irrelevant Images: Photos that are not related to your profile may result in deactivation.",
    "Don’t Use Old or Outdated Photos: Ensure all images are current and reflect your appearance.",
    "Avoid Group Photos: Ensure your profile photos only feature you and not groups or other people.",
    "Skip Low-Quality or Blurry Photos: Ensure all photos are clear and high-quality to avoid rejection."
  ];
  final StepFiveController controller = Get.put(StepFiveController());
  final StepFourController _stepFourController = Get.put(StepFourController());
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
          builder: (context) => const UserInfoStepFour(),
        ));
        return false; // Prevent default back navigation
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(child: Obx(
            () {
              String? language = sharedPreferences?.getString("Language");
              if (_stepFourController.isPageLoading.value) {
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
                                    Get.back();
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
                                  language == "en" ? "STEP 5" : "पाचवी पायरी",
                                  style: CustomTextStyle.bodytextLarge,
                                ),
                              ],
                            ),
                            const SelectLanguage()
                          ],
                        ),
                      ),
                      const StepsFormHeaderBasic(
                        title: "Upload Your Photos",
                        desc:
                            "Increase Your Matches: Upload Photos to Complete Your Profile! Stand Out with 10x More Responses Add quality photos, your photos are safe with us!!",
                        image: "assets/formstep1.png",
                        statusdesc: "Great ! You have Completed",
                        statusPercent: "60%",
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
                      title: language == "en" ? "STEP 5" : "पाचवी पायरी",
                      lang: true,
                      onTap: () {
                        if (navigatorKey.currentState!.canPop()) {
                          Get.back();
                        } else {
                          navigatorKey.currentState!
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => const UserInfoStepFour(),
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
                      title: AppLocalizations.of(context)!.galleryPhotos,
                      desc: _stepFourController.headingText.value,
                      // desc: "A valid face photo is necessary; unrealistic photos may get your profile blocked.",
                      image: _stepFourController.headingImage.value,
                      statusdesc: "Great ! You have Completed",
                      statusPercent: "75%",
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Form(
                        child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: AppLocalizations.of(context)!
                                    .addGalleryPhotos,
                                style: CustomTextStyle.fieldName
                                    .copyWith(fontSize: 14)),
                            TextSpan(
                                text: AppLocalizations.of(context)!.atleast1,
                                style: CustomTextStyle.bodytextSmall),
                            const TextSpan(
                                text: "*", style: TextStyle(color: Colors.red)),
                          ])),
                          const SizedBox(
                            height: 5,
                          ),
                          language == "en"
                              ? Text.rich(
                                  TextSpan(
                                    text:
                                        "A genuine and recent face photo are required. If your gallery photos are fake or unrealistic, your profile may be restricted or ",
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
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width > 600
                                ? 200
                                : 300,
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 4,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 0.5,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                crossAxisCount:
                                    MediaQuery.of(context).size.width > 600
                                        ? 4
                                        : 2,
                                mainAxisExtent: 140,
                              ),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () => controller.pickImage(index),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(12)),
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 70,
                                                  width: 70,
                                                  child: Obx(() {
                                                    // Check if local image is selected, otherwise show network image if available
                                                    if (controller
                                                                .selectedImages[
                                                            index] !=
                                                        null) {
                                                      print(
                                                          "THIS IS FIRST IMAGE ${controller.selectedImages.first?.path}");
                                                      return Image.file(
                                                        File(controller
                                                            .selectedImages[
                                                                index]!
                                                            .path),
                                                        fit: BoxFit.cover,
                                                      );
                                                    } else if (_stepFourController
                                                            .galleryPhotos
                                                            .isNotEmpty &&
                                                        index <
                                                            _stepFourController
                                                                .galleryPhotos
                                                                .length) {
                                                      return Image.network(
                                                        _stepFourController
                                                                .galleryPhotos[
                                                            index],
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return const Text(
                                                              'Failed to load image');
                                                        },
                                                      );
                                                    } else {
                                                      return Image.asset(
                                                          "assets/uploadImagelight4x.png");
                                                    }
                                                  }),
                                                ),
                                                const SizedBox(height: 10),
                                                language == "en"
                                                    ? Center(
                                                        child: RichText(
                                                          text: TextSpan(
                                                            children: <TextSpan>[
                                                              TextSpan(
                                                                text:
                                                                    "Click here to Upload ",
                                                                style: CustomTextStyle
                                                                    .bodytext
                                                                    .copyWith(
                                                                        fontSize:
                                                                            10),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : Center(
                                                        child: RichText(
                                                          text: TextSpan(
                                                            children: <TextSpan>[
                                                              TextSpan(
                                                                text: "येथे ",
                                                                style: CustomTextStyle
                                                                    .bodytext
                                                                    .copyWith(
                                                                        fontSize:
                                                                            12),
                                                              ),
                                                              TextSpan(
                                                                text: "फोटो",
                                                                style: CustomTextStyle
                                                                    .bodytext
                                                                    .copyWith(
                                                                  fontSize: 12,
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
                                                                    " अपलोड करा  ",
                                                                style: CustomTextStyle
                                                                    .bodytext
                                                                    .copyWith(
                                                                        fontSize:
                                                                            12),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Center(
                                        child: RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: language == "en"
                                                    ? "Upload "
                                                    : "अपलोड",
                                                style: CustomTextStyle.bodytext
                                                    .copyWith(fontSize: 12),
                                              ),
                                              TextSpan(
                                                text:
                                                    "${language == "en" ? " Photo" : " फोटो "} ${index + 1}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppTheme.primaryColor,
                                                ),
                                              ),
                                              if (index == 0)
                                                const TextSpan(
                                                  text: ' *',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors
                                                        .red, // Red color for the star
                                                    letterSpacing: 1,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          Obx(
                            () {
                              List<XFile?> nonNullSelectedImages = controller
                                  .selectedImages
                                  .where((image) => image != null)
                                  .cast<XFile?>()
                                  .toList();

                              if (nonNullSelectedImages.isEmpty &&
                                  controller.sumbitted.value == true) {
                                return Center(
                                  child: Text(
                                    language == "en"
                                        ? "Please select at least 1 gallery image"
                                        : "कमीत कमी एक गॅलरी फोटो अपलोड करा ",
                                    style: CustomTextStyle.errorText,
                                  ),
                                );
                              }

                              // If images are selected, you can display them in a GridView or ListView
                              return const SizedBox();
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
                                            .pushReplacement(MaterialPageRoute(
                                          builder: (context) =>
                                              const UserInfoStepFour(),
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
                                  onPressed: () async {
                                    String photoType =
                                        "gallery"; // Specify the photo type
                                    controller.sumbitted.value = true;
                                    // Filter out null values from selectedImages and cast it to List<XFile?>
                                    List<XFile?> nonNullSelectedImages =
                                        controller.selectedImages
                                            .where((image) => image != null)
                                            .cast<XFile?>()
                                            .toList();

                                    print(
                                        "Filtered Image list: $nonNullSelectedImages");

                                    if (_stepFourController
                                        .galleryPhotos.isEmpty) {
                                      print("Empty image");

                                      if (nonNullSelectedImages.isEmpty) {
                                        //  Get.snackbar("error", "Please Select Gallery Images");
                                        /*   Get.snackbar(
        "Error", 
        "Please Select Gallery Images",
        snackPosition: SnackPosition.BOTTOM, // Show from the bottom
        backgroundColor: AppTheme.primaryColor,         // Red background color
        colorText: Colors.white,             // White text color for contrast
        margin: EdgeInsets.all(10),          // Adds some margin around the snackbar
        borderRadius: 8,                     // Adds rounded corners
        icon: Icon(Icons.error, color: Colors.white), // Adds an icon for emphasis
        snackStyle: SnackStyle.FLOATING,     // Optional: floating style for better appearance
      );*/
                                      } else {
                                        await controller.UploadImages(
                                          selectedImages: nonNullSelectedImages,
                                          photoType: photoType,
                                          oldimg: controller.replacedImageNames,
                                        );
                                      }
                                    } else {
                                      print(
                                          "Noooooooooooooooooooooooooooooooooooo");

                                      if (nonNullSelectedImages.isEmpty) {
                                        //  Get.snackbar("error", "Please Select Gallery Images");
                                      } else {
                                        await controller.UploadImages(
                                          selectedImages: nonNullSelectedImages,
                                          photoType: photoType,
                                          oldimg: controller.replacedImageNames,
                                        );
                                      }
                                    }
                                  },
                                  child: Obx(() {
                                    return controller.isLoading.value
                                        ? const CircularProgressIndicator(
                                            color: Colors
                                                .white, // Set the indicator color if needed
                                          )
                                        : Text(
                                            AppLocalizations.of(context)!.save,
                                            style:
                                                CustomTextStyle.elevatedButton);
                                  }),
                                ),
                              ),
                            ],
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
                                      style: CustomTextStyle.fieldName.copyWith(
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
                                          'कृपया खालील प्रकारचे प्रोफाईल फोटो अपलोड करू नका अथवा प्रोफाईल ब्लॉक केली जाईल.',
                                      style: CustomTextStyle.fieldName.copyWith(
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
