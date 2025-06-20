import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hive/hive.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/editforms_controllers/editEducationController.dart';
import 'package:_96kuliapp/controllers/formfields/educationController.dart';
import 'package:_96kuliapp/controllers/formfields/employedInController.dart';
import 'package:_96kuliapp/controllers/formfields/occupationController.dart';
import 'package:_96kuliapp/controllers/formfields/specializationController.dart';

import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/profile_screens/edit_profile.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepThree.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/bottomnavBar.dart';
import 'package:_96kuliapp/utils/buttonContainer.dart';
import 'package:_96kuliapp/utils/customtextform.dart';
import 'package:_96kuliapp/utils/selectlanguage.dart';
import 'package:shimmer/shimmer.dart';

class EditEducationForm extends StatefulWidget {
  const EditEducationForm({super.key});

  @override
  State<EditEducationForm> createState() => _EditEducationFormState();
}

class _EditEducationFormState extends State<EditEducationForm> {
  final
// final StepTwoController _stepTwoController = Get.put(StepTwoController());
      TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController countryPermanent = TextEditingController();
  TextEditingController statePermanent = TextEditingController();
  TextEditingController cityPermanent = TextEditingController();

  final EditEducationController _editEducationController =
      Get.put(EditEducationController());

  final EmplyedInController _emplyedInController =
      Get.put(EmplyedInController());
  final OccupationController _occupationController =
      Get.put(OccupationController());
  final SpecializationController _specializationController =
      Get.put(SpecializationController());
  final EducationController _educationController =
      Get.put(EducationController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String presentlocationText = "";
  late String gender;
  String? gender2;
  String? gender3;
  String? gender4;
  @override
  void initState() {
    super.initState(); // Call the superclass's method
    gender = selectgender();
  }

  final mybox = Hive.box('myBox');
  String? language = sharedPreferences?.getString("Language");
  String selectgender() {
    if (language == "en") {
      if (mybox.get("gender") == 2) {
        return "groom";
      } else {
        return "bride";
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
        gender4 = "वधूचे ";

        return "वधूची";
      }
    }
  }

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
    final mybox = Hive.box('myBox');
    String gender = mybox.get("gender") == 2 ? "groom" : "bride";

    return WillPopScope(
      onWillPop: () async {
        if (navigatorKey.currentState!.canPop()) {
          Get.back(); // Navigates back to the previous screen
        } else {
          navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
            builder: (context) => const EditProfile(),
          ));
        }
        // Execute actions before the back button is pressed

        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(child: Obx(
            () {
              String? language = sharedPreferences?.getString("Language");
              String selectgender() {
                if (language == "en") {
                  if (mybox.get("gender") == 2) {
                    return "groom";
                  } else {
                    return "bride";
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
                    gender4 = "वधूचे ";

                    return "वधूची";
                  }
                }
              }

              gender = selectgender();
              if (_editEducationController.isPageLoading.value) {
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
                                    //   Get.offNamed(AppRouteNames.userInfoStepOne);
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
                                  AppLocalizations.of(context)!
                                      .editEducationInfo,
                                  style: CustomTextStyle.bodytextLarge,
                                ),
                              ],
                            ),
                            //  const SelectLanguage()
                          ],
                        ),
                      ),
                      const CustomTextField(HintText: ""),
                      const SizedBox(
                        height: 10,
                      ),
                      const CustomTextField(HintText: ""),
                      const SizedBox(
                        height: 10,
                      ),
                      const CustomTextField(HintText: ""),
                      const SizedBox(
                        height: 10,
                      ),
                      const CustomTextField(HintText: ""),
                      const SizedBox(
                        height: 10,
                      ),
                      const CustomTextField(HintText: ""),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 60,
                      color: const Color.fromARGB(255, 222, 222, 226)
                          .withOpacity(0.25),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (navigatorKey.currentState!.canPop()) {
                                      Get.back(); // Navigates back to the previous screen
                                    } else {
                                      navigatorKey.currentState!
                                          .pushReplacement(MaterialPageRoute(
                                        builder: (context) =>
                                            const EditProfile(),
                                      ));
                                    }
                                    // Execute actions before the back button is pressed
                                  },
                                  child: SizedBox(
                                    width: 25,
                                    height: 40,
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
                                    AppLocalizations.of(context)!
                                        .editEducationInfo,
                                    style: CustomTextStyle.bodytextLarge),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
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
                                  text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .highestEducation,
                                    style: CustomTextStyle.fieldName),
                                const TextSpan(
                                    text: "*",
                                    style: TextStyle(color: Colors.red))
                              ])),
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
                                            return 'Please select $gender highest education';
                                          }
                                        } else {
                                          if (value == null || value.isEmpty) {
                                            return '$gender4 शिक्षण टाकणे अनिवार्य आहे';
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
                                          ? "Select $gender Education"
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
                                                  text: "Other Education ",
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
                                              _editEducationController
                                                  .othereducation,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter $gender other education ';
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
                                            return 'Please select $gender specialization';
                                          }
                                        } else {
                                          if (value == null || value.isEmpty) {
                                            return '$gender4 स्पेशलायझेशन टाकणे अनिवार्य आहे.';
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
                                          ? "Select $gender Specialization"
                                          : "$gender4 स्पेशलायझेशन");
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
                                              _editEducationController
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
                                  text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .employedIn,
                                    style: CustomTextStyle.fieldName),
                                const TextSpan(
                                    text: "*",
                                    style: TextStyle(color: Colors.red))
                              ])),
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
                                          return 'Please select $gender employed in status';
                                        }
                                      } else {
                                        if (value == null || value.isEmpty) {
                                          return 'कोणत्या क्षेत्रात नोकरीला आहात ते टाकणे अनिवार्य आहे';
                                        }
                                      }

                                      return null;
                                    },
                                    textEditingController: employeedIn,
                                    HintText: language == "en"
                                        ? "Select $gender Employeed In"
                                        : "कोणत्या क्षेत्रात नोकरीला आहात",
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
                                            text: TextSpan(children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .occupation,
                                              style: CustomTextStyle.fieldName),
                                          const TextSpan(
                                              text: "*",
                                              style:
                                                  TextStyle(color: Colors.red))
                                        ])),
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
                                                    return 'Please select $gender occupation';
                                                  }
                                                } else {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return '$gender2 व्यवसाय टाकणे अनिवार्य आहे';
                                                  }
                                                }

                                                return null;
                                              },
                                              textEditingController:
                                                  textEditingController,
                                              readonly: true,
                                              HintText: language == "en"
                                                  ? "Select $gender Occupation"
                                                  : "$gender2 व्यवसाय",
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
                                                        _editEducationController
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
                                            text: TextSpan(children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .designation,
                                              style: CustomTextStyle.fieldName),
                                          const TextSpan(
                                              text: "*",
                                              style:
                                                  TextStyle(color: Colors.red))
                                        ])),
                                        CustomTextField(
                                            textEditingController:
                                                _editEducationController
                                                    .designationController,
                                            validator: (value) {
                                              if (language == "en") {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter $gender designation';
                                                }
                                              } else {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return '$gender4 डेजिग्नेशन टाकणे अनिवार्य आहे';
                                                }
                                              }

                                              return null;
                                            },
                                            HintText: language == "en"
                                                ? "Enter $gender Designation"
                                                : "$gender4 डेजिग्नेशन"),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        RichText(
                                            text: TextSpan(children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .companyName,
                                              style: CustomTextStyle.fieldName),
                                          const TextSpan(
                                              text: "*",
                                              style:
                                                  TextStyle(color: Colors.red))
                                        ])),
                                        CustomTextField(
                                            textEditingController:
                                                _editEducationController
                                                    .companyNameController,
                                            validator: (value) {
                                              if (language == "en") {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter $gender company name';
                                                }
                                              } else {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return '$gender3 कंपनीचे नाव टाकणे अनिवार्य आहे';
                                                }
                                              }

                                              return null;
                                            },
                                            HintText: language == "en"
                                                ? "Enter Company Name"
                                                : "$gender3 कंपनीचे नाव"),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                              RichText(
                                  text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .annualIncome,
                                    style: CustomTextStyle.fieldName),
                                const TextSpan(
                                    text: "*",
                                    style: TextStyle(color: Colors.red))
                              ])),
                              Obx(() {
                                // Controller
                                final TextEditingController
                                    annualIncomeController =
                                    TextEditingController(
                                  text: _editEducationController
                                          .selectedAnnualIncome.value?.name ??
                                      '',
                                );

                                return CustomTextField(
                                  textEditingController: annualIncomeController,
                                  readonly: true, // To prevent manual input
                                  HintText: language == "en"
                                      ? 'Select $gender Annual Income'
                                      : "$gender4 वार्षिक उत्पन्न",
                                  ontap: () {
                                    // Preload the list when opening the dialog
                                    _editEducationController
                                            .filteredItemsList.value =
                                        _editEducationController.itemsList;

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
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                // Search Field
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0, top: 8),
                                                  child: TextField(
                                                    controller:
                                                        searchController,
                                                    decoration: InputDecoration(
                                                      errorMaxLines: 5,
                                                      errorStyle:
                                                          CustomTextStyle
                                                              .errorText,
                                                      labelStyle:
                                                          CustomTextStyle
                                                              .bodytext,
                                                      hintText: AppLocalizations
                                                              .of(context)!
                                                          .searchAnnualIncome,
                                                      // "Search Annual Income",
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      hintStyle: CustomTextStyle
                                                          .hintText,
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      errorBorder:
                                                          const OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.red),
                                                        gapPadding: 30,
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    5)),
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .grey.shade300),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    5)),
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .grey.shade300),
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    5)),
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .grey.shade300),
                                                      ),
                                                      suffixIcon: Icon(
                                                          Icons.search,
                                                          color: Colors
                                                              .grey.shade500),
                                                    ),
                                                    onChanged: (query) {
                                                      _editEducationController
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
                                                            Radius.circular(5)),
                                                    color: Colors.white,
                                                  ),
                                                  height:
                                                      400, // Set a height for the list inside the dialog
                                                  child: Obx(() {
                                                    return ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          _editEducationController
                                                              .filteredItemsList
                                                              .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        final item =
                                                            _editEducationController
                                                                    .filteredItemsList[
                                                                index];
                                                        bool isSelected =
                                                            _editEducationController
                                                                    .selectedAnnualIncome
                                                                    .value
                                                                    ?.id ==
                                                                item.id;

                                                        return GestureDetector(
                                                          onTap: () {
                                                            // Update the selected value and close the dialog
                                                            _editEducationController
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
                                                                : Colors.white,
                                                            child: ListTile(
                                                              title: Text(
                                                                item.name ?? "",
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
                                  validator: (value) {
                                    if (language == "en") {
                                      if (value == null ||
                                          value.isEmpty ||
                                          value ==
                                              'Select your Annual Income') {
                                        return 'Please select $gender annual income';
                                      }
                                    } else {
                                      if (value == null ||
                                          value.isEmpty ||
                                          value ==
                                              'Select your Annual Income') {
                                        return '$gender4 वार्षिक उत्पन्न टाकणे अनिवार्य आहे';
                                      }
                                    }
                                    return null;
                                  },
                                );
                              }),
                              const SizedBox(
                                height: 20,
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
                                            text: TextSpan(children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .jobLocation,
                                              style: CustomTextStyle.fieldName),
                                          const TextSpan(
                                              text: "*",
                                              style:
                                                  TextStyle(color: Colors.red))
                                        ])),
                                        CustomTextField(
                                            textEditingController:
                                                _editEducationController
                                                    .jobLocation,
                                            validator: (value) {
                                              if (language == "en") {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter $gender job location';
                                                }
                                              } else {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'सध्याचा जॉबचा पत्ता टाकणे अनिवार्य आहे';
                                                }
                                              }
                                              return null;
                                            },
                                            HintText: language == "en"
                                                ? "Enter job Location"
                                                : "सध्याचा जॉबचा पत्ता"),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        RichText(
                                            text: TextSpan(children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .workMode,
                                              style: CustomTextStyle.fieldName),
                                          const TextSpan(
                                              text: "*",
                                              style:
                                                  TextStyle(color: Colors.red))
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
                                                      _editEducationController
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
                                                      color: _editEducationController
                                                                  .selectedWorkMode
                                                                  .value
                                                                  .id ==
                                                              1
                                                          ? AppTheme
                                                              .selectedOptionColor
                                                          : null,
                                                      textColor:
                                                          _editEducationController
                                                                      .selectedWorkMode
                                                                      .value
                                                                      .id ==
                                                                  1
                                                              ? Colors.white
                                                              : null,
                                                    )),
                                                GestureDetector(
                                                    onTap: () {
                                                      _editEducationController
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
                                                      color: _editEducationController
                                                                  .selectedWorkMode
                                                                  .value
                                                                  .id ==
                                                              2
                                                          ? AppTheme
                                                              .selectedOptionColor
                                                          : null,
                                                      textColor:
                                                          _editEducationController
                                                                      .selectedWorkMode
                                                                      .value
                                                                      .id ==
                                                                  2
                                                              ? Colors.white
                                                              : null,
                                                    )),
                                                GestureDetector(
                                                    onTap: () {
                                                      _editEducationController
                                                          .updateWorkMode(
                                                              FieldModel(
                                                                  id: 3,
                                                                  name: "WFO"));
                                                    },
                                                    child: CustomContainer(
                                                      height: 60,
                                                      title:
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .workFromOffice,
                                                      width: 143,
                                                      color: _editEducationController
                                                                  .selectedWorkMode
                                                                  .value
                                                                  .id ==
                                                              3
                                                          ? AppTheme
                                                              .selectedOptionColor
                                                          : null,
                                                      textColor:
                                                          _editEducationController
                                                                      .selectedWorkMode
                                                                      .value
                                                                      .id ==
                                                                  3
                                                              ? Colors.white
                                                              : null,
                                                    )),
                                              ],
                                            );
                                          },
                                        ),
                                        Obx(
                                          () {
                                            print("Valid Mang");
                                            if (_editEducationController
                                                        .selectedWorkModeValidated
                                                        .value ==
                                                    false &&
                                                _editEducationController
                                                        .isSubmitted.value ==
                                                    true) {
                                              if (_editEducationController
                                                      .selectedWorkMode
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
                                                        language == "en"
                                                            ? "Please select $gender work mode"
                                                            : "$gender जॉब मोड निवडा ",
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
                                      ],
                                    ),
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
                                            if (navigatorKey.currentState!
                                                .canPop()) {
                                              Get.back(); // Navigates back to the previous screen
                                            } else {
                                              navigatorKey.currentState!
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                builder: (context) =>
                                                    const EditProfile(),
                                              ));
                                            }
                                            // Execute actions before the back button is pressed
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
                                      _editEducationController
                                          .isSubmitted.value = true;
                                      print("Education Form Data:");
                                      print(
                                          "Highest Education ID: ${_educationController.selectedEducation.value.id ?? 0}");
                                      print(
                                          "Other Education: ${_editEducationController.othereducation.text.trim().isEmpty ? "" : _editEducationController.othereducation.text.trim()}");
                                      print(
                                          "Specialization ID: ${_specializationController.selectedSpecialization.value.id ?? 0}");
                                      print(
                                          "Other Specialization: ${_editEducationController.otherspecialization.text.trim().isEmpty ? "" : _editEducationController.otherspecialization.text.trim()}");
                                      print(
                                          "Employed In ID: ${_emplyedInController.selectedOption.value.id ?? 0}");
                                      print(
                                          "Work Mode ID: ${_editEducationController.selectedWorkMode.value.id ?? 0}");
                                      print(
                                          "Occupation ID: ${_occupationController.selectedOccupation.value.id ?? 0}");
                                      print(
                                          "Other Occupation: ${_editEducationController.otheroccupation.text.trim().isEmpty ? "" : _editEducationController.otheroccupation.text.trim()}");
                                      print(
                                          "Designation: ${_editEducationController.designationController.text.trim()}");
                                      print(
                                          "Company Name: ${_editEducationController.companyNameController.text.trim().isEmpty ? "" : _editEducationController.companyNameController.text.trim()}");
                                      print(
                                          "Annual Income ID: ${_editEducationController.selectedAnnualIncome.value?.id ?? 0}");
                                      print(
                                          "Current Job Location: ${_editEducationController.jobLocation.text.trim()}");

                                      // Get.toNamed(AppRouteNames.userInfoStepThree);
                                      bool workmodevalidated =
                                          _editEducationController
                                                  .selectedWorkMode.value.id !=
                                              null;

                                      if (_formKey.currentState!.validate()) {
                                        print("VaLID");
                                        if (!workmodevalidated) {
                                          print("True");
                                          //  Get.snackbar("Error", "Please Fill all required Fields");
                                        } else {
                                          print("API Call valid");
                                          _editEducationController
                                              .EducationForm(
                                            highestEducation:
                                                _educationController
                                                        .selectedEducation
                                                        .value
                                                        .id ??
                                                    0,
                                            otherEducation:
                                                _editEducationController
                                                        .othereducation.text
                                                        .trim()
                                                        .isEmpty
                                                    ? ""
                                                    : _editEducationController
                                                        .othereducation.text
                                                        .trim(),
                                            specialization:
                                                _specializationController
                                                        .selectedSpecialization
                                                        .value
                                                        .id ??
                                                    0,
                                            otherSpecialization:
                                                _editEducationController
                                                        .otherspecialization
                                                        .text
                                                        .trim()
                                                        .isEmpty
                                                    ? ""
                                                    : _editEducationController
                                                        .otherspecialization
                                                        .text
                                                        .trim(),
                                            employedIn: _emplyedInController
                                                    .selectedOption.value.id ??
                                                0,
                                            workMode: _editEducationController
                                                    .selectedWorkMode
                                                    .value
                                                    .id ??
                                                0,
                                            occupation: _occupationController
                                                    .selectedOccupation
                                                    .value
                                                    .id ??
                                                0,
                                            otherOccupation:
                                                _editEducationController
                                                        .otheroccupation.text
                                                        .trim()
                                                        .isEmpty
                                                    ? ""
                                                    : _editEducationController
                                                        .otheroccupation.text
                                                        .trim(),
                                            designation:
                                                _editEducationController
                                                        .designationController
                                                        .text
                                                        .isEmpty
                                                    ? ''
                                                    : _editEducationController
                                                        .designationController
                                                        .text
                                                        .trim(),
                                            companyName:
                                                _editEducationController
                                                        .companyNameController
                                                        .text
                                                        .trim()
                                                        .isEmpty
                                                    ? ''
                                                    : _editEducationController
                                                        .companyNameController
                                                        .text
                                                        .trim(),
                                            annualIncome:
                                                _editEducationController
                                                        .selectedAnnualIncome
                                                        .value
                                                        ?.id ??
                                                    0,
                                            currentJobLocation:
                                                _editEducationController
                                                    .jobLocation.text
                                                    .trim(),
                                          );
                                        }
                                      } else {
                                        // Get.snackbar("Error", "Please Fill all required Fields");
                                      }
                                    },
                                    child: Obx(() {
                                      return _editEducationController
                                              .isLoading.value
                                          ? const CircularProgressIndicator(
                                              color: Colors
                                                  .white, // Set the indicator color if needed
                                            )
                                          : Text(
                                              AppLocalizations.of(context)!
                                                  .save,
                                              style: CustomTextStyle
                                                  .elevatedButton);
                                    }),
                                  )),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              )
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
    String? language = sharedPreferences?.getString("Language");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ConstrainedBox(
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
                    Text(
                        language == "en"
                            ? "You Are Employed In"
                            : "तुमच्या नोकरीचे ठिकाण",
                        style: CustomTextStyle.bodytextboldLarge),
                    const SizedBox(height: 10),

                    // Search bar for filtering
                    TextField(
                      style: CustomTextStyle.bodytext,
                      decoration: InputDecoration(
                        errorMaxLines: 5,
                        errorStyle: CustomTextStyle.errorText,
                        labelStyle: CustomTextStyle.bodytext,
                        hintText: /* "Search " */
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

                      if (emplyedInController.filteredEmployedInList.isEmpty) {
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
                    // "Select Specialization",
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
                    // "Search Specialization",
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
                    // "Select Occupation",
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
                    // "Select Highest Education",
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
