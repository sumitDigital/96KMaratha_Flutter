// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/ExploreApController/exploreAppController.dart';
import 'package:_96kuliapp/controllers/auth/registerController.dart';
import 'package:_96kuliapp/controllers/formfields/castController.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:_96kuliapp/screens/auth_Screens/loginScreen2.dart';
import 'package:_96kuliapp/screens/onboarding/welcomeScreen.dart';
import 'package:_96kuliapp/screens/userInfoForms/userInfoStepOne.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/customdropdown.dart';
import 'package:_96kuliapp/utils/customtextform.dart';
import 'package:_96kuliapp/utils/selectlanguage.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:shimmer/shimmer.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class CapitalizeFirstLetterFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Capitalizing the first letter of the text
    String newText = newValue.text;

    if (newText.isNotEmpty) {
      newText = newText[0].toUpperCase() + newText.substring(1);
    }

    // Return the updated TextEditingValue
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  static String formattedDate = "";
  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _middleNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();
  // String? language = sharedPreferences?.getString("Language");
  String? language;

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController dateController =
      TextEditingController(text: formattedDate);

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> bloodGroups = ["A+", "B+"];
  final CastController _castController = Get.put(CastController());

  String? validateEmail(String? value) {
    String? language = sharedPreferences?.getString("Language");
    value = value?.trim();
    if (value == null || value.isEmpty) {
      return language == 'en'
          ? "Please Enter Valid email-ID"
          : "कृपया ई-मेल आयडी टाका";
      // AppLocalizations.of(context)!.pleaseEnterValidEmailID;
    }

    // Updated regex for stricter email validation (TLD length between 2 and 4)
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9]+[a-zA-Z0-9._%+-]*@[a-zA-Z0-9.-]+\.[a-zA-Z]{3,4}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return language == 'en'
          ? 'Please enter a valid email ID'
          : "कृपया व्हेरीफाईड ई-मेल आयडी टाका";
    }

    return null; // Email is valid
  }

  final GlobalKey<FormFieldState> _birthTimeKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _firstNameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _middleNameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _lastNameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _emailIDKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _mobileNumberKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _genderKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _sectionKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _profilecreatedForKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _passwordKey = GlobalKey<FormFieldState>();

  final ScrollController _scrollController = ScrollController();

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

  @override
  void initState() {
    super.initState();
    language = sharedPreferences?.getString("Language");
  }

  Locale? locale;

  @override
  Widget build(BuildContext context) {
    final registerationController = Get.put(RegistrationScreenController());
    Get.delete<LocationController>();
    Get.delete<ExploreAppController>();

    print("THIS IS LANGUAGE $language");

    return WillPopScope(
      onWillPop: () async {
        if (navigatorKey.currentState!.canPop()) {
          Get.back();
        } else {
          navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
            builder: (context) => WelcomeScreen(),
          ));
        }
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          controller: _scrollController,
          child: SafeArea(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    color: const Color.fromRGBO(204, 40, 77, 1),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (navigatorKey.currentState!.canPop()) {
                                    Get.back();
                                  } else {
                                    navigatorKey.currentState!
                                        .pushReplacement(MaterialPageRoute(
                                      builder: (context) => WelcomeScreen(),
                                    ));
                                  }
                                },
                                child: SizedBox(
                                  width: 25,
                                  height: 20,
                                  child:
                                      Image.asset("assets/arrowbackwhite.png"),
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        navigatorKey.currentState!
                                            .pushReplacement(MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen2(),
                                        ));
                                      },
                                      child: Container(
                                          height: 25,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                              border: Border.all(
                                                  color: Colors.white)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 2),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .login,
                                              style: const TextStyle(
                                                fontFamily: "WORKSANSLIGHT",
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const SizedBox(
                                      height: 25,
                                      child: VerticalDivider(
                                        width: 2,
                                        thickness: 1,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SelectLanguage(
                                      color: Colors.white,
                                      pading: true,
                                      onChanged: () {
                                        setState(() {
                                          language = sharedPreferences
                                              ?.getString("Language");
                                          /* Sub-Cast */
                                          _castController
                                              .selectedSection.value.name = '';
                                          _castController
                                              .selectedSection.value.id = null;
                                          /* Profile Created */
                                          registerationController
                                              .selectedProfileCreatedFor
                                              .value = '';
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          Center(
                              child: Text(
                            textAlign: TextAlign.center,
                            AppLocalizations.of(context)!.createProfile,
                            style: const TextStyle(
                                fontSize: 25,
                                fontFamily: "WORKSANSMEDIUM",
                                color: Colors.white),
                          )),
                          Center(
                              child: Text(
                            AppLocalizations.of(context)!
                                .yourStoryisWaitingToHappen,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "WORKSANSLIGHT",
                                color: Colors.white),
                          )),
                          const SizedBox(height: 90),
                        ],
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom:
                        -60, // Half of the button size to make it overlap the container
                    left: 0,
                    right: 0,
                    child: Center(
                        child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Color.fromRGBO(204, 40, 77, 1),
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage:
                            AssetImage("assets/registerformheader.png"),
                      ),
                    )),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: RichText(
                            text: TextSpan(children:
                                    // language == "en"
                                    //     ?
                                    <TextSpan>[
                              const TextSpan(
                                text: "()",
                                // style: TextStyle(color: Colors.red),
                              ),
                              const TextSpan(
                                text: "*",
                                style: TextStyle(color: Colors.red),
                              ),
                              const TextSpan(
                                text: ")",
                                // style: TextStyle(color: Colors.red),
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)!
                                    .pleasefillallfieldsmarkedwith,
                                // "Please fill in all required fields marked with ",
                                style: CustomTextStyle.bodytext
                                    .copyWith(fontSize: 12),
                              ),
                            ]
                                // : <TextSpan>[
                                //     TextSpan(
                                //       text: "सर्व ",
                                //       style: CustomTextStyle.bodytext
                                //           .copyWith(fontSize: 12),
                                //     ),
                                //     const TextSpan(
                                //       text: "*",
                                //       style: TextStyle(color: Colors.red),
                                //     ),
                                //     TextSpan(
                                //       text: " मार्क फील्ड्स भरणे आवश्यक आहे",
                                //       style: CustomTextStyle.bodytext
                                //           .copyWith(fontSize: 12),
                                //     ),
                                //   ],
                                ),
                          ),
                        ),

                        // language == "en"
                        //     ? Center(
                        //         child: RichText(
                        //             text: TextSpan(children: <TextSpan>[
                        //           TextSpan(
                        //               text:
                        //                   "Please fill in all required fields marked with ",
                        //               style: CustomTextStyle.bodytext
                        //                   .copyWith(fontSize: 12)),
                        //           const TextSpan(
                        //               text: "*",
                        //               style: TextStyle(color: Colors.red)),
                        //         ])),
                        //       )
                        //     : Center(
                        //         child: RichText(
                        //           text: TextSpan(children: <TextSpan>[
                        //             TextSpan(
                        //                 text: "सर्व ",
                        //                 style: CustomTextStyle.bodytext
                        //                     .copyWith(fontSize: 12)),
                        //             const TextSpan(
                        //                 text: "*",
                        //                 style: TextStyle(color: Colors.red)),
                        //             TextSpan(
                        //                 text: " मार्क फील्ड्स भरणे आवश्यक आहे",
                        //                 style: CustomTextStyle.bodytext
                        //                     .copyWith(fontSize: 12)),
                        //           ]),
                        //         ),
                        //       ),
                        const SizedBox(
                          height: 10,
                        ),
                        RichText(
                            key: _genderKey,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .selectGender,
                                  style: CustomTextStyle.fieldName),
                              const TextSpan(
                                  text: "*",
                                  style: TextStyle(color: Colors.red))
                            ])),
                        Obx(() {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      registerationController
                                          .selectedDate.value = null;
                                      dateController.text = '';
                                      registerationController
                                          .selectedGender.value = "Male";
                                      registerationController
                                          .updateOption("Male");
                                      registerationController.validateAge();
                                    },
                                    child: Container(
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5)),
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Radio<String>(
                                                activeColor:
                                                    const Color.fromARGB(
                                                        255, 80, 93, 126),
                                                value: "Male",
                                                groupValue:
                                                    registerationController
                                                        .selectedGender.value,
                                                onChanged: (String? value) {
                                                  registerationController
                                                      .selectedDate
                                                      .value = null;
                                                  dateController.text = '';
                                                  registerationController
                                                      .selectedGender
                                                      .value = value!;
                                                  if (registerationController
                                                          .selectedDate.value !=
                                                      null) {
                                                    registerationController
                                                        .validateAge();
                                                  } else {
                                                    registerationController
                                                            .genderageError
                                                            .value =
                                                        "Please select your date of birth";
                                                    registerationController
                                                        .gendervalid
                                                        .value = false;
                                                  }
                                                  registerationController
                                                      .updateOption(value);
                                                }),
                                            Text(
                                                AppLocalizations.of(context)!
                                                    .male,
                                                style:
                                                    CustomTextStyle.bodytext),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Image.asset(
                                                height: 30, "assets/male.png")
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      registerationController
                                          .selectedDate.value = null;
                                      dateController.text = '';
                                      registerationController
                                          .selectedGender.value = "Female";
                                      registerationController.validateAge();
                                      registerationController
                                          .updateOption("Female");
                                    },
                                    child: Container(
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5)),
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Radio<String>(
                                                activeColor:
                                                    const Color.fromARGB(
                                                        255, 80, 93, 126),
                                                value: "Female",
                                                groupValue:
                                                    registerationController
                                                        .selectedGender.value,
                                                onChanged: (String? value) {
                                                  registerationController
                                                      .selectedDate
                                                      .value = null;
                                                  dateController.text = '';
                                                  registerationController
                                                      .selectedGender
                                                      .value = value!;
                                                  if (registerationController
                                                          .selectedDate.value !=
                                                      null) {
                                                    registerationController
                                                        .validateAge();
                                                  } else {
                                                    registerationController
                                                            .genderageError
                                                            .value =
                                                        "Please select your date of birth";
                                                    registerationController
                                                        .gendervalid
                                                        .value = false;
                                                  }
                                                  registerationController
                                                      .updateOption(value);
                                                }),
                                            Text(
                                                AppLocalizations.of(context)!
                                                    .female,
                                                style:
                                                    CustomTextStyle.bodytext),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Image.asset(
                                                height: 30, "assets/female.png")
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        Obx(
                          () {
                            if (registerationController.isvalidate.value ==
                                true) {
                              if (registerationController
                                      .selectedGender.value ==
                                  "") {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 18.0),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .pleaseSelectGender,
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
                        const SizedBox(
                          height: 10,
                        ),

                        Obx(
                          () {
                            if (registerationController.selectedGender.value ==
                                "") {
                              return const SizedBox();
                            } else {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    key: _birthTimeKey,
                                    text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                          text: AppLocalizations.of(context)!
                                              .dateOfBirth,
                                          style: CustomTextStyle.fieldName),
                                      const TextSpan(
                                          text: "*",
                                          style: TextStyle(color: Colors.red))
                                    ]),
                                  ),
                                  Obx(() {
                                    // Combine day, month, and year into a single string for the date input
                                    formattedDate = registerationController
                                                .selectedDate.value !=
                                            null
                                        ? DateFormat('dd/MM/yyyy').format(
                                            registerationController
                                                .selectedDate.value!)
                                        : ''; // If no date is selected, leave it as an empty string
                                    // Create a single TextEditingController for the date
                                    return CustomTextField(
                                      HintText: language == "en"
                                          ? (registerationController
                                                      .selectedGender.value ==
                                                  "Male"
                                              ? "Groom's Date of Birth"
                                              : registerationController
                                                          .selectedGender
                                                          .value ==
                                                      "Female"
                                                  ? "Bride's Date of Birth"
                                                  : AppLocalizations.of(
                                                          context)!
                                                      .selectDateOfBirth)
                                          : (registerationController
                                                      .selectedGender.value ==
                                                  "Male"
                                              ? "वराची जन्मतारीख"
                                              : registerationController
                                                          .selectedGender
                                                          .value ==
                                                      "Female"
                                                  ? "वधूची जन्मतारीख"
                                                  : AppLocalizations.of(
                                                          context)!
                                                      .selectDateOfBirth),
                                      textEditingController: dateController,
                                      readonly: true,
                                      ontap: () async {
                                        DateTime currentDate = DateTime.now();

                                        // Set max selectable date based on selected gender
                                        DateTime maxSelectableDate;
                                        if (registerationController
                                                .selectedGender.value ==
                                            "Male") {
                                          maxSelectableDate = DateTime(
                                              currentDate.year - 21,
                                              currentDate.month,
                                              currentDate.day);
                                        } else if (registerationController
                                                .selectedGender.value ==
                                            "Female") {
                                          maxSelectableDate = DateTime(
                                              currentDate.year - 18,
                                              currentDate.month,
                                              currentDate.day);
                                        } else {
                                          // Default in case no gender is selected
                                          maxSelectableDate = currentDate;
                                        }

                                        DateTime? selectedDate =
                                            registerationController
                                                .selectedDate.value;

                                        // Set the initial date to the selected date if available, otherwise use maxSelectableDate
                                        DateTime initialDate =
                                            selectedDate ?? maxSelectableDate;

                                        DateTime? pickedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: initialDate,
                                          firstDate: DateTime(currentDate.year -
                                              70), // 70 years ago as minimum date
                                          lastDate:
                                              maxSelectableDate, // Set max date based on gender selection
                                        );

                                        if (pickedDate != null) {
                                          // Update the selected date in the controller
                                          registerationController
                                              .updateSelectedDate(pickedDate);
                                          dateController.text =
                                              DateFormat('dd/MM/yyyy')
                                                  .format(pickedDate);
                                        }
                                      },
                                    );
                                  }),
                                  Obx(
                                    () {
                                      if (registerationController
                                                  .isvalidate.value ==
                                              true &&
                                          dateController.text.trim().isEmpty) {
                                        if (language == "en") {
                                          if (registerationController
                                                  .selectedGender.value ==
                                              "Male") {
                                            return ErrorTextWidget(
                                                message:
                                                    "Please select date of birth of groom");
                                          } else if (registerationController
                                                  .selectedGender.value ==
                                              "Female") {
                                            return ErrorTextWidget(
                                                message:
                                                    "Please select date of birth of bride");
                                          } else {
                                            return ErrorTextWidget(
                                                message: AppLocalizations.of(
                                                        context)!
                                                    .pleaseEnterFirstName);
                                          }
                                        } else {
                                          if (registerationController
                                                  .selectedGender.value ==
                                              "Male") {
                                            return ErrorTextWidget(
                                                message:
                                                    "कृपया वराची जन्मतारीख टाका ");
                                          } else if (registerationController
                                                  .selectedGender.value ==
                                              "Female") {
                                            return ErrorTextWidget(
                                                message:
                                                    "कृपया वधूची जन्मतारीख टाका ");
                                          } else {
                                            return ErrorTextWidget(
                                                message: AppLocalizations.of(
                                                        context)!
                                                    .pleaseEnterFirstName);
                                          }
                                        }
                                      } else {
                                        return const SizedBox();
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  )
                                ],
                              );
                            }
                          },
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        RichText(
                            key: _firstNameKey,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: AppLocalizations.of(context)!.firstName,
                                  style: CustomTextStyle.fieldName),
                              const TextSpan(
                                  text: "*",
                                  style: TextStyle(color: Colors.red))
                            ])),

                        Obx(
                          () {
                            return CustomTextField(
                              onChange: (p0) {
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z]')),
                                CapitalizeFirstLetterFormatter()
                              ],
                              HintText: language == "en"
                                  ? (registerationController
                                              .selectedGender.value ==
                                          "Male"
                                      ? "Groom's first name"
                                      : registerationController
                                                  .selectedGender.value ==
                                              "Female"
                                          ? "Bride's first name"
                                          : AppLocalizations.of(context)!
                                              .enterfirstName)
                                  : (registerationController
                                              .selectedGender.value ==
                                          "Male"
                                      ? "वराचे पहिले नाव"
                                      : registerationController
                                                  .selectedGender.value ==
                                              "Female"
                                          ? "वधूचे पहिले नाव"
                                          : AppLocalizations.of(context)!
                                              .enterfirstName),
                              textEditingController: _firstNameController,
                            );
                          },
                        ),

                        Obx(
                          () {
                            if (registerationController.isvalidate.value ==
                                    true &&
                                _firstNameController.text.trim().isEmpty) {
                              if (language == "en") {
                                if (registerationController
                                        .selectedGender.value ==
                                    "Male") {
                                  return ErrorTextWidget(
                                      message:
                                          "Enter the first name of the groom");
                                } else if (registerationController
                                        .selectedGender.value ==
                                    "Female") {
                                  return ErrorTextWidget(
                                      message:
                                          "Enter the first name of the bride");
                                } else {
                                  return ErrorTextWidget(
                                      message: AppLocalizations.of(context)!
                                          .pleaseEnterFirstName);
                                }
                              } else {
                                if (registerationController
                                        .selectedGender.value ==
                                    "Male") {
                                  return ErrorTextWidget(
                                      message: "वराचे नाव टाकणे अनिवार्य आहे");
                                } else if (registerationController
                                        .selectedGender.value ==
                                    "Female") {
                                  return ErrorTextWidget(
                                      message: "वधूचे नाव टाकणे अनिवार्य आहे ");
                                } else {
                                  return ErrorTextWidget(
                                      message: AppLocalizations.of(context)!
                                          .pleaseEnterFirstName);
                                }
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
                            key: _middleNameKey,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text:
                                      AppLocalizations.of(context)!.middleName,
                                  style: CustomTextStyle.fieldName),
                              const TextSpan(
                                  text: "*",
                                  style: TextStyle(color: Colors.red))
                            ])),
                        Obx(
                          () {
                            return CustomTextField(
                              onChange: (value) {
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z]')),
                                CapitalizeFirstLetterFormatter()
                              ],
                              HintText: language == "en"
                                  ? (registerationController
                                              .selectedGender.value ==
                                          "Male"
                                      ? "Groom's Middle Name"
                                      : registerationController
                                                  .selectedGender.value ==
                                              "Female"
                                          ? "Bride's Middle Name"
                                          : AppLocalizations.of(context)!
                                              .entermiddleName)
                                  : (registerationController
                                              .selectedGender.value ==
                                          "Male"
                                      ? "वराच्या वडिलांचे  नाव"
                                      : registerationController
                                                  .selectedGender.value ==
                                              "Female"
                                          ? "वधूच्या वडिलांचे  नाव"
                                          : AppLocalizations.of(context)!
                                              .entermiddleName),
                              textEditingController: _middleNameController,
                            );
                          },
                        ),
                        Obx(
                          () {
                            if (registerationController.isvalidate.value ==
                                    true &&
                                _middleNameController.text.trim().isEmpty) {
                              if (language == "en") {
                                if (registerationController
                                        .selectedGender.value ==
                                    "Male") {
                                  return ErrorTextWidget(
                                      message:
                                          "Enter the middle name of the groom");
                                } else if (registerationController
                                        .selectedGender.value ==
                                    "Female") {
                                  return ErrorTextWidget(
                                      message:
                                          "Enter the middle name of the bride");
                                } else {
                                  return ErrorTextWidget(
                                      message: AppLocalizations.of(context)!
                                          .pleaseEnterMiddleName);
                                }
                              } else {
                                if (registerationController
                                        .selectedGender.value ==
                                    "Male") {
                                  return ErrorTextWidget(
                                      message: "वराच्या वडिलांचे नाव टाका");
                                } else if (registerationController
                                        .selectedGender.value ==
                                    "Female") {
                                  return ErrorTextWidget(
                                      message: "वधूच्या वडिलांचे नाव टाका");
                                } else {
                                  return ErrorTextWidget(
                                      message: AppLocalizations.of(context)!
                                          .pleaseEnterMiddleName);
                                }
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
                            key: _lastNameKey,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: AppLocalizations.of(context)!.lastName,
                                  style: CustomTextStyle.fieldName),
                              const TextSpan(
                                  text: "*",
                                  style: TextStyle(color: Colors.red))
                            ])),
                        Obx(
                          () {
                            return CustomTextField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z]')),
                                CapitalizeFirstLetterFormatter()
                              ],
                              HintText: language == "en"
                                  ? (registerationController
                                              .selectedGender.value ==
                                          "Male"
                                      ? "Groom's last Name"
                                      : registerationController
                                                  .selectedGender.value ==
                                              "Female"
                                          ? "Bride's last Name"
                                          : AppLocalizations.of(context)!
                                              .enterlastName)
                                  : (registerationController
                                              .selectedGender.value ==
                                          "Male"
                                      ? "वराचे आडनाव "
                                      : registerationController
                                                  .selectedGender.value ==
                                              "Female"
                                          ? "वधूचे आडनाव "
                                          : AppLocalizations.of(context)!
                                              .enterlastName),
                              textEditingController: _lastNameController,
                            );
                          },
                        ),
                        Obx(
                          () {
                            if (registerationController.isvalidate.value ==
                                    true &&
                                _lastNameController.text.trim().isEmpty) {
                              if (language == "en") {
                                if (registerationController
                                        .selectedGender.value ==
                                    "Male") {
                                  return ErrorTextWidget(
                                      message:
                                          "Enter the last name of the groom");
                                } else if (registerationController
                                        .selectedGender.value ==
                                    "Female") {
                                  return ErrorTextWidget(
                                      message:
                                          "Enter the last name of the bride");
                                } else {
                                  return ErrorTextWidget(
                                      message: AppLocalizations.of(context)!
                                          .pleaseEnterLastName);
                                }
                              } else {
                                if (registerationController
                                        .selectedGender.value ==
                                    "Male") {
                                  return ErrorTextWidget(
                                      message: "वराचे आडनाव टाका");
                                } else if (registerationController
                                        .selectedGender.value ==
                                    "Female") {
                                  return ErrorTextWidget(
                                      message: "वधूचे आडनाव टाका");
                                } else {
                                  return ErrorTextWidget(
                                      message: AppLocalizations.of(context)!
                                          .pleaseEnterLastName);
                                }
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
                            key: _emailIDKey,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: AppLocalizations.of(context)!.emailID,
                                  style: CustomTextStyle.fieldName),
                              const TextSpan(
                                  text: "*",
                                  style: TextStyle(color: Colors.red))
                            ])),
                        CustomTextField(
                          onChange: (p0) {
                            registerationController.registrationErrorModel.value
                                .errors?['email']?.first = "";
                            //  registerationcontroller.registrationErrorModel.value.errors?['email']?.first = "";
                            registerationController.registrationErrorModel
                                .refresh();
                            return null;
                          },
                          validator: validateEmail,
                          HintText: AppLocalizations.of(context)!.enterEmailID,
                          textEditingController: _emailController,
                        ),
                        Obx(() {
                          // Check if the error model and its status are not null
                          final registerErrorModel = registerationController
                              .registrationErrorModel.value;

                          print("IN OBX MESSAGE");
                          print("This is Resp ${registerErrorModel.message}");

                          if (registerErrorModel.status == false) {
                            print("False Status");

                            // Check if errors and email/mobile are not null before accessing them
                            if (registerErrorModel.errors != null &&
                                registerErrorModel.errors!.isNotEmpty) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0, bottom: 8, top: 8),
                                child: Text(
                                  // Display the first error message for 'mobile', or an empty string if null
                                  registerErrorModel.errors?['email']?.first ??
                                      '',
                                  style: CustomTextStyle.errorText,
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          } else {
                            return const SizedBox.shrink();
                          }
                        }),
                        const SizedBox(
                          height: 10,
                        ),
                        RichText(
                            key: _mobileNumberKey,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .mobileNumber,
                                  style: CustomTextStyle.fieldName),
                              const TextSpan(
                                  text: "*",
                                  style: TextStyle(color: Colors.red))
                            ])),

                        const SizedBox(
                          height: 10,
                        ),
                        PhoneFormField(
                          controller:
                              registerationController.phoneNumberController,
                          style: CustomTextStyle.bodytext,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            errorStyle: CustomTextStyle.errorText,
                            contentPadding: const EdgeInsets.all(18),
                            hintText:
                                AppLocalizations.of(context)!.entermobileNumber,
                            labelStyle: CustomTextStyle.bodytext,
                            hintStyle: CustomTextStyle.hintText,
                            errorBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          validator: PhoneValidator.compose([
                            PhoneValidator.required(
                                errorText: AppLocalizations.of(context)!
                                    .pleaseEntervalidPhoneNumber,
                                context),
                            PhoneValidator.validMobile(
                                errorText: AppLocalizations.of(context)!
                                    .pleaseEntervalidPhoneNumber,
                                context)
                          ]),
                          countrySelectorNavigator:
                              const CountrySelectorNavigator.page(),
                          onChanged: (phoneNumber) {
                            // Clear the identifier error messages
                            // _logincontroller.errordata['errorData']?['identifier'] = [];

                            // Trigger an update by re-assigning the observable map
                            // _logincontroller.errordata.refresh();
                            registerationController.registrationErrorModel.value
                                .errors?['mobile']?.first = "";
                            print(
                                "Selected country code: ${registerationController.selectedCountryCode.value}");
                            print('Changed to $phoneNumber');
                            registerationController.registrationErrorModel
                                .refresh();
                          },
                          enabled: true,
                          isCountrySelectionEnabled: true,
                          isCountryButtonPersistent: true,
                          countryButtonStyle: const CountryButtonStyle(
                              showDialCode: true,
                              showIsoCode: false,
                              showFlag: true,
                              flagSize: 16),
                        ),
                        Obx(() {
                          // Check if the error model and its status are not null
                          final registerErrorModel = registerationController
                              .registrationErrorModel.value;

                          print("IN OBX MESSAGE");
                          print("This is Resp ${registerErrorModel.message}");

                          if (registerErrorModel.status == false) {
                            print("False Status");

                            // Check if errors and email/mobile are not null before accessing them
                            if (registerErrorModel.errors != null &&
                                registerErrorModel.errors!.isNotEmpty) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0, bottom: 8, top: 8),
                                child: Text(
                                  // Display the first error message for 'mobile', or an empty string if null
                                  registerErrorModel.errors?['mobile']?.first ??
                                      '',
                                  style: CustomTextStyle.errorText,
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          } else {
                            return const SizedBox.shrink();
                          }
                        }),

                        /*
                  Obx(() {
                    if(registerationController.phvalidation.value == false){
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
                          key: _sectionKey,
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: AppLocalizations.of(context)!.subcaste,
                                  style: CustomTextStyle.fieldName),
                              const TextSpan(
                                  text: "*",
                                  style: TextStyle(color: Colors.red))
                            ],
                          ),
                        ),
                        //    Text("(Only Jain Section)" , style: CustomTextStyle.bodytext.copyWith(fontSize: 12), ),

                        Obx(
                          () {
                            final TextEditingController cast =
                                TextEditingController(
                                    text: _castController
                                        .selectedSection.value.name);

                            return CustomTextField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .pleaseselectsubcaste;
                                }
                                return null; // Return null if the validation passes
                              },
                              textEditingController: cast,
                              readonly: true,
                              ontap: () {
                                _showSectionBottomSheet(context);
                                Get.find<CastController>().refreshSectionList();
                              },
                              HintText:
                                  AppLocalizations.of(context)!.selectsubcaste,
                            );
                          },
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppTheme.lightPrimaryColor,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RichText(
                                  text: TextSpan(children: <TextSpan>[
                                const TextSpan(
                                    text: "*",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red)),
                                const TextSpan(
                                    text: "Note : ",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red)),
                                TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .onlyMarathaCommunity,
                                    style: CustomTextStyle.bodytextSmall),
                              ])),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        RichText(
                            key: _profilecreatedForKey,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .profilecreatedfor,
                                  style: CustomTextStyle.fieldName),
                              const TextSpan(
                                  text: "*",
                                  style: TextStyle(color: Colors.red))
                            ])),
                        Obx(
                          () {
                            TextEditingController profilecreatedfor =
                                TextEditingController(
                                    text: registerationController
                                        .selectedProfileCreatedFor.value);
                            return CustomTextField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .pleaseselectprofilecreatedfor;
                                }
                                return null; // Return null if the validation passes
                              },
                              textEditingController: profilecreatedfor,
                              HintText: AppLocalizations.of(context)!
                                  .selectprofilecreatedfor,
                              readonly: true,
                              ontap: () {
                                _showProfileCreatedFor(context);
                              },
                            );
                          },
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        /*  Obx(() {
                       if(registerationController.brandname.value == ""){
                        return SizedBox();
                       }else{
                        return Text(registerationController.brandname.value , style: CustomTextStyle.bodytext,);
                       }
                        },),*/

                        RichText(
                            key: _passwordKey,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .createPassword,
                                  style: CustomTextStyle.fieldName),
                              const TextSpan(
                                  text: "*",
                                  style: TextStyle(color: Colors.red))
                            ])),
                        Obx(
                          () {
                            return CustomTextField(
                              obscuretext: registerationController.ishide.value,
                              suffixIcon: registerationController
                                          .ishide.value ==
                                      true
                                  ? IconButton(
                                      onPressed: () {
                                        registerationController.showhidetext();
                                      },
                                      icon: Icon(
                                        Icons.visibility_off,
                                        color: Colors.grey.shade500,
                                      ))
                                  : IconButton(
                                      onPressed: () {
                                        registerationController.showhidetext();
                                      },
                                      icon: Icon(
                                        Icons.visibility,
                                        color: AppTheme.selectedOptionColor,
                                      )),
                              HintText:
                                  AppLocalizations.of(context)!.enterPassword,
                              textEditingController: _passwordController,
                              validator: (value) {
                                // Trim the input value
                                String trimmedValue = value?.trim() ?? '';

                                if (trimmedValue.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .pleaseEnterMinimum6Digit;
                                }

                                if (trimmedValue.length < 6) {
                                  return AppLocalizations.of(context)!
                                      .pleaseEnterMinimum6Digit;
                                }

                                return null;
                              },
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        /*   RichText(text: const TextSpan(children: <TextSpan>[
                TextSpan(text: "Confirm Password " , style: CustomTextStyle.fieldName ) , 
                TextSpan( text: "*" , style: TextStyle(color: Colors.red))
               ])), 
                        Obx(() {
              return  CustomTextField(
              obscuretext: registerationController.ishide.value, 
              suffixIcon: registerationController.ishide.value == true ? IconButton(onPressed: (){
                registerationController.showhidetext();
              }, icon:  Icon(Icons.visibility_off , color: Colors.grey.shade500,)) : IconButton(onPressed: (){
              registerationController.showhidetext();
              }, icon:  const Icon(Icons.visibility , color: Colors.blue,)),  
                         
              HintText: "Enter Password again" , textEditingController: _confirmPasswordController, validator: (value) {
              if (value == null || value.isEmpty) {
                        return 'Please confirm your password'; 
                }
                        
                if(value.trim() != _passwordController.text.trim()){
                        return 'Passwords did not match';
                }
                        
                return null;
                         },);
                        },),*/
                        const SizedBox(
                          height: 20,
                        ),
                        /*Obx(() {
              if (registerationController.registerUserMOdel.value.status == false) {
                return Text(
                        registerationController.registerUserMOdel.value.messageShow ?? "",
                        style: CustomTextStyle.errorText,
                );
              } else if (registerationController.registerUserMOdel.value.status == true) {
                return Column(
                        children: [
              Text(AppLocalizations.of(context)!.enterOtp, style: CustomTextStyle.fieldName),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: OTPTextField(
                  length: 4,
                  width: MediaQuery.of(context).size.width,
                  fieldWidth: 40,
                  otpFieldStyle: OtpFieldStyle(
                    enabledBorderColor: Colors.black,
                    disabledBorderColor: Colors.black,
                    borderColor: Colors.black,
                    focusBorderColor: Colors.black,
                  ),
                  style: const TextStyle(fontSize: 17),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.underline,
                  onCompleted: (pin) {},
                ),
              ),
              Text(AppLocalizations.of(context)!.otpsenttomobileNumber, style: CustomTextStyle.fieldName),
                        ],
                );
              } else {
                return SizedBox();
              }
                        }),*/

                        const SizedBox(
                          height: 10,
                        ),
                        /*Center(
              child: Obx(() {
                return ElevatedButton(
                        onPressed: registerationController.isLoadingForRegistration.value
                ? null // Disable button while loading
                : () async {
                    print("Phone number: ${_phoneNumberController.text}");
                    if (_formKey.currentState!.validate()) {
                      print("Password: ${_passwordController.text}, Confirm password: ${_confirmPasswordController.text}");
                      await registerationController.registerUser(
                        firstName: _firstNameController.text.trim(),
                        lastName: _lastNameController.text.trim(),
                        middleName: _middleNameController.text.trim(),
                        phoneNumber: _phoneNumberController.text.trim(),
                        email: _emailController.text.trim(),
                        birthDate: registerationController.birthDate,
                        subCategory: "1",
                        gender: registerationController.selectedGender.value,
                        createdfor: "1",
                        password: _passwordController.text.trim(),
                        confirmPassword: _confirmPasswordController.text.trim(),
                      );
                    }
                  },
                        style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
                        ),
                        child: registerationController.isLoadingForRegistration.value
                ? CircularProgressIndicator(color: Colors.white)
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Text(
                      AppLocalizations.of(context)!.registerNow,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }),
                        )*/
                        InkWell(
                          onTap: () {
                            registerationController.altercheckBox();
                          },
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(
                                  () {
                                    return SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: Checkbox(
                                          side: BorderSide(
                                              color: Colors.grey.shade500),
                                          activeColor: const Color.fromARGB(
                                            255,
                                            80,
                                            93,
                                            126,
                                          ),
                                          value: registerationController
                                              .showCheckBox.value,
                                          onChanged: (value) {
                                            registerationController
                                                .altercheckBox();
                                          },
                                        ));
                                  },
                                ),
                                Flexible(
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    AppLocalizations.of(context)!.privacyPolicy,
                                    // "By clicking on Register Free, you agree to Terms & Conditions and Privacy Policy",
                                    style: CustomTextStyle.textbutton
                                        .copyWith(fontSize: 13),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                        Obx(
                          () {
                            if (registerationController.showCheckBox.value ==
                                    false &&
                                registerationController.isvalidate.value ==
                                    true) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 10),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .pleaseSelectCheckboxToProcedeFurther,
                                  style: CustomTextStyle.errorText,
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: SizedBox(
                            width: 220.41,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                print(
                                    "Enter validty ${registerationController.gendervalid}");
                                registerationController.isvalidate.value = true;
                                registerationController
                                        .selectedCountryCode.value =
                                    registerationController
                                        .phoneNumberController
                                        .initialValue
                                        .countryCode;

                                //   print("Caste: ${_castController.selectedSectionInt.value}");
                                if (registerationController.gendervalid.value ==
                                    false) {
                                  // Get.snackbar("Error", "Select valid age");

                                  if (registerationController
                                          .gendervalid.value ==
                                      false) {
                                    _scrollToWidget(_genderKey);
                                  } else if (_formKey.currentState!
                                      .validate()) {
                                    _scrollToWidget(_birthTimeKey);
                                  } else {
                                    if (dateController.text.trim().isEmpty) {
                                      print("THIS IS Birth");
                                      _scrollToWidget(_birthTimeKey);
                                    } else if (_firstNameController.text
                                        .trim()
                                        .isEmpty) {
                                      print("THIS IS FIRST NAME");
                                      _scrollToWidget(_firstNameKey);
                                    } else if (_middleNameController.text
                                        .trim()
                                        .isEmpty) {
                                      _scrollToWidget(_middleNameKey);
                                    } else if (_lastNameController.text
                                        .trim()
                                        .isEmpty) {
                                      _scrollToWidget(_lastNameKey);
                                    } else if (_emailController.text
                                        .trim()
                                        .isEmpty) {
                                      _scrollToWidget(_emailIDKey);
                                    } else if (registerationController
                                        .phoneNumberController
                                        .value
                                        .nsn
                                        .isEmpty) {
                                      _scrollToWidget(_mobileNumberKey);
                                    } else if (registerationController
                                            .gendervalid.value ==
                                        false) {
                                      _scrollToWidget(_birthTimeKey);
                                    }
                                    // mother tongue
                                    else if (_castController
                                            .selectedSection.value.id ==
                                        null) {
                                      _scrollToWidget(_sectionKey);
                                    } else if (_passwordController.text
                                        .trim()
                                        .isEmpty) {
                                      _scrollToWidget(_passwordKey);
                                    }
                                  }
                                } else if (registerationController
                                        .showCheckBox.value ==
                                    false) {
                                  print("INSIDE CHECK");
                                  //Get.snackbar("Error", "Select check box ");
                                  if (_formKey.currentState!.validate()) {
                                  } else {
                                    if (dateController.text.trim().isEmpty) {
                                      print("THIS IS Birth");
                                      _scrollToWidget(_birthTimeKey);
                                    } else if (_firstNameController.text
                                        .trim()
                                        .isEmpty) {
                                      print("THIS IS FIRST NAME");
                                      _scrollToWidget(_firstNameKey);
                                    } else if (_middleNameController.text
                                        .trim()
                                        .isEmpty) {
                                      _scrollToWidget(_middleNameKey);
                                    } else if (_lastNameController.text
                                        .trim()
                                        .isEmpty) {
                                      _scrollToWidget(_lastNameKey);
                                    } else if (_emailController.text
                                        .trim()
                                        .isEmpty) {
                                      _scrollToWidget(_emailIDKey);
                                    } else if (registerationController
                                        .phoneNumberController
                                        .value
                                        .nsn
                                        .isEmpty) {
                                      _scrollToWidget(_mobileNumberKey);
                                    } else if (registerationController
                                            .gendervalid.value ==
                                        false) {
                                      _scrollToWidget(_genderKey);
                                    }
                                    // mother tongue
                                    else if (_castController
                                            .selectedSection.value.id ==
                                        null) {
                                      _scrollToWidget(_sectionKey);
                                    } else if (_passwordController.text
                                        .trim()
                                        .isEmpty) {
                                      _scrollToWidget(_passwordKey);
                                    } else if (validateEmail(_emailController
                                            .text
                                            .trim()
                                            .toString()) !=
                                        null) {
                                      _scrollToWidget(_emailIDKey);
                                    } else if (registerationController
                                            .registrationErrorModel
                                            .value
                                            .errors !=
                                        null) {
                                      _scrollToWidget(_emailIDKey);
                                    }
                                  }
                                } else {
                                  registerationController.phvalidation.value =
                                      true;

                                  if (_formKey.currentState!.validate()) {
                                    sharedPreferences?.setString("Full Name",
                                        "${_firstNameController.text.trim()} ${_middleNameController.text.trim()} ${_lastNameController.text.trim()}");
                                    print("Valid");
                                    registerationController
                                        .registerUser(
                                      email: _emailController.text.trim(),
                                      firstName:
                                          _firstNameController.text.trim(),
                                      middleName:
                                          _middleNameController.text.trim(),
                                      lastName: _lastNameController.text.trim(),
                                      section: _castController
                                              .selectedSection.value.id ??
                                          1,
                                      mobileCountryCode: registerationController
                                          .selectedCountryCode.value,
                                      mobile: registerationController
                                          .phoneNumberController.value.nsn,
                                      password: _passwordController.text.trim(),
                                      dateOfBirth: registerationController
                                          .selectedDate.value
                                          .toString(),
                                      gender: registerationController
                                          .genderInt.value,
                                      onbehalf: registerationController
                                          .profileCreatedInt.value,
                                    )
                                        .then(
                                      (value) {
                                        if (registerationController
                                                .registrationErrorModel
                                                .value
                                                .errors !=
                                            null) {
                                          _scrollToWidget(_emailIDKey);
                                        } else if (registerationController
                                                .registrationErrorModel
                                                .value
                                                .errors?['mobile']
                                                ?.first !=
                                            null) {
                                          _scrollToWidget(_mobileNumberKey);
                                        }
                                      },
                                    );
                                  } else {
                                    if (dateController.text.trim().isEmpty) {
                                      print("THIS IS Birth");
                                      _scrollToWidget(_birthTimeKey);
                                    } else if (_firstNameController.text
                                        .trim()
                                        .isEmpty) {
                                      _scrollToWidget(_firstNameKey);
                                    } else if (_middleNameController.text
                                        .trim()
                                        .isEmpty) {
                                      _scrollToWidget(_middleNameKey);
                                    } else if (_lastNameController.text
                                        .trim()
                                        .isEmpty) {
                                      _scrollToWidget(_lastNameKey);
                                    } else if (_emailController.text
                                        .trim()
                                        .isEmpty) {
                                      _scrollToWidget(_emailIDKey);
                                    } else if (registerationController
                                        .phoneNumberController
                                        .value
                                        .nsn
                                        .isEmpty) {
                                      _scrollToWidget(_mobileNumberKey);
                                    } else if (registerationController
                                            .gendervalid.value ==
                                        false) {
                                      _scrollToWidget(_genderKey);
                                    }
                                    // mother tongue
                                    else if (_castController
                                            .selectedSection.value.id ==
                                        null) {
                                      _scrollToWidget(_sectionKey);
                                    } else if (_passwordController.text
                                        .trim()
                                        .isEmpty) {
                                      _scrollToWidget(_passwordKey);
                                    } else if (validateEmail(_emailController
                                            .text
                                            .trim()
                                            .toString()) !=
                                        null) {
                                      _scrollToWidget(_emailIDKey);
                                    } else if (registerationController
                                            .registrationErrorModel
                                            .value
                                            .errors !=
                                        null) {
                                      _scrollToWidget(_emailIDKey);
                                    }
                                  }
                                }
                                print("Email: ${_emailController.text.trim()}");
                                print(
                                    "First Name: ${_firstNameController.text.trim()}");
                                print(
                                    "Middle Name: ${_middleNameController.text.trim()}");
                                print(
                                    "Last Name: ${_lastNameController.text.trim()}");
                                print(
                                    "Caste: ${_castController.selectedSectionInt.value}");
                                print(
                                    "Mobile Country Code: ${registerationController.selectedCountryCode.value}");
                                print(
                                    "Mobile: ${_phoneNumberController.text.trim()}");
                                print(
                                    "Password: ${_passwordController.text.trim()}");
                                print(
                                    "Device ID: ${registerationController.deviceId.value}");
                                print(
                                    "Date of Birth: ${registerationController.birthDate.toString()}");
                                print(
                                    "Gender: ${registerationController.genderInt.value}");
                                print(
                                    "On Behalf: ${registerationController.profileCreatedInt.value}");
                              },
                              child: Obx(() {
                                return registerationController.isLoading.value
                                    ? const CircularProgressIndicator(
                                        color: Colors
                                            .white, // Set the indicator color if needed
                                      )
                                    : Text(
                                        AppLocalizations.of(context)!
                                            .registerNow,
                                        style: CustomTextStyle.elevatedButton);
                              }),
                            ),
                          ),
                        ),

                        // ElevatedButton(
                        //     onPressed: () {
                        //       sharedPreferences?.setString("PageIndex", "2");
                        //       navigatorKey.currentState!.push(MaterialPageRoute(
                        //         builder: (context) => UserInfoStepOne(),
                        //       ));
                        //     },
                        //     child: Text("NEXT PAGE"))
                      ],
                    )),
              )
            ],
          )),
        ),
      ),
    );
  }

  dynamic ErrorTextWidget({required String message}) => Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 8),
        child: Text(
          message,
          style: CustomTextStyle.errorText,
        ),
      );
  void _showProfileCreatedFor(BuildContext context) {
    String? language = sharedPreferences?.getString("Language");
    final List<String> profileCreatedFor = language == "en"
        ? ['Self', 'Son', 'Daughter', 'Brother', 'Sister', 'Relative', 'Friend']
        : [
            'स्वतः',
            'मुलगा',
            'मुलगी',
            'भाऊ',
            'बहीण',
            'नातेवाईक',
            'मित्र / मैत्रीण'
          ];

    // Access the registration controller
    final RegistrationScreenController registrationController =
        Get.find<RegistrationScreenController>();

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
                Text(
                    AppLocalizations.of(context)!
                        .selectprofilecreatedfor /* "Select Profile Created For" */,
                    style: CustomTextStyle.bodytextboldLarge),
                const SizedBox(height: 10),
                // Static list of values for profile selection
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: profileCreatedFor.map((String item) {
                    return Obx(() {
                      // Only this part rebuilds when the selectedProfileCreatedFor value changes
                      final isSelected = registrationController
                              .selectedProfileCreatedFor.value ==
                          item;

                      return ChoiceChip(
                        labelPadding: const EdgeInsets.all(4),
                        checkmarkColor: Colors.white,
                        disabledColor: AppTheme.lightPrimaryColor,
                        backgroundColor: AppTheme.lightPrimaryColor,
                        label: Text(
                          item, // Display static value name
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
                            registrationController
                                .updateProfileCreatedFor(item);
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

  void _showSectionBottomSheet(BuildContext context) {
    final CastController castController = Get.put(CastController());
    // Fetch Ras data when modal opens

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
                Text(AppLocalizations.of(context)!.selectsubcaste,
                    style: CustomTextStyle.bodytextboldLarge),
                const SizedBox(height: 10),
                // Use Obx to listen for changes in fetched data and loading state
                Obx(() {
                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: castController.sectionList.map((FieldModel item) {
                      final isSelected =
                          castController.selectedSection.value.id == item.id;
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
                            castController.updateSelectedSection(item: item);
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
        );
      },
    );
  }
}
