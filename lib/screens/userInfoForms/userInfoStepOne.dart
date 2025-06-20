//import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:_96kuliapp/commons/dialogues/logoutDialogoue.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/auth/logincontroller.dart';
import 'package:_96kuliapp/controllers/formfields/castController.dart';
import 'package:_96kuliapp/controllers/formfields/rasController.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/controllers/userform/formstep1Controller.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/auth_Screens/loginScreen2.dart';
import 'package:_96kuliapp/screens/userInfoForms/location/birthPlace/selectBirthPlace.dart';
import 'package:_96kuliapp/screens/userInfoForms/userInfoStepTwo.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepThree.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/buttonContainer.dart';
import 'package:_96kuliapp/utils/customdropdown.dart';
import 'package:_96kuliapp/utils/customsnackbar.dart';
import 'package:_96kuliapp/utils/customtextform.dart';
import 'package:_96kuliapp/utils/formHeader.dart';
import 'package:_96kuliapp/utils/formheaderbasic.dart';
import 'package:_96kuliapp/utils/formtitletag.dart';
import 'package:_96kuliapp/utils/selectlanguage.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:shimmer/shimmer.dart';

class HeightOption {
  final String displayValue;
  final int numericValue;

  HeightOption(this.displayValue, this.numericValue);
}

class UserInfoStepOne extends StatefulWidget {
  const UserInfoStepOne({super.key});

  @override
  State<UserInfoStepOne> createState() => _UserInfoStepOneState();
}

class _UserInfoStepOneState extends State<UserInfoStepOne> {
  final Rascontroller _rascontroller = Get.put(Rascontroller());

  @override
  void initState() {
    super.initState(); // Call the superclass's method
    language = sharedPreferences?.getString("Language");
    selectgender();
    gender = selectgender();
  }

  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String locationText = "";

  TimeOfDay selectedTime = TimeOfDay.now();
  late String gender;
  String? gender2;
  String? gender3;
  String? gender4;
  String? gender5;

  // String? language = sharedPreferences?.getString("Language");
  String? language;

  final LocationController _locationController = Get.put(LocationController());
  final Rascontroller rascontroller = Get.put(Rascontroller());
  final CastController _castController = Get.put(CastController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormFieldState> _timeFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _placeofbirthKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _rasKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _manglikKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _heightKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _bloodGroupKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _subSectionKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _casteKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _parentsContacKey =
      GlobalKey<FormFieldState>();
  // _physicalStatusKey
  final GlobalKey<FormFieldState> _maritialStatus = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _physicalStatusKey =
      GlobalKey<FormFieldState>();

  final ScrollController _scrollController = ScrollController();

  void _scrollToManglik() {
    final RenderObject? renderObject =
        _manglikKey.currentContext?.findRenderObject();
    if (renderObject is RenderBox) {
      final offset =
          renderObject.localToGlobal(Offset.zero).dy + _scrollController.offset;
      final targetOffset = offset - 40.0;

      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(seconds: 1),
        curve: Curves.decelerate,
      );
    }
  }

  void _scrollToWidget(GlobalKey key) {
    final RenderObject? renderObject = key.currentContext?.findRenderObject();
    if (renderObject is RenderBox) {
      final offset =
          renderObject.localToGlobal(Offset.zero).dy + _scrollController.offset;

      // Subtract a few pixels (e.g., 40 pixels) to scroll above
      final targetOffset = offset - 80.0;

      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(seconds: 1),
        curve: Curves.easeOutBack,
      );
    }
  }

  List<ListItems> bloodGroups = [
    ListItems("A+ve", 1),
    ListItems("A-ve", 2),
    ListItems("B+ve", 3),
    ListItems("B-ve", 4),
    ListItems("AB+ve", 5),
    ListItems("AB-ve", 6),
    ListItems("O+ve", 7),
    ListItems("O-ve", 8),
  ];

  final StepOneController _stepOneController = Get.put(StepOneController());
  final mybox = Hive.box('myBox');

  String selectgender() {
    if (language == "en") {
      if (mybox.get("gender") == 2) {
        return "Groom";
      } else {
        return "Bride";
      }
    } else {
      if (mybox.get("gender") == 2) {
        gender2 = "वराचा";
        gender3 = "वराच्या";
        gender4 = "वराला";
        gender5 = "वराचे";
        return "वराची";
      } else {
        gender2 = "वधूचा";
        gender3 = "वधूच्या";
        gender4 = "वधूला";
        gender5 = "वधूचे";

        return "वधूची";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print("THIS IS GENDER $gender");

    Future<void> selectTime(BuildContext context) async {
      final TimeOfDay? pickedTime = await showTimePicker(
          initialEntryMode: TimePickerEntryMode.dialOnly,
          builder: (context, child) {
            return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: false),
                child: child!);
          },
          context: context,
          initialTime: TimeOfDay.now());

      if (pickedTime != null) {
        _stepOneController.updateTime(pickedTime, context);
      }
    }
    //  int selectedIndex = _stepOneController.selectedBloodGroup.value?.id ?? 0;

    // Ensure the index is within the bounds of bloodGroups
    //  ListItems selectedBloodGroup = bloodGroups[selectedIndex];
    //  int selectedIndexHeight = _stepOneController.selectedHeightIndex.value;

    // Ensure the index is within the bounds of heightInFeet
    //  ListItems selectedHeight = heightInFeet[selectedIndexHeight];
    return WillPopScope(
      onWillPop: () async {
        // Show the confirmation dialog
        bool? shouldExit = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              insetPadding: const EdgeInsets.all(18),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
              ),
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: Image.asset("assets/exitApp.png"),
                    ),
                    const SizedBox(
                        height: 10), // Space between the icon and the title
                    Text(
                      AppLocalizations.of(context)!
                          .areYousureYouWantToExitAppIncompleteForms,
                      textAlign: TextAlign.center,
                      style: CustomTextStyle.bodytext
                          .copyWith(letterSpacing: 0.5, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 10.0), // Padding at the bottom of the buttons
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  AppTheme.secondryColor, // White text color
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                  vertical: 12), // Button padding
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8), // Rounded corners for the button
                              ),
                            ),
                            child: Text(
                                AppLocalizations.of(context)!.yesExitApp,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              // Get.back();
                              Navigator.of(context).pop(false);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Text(
                                  AppLocalizations.of(context)!.nodontExitApp,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromRGBO(80, 93, 126, .66))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
        return shouldExit ?? false;
      },
      child: Scaffold(
          body: SingleChildScrollView(
        controller: _scrollController,
        child: SafeArea(
          child: Obx(
            () {
              String? language = sharedPreferences?.getString("Language");
              String selectgender() {
                if (language == "en") {
                  if (mybox.get("gender") == 2) {
                    return "Groom";
                  } else {
                    return "Bride";
                  }
                } else {
                  if (mybox.get("gender") == 2) {
                    gender2 = "वराचा";
                    gender3 = "वराच्या";
                    gender4 = "वराला";
                    gender5 = "वराचे";
                    return "वराची";
                  } else {
                    gender2 = "वधूचा";
                    gender3 = "वधूच्या";
                    gender4 = "वधूला";
                    gender5 = "वधूचे";

                    return "वधूची";
                  }
                }
              }

              gender = selectgender();

              if (_stepOneController.isPageLoading.value == true) {
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
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  language == "en" ? "STEP 1" : "पहिली पायरी",
                                  style: CustomTextStyle.bodytextLarge,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const StepsFormHeaderBasic(
                        title: "Update Your Basic Information",
                        desc:
                            "Finding your Perfect soulmate is just a step away",
                        image: "assets/formstep1.png",
                        statusPercent: "20%",
                        statusdesc: "Update profile & boost visibility by",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormsTitleTag(
                      arrowback: false,
                      title: AppLocalizations.of(context)!.step1heading,
                      pageName: "incompleteForms",
                      lang: true,
                      onTaplang: () {
                        _stepOneController.fetchBasicInfo();
                        _stepOneController.zodiacsigList();
                        _stepOneController.regenerateHeightList();
                        selectgender();
                        /* placeOfBirth */
                        if (_stepOneController
                                .basicInfoData["place_of_birth"] ==
                            null) {
                          _locationController.selectedPlace.value.name = '';
                          _locationController.selectedPlace.value.id = null;
                          print("cheking place");
                        }
                        /* Ras */
                        if (_stepOneController.basicInfoData["ras"] == null) {
                          _stepOneController.selectedZodiacSign.value?.name =
                              '';
                          _stepOneController.selectedZodiacSign.value?.id = 0;
                          print("cheking selectedZodiacSign");
                        }
                        /* Height */
                        if (_stepOneController.basicInfoData["height"] ==
                            null) {
                          print("cheking basicInfoData");
                          _stepOneController.selectedHeight.value?.name = "";
                          _stepOneController.selectedHeight.value?.id = null;
                          _stepOneController.selectedHeightIndex.value = null;
                          // _stepOneController.updateHeight();
                        }
                        setState(() {});
                      },
                    ),
                    // const StepsFormHeader(title: "Update Your Basic Information", desc: "Begin your journey to finding your soulmate by sharing your basic details. It's quick and effortless" , image: "assets/formstep1.png", statusPercent: "20%", statusdesc: "Submit this form to boost your profile visibility by",),
                    StepsFormHeader(
                      endhour: _stepOneController.endhours.value,
                      endminutes: _stepOneController.endminutes.value,
                      endseconds: _stepOneController.endseconds.value,
                      title: AppLocalizations.of(context)!.updatebasicInfo,
                      desc: _stepOneController.headingText.value,
                      image: _stepOneController.headingImage.value,
                      statusPercent: "20%",
                      statusdesc: "Update profile & boost visibility by",
                      statusDescMarathiPrefix: AppLocalizations.of(context)!
                          .updateProfileAndBoostVisibilitypreffix,
                      statusPercentMarathi:
                          AppLocalizations.of(context)!.updatePercent20,
                      statusDescMarathiSuffix: AppLocalizations.of(context)!
                          .updateProfileAndBoostVisibilitySuffix,
                    ),

                    const SizedBox(
                      height: 30,
                    ),
                    language == "en"
                        ? Center(
                            child: RichText(
                                text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text:
                                      "Please fill in all required fields marked with ",
                                  style: CustomTextStyle.bodytext
                                      .copyWith(fontSize: 12)),
                              const TextSpan(
                                  text: "*",
                                  style: TextStyle(color: Colors.red)),
                            ])),
                          )
                        : Center(
                            child: RichText(
                                text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: "सर्व ",
                                  style: CustomTextStyle.bodytext
                                      .copyWith(fontSize: 12)),
                              const TextSpan(
                                  text: "*",
                                  style: TextStyle(color: Colors.red)),
                              TextSpan(
                                  text: " मार्क फील्ड्स भरणे आवश्यक आहे",
                                  style: CustomTextStyle.bodytext
                                      .copyWith(fontSize: 12)),
                            ])),
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.dateOfBirth,
                                style: CustomTextStyle.fieldName,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomContainer(
                                height: 55,
                                width: 134,

                                title: _stepOneController.dateofbirth
                                    .value, // Default if no date is selected
                              ),

                              const SizedBox(
                                height: 20,
                              ),
                              RichText(
                                  key: _timeFieldKey,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .timeofBirth,
                                        style: CustomTextStyle.fieldName),
                                    const TextSpan(
                                        text: "*",
                                        style: TextStyle(color: Colors.red))
                                  ])),
                              Obx(() {
                                // Concatenate the hour, minute, and time format into a single string
                                final String formattedTime = (_stepOneController
                                            .selectedHour.value !=
                                        "")
                                    ? "${_stepOneController.selectedHour.value}:${_stepOneController.selectedMinute.value} ${_stepOneController.selectedTimeFormat.value}"
                                    : "";

                                // Use the concatenated string in a single TextEditingController
                                final TextEditingController timeController =
                                    TextEditingController(text: formattedTime);

                                return CustomTextField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppLocalizations.of(context)!
                                          .pleaseEnterTimeOfBirth
                                          .replaceAll("[[gender]]", gender);
                                    }

                                    return null;
                                  },
                                  textEditingController: timeController,
                                  readonly: true,
                                  HintText: AppLocalizations.of(context)!
                                      .selectTimeOfBirth
                                      .replaceAll("[[gender]]",
                                          gender), // Updated hint to reflect format
                                  ontap: () async {
                                    await selectTime(
                                        context); // Trigger time selection

                                    // After time is selected, update the controller and validate the field
                                    if (_stepOneController
                                        .selectedHour.value.isNotEmpty) {
                                      timeController.text =
                                          "${_stepOneController.selectedHour.value}:${_stepOneController.selectedMinute.value} ${_stepOneController.selectedTimeFormat.value}";

                                      // Trigger validation on the text field
                                      if (_timeFieldKey.currentState != null) {
                                        _timeFieldKey.currentState!.validate();
                                      }
                                    }
                                  },
                                );
                              }),

                              const SizedBox(
                                height: 10,
                              ),
                              RichText(
                                key: _placeofbirthKey,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .placeofBirth,
                                        style: CustomTextStyle.fieldName),
                                    const TextSpan(
                                        text: "*",
                                        style: TextStyle(color: Colors.red))
                                  ],
                                ),
                              ),

                              Text(
                                AppLocalizations.of(context)!
                                    .selectbirthPlaceDistrict,
                                style: CustomTextStyle.bodytext
                                    .copyWith(fontSize: 12),
                              ),
                              Obx(() {
                                // Use a controller from locationController, rather than recreating it each time
                                final TextEditingController placeOfBirth =
                                    TextEditingController(
                                        text: _locationController
                                            .selectedPlace.value.name);

                                return CustomTextField(
                                  textEditingController: placeOfBirth,
                                  validator: (value) {
                                    if (language == "en") {
                                      if (value == null || value.isEmpty) {
                                        return 'Please choose the nearest district to $gender place of birth.';
                                      }
                                    } else {
                                      if (value == null || value.isEmpty) {
                                        return '$gender2 जन्म ठिकाणा जवळील जिल्हा निवडा'; /* जन्म स्थळाजवळील जिल्हा निवडा */
                                      }
                                    }

                                    return null;
                                  },
                                  readonly: true,
                                  ontap: () async {
                                    // Navigate to the place selection page
                                    //  await Get.toNamed(AppRouteNames.selectPlaceOfBirth);
                                    await navigatorKey.currentState!
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          const PlaceOfBirthScreen(),
                                    ));
                                    if (_locationController
                                            .selectedPlace.value.name !=
                                        null) {
                                      if (_locationController.selectedPlace
                                          .value.name!.isNotEmpty) {
                                        // Update the TextEditingController with the new place of birth
                                        placeOfBirth.text = _locationController
                                                .selectedPlace.value.name ??
                                            "";
                                        print("this is validation");
                                        // Trigger validation after the update
                                        if (_placeofbirthKey.currentState !=
                                            null) {
                                          _placeofbirthKey.currentState!
                                              .validate();
                                        }
                                      }
                                    }
                                    // Ensure that the selected place is updated
                                  },
                                  HintText: language == "en"
                                      ? "Select Place of Birth"
                                      : "$gender5 जन्मठिकाण निवडा",
                                );
                              }),

                              //    SizedBox(height: 20,) ,
                              //    Text("Time of Birth" , style: CustomTextStyle.fieldName,),
                              const SizedBox(
                                height: 10,
                              ),
                              RichText(
                                  key: _rasKey,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: AppLocalizations.of(context)!.ras,
                                        style: CustomTextStyle.fieldName),
                                    const TextSpan(
                                        text: "*",
                                        style: TextStyle(color: Colors.red))
                                  ])),
                              Obx(
                                () {
                                  final TextEditingController ras =
                                      TextEditingController(
                                          text: _stepOneController
                                                  .selectedZodiacSign
                                                  .value
                                                  ?.name ??
                                              "");
                                  return CustomTextField(
                                    validator: (value) {
                                      if (language == "en") {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select $gender ras';
                                        }
                                      } else {
                                        if (value == null || value.isEmpty) {
                                          return 'कृपया $gender रास निवडा';
                                        }
                                      }

                                      return null;
                                    },
                                    textEditingController: ras,
                                    HintText: language == "en"
                                        ? "Select ras"
                                        : "$gender रास निवडा",
                                    ontap: () {
                                      _showZodiacSelection(context);
                                    },
                                    readonly: true,
                                  );
                                },
                              ),

                              const SizedBox(
                                height: 10,
                              ),
                              RichText(
                                  key: _manglikKey,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .manglik,
                                        style: CustomTextStyle.fieldName),
                                    const TextSpan(
                                        text: "*",
                                        style: TextStyle(color: Colors.red))
                                  ])),
                              const SizedBox(
                                height: 10,
                              ),
                              Obx(
                                () {
                                  return Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _stepOneController.updateManglik(
                                              FieldModel(id: 2, name: "Yes"));
                                        },
                                        child: CustomContainer(
                                          height: 60,
                                          width: 89,
                                          color: _stepOneController
                                                      .manglikSelected
                                                      .value
                                                      .id ==
                                                  2
                                              ? AppTheme.selectedOptionColor
                                              : null,
                                          title:
                                              AppLocalizations.of(context)!.yes,
                                          textColor: _stepOneController
                                                      .manglikSelected
                                                      .value
                                                      .id ==
                                                  2
                                              ? Colors.white
                                              : null,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _stepOneController.updateManglik(
                                              FieldModel(id: 1, name: "no"));
                                        },
                                        child: CustomContainer(
                                          color: _stepOneController
                                                      .manglikSelected
                                                      .value
                                                      .id ==
                                                  1
                                              ? AppTheme.selectedOptionColor
                                              : null,
                                          height: 60,
                                          width: 89,
                                          title:
                                              AppLocalizations.of(context)!.no,
                                          textColor: _stepOneController
                                                      .manglikSelected
                                                      .value
                                                      .id ==
                                                  1
                                              ? Colors.white
                                              : null,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _stepOneController.updateManglik(
                                              FieldModel(
                                                  id: 3, name: "Don't Know"));
                                        },
                                        child: CustomContainer(
                                          color: _stepOneController
                                                      .manglikSelected
                                                      .value
                                                      .id ==
                                                  3
                                              ? AppTheme.selectedOptionColor
                                              : null,
                                          height: 60,
                                          width: 125,
                                          title: AppLocalizations.of(context)!
                                              .dontknow,
                                          textColor: _stepOneController
                                                      .manglikSelected
                                                      .value
                                                      .id ==
                                                  3
                                              ? Colors.white
                                              : null,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              Obx(
                                () {
                                  print("Valid Mang");
                                  if (_stepOneController
                                              .selectedManglikValidated.value ==
                                          false &&
                                      _stepOneController.isSubmitted.value ==
                                          true) {
                                    if (_stepOneController
                                            .manglikSelected.value.id ==
                                        null) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          language == "en"
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 18.0),
                                                  child: Text(
                                                    "Please select $gender manglik status",
                                                    style: CustomTextStyle
                                                        .errorText,
                                                  ),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 18.0),
                                                  child: Text(
                                                    "कृपया $gender2 मंगळ दोष निवडा",
                                                    /* मंगळ वराचा दोष निवडा */
                                                    style: CustomTextStyle
                                                        .errorText,
                                                  ),
                                                )
                                        ],
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),

                              RichText(
                                key: _heightKey,
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          AppLocalizations.of(context)!.height,
                                      style: CustomTextStyle.fieldName),
                                  const TextSpan(
                                      text: "*",
                                      style: TextStyle(color: Colors.red))
                                ]),
                              ),

                              Obx(
                                () {
                                  final TextEditingController maxage =
                                      TextEditingController(
                                          text: _stepOneController
                                              .selectedHeight.value?.name);
                                  return CustomTextField(
                                    validator: (value) {
                                      if (language == "en") {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select $gender height';
                                        }
                                      } else {
                                        if (value == null || value.isEmpty) {
                                          return 'कृपया $gender उंची निवडा'; /* वराची उंची टाकणे अनिवार्य आहे  */
                                        }
                                      }

                                      return null;
                                    },
                                    readonly: true,
                                    textEditingController: maxage,
                                    HintText: language == "en"
                                        ? "Select height"
                                        : "$gender उंची निवडा",
                                    ontap: () {
                                      _stepOneController
                                              .searchedHeightList.value =
                                          _stepOneController.heightInFeet;

                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 8.0,
                                                            top: 8),
                                                    child: TextField(
                                                      decoration:
                                                          InputDecoration(
                                                        errorMaxLines: 5,
                                                        errorStyle:
                                                            CustomTextStyle
                                                                .errorText,
                                                        labelStyle:
                                                            CustomTextStyle
                                                                .bodytext,
                                                        hintText:
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .searchHeight,
                                                        //  language ==
                                                        //         "en"
                                                        //     ? "Select Height"
                                                        //     : "उंची मर्यादा निवडा",
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .all(20),
                                                        hintStyle:
                                                            CustomTextStyle
                                                                .hintText,
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        errorBorder:
                                                            const OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .red),
                                                          gapPadding: 30,
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5)),
                                                          borderSide: BorderSide(
                                                              color: Colors.grey
                                                                  .shade300),
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5)),
                                                          borderSide: BorderSide(
                                                              color: Colors.grey
                                                                  .shade300),
                                                        ),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5)),
                                                          borderSide: BorderSide(
                                                              color: Colors.grey
                                                                  .shade300),
                                                        ),
                                                        suffixIcon: Icon(
                                                            Icons.search,
                                                            color: Colors
                                                                .grey.shade500),
                                                      ),
                                                      onChanged: (query) {
                                                        _stepOneController
                                                            .searchMinHeight(
                                                                query); // Filter the list in the controller
                                                      },
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5)),
                                                      color: Colors.white,
                                                    ),
                                                    height:
                                                        400, // Set a height for the list inside the dialog
                                                    child: Obx(() {
                                                      return ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            _stepOneController
                                                                .searchedHeightList
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final item =
                                                              _stepOneController
                                                                      .searchedHeightList[
                                                                  index];
                                                          bool isSelected =
                                                              _stepOneController
                                                                      .selectedHeight
                                                                      .value
                                                                      ?.id ==
                                                                  item.id;

                                                          return GestureDetector(
                                                            onTap: () {
                                                              // Update the selected value and close the dialog
                                                              _stepOneController
                                                                  .updateHeight(
                                                                      item); // Update the selected height and index in the controller

                                                              // Update the controller text based on selection

                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Container(
                                                              color: isSelected
                                                                  ? AppTheme
                                                                      .selectedOptionColor
                                                                  : Colors
                                                                      .white,
                                                              child: ListTile(
                                                                title: Text(
                                                                  item.name ??
                                                                      "",
                                                                  style: CustomTextStyle
                                                                      .bodytext
                                                                      .copyWith(
                                                                    color: isSelected
                                                                        ? Colors
                                                                            .white
                                                                        : AppTheme
                                                                            .textColor,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),

                              /*          Obx(() {
        return CustomDropdownButton(
      value: _stepOneController.selectedHeight.value, // Preselect the value from the controller
      onChanged: (FieldModel? selectedItem) {
        if (selectedItem != null) {
          print('Selected ID: ${selectedItem.id}, Display Value: ${selectedItem.name}');
          _stepOneController.updateHeight(selectedItem); // Update the selected height and index in the controller
        }
      },
      validator: (value) {
        if (value == null) {
          return 'Height is Required';
        }
        return null;
      },
      items: _stepOneController.heightInFeet,
      hintText: "Enter Height",
        );
      }),*/
                              const SizedBox(
                                height: 10,
                              ),
                              RichText(
                                  key: _bloodGroupKey,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .bloodgroup,
                                        style: CustomTextStyle.fieldName),
                                    const TextSpan(
                                        text: "*",
                                        style: TextStyle(color: Colors.red))
                                  ])),
                              Obx(
                                () {
                                  final TextEditingController maxage =
                                      TextEditingController(
                                          text: _stepOneController
                                              .selectedBloodGroup.value?.name);
                                  return CustomTextField(
                                    validator: (value) {
                                      if (language == "en") {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select $gender blood group';
                                        }
                                      } else {
                                        if (value == null || value.isEmpty) {
                                          return 'कृपया $gender2 रक्तगट निवडा'; /* रक्तगट टाकणे अनिवार्य आहे */
                                        }
                                      }

                                      return null;
                                    },
                                    readonly: true,
                                    textEditingController: maxage,
                                    HintText: language == "en"
                                        ? "Select blood group "
                                        : "$gender2 रक्तगट टाका",
                                    ontap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5)),
                                                      color: Colors.white,
                                                    ),
                                                    height:
                                                        400, // Set a height for the list inside the dialog
                                                    child: Obx(() {
                                                      return ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            _stepOneController
                                                                .bloodGroups
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final item =
                                                              _stepOneController
                                                                      .bloodGroups[
                                                                  index];
                                                          bool isSelected =
                                                              _stepOneController
                                                                      .selectedBloodGroup
                                                                      .value
                                                                      ?.id ==
                                                                  item.id;

                                                          return GestureDetector(
                                                            onTap: () {
                                                              // Update the selected value and close the dialog
                                                              _stepOneController
                                                                  .updateBloodGroup(
                                                                      item); // Update the selected item and index in the controller
                                                              // Update the selected height and index in the controller

                                                              // Update the controller text based on selection

                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Container(
                                                              color: isSelected
                                                                  ? AppTheme
                                                                      .selectedOptionColor
                                                                  : Colors
                                                                      .white,
                                                              child: ListTile(
                                                                title: Text(
                                                                  item.name ??
                                                                      "",
                                                                  style: CustomTextStyle
                                                                      .bodytext
                                                                      .copyWith(
                                                                    color: isSelected
                                                                        ? Colors
                                                                            .white
                                                                        : AppTheme
                                                                            .textColor,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                              /*  Obx(() {
        return CustomDropdownButton(
      value: _stepOneController.selectedBloodGroup.value, // Use the selected blood group from the controller
      onChanged: (FieldModel? selectedItem) {
        if (selectedItem != null) {
          print('Selected ID: ${selectedItem.id}, Display Value: ${selectedItem.name}');
          _stepOneController.updateBloodGroup(selectedItem); // Update the selected item and index in the controller
        }
      },
      validator: (value) {
        if (value == null) {
          return 'Blood Group is Required';
        }
        return null;
      },
      items: _stepOneController.bloodGroups,
      hintText: "Blood Group",
        );
      }),*/
                              const SizedBox(
                                height: 15,
                              ),
                              RichText(
                                  key: _physicalStatusKey,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .physicalstatus,
                                        style: CustomTextStyle.fieldName),
                                    const TextSpan(
                                        text: "*",
                                        style: TextStyle(color: Colors.red))
                                  ])),
                              const SizedBox(
                                height: 10,
                              ),
                              Obx(
                                () {
                                  return Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _stepOneController
                                              .updatePhysicalStatus(FieldModel(
                                                  id: 2, name: "yes"));
                                        },
                                        child: CustomContainer(
                                          textColor: _stepOneController
                                                      .selectedPhysicalStatus
                                                      .value
                                                      .id ==
                                                  2
                                              ? Colors.white
                                              : null,
                                          height: 60,
                                          title:
                                              AppLocalizations.of(context)!.yes,
                                          width: 89,
                                          color: _stepOneController
                                                      .selectedPhysicalStatus
                                                      .value
                                                      .id ==
                                                  2
                                              ? AppTheme.selectedOptionColor
                                              : null,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _stepOneController
                                              .updatePhysicalStatus(FieldModel(
                                                  id: 1, name: "no"));
                                        },
                                        child: CustomContainer(
                                          textColor: _stepOneController
                                                      .selectedPhysicalStatus
                                                      .value
                                                      .id ==
                                                  1
                                              ? Colors.white
                                              : null,
                                          height: 60,
                                          title:
                                              AppLocalizations.of(context)!.no,
                                          width: 89,
                                          color: _stepOneController
                                                      .selectedPhysicalStatus
                                                      .value
                                                      .id ==
                                                  1
                                              ? AppTheme.selectedOptionColor
                                              : null,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              Obx(
                                () {
                                  print("Valid Maritial");
                                  if (_stepOneController
                                              .selectedPhysicalStatusValidated
                                              .value ==
                                          false &&
                                      _stepOneController.isSubmitted.value ==
                                          true) {
                                    if (_stepOneController
                                            .selectedPhysicalStatus.value.id ==
                                        null) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          language == "en"
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 18.0),
                                                  child: Text(
                                                    "Please select $gender physical status",
                                                    style: CustomTextStyle
                                                        .errorText,
                                                  ),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 18.0),
                                                  child: Text(
                                                    "$gender4 अपंगत्व आहे का?",
                                                    style: CustomTextStyle
                                                        .errorText,
                                                  ),
                                                )
                                        ],
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),

                              Obx(
                                () {
                                  if (_stepOneController
                                          .selectedPhysicalStatus.value.id ==
                                      2) {
                                    return CustomTextField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please mention $gender physical disability';
                                          }
                                          return null;
                                        },
                                        textEditingController:
                                            _stepOneController.physicalStatus,
                                        HintText: language == 'en'
                                            ? "Explain Disability"
                                            : "$gender4 काय अपंगत्व आहे ते टाका");
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              RichText(
                                key: _maritialStatus,
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .maritalstatus,
                                      style: CustomTextStyle.fieldName),
                                  const TextSpan(
                                      text: "*",
                                      style: TextStyle(color: Colors.red))
                                ]),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Obx(
                                () {
                                  return Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            _stepOneController
                                                .updateMaritalStatus(FieldModel(
                                                    id: 1,
                                                    name: "Never Married"));
                                            _stepOneController
                                                .numberchilren.text = "";
                                            _stepOneController.selectedChildren
                                                .value.id = null;
                                          },
                                          child: CustomContainer(
                                            height: 60,
                                            title: AppLocalizations.of(context)!
                                                .neverMarried,
                                            width: 122,
                                            color: _stepOneController
                                                        .selectedMaritalStatus
                                                        .value
                                                        .id ==
                                                    1
                                                ? AppTheme.selectedOptionColor
                                                : null,
                                            textColor: _stepOneController
                                                        .selectedMaritalStatus
                                                        .value
                                                        .id ==
                                                    1
                                                ? Colors.white
                                                : null,
                                          )),
                                      GestureDetector(
                                          onTap: () {
                                            _stepOneController
                                                .updateMaritalStatus(FieldModel(
                                                    id: 3, name: "Divorced"));
                                          },
                                          child: CustomContainer(
                                            height: 60,
                                            title: AppLocalizations.of(context)!
                                                .divorced,
                                            width: 105,
                                            color: _stepOneController
                                                        .selectedMaritalStatus
                                                        .value
                                                        .id ==
                                                    3
                                                ? AppTheme.selectedOptionColor
                                                : null,
                                            textColor: _stepOneController
                                                        .selectedMaritalStatus
                                                        .value
                                                        .id ==
                                                    3
                                                ? Colors.white
                                                : null,
                                          )),
                                      GestureDetector(
                                          onTap: () {
                                            _stepOneController
                                                .updateMaritalStatus(FieldModel(
                                                    id: 5, name: "Seprated"));
                                          },
                                          child: CustomContainer(
                                            height: 60,
                                            title: AppLocalizations.of(context)!
                                                .separated,
                                            width: 105,
                                            color: _stepOneController
                                                        .selectedMaritalStatus
                                                        .value
                                                        .id ==
                                                    5
                                                ? AppTheme.selectedOptionColor
                                                : null,
                                            textColor: _stepOneController
                                                        .selectedMaritalStatus
                                                        .value
                                                        .id ==
                                                    5
                                                ? Colors.white
                                                : null,
                                          )),
                                      GestureDetector(
                                          onTap: () {
                                            _stepOneController
                                                .updateMaritalStatus(FieldModel(
                                                    id: 4,
                                                    name: "Awaiting Response"));
                                          },
                                          child: CustomContainer(
                                            height: 60,
                                            title: AppLocalizations.of(context)!
                                                .awaitingresponse,
                                            width: 155,
                                            color: _stepOneController
                                                        .selectedMaritalStatus
                                                        .value
                                                        .id ==
                                                    4
                                                ? AppTheme.selectedOptionColor
                                                : null,
                                            textColor: _stepOneController
                                                        .selectedMaritalStatus
                                                        .value
                                                        .id ==
                                                    4
                                                ? Colors.white
                                                : null,
                                          )),
                                      GestureDetector(
                                          onTap: () {
                                            _stepOneController
                                                .updateMaritalStatus(FieldModel(
                                                    id: 2, name: "Widow"));
                                          },
                                          child: CustomContainer(
                                            height: 60,
                                            title: AppLocalizations.of(context)!
                                                .widoworwidower,
                                            width: 144,
                                            color: _stepOneController
                                                        .selectedMaritalStatus
                                                        .value
                                                        .id ==
                                                    2
                                                ? AppTheme.selectedOptionColor
                                                : null,
                                            textColor: _stepOneController
                                                        .selectedMaritalStatus
                                                        .value
                                                        .id ==
                                                    2
                                                ? Colors.white
                                                : null,
                                          )),
                                    ],
                                  );
                                },
                              ),
                              Obx(
                                () {
                                  print("Valid Maritial");
                                  if (_stepOneController
                                              .selectedMaritialStatusValidated
                                              .value ==
                                          false &&
                                      _stepOneController.isSubmitted.value ==
                                          true) {
                                    if (_stepOneController
                                            .selectedMaritalStatus.value.id ==
                                        null) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          language == "en"
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 18.0),
                                                  child: Text(
                                                    "Please select $gender marital status",
                                                    style: CustomTextStyle
                                                        .errorText,
                                                  ),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 18.0),
                                                  child: Text(
                                                    "कृपया $gender वैवाहिक स्थिती निवडा",
                                                    /* वराची वैवाहिक स्थिती टाकणे अनिवार्य आहे */

                                                    style: CustomTextStyle
                                                        .errorText,
                                                  ),
                                                )
                                        ],
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Obx(
                                () {
                                  if (_stepOneController.selectedMaritalStatus.value.id == 2 ||
                                      _stepOneController
                                              .selectedMaritalStatus.value.id ==
                                          3 ||
                                      _stepOneController
                                              .selectedMaritalStatus.value.id ==
                                          4 ||
                                      _stepOneController
                                              .selectedMaritalStatus.value.id ==
                                          5) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                            text: TextSpan(children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .haveChildren,
                                              style: CustomTextStyle.fieldName),
                                          const TextSpan(
                                              text: "*",
                                              style:
                                                  TextStyle(color: Colors.red))
                                        ])),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Wrap(
                                          spacing: 10,
                                          runSpacing: 10,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                _stepOneController
                                                    .updateChildren(FieldModel(
                                                        id: 1, name: "no"));
                                              },
                                              child: CustomContainer(
                                                textColor: _stepOneController
                                                            .selectedChildren
                                                            .value
                                                            .id ==
                                                        1
                                                    ? Colors.white
                                                    : null,
                                                height: 60,
                                                title: AppLocalizations.of(
                                                        context)!
                                                    .no,
                                                width: 89,
                                                color: _stepOneController
                                                            .selectedChildren
                                                            .value
                                                            .id ==
                                                        1
                                                    ? AppTheme
                                                        .selectedOptionColor
                                                    : null,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                _stepOneController
                                                    .updateChildren(FieldModel(
                                                        id: 2,
                                                        name:
                                                            "yes , Living Together"));
                                              },
                                              child: CustomContainer(
                                                textColor: _stepOneController
                                                            .selectedChildren
                                                            .value
                                                            .id ==
                                                        2
                                                    ? Colors.white
                                                    : null,
                                                height: 60,
                                                title: AppLocalizations.of(
                                                        context)!
                                                    .yeslivingtogether,
                                                width: 89,
                                                color: _stepOneController
                                                            .selectedChildren
                                                            .value
                                                            .id ==
                                                        2
                                                    ? AppTheme
                                                        .selectedOptionColor
                                                    : null,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                _stepOneController
                                                    .updateChildren(FieldModel(
                                                        id: 3,
                                                        name:
                                                            "yes, Not Living Together"));
                                              },
                                              child: CustomContainer(
                                                textColor: _stepOneController
                                                            .selectedChildren
                                                            .value
                                                            .id ==
                                                        3
                                                    ? Colors.white
                                                    : null,
                                                height: 60,
                                                title: AppLocalizations.of(
                                                        context)!
                                                    .yesnotlivingtogether,
                                                width: 89,
                                                color: _stepOneController
                                                            .selectedChildren
                                                            .value
                                                            .id ==
                                                        3
                                                    ? AppTheme
                                                        .selectedOptionColor
                                                    : null,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Obx(
                                          () {
                                            if (_stepOneController
                                                        .selectedChildrenValidated
                                                        .value ==
                                                    false &&
                                                _stepOneController
                                                        .isSubmitted.value ==
                                                    true) {
                                              if (_stepOneController
                                                      .selectedChildren
                                                      .value
                                                      .id ==
                                                  null) {
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 18.0),
                                                      child: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .pleaseSelectIfYouHaveChildren
                                                            .replaceAll(
                                                                "[[gender]]",
                                                                "$gender4"),
                                                        style: CustomTextStyle
                                                            .errorText,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    )
                                                  ],
                                                );
                                              } else {
                                                return const SizedBox();
                                              }
                                            } else {
                                              return const SizedBox();
                                            }
                                          },
                                        ),
                                        Obx(
                                          () {
                                            if (_stepOneController
                                                        .selectedChildren
                                                        .value
                                                        .id ==
                                                    2 ||
                                                _stepOneController
                                                        .selectedChildren
                                                        .value
                                                        .id ==
                                                    3) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  RichText(
                                                      text: const TextSpan(
                                                          children: <TextSpan>[
                                                        TextSpan(
                                                            text:
                                                                "Number of Children ",
                                                            style:
                                                                CustomTextStyle
                                                                    .fieldName),
                                                        TextSpan(
                                                            text: "*",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red))
                                                      ])),
                                                  /*  Padding(
                            padding: const EdgeInsets.only(bottom:  12.0),
                            child: CustomTextField(
                              readonly: true, 
                              ontap: () {
                                
                              },
        validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please select the number of children';
      }
       
      return null;
        },
        textEditingController: _stepOneController.numberchilren,
        textInputType: TextInputType.number, // Opens numeric keyboard
      
        HintText: "Enter Number of Children",
      ),
      
                          ),*/
                                                  Obx(
                                                    () {
                                                      final TextEditingController
                                                          maxage =
                                                          TextEditingController(
                                                              text: _stepOneController
                                                                  .selectedNumberOfChildren
                                                                  .value
                                                                  ?.name);
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 12.0),
                                                        child: CustomTextField(
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return 'Please select $gender Number of Children';
                                                            }
                                                            return null;
                                                          },
                                                          readonly: true,
                                                          textEditingController:
                                                              maxage,
                                                          HintText:
                                                              "Select Number of Children ",
                                                          ontap: () {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return Dialog(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            16.0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        Container(
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(5)),
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          //  height: 400, // Set a height for the list inside the dialog
                                                                          child:
                                                                              Obx(() {
                                                                            return ListView.builder(
                                                                              shrinkWrap: true,
                                                                              itemCount: _stepOneController.numberOfChildren.length,
                                                                              itemBuilder: (context, index) {
                                                                                final item = _stepOneController.numberOfChildren[index];
                                                                                bool isSelected = _stepOneController.selectedNumberOfChildren.value?.id == item.id;

                                                                                return GestureDetector(
                                                                                  onTap: () {
                                                                                    // Update the selected value and close the dialog
                                                                                    _stepOneController.updateNumberOfChildren(item); // Update the selected item and index in the controller
                                                                                    // Update the selected height and index in the controller

                                                                                    // Update the controller text based on selection

                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Container(
                                                                                    color: isSelected ? AppTheme.selectedOptionColor : Colors.white,
                                                                                    child: ListTile(
                                                                                      title: Text(
                                                                                        item.name ?? "",
                                                                                        style: CustomTextStyle.bodytext.copyWith(
                                                                                          color: isSelected ? Colors.white : AppTheme.textColor,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                            );
                                                                          }),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  )
                                                ],
                                              );
                                            } else {
                                              return const SizedBox();
                                            }
                                          },
                                        )
                                      ],
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                              /*         RichText(text: const TextSpan(children: <TextSpan>[
                      TextSpan(text: "Section " , style: CustomTextStyle.fieldName ) , 
                      TextSpan( text: "*" , style: TextStyle(color: Colors.red))
                     ])), 
                  
                     
                     SizedBox(height: 10,),
                          Obx(() {
                            return CustomContainer(
                  height: 55,
                  width: 134,
                
                  title: _castController.selectedSection.value.name ?? "Section" , // Default if no date is selected
                );
                          },), 
                                Padding(
                                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                    color: AppTheme.lightPrimaryColor,
                                      
                                      borderRadius: BorderRadius.all(Radius.circular(5))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RichText(text: const TextSpan(children: <TextSpan>[
                                                            TextSpan( text: "*" , style: TextStyle(
                                                              fontSize: 12, 
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.red)),
                                                            TextSpan( text: "Note : " , style: TextStyle(
                                                              fontSize: 12, 
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.red)),
                                                            TextSpan(text: "Only Jain community members are allowed. Profiles with other caste will be blocked. " , style: CustomTextStyle.bodytextSmall ) , 
                                                           ])),
                                    ),
                                  ),
                                ), 
                      /*   Obx(() {
                       //   String? selectedSection = sharedPreferences?.getString("SectionValue");
      TextEditingController _sectionController = TextEditingController(text: _castController.selectedSection.value.name);
                           return  CustomTextField(
                          validator: (value) {
                               if (value == null || value.isEmpty) {
                  return 'Please select ${gender} section';
                      }
                      return null;
                          },
                  textEditingController: _sectionController,
                readonly: true,
                          
                HintText: "Select Section");
                         },),*/
                const SizedBox(height: 10,),
                         RichText(
                          key: _subSectionKey,
                          text: const TextSpan(children: <TextSpan>[
                      TextSpan(text: "Sub Section " , style: CustomTextStyle.fieldName ) , 
                      TextSpan( text: "*" , style: TextStyle(color: Colors.red))
                     ])), 

                          Obx(() {
                      final TextEditingController Subsection = TextEditingController(text: _castController.selectedSubSection.value.name);
                           return CustomTextField(
                   validator: (value) {
                               if (value == null || value.isEmpty) {
                  return 'Please select ${gender} subsection';
                      }
                      return null;
                          },
                textEditingController: Subsection,
                ontap: () {
                  _showSubSectionBottomSheet(context);
                  
                }, 
                readonly: true,
                HintText: "Sub Section");
                          },),
                const SizedBox(height: 10,),
                      RichText(
                        key: _casteKey,
                        text: const TextSpan(children: <TextSpan>[
                      TextSpan(text: "Caste " , style: CustomTextStyle.fieldName ) , 
                      TextSpan( text: "*" , style: TextStyle(color: Colors.red))
                     ])), 
                          
                          Obx(() {
                      final TextEditingController cast = TextEditingController(text: _castController.selectedCast.value.name);
                return  CustomTextField(
                   validator: (value) {
                               if (value == null || value.isEmpty) {
                  return 'Please select ${gender} caste';
                      }
                      return null;
                          },
                textEditingController: cast,
                ontap: () {
                  _showCastBottomSheet(context);
                  
                }, 
                readonly: true,
                HintText: "Select Caste");
                          },),
                */
                              /*      RichText(
                        key: _dietryHabitKey,
                        text: const TextSpan(children: <TextSpan>[
                      TextSpan(text: "Dietry habit " , style: CustomTextStyle.fieldName ) , 
                      TextSpan( text: "*" , style: TextStyle(color: Colors.red))
                     ])), 
                   const SizedBox(height: 10,) , 
                 Obx(() {
                   return   Wrap(
                    spacing: 10, 
                    runSpacing: 10,
                    children: [
                      GestureDetector( 
                        onTap: () {
                          _stepOneController.updateEatingHabit(FieldModel(id: 1 , name: "Vegetarian"));
                        },
                        child: CustomContainer(height: 60, title: "Vegetarian" , width: 105 , 
                        color: _stepOneController.selectedEatingHabit.value.id == 1 ?  AppTheme.selectedOptionColor : null ,
                        
                        textColor: _stepOneController.selectedEatingHabit.value.id == 1 ? Colors.white : null,
                        ),
                      ), 
                          
                        GestureDetector( 
                        onTap: () {
                          _stepOneController.updateEatingHabit(FieldModel(id: 2 , name: "Non-Veg"));
                        },
                        child: CustomContainer(height: 60, title: "Non-Vegetarian" , width: 138 , 
                        color: _stepOneController.selectedEatingHabit.value.id == 2 ?  AppTheme.selectedOptionColor: null ,
                        
                        textColor: _stepOneController.selectedEatingHabit.value.id == 2 ? Colors.white : null,
                        ),
                      ), 
                          
                        GestureDetector( 
                        onTap: () {
                          _stepOneController.updateEatingHabit(FieldModel(id: 5 , name: "Vegan"));
                        },
                        child: CustomContainer(height: 60, title: "Vegan" , width: 105 , 
                        color: _stepOneController.selectedEatingHabit.value.id == 5 ?  AppTheme.selectedOptionColor : null ,
                        
                        textColor: _stepOneController.selectedEatingHabit.value.id == 5 ? Colors.white : null,
                        ),
                      ), 
                          
                        GestureDetector( 
                        onTap: () {
                          _stepOneController.updateEatingHabit(FieldModel(id: 4 , name: "Eggetarian"));
                        },
                        child: CustomContainer(height: 60, title: "Eggetarian" , width: 105 , 
                        color: _stepOneController.selectedEatingHabit.value.id == 4 ?  AppTheme.selectedOptionColor : null ,
                        
                        textColor: _stepOneController.selectedEatingHabit.value.id == 4 ? Colors.white : null,
                        ),
                      ), 
                       GestureDetector(
                          onTap: () {
                _stepOneController.updateEatingHabit(FieldModel(id: 6, name: "Jain"));
                          },
                          child: CustomContainer(
                height: 60,
                title: "Jain",
                width: 105,
                color: _stepOneController.selectedEatingHabit.value.id == 6
                    ? AppTheme.selectedOptionColor
                    : null,
                textColor: _stepOneController.selectedEatingHabit.value.id == 6
                    ? Colors.white
                    : null,
                          ),
                  ),
                GestureDetector(
                          onTap: () {
                _stepOneController.updateEatingHabit(FieldModel(id: 3 , name: "Occasionally Non-veg"));
                          },
                          child: CustomContainer(
                height: 60,
                title: "Occasionally Non-Veg",
                width: 105,
                color: _stepOneController.selectedEatingHabit.value.id == 3
                    ? AppTheme.selectedOptionColor
                    : null,
                textColor: _stepOneController.selectedEatingHabit.value.id == 3
                    ? Colors.white
                    : null,
                          ),
                  ),
                          
                        GestureDetector( 
                        onTap: () {
                          _stepOneController.updateEatingHabit(FieldModel(id: 7 , name: "Other"));
                        },
                        child: CustomContainer(height: 60, title: "Other" , width: 105 , 
                        color: _stepOneController.selectedEatingHabit.value.id == 7 ?  AppTheme.selectedOptionColor : null ,
                        
                        textColor: _stepOneController.selectedEatingHabit.value.id == 7 ? Colors.white : null,
                        ),
                      ), 
                    ],);
                 },), 
                  Obx(() {
                print("Valid Mang");
                          if(_stepOneController .selectedEatingHabitValidated .value == false &&  _stepOneController.isSubmitted.value == true){
                  if(_stepOneController.selectedEatingHabit.value.id == null){
                  return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                          SizedBox(height: 10,),
                          Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Text("Please select ${gender} dietary habits" , style: CustomTextStyle.errorText,),
                          )
                  ],);
                }else{
                  return SizedBox();
                }
                          }else{
                return SizedBox();
                          }
                          },),
                 const SizedBox(height: 20,),
                          
                     RichText(
                      key: _smokingHabitKey,
                      text: const TextSpan(children: <TextSpan>[
                      TextSpan(text: "Smoking habit " , style: CustomTextStyle.fieldName ) , 
                      TextSpan( text: "*" , style: TextStyle(color: Colors.red))
                     ])), 
                     const SizedBox(height: 10,),
                   Obx(() {
                     return   Wrap(spacing: 10, runSpacing: 10 , children: [
                      GestureDetector( 
                        onTap: () {
                          _stepOneController.updateSmokingHabit(FieldModel(id: 1 , name: "yes"));
                        },
                        child: CustomContainer(
                          textColor: _stepOneController.selectedSmokingHabit.value.id == 1 ? Colors.white : null,
                          height: 60, title: "Yes", width: 89 , color: _stepOneController.selectedSmokingHabit.value.id == 1 ?  AppTheme.selectedOptionColor: null,),
                      ), 
                           GestureDetector( 
                        onTap: () {
                          _stepOneController.updateSmokingHabit(FieldModel(id: 2 , name: "no"));
                        },
                        child: CustomContainer(
                          textColor: _stepOneController.selectedSmokingHabit.value.id == 2 ? Colors.white : null,
                          height: 60, title: "No", width: 89 , color: _stepOneController.selectedSmokingHabit.value.id == 2 ?  AppTheme.selectedOptionColor : null,),
                      ), 
                       GestureDetector( 
                        onTap: () {
                          _stepOneController.updateSmokingHabit(FieldModel(id: 3 , name: "Occasionally"));
                        },
                        child: CustomContainer(
                          textColor: _stepOneController.selectedSmokingHabit.value.id == 3 ? Colors.white : null,
                          height: 60, title: "Occasionally", width: 117 , color: _stepOneController.selectedSmokingHabit.value.id == 3 ?  AppTheme.selectedOptionColor : null,),
                      ), 
                          
                     ],);
                   },), 
                             Obx(() {
                print("Valid Mang");
                          if(_stepOneController .selectedSmokingHabitValidated.value == false &&  _stepOneController.isSubmitted.value == true){
                  if(_stepOneController.selectedSmokingHabit.value.id == null){
                  return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                          SizedBox(height: 10,),
                          Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Text("Please select ${gender} smoking habits" , style: CustomTextStyle.errorText,),
                          )
                  ],);
                }else{
                  return SizedBox();
                }
                          }else{
                return SizedBox();
                          }
                          },),
                   const SizedBox(height: 20,), 
                     RichText(
                      key: _drinkingHabitKey,
                      text: const TextSpan(children: <TextSpan>[
                      TextSpan(text: "Drinking habit " , style: CustomTextStyle.fieldName ) , 
                      TextSpan( text: "*" , style: TextStyle(color: Colors.red))
                     ])), 
                     const SizedBox(height: 10,),
                   Obx(() {
                     return   Wrap(spacing: 10, runSpacing: 10 , children: [
                      GestureDetector( 
                        onTap: () {
                          _stepOneController.updateDrinkingHabit(FieldModel(id: 1 , name: "yes"));
                        },
                        child: CustomContainer(
                          textColor: _stepOneController.selectedDrinkingHabit.value.id == 1 ? Colors.white : null,
                          height: 60, title: "Yes", width: 89 , color: _stepOneController.selectedDrinkingHabit.value.id == 1 ?  AppTheme.selectedOptionColor: null,),
                      ), 
                           GestureDetector( 
                        onTap: () {
                          _stepOneController.updateDrinkingHabit(FieldModel(id: 2 , name: "no"));
                        },
                        child: CustomContainer(
                          textColor: _stepOneController.selectedDrinkingHabit.value.id == 2 ? Colors.white : null,
                          height: 60, title: "No", width: 89 , color: _stepOneController.selectedDrinkingHabit.value.id == 2 ?  AppTheme.selectedOptionColor : null,),
                      ), 
                       GestureDetector( 
                        onTap: () {
                          _stepOneController.updateDrinkingHabit(FieldModel(id: 3 , name: "Occassionally"));
                        },
                        child: CustomContainer(
                          textColor: _stepOneController.selectedDrinkingHabit.value.id == 3 ? Colors.white : null,
                          height: 60, title: "Occasionally", width: 117 , color: _stepOneController.selectedDrinkingHabit.value .id == 3 ?  AppTheme.selectedOptionColor : null,),
                      ), 
                          
                     ],);
                   },), 
      
                             Obx(() {
                print("Valid Mang");
                          if(_stepOneController .selectedDrinkingHabitValidated.value == false &&  _stepOneController.isSubmitted.value == true){
                  if(_stepOneController.selectedDrinkingHabit.value.id == null){
                  return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                          SizedBox(height: 10,),
                          Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Text("Please select ${gender} drinking habits" , style: CustomTextStyle.errorText,),
                          )
                  ],);
                }else{
                  return SizedBox();
                }
                          }else{
                return SizedBox();
                          }
                          },),
                  */
                              RichText(
                                  key: _parentsContacKey,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .parentsContactNumber,
                                        style: CustomTextStyle.fieldName),
                                    const TextSpan(
                                        text: "*",
                                        style: TextStyle(color: Colors.red))
                                  ])),

                              const SizedBox(
                                height: 10,
                              ),

                              /// params
                              PhoneFormField(
                                controller:
                                    _stepOneController.phoneNumberController,
                                style: CustomTextStyle.bodytext,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade300),
                                  ),
                                  errorStyle: CustomTextStyle.errorText,
                                  contentPadding: const EdgeInsets.all(20),
                                  hintText: language == "en"
                                      ? "Enter mobile number"
                                      : "$gender3 पालकांचा मोबाईल नंबर टाका",
                                  labelStyle: CustomTextStyle.bodytext,
                                  hintStyle: CustomTextStyle.hintText,
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade300),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade300),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade300),
                                  ),
                                ),
                                validator: PhoneValidator.compose([
                                  PhoneValidator.required(
                                      errorText: language == "en"
                                          ? "Enter $gender parent's Contact Number"
                                          : "पालकांचा मोबाईल नंबर टाकणे अनिवार्य आहे",
                                      context),
                                  PhoneValidator.validMobile(
                                      errorText: language == "en"
                                          ? "Enter valid phone number"
                                          : "कृपया वैध फोन नंबर प्रविष्ट करा.",
                                      context)
                                ]),
                                countrySelectorNavigator:
                                    const CountrySelectorNavigator.page(),
                                onChanged: (phoneNumber) =>
                                    print('changed into $phoneNumber'),
                                enabled: true,
                                isCountrySelectionEnabled: true,
                                isCountryButtonPersistent: true,
                                countryButtonStyle: const CountryButtonStyle(
                                    showDialCode: true,
                                    showIsoCode: false,
                                    showFlag: true,
                                    flagSize: 16),
                              ),
                              const SizedBox(
                                height: 20,
                              ),

                              /*  Obx(() {
        if(_stepOneController.phvalidation.value == false){
       return Padding(
         padding: const EdgeInsets.only(left:  18.0 , top: 8 , bottom: 8 ),
         child: Text("Please enter a valid mobile number" , style: CustomTextStyle.errorText,),
       ) ;
      }else{
        return SizedBox();
      }
      },),*/
                              const SizedBox(
                                height: 10,
                              ),
                              RichText(
                                  text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .contactNumbervisibility,
                                    style: CustomTextStyle.fieldName),
                                const TextSpan(
                                    text: "*",
                                    style: TextStyle(color: Colors.red))
                              ])),
                              const SizedBox(
                                height: 10,
                              ),
                              Obx(() {
                                String? language =
                                    sharedPreferences?.getString("Language");
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RadioListTile<int>(
                                      visualDensity: VisualDensity.compact,
                                      contentPadding: const EdgeInsets.all(0),
                                      value:
                                          1, // Using the FieldModel.id directly
                                      groupValue: _stepOneController
                                          .parentContactSelected.value.id,
                                      onChanged: (int? value) {
                                        if (value != null) {
                                          // Update the selected value and the corresponding FieldModel
                                          _stepOneController
                                              .updateParentContact(FieldModel(
                                                  id: value,
                                                  name:
                                                      "Show my contact number to all"));
                                        }
                                      },
                                      title: Text(
                                        language == "en"
                                            ? "Show my contact number to all."
                                            : "${AppLocalizations.of(context)!.only} $gender2 संपर्क क्रमांक दाखवा.",
                                        style: CustomTextStyle.bodytext
                                            .copyWith(
                                                color: AppTheme.textColor),
                                      ),
                                      selected: _stepOneController
                                              .parentContactSelected.value.id ==
                                          1,
                                      selectedTileColor: Colors.white,
                                      activeColor: AppTheme
                                          .secondryColor, // Change this to your desired active color
                                    ),
                                    RadioListTile<int>(
                                      visualDensity: VisualDensity.compact,
                                      contentPadding: const EdgeInsets.all(0),
                                      value:
                                          3, // Using the FieldModel.id directly
                                      groupValue: _stepOneController
                                          .parentContactSelected.value.id,
                                      onChanged: (int? value) {
                                        if (value != null) {
                                          _stepOneController
                                              .updateParentContact(FieldModel(
                                                  id: value, name: "no"));
                                        }
                                      },
                                      title: Text(
                                        AppLocalizations.of(context)!
                                            .showParentContactNumberToAll,
                                        style: CustomTextStyle.bodytext
                                            .copyWith(
                                                color: AppTheme.textColor),
                                      ),
                                      selected: _stepOneController
                                              .parentContactSelected.value.id ==
                                          3,

                                      activeColor: AppTheme
                                          .secondryColor, // Change this to your desired active color
                                    ),
                                    RadioListTile<int>(
                                      visualDensity: VisualDensity.compact,
                                      contentPadding: const EdgeInsets.all(0),
                                      value:
                                          2, // Using the FieldModel.id directly
                                      groupValue: _stepOneController
                                          .parentContactSelected.value.id,
                                      onChanged: (int? value) {
                                        if (value != null) {
                                          _stepOneController
                                              .updateParentContact(FieldModel(
                                                  id: value,
                                                  name:
                                                      "Show my & my parent's contact number to all"));
                                        }
                                      },
                                      title: Text(
                                        language == "en"
                                            /* $gender */ ? AppLocalizations.of(
                                                    context)!
                                                .showmyandparentscontactnumbertoall
                                            : "$gender2 ${AppLocalizations.of(context)!.showmyandparentscontactnumbertoall}",
                                        // "${language == "en" ? gender : gender2} ${AppLocalizations.of(context)!.showmyandparentscontactnumbertoall}",
                                        style: CustomTextStyle.bodytext
                                            .copyWith(
                                                color: AppTheme.textColor),
                                      ),
                                      selected: _stepOneController
                                              .parentContactSelected.value.id ==
                                          2,

                                      activeColor: AppTheme
                                          .secondryColor, // Change this to your desired active color
                                    ),
                                  ],
                                );
                              }),

                              Obx(
                                () {
                                  print("Valid Mang");
                                  if (_stepOneController
                                              .parentContactValidated.value ==
                                          false &&
                                      _stepOneController.isSubmitted.value ==
                                          true) {
                                    if (_stepOneController
                                            .parentContactSelected.value.id ==
                                        null) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 18.0),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .pleaseSelectOneOfAboveOption,
                                              style: CustomTextStyle.errorText,
                                            ),
                                          )
                                        ],
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),

                              /*    Center(child: Column(children: [
                  ElevatedButton(onPressed: (){
                            showCustomSnackBar(
  context,
  'Complete All Fields.',
  'All fields must be completed. Please double-check your input and submit it.',
  'assets/error.png',
);
                  }, child: Text("Error1")), 
                  ElevatedButton(onPressed: (){
                            showCustomSnackBar(
  context,
  'All Fields Are Required.',
  'Please make sure to complete all the fields before submitting the form.',
  'assets/error.png',
);
                  }, child: Text("Error2")), 
                  ElevatedButton(onPressed: (){
                            showCustomSnackBar(
  context,
  'All Fields Are Compulsory.',
  'Kindly fill in all the required details before submitting your form.',
  'assets/error.png',
);
                  }, child: Text("Error3")), 

                 ],),),         */
                              const SizedBox(
                                height: 50,
                              ),

                              Center(
                                child: SizedBox(
                                  height: 50,
                                  width: 170,
                                  child: Obx(
                                    () => ElevatedButton(
                                      onPressed: _stepOneController
                                              .isLoading.value
                                          ? null
                                          : () {
                                              sharedPreferences?.setString(
                                                  "PageIndex", "3");
                                              print(
                                                  "This is ph number in save ${_stepOneController.phoneNumberController.value}");
                                              // Validation for each field
                                              //   bool parentsContactValid = _phoneNumberController.value.toString() == "" ? false : true;
                                              bool contactsOptionValid =
                                                  _stepOneController
                                                          .parentContactSelected
                                                          .value
                                                          .id !=
                                                      null;
                                              bool isManglikValid =
                                                  _stepOneController
                                                          .manglikSelected
                                                          .value
                                                          .id !=
                                                      null;
                                              bool isMaritalStatusValid =
                                                  _stepOneController
                                                          .selectedMaritalStatus
                                                          .value
                                                          .id !=
                                                      null;
                                              bool isPhysicalStatusValid =
                                                  _stepOneController
                                                          .selectedPhysicalStatus
                                                          .value
                                                          .id !=
                                                      null;

                                              // Children validation based on marital status
                                              bool? isChildrenValid = true;
                                              if (_stepOneController.selectedMaritalStatus.value.id == 2 ||
                                                  _stepOneController
                                                          .selectedMaritalStatus
                                                          .value
                                                          .id ==
                                                      3 ||
                                                  _stepOneController
                                                          .selectedMaritalStatus
                                                          .value
                                                          .id ==
                                                      4 ||
                                                  _stepOneController
                                                          .selectedMaritalStatus
                                                          .value
                                                          .id ==
                                                      5) {
                                                isChildrenValid =
                                                    _stepOneController
                                                            .selectedChildren
                                                            .value
                                                            .id !=
                                                        null;
                                              }

                                              // Update validation statuses in the controller
                                              _stepOneController
                                                  .selectedManglikValidated
                                                  .value = isManglikValid;
                                              //    _stepOneController.phvalidation.value = parentsContactValid;
                                              _stepOneController
                                                  .selectedMaritialStatusValidated
                                                  .value = isMaritalStatusValid;
                                              _stepOneController
                                                  .selectedPhysicalStatusValidated
                                                  .value = isPhysicalStatusValid;
                                              _stepOneController
                                                      .selectedChildrenValidated
                                                      .value =
                                                  isChildrenValid ?? true;
                                              _stepOneController
                                                  .parentContactValidated
                                                  .value = contactsOptionValid;
                                              // Set submitted state
                                              _stepOneController
                                                  .isSubmitted.value = true;

                                              // Validate form
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                // Check if all validations are passed
                                                if (_stepOneController
                                                        .selectedHour.value ==
                                                    "") {
                                                  _scrollToWidget(
                                                      _timeFieldKey);
                                                } else if (_locationController
                                                        .selectedPlace
                                                        .value
                                                        .id ==
                                                    null) {
                                                  _scrollToWidget(
                                                      _placeofbirthKey);
                                                } else if (_stepOneController
                                                        .selectedZodiacSign
                                                        .value
                                                        ?.id ==
                                                    null) {
                                                  _scrollToWidget(_rasKey);
                                                } else if (!isManglikValid) {
                                                  _scrollToWidget(_manglikKey);
                                                } else if (_stepOneController
                                                        .selectedHeight
                                                        .value
                                                        ?.id ==
                                                    null) {
                                                  _scrollToWidget(_heightKey);
                                                } else if (_stepOneController
                                                        .selectedBloodGroup
                                                        .value
                                                        ?.id ==
                                                    null) {
                                                  _scrollToWidget(
                                                      _bloodGroupKey);
                                                } else if (!isPhysicalStatusValid) {
                                                  _scrollToWidget(
                                                      _physicalStatusKey);
                                                } else if (!isMaritalStatusValid) {
                                                  _scrollToWidget(
                                                      _maritialStatus);
                                                } else if (_stepOneController
                                                        .phoneNumberController
                                                        .value
                                                        .nsn ==
                                                    "") {
                                                  _scrollToWidget(
                                                      _parentsContacKey);
                                                } else {
                                                  // Start loading state
                                                  _stepOneController
                                                      .isLoading.value = true;

                                                  // API call
                                                  _stepOneController.BasicForm(
                                                    context: context,
                                                    contactNumberVisiblity:
                                                        _stepOneController
                                                                .parentContactSelected
                                                                .value
                                                                .id ??
                                                            0,
                                                    parentsContactNumber:
                                                        _stepOneController
                                                            .phoneNumberController
                                                            .value
                                                            .nsn
                                                            .toString(),
                                                    timeOfBirth:
                                                        _stepOneController
                                                            .selected24HourFormat
                                                            .value,
                                                    placeOfBirth:
                                                        _locationController
                                                            .selectedPlace
                                                            .value
                                                            .id
                                                            .toString(),
                                                    ras: _stepOneController
                                                            .selectedZodiacSign
                                                            .value
                                                            ?.id ??
                                                        0,
                                                    manglik: _stepOneController
                                                            .manglikSelected
                                                            .value
                                                            .id ??
                                                        0,
                                                    maritalStatus:
                                                        _stepOneController
                                                                .selectedMaritalStatus
                                                                .value
                                                                .id ??
                                                            0,
                                                    haveChildren:
                                                        _stepOneController
                                                                .selectedChildren
                                                                .value
                                                                .id ??
                                                            0,
                                                    numberOfChildren:
                                                        _stepOneController
                                                                .selectedNumberOfChildren
                                                                .value
                                                                ?.id ??
                                                            0,
                                                    height: _stepOneController
                                                            .selectedHeight
                                                            .value
                                                            ?.id ??
                                                        0,
                                                    bloodGroup: _stepOneController
                                                            .selectedBloodGroup
                                                            .value
                                                            ?.id ??
                                                        0,
                                                    disability: _stepOneController
                                                            .selectedPhysicalStatus
                                                            .value
                                                            .id ??
                                                        0,
                                                    disabilityDesc:
                                                        _stepOneController
                                                            .physicalStatus.text
                                                            .trim(),
                                                  ).then((result) {
                                                    // Reset loading state
                                                    _stepOneController.isLoading
                                                        .value = false;
                                                    // Handle successful result (optional)
                                                  }).catchError((error) {
                                                    // Handle error and reset loading state
                                                    _stepOneController.isLoading
                                                        .value = false;
                                                    print("Error: $error");
                                                  });
                                                }
                                              } else {
                                                if (_stepOneController
                                                        .selectedHour.value ==
                                                    "") {
                                                  _scrollToWidget(
                                                      _timeFieldKey);
                                                } else if (_locationController
                                                        .selectedPlace
                                                        .value
                                                        .id ==
                                                    null) {
                                                  _scrollToWidget(
                                                      _placeofbirthKey);
                                                } else if (_stepOneController
                                                        .selectedZodiacSign
                                                        .value
                                                        ?.id ==
                                                    null) {
                                                  _scrollToWidget(_rasKey);
                                                } else if (!isManglikValid) {
                                                  _scrollToWidget(_manglikKey);
                                                } else if (_stepOneController
                                                        .selectedHeight
                                                        .value
                                                        ?.id ==
                                                    null) {
                                                  _scrollToWidget(_heightKey);
                                                } else if (_stepOneController
                                                        .selectedBloodGroup
                                                        .value
                                                        ?.id ==
                                                    null) {
                                                  _scrollToWidget(
                                                      _bloodGroupKey);
                                                } else if (!isPhysicalStatusValid) {
                                                  _scrollToWidget(
                                                      _physicalStatusKey);
                                                } else if (!isMaritalStatusValid) {
                                                  _scrollToWidget(
                                                      _maritialStatus);
                                                } else if (_castController
                                                        .selectedSubSection
                                                        .value
                                                        .id ==
                                                    null) {
                                                  _scrollToWidget(
                                                      _subSectionKey);
                                                } else if (_castController
                                                        .selectedCast
                                                        .value
                                                        .id ==
                                                    null) {
                                                  _scrollToWidget(_casteKey);
                                                } else if (_stepOneController
                                                        .phoneNumberController
                                                        .value
                                                        .nsn ==
                                                    "") {
                                                  _scrollToWidget(
                                                      _parentsContacKey);
                                                }

                                                // Show error if form validation fails
                                                //   Get.snackbar("Error", "Please Fill all required Fields");
                                              }
                                            },
                                      child: _stepOneController.isLoading.value
                                          ? const CircularProgressIndicator(
                                              color: Colors.white)
                                          : Text(
                                              AppLocalizations.of(context)!
                                                  .save,
                                              style: CustomTextStyle
                                                  .elevatedButton),
                                    ),
                                  ),
                                ),
                              ),

                              // ElevatedButton(
                              //     onPressed: () {
                              //       sharedPreferences?.setString(
                              //           "PageIndex", "3");
                              //       navigatorKey.currentState!
                              //           .push(MaterialPageRoute(
                              //         builder: (context) => UserInfoStepTwo(),
                              //       ));
                              //     },
                              //     child: Text("NEXT PAGE"))
                            ],
                          )),
                    )
                  ],
                );
              }
            },
          ),
        ),
      )),
    );
  }

  void _showSubSectionBottomSheet(BuildContext context) {
    final CastController castController = Get.find<CastController>();
    // Fetch Ras data when modal opens
    castController.fetchSubSectionFromApi();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height *
                0.7, // Set your desired max height here
          ),
          child: Container(
            width: double.infinity,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Center(
                      child: Text("Select Sub Section",
                          style: CustomTextStyle.bodytextboldLarge),
                    ),
                    const SizedBox(height: 10),

                    // Use Obx to listen for changes in fetched data and loading state
                    Obx(() {
                      if (castController.isloading.value) {
                        return Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(3, (index) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: ChoiceChip(
                                label: Container(
                                  width: 50,
                                  height: 20,
                                  color: Colors.grey[
                                      300], // Placeholder color for shimmer
                                ),
                                selected: false,
                                onSelected: (_) {},
                              ),
                            );
                          }),
                        );
                      }
                      if (castController.subsectionerror.value) {
                        return const Center(
                          child: Text("Server Problem"),
                        );
                      } else if (castController.subSectionList.isEmpty) {
                        return const Center(
                            child: Text(
                                'No data found')); // Show message if no data
                      }

                      // Display the fetched list of items in ChoiceChips (only one can be selected)
                      return Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        alignment: WrapAlignment.start,
                        spacing: 5,
                        runSpacing: 10,
                        children: castController.subSectionList
                            .map((FieldModel item) {
                          final isSelected =
                              castController.selectedSubSection.value.id ==
                                  item.id;

                          return ChoiceChip(
                            labelPadding: const EdgeInsets.all(4),
                            checkmarkColor: Colors.white,
                            disabledColor: AppTheme.lightPrimaryColor,
                            backgroundColor: AppTheme.lightPrimaryColor,
                            label: Text(
                              item.name ?? "", // Display FieldModel name
                              style: CustomTextStyle.bodytext.copyWith(
                                fontSize: 14,
                                color: isSelected
                                    ? AppTheme.lightPrimaryColor
                                    : AppTheme.selectedOptionColor,
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (bool selected) {
                              if (selected) {
                                castController.selectSubSection(
                                    item); // Update the selected item
                              }
                            },
                            selectedColor: AppTheme.selectedOptionColor,
                            labelStyle: CustomTextStyle.bodytext.copyWith(
                              fontSize: 14,
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme.secondryColor,
                            ),
                          );
                        }).toList(),
                      );
                    }),

                    const SizedBox(height: 20),

                    // Done button to close the modal
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    side: const BorderSide(color: Colors.red)),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  // " Cancel",
                                  AppLocalizations.of(context)!.cancel,
                                  style: CustomTextStyle.elevatedButton
                                      .copyWith(color: Colors.red),
                                ))),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              // "Done",
                              AppLocalizations.of(context)!.done,
                              style: CustomTextStyle.elevatedButton,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSectionBottomSheet(BuildContext context) {
    final CastController castController = Get.put(CastController());
    // Fetch Ras data when modal opens
    castController.fetchSectionFromApi();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          width: double.infinity,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Select Section",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "WORKSANS",
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Use Obx to listen for changes in fetched data and loading state
                  Obx(() {
                    if (castController.isloading.value) {
                      return Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: List.generate(3, (index) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: ChoiceChip(
                              label: Container(
                                width: 50,
                                height: 20,
                                color: Colors
                                    .grey[300], // Placeholder color for shimmer
                              ),
                              selected: false,
                              onSelected: (_) {},
                            ),
                          );
                        }),
                      );
                    }

                    if (castController.sectionList.isEmpty) {
                      return const Center(
                          child:
                              Text('No data found')); // Show message if no data
                    }

                    // Display the fetched list of items in ChoiceChips (only one can be selected)
                    return Wrap(
                      spacing: 5,
                      runSpacing: 10,
                      children:
                          castController.sectionList.map((FieldModel item) {
                        final isSelected =
                            castController.selectedSection.value == item.name;

                        return ChoiceChip(
                          checkmarkColor: Colors.white,
                          disabledColor: AppTheme.lightPrimaryColor,
                          backgroundColor: AppTheme.lightPrimaryColor,
                          label: Text(
                            item.name ?? "", // Display FieldModel name
                            style: CustomTextStyle.bodytext.copyWith(
                              fontSize: 14,
                              color: isSelected
                                  ? AppTheme.lightPrimaryColor
                                  : AppTheme.selectedOptionColor,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (bool selected) {
                            if (selected) {
                              castController.selectSection(
                                  item.name ?? ""); // Update the selected item
                              castController.selectedSectionID.value =
                                  item.id.toString();
                              print("This is Section ${item.id}");
                              castController.selectedSectionInt.value =
                                  item.id ?? 0;
                            }
                          },
                          selectedColor: AppTheme.selectedOptionColor,
                          labelStyle: CustomTextStyle.bodytext.copyWith(
                            fontSize: 14,
                            color: isSelected
                                ? Colors.white
                                : AppTheme.secondryColor,
                          ),
                        );
                      }).toList(),
                    );
                  }),

                  const SizedBox(height: 20),

                  // Done button to close the modal
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Done",
                      style: CustomTextStyle.elevatedButton,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCastBottomSheet(BuildContext context) {
    final CastController castController = Get.put(CastController());
    // Fetch Cast data when modal opens
    castController.fetchCastFromApi();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height *
                0.7, // Set your desired max height here
          ),
          child: Container(
            width: double.infinity,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Select Caste",
                      style: CustomTextStyle.bodytextboldLarge),
                  const SizedBox(height: 10),

                  // Wrap the content in a SingleChildScrollView
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Use Obx to listen for changes in fetched data and loading state
                          Obx(() {
                            if (castController.isloading.value) {
                              return Wrap(
                                spacing: 10,
                                direction: Axis.vertical,
                                runSpacing: 10,
                                children: List.generate(3, (index) {
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: ChoiceChip(
                                      label: Container(
                                        width: 50,
                                        height: 20,
                                        color: Colors.grey[
                                            300], // Placeholder color for shimmer
                                      ),
                                      selected: false,
                                      onSelected: (_) {},
                                    ),
                                  );
                                }),
                              );
                            }

                            if (castController.castList.isEmpty) {
                              return const Center(
                                  child: Text(
                                      'No data found')); // Show message if no data
                            }

                            // Display the fetched list of items in ChoiceChips (only one can be selected)
                            return Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: castController.castList
                                  .map((FieldModel item) {
                                final isSelected =
                                    castController.selectedCast.value.id ==
                                        item.id;

                                return ChoiceChip(
                                  labelPadding: const EdgeInsets.all(4),
                                  checkmarkColor: Colors.white,
                                  disabledColor: AppTheme.lightPrimaryColor,
                                  backgroundColor: AppTheme.lightPrimaryColor,
                                  label: Text(
                                    item.name ?? "", // Display FieldModel name
                                    style: CustomTextStyle.bodytext.copyWith(
                                      fontSize: 14,
                                      color: isSelected
                                          ? AppTheme.lightPrimaryColor
                                          : AppTheme.selectedOptionColor,
                                    ),
                                  ),
                                  selected: isSelected,
                                  onSelected: (bool selected) {
                                    if (selected) {
                                      // Update the selected item
                                      castController.selectedCast.value =
                                          item; // Correct assignment
                                    }
                                  },
                                  selectedColor: AppTheme.selectedOptionColor,
                                  labelStyle: CustomTextStyle.bodytext.copyWith(
                                    fontSize: 14,
                                    color: isSelected
                                        ? Colors.white
                                        : AppTheme.secondryColor,
                                  ),
                                );
                              }).toList(),
                            );
                          }),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),

                  // Done button to close the modal
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.red)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                // " Cancel",
                                AppLocalizations.of(context)!.cancel,
                                style: CustomTextStyle.elevatedButton
                                    .copyWith(color: Colors.red),
                              ))),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            // "Done",
                            AppLocalizations.of(context)!.done,
                            style: CustomTextStyle.elevatedButton,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showZodiacSelection(BuildContext context) {
    // Access the ZodiacController
    final StepOneController zodiacController = Get.find<StepOneController>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppLocalizations.of(context)!.selectRas,
                    style: CustomTextStyle.bodytextboldLarge),
                const SizedBox(height: 10),

                // Dynamic list of zodiac signs from the controller
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: zodiacController.zodiacSigns.map((FieldModel sign) {
                    return Obx(() {
                      // Only this part rebuilds when the selectedZodiacSign value changes
                      final isSelected =
                          zodiacController.selectedZodiacSign.value?.id ==
                              sign.id;

                      return ChoiceChip(
                        labelPadding: const EdgeInsets.all(4),
                        checkmarkColor: Colors.white,
                        disabledColor: AppTheme.lightPrimaryColor,
                        backgroundColor: AppTheme.lightPrimaryColor,
                        label: Text(
                          sign.name ?? '', // Display zodiac name
                          style: CustomTextStyle.bodytext.copyWith(
                            fontSize: 14,
                            color: isSelected
                                ? AppTheme.lightPrimaryColor
                                : AppTheme.selectedOptionColor,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          if (selected) {
                            // Update the controller's selected value directly
                            zodiacController.updateZodiacSign(sign);
                            if (_rasKey.currentState != null) {
                              _rasKey.currentState!.validate();
                            }
                          }
                        },
                        selectedColor: AppTheme.selectedOptionColor,
                        labelStyle: CustomTextStyle.bodytext.copyWith(
                          fontSize: 14,
                          color: isSelected
                              ? Colors.white
                              : AppTheme.secondryColor,
                        ),
                      );
                    });
                  }).toList(),
                ),
                const SizedBox(height: 20),
                // Done button to close the modal
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: const BorderSide(color: Colors.red)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.cancel,
                              style: CustomTextStyle.elevatedButton
                                  .copyWith(color: Colors.red),
                            ))),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.done,
                          style: CustomTextStyle.elevatedButton,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showRasSelectBottomSheet(BuildContext context) {
    final Rascontroller rasController = Get.put(Rascontroller());
    // Fetch Ras data when modal opens
    rasController.fetchRasFromApi();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows full-screen bottom sheet if needed
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Select ras",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: "WORKSANS",
                  ),
                ),
                const SizedBox(height: 10),

                // Use Obx to listen for changes in fetched data and loading state
                Obx(() {
                  if (rasController.isloading.value) {
                    return Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(10, (index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: ChoiceChip(
                            label: Container(
                              width: 50,
                              height: 20,
                              color: Colors
                                  .grey[300], // Placeholder color for shimmer
                            ),
                            selected: false,
                            onSelected: (_) {},
                          ),
                        );
                      }),
                    );
                  }

                  if (rasController.rassList.isEmpty) {
                    return const Center(
                        child:
                            Text('No data found')); // Show message if no data
                  }

                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: rasController.rassList.map((FieldModel item) {
                      // Compare item with the preselected value in rasSelected
                      final isSelected =
                          rasController.rasSelected.value.id == item.id;

                      return ChoiceChip(
                        checkmarkColor: Colors.white,
                        disabledColor: AppTheme.lightPrimaryColor,
                        backgroundColor: AppTheme.lightPrimaryColor,
                        label: Text(
                          item.name ?? "", // Display FieldModel name
                          style: CustomTextStyle.bodytext.copyWith(
                            fontSize: 14,
                            color: isSelected
                                ? AppTheme.lightPrimaryColor
                                : AppTheme.selectedOptionColor,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          if (selected) {
                            rasController
                                .selectItem(item); // Update the selected item
                            rasController.rasIndex.value = item.id ?? 0;
                            print("Ras Index ${rasController.rasIndex}");
                          }
                        },
                        selectedColor: AppTheme.selectedOptionColor,
                        labelStyle: CustomTextStyle.bodytext.copyWith(
                          fontSize: 14,
                          color: isSelected
                              ? Colors.white
                              : AppTheme.secondryColor,
                        ),
                      );
                    }).toList(),
                  );
                }),

                const SizedBox(height: 20),

                // Done button to close the modal
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Done",
                    style: CustomTextStyle.elevatedButton,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
