import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:_96kuliapp/commons/dialogues/logoutDialogoue.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/requestToChangePhotosController/requestToChangePhotosController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/formheaderbasic.dart';
import 'package:_96kuliapp/utils/formtitletag.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePhotoRequestToChangeScreen extends StatefulWidget {
  const ProfilePhotoRequestToChangeScreen({super.key});

  @override
  State<ProfilePhotoRequestToChangeScreen> createState() =>
      _ProfilePhotoRequestToChangeScreenState();
}

class _ProfilePhotoRequestToChangeScreenState
    extends State<ProfilePhotoRequestToChangeScreen> {
  List guidelinesData = [
    "assets/PhotoGuideline1.png",
    "assets/PhotoGuideline2.png",
    "assets/PhotoGuideline3.png",
    "assets/PhotoGuideline4.png",
    "assets/PhotoGuideline5.png",
    "assets/PhotoGuideline6.png",
  ];

  Future<void> handleSave() async {
    _stepFourController.isLoading.value = true;

    try {
      print("UPLOADING IMAGES");

      // Step 1: Handle profile photo upload
      if (_stepFourController.selectedImages.length >= 2) {
        // Extract the images to be sent
        File profileFile =
            File(_stepFourController.selectedImage.value?.path ?? "");

        // Prepare a list for gallery photos
        List<File?> galleryFiles = [];

        // Check each index for the presence of an image
        if (_stepFourController.selectedImages.isNotEmpty &&
            _stepFourController.selectedImages[0] != null) {
          galleryFiles.add(File(_stepFourController.selectedImages[0]!.path));
        }
        if (_stepFourController.selectedImages.length > 1 &&
            _stepFourController.selectedImages[1] != null) {
          galleryFiles.add(File(_stepFourController.selectedImages[1]!.path));
        }
        if (_stepFourController.selectedImages.length > 2 &&
            _stepFourController.selectedImages[2] != null) {
          galleryFiles.add(File(_stepFourController.selectedImages[2]!.path));
        }
        if (_stepFourController.selectedImages.length > 3 &&
            _stepFourController.selectedImages[3] != null) {
          galleryFiles.add(File(_stepFourController.selectedImages[3]!.path));
        }

        // Check that at least the required gallery photos are not null (we need at least two images)
        if (galleryFiles.isNotEmpty && galleryFiles.length >= 2) {
          // Call the uploadPhotos method with non-nullable File objects
          await _stepFourController.uploadPhotos(
            profilePhoto: profileFile,
            galleryPhoto1:
                galleryFiles[0]!, // Ensure non-null File for the first image
            galleryPhoto2: galleryFiles.length > 1
                ? galleryFiles[1]!
                : File(""), // Ensure non-null File for the second image
            galleryPhoto3: galleryFiles.length > 2
                ? galleryFiles[2]
                : null, // Allow nullable for galleryPhoto3
            galleryPhoto4: galleryFiles.length > 3
                ? galleryFiles[3]
                : null, // Allow nullable for galleryPhoto4
          );

          // Handle success case

          // Navigate or go back if needed
          Get.back();
        } else {
          print("Gallery photos are not available.");
        }
      } else {
        print("Not enough images selected. Please select at least two images.");
      }
    } catch (error) {
      // Handle errors
      Get.snackbar(
        "Error",
        "An error occurred while uploading photos: $error",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _stepFourController.isLoading.value = false;
    }
  }

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
    "Don't Use Old or Outdated Photos: Ensure all images are current and reflect your appearance.",
    "Avoid Group Photos: Ensure your profile photos only feature you and not groups or other people.",
    "Skip Low-Quality or Blurry Photos: Ensure all photos are clear and high-quality to avoid rejection."
  ];
  final RequesttochangephotosController controller =
      Get.put(RequesttochangephotosController());
  final RequesttochangephotosController _stepFourController =
      Get.put(RequesttochangephotosController());
  void displayDialogue() {
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

  String? language = sharedPreferences?.getString("Language");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  memberid = arguments["memberID"];
//controller.fetchMemberPhotos();
    _stepFourController.fetcheDataFromApi();
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
        // Show the confirmation dialog
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
                    ? 'Do you really want to exit the app?'
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
        return shouldExit ?? false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(child: Obx(
            () {
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
                                const Text(
                                  "Update Gallery Photos",
                                  style: CustomTextStyle.bodytextLarge,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FormsTitleTag(
                      pageName: "dashBoard",
                      title: "Update Profile Photo",
                      arrowback: false,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      // rgba(204, 40, 77, 1)
                      color: const Color.fromRGBO(204, 40, 77, 1),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            language == "en"
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text: 'Your profile photo is ',
                                        style: CustomTextStyle.bodytextLarge
                                            .copyWith(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          height:
                                              1.5, // Increase line height here
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'DISAPPROVED',
                                            style: CustomTextStyle.bodytextLarge
                                                .copyWith(
                                              // rgba(255, 195, 0, 1)
                                              color: const Color.fromRGBO(
                                                  255, 195, 0, 1),
                                              fontSize: 20,

                                              fontWeight: FontWeight.w600,
                                              height:
                                                  1.5, // Increase line height here
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                ' for not following our policy.',
                                            style: CustomTextStyle.bodytextLarge
                                                .copyWith(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                              height:
                                                  1.3, // Increase line height here
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text: 'तुमचा प्रोफाईल फोटो',
                                        style: CustomTextStyle.bodytextLarge
                                            .copyWith(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          height:
                                              1.5, // Increase line height here
                                        ),
                                        children: [
                                          TextSpan(
                                            text: ' नाकारण्यात ',
                                            style: CustomTextStyle.bodytextLarge
                                                .copyWith(
                                              // rgba(255, 195, 0, 1)
                                              color: const Color.fromRGBO(
                                                  255, 195, 0, 1),
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              height:
                                                  1.5, // Increase line height here
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'आला आहे.',
                                            style: CustomTextStyle.bodytextLarge
                                                .copyWith(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              height:
                                                  1.3, // Increase line height here
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Divider(height: 8, color: Colors.white),
                            const SizedBox(
                              height: 20,
                            ),
                            language == "en"
                                ? Center(
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: const TextSpan(
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "WORKSANS",
                                          color: Color.fromRGBO(80, 93, 126, 1),
                                          fontSize: 14,
                                        ),
                                        children: [
                                          TextSpan(
                                              text:
                                                  "A valid face photo is necessary; unrealistic photos may get your profile ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "WORKSANS",
                                                color: Colors.white,
                                                fontSize: 14,
                                              )),
                                          TextSpan(
                                              text: "BLOCKED",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "WORKSANS",
                                                color: Colors.white,
                                                fontSize: 14,
                                              )),
                                          TextSpan(text: "."),
                                        ],
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: const TextSpan(
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "WORKSANS",
                                          color: Color.fromRGBO(80, 93, 126, 1),
                                          fontSize: 14,
                                        ),
                                        children: [
                                          TextSpan(
                                              text:
                                                  "प्रोफाईल फोटो आमच्या नियमांमध्ये बसत नसल्या कारणाने नाकारण्यात आला आहे. तुमचा योग्य फोटो अपलोड करा अथवा तुमची प्रोफाईल ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "WORKSANS",
                                                color: Colors.white,
                                                fontSize: 14,
                                              )),
                                          TextSpan(
                                              text: "ब्लॉक",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "WORKSANSBOLD",
                                                color: Colors.white,
                                                fontSize: 16,
                                              )),
                                          TextSpan(
                                              text: " केली जाईल.",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "WORKSANS",
                                                color: Colors.white,
                                                fontSize: 14,
                                              )),
                                          TextSpan(text: "."),
                                        ],
                                      ),
                                    ),
                                  ),
                            const SizedBox(
                              height: 15,
                            )
                          ],
                        ),
                      ),
                    ),
                    Form(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            RichText(
                                text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .profilePhoto,
                                  style: CustomTextStyle.fieldName
                                      .copyWith(fontSize: 14)),
                              const TextSpan(
                                  text: " *",
                                  style: TextStyle(color: Colors.red)),
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
                                          "तुमचा स्वतःचा फोटो टाकणे आवश्यक आहे. जर तुमचा स्वतःचा फोटो नसेल किंवा अजून इतर कुठलेही फोटो तुम्ही अपलोड केले तर तुमची प्रोफाइल ",
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
                                return GestureDetector(
                                  onTap: displayDialogue,
                                  child: Center(
                                    child: Stack(
                                      alignment: Alignment
                                          .center, // Center the content
                                      children: [
                                        DottedBorder(
                                          borderType: BorderType.RRect,
                                          color: Colors.grey,
                                          radius: const Radius.circular(12),
                                          padding: const EdgeInsets.all(6),
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
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
                                                child: Image.file(
                                                  _stepFourController
                                                      .selectedImage.value!,
                                                  height: 200,
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
                                        borderType: BorderType.RRect,
                                        color: Colors.grey,
                                        radius: const Radius.circular(0),
                                        padding: const EdgeInsets.all(6),
                                        strokeWidth: 1,
                                        dashPattern: const [
                                          5,
                                          6
                                        ], // Length of dash and gap between dashes
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(0)),
                                          child: SizedBox(
                                            height: 121,
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
                                                    height: 50,
                                                    width: 50,
                                                    child: Image.asset(
                                                        "assets/uploadImagelight.png"),
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
                                                                              12),
                                                                ),
                                                                TextSpan(
                                                                  text: "Photo",
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
                                            radius: const Radius.circular(0),
                                            padding: const EdgeInsets.all(6),
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(0)),
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
                              height: 10,
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
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                                height: 18,
                                                width: 18,
                                                child: Image.asset(
                                                    "assets/editprofile.png")),
                                          ),
                                          // ignore: prefer_const_constructors

                                          const Text(
                                            "Upload Profile Photo",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                color: Color.fromARGB(
                                                    255, 80, 93, 126)),
                                          )
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
                                  print("WHY NOT SHOWING");
                                  if (_stepFourController.selectedImage.value ==
                                      null) {
                                    print("THIS SHOULD SHOW MESSAGE");
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(left: 18.0),
                                      child: Text(
                                        "Please upload profile photo",
                                        style: CustomTextStyle.errorText,
                                      ),
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                } else {
                                  print("WHY NOT SHOWING TURRR");

                                  return const SizedBox();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
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
                                text:
                                    AppLocalizations.of(context)!.galleryPhotos,
                                style: CustomTextStyle.fieldName
                                    .copyWith(fontSize: 14)),
                            const TextSpan(
                                text: "", style: CustomTextStyle.bodytextSmall),
                            const TextSpan(
                                text: "*", style: TextStyle(color: Colors.red)),
                          ])),
                          const SizedBox(
                            height: 20,
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
                                crossAxisSpacing: 35,
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
                                        color: const Color.fromARGB(
                                                255, 80, 93, 126)
                                            .withOpacity(0.65),
                                        radius: const Radius.circular(0),
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
                                                Center(
                                                  child: RichText(
                                                    text: TextSpan(
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text: language == "en"
                                                              ? "Upload Photo"
                                                              : "येथे फोटो अपलोड करा ",
                                                          style: CustomTextStyle
                                                              .bodytext
                                                              .copyWith(
                                                                  fontSize: 10),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
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
                                              // TextSpan(
                                              //   text: "Upload ",
                                              //   style: CustomTextStyle.bodytext
                                              //       .copyWith(
                                              //     fontSize: 12,
                                              //     letterSpacing:
                                              //         1, // Adjust spacing for "Upload"
                                              //   ),
                                              // ),
                                              // TextSpan(
                                              //   text: "Photo ${index + 1}",
                                              //   style: TextStyle(
                                              //     fontSize: 12,
                                              //     fontWeight: FontWeight.w600,
                                              //     color: const Color.fromARGB(
                                              //         255, 234, 52, 74),
                                              //     letterSpacing:
                                              //         1, // Adjust spacing for "Photo X"
                                              //   ),
                                              // ),
                                              if (index == 0 || index == 1)
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

                              if (nonNullSelectedImages.length < 2 &&
                                  controller.sumbitted.value == true) {
                                return Center(
                                  child: Text(
                                    language == "en"
                                        ? "Please upload at least 2 gallery images"
                                        : "कृपया कमीत कमी २ फोटो अपलोड करा ",
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
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                controller.sumbitted.value = true;
                                _stepFourController.submited.value = true;
                                // Call a function to handle both API uploads
                                File profileFile = File(_stepFourController
                                        .selectedImage.value?.path ??
                                    "");
                                print(
                                    "igggggggggggggggggggg ${_stepFourController.selectedImage.value}");
                                if (profileFile.path.isEmpty) {
                                  print("IMAGE for photo");
                                } else if (controller.selectedImages.length <
                                    2) {
                                  print("IMAGE for gallert photo");
                                } else {
                                  await handleSave();
                                }
                              },
                              child: Obx(() {
                                return _stepFourController.isLoading.value
                                    ? const CircularProgressIndicator(
                                        color: Colors
                                            .white, // Set the indicator color if needed
                                      )
                                    : Text(AppLocalizations.of(context)!.save,
                                        style: CustomTextStyle.elevatedButton);
                              }),
                            ),
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
                                          'कृपया खालील प्रकारचे प्रोफाइल फोटो अपलोड करू नका अथवा प्रोफाईल ब्लॉक केली जाईल.',
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
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: language == "en"
                                ? RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: "Need assistance? Reach out at ",
                                      style: CustomTextStyle.bodytext.copyWith(
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
                                          style:
                                              CustomTextStyle.bodytext.copyWith(
                                            letterSpacing: 0.5,
                                            height:
                                                1.5, // Adjust height for spacing
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text:
                                          "तुमच्या मदतीसाठी आम्ही आहोत! आमच्याशी ",
                                      style: CustomTextStyle.bodytext.copyWith(
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
                                          style:
                                              CustomTextStyle.bodytext.copyWith(
                                            height:
                                                1.5, // Adjust height for spacing
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
