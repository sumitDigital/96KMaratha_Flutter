// import 'package:facebook_app_events/facebook_app_events.dart';
// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:io';

// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:_96kuliapp/screens/userInfoForms/pendingForms/userinfoIncompleteForm.dart';
import 'package:_96kuliapp/screens/userInfoForms/pendingForms/userinfoIncompleteForm1.dart';
import 'package:_96kuliapp/screens/userInfoForms/userInfoStepOne.dart';
import 'package:_96kuliapp/screens/userInfoForms/userInfoStepTwo.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:hive_flutter/hive_flutter.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/network_controller.dart';
import 'package:_96kuliapp/controllers/pageRouteController/pagerouteController.dart';
import 'package:_96kuliapp/firebase_options.dart';
import 'package:_96kuliapp/firebasenotifications.dart';
import 'package:_96kuliapp/home.dart';
import 'package:_96kuliapp/screens/auth_Screens/loginScreen2.dart';
import 'package:_96kuliapp/screens/onboarding/welcomeScreen.dart';
import 'package:_96kuliapp/screens/updateAppScreen.dart';
import 'package:_96kuliapp/splashScreens/meethorizontal.dart';
import 'package:_96kuliapp/splashScreens/meetincenter.dart';
import 'package:_96kuliapp/splashScreens/meetincentervertical.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/splash.dart';
import 'package:_96kuliapp/utils/splashScreen.dart';
// import 'package:no_screenshot/no_screenshot.dart';
import 'package:package_info_plus/package_info_plus.dart';
//import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:_96kuliapp/controllers/auth/languageChangeController.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/routes/routeConfig.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// import 'package:facebook_core/facebook_core.dart';
void main() async {
  // Ensure widgets are properly initialized
  final facebookAppEvents = FacebookAppEvents();
  WidgetsFlutterBinding.ensureInitialized();
  await FacebookAppEvents().setAutoLogAppEventsEnabled(true);

  // await FacebookAppEvents.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  String? appidfb = await facebookAppEvents.getApplicationId();
  print("THIS IS FB ID $appidfb");

  final packageInfo = await PackageInfo.fromPlatform();
  print(
      "THIS IS PACAKAGE INFO ${packageInfo.packageName} ${packageInfo.version}");

  sharedPreferences = await SharedPreferences.getInstance();
  await Hive.initFlutter();
  // Ensure LocationController is available before running the app
  await Hive.openBox('myBox');
  // Get.put(LocationController());

  // final _noScreenshot = NoScreenshot.instance;

  // bool result = await _noScreenshot.screenshotOff();

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessagingHandler);
  /*FlutterError.onError = (errorDetails){
    FirebaseCrashlytics.instance.recordFlutterFatalError;
  };
  PlatformDispatcher.instance.onError = (error , stack){
    FirebaseCrashlytics.instance.recordError(error, stack , fatal: true);
  return true;
  };*/
  final WelcomeControllerData wellcomeControllerData =
      Get.put(WelcomeControllerData());
  wellcomeControllerData.fetchExploreAppEnabled();

  // print("Result ss ${result}");

  runApp(const MyApp());
  // Listen for deep links when the app is resumed or opened
}

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundMessagingHandler(RemoteMessage message) async {
  print("NOTI Bhaiya received bg ${message.data["image"]}");
  sendNotificationTracking(notificationID: message.data["notification_id"]);
  await Firebase.initializeApp();
}

Future<void> sendNotificationTrackingOpen({dynamic notificationID}) async {
  print("NOTI ID $notificationID");

  try {
    // Example API call using the token
    final response = await http.post(
      Uri.parse(
          '${Appconstants.baseURL}/api/push-notification/mark-as-open/$notificationID'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    print("TIME RESP noti ${response.body}");
    if (response.statusCode == 200) {
      print('API call successful noti');
    } else {
      print('Failed to call API');
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> sendNotificationTracking({dynamic notificationID}) async {
  print("NOTI ID $notificationID");

  try {
    // Example API call using the token
    final response = await http.post(
      Uri.parse(
          '${Appconstants.baseURL}/api/push-notification/mark-as-sent/$notificationID'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    print("TIME RESP noti ${response.body}");
    if (response.statusCode == 200) {
      print('API call successful noti');
    } else {
      print('Failed to call API');
    }
  } catch (e) {
    print('Error: $e');
  }
}

SharedPreferences? sharedPreferences;
Future<void> sendToken({String? fcmToken}) async {
  try {
    // Fetch both education and specialization data in parallel
    print("Token will be sent this way");

    final response = await http.post(
        headers: {
          'Content-Type': 'application/json',
          //    "Authorization": "Bearer ${token}",
        },
        body: jsonEncode({
          'fcm_token': fcmToken,
        }),
        Uri.parse('${Appconstants.baseURL}/api/fcm/non-registered'));
    print("Token will be sent and response for fcm ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final UnregisteredID = data["id"];
      sharedPreferences?.setInt("UnregisteredID", UnregisteredID);
      print("Token will be sent and response for fcm ${response.body}");
      //  print("response body online  is this ${responsebody["data"]["data"]}");
    } else {
      //Get.snackbar('Error', 'Failed to load data');
      print("Token will not be sent");
    }
  } catch (e) {
    print("Error is this $e");
    //Get.snackbar('Error', e.toString());
  } finally {}
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Timer? _timer;
  // var mybox =  Hive.openBox('myBox');
  late Box mybox;
  @override
  void initState() {
    super.initState();
    _initializeHive();
    checkForUpdate();
    _checkTokenAndStartTimer();
    fetchTypeURL();
    NotificationServices().getDeviceToken().then(
      (value) {
        print("Value for notification $value");
        mybox.put("fcmtoken", value);
        sendToken(fcmToken: value);
      },
    );
    NotificationServices().requestNotificationPermission();

    /*  NotificationServices().requestNotificationPermissions();
    NotificationServices().setupInteractMessage(context);
    NotificationServices().firebaseInit();*/
  }

  void fetchTypeURL() async {
    final url = Uri.parse(
        'https://96kulimarathamarriage.com/migration/web/api/app-link'); // replace with your actual URL
    final headers = {
      'Accept': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);
      print("APITYPE $response");
      if (response.statusCode == 200) {
        jsonDecode(response.body);
        final data = jsonDecode(response.body);
        var type = data["api_mode"];
        Appconstants.typeAPI = type;
        print("demo $type");
      } else {
        throw Exception('Failed to load profile visitor data');
      }
    } catch (e) {
      throw Exception('Failed to load Type $e');
    }
    // final response = await http.get(url, headers: headers);

    // if (response.statusCode == 200) {
    //    jsonDecode(response.body);
    //    final data = jsonDecode(response.body);
    // } else {
    //   throw Exception('Failed to load profile visitor data');
    // }
  }

  Future<void> checkForUpdate() async {
    try {
      print('Checking for Update');
      AppUpdateInfo info = await InAppUpdate.checkForUpdate();

      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        print('Update available');
        await update();
      } else {
        print('No update available');
      }
    } catch (e) {
      print('Error checking for update: ${e.toString()}');
    }
  }

  Future<void> update() async {
    try {
      print('Starting update');
      await InAppUpdate.performImmediateUpdate();
    } catch (e) {
      print('Error performing update: ${e.toString()}');
      // You might want to handle this case, such as notifying the user.
    }
  }

  String? token =
      sharedPreferences?.getString('token'); // replace 'token' with your key
  Future<void> _checkTokenAndStartTimer() async {
    if (token != null) {
      await _sendApiCall();
      _startApiCallTimer();
    } else {
      _startApiCallTimer();
    }
  }

  Future<void> _initializeHive() async {
    // Open Hive box and assign it to the myBox variable
    mybox = await Hive.openBox('myBox');
  }

  // Your API call function
  Future<void> _sendApiCall() async {
    try {
      final String platform = Platform.isAndroid ? "android" : "ios";
      // Example API call using the token
      final response = await http.get(
        Uri.parse(
            '${Appconstants.baseURL}/api/update-online-status?device=$platform'),
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

  // Start the periodic timer that calls the API every 5 minutes
  void _startApiCallTimer() {
    print("TIMER STARTED ");
    _timer = Timer.periodic(const Duration(minutes: 5), (timer) async {
      await _sendApiCall();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("selected Language ${sharedPreferences?.getString("Language")}");
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageChangeController()),
      ],
      child:
          Consumer<LanguageChangeController>(builder: (context, value, child) {
        print("Value of locale ${value.appLocale}");
        return GetMaterialApp(
          navigatorKey: navigatorKey,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SplashScreen(),
          // home: userIncomplete_userForm(),
          // home: const userIncomplete_userFormOne(),
          title: '96K Matrimony Bureau',
          theme: ThemeData(
            datePickerTheme: const DatePickerThemeData(
              backgroundColor: Colors.white,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor:
                  Colors.white, // Set the background color of the picker
              hourMinuteShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                side: BorderSide(color: Colors.blue, width: 2),
              ), // Customize the shape of hour and minute input
              hourMinuteTextColor: WidgetStateColor.resolveWith((states) =>
                  states.contains(WidgetState.selected)
                      ? Colors.white
                      : Colors.blue), // Change text color based on selection
              hourMinuteColor: WidgetStateColor.resolveWith((states) => states
                      .contains(WidgetState.selected)
                  ? Colors.blue
                  : Colors
                      .white), // Change selected/unselected hour-minute color
              dialBackgroundColor:
                  Colors.orange[50], // Set background color of the clock dial
              entryModeIconColor:
                  Colors.blue, // Set color of the icon to switch between modes
              hourMinuteTextStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ), // Customize the hour and minute text style
            ),
            primaryColor: const Color.fromRGBO(234, 52, 74, 1),
            scaffoldBackgroundColor: Colors.white,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  // rgba(204, 40, 77, 1)
                  backgroundColor: const Color.fromRGBO(204, 40, 77, 1)),
            ),
            appBarTheme: AppBarTheme(
                titleTextStyle: CustomTextStyle.appBarTitle,
                backgroundColor:
                    const Color.fromARGB(255, 222, 222, 226).withOpacity(0.25)),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          locale: value.appLocale,
          //    getPages: AppRouteConfig.route,
        );
      }),
    );
  }
}

void navigateWithTransition({
  required GlobalKey<NavigatorState> navigatorKey,
  required Widget screen,
  Offset begin =
      const Offset(1.0, 0.0), // Default transition: slide in from right
  Offset end = Offset.zero, // End position
  Curve curve = Curves.easeInOut, // Transition curve
}) {
  navigatorKey.currentState?.push(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    ),
  );
}
