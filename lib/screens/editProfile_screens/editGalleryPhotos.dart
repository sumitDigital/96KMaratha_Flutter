// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/editforms_controllers/editGalleryPhotoController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditGalleryPhotosScreen extends StatefulWidget {
  const EditGalleryPhotosScreen({super.key});

  @override
  State<EditGalleryPhotosScreen> createState() =>
      _EditGalleryPhotosScreenState();
}

class _EditGalleryPhotosScreenState extends State<EditGalleryPhotosScreen> {
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
      print("UPLOADING EMPTY IMAGE");
      // Step 1: Handle profile photo upload
      if (_stepFourController.selectedImage.value != null) {
        print("UPLOADING EMPTY IMAGE seelcted ima");

        File profileFile =
            File(_stepFourController.selectedImage.value?.path ?? "");
        await _stepFourController.Upload(
          photoType: "profile",
          pickedFile: XFile(profileFile.path),
        );
      }

      // Step 2: Handle gallery photos upload
      String photoType = "gallery";
      List<XFile?> nonNullSelectedImages = _stepFourController.selectedImages
          .where((image) => image != null)
          .cast<XFile?>()
          .toList();
      print("UPLOADING EMPTY IMAGE gallery");

      if (nonNullSelectedImages.isNotEmpty) {
        print("UPLOADING EMPTY IMAGE pho not empty");

        await _stepFourController.UploadImages(
          selectedImages: nonNullSelectedImages,
          photoType: photoType,
          oldimg: _stepFourController.replacedImageNames,
        );
      }
      if (nonNullSelectedImages.isEmpty &&
          _stepFourController.selectedImage.value == null) {
        Get.back();
      }

      // Handle success case
      Get.snackbar(
        "Success",
        "Profile and Gallery photos uploaded successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate or go back if needed
      Get.back();
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
    "Use a Front-Facing Photo: Ensure your entire face is visible and clearly shown.",
    "Upload Recent Photos: Your photo should be up-to-date and not include others.",
    "Add Multiple Photos: You can upload up to 20 photos to showcase yourself.",
    "Follow Size and Format Guidelines: Each photo must be under 10 MB and in JPG, JPEG, or PNG format.",
    "Choose a Professional Look: Ensure your photo is well-composed and appropriate."
  ];
  List donts = [
    "Avoid Watermarked or Enhanced Photos: Photos with logos, digital enhancements, or personal information will be rejected.",
    "No Irrelevant Images: Photos that are not related to your profile may result in deactivation.",
    "Don’t Use Old or Outdated Photos: Ensure all images are current and reflect your appearance.",
    "Avoid Group Photos: Ensure your profile photos only feature you and not groups or other people.",
    "Skip Low-Quality or Blurry Photos: Ensure all photos are clear and high-quality to avoid rejection."
  ];
  final EditGalleryPhotosController controller =
      Get.put(EditGalleryPhotosController());
  final EditGalleryPhotosController _stepFourController =
      Get.put(EditGalleryPhotosController());
  String? language = sharedPreferences?.getString("Language");

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  memberid = arguments["memberID"];
//controller.fetchMemberPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                "Edit Gallery Photos",
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
                              onTap: () => Get.back(),
                              child: SizedBox(
                                width: 25,
                                height: 20,
                                child: SvgPicture.asset("assets/arrowback.svg",
                                    fit: BoxFit.fitWidth),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                                language == "en"
                                    ? "Edit Photos Screen"
                                    : "प्रोफाईल फोटो बदला",
                                style: CustomTextStyle.bodytextLarge),
                          ],
                        ),
                      ],
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
                                    AppLocalizations.of(context)!.profilePhoto,
                                // "Profile Photo ",
                                style: CustomTextStyle.fieldName
                                    .copyWith(fontSize: 14)),
                          ])),
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
                                    alignment:
                                        Alignment.center, // Center the content
                                    children: [
                                      DottedBorder(
                                        borderType: BorderType.RRect,
                                        color: Colors.grey,
                                        radius: const Radius.circular(12),
                                        padding: const EdgeInsets.all(6),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
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
                                      if (_stepFourController
                                          .isLoading.value) // Check if loading
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
                                      radius: const Radius.circular(12),
                                      padding: const EdgeInsets.all(6),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                        child: SizedBox(
                                          height: 200,
                                          width:
                                              MediaQuery.of(context).size.width,
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
                                                // Center(
                                                //   child: RichText(
                                                //     text: TextSpan(
                                                //       children: <TextSpan>[
                                                //         TextSpan(
                                                //           text:
                                                //               "Click here to Upload ",
                                                //           style: CustomTextStyle
                                                //               .bodytext
                                                //               .copyWith(
                                                //                   fontSize: 12),
                                                //         ),
                                                //         TextSpan(
                                                //           text: "Photo",
                                                //           style: CustomTextStyle
                                                //               .bodytext
                                                //               .copyWith(
                                                //             fontSize: 12,
                                                //             fontWeight:
                                                //                 FontWeight.w600,
                                                //             color: const Color
                                                //                 .fromARGB(255,
                                                //                 234, 52, 74),
                                                //           ),
                                                //         ),
                                                //       ],
                                                //     ),
                                                //   ),
                                                // ),
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
                                        if (_stepFourController.isImageLoading
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

                                        Text(
                                          language == "en"
                                              ? "Upload Profile Photo"
                                              : 'प्रोफाईल फोटो अपलोड करा',
                                          style: const TextStyle(
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
                                if (_stepFourController.selectedImage.value ==
                                        null &&
                                    _stepFourController.profilePhotos.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: Text(
                                      "Please Select Profile Photo",
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
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: language == "en"
                                      ? "Update Gallery Photos "
                                      : "गॅलरी फोटो बदला ",
                                  style: CustomTextStyle.fieldName
                                      .copyWith(fontSize: 14)),
                              const TextSpan(
                                  text: "",
                                  style: CustomTextStyle.bodytextSmall),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width > 600
                              ? 200
                              : 500,
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
                              mainAxisExtent: 240,
                            ),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () => controller.pickImage(index),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    DottedBorder(
                                      strokeWidth: 1,
                                      dashPattern: const [
                                        7,
                                        4
                                      ], // Length of dash and gap between dashes
                                      borderType: BorderType.RRect,
                                      color:
                                          const Color.fromARGB(255, 80, 93, 126)
                                              .withOpacity(0.65),
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
                                                height: 170,
                                                width: 170,
                                                child: Obx(() {
                                                  // Check if local image is selected, otherwise show network image if available
                                                  if (controller.selectedImages[
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
                                                          .galleryPhotos[index],
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return const Text(
                                                            'Failed to load image');
                                                      },
                                                    );
                                                  } else {
                                                    return LayoutBuilder(
                                                      builder: (context,
                                                          constraints) {
                                                        // Use constraints to adjust the size of the asset image.
                                                        double scaledSize =
                                                            constraints
                                                                    .maxWidth *
                                                                0.6; // Scale the image to 60% of the SizedBox's width.
                                                        return Center(
                                                          child: Image.asset(
                                                            "assets/uploadImage.png",
                                                            width: scaledSize,
                                                            height: scaledSize,
                                                            fit: BoxFit.contain,
                                                          ),
                                                        );
                                                      },
                                                    );
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
                                                              style:
                                                                  CustomTextStyle
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
                                  "Please select at least 1 gallery image",
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
                                  side: const BorderSide(color: Colors.red),
                                ),
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text(
                                  // "Back",
                                  AppLocalizations.of(context)!.back,

                                  style: CustomTextStyle.elevatedButton
                                      .copyWith(color: Colors.red),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  // Call a function to handle both API uploads
                                  await handleSave();
                                },
                                child: Obx(() {
                                  return _stepFourController.isLoading.value
                                      ? const CircularProgressIndicator(
                                          color: Colors
                                              .white, // Set the indicator color if needed
                                        )
                                      : Text(
                                          // "Save",
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
                                        style:
                                            CustomTextStyle.fieldName.copyWith(
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
                                        style:
                                            CustomTextStyle.fieldName.copyWith(
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
                      ],
                    ),
                  ))
                ],
              );
            }
          },
        )),
      ),
    );
  }
}
