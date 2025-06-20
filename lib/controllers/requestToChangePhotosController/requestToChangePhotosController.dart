import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/controllers/viewProfileControllers/myprofileController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/utils/bottomnavBar.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';

class GalleryimageList {
  final String imageName;
  final String imagePath;

  GalleryimageList({required this.imageName, required this.imagePath});
}

class RequesttochangephotosController extends GetxController {
  String? token = sharedPreferences?.getString("token");

///////////////////////////
  Future<void> fetcheDataFromApi() async {
    print("THIS IS FETCHING");
    try {
      final response = await http.get(headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      }, Uri.parse('${Appconstants.baseURL}/api/photo-verification-data'));
      print(
          "THIS IS FETCHING Response caste ${response.body} and Sta ${response.statusCode}");

      if (response.statusCode == 200) {
        final responsedata = jsonDecode(response.body);
        if (responsedata is Map<String, dynamic>) {
          // data.value = responsedata;
          if (responsedata["verification_status"] == "ACCEPTED") {
            navigatorKey.currentState!.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const BottomNavBar(),
              ),
              (route) => false,
            );
          }
        } else {
          print("The decoded response is not a valid Map.");
        }
      } else {
        print("Error in fetching education data");
      }
    } finally {
      //  isloading(false);  // Ensure the loading state is reset
    }
  }

//////////////////////////////
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

  /* @override
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
        "Authorization": "Bearer ${token}",
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
            galleryImageList.add(GalleryimageList(imageName: photo['image_name'], imagePath: photo['image_path']));
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
*/

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

/*
 Center(
                  child: ElevatedButton.icon(
                     style: ElevatedButton.styleFrom(
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.all(Radius.circular(5)), // This ensures a rectangular button (sharp corners)
               ),
             ),
                    onPressed: () async {
                      if (!advancefiltercontroller.searchfetching.value) {
                     advancefiltercontroller.searchpage.value = 1; 
                             advancefiltercontroller.searchListHasMore.value = true;
                             advancefiltercontroller.searchList.clear();
                          
                            
                            await advancefiltercontroller.advanceSearch().then((value) {
                       navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => SearchResultScreen(),));
                        },);
                      
                      }
                    },
                    label: Obx(() => advancefiltercontroller.searchfetching.value
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          )
                        : const Text(
                            "Search",
                            style: CustomTextStyle.elevatedButton,
                          )),
                    icon: Obx(() => advancefiltercontroller.searchfetching.value
                        ? const SizedBox.shrink() // Hide the icon when loading
                        : const Icon(
                            Icons.search,
                            color: Colors.white,
                          )),
                  ),
                ),
                Center(
                  child: TextButton(onPressed: (){
                  
                    advancefiltercontroller.selectedMinAge.value = FieldModel(); 
                    advancefiltercontroller.selectedMaxAge.value = FieldModel() ; 
                    advancefiltercontroller.selectedMinHeight.value = FieldModel();
                    advancefiltercontroller.selectedMaxHeight.value = FieldModel();
                    advancefiltercontroller.manglikSelectedList.value = []; 
                    locationController.selectedCities.value = []; 
                    locationController.selectedCountries.value = []; 
                    locationController.selectedStates.value = []; 
                    _castController.selectedCasteList.value = [];
                    _castController.selectedSectionList.value = []; 
                    _castController.selectedSubSectionList.value = []; 
                  advancefiltercontroller.selectedItems.value = [];
                  advancefiltercontroller.selectedMinIncome.value = FieldModel();
                  advancefiltercontroller.selectedMaxIncome.value = FieldModel(); 
                  _educationController.selectedEducationList.value = [];
                  advancefiltercontroller.selectedEatingHabitIds.value = []; 
                  advancefiltercontroller.selectedSmokingHabit.value = [];
                  advancefiltercontroller.selectedStatusIds.value = [];
                  advancefiltercontroller.selectedDrinkingHabit.value = [];
                  
                  }, child: Text("Reset" , style: CustomTextStyle.textbuttonRedLarge,)),
                ),
 * 
 */
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
      Get.put(DashboardController());

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

// upload new

  Future<void> uploadPhotos({
    required File profilePhoto,
    required File galleryPhoto1,
    required File galleryPhoto2,
    File? galleryPhoto3,
    File? galleryPhoto4,
  }) async {
    var uri = Uri.parse('${Appconstants.baseURL}/api/photo-change-request');
    String? token = sharedPreferences!.getString("token");
    print("THIS IS TOKEN $token");

    var request = http.MultipartRequest('POST', uri);

    // Add the token to the request headers
    request.headers.addAll({
      'Authorization':
          'Bearer $token', // Passing the token in the Authorization header
    });

    try {
      // Compress image helper function
      Future<XFile?> compressImageHelper(File imageFile) async {
        return compressImage(XFile(imageFile.path));
      }

      // Function to get MIME type from file extension
      String getMimeType(String path) {
        final mimeType = lookupMimeType(path);
        print("MIME TYPE FOR PHOTO IS $mimeType");
        return mimeType ??
            'application/octet-stream'; // Default to generic MIME type if unknown
      }

      // Compress all images
      XFile? compressedProfilePhoto = await compressImageHelper(profilePhoto);
      XFile? compressedGalleryPhoto1 = await compressImageHelper(galleryPhoto1);
      XFile? compressedGalleryPhoto2 = await compressImageHelper(galleryPhoto2);
      XFile? compressedGalleryPhoto3 = galleryPhoto3 != null
          ? await compressImageHelper(galleryPhoto3)
          : null;
      XFile? compressedGalleryPhoto4 = galleryPhoto4 != null
          ? await compressImageHelper(galleryPhoto4)
          : null;

      // Ensure all required images are compressed
      if (compressedProfilePhoto == null ||
          compressedGalleryPhoto1 == null ||
          compressedGalleryPhoto2 == null) {
        print("Failed to compress required photos");
        return;
      }

      // Add compressed images to the request
      request.files.add(await http.MultipartFile.fromPath(
        'profile_photo',
        compressedProfilePhoto.path,
        contentType: MediaType.parse(getMimeType(compressedProfilePhoto.path)),
      ));
      print("COMpressed profile photo $compressedProfilePhoto");
      request.files.add(await http.MultipartFile.fromPath(
        'gallery_photo1',
        compressedGalleryPhoto1.path,
        contentType: MediaType.parse(getMimeType(compressedGalleryPhoto1.path)),
      ));

      request.files.add(await http.MultipartFile.fromPath(
        'gallery_photo2',
        compressedGalleryPhoto2.path,
        contentType: MediaType.parse(getMimeType(compressedGalleryPhoto2.path)),
      ));

      if (compressedGalleryPhoto3 != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'gallery_photo3',
          compressedGalleryPhoto3.path,
          contentType:
              MediaType.parse(getMimeType(compressedGalleryPhoto3.path)),
        ));
      }

      if (compressedGalleryPhoto4 != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'gallery_photo4',
          compressedGalleryPhoto4.path,
          contentType:
              MediaType.parse(getMimeType(compressedGalleryPhoto4.path)),
        ));
      }

      // Send the request
      print(
          "Profile Photo Size before: ${File(profilePhoto.path).lengthSync() / 1024} KB");
      print(
          "Profile Photo Size After: ${File(compressedProfilePhoto.path).lengthSync() / 1024} KB");
      var response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print("Photos uploaded successfully! $responseBody");
        Get.delete<RequesttochangephotosController>();

        sharedPreferences!.setString("PageIndex", "8");

        navigatorKey.currentState!.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const BottomNavBar(),
          ),
          (route) => false,
        );
      } else {
        final responseBody = await response.stream.bytesToString();
        print(
            "Failed to upload photos. Status code: $responseBody and status ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

// upload old
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
