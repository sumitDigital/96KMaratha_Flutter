import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationBlock.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationBlockController.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationScreen.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepFive.dart';
import 'package:path_provider/path_provider.dart';

class StepFourController extends GetxController {
  var selectedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();
  var showEditButton = false.obs;
  var isLoading = false.obs;
  var isPageLoading = false.obs;
  var isImageLoading = false.obs;
  var submited = false.obs;

  var profilePhotos = <String>[].obs;
  var galleryPhotos = <String>[].obs;
  var galleryPhotosNames = <String>[].obs;
  var basicInfoData = {}.obs; // To hold the API response data
  var headingText = "".obs;
  var headingImage = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchMemberPhotos();
  }

  final CasteVerificationBlockController _casteVerificationBlockController =
      Get.put(CasteVerificationBlockController());
  var endhours = 0.obs;
  var endminutes = 0.obs;
  var endseconds = 0.obs;
  Future<void> fetchMemberPhotos() async {
    print("fetching Photos");
    try {
      isPageLoading.value = true;
      String? token = sharedPreferences!.getString("token");
      String? language = sharedPreferences?.getString("Language");
      final headers = {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      };

      var url = Uri.parse(
          "${Appconstants.baseURL}/api/member-photos-data?lang=$language");

      var response = await http.get(headers: headers, url);
      print("response is ${response.body}");

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        profilePhotos.clear();
        galleryPhotos.clear();
        print("THIS IS VALUE IN FORM IMAGE ${data["pageData"]["Offer_Img"]}");
        headingText.value = data["pageData"]["Offer_Heading"];
        headingImage.value = data["pageData"]["Offer_Img"];
        print("THIS IS VALUE IN EndTime ${headingImage.value}");
        if (data["pageData"]["End_Date_time"] != null) {
          String dateTimeString = data["pageData"]["End_Date_time"];

          // Define the format of the input string (YYYY-MM-DD HH:mm:ss)
          DateFormat inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

          // Parse the string into a DateTime object
          DateTime parsedDateTime = inputFormat.parse(dateTimeString);

          // Get the current DateTime
          DateTime currentDateTime = DateTime.now();

          // Calculate the difference (Duration)
          Duration difference = parsedDateTime.difference(currentDateTime);

          // Extract hours, minutes, and seconds from the Duration
          endhours.value = difference.inHours;
          endminutes.value = difference.inMinutes %
              60; // Get the remainder of minutes after hours
          endseconds.value = difference.inSeconds %
              60; // Get the remainder of seconds after minutes

          // Output the results
          print("Difference:");
          print("Hours: in time $endhours");
          print("Minutes: $endminutes");
          print("Seconds: $endseconds");
        }
        if (data['profile_photos'] != null) {
          for (var photo in data['profile_photos']) {
            profilePhotos.add(photo['image_path']);
          }
        }

        if (data['gallery_photos'] != null) {
          for (var photo in data['gallery_photos']) {
            galleryPhotos.add(photo['image_path']);
            galleryPhotosNames.add(photo['image_name']);
          }
        }

        /*   if(data["redirection"]["pagename"].trim() == "CASTE-VERIFICATION-PENDING"){
print("this is page name inside ${data["redirection"]["pagename"]}");

  _casteVerificationBlockController.popup.value = data["redirection"]["Popup"];
     navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => CasteVerificationBlock(),) ,   (route) => false,);
 
}else if (data["redirection"]["pagename"].trim() == "CASTE-VERIFICATION"){
 //  _casteVerificationBlockController.popup.value = basicInfoData["redirection"]["Popup"];
     navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => CasteVerificationScreen(),) ,   (route) => false,);
 
}*/

        print("Photos are ${galleryPhotosNames.first}");
      } else {
        //    Get.snackbar("Error", "Failed to fetch photos");
      }
    } catch (e) {
      //   Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isPageLoading.value = false;
    }
  }

  Future<void> selectImage(ImageSource source) async {
    try {
      // Pick an image using the image picker
      XFile? pickedFile = await _picker.pickImage(source: source);
      isImageLoading.value = true;

      if (pickedFile != null) {
        // Check if the file extension is JPG, JPEG, or PNG
        await cropImage(pickedFile);
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error selecting image: $e');
    } finally {
      isImageLoading.value = false;
    }
  }

  Future<void> cropImage(XFile file) async {
    try {
      CroppedFile? croppedImg = await ImageCropper().cropImage(
        sourcePath: file.path,
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

      if (croppedImg != null) {
        selectedImage.value = File(croppedImg.path);
        print(
            "Profile Photo Size: ${File(croppedImg.path).lengthSync() / 1024} KB");
        uploadData();
        showEditButton.value = true;
      }
    } catch (e) {
      print('Error cropping image: $e');
    }
  }

  Future<void> uploadData() async {
    if (selectedImage.value != null) {
      print("Image uploaded: ${selectedImage.value!.path}");
    }
  }

  Future<void> removeImage() async {
    selectedImage.value = null;
    showEditButton.value = false;
  }

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

  Future<String?> Upload({
    required XFile? pickedFile,
    required String photoType,
  }) async {
    final client = http.Client();
    try {
      isLoading.value = true;
      String? token = sharedPreferences!.getString("token");
      final header = {
        "Content-Type": "multipart/form-data",
        "Authorization": "Bearer $token",
      };

      final String pageUrl = '${Appconstants.baseURL}/api/save-image';

      XFile? compressedFile = await compressImage(pickedFile);

      if (compressedFile == null) {
        Get.snackbar("Error", "Image compression failed");
        return null;
      }

      var file = await http.MultipartFile.fromPath(
        'image',
        compressedFile.path,
        filename: compressedFile.name,
      );

      final request = http.MultipartRequest('POST', Uri.parse(pageUrl));
      request.fields['photo_type'] = photoType;
      request.files.add(file);
      request.headers.addAll(header);

      var streamedResponse = await client.send(request).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          Get.snackbar("Error", "Image upload timed out");
          throw TimeoutException("Error Message");
        },
      );

      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        debugPrint('Body: ${response.body}');

        sharedPreferences!.setString("PageIndex", "6");
        // Get.toNamed(AppRouteNames.userInfoStepFive);
        navigatorKey.currentState!.push(MaterialPageRoute(
          builder: (context) => const UserInfoStepFive(),
        ));

        return jsonDecode(response.body)['fileName'];
      } else {
        debugPrint(response.body);
        debugPrint("Upload failed: ${response.statusCode}");
        Get.snackbar("Error", "Image upload failed");
        return null;
      }
    } on TimeoutException catch (_) {
      Get.snackbar("Error", "Request timed out. Please try again.");
      return null;
    } on Exception catch (e) {
      debugPrint('Multipart Exception: $e');
      Get.snackbar("Error", "$e");
      throw Exception(e);
    } finally {
      isLoading.value = false;
      client.close();
    }
  }
}
