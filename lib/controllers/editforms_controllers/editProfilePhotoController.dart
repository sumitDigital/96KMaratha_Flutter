import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/controllers/viewProfileControllers/myprofileController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class Editprofilephotocontroller extends GetxController {
  var isImageLoading = false.obs;
  final ImagePicker _picker = ImagePicker();
  var selectedImage = Rx<File?>(null);

  Future<void> selectImage(ImageSource source) async {
    try {
      // Pick an image using the image picker
      XFile? pickedFile = await _picker.pickImage(source: source);
      isImageLoading.value = true;

      if (pickedFile != null) {
        // Check if the file extension is JPG, JPEG, or PNG
        String filePath = pickedFile.path;
        String fileExtension = filePath.split('.').last.toLowerCase();

        if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
          // If the format is valid, proceed to crop the image
          await cropImage(pickedFile);
        } else {
          // If the format is invalid, show a message
          print(
              'Invalid file format. Please select a JPG, JPEG, or PNG image.');
        }
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
        uploadData(
            photoType: "profile",
            pickedFile: XFile(selectedImage.value?.path ?? "path"));
      }
    } catch (e) {
      print('Error cropping image: $e');
    }
  }

  final MyProfileController _profileController = Get.put(MyProfileController());

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

  var isLoading = false.obs;
  Future<String?> uploadData({
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
        // sharedPreferences!.setString("PageIndex", "6");
        //  Get.toNamed(AppRouteNames.userInfoStepFive);
        // Get.back();
        _profileController.fetchUserInfo();
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
