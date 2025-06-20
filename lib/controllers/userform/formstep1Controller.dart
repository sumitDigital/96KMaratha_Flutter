import 'dart:async';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:_96kuliapp/commons/appconstants.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationBlock.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationBlockController.dart';
import 'package:_96kuliapp/controllers/auth/casteVerificationScreen.dart';
import 'package:_96kuliapp/controllers/formfields/castController.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/models/forms/CountryModel.dart';
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:intl/intl.dart';
import 'package:_96kuliapp/screens/userInfoForms/userInfoStepTwo.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:phone_form_field/phone_form_field.dart';

class StepOneController extends GetxController {
  final CastController _castController = Get.put(CastController());
  final LocationController _locationController = Get.put(LocationController());
  TextEditingController numberchilren = TextEditingController();
  TextEditingController physicalStatus = TextEditingController();
  PhoneController phoneNumberController =
      PhoneController(initialValue: PhoneNumber.parse('+91'));

  // static String? language = sharedPreferences?.getString("Language");

  var phvalidation = true.obs;
  var selectedCountryCode = "".obs;

  var endhours = 0.obs;
  var endminutes = 0.obs;
  var endseconds = 0.obs;

  var searchedHeightList = <FieldModel>[].obs;

  var isSubmitted = false.obs;
  var dateofbirth = "".obs;
  var selectedManglikValidated = false.obs;
  var manglikSelected = FieldModel().obs;
  var parentContactValidated = false.obs;

  var selected = false.obs;

  var isLoading = false.obs;
  var parentContactSelected = FieldModel().obs;

  void searchMinHeight(String query) {
    if (query.isEmpty) {
      searchedHeightList.value = heightInFeet;
    } else {
      searchedHeightList.value = heightInFeet
          .where((item) => item.name!
              .toLowerCase()
              .startsWith(query.toLowerCase())) // Filter by name
          .toList();
    }
  }

  var bloodGroups = [
    FieldModel(id: 1, name: 'A+ve'),
    FieldModel(id: 2, name: 'A-ve'),
    FieldModel(id: 3, name: 'B+ve'),
    FieldModel(id: 4, name: 'B-ve'),
    FieldModel(id: 5, name: 'O+ve'),
    FieldModel(id: 6, name: 'O-ve'),
    FieldModel(id: 7, name: 'AB+ve'),
    FieldModel(id: 8, name: 'AB-ve'),
  ].obs;

  // Selected blood group
  var selectedBloodGroup = Rxn<FieldModel>();
  // Selected blood index (for tracking purposes)
  var selectedBloodIndex = Rxn<int>();

  // Method to update the selected blood group
  void updateBloodGroup(FieldModel selectedItem) {
    selectedBloodGroup.value = selectedItem;
    selectedBloodIndex.value = bloodGroups.indexOf(selectedItem);
  }

  // Preselect blood group based on ID
  void preselectBloodGroup(int id) {
    FieldModel? selected = bloodGroups.firstWhere((element) => element.id == id,
        orElse: () => FieldModel());
    if (selected.id != null) {
      updateBloodGroup(selected);
    }
  }

  void preselectNumberOfChildren(int id) {
    FieldModel? selected = numberOfChildren
        .firstWhere((element) => element.id == id, orElse: () => FieldModel());
    if (selected.id != null) {
      updateNumberOfChildren(selected);
    }
  }

  var heightInFeet = <FieldModel>[].obs;

  void regenerateHeightList() {
    String? language = sharedPreferences?.getString("Language");

    heightInFeet.value = List<FieldModel>.generate(37, (index) {
      int feet = 4 + (index ~/ 12);
      int inches = index % 12;
      double totalInches = (feet * 12 + inches).toDouble();
      double heightInCm = totalInches * 2.54;

      return FieldModel(
        id: index + 1,
        name:
            '$feet\'$inches" - ${heightInCm.toStringAsFixed(2)} ${language == "en" ? 'cm' : "सेमी"}',
      );
    });
  }

  // var heightInFeet = List<FieldModel>.generate(37, (index) {
  //   int feet = 4 + (index ~/ 12); // Calculate feet starting from 4
  //   int inches = index % 12; // Calculate inches
  //   double totalInches = (feet * 12 + inches).toDouble(); // Convert to double
  //   double heightInCm = totalInches * 2.54; // Convert inches to centimeters
  //   String? language = sharedPreferences?.getString("Language");
  //   // Return the FieldModel with both feet/inches and cm
  //   return FieldModel(
  //     id: index + 1,
  //     name:
  //         '$feet\'$inches" - ${heightInCm.toStringAsFixed(2)} ${language == "en" ? 'cm' : "सेमी"}',
  //   );
  // }).obs;

  var selectedHeight = Rxn<FieldModel>();
  // Selected height index (for tracking purposes)
  var selectedHeightIndex = Rxn<int>();

  // Method to update the selected height
  void updateHeight(FieldModel selectedItem) {
    selectedHeight.value = selectedItem;
    selectedHeightIndex.value = heightInFeet.indexOf(selectedItem);
  }

  // Preselect height based on ID
  void preselectHeight(int id) {
    FieldModel? selected = heightInFeet
        .firstWhere((element) => element.id == id, orElse: () => FieldModel());
    if (selected.id != null) {
      updateHeight(selected);
    }
  }

  var headingText = "".obs;
  var headingImage = "".obs;

  var isvalidate = false.obs;
  var selected24HourFormat = "".obs;
  var selectedMaritalStatus = FieldModel().obs;
  var selectedMaritialStatusValidated = false.obs;
  var selectedChildren = FieldModel().obs;
  var selectedChildrenValidated = false.obs;

  var isPageLoading = false.obs;
  var basicInfoData = {}.obs; // To hold the API response data
  var selectedDay = Rx<DateTime?>(null);
  var zodiacSigns = <FieldModel>[].obs;

  void zodiacsigList() {
    String? language = sharedPreferences?.getString("Language");
    zodiacSigns.value = language == 'en'
        ? <FieldModel>[
            FieldModel(id: 1, name: 'Aries'),
            FieldModel(id: 2, name: 'Taurus'),
            FieldModel(id: 3, name: 'Gemini'),
            FieldModel(id: 4, name: 'Cancer'),
            FieldModel(id: 5, name: 'Leo'),
            FieldModel(id: 6, name: 'Virgo'),
            FieldModel(id: 7, name: 'Libra'),
            FieldModel(id: 8, name: 'Scorpio'),
            FieldModel(id: 9, name: 'Sagittarius'),
            FieldModel(id: 10, name: 'Capricorn'),
            FieldModel(id: 11, name: 'Aquarius'),
            FieldModel(id: 12, name: 'Pisces'),
          ]
        : <FieldModel>[
            FieldModel(id: 1, name: 'मेष'),
            FieldModel(id: 2, name: 'वृषभ'),
            FieldModel(id: 3, name: 'मिथुन'),
            FieldModel(id: 4, name: 'कर्क'),
            FieldModel(id: 5, name: 'सिंह'),
            FieldModel(id: 6, name: 'कन्या'),
            FieldModel(id: 7, name: 'तुळ'),
            FieldModel(id: 8, name: 'वृश्चिक'),
            FieldModel(id: 9, name: 'धनु'),
            FieldModel(id: 10, name: 'मकर'),
            FieldModel(id: 11, name: 'कुंभ'),
            FieldModel(id: 12, name: 'मीन'),
          ];
  }

  @override
  void onInit() {
    super.onInit();
    fetchBasicInfo();
    zodiacsigList();
    regenerateHeightList();
  }

  final CasteVerificationBlockController _casteVerificationBlockController =
      Get.put(CasteVerificationBlockController());
  Future<void> fetchBasicInfo() async {
    String? token = sharedPreferences!.getString("token");

    print("Token is $token");
    try {
      String? language = sharedPreferences?.getString("Language");
      isPageLoading(true);
      final response = await http.get(
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        Uri.parse('${Appconstants.baseURL}/api/basic-info-data?lang=$language'),
      );
      print("response is ${response.body}");
      if (response.statusCode == 200) {
        basicInfoData.value = jsonDecode(response.body);
        print("basic info is  $basicInfoData");
        headingText.value = basicInfoData["Offer_Heading"];
        headingImage.value = basicInfoData["Offer_Img"];
        print("THIS IS IMAGE SHOWN IN ${basicInfoData["End_Date_time"]}");
        await Future.wait([_castController.fetchSectionFromApi()]);

        if (basicInfoData["End_Date_time"] != null) {
          String dateTimeString = basicInfoData["End_Date_time"];

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

        dateofbirth.value = basicInfoData["date_of_birth"] ?? "DD/MM/YYYY";
        print("in section");
        _castController.selectedSection.value = _castController.sectionList
            .firstWhere((element) => element.id == basicInfoData["section"],
                orElse: () => FieldModel());
        print("This is sectoion ${_castController.selectedSection.value.name}");
        if (basicInfoData["ras"] != null) {
          await Future.wait([
            _castController.fetchSectionFromApi(),
            _castController.fetchSubSectionFromApi(),
            _castController.fetchCastFromApi(),
            _locationController.fetchPlaces()
          ]);
          print("This is dta ");
          parentContactSelected.value.id =
              basicInfoData["contact_number_visibility"];
// Assuming phoneNumberController is a custom controller

          phoneNumberController = PhoneController(
              initialValue: PhoneNumber(
                  isoCode: IsoCode.IN, nsn: basicInfoData["mobile"]));

          // rascontroller.rasSelected.value.id = rascontroller.rassList.where((e) => e.id == 2 ,).
          /*    rascontroller.rasSelected.value = rascontroller.rassList.firstWhere(
  (e) => e.id == basicInfoData["ras"],  // Replace '2' with the ID you want to preselect
  orElse: () => FieldModel(),  // In case the ID is not found, return an empty model
);*/
          selectedZodiacSign.value = zodiacSigns.firstWhere(
            (element) => element.id == basicInfoData["ras"],
          );
          var placeOfBirthId = basicInfoData["place_of_birth"];

// Find the matching CountryModel based on the id
          var foundPlace = _locationController.places.firstWhere(
            (element) => element.id.toString() == placeOfBirthId,
            orElse: () => CountryModel(),
          );

          print("found place ${foundPlace.id}");
          if (foundPlace.id != null) {
            // Assign the found place to the selectedPlace's CountryModel reference
            _locationController.selectedPlace.value.id = foundPlace.id;
            _locationController.selectedPlace.value.name = foundPlace.name;
          }
          _castController.selectedSubSection.value =
              _castController.subSectionList.firstWhere(
            (element) => element.id == basicInfoData["subsection"],
            orElse: () => FieldModel(),
          );
          _castController.selectedCast.value =
              _castController.castList.firstWhere(
            (element) => element.id == basicInfoData["subcaste"],
            orElse: () => FieldModel(),
          );
          print("Manglik ${basicInfoData["manglik"]}");

          selectedPhysicalStatus.value.id = basicInfoData["disability"];
          manglikSelected.value.id = basicInfoData["manglik"];
          selectedMaritalStatus.value.id = basicInfoData["marital_status"];
          selectedEatingHabit.value.id = basicInfoData["dietary_habits"];
          selectedSmokingHabit.value.id = basicInfoData["smoking_habits"];
          selectedDrinkingHabit.value.id = basicInfoData["drinking_habits"];

          preselectBloodGroup(basicInfoData["blood_group"]);
          preselectHeight(basicInfoData["height"]);
          convertTo12HourFormat(basicInfoData["time_of_birth"]);
          print("children is this ${basicInfoData["have_childs"]}");
          selectedChildren.value.id = basicInfoData["have_childs"];
          if (basicInfoData["no_of_chidls"] != null) {
            //  numberchilren.text = ;
            preselectNumberOfChildren(basicInfoData["no_of_chidls"]);
          }
          print("Basic info is this ${basicInfoData["other_disability"]}");
          if (basicInfoData["other_disability"] != null) {
            physicalStatus.text = basicInfoData["other_disability"];
          }

          print(
              "This is contact details ${basicInfoData["contact_number_visibility"]}");
        } else {
          // here make values empty
        }
        print("this is page name ${basicInfoData["redirection"]["pagename"]}");
/*if(basicInfoData["redirection"]["pagename"].trim() == "CASTE-VERIFICATION-PENDING"){
print("this is page name inside ${basicInfoData["redirection"]["pagename"]}");

  _casteVerificationBlockController.popup.value = basicInfoData["redirection"]["Popup"];
     navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => CasteVerificationBlock(),) ,   (route) => false,);
 
}else if (basicInfoData["redirection"]["pagename"].trim() == "CASTE-VERIFICATION"){
//  _casteVerificationBlockController.popup.value = basicInfoData["redirection"]["Popup"];
     navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => CasteVerificationScreen(),) ,   (route) => false,);
 
}*/
      } else {
        print("Fetched successfully Error");

        // Handle error if needed
        //     Get.snackbar('Error', 'Failed to load data');
      }
    } catch (e) {
      // Handle exception
      //  Get.snackbar('Error', e.toString());
    } finally {
      isPageLoading(false);
    }
  }

  // Method to pick a date
  Future<void> pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDay.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDay.value) {
      selectedDay.value = DateTime(picked.year, picked.month, picked.day);
    }
  }

  void convertTo12HourFormat(String time24Hour) {
    // Parse the 24-hour format time
    DateTime dateTime = DateFormat("HH:mm").parse(time24Hour);

    // Convert to 12-hour AM/PM format
    String hour = DateFormat("hh").format(dateTime); // Hour in 12-hour format
    String minute = DateFormat("mm").format(dateTime); // Minute
    String timePeriod = DateFormat("a").format(dateTime); // AM/PM

    selectedHour.value = hour;
    selectedMinute.value = minute;
    selectedTimeFormat.value = timePeriod;
    selected24HourFormat.value = time24Hour;
  }

  var selectedSmokingHabit = FieldModel().obs;
  var selectedDrinkingHabit = FieldModel().obs;

  var selectedSmokingHabitValidated = false.obs;

  var selectedDrinkingHabitValidated = false.obs;

  var selectedPhysicalStatus = FieldModel().obs;
  var selectedPhysicalStatusValidated = false.obs;

  var selectedEatingHabit = FieldModel().obs;

  var selectedEatingHabitValidated = false.obs;

  var selectedChildrenInt = 0.obs;

  var selectedTime = TimeOfDay.now().obs;
  var selectedHour = "".obs;
  var selectedMinute = "".obs;
  var selectedTime24 = TimeOfDay.now().obs;
  var selectedHour24 = "".obs;
  var selectedMinute24 = "".obs;
  var selectedTimeFormat = "".obs;
  void updateChildren(FieldModel value) {
    selectedChildren.value = value;
  }

  void updateManglik(FieldModel value) {
    manglikSelected.value = value;

    selectedManglikValidated.value = true;
  }

  void updateParentContact(FieldModel value) {
    print("Update conatct for this ");
    parentContactSelected.value = value;

    parentContactValidated.value = true;
  }

  void updatePhysicalStatus(FieldModel value) {
    selectedPhysicalStatus.value = value;
    if (selectedPhysicalStatus.value.id == 1) {
      physicalStatus.text = "";
    }
    selectedPhysicalStatusValidated.value = true;
  }

  void updateMaritalStatus(FieldModel value) {
    selectedMaritalStatus.value = value;

    selectedMaritialStatusValidated.value = true;
  }

  void updateSmokingHabit(FieldModel value) {
    selectedSmokingHabit.value = value;

    selectedSmokingHabitValidated.value = true;
  }

  void updateDrinkingHabit(FieldModel value) {
    selectedDrinkingHabit.value = value;

    selectedDrinkingHabitValidated.value = true;
  }

  void updateEatingHabit(FieldModel value) {
    selectedEatingHabit.value = value;

    selectedEatingHabitValidated.value = true;
  }

  void updateTime(TimeOfDay time, BuildContext context) {
    final int hourIn12Format =
        time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final String period = time.period == DayPeriod.am ? 'AM' : 'PM';

    selectedTime.value = time;
    selectedHour.value = hourIn12Format.toString().padLeft(2, '0');
    selectedMinute.value = time.minute.toString().padLeft(2, '0');
    selectedTimeFormat.value = period;
    final int hourIn24Format = time.hour; // 24-hour format
    final String formattedHour = hourIn24Format.toString().padLeft(2, '0');
    final String formattedMinute = time.minute.toString().padLeft(2, '0');

    selectedTime24.value = time;
    selectedHour24.value = hourIn24Format.toString().padLeft(2, '0');
    selectedMinute24.value = formattedMinute;
    selectedTimeFormat.value = time.period == DayPeriod.am ? 'AM' : 'PM';

    // Update the 24-hour format observable
    selected24HourFormat.value = "$formattedHour:$formattedMinute";
  }

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final facebookAppEvents = FacebookAppEvents();

  Future<void> BasicForm(
      {required String timeOfBirth,
      required String placeOfBirth,
      required int ras,
      required int manglik,
      required int maritalStatus,
      required int haveChildren,
      required int numberOfChildren,
      required int height,
      required int contactNumberVisiblity,
      required String parentsContactNumber,
      required int bloodGroup,
      required int disability,
      required String disabilityDesc,
      required BuildContext context}) async {
    // The API URL where you want to send the POST request
    String url = '${Appconstants.baseURL}/api/basic-info';
    isLoading.value = true;
    // The request body
    Map<String, dynamic> body = {
      "time_of_birth": timeOfBirth,
      "place_of_birth": placeOfBirth,
      "ras": ras,
      "manglik": manglik,
      "marital_status": maritalStatus,
      "height": height,
      "contact_number_visibility": contactNumberVisiblity,
      "mobile": parentsContactNumber,
      "mobile_countryCode": "91",
      "blood_group": bloodGroup,
      "disability": disability,
      "other_disability": disabilityDesc,
    };
    if (haveChildren == 2 || haveChildren == 3) {
      body["have_childs"] = haveChildren;
      body["no_of_chidls"] = numberOfChildren;
    }

    try {
      String? token = sharedPreferences!.getString("token");

      // Sending the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      print("No segments ${response.body}");
      if (response.statusCode == 200) {
        // Handle success
        print('basic successful');
        analytics.logEvent(name: "app_96k_basic_info_form_completed");
        // You can handle the response data here
        //  var data = jsonDecode(response.body);
        // Do something with the data if needed
        facebookAppEvents.logEvent(
            name: "Fb_96k_app_basic_info_form_completed");
        print('Response body: ${response.body}');
        sharedPreferences!.setString("PageIndex", "3");
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UserInfoStepTwo(),
            ));
        //  Get.offAllNamed(AppRouteNames.userInfoStepTwo);
      } else {
        // Handle error
        print('Failed to register: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // = [
  //   FieldModel(id: 1, name: AppLocalizations.of(Get.context!)!.aries),
  //   FieldModel(id: 2, name: AppLocalizations.of(Get.context!)!.taurus),
  //   FieldModel(id: 3, name: AppLocalizations.of(Get.context!)!.gemini),
  //   FieldModel(id: 4, name: AppLocalizations.of(Get.context!)!.cancer),
  //   FieldModel(id: 5, name: AppLocalizations.of(Get.context!)!.leo),
  //   FieldModel(id: 6, name: AppLocalizations.of(Get.context!)!.virgo),
  //   FieldModel(id: 7, name: AppLocalizations.of(Get.context!)!.libra),
  //   FieldModel(id: 8, name: AppLocalizations.of(Get.context!)!.scorpio),
  //   FieldModel(id: 9, name: AppLocalizations.of(Get.context!)!.sagittarius),
  //   FieldModel(id: 10, name: AppLocalizations.of(Get.context!)!.capricorn),
  //   FieldModel(id: 11, name: AppLocalizations.of(Get.context!)!.aquarius),
  //   FieldModel(id: 12, name: AppLocalizations.of(Get.context!)!.pisces),
  // ];

  // void updateZodiacSigns() {
  //   String? lang = sharedPreferences?.getString("Language");
  //   zodiacSigns = [
  //     FieldModel(id: 1, name: lang == "en" ? "Aries" : "मेष"),
  //     FieldModel(id: 2, name: lang == "en" ? "Taurus" : "वृषभ"),
  //     FieldModel(id: 3, name: lang == "en" ? "Gemini" : "मिथुन"),
  //     FieldModel(id: 4, name: lang == "en" ? "Cancer" : "कर्क"),
  //     FieldModel(id: 5, name: lang == "en" ? "Leo" : "सिंह"),
  //     FieldModel(id: 6, name: lang == "en" ? "Virgo" : "कन्या"),
  //     FieldModel(id: 7, name: lang == "en" ? "Libra" : "तुळ"),
  //     FieldModel(id: 8, name: lang == "en" ? "Scorpio" : "वृश्चिक"),
  //     FieldModel(id: 9, name: lang == "en" ? "Sagittarius" : "धनु"),
  //     FieldModel(id: 10, name: lang == "en" ? "Capricorn" : "मकर"),
  //     FieldModel(id: 11, name: lang == "en" ? "Aquarius" : "कुंभ"),
  //     FieldModel(id: 12, name: lang == "en" ? "Pisces" : "मीन"),
  //   ];

  //   update(); // Trigger UI update
  // }

  // Currently selected zodiac sign
  Rxn<FieldModel> selectedZodiacSign = Rxn<FieldModel>();

  // Method to update the selected zodiac sign
  void updateZodiacSign(FieldModel sign) {
    selectedZodiacSign.value = sign;
  }

  // number of children
  var numberOfChildren = [
    FieldModel(id: 1, name: '1'),
    FieldModel(id: 2, name: '2'),
    FieldModel(id: 3, name: '3+'),
  ].obs;

  var selectedNumberOfChildren = Rxn<FieldModel>();
  // Selected blood index (for tracking purposes)
  // var selectedBloodIndex = Rxn<int>();

  // Method to update the selected blood group
  void updateNumberOfChildren(FieldModel selectedItem) {
    selectedNumberOfChildren.value = selectedItem;
    //  selectedBloodIndex.value = bloodGroups.indexOf(selectedItem);
  }
}
