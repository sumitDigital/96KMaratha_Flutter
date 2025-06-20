//import 'package:csc_picker/csc_picker.dart';
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:_96kuliapp/commons/dialogues/logoutDialogoue.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:_96kuliapp/controllers/formfields/educationController.dart';
import 'package:_96kuliapp/controllers/formfields/employedInController.dart';
import 'package:_96kuliapp/controllers/formfields/occupationController.dart';
import 'package:_96kuliapp/controllers/formfields/specializationController.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/controllers/userform/formstep2Controller.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/models/forms/EducationModel.dart';
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/auth_Screens/loginScreen2.dart';
import 'package:_96kuliapp/screens/userInfoForms/location/permanentAdress/permanentCountry.dart';
import 'package:_96kuliapp/screens/userInfoForms/location/presentAddress/presentCountry.dart';
import 'package:_96kuliapp/screens/userInfoForms/userInfoStepOne.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepThree.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/buttonContainer.dart';
import 'package:_96kuliapp/utils/customdropdown.dart';
import 'package:_96kuliapp/utils/customtextform.dart';
import 'package:_96kuliapp/utils/formHeader.dart';
import 'package:_96kuliapp/utils/formheaderbasic.dart';
import 'package:_96kuliapp/utils/formtitletag.dart';
import 'package:_96kuliapp/utils/selectlanguage.dart';
import 'package:shimmer/shimmer.dart';

class UserInfoStepTwo extends StatefulWidget {
  const UserInfoStepTwo({super.key});

  @override
  State<UserInfoStepTwo> createState() => _UserInfoStepTwoState();
}

class _UserInfoStepTwoState extends State<UserInfoStepTwo> {
  final StepTwoController _stepTwoController = Get.put(StepTwoController());
  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController countryPermanent = TextEditingController();
  TextEditingController statePermanent = TextEditingController();
  TextEditingController cityPermanent = TextEditingController();
  late String gender;
  String? gender2;
  String? gender3;
  String? gender4;
  @override
  void initState() {
    super.initState(); // Call the superclass's method
    gender = selectgender();
    _stepTwoController.fetchEducationInfo();
  }

  String? language = sharedPreferences?.getString("Language");

  final LocationController _locationController = Get.put(LocationController());
  final EmplyedInController _emplyedInController =
      Get.put(EmplyedInController());
  final OccupationController _occupationController =
      Get.put(OccupationController());
  final SpecializationController _specializationController =
      Get.put(SpecializationController());
  final EducationController _educationController =
      Get.put(EducationController());
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<FormFieldState> _highestEducationKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _specializationKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _employedInKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _OccupationKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _designationKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _companyNameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _jobLocationKey = GlobalKey<FormFieldState>();

  final GlobalKey<FormFieldState> _AnnualincomeKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _workModeKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _presentAddressKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _permanentAddressKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _nativePlaceKey = GlobalKey<FormFieldState>();

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
        gender4 = "वराचे";
        return "वराची";
      } else {
        gender2 = "वधूचा";
        gender3 = "वधूच्या";
        gender4 = "वधूचे";

        return "वधूची";
      }
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String presentlocationText = "";
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

  // String? language = sharedPreferences?.getString("Language");

  List<Map<String, dynamic>> jsonData = [
    {"id": 1, "name": "No Income"},
    {"id": 2, "name": "0 - 1 Lakh"},
    {"id": 3, "name": "1 - 2 Lakhs"},
    {"id": 4, "name": "2 - 3 Lakhs"},
    {"id": 5, "name": "3 - 5 Lakhs"},
    {"id": 6, "name": "5 - 7 Lakhs"},
    {"id": 7, "name": "7 - 10 Lakhs"},
    {"id": 8, "name": "10 - 15 Lakhs"},
    {"id": 9, "name": "15 - 20 Lakhs"},
    {"id": 10, "name": "16 - 18 Lakhs"},
    {"id": 11, "name": "18 - 20 Lakhs"},
    {"id": 12, "name": "20 - 30 Lakhs"},
    {"id": 13, "name": "30 - 40 Lakhs"},
    {"id": 14, "name": "40 - 50 Lakhs"},
    {"id": 15, "name": "50 - 60 Lakhs"},
    {"id": 16, "name": "60 - 70 Lakhs"},
    {"id": 17, "name": "70 - 80 Lakhs"},
    {"id": 18, "name": "80 - 90 Lakhs"},
    {"id": 19, "name": "90 Lakhs - 1 Crore"},
    {"id": 20, "name": "1 Crore & Above"}
  ];

  // Convert JSON to ListItems

  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String countryValuePermanent = "";
  String stateValuePermanent = "";
  String cityValuePermanent = "";
  @override
  Widget build(BuildContext context) {
    // print("Language $language");
    List<ListItems> itemsList = jsonData.map((item) {
      return ListItems(item['name'], item['id']);
    }).toList();

    ListItems? selectedItem;
    if (_stepTwoController.basicInfoData["annual_income"] != null) {
      selectedItem = itemsList.firstWhere(
        (element) =>
            element.numericValue ==
            _stepTwoController.basicInfoData["annual_income"],
      );
    }
    return WillPopScope(
      onWillPop: () async {
        navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
          builder: (context) => const UserInfoStepOne(),
        ));

        return false; // Prevent default back navigation
      },
      child: Scaffold(
        body: SingleChildScrollView(
          controller: _scrollController,
          child: SafeArea(child: Obx(
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
                    gender4 = "वराचे";
                    return "वराची";
                  } else {
                    gender2 = "वधूचा";
                    gender3 = "वधूच्या";
                    gender4 = "वधूचे";

                    return "वधूची";
                  }
                }
              }

              gender = selectgender();
              if (_stepTwoController.isPageLoading.value) {
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
                                    navigatorKey.currentState!
                                        .pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const UserInfoStepOne(),
                                      ),
                                      (route) => false,
                                    );
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
                                Text(
                                  AppLocalizations.of(context)!.step2,
                                  style: CustomTextStyle.bodytextLarge,
                                ),
                              ],
                            ),
                            const SelectLanguage()
                          ],
                        ),
                      ),
                      StepsFormHeaderBasic(
                        title: AppLocalizations.of(context)!
                            .updateEducationCareerLocation,
                        desc: _stepTwoController.headingText.value,
                        // "Find your soulmate by sharing your education, career, and location. It’s quick and easy.",
                        image: _stepTwoController.headingImage.value,
                        // "assets/formstep1.png",
                        statusdesc:
                            "Submit this form to boost your profile visibility by",
                        statusPercent: "40%",
                      ),
                    ],
                  ),
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormsTitleTag(
                      pageName: "incompleteForms",
                      title: AppLocalizations.of(context)!.step2,
                      lang: true,
                      onTap: () {
                        if (navigatorKey.currentState!.canPop()) {
                          Get.back();
                        } else {
                          navigatorKey.currentState!
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => const UserInfoStepOne(),
                          ));
                        }
                      },
                      onTaplang: () {
                        _stepTwoController.fetchEducationInfo();
                        _locationController.fetchCountries();
                        _stepTwoController.loadItems();
                        /* Highest-Education */
                        if (_stepTwoController
                                .basicInfoData["highest_education"] ==
                            null) {
                          _educationController.selectedEducation.value.name =
                              '';
                          _educationController.selectedEducation.value.id =
                              null;
                        }
                        /* Specialization */
                        if (_stepTwoController
                                .basicInfoData["specialization"] ==
                            null) {
                          _specializationController
                              .selectedSpecialization.value.name = '';
                          _specializationController
                              .selectedSpecialization.value.id = 0;
                        }
                        /* Employed-in */
                        if (_stepTwoController.basicInfoData["employed_in"] ==
                            null) {
                          _emplyedInController.selectedOption.value.name = '';
                          _emplyedInController.selectedOption.value.id = null;
                        }
                        /* Occupation */
                        if (_stepTwoController.basicInfoData["occupation"] ==
                            null) {
                          _occupationController.selectedOccupation.value.name =
                              '';
                          _occupationController.selectedOccupation.value.id =
                              null;
                        }
                        /* AnuualIncome */
                        if (_stepTwoController.basicInfoData["annual_income"] ==
                            null) {
                          _stepTwoController.selectedAnnualIncome.value?.name =
                              '';
                          _stepTwoController.selectedAnnualIncome.value?.id =
                              null;
                        }
                        /* presentCountry */
                        if (_stepTwoController
                                    .basicInfoData["present_country"] ==
                                null ||
                            _stepTwoController.basicInfoData["present_state"] ==
                                null) {
                          _locationController.presentselectedCity.value.name =
                              '';
                          _locationController.presentselectedState.value.name =
                              '';
                          _locationController
                              .presentselectedCountry.value.name = '';
                          _locationController.presentselectedCity.value.id =
                              null;
                          _locationController.presentselectedState.value.id =
                              null;
                          _locationController.presentselectedCountry.value.id =
                              null;
                          /* Permament Address */

                          _locationController.permanentSelectedCity.value.name =
                              '';
                          _locationController
                              .permanentSelectedState.value.name = '';
                          _locationController
                              .permanentSelectedCountry.value.name = '';
                          _locationController.permanentSelectedCity.value.id =
                              null;
                          _locationController.permanentSelectedState.value.id =
                              null;
                          _locationController
                              .permanentSelectedCountry.value.id = null;
                        }
                      },
                    ),
                    StepsFormHeader(
                        statusDescMarathiPrefix: AppLocalizations.of(context)!
                            .updateProfileAndBoostVisibilitypreffix,
                        statusPercentMarathi:
                            AppLocalizations.of(context)!.updatePercent40,
                        statusDescMarathiSuffix: AppLocalizations.of(context)!
                            .updateProfileAndBoostVisibilitySuffix,
                        endhour: _stepTwoController.endhours.value,
                        endminutes: _stepTwoController.endminutes.value,
                        endseconds: _stepTwoController.endseconds.value,
                        title: AppLocalizations.of(context)!
                            .updateEducationCareerLocation,
                        desc: "${_stepTwoController.headingText}",
                        image: _stepTwoController.headingImage.value,
                        statusdesc: "Update profile & boost visibility by",
                        statusPercent: "40%"),
                    const SizedBox(
                      height: 40,
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
                    Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                key: _highestEducationKey,
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .highestEducation,
                                      style: CustomTextStyle.fieldName),
                                  const TextSpan(
                                      text: "*",
                                      style: TextStyle(color: Colors.red))
                                ]),
                              ),
                              Obx(
                                () {
                                  TextEditingController textEditingController =
                                      TextEditingController(
                                          text: _educationController
                                              .selectedEducation.value.name);
                                  return CustomTextField(
                                      validator: (value) {
                                        if (language == "en") {
                                          if (value == null || value.isEmpty) {
                                            return 'enter $gender education ';
                                          }
                                        } else {
                                          if (value == null || value.isEmpty) {
                                            return 'कृपया $gender4 शिक्षण निवडा';
                                          }
                                        }
                                        return null;
                                      },
                                      textEditingController:
                                          textEditingController,
                                      readonly: true,
                                      ontap: () {
                                        _showEducationBottomSheet(context);
                                      },
                                      HintText: language == "en"
                                          ? "$gender education"
                                          : "$gender4 शिक्षण");
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              _educationController.selectedEducation.value.id == 10 ||
                                      _educationController
                                              .selectedEducation.value.id ==
                                          15 ||
                                      _educationController
                                              .selectedEducation.value.id ==
                                          23 ||
                                      _educationController
                                              .selectedEducation.value.id ==
                                          33 ||
                                      _educationController
                                              .selectedEducation.value.id ==
                                          36 ||
                                      _educationController
                                              .selectedEducation.value.id ==
                                          42 ||
                                      _educationController
                                              .selectedEducation.value.id ==
                                          60 ||
                                      _educationController
                                              .selectedEducation.value.id ==
                                          68 ||
                                      _educationController
                                              .selectedEducation.value.id ==
                                          74 ||
                                      _educationController
                                              .selectedEducation.value.id ==
                                          90 ||
                                      _educationController
                                              .selectedEducation.value.id ==
                                          94 ||
                                      _educationController
                                              .selectedEducation.value.id ==
                                          97
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                            text: const TextSpan(
                                                children: <TextSpan>[
                                              TextSpan(
                                                  text: "Other education ",
                                                  style: CustomTextStyle
                                                      .fieldName),
                                              TextSpan(
                                                  text: "*",
                                                  style: TextStyle(
                                                      color: Colors.red))
                                            ])),
                                        CustomTextField(
                                          HintText: "Enter other education",
                                          textEditingController:
                                              _stepTwoController.othereducation,
                                          validator: (value) {
                                            if (language == "en") {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Enter $gender education ';
                                              }
                                            } else {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return '$gender4 शिक्षण टाकणे अनिवार्य आहे';
                                              }
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    )
                                  : const SizedBox(),
                              RichText(
                                  key: _specializationKey,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .specialization,
                                        style: CustomTextStyle.fieldName),
                                    const TextSpan(
                                        text: "*",
                                        style: TextStyle(color: Colors.red))
                                  ])),
                              Obx(
                                () {
                                  TextEditingController textEditingController =
                                      TextEditingController(
                                          text: _specializationController
                                              .selectedSpecialization
                                              .value
                                              .name);
                                  return CustomTextField(
                                      validator: (value) {
                                        if (language == "en") {
                                          if (value == null || value.isEmpty) {
                                            return 'Select specialization of $gender';
                                          }
                                        } else {
                                          if (value == null || value.isEmpty) {
                                            return 'कृपया $gender4 स्पेशलायझेशन निवडा';
                                          }
                                        }

                                        return null;
                                      },
                                      textEditingController:
                                          textEditingController,
                                      readonly: true,
                                      ontap: () {
                                        _showSpecializationBottomSheet(context);
                                      },
                                      HintText: language == "en"
                                          ? "Select specialization"
                                          : "$gender4 स्पेशलायझेशन निवडा");
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              _specializationController
                                          .selectedSpecialization.value.id ==
                                      180
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                            text: const TextSpan(
                                                children: <TextSpan>[
                                              TextSpan(
                                                  text: "Other Specialization ",
                                                  style: CustomTextStyle
                                                      .fieldName),
                                              TextSpan(
                                                  text: "*",
                                                  style: TextStyle(
                                                      color: Colors.red))
                                            ])),
                                        CustomTextField(
                                          HintText:
                                              "Enter other $gender Specialization",
                                          textEditingController:
                                              _stepTwoController
                                                  .otherspecialization,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter other Specialization ';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    )
                                  : const SizedBox(),
                              RichText(
                                key: _employedInKey,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .employedIn,
                                        style: CustomTextStyle.fieldName),
                                    const TextSpan(
                                        text: "*",
                                        style: TextStyle(color: Colors.red))
                                  ],
                                ),
                              ),
                              Obx(
                                () {
                                  final TextEditingController employeedIn =
                                      TextEditingController(
                                          text: _emplyedInController
                                              .selectedOption.value.name);
                                  return CustomTextField(
                                    validator: (value) {
                                      if (language == "en") {
                                        if (value == null || value.isEmpty) {
                                          return 'Select Employed in which field';
                                        }
                                      } else {
                                        if (value == null || value.isEmpty) {
                                          return 'कृपया $gender जॉब क्षेत्र निवडा';
                                        }
                                      }

                                      return null;
                                    },
                                    textEditingController: employeedIn,
                                    HintText: language == "en"
                                        ? "Employed in which field"
                                        : "$gender जॉब क्षेत्र निवडा",
                                    ontap: () {
                                      _showEmployeedInBottomSheet(context);
                                    },
                                    readonly: true,
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              _emplyedInController.selectedOption.value.id ==
                                          7 ||
                                      _emplyedInController
                                              .selectedOption.value.id ==
                                          8 ||
                                      _emplyedInController
                                              .selectedOption.value.id ==
                                          9
                                  ? const SizedBox()
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          key: _OccupationKey,
                                          text: TextSpan(children: <TextSpan>[
                                            TextSpan(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .occupation,
                                                style:
                                                    CustomTextStyle.fieldName),
                                            const TextSpan(
                                                text: "*",
                                                style: TextStyle(
                                                    color: Colors.red))
                                          ]),
                                        ),
                                        Obx(
                                          () {
                                            TextEditingController
                                                textEditingController =
                                                TextEditingController(
                                                    text: _occupationController
                                                        .selectedOccupation
                                                        .value
                                                        .name);
                                            return CustomTextField(
                                              validator: (value) {
                                                if (language == "en") {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Select business of $gender';
                                                  }
                                                } else {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'कृपया $gender2 नोकरी/व्यवसाय निवडा';
                                                  }
                                                }
                                                return null;
                                              },
                                              textEditingController:
                                                  textEditingController,
                                              readonly: true,
                                              HintText: language == "en"
                                                  ? "Select business of $gender"
                                                  : "$gender2 नोकरी/व्यवसाय",
                                              ontap: () {
                                                _showOccupationBottomSheet(
                                                    context);
                                              },
                                            );
                                          },
                                        ),
                                        _occupationController.selectedOccupation
                                                        .value.id ==
                                                    33 ||
                                                _occupationController
                                                        .selectedOccupation
                                                        .value
                                                        .id ==
                                                    169 ||
                                                _occupationController
                                                        .selectedOccupation
                                                        .value
                                                        .id ==
                                                    181
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  RichText(
                                                      text: const TextSpan(
                                                          children: <TextSpan>[
                                                        TextSpan(
                                                            text:
                                                                "Other Occupation ",
                                                            style:
                                                                CustomTextStyle
                                                                    .fieldName),
                                                        TextSpan(
                                                            text: "*",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red))
                                                      ])),
                                                  CustomTextField(
                                                    HintText:
                                                        "Enter other Occupation",
                                                    textEditingController:
                                                        _stepTwoController
                                                            .otheroccupation,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter $gender other Occupation ';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        RichText(
                                          key: _designationKey,
                                          text: TextSpan(children: <TextSpan>[
                                            TextSpan(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .designation,
                                                style:
                                                    CustomTextStyle.fieldName),
                                            const TextSpan(
                                                text: "*",
                                                style: TextStyle(
                                                    color: Colors.red))
                                          ]),
                                        ),
                                        CustomTextField(
                                          textEditingController:
                                              _stepTwoController
                                                  .designationController,
                                          validator: (value) {
                                            if (language == "en") {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Enter designation of $gender';
                                              }
                                            } else {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'कृपया $gender4 डेजिग्नेशन टाका';
                                              }
                                            }

                                            return null;
                                          },
                                          HintText: language == "en"
                                              ? "Designation of $gender"
                                              : "$gender4 डेजिग्नेशन टाका",
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        RichText(
                                          key: _companyNameKey,
                                          text: TextSpan(children: <TextSpan>[
                                            TextSpan(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .companyName,
                                                style:
                                                    CustomTextStyle.fieldName),
                                            const TextSpan(
                                                text: "*",
                                                style: TextStyle(
                                                    color: Colors.red))
                                          ]),
                                        ),
                                        CustomTextField(
                                          textEditingController:
                                              _stepTwoController
                                                  .companyNameController,
                                          validator: (value) {
                                            if (language == "en") {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Enter $gender company name';
                                              }
                                            } else {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'कृपया $gender3 कंपनीचे नाव टाका';
                                              }
                                            }

                                            return null;
                                          },
                                          HintText: language == "en"
                                              ? "$gender company Name"
                                              : "$gender3 कंपनीचे नाव टाका",
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                              RichText(
                                key: _AnnualincomeKey,
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .annualIncome,
                                      style: CustomTextStyle.fieldName),
                                  const TextSpan(
                                      text: "*",
                                      style: TextStyle(color: Colors.red))
                                ]),
                              ),
                              Obx(() {
                                // Controller
                                final TextEditingController
                                    annualIncomeController =
                                    TextEditingController(
                                  text: _stepTwoController
                                          .selectedAnnualIncome.value?.name ??
                                      '',
                                );

                                return CustomTextField(
                                  textEditingController: annualIncomeController,
                                  readonly: true, // To prevent manual input
                                  HintText: language == "en"
                                      ? 'Select annual Income'
                                      : "$gender4 वार्षिक उत्पन्न निवडा",
                                  ontap: () {
                                    // Preload the list when opening the dialog
                                    _stepTwoController.filteredItemsList.value =
                                        _stepTwoController.itemsList;

                                    // When text field is tapped, show dialog with search and options
                                    TextEditingController searchController =
                                        TextEditingController();

                                    // Show the dialog
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: SingleChildScrollView(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  // Search Field
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 8.0,
                                                            top: 8),
                                                    child: TextField(
                                                      controller:
                                                          searchController,
                                                      decoration:
                                                          InputDecoration(
                                                        errorMaxLines: 5,
                                                        errorStyle:
                                                            CustomTextStyle
                                                                .errorText,
                                                        labelStyle:
                                                            CustomTextStyle
                                                                .bodytext,
                                                        hintText: language ==
                                                                "en"
                                                            ? '$gender annual Income'
                                                            : "$gender4 वार्षिक उत्पन्न निवडा",
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
                                                        _stepTwoController
                                                            .filterItems(
                                                                query); // Filter the list in the controller
                                                      },
                                                    ),
                                                  ),
                                                  // List of Items
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
                                                            _stepTwoController
                                                                .filteredItemsList
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final item =
                                                              _stepTwoController
                                                                      .filteredItemsList[
                                                                  index];
                                                          bool isSelected =
                                                              _stepTwoController
                                                                      .selectedAnnualIncome
                                                                      .value
                                                                      ?.id ==
                                                                  item.id;

                                                          return GestureDetector(
                                                            onTap: () {
                                                              // Update the selected value and close the dialog
                                                              _stepTwoController
                                                                  .setSelectedAnnualIncome(
                                                                      item);
                                                              annualIncomeController
                                                                  .text = item
                                                                      .name ??
                                                                  ""; // Update the controller text if needed
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
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  validator: (value) {
                                    if (language == "en") {
                                      if (value == null ||
                                          value.isEmpty ||
                                          value ==
                                              'Select your Annual Income') {
                                        return 'Select $gender annual income';
                                      }
                                    } else {
                                      if (value == null ||
                                          value.isEmpty ||
                                          value ==
                                              'Select your Annual Income') {
                                        return 'कृपया $gender4 वार्षिक उत्पन्न टाका';
                                      }
                                    }

                                    return null;
                                  },
                                );
                              }),
                              _emplyedInController.selectedOption.value.id ==
                                          7 ||
                                      _emplyedInController
                                              .selectedOption.value.id ==
                                          8 ||
                                      _emplyedInController
                                              .selectedOption.value.id ==
                                          9
                                  ? const SizedBox()
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        RichText(
                                            key: _jobLocationKey,
                                            text: TextSpan(children: <TextSpan>[
                                              TextSpan(
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .jobLocation,
                                                  style: CustomTextStyle
                                                      .fieldName),
                                              const TextSpan(
                                                  text: "*",
                                                  style: TextStyle(
                                                      color: Colors.red))
                                            ])),
                                        CustomTextField(
                                          textEditingController:
                                              _stepTwoController.jobLocation,
                                          validator: (value) {
                                            if (language == "en") {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Enter current job address';
                                              }
                                            } else {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'कृपया सध्याचे जॉबचे ठिकाण टाका ';
                                              }
                                            }
                                            return null;
                                          },
                                          HintText: language == "en"
                                              ? "Current job Address"
                                              : "सध्याचे जॉबचे ठिकाण टाका",
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        RichText(
                                          key: _workModeKey,
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .workMode,
                                                  style: CustomTextStyle
                                                      .fieldName),
                                              const TextSpan(
                                                  text: "*",
                                                  style: TextStyle(
                                                      color: Colors.red))
                                            ],
                                          ),
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
                                                      _stepTwoController
                                                          .updateWorkMode(
                                                              FieldModel(
                                                                  id: 1,
                                                                  name:
                                                                      "Fully Remote"));
                                                    },
                                                    child: CustomContainer(
                                                      height: 60,
                                                      title:
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .fullyremote,
                                                      width: 110,
                                                      color: _stepTwoController
                                                                  .selectedWorkMode
                                                                  .value
                                                                  .id ==
                                                              1
                                                          ? AppTheme
                                                              .selectedOptionColor
                                                          : null,
                                                      textColor: _stepTwoController
                                                                  .selectedWorkMode
                                                                  .value
                                                                  .id ==
                                                              1
                                                          ? Colors.white
                                                          : null,
                                                    )),
                                                GestureDetector(
                                                    onTap: () {
                                                      _stepTwoController
                                                          .updateWorkMode(
                                                              FieldModel(
                                                                  id: 2,
                                                                  name:
                                                                      "Hybrid"));
                                                    },
                                                    child: CustomContainer(
                                                      height: 60,
                                                      title:
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .hybridMode,
                                                      width: 112,
                                                      color: _stepTwoController
                                                                  .selectedWorkMode
                                                                  .value
                                                                  .id ==
                                                              2
                                                          ? AppTheme
                                                              .selectedOptionColor
                                                          : null,
                                                      textColor: _stepTwoController
                                                                  .selectedWorkMode
                                                                  .value
                                                                  .id ==
                                                              2
                                                          ? Colors.white
                                                          : null,
                                                    )),
                                                GestureDetector(
                                                  onTap: () {
                                                    _stepTwoController
                                                        .updateWorkMode(
                                                            FieldModel(
                                                                id: 3,
                                                                name: "WFO"));
                                                  },
                                                  child: CustomContainer(
                                                    height: 60,
                                                    title: AppLocalizations.of(
                                                            context)!
                                                        .workFromOffice,
                                                    width: 143,
                                                    color: _stepTwoController
                                                                .selectedWorkMode
                                                                .value
                                                                .id ==
                                                            3
                                                        ? AppTheme
                                                            .selectedOptionColor
                                                        : null,
                                                    textColor: _stepTwoController
                                                                .selectedWorkMode
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
                                            print(
                                                "Work Mode Chekc ${_stepTwoController.selectedWorkModeValidated.value}");
                                            print(
                                                "Work Mode Chekc ${_stepTwoController.isSubmitted.value}");
                                            if (_stepTwoController
                                                        .selectedWorkModeValidated
                                                        .value ==
                                                    false &&
                                                _stepTwoController
                                                        .isSubmitted.value ==
                                                    true) {
                                              print(
                                                  "Work Mode Chekc ${_stepTwoController.selectedWorkModeValidated.value}");
                                              // if (_stepTwoController
                                              //         .selectedWorkMode
                                              //         .value
                                              //         .id ==
                                              //     null) {
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
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 18.0),
                                                          child: Text(
                                                            "Please select $gender work mode",
                                                            style:
                                                                CustomTextStyle
                                                                    .errorText,
                                                          ),
                                                        )
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 18.0),
                                                          child: Text(
                                                            "जॉबची पद्धत निवडा",
                                                            style:
                                                                CustomTextStyle
                                                                    .errorText,
                                                          ),
                                                        )
                                                ],
                                              );
                                            } else {
                                              return const SizedBox();
                                            }
                                            // } else {
                                            //   return const SizedBox();
                                            // }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                              /* : SizedBox(
                                      height: 10,
                                    ), */
                              RichText(
                                key: _presentAddressKey,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .presentAddress,
                                        style: CustomTextStyle.fieldName),
                                    const TextSpan(
                                        text: "*",
                                        style: TextStyle(color: Colors.red))
                                  ],
                                ),
                              ),
                              Obx(
                                () {
                                  final TextEditingController
                                      locationTextController =
                                      TextEditingController();

                                  final selectedLocation = [
                                    _locationController
                                        .presentselectedCity.value.name,
                                    _locationController
                                        .presentselectedState.value.name,
                                    _locationController
                                        .presentselectedCountry.value.name
                                  ]
                                      .where((element) =>
                                          element != null &&
                                          element
                                              .isNotEmpty) // Check for null and empty strings
                                      .join(' , ');

                                  locationTextController.text =
                                      selectedLocation.isEmpty
                                          ? ""
                                          : selectedLocation;
                                  presentlocationText =
                                      locationTextController.text;

                                  return CustomTextField(
                                    textEditingController:
                                        locationTextController,
                                    validator: (value) {
                                      if (language == "en") {
                                        if (value == null || value.isEmpty) {
                                          return 'Enter $gender present address';
                                        } else if (_locationController
                                                .presentselectedState
                                                .value
                                                .name ==
                                            null) {
                                          return 'Please your select $gender present state';
                                        } else if (_locationController
                                                .presentselectedCity
                                                .value
                                                .name ==
                                            null) {
                                          return 'Please your select $gender present district';
                                        }
                                      } else {
                                        if (value == null || value.isEmpty) {
                                          return 'कृपया $gender4 सध्याचे ठिकाण निवडा';
                                        } else if (_locationController
                                                .permanentSelectedState
                                                .value
                                                .name ==
                                            null) {
                                          return '$gender4 सध्याचे राज्य निवडणे अनिवार्य आहे.';
                                        } else if (_locationController
                                                .permanentSelectedCity
                                                .value
                                                .name ==
                                            null) {
                                          return '$gender4 सध्याचा जिल्हा निवडणे अनिवार्य आहे. ';
                                        }
                                      }
                                      return null;
                                    },
                                    readonly: true,
                                    ontap: () {
                                      //    Get.toNamed(AppRouteNames.presentselectCountry);
                                      navigatorKey.currentState!
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            const PresentCountrySelectScreen(),
                                      ));
                                    },
                                    HintText: language == "en"
                                        ? "$gender present address"
                                        : "$gender4 सध्याचे ठिकाण निवडा",
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Obx(
                                () {
                                  return GestureDetector(
                                    onTap: () {
                                      _stepTwoController.updateSameAddress();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                            height: 25,
                                            width: 25,
                                            child: Checkbox(
                                              side: BorderSide(
                                                  color: Colors.grey.shade400),
                                              activeColor: const Color.fromARGB(
                                                255,
                                                80,
                                                93,
                                                126,
                                              ),
                                              value: _stepTwoController
                                                  .isSameAdress.value,
                                              onChanged: (value) {
                                                _stepTwoController
                                                    .updateSameAddress();
                                              },
                                            )),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .sameAddress,
                                          style: CustomTextStyle.textbutton,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Obx(
                                () {
                                  if (_stepTwoController.isSameAdress.value ==
                                      false) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                            key: _permanentAddressKey,
                                            text: TextSpan(children: <TextSpan>[
                                              TextSpan(
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .permanentAddress,
                                                  style: CustomTextStyle
                                                      .fieldName),
                                              const TextSpan(
                                                  text: "*",
                                                  style: TextStyle(
                                                      color: Colors.red))
                                            ])),
                                        Obx(
                                          () {
                                            final TextEditingController
                                                locationTextController =
                                                TextEditingController();

                                            final selectedLocation = [
                                              _locationController
                                                  .permanentSelectedCity
                                                  .value
                                                  .name,
                                              _locationController
                                                  .permanentSelectedState
                                                  .value
                                                  .name,
                                              _locationController
                                                  .permanentSelectedCountry
                                                  .value
                                                  .name,
                                            ]
                                                .where((element) =>
                                                    element != null &&
                                                    element.isNotEmpty)
                                                .join(' , ');

                                            locationTextController.text =
                                                selectedLocation.isEmpty
                                                    ? ""
                                                    : selectedLocation;
                                            presentlocationText =
                                                locationTextController.text;

                                            return CustomTextField(
                                                textEditingController:
                                                    locationTextController,
                                                validator: (value) {
                                                  if (language == "en") {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Enter $gender permanent address';
                                                    } else if (_locationController
                                                            .permanentSelectedState
                                                            .value
                                                            .name ==
                                                        null) {
                                                      return 'Please select your $gender permanent state';
                                                    } else if (_locationController
                                                            .permanentSelectedCity
                                                            .value
                                                            .name ==
                                                        null) {
                                                      return 'Please select your $gender permanent city';
                                                    }
                                                  } else {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'कृपया $gender कायमचे ठिकाण निवडा';
                                                    } else if (_locationController
                                                            .permanentSelectedState
                                                            .value
                                                            .name ==
                                                        null) {
                                                      return '$gender4 कायमचे राज्य निवडणे अनिवार्य आहे.';
                                                    } else if (_locationController
                                                            .permanentSelectedCity
                                                            .value
                                                            .name ==
                                                        null) {
                                                      return '$gender4 कायमचा जिल्हा निवडणे अनिवार्य आहे. ';
                                                    }
                                                  }
                                                  return null;
                                                },
                                                readonly: true,
                                                ontap: () {
                                                  navigatorKey.currentState!
                                                      .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        const PermanentCountrySelectScreen(),
                                                  ));
                                                },
                                                HintText: language == "en"
                                                    ? "$gender permanent address"
                                                    : "$gender2 कायमचे ठिकाण निवडा");
                                          },
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                              RichText(
                                  key: _nativePlaceKey,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .nativePlace,
                                        style: CustomTextStyle.fieldName),
                                    const TextSpan(
                                        text: "*",
                                        style: TextStyle(color: Colors.red))
                                  ])),
                              CustomTextField(
                                  textEditingController:
                                      _stepTwoController.nativePlace,
                                  validator: (value) {
                                    if (language == "en") {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter native place of $gender';
                                      }
                                    } else {
                                      if (value == null || value.isEmpty) {
                                        return 'कृपया $gender4 मूळ गाव टाका';
                                      }
                                    }
                                    return null;
                                  },
                                  HintText: language == "en"
                                      ? "Native place of $gender"
                                      : "$gender4 मूळ गाव"),
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
                                              side: const BorderSide(
                                                  color: Colors.red)),
                                          onPressed: () {
                                            navigatorKey.currentState!
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                              builder: (context) =>
                                                  const UserInfoStepOne(),
                                            ));
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)!.back,
                                            style: CustomTextStyle
                                                .elevatedButton
                                                .copyWith(color: Colors.red),
                                          ))),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        //   sharedPreferences?.setString("PageIndex", "4");

                                        _stepTwoController.isSubmitted.value =
                                            true;
                                        if (_stepTwoController
                                                .isSameAdress.value ==
                                            true) {
                                          _locationController
                                                  .permanentSelectedCity.value =
                                              _locationController
                                                  .presentselectedCity.value;
                                          _locationController
                                                  .permanentSelectedState
                                                  .value =
                                              _locationController
                                                  .presentselectedState.value;
                                          _locationController
                                                  .permanentSelectedCountry
                                                  .value =
                                              _locationController
                                                  .presentselectedCountry.value;
                                        }
                                        // Get.toNamed(AppRouteNames.userInfoStepThree);
                                        bool workmodevalidated =
                                            _stepTwoController.selectedWorkMode
                                                    .value.id !=
                                                null;

                                        if (_formKey.currentState!.validate()) {
                                          print("VaLID");
                                          if (!workmodevalidated) {
                                            print("True");
                                            // Get.snackbar("Error", "Please Fill all required Fields");
                                            if (_stepTwoController
                                                    .selectedWorkMode
                                                    .value
                                                    .id ==
                                                null) {
                                              _scrollToWidget(_workModeKey);
                                            }
                                          } else {
                                            print("API Call");
                                            _stepTwoController.EducationForm(
                                                highestEducation: _educationController
                                                        .selectedEducation
                                                        .value
                                                        .id ??
                                                    0,
                                                otherEducation: _stepTwoController
                                                        .othereducation.text
                                                        .trim()
                                                        .isEmpty
                                                    ? ""
                                                    : _stepTwoController
                                                        .othereducation.text
                                                        .trim(),
                                                specialization: _specializationController
                                                        .selectedSpecialization
                                                        .value
                                                        .id ??
                                                    0,
                                                otherSpecialization:
                                                    _stepTwoController
                                                            .otherspecialization
                                                            .text
                                                            .trim()
                                                            .isEmpty
                                                        ? ""
                                                        : _stepTwoController
                                                            .otherspecialization
                                                            .text
                                                            .trim(),
                                                employedIn: _emplyedInController.selectedOption.value.id ?? 0,
                                                nativePlace: _stepTwoController.nativePlace.text.trim(),
                                                workMode: _stepTwoController.selectedWorkMode.value.id ?? 0,
                                                presentCountry: _locationController.presentselectedCountry.value.id ?? 0,
                                                presentState: _locationController.presentselectedState.value.id ?? 0,
                                                presentCity: _locationController.presentselectedCity.value.id ?? 0,
                                                permanentCountry: _locationController.permanentSelectedCountry.value.id ?? 0,
                                                permanentState: _locationController.permanentSelectedState.value.id ?? 0,
                                                permanentCity: _locationController.permanentSelectedCity.value.id ?? 0,
                                                occupation: _occupationController.selectedOccupation.value.id ?? 0,
                                                otherOccupation: _stepTwoController.otheroccupation.text.trim().isEmpty ? "" : _stepTwoController.otheroccupation.text.trim(),
                                                designation: _stepTwoController.designationController.text.trim(),
                                                companyName: _stepTwoController.companyNameController.text.trim().isEmpty ? "" : _stepTwoController.companyNameController.text.trim(),
                                                annualIncome: _stepTwoController.selectedAnnualIncome.value?.id ?? 0,
                                                currentJobLocation: _stepTwoController.jobLocation.text.trim(),
                                                sameAddress: 1);
                                          }
                                        } else {
                                          // Get.snackbar("Error", "Please Fill all required Fields");
                                          if (_educationController.selectedEducation.value.id ==
                                              null) {
                                            _scrollToWidget(
                                                _highestEducationKey);
                                          } else if (_specializationController
                                                  .selectedSpecialization
                                                  .value
                                                  .id ==
                                              null) {
                                            _scrollToWidget(_specializationKey);
                                          } else if (_emplyedInController
                                                  .selectedOption.value.id ==
                                              null) {
                                            _scrollToWidget(_employedInKey);
                                          } else if (_occupationController
                                                  .selectedOccupation
                                                  .value
                                                  .id ==
                                              null) {
                                            _scrollToWidget(_OccupationKey);
                                          } else if (_stepTwoController
                                              .designationController.text
                                              .trim()
                                              .isEmpty) {
                                            _scrollToWidget(_designationKey);
                                          } else if (_stepTwoController
                                              .companyNameController.text
                                              .trim()
                                              .isEmpty) {
                                            _scrollToWidget(_companyNameKey);
                                          } else if (_stepTwoController
                                                  .selectedAnnualIncome
                                                  .value
                                                  ?.id ==
                                              null) {
                                            _scrollToWidget(_AnnualincomeKey);
                                          } else if (_stepTwoController
                                              .jobLocation.text
                                              .trim()
                                              .isEmpty) {
                                            _scrollToWidget(_jobLocationKey);
                                          } else if (_stepTwoController
                                                  .selectedWorkMode.value.id ==
                                              null) {
                                            _scrollToWidget(_workModeKey);
                                          } else if (_locationController.presentselectedCity.value.id == null) {
                                            _scrollToWidget(_presentAddressKey);
                                          } else if (_locationController.permanentSelectedCity.value.id == null) {
                                            _scrollToWidget(
                                                _permanentAddressKey);
                                          } else if (_stepTwoController.nativePlace.text.trim().isEmpty) {
                                            _scrollToWidget(_nativePlaceKey);
                                          }
                                        }
                                      },
                                      child: Obx(() {
                                        return _stepTwoController
                                                .isLoading.value
                                            ? const CircularProgressIndicator(
                                                color: Color.fromRGBO(
                                                    255,
                                                    255,
                                                    255,
                                                    1), // Set the indicator color if needed
                                              )
                                            : Text(
                                                AppLocalizations.of(context)!
                                                    .save,
                                                style: CustomTextStyle
                                                    .elevatedButton);
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              // ElevatedButton(
                              //     onPressed: () {
                              //       sharedPreferences?.setString(
                              //           "PageIndex", "4");
                              //       navigatorKey.currentState!
                              //           .push(MaterialPageRoute(
                              //         builder: (context) =>
                              //             const UserInfoStepThree(),
                              //       ));
                              //     },
                              //     child: const Text("NEXT PAGE"))
                            ],
                          ),
                        ))
                  ],
                );
              }
            },
          )),
        ),
      ),
    );
  }

  void _showEmployeedInBottomSheet(BuildContext context) {
    final EmplyedInController emplyedInController =
        Get.put(EmplyedInController());
    // Fetch employed in data when modal opens
    emplyedInController.fetchemployeedInFromApi();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height *
                    0.7 // Set your desired max height here
                ),
            child: Container(
              //  height: MediaQuery.of(context).size.height * 0.7,
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(AppLocalizations.of(context)!.selectEmployedIn,
                          style: CustomTextStyle.bodytextboldLarge),
                      const SizedBox(height: 10),

                      // Search bar for filtering
                      TextField(
                        style: CustomTextStyle.bodytext,
                        decoration: InputDecoration(
                          errorMaxLines: 5,
                          errorStyle: CustomTextStyle.errorText,
                          labelStyle: CustomTextStyle.bodytext,
                          hintText:
                              AppLocalizations.of(context)!.searchEmployedIn,
                          contentPadding: const EdgeInsets.all(20),
                          hintStyle: CustomTextStyle.hintText,
                          filled: true,
                          fillColor: Colors.white,
                          errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              gapPadding: 30),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          suffixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        onChanged: (query) {
                          emplyedInController.searchEmployedIn(
                              query); // Call the search function in controller
                        },
                      ),
                      const SizedBox(height: 10),

                      // Use Obx to listen for changes in fetched data and loading state
                      Obx(() {
                        if (emplyedInController.isloading.value) {
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

                        if (emplyedInController
                            .filteredEmployedInList.isEmpty) {
                          return const Center(
                              child: Text(
                                  'No data found')); // Show message if no data
                        }

                        // Display the fetched list of items in ChoiceChips (only one can be selected)
                        return Wrap(
                          spacing: 5,
                          runSpacing: 10,
                          children: emplyedInController.filteredEmployedInList
                              .map((FieldModel item) {
                            final isSelected =
                                emplyedInController.selectedOption.value.id ==
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
                                  emplyedInController.selectEmployeedIn(
                                      item); // Update the selected item
                                  print("This is employed in iD ${item.id}");
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
                                      side:
                                          const BorderSide(color: Colors.red)),
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
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSpecializationBottomSheet(BuildContext context) {
    final SpecializationController specializationController =
        Get.put(SpecializationController());
    // Fetch specialization data when modal opens
    specializationController.fetchSpecializatiomFromApi();

    // TextEditingController to handle search input
    TextEditingController searchController = TextEditingController();

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppLocalizations.of(context)!.selectSpecialization,
                    style: CustomTextStyle.bodytextboldLarge),
                const SizedBox(height: 10),

                // Search field
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    errorMaxLines: 5,
                    errorStyle: CustomTextStyle.errorText,
                    labelStyle: CustomTextStyle.bodytext,
                    hintText:
                        AppLocalizations.of(context)!.searchSpecialization,
                    contentPadding: const EdgeInsets.all(20),
                    hintStyle: CustomTextStyle.hintText,
                    filled: true,
                    fillColor: Colors.white,
                    errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        gapPadding: 30),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  onChanged: (value) {
                    specializationController.filterSpecializations(value);
                  },
                ),
                const SizedBox(height: 10),

                // Use Obx to listen for changes in fetched data and loading state
                Obx(() {
                  if (specializationController.isloading.value) {
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

                  if (specializationController.specializationList.isEmpty) {
                    return const Center(
                        child:
                            Text('No data found')); // Show message if no data
                  }

                  // Use Flexible to allow ListView to take the available space
                  return Flexible(
                    child: ListView.builder(
                      itemCount: specializationController
                          .filteredSpecializations.length,
                      itemBuilder: (context, index) {
                        var education = specializationController
                            .filteredSpecializations[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              education.name.toString(),
                              style: CustomTextStyle.fieldName,
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            // Wrap to display ChoiceChips for each item
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: education.value!.map((e) {
                                return Obx(() {
                                  // Wrap with Obx to reactively update UI
                                  final isSelected = specializationController
                                          .selectedSpecialization.value.id ==
                                      e.id;
                                  return ChoiceChip(
                                    labelPadding: const EdgeInsets.all(4),
                                    checkmarkColor: Colors.white,
                                    disabledColor: AppTheme.lightPrimaryColor,
                                    backgroundColor: AppTheme.lightPrimaryColor,
                                    label: Text(
                                      e.name ?? "", // Display FieldModel name
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
                                        // Update the selected item in controller
                                        specializationController
                                            .selectSpecialization(e);
                                        print("Item is is ${e.id}");
                                      }
                                    },
                                    selectedColor: AppTheme.selectedOptionColor,
                                    labelStyle:
                                        CustomTextStyle.bodytext.copyWith(
                                      fontSize: 14,
                                      color: isSelected
                                          ? Colors.white
                                          : AppTheme.secondryColor,
                                    ),
                                  );
                                });
                              }).toList(),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        );
                      },
                    ),
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

  void _showOccupationBottomSheet(BuildContext context) {
    final OccupationController occupationController =
        Get.put(OccupationController());

    // Fetch occupation data when modal opens
    occupationController.fetchOccupationFromApi();
    TextEditingController searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        // Add a local TextEditingController for the search field
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          width: double.infinity,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppLocalizations.of(context)!.selectOccupation,
                    style: CustomTextStyle.bodytextboldLarge),
                const SizedBox(height: 10),

                // Search Field
                TextField(
                  style: CustomTextStyle.bodytext,
                  controller: searchController,
                  decoration: InputDecoration(
                    errorMaxLines: 5,
                    errorStyle: CustomTextStyle.errorText,
                    labelStyle: CustomTextStyle.bodytext,
                    hintText: AppLocalizations.of(context)!.searchOccupation,
                    contentPadding: const EdgeInsets.all(20),
                    hintStyle: CustomTextStyle.hintText,
                    filled: true,
                    fillColor: Colors.white,
                    errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        gapPadding: 30),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  onChanged: (query) {
                    occupationController.searchOccupation(
                        query); // Call the search function in controller
                  },
                ),
                const SizedBox(height: 10),

                // Use Obx to listen for changes in fetched data and loading state
                Obx(() {
                  if (occupationController.isloading.value) {
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

                  if (occupationController.filteredEducationList.isEmpty) {
                    return const Center(
                        child:
                            Text('No data found')); // Show message if no data
                  }

                  // Use Flexible to allow ListView to take the available space
                  return Flexible(
                    child: ListView.builder(
                      itemCount:
                          occupationController.filteredEducationList.length,
                      itemBuilder: (context, index) {
                        var education =
                            occupationController.filteredEducationList[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(education.name.toString(),
                                style: CustomTextStyle.fieldName),
                            const SizedBox(height: 10),

                            // Wrap to display ChoiceChips for each item
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: education.value!.map((e) {
                                return Obx(() {
                                  // Wrap with Obx to reactively update UI
                                  final isSelected = occupationController
                                          .selectedOccupation.value.id ==
                                      e.id;
                                  return ChoiceChip(
                                    labelPadding: const EdgeInsets.all(4),
                                    checkmarkColor: Colors.white,
                                    disabledColor: AppTheme.lightPrimaryColor,
                                    backgroundColor: AppTheme.lightPrimaryColor,
                                    label: Text(
                                      e.name ?? "", // Display FieldModel name
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
                                        // Update the selected item in controller
                                        occupationController
                                            .selectOccupation(e);
                                      }
                                    },
                                    selectedColor: AppTheme.selectedOptionColor,
                                    labelStyle:
                                        CustomTextStyle.bodytext.copyWith(
                                      fontSize: 14,
                                      color: isSelected
                                          ? Colors.white
                                          : AppTheme.secondryColor,
                                    ),
                                  );
                                });
                              }).toList(),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        );
                      },
                    ),
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

  void _showEducationBottomSheet(BuildContext context) {
    final EducationController educationController =
        Get.put(EducationController());
    // Fetch Ras data when modal opens
    educationController.fetcheducationFromApi();

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppLocalizations.of(context)!.selectHighestEducation,
                    style: CustomTextStyle.bodytextboldLarge),
                const SizedBox(height: 10),

                // Search TextField
                TextField(
                  onChanged: (value) {
                    educationController.searchQuery.value =
                        value; // Update search query
                    educationController
                        .filterEducationList(); // Filter the list
                  },
                  style: CustomTextStyle.bodytext,
                  decoration: InputDecoration(
                    errorMaxLines: 5,
                    errorStyle: CustomTextStyle.errorText,
                    labelStyle: CustomTextStyle.bodytext,
                    hintText: AppLocalizations.of(context)!.searchEducation,
                    contentPadding: const EdgeInsets.all(20),
                    hintStyle: CustomTextStyle.hintText,
                    filled: true,
                    fillColor: Colors.white,
                    errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        gapPadding: 30),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Obx(() {
                  if (educationController.isloading.value) {
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

                  if (educationController.filteredEducationList.isEmpty) {
                    return const Center(child: Text('No data found'));
                  }

                  return Flexible(
                    child: ListView.builder(
                      itemCount:
                          educationController.filteredEducationList.length,
                      itemBuilder: (context, index) {
                        var education =
                            educationController.filteredEducationList[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(education.name.toString(),
                                style: CustomTextStyle.fieldName),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: education.value!.map((e) {
                                return Obx(() {
                                  final isSelected = educationController
                                          .selectedEducation.value.id ==
                                      e.id;
                                  return ChoiceChip(
                                    labelPadding: const EdgeInsets.all(4),
                                    checkmarkColor: Colors.white,
                                    disabledColor: AppTheme.lightPrimaryColor,
                                    backgroundColor: AppTheme.lightPrimaryColor,
                                    label: Text(
                                      e.name ?? "", // Display FieldModel name
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
                                        educationController.selectEducation(e);
                                        educationController.selectEducationint
                                            .value = e.id ?? 0;
                                      }
                                    },
                                    selectedColor: AppTheme.selectedOptionColor,
                                    labelStyle:
                                        CustomTextStyle.bodytext.copyWith(
                                      fontSize: 14,
                                      color: isSelected
                                          ? Colors.white
                                          : AppTheme.secondryColor,
                                    ),
                                  );
                                });
                              }).toList(),
                            ),
                            const SizedBox(height: 20)
                          ],
                        );
                      },
                    ),
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
}
