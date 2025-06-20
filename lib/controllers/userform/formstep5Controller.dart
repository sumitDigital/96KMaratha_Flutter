import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/commons/dialogues/apidialogues/addonPLanDialogue.dart';
import 'package:_96kuliapp/commons/dialogues/apidialogues/registerCompleteDialogue.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationScreen.dart';
import 'package:_96kuliapp/controllers/userform/formstep4Controller.dart';
import 'package:_96kuliapp/main.dart';
import 'package:http/http.dart' as http;
import 'package:_96kuliapp/routes/routenames.dart';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:_96kuliapp/screens/auth_Screens/registerOTPScreen.dart';
import 'package:_96kuliapp/screens/plans/upgradeScreen.dart';
import 'package:_96kuliapp/screens/userInfoForms/userInfoStepOne.dart';
import 'package:_96kuliapp/screens/userInfoForms/userInfoStepTwo.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepFour.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepThree.dart';
import 'package:_96kuliapp/utils/bottomnavBar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class StepFiveController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  var isLoading = false.obs;
  final StepFourController _stepFourController = Get.put(StepFourController());
  var sumbitted = false.obs;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final facebookAppEvents = FacebookAppEvents();

  // Holds selected images
  var selectedImages = List<XFile?>.filled(4, null).obs;

  // List to store names of replaced images
  var replacedImageNames = <String>[].obs;

  Future<void> pickImage(int index) async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      // Pass the picked image to the cropper function
      File? croppedImage = await cropImage(File(pickedImage.path));

      if (croppedImage != null) {
        print("Cropped image path: ${croppedImage.path}");
        print("This is data for my images $index ${croppedImage.path}");

        // Ensure `galleryPhotosNames` list has enough elements
        while (_stepFourController.galleryPhotosNames.length < index) {
          _stepFourController.galleryPhotosNames
              .add(""); // Add empty placeholders if needed
        }

        // Ensure `selectedImages` list has enough elements
        while (selectedImages.length < index) {
          selectedImages.add(null); // Add placeholders for unselected images
        }

        // Handle replacing existing image names
        if (_stepFourController.galleryPhotosNames.isNotEmpty) {
          print(
              "THIS IS INDEX $index THIS IS LENGTH ${_stepFourController.galleryPhotosNames.length}");
          if (index < _stepFourController.galleryPhotosNames.length) {
            String name = _stepFourController.galleryPhotosNames[index];
            replacedImageNames.add(name);
          }
        }

        // Update the `selectedImages` list with the newly cropped image
        selectedImages[index] = XFile(croppedImage.path);
      }
    }
  }

  Future<File?> cropImage(File imageFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      compressQuality: 100,
      aspectRatio: const CropAspectRatio(ratioX: 2, ratioY: 3),
      uiSettings: [
        AndroidUiSettings(
          cropFrameColor: Colors.red,
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.white,
          toolbarWidgetColor: Colors.black,
          initAspectRatio: CropAspectRatioPreset.ratio7x5,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioLockEnabled: true,
        ),
      ],
    );

    if (croppedFile != null) {
      return File(croppedFile.path);
    }
    return null;
  }

  // Image compression function
  Future<XFile?> compressImage(XFile? pickedFile) async {
    if (pickedFile == null) return null;

    File originalFile = File(pickedFile.path);
    if (!await originalFile.exists()) {
      print("Original file not found: ${pickedFile.path}");
      return null;
    }

    Directory tempDir = await getTemporaryDirectory();
    String targetPath = '${tempDir.path}/${pickedFile.name}_compressed.jpg';

    try {
      var compressedFile = await FlutterImageCompress.compressAndGetFile(
        pickedFile.path,
        targetPath,
        quality: 85,
        minWidth: 800,
        minHeight: 600,
      );

      if (compressedFile == null) {
        print("Compression failed");
        return null;
      }

      return XFile(compressedFile.path);
    } catch (e) {
      print('Compression error: $e');
      return null;
    }
  }

  var apiData = {}.obs;
  var isLoadingRedirect = true.obs;
  // Function to fetch data from the API with a token
  Future<void> fetchDataredirect() async {
    String? token = sharedPreferences!.getString("token");
    String url = '${Appconstants.baseURL}/api/redirect';
    print("INSIDE REDIRECT");
    try {
      isLoadingRedirect(true);
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token', // Add token in headers
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Parse and store the JSON data
        apiData.value = json.decode(response.body);
        //  mybox.put("gender", responsedata["data"]["gender"] );
        print("THIS IS  RESPONSE INSIDE REDIRECT $apiData");
        //    sharedPreferences?.setString("token", responsedata["token"]);
        print(
            "Login data page name for reg  ${apiData["redirect"]["pagename"]}");
        var pagename = apiData["redirect"]["pagename"];
        // Handle success (e.g., navigate to the next screen)

        if (pagename == "OTP-VERIFICATION") {
          sharedPreferences!.setString("PageIndex", "1");
// Get.offAllNamed(AppRouteNames.registerOTPScreen);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const RegisterOTPScreen(),
            ),
            (route) => false,
          );
        } else if (pagename == "BASIC-INFO") {
          sharedPreferences!.setString("PageIndex", "2");
          print("Shared pref ${sharedPreferences?.getString("PageIndex")}");

// Get.offAllNamed(AppRouteNames.userInfoStepOne);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const UserInfoStepOne(),
            ),
            (route) => false,
          );
        } else if (pagename == "EDUCATION-CAREER") {
          sharedPreferences!.setString("PageIndex", "3");

          // Get.offAllNamed(AppRouteNames.userInfoStepTwo);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const UserInfoStepTwo(),
            ),
            (route) => false,
          );
        } else if (pagename == "PARTNER") {
          sharedPreferences!.setString("PageIndex", "4");

// Get.offAllNamed(AppRouteNames.userInfoStepThree);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const UserInfoStepThree(),
            ),
            (route) => false,
          );
        } else if (pagename == "PHOTOS") {
          sharedPreferences!.setString("PageIndex", "5");

          // Get.offAllNamed(AppRouteNames.userInfoStepFour);
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const UserInfoStepFour(),
            ),
            (route) => false,
          );
        } else if (pagename == "DASHBOARD") {
          sharedPreferences!.setString("PageIndex", "8");

          //  Get.offAllNamed(AppRouteNames.bottomNavBar);
          analytics.logEvent(name: "app_96k_first_dashboard_landed");
          facebookAppEvents.logEvent(name: "Fb_96k_app_first_dashboard_landed");
          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const BottomNavBar(),
            ),
            (route) => false,
          );
        } else if (pagename == "PLAN") {
          sharedPreferences!.setString("PageIndex", "9");

          //  Get.offAllNamed(AppRouteNames.bottomNavBar);

          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const UpgradePlan(),
            ),
            (route) => false,
          );
        } else {
          sharedPreferences!.setString("PageIndex", "8");

          navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const BottomNavBar(),
            ),
            (route) => false,
          );
        }
      } else {
        // Optionally handle errors here
        // Get.snackbar("Error", "Failed to load data from the server");
      }
    } catch (e) {
      // Optionally handle exceptions here
      // Get.snackbar("Error", "Something went wrong. $e");
    } finally {
      isLoadingRedirect(false);
      _sendApiCall();
    }
  }
  /*
    Future.delayed(const Duration(milliseconds: 500), () {
    Get.dialog(const Registercompletedialogue(),
    
     barrierDismissible: false);
  });*/

  Future<void> _sendApiCall() async {
    String? token =
        sharedPreferences?.getString('token'); // replace 'token' with your key

    try {
      // Example API call using the token
      final response = await http.get(
        Uri.parse('${Appconstants.baseURL}/api/update-online-status'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );
      print("TIME RESP ${response.body}");
      if (response.statusCode == 200) {
        print('API call successful');
      } else {
        print('Failed to call API');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Function to upload images
  Future<void> UploadImages(
      {required List<XFile?> selectedImages,
      required String photoType,
      required List<String> oldimg}) async {
    print("INSIDE THIS FUNCTION");
    try {
      isLoading.value = true;
      String? token = sharedPreferences!.getString("token");
      if (token == null) {
        //  Get.snackbar("Error", "Token not found");
        return;
      }

      final header = {
        "Content-Type": "multipart/form-data",
        "Authorization": "Bearer $token",
      };

      String pageUrl = '${Appconstants.baseURL}/api/save-image';
      final request = http.MultipartRequest('POST', Uri.parse(pageUrl));

      // Add the photo type field to the request
      request.fields['photo_type'] = photoType;

      // Compress and add each selected image to the request
      for (var image in selectedImages) {
        if (image != null) {
          XFile? compressedFile = await compressImage(image);
          if (compressedFile == null) {
            //   Get.snackbar("Error", "Image compression failed");
            continue;
          }

          var file = await http.MultipartFile.fromPath(
            'image',
            compressedFile.path,
            filename: compressedFile.name,
          );
          request.files.add(file);
        }
      }

      // Add old images' names to the request
      for (var imageName in oldimg) {
        if (imageName.isNotEmpty) {
          request.fields['Old_Image'] = imageName;
          print("Image Name is $imageName");
        }
      }

      // Add headers to the request
      request.headers.addAll(header);

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        debugPrint('Body: INSIDE THIS FUNCTION ${response.body}');
        //   Get.snackbar("Success", "Images uploaded successfully");
        facebookAppEvents.logEvent(name: "Fb_96k_app_gallary_photo_completed");
        analytics.logEvent(name: "app_96k_profile_gallary_photo_completed");
        print('Body: INSIDE THIS FUNCTION ${response.body}');
        await fetchDataredirect();
      } else {
        debugPrint(response.body);
        debugPrint("Upload failed: ${response.statusCode}");
        //   Get.snackbar("Error", "Image upload failed");
      }
    } catch (e) {
      debugPrint('Exception: $e');
      //  Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
