// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/closeappScreen.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationScreen.dart';
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/controllers/pageRouteController/pagerouteController.dart';
import 'package:_96kuliapp/controllers/planControllers/premiumPlanController.dart';
import 'package:_96kuliapp/dummy.dart';
import 'package:_96kuliapp/homedummy.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/screens/ProfilePhotoRequestToChange/ProfilePhotoRequestToChangeScreen.dart';
import 'package:_96kuliapp/screens/accounts_and_settings/updatePasswordScreen.dart';
import 'package:_96kuliapp/screens/auth_Screens/loginScreen.dart';
import 'package:_96kuliapp/screens/auth_Screens/loginScreen2.dart';
import 'package:_96kuliapp/screens/auth_Screens/registerOTPScreen.dart';
import 'package:_96kuliapp/screens/auth_Screens/registerScreen.dart';
import 'package:_96kuliapp/screens/editProfile_screens/editBasicInfo.dart';
import 'package:_96kuliapp/screens/editProfile_screens/editFamilyDetails.dart';
import 'package:_96kuliapp/screens/editProfile_screens/editGalleryPhotos.dart';
import 'package:_96kuliapp/screens/editProfile_screens/editLifestyleDetails.dart';
import 'package:_96kuliapp/screens/exploreAppScreens/exploreAppAfterLogin/exploreAppAfterLogin.dart';
import 'package:_96kuliapp/screens/onboarding/welcomeScreen.dart';
import 'package:_96kuliapp/screens/plans/addOnPlan.dart';
import 'package:_96kuliapp/screens/plans/limitedOfferPlanScreen.dart';
import 'package:_96kuliapp/screens/plans/upgradeScreen.dart';
import 'package:_96kuliapp/screens/profile_screens/edit_profile.dart';
import 'package:_96kuliapp/screens/profile_screens/user_details.dart';
import 'package:_96kuliapp/screens/userInfoForms/userInfoStepOne.dart';
import 'package:_96kuliapp/screens/userInfoForms/userInfoStepTwo.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

import 'package:_96kuliapp/screens/userInfoForms/userinfoStepFive.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepFour.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepSix.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepThree.dart';
import 'package:_96kuliapp/utils/bottomnavBar.dart';
import 'package:path_provider/path_provider.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {}
  }

  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings('ic_notification');
    var iosinitializationSettings = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosinitializationSettings);
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        print("NOTI Bhaiya received");
        handleMessage(context, message);
      },
    );
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen(
      (event) {
        print("NOTI Bhaiya received");
        sendNotificationTracking(notificationID: event.data["notification_id"]);

        print(
            "message in noti ${event.notification?.title} and sub title ${event.notification?.body}");
        initLocalNotifications(context, event);
        showNotificatons(event);
      },
    );
  }

  Future<void> showNotificatons(RemoteMessage message) async {
    // Extract image URL from the message payload
    final imageUrl = message.notification?.android?.imageUrl;
    final notificationType = message.data['Type'];
    print("Notification Type $notificationType");
    AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel(
      Random.secure().nextInt(1000).toString(),
      'High importance',
      importance: Importance.high,
    );

    AndroidNotificationDetails androidNotificationDetails;

    if (notificationType == "PLAN") {
      if (imageUrl != null && imageUrl.isNotEmpty) {
        // Download the image to make it usable for BigPictureStyleInformation
        final bigPicturePath =
            await _downloadAndSaveImage(imageUrl, 'big_picture');

        final bigPictureStyleInformation = BigPictureStyleInformation(
          FilePathAndroidBitmap(bigPicturePath),
          contentTitle: message.notification?.title,
          summaryText: message.notification?.body,
        );

        androidNotificationDetails = AndroidNotificationDetails(
          androidNotificationChannel.id,
          ongoing: true,
          androidNotificationChannel.name,
          channelDescription: 'description',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker',
          icon: 'ic_notification',
          styleInformation: bigPictureStyleInformation,
        );
      } else {
        // Default notification style
        androidNotificationDetails = AndroidNotificationDetails(
          androidNotificationChannel.id,
          androidNotificationChannel.name,
          ongoing: true,
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker',
          icon: 'ic_notification',
        );
      }
    } else if (notificationType == "CircleImage") {
      Uint8List? circularImage;
      if (imageUrl != null && imageUrl.isNotEmpty) {
        circularImage = await _getCircularImage(imageUrl);
      }

      androidNotificationDetails = AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        channelDescription: 'description',
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker',
        icon: 'ic_notification',

        largeIcon: circularImage != null
            ? ByteArrayAndroidBitmap(circularImage)
            : null, // Display circular image if available
      );
    } else {
      print("THIS IS ELSE CONDITION");
      if (imageUrl != null && imageUrl.isNotEmpty) {
        // Download the image to make it usable for BigPictureStyleInformation
        final bigPicturePath =
            await _downloadAndSaveImage(imageUrl, 'big_picture');

        final bigPictureStyleInformation = BigPictureStyleInformation(
          FilePathAndroidBitmap(bigPicturePath),
          contentTitle: message.notification?.title,
          summaryText: message.notification?.body,
        );

        androidNotificationDetails = AndroidNotificationDetails(
          androidNotificationChannel.id,
          androidNotificationChannel.name,
          channelDescription: 'description',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker',
          icon: 'ic_notification',
          styleInformation: bigPictureStyleInformation,
        );
      } else {
        // Default notification style
        androidNotificationDetails = AndroidNotificationDetails(
          androidNotificationChannel.id,
          androidNotificationChannel.name,
          channelDescription: 'description',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker',
          icon: 'ic_notification',
        );
      }
    }

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title.toString(),
        message.notification?.body.toString(),
        notificationDetails,
      );
    });
  }

// Helper function to download and save the image
  Future<String> _downloadAndSaveImage(String url, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final response = await http.get(Uri.parse(url));
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<Uint8List> _getCircularImage(String imageUrl) async {
    try {
      // Fetch the image from the network
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        // Decode the image and resize it
        final codec = await ui.instantiateImageCodec(
          response.bodyBytes,
          targetWidth: 200, // Set the desired width
          targetHeight: 200, // Set the desired height
        );
        final frame = await codec.getNextFrame();

        // Prepare a canvas to draw the circular image
        final pictureRecorder = ui.PictureRecorder();
        final canvas = Canvas(pictureRecorder);

        final paint = Paint()..isAntiAlias = true;
        final size = ui.Size(
            frame.image.width.toDouble(), frame.image.height.toDouble());
        final rect = Offset.zero & size;

        // Clip the canvas to a circle and draw the image
        canvas.clipPath(Path()..addOval(rect));
        canvas.drawImage(frame.image, Offset.zero, paint);

        // Convert the canvas content to a final image
        final picture = pictureRecorder.endRecording();
        final image =
            await picture.toImage(frame.image.width, frame.image.height);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

        // Return the resulting circular image as a Uint8List
        return byteData!.buffer.asUint8List();
      } else {
        throw Exception(
            'Failed to load image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in _getCircularImage: $e');
      rethrow;
    }
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    print("THIS IS NOTI $token");
    return token ?? "";
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    // terminated
    print("THIS IS APP For NOTO");

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

// when in background
    FirebaseMessaging.onMessageOpenedApp.listen(
      (event) {
        handleMessage(context, event);
      },
    );
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    print("THIS IS APP For NOTO");
    sendNotificationTrackingOpen(
        notificationID: message.data["notification_id"]);
    String? token = sharedPreferences?.getString("token");
    print("Inside handleMessage for foreground ${message.data['route']}");
    String? pageIndex = sharedPreferences?.getString("PageIndex");

    if (navigatorKey.currentState != null) {
      print("THIS IS APP RUNNING");
      if (token != null) {
        if (pageIndex == "8") {
          if (message.data['route'] == "EditProileLifestyle") {
            navigatorKey.currentState!.pushReplacement(
              MaterialPageRoute(
                  builder: (context) => const EditLifestyleDetails()),
            );
          } else if (message.data['route'] == "ProfileEditActivity") {
            print("ONSODE PROFIE EDIT");
            navigatorKey.currentState!.pushReplacement(
              MaterialPageRoute(builder: (context) => const EditProfile()),
            );
          } else if (message.data['route'] == "EditProfileFamilyDetails") {
            print("ONSODE PROFIE EDIT");
            navigatorKey.currentState!.pushReplacement(
              MaterialPageRoute(
                  builder: (context) => const EditFamilyDetailsScreen()),
            );
          } else if (message.data['route'] == "EditProfileMyPhoto") {
            print("ONSODE PROFIE EDIT");
            navigatorKey.currentState!.pushReplacement(
              MaterialPageRoute(
                  builder: (context) => const EditGalleryPhotosScreen()),
            );
          } else if (message.data['route'] == "EditSpiritualPhoto") {
            print("ONSODE PROFIE EDIT");
            navigatorKey.currentState!.pushReplacement(
              MaterialPageRoute(
                  builder: (context) => const EditGalleryPhotosScreen()),
            );
          } else if (message.data['route'] == "UpgradeMembershipPlan") {
            print("ONSODE PROFIE EDIT");
            navigatorKey.currentState!.pushReplacement(
              MaterialPageRoute(builder: (context) => const UpgradePlan()),
            );
          } else if (message.data['route'] == "RecommendedListings") {
            print("ONSODE PROFIE EDIT");
            final DashboardController dashboardController =
                Get.put(DashboardController());
            navigatorKey.currentState!
                .pushReplacement(
              MaterialPageRoute(builder: (context) => const BottomNavBar()),
            )
                .then(
              (value) {
                dashboardController.updateMathcesScreen(0);

                dashboardController.onItemTapped(1);
              },
            );
          } else if (message.data['route'] == "MemberDetail") {
            print("INSIDE PROFILE EDIT ${message.data["RecommendMember_id"]}");

            // Safely parse the member ID
            final memberId = message.data["RecommendMember_id"];
            final parsedMemberId =
                memberId != null ? int.tryParse(memberId) : null;

            if (parsedMemberId != null) {
              print("THIS IS PARSED MEM");
              navigatorKey.currentState!.pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                      UserDetails(notificationID: 0, memberid: parsedMemberId),
                ),
              );
            } else {
              print("Invalid or missing member_id in message data");
              // Handle the error case, if needed
            }
          } else if (message.data['route'] == "AddOnPlan") {
            print("ONSODE PROFIE EDIT");
            navigatorKey.currentState!.pushReplacement(
              MaterialPageRoute(builder: (context) => const Addonplan()),
            );
          } else if (message.data['route'] == "DocumentVerification") {
            print("ONSODE PROFIE EDIT");
            navigatorKey.currentState!.pushReplacement(
              MaterialPageRoute(builder: (context) => const UserInfoStepSix()),
            );
          } else if (message.data['route'] == "CasteVerification") {
            print("ONSODE PROFIE EDIT");
            navigatorKey.currentState!.pushReplacement(
              MaterialPageRoute(
                  builder: (context) => const CasteVerificationScreen()),
            );
          } else if (message.data['route'] == "PhotoVerification") {
            print("ONSODE PROFIE EDIT");
            navigatorKey.currentState!.pushReplacement(
              MaterialPageRoute(
                  builder: (context) =>
                      const ProfilePhotoRequestToChangeScreen()),
            );
          } else if (message.data['route'] == "EditBasicInfo") {
            print("ONSODE PROFIE EDIT");
            navigatorKey.currentState!.pushReplacement(
              MaterialPageRoute(
                  builder: (context) => const EditBasicInfoScreen()),
            );
          } else if (message.data['route'] == "SplashScreen") {}
        } else if (pageIndex == "9") {
          if (message.data["route"] == "UpgradeMembershipPlan") {
            final PremiumPlanController premiumPlanController =
                Get.put(PremiumPlanController());
            final PaymentPremiumController paymentController =
                Get.put(PaymentPremiumController());
            premiumPlanController.fetchPlans();
          } else {
            final PremiumPlanController premiumPlanController =
                Get.put(PremiumPlanController());
            final PaymentPremiumController paymentController =
                Get.put(PaymentPremiumController());
            premiumPlanController.fetchPlans();

            navigatorKey.currentState!.pushReplacement(
              MaterialPageRoute(
                  builder: (context) => const ExploreAppAfterLogin()),
            );
          }
        }

        {}
      } else {
        if (message.data['route'] == "register") {
          print("Navigating to RegisterScreen");
          navigatorKey.currentState!.pushReplacement(
            MaterialPageRoute(builder: (context) => const RegisterScreen()),
          );
        } else {
          navigatorKey.currentState!.pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen2()),
          );
        }
      }
    } else {
      if (token != null) {
        if (pageIndex == "8") {
          if (message.data['route'] == "EditProileLifestyle") {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const EditLifestyleDetails()),
            );
          } else if (message.data['route'] == "EditProfileFamilyDetails") {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const EditFamilyDetailsScreen()),
            );
          } else if (message.data['route'] == "EditProfileMyPhoto") {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const EditGalleryPhotosScreen()),
            );
          } else if (message.data['route'] == "UpgradeMembershipPlan") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UpgradePlan()),
            );
          } else if (message.data['route'] == "PhotoVerification") {
            print("ONSODE PROFIE EDIT");
            navigatorKey.currentState!.pushReplacement(
              MaterialPageRoute(
                  builder: (context) =>
                      const ProfilePhotoRequestToChangeScreen()),
            );
          } else if (message.data['route'] == "RecommendedListings") {
            print("ONSODE PROFIE EDIT");
            final DashboardController dashboardController =
                Get.put(DashboardController());
            navigatorKey.currentState!
                .pushReplacement(
              MaterialPageRoute(builder: (context) => const BottomNavBar()),
            )
                .then(
              (value) {
                dashboardController.updateMathcesScreen(0);

                dashboardController.onItemTapped(1);
              },
            );
          } else if (message.data['route'] == "ProfileEditActivity") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditProfile()),
            );
          } else if (message.data['route'] == "AddOnPlan") {
            print("ONSODE PROFIE EDIT");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Addonplan()),
            );
          } else if (message.data['route'] == "DocumentVerification") {
            print("ONSODE PROFIE EDIT");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserInfoStepSix()),
            );
          } else if (message.data['route'] == "CasteVerification") {
            print("ONSODE PROFIE EDIT");
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CasteVerificationScreen()),
            );
          } else if (message.data['route'] == "EditBasicInfo") {
            print("ONSODE PROFIE EDIT");
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const EditBasicInfoScreen()),
            );
          } else if (message.data['route'] == "ExplorerMemberList") {
            print("ONSODE PROFIE EDIT");
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ExploreAppAfterLogin()),
            );
          } else if (message.data['route'] == "SplashScreen") {
            checkUserTokenAndNavigateAppClose(context);
          }
        } else if (pageIndex == "9") {
          if (message.data["route"] == "UpgradeMembershipPlan") {
            final PremiumPlanController premiumPlanController =
                Get.put(PremiumPlanController());
            final PaymentPremiumController paymentController =
                Get.put(PaymentPremiumController());
            premiumPlanController.fetchPlans();
          } else {
            final PremiumPlanController premiumPlanController =
                Get.put(PremiumPlanController());
            final PaymentPremiumController paymentController =
                Get.put(PaymentPremiumController());
            premiumPlanController.fetchPlans();

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ExploreAppAfterLogin()),
            );
          }
        } else {}
      } else {
        if (message.data['route'] == "register") {
          print("Navigating to RegisterScreen");
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegisterScreen(),
              ));
          /*   Navigator.pushReplacement(
          MaterialPageRoute(builder: (context) => const RegisterScreen()),
        );*/
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen2()),
          );
        }
      }
      print("Navigator key not accessible.");
    }
  }

  Future<void> checkUserTokenAndNavigateAppClose(BuildContext context) async {
    String? pageIndex = sharedPreferences?.getString("PageIndex");
    String? token = sharedPreferences?.getString("token");

    if (token == null) {
      // If no token, navigate to the welcome screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    } else {
      // Navigate based on page index
      switch (pageIndex) {
        case "1":
          navigatorKey.currentState!.pushReplacement(
            MaterialPageRoute(builder: (context) => const RegisterOTPScreen()),
          );
          break;
        case "2":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserInfoStepOne()),
          );
          break;
        case "3":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserInfoStepTwo()),
          );
          break;
        case "4":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserInfoStepThree()),
          );
          break;
        case "5":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserInfoStepFour()),
          );
          break;
        case "6":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserInfoStepFive()),
          );
          break;
        case "7":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserInfoStepSix()),
          );
          break;
        case "8":
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavBar()),
          );
          break;
        default:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => WelcomeScreen()),
          );
          break;
      }
    }
  }
}
