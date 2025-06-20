import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/controllers/viewProfileControllers/myprofileController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:path_provider/path_provider.dart';

class GalleryimageList {
  final String imageName;
  final String imagePath;

  GalleryimageList({required this.imageName, required this.imagePath});
}

class EditGalleryPhotosController extends GetxController {
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

  var galleryImageList = <GalleryimageList>[].obs;
  @override
  void onInit() {
    super.onInit();
    fetchMemberPhotos();
  }

  Future<void> fetchMemberPhotos() async {
    print("fetching Photos");
    try {
      isPageLoading.value = true;
      String? token = sharedPreferences!.getString("token");

      final headers = {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      };

      var url = Uri.parse("${Appconstants.baseURL}/api/member-photos-data");

      var response = await http.get(headers: headers, url);
      print("response is ${response.body}");

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        profilePhotos.clear();
        galleryPhotos.clear();

        if (data['profile_photos'] != null) {
          for (var photo in data['profile_photos']) {
            profilePhotos.add(photo['image_path']);
          }
        }

        if (data['gallery_photos'] != null) {
          for (var photo in data['gallery_photos']) {
            galleryImageList.add(GalleryimageList(
                imageName: photo['image_name'],
                imagePath: photo['image_path']));
            galleryPhotos.add(photo['image_path']);
            galleryPhotosNames.add(photo['image_name']);
          }
        }

        print("THIS IS LENGTH OF IMAGES FROM GAL ${galleryImageList.length}");

        print("Photos are these for images  ${galleryPhotosNames.length}");
      } else {
        //    Get.snackbar("Error", "Failed to fetch photos");
      }
    } catch (e) {
      //   Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isPageLoading.value = false;
    }
  }

  var sumbitted = false.obs;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  // Holds selected images
  var selectedImages = List<XFile?>.filled(4, null).obs;

  // List to store names of replaced images
  var replacedImageNames = <String>[].obs;

  // Function to pick an image
  // Function to pick an image
  Future<void> pickImage(int index) async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);

    print("This is  data for my images $index ${galleryPhotosNames.length}");

    if (pickedImage != null) {
      File? croppedImage = await cropImageGallery(File(pickedImage.path));

      // Ensure `galleryPhotosNames` list has enough elements
      while (galleryPhotosNames.length < index) {
        galleryPhotosNames.add(""); // Add empty placeholders if needed
      }

      // Ensure `selectedImages` list has enough elements
      while (selectedImages.length < index) {
        selectedImages.add(null); // Add placeholders for unselected images
      }

      // Handle replacing existing image names
      if (galleryPhotosNames.isNotEmpty) {
        print(
            "THIS IS  INDEX $index THSI IS LENGTH ${galleryPhotosNames.length}");
        if (index < galleryPhotosNames.length) {
          String name = galleryPhotosNames[index];
          replacedImageNames.add(name);
        }
      }

      // Update the `selectedImages` list with the newly picked image

      selectedImages[index] = XFile(croppedImage!.path);
    }
  }

  Future<File?> cropImageGallery(File imageFile) async {
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

  final MyProfileController _profileController = Get.put(MyProfileController());
  final DashboardController _dashboardController =
      Get.find<DashboardController>();

  // Function to upload images
  Future<void> UploadImages(
      {required List<XFile?> selectedImages,
      required String photoType,
      required List<String> oldimg}) async {
    print(
        "THIS IS LIST OF SELECTED IMAGES $selectedImages and old img $oldimg");
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

      final String pageUrl = '${Appconstants.baseURL}/api/save-image';
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
        debugPrint('Body: ${response.body}');
        //   Get.snackbar("Success", "Images uploaded successfully");

        // Navigate to the next step
        //  sharedPreferences!.setString("PageIndex", "8");
        //  Get.offAllNamed(AppRouteNames.bottomNavBar);
        Get.back();
        _profileController.fetchUserInfo();
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

        Get.back();
        _profileController.fetchUserInfo();

        //   sharedPreferences!.setString("PageIndex", "6");
        //  Get.toNamed(AppRouteNames.userInfoStepFive);
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
      _dashboardController.fetchMemberProfilePhoto();
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
}
