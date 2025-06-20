import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/editforms_controllers/editBasicInfoController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';
import 'package:_96kuliapp/screens/auth_Screens/registerScreen.dart';
import 'package:_96kuliapp/screens/profile_screens/edit_profile.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/buttonContainer.dart';
import 'package:_96kuliapp/utils/customtextform.dart';
import 'package:_96kuliapp/utils/formHeader.dart';
import 'package:_96kuliapp/utils/formHeaderEdit.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class EditBasicInfoScreen extends StatefulWidget {
  const EditBasicInfoScreen({super.key});

  @override
  State<EditBasicInfoScreen> createState() => _EditBasicInfoScreenState();
}

class _EditBasicInfoScreenState extends State<EditBasicInfoScreen> {
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String locationText = "";

  TimeOfDay selectedTime = TimeOfDay.now();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final EditBasicInfoController _stepOneController =
      Get.put(EditBasicInfoController());
  bool _hasFormChanged() {
    return _stepOneController.firstName.value !=
            _stepOneController.firstNameController.text.trim() ||
        _stepOneController.middleName.value !=
            _stepOneController.middleNameController.text.trim() ||
        _stepOneController.lastName.value !=
            _stepOneController.lastNameController.text.trim() ||
        _stepOneController.selectedGenderShowInt.value !=
            _stepOneController.genderInt.value ||
        _stepOneController.selectedDateShow.value.toString() !=
            _stepOneController.selectedDate.value.toString();
  }

  @override
  Widget build(BuildContext context) {
    validateEmail(String? value) {
      value = value?.trim();
      if (value == null || value.isEmpty) {
        return 'Please enter a valid Email ID';
      }

      // Updated regex for stricter email validation (TLD length between 2 and 4)
      final emailRegex = RegExp(
        r'^[a-zA-Z0-9]+[a-zA-Z0-9._%+-]*@[a-zA-Z0-9.-]+\.[a-zA-Z]{3,4}$',
      );

      if (!emailRegex.hasMatch(value)) {
        return 'Please enter a valid Email ID';
      }

      return null; // Email is valid
    }

    Future<void> openEmail(String email) async {
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: email,
      );

      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        throw 'Could not launch $emailUri';
      }
    }

    final mybox = Hive.box('myBox');
    String gender = mybox.get("gender") == 2 ? "groom" : "bride";
    return WillPopScope(
      onWillPop: () async {
        if (navigatorKey.currentState!.canPop()) {
          Get.delete<EditBasicInfoController>();

          Get.back();
        } else {
          Get.delete<EditBasicInfoController>();

          navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
            builder: (context) => const EditProfile(),
          ));
        }
        return false;
      },
      child: Scaffold(body: SafeArea(
        child: Obx(
          () {
            String? language = sharedPreferences?.getString("Language");
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
                              GestureDetector(
                                onTap: () {
                                  //  Get.offNamed(AppRouteNames.userInfoStepTwo);
                                  Get.back();
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
                                AppLocalizations.of(context)!.editBasicInfo,
                                style: CustomTextStyle.bodytextLarge,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    //   const StepsFormHeader(title: "Update Your Basic Information", desc: "Finding your Perfect soulmate is just a step away" , image: "assets/formstep1.png", statusPercent: "20%", statusdesc: "Update profile & boost visibility by",),
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
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(
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
                                        Get.back();
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
                                            .editBasicInfo,
                                        style: CustomTextStyle.bodytextLarge),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // const StepsFormHeader(title: "Update Your Basic Information", desc: "Begin your journey to finding your soulmate by sharing your basic details. It's quick and effortless" , image: "assets/formstep1.png", statusPercent: "20%", statusdesc: "Submit this form to boost your profile visibility by",),
                        //   const StepsFormHeader(title: "Update Your Basic Information", desc: "Finding your Perfect soulmate is just a step away" , image: "assets/formstep1.png", statusPercent: "20%", statusdesc: "Update profile & boost visibility by",),
                        //  StepsFormHeaderEdit(title: "Basic Information", desc: "To Update this Information, Please Contact the Admin for Assistance.")

                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.fullName,
                                    // "Full Name",
                                    style: CustomTextStyle.fieldName,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomContainer(
                                    height: 55,
                                    width: 134,

                                    title:
                                        "${_stepOneController.firstName.value} ${_stepOneController.middleName.value} ${_stepOneController.lastName.value}", // Default if no date is selected
                                  ),
                                  Obx(
                                    () {
                                      if (_stepOneController
                                              .documentVerificationStatus
                                              .value ==
                                          1) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, right: 8, bottom: 8),
                                          child: Container(
                                            padding: const EdgeInsets.all(
                                                8), // Add padding for spacing inside the container
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255,
                                                  230,
                                                  232,
                                                  235), // Background color
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      12), // Rounded corners
                                            ),
                                            child: Text(
                                              language == "en"
                                                  ? "Name details cannot be edited as your documents have been successfully verified"
                                                  : "तुमचे डॉक्युमेंट व्हेरिफिकेशन यशस्वीरित्या पार पडले असून आता नावात बदल करता येणार नाही. ",
                                              style: CustomTextStyle.bodytext
                                                  .copyWith(fontSize: 12),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    // "Date of Birth",
                                    AppLocalizations.of(context)!.dateOfBirth,
                                    style: CustomTextStyle.fieldName,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Obx(
                                    () {
                                      print(
                                          "Selected Date ${_stepOneController.selectedDateShow.value}");
                                      // Combine day, month, and year into a single string for the date input
                                      String formattedDate = _stepOneController
                                                  .selectedDateShow.value !=
                                              null
                                          ? DateFormat('dd/MM/yyyy').format(
                                              _stepOneController
                                                  .selectedDateShow.value!)
                                          : ''; // If no date is selected, leave it as an empty string
                                      return CustomContainer(
                                        height: 55,
                                        width: 134,

                                        title:
                                            formattedDate, // Default if no date is selected
                                      );
                                    },
                                  ),

                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.gender,
                                    style: CustomTextStyle.fieldName,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomContainer(
                                    height: 55,
                                    width: 134,

                                    title: _stepOneController.selectedGenderShow
                                        .value, // Default if no date is selected
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  //////
                                  Obx(() {
                                    if (_stepOneController.basicInfoData["data"]
                                            ["isProfileChangeRequest"] ==
                                        1) {
                                      return Container(
                                        padding: const EdgeInsets.all(
                                            16), // Add padding for spacing inside the container
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 230, 232, 235),

                                          borderRadius: BorderRadius.circular(
                                              12), // Rounded corners
                                        ),
                                        child: Text(
                                          language == "en"
                                              ? "Thank you! Your request has been submitted. We'll respond soon"
                                              : "धन्यवाद, तुमची विनंती स्वीकारली आहे. आम्ही लवकरच प्रतिसाद देऊ.",
                                          style: CustomTextStyle.bodytextbold,
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    } else if (_stepOneController
                                                .basicInfoData["data"]
                                            ["isProfileChangeRequest"] ==
                                        2) {
                                      return Container(
                                          padding: const EdgeInsets.all(
                                              16), // Add padding for spacing inside the container
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 230, 232, 235),

                                            borderRadius: BorderRadius.circular(
                                                12), // Rounded corners
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: Text(
                                                  language == "en"
                                                      ? "Your Basic Details Has Been Changed."
                                                      : "विनंतीनुसार माहिती अपडेट झाली आहे",
                                                  style: CustomTextStyle
                                                      .bodytextbold,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Center(
                                                child: Text(
                                                  language == "en"
                                                      ? "Since you have already made changes, further updates are not permitted."
                                                      : "तुम्ही आता पुन्हा माहिती अपडेट करू शकत नाही ",
                                                  style: CustomTextStyle
                                                      .bodytext
                                                      .copyWith(fontSize: 12),
                                                  textAlign: TextAlign.center,
                                                ),
                                              )
                                            ],
                                          ));
                                    } else {
                                      if (_stepOneController
                                              .selectedEditOption.value ==
                                          false) {
                                        return Center(
                                          child: ElevatedButton.icon(
                                              onPressed: () {
                                                _stepOneController
                                                    .updateEditOption();
                                              },
                                              label: Text(
                                                language == "en"
                                                    ? "Edit Profile"
                                                    : "माहिती अपडेट करा",
                                                style: CustomTextStyle
                                                    .elevatedButton,
                                              ),
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                              )),
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    }
                                  }),
                                  //////

                                  Obx(
                                    () {
                                      if (_stepOneController
                                          .selectedEditOption.value) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Divider(
                                                color:
                                                    AppTheme.dividerDarkColor,
                                                endIndent: 10,
                                                indent: 10,
                                                height: 10,
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),

                                              Obx(
                                                () {
                                                  if (_stepOneController
                                                          .documentVerificationStatus
                                                          .value ==
                                                      1) {
                                                    return const SizedBox();
                                                  } else {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 10.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .firstName,
                                                            style:
                                                                CustomTextStyle
                                                                    .fieldName,
                                                          ),
                                                          CustomTextField(
                                                            onChange: (p0) {
                                                              print(
                                                                  " this is first name ${_hasFormChanged()} ${_stepOneController.firstName.value} ${_stepOneController.firstNameController.text.trim()}");
                                                              _stepOneController
                                                                  .hasTextChanged
                                                                  .value = true;
                                                              return null;
                                                            },
                                                            suffixIcon: Icon(
                                                              Icons.edit,
                                                              color: Colors.grey
                                                                  .shade500,
                                                            ),
                                                            textEditingController:
                                                                _stepOneController
                                                                    .firstNameController,
                                                            HintText: AppLocalizations
                                                                    .of(context)!
                                                                .enterfirstName,
                                                            // "Enter First Name",
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter
                                                                  .allow(RegExp(
                                                                      r'[a-zA-Z]')),
                                                              CapitalizeFirstLetterFormatter()
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .middleName,
                                                            style:
                                                                CustomTextStyle
                                                                    .fieldName,
                                                          ),
                                                          CustomTextField(
                                                            onChange: (p0) {
                                                              _stepOneController
                                                                  .hasTextChanged
                                                                  .value = true;
                                                              return null;
                                                            },
                                                            suffixIcon: Icon(
                                                              Icons.edit,
                                                              color: Colors.grey
                                                                  .shade500,
                                                            ),
                                                            textEditingController:
                                                                _stepOneController
                                                                    .middleNameController,
                                                            HintText:
                                                                "Enter Middle Name",
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter
                                                                  .allow(RegExp(
                                                                      r'[a-zA-Z]')),
                                                              CapitalizeFirstLetterFormatter()
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .lastName,
                                                            style:
                                                                CustomTextStyle
                                                                    .fieldName,
                                                          ),
                                                          CustomTextField(
                                                            onChange: (p0) {
                                                              _stepOneController
                                                                  .hasTextChanged
                                                                  .value = true;
                                                              return null;
                                                            },
                                                            suffixIcon: Icon(
                                                              Icons.edit,
                                                              color: Colors.grey
                                                                  .shade500,
                                                            ),
                                                            textEditingController:
                                                                _stepOneController
                                                                    .lastNameController,
                                                            HintText:
                                                                "Enter Last Name",
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter
                                                                  .allow(RegExp(
                                                                      r'[a-zA-Z]')),
                                                              CapitalizeFirstLetterFormatter()
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),

                                              // Gender Name
                                              //
                                              /*  Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    "Name details cannot be edited as your documents have been successfully verified" , style: CustomTextStyle.bodytextboldLarge,),
                ),*/

                                              RichText(
                                                  text: TextSpan(
                                                      children: <TextSpan>[
                                                    TextSpan(
                                                        text:
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .gender,
                                                        style: CustomTextStyle
                                                            .fieldName),
                                                    const TextSpan(
                                                        text: "*",
                                                        style: TextStyle(
                                                            color: Colors.red))
                                                  ])),
                                              Obx(() {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 6.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Expanded(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            _stepOneController
                                                                .selectedGender
                                                                .value = "Male";
                                                            _stepOneController
                                                                .updateOption(
                                                                    "Male");
                                                            _stepOneController
                                                                .validateAge();
                                                          },
                                                          child: Container(
                                                            height: 60,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                      Radius.circular(
                                                                          5)),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 8.0,
                                                                      right:
                                                                          8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Radio<String>(
                                                                      activeColor: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          80,
                                                                          93,
                                                                          126),
                                                                      value:
                                                                          "Male",
                                                                      groupValue: _stepOneController
                                                                          .selectedGender
                                                                          .value,
                                                                      onChanged:
                                                                          (String?
                                                                              value) {
                                                                        _stepOneController
                                                                            .selectedGender
                                                                            .value = value!;
                                                                        if (_stepOneController.selectedDate.value !=
                                                                            null) {
                                                                          _stepOneController
                                                                              .validateAge();
                                                                        } else {
                                                                          _stepOneController
                                                                              .genderageError
                                                                              .value = "Please select your date of birth";
                                                                        }
                                                                        _stepOneController
                                                                            .updateOption(value);
                                                                      }),
                                                                  Text(
                                                                      AppLocalizations.of(
                                                                              context)!
                                                                          .male,
                                                                      style: CustomTextStyle
                                                                          .bodytext),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Image.asset(
                                                                      height:
                                                                          30,
                                                                      "assets/male.png")
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
                                                            _stepOneController
                                                                .selectedGender
                                                                .value = "Female";
                                                            _stepOneController
                                                                .validateAge();
                                                            _stepOneController
                                                                .updateOption(
                                                                    "Female");
                                                          },
                                                          child: Container(
                                                            height: 60,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                      Radius.circular(
                                                                          5)),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 8.0,
                                                                      right:
                                                                          8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Radio<String>(
                                                                      activeColor: const Color.fromARGB(
                                                                          255,
                                                                          80,
                                                                          93,
                                                                          126),
                                                                      value: AppLocalizations.of(
                                                                              context)!
                                                                          .female,
                                                                      groupValue: _stepOneController
                                                                          .selectedGender
                                                                          .value,
                                                                      onChanged:
                                                                          (String?
                                                                              value) {
                                                                        _stepOneController
                                                                            .selectedGender
                                                                            .value = value!;
                                                                        if (_stepOneController.selectedDate.value !=
                                                                            null) {
                                                                          _stepOneController
                                                                              .validateAge();
                                                                        } else {
                                                                          _stepOneController
                                                                              .genderageError
                                                                              .value = "Please select your date of birth";
                                                                        }
                                                                        _stepOneController
                                                                            .updateOption(value);
                                                                      }),
                                                                  Text(
                                                                      AppLocalizations.of(
                                                                              context)!
                                                                          .female,
                                                                      style: CustomTextStyle
                                                                          .bodytext),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Image.asset(
                                                                      height:
                                                                          30,
                                                                      "assets/female.png")
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
                                              // copy
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Obx(
                                                () {
                                                  if (_stepOneController
                                                          .selectedGender
                                                          .value ==
                                                      "") {
                                                    return const SizedBox();
                                                  } else {
                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        RichText(
                                                            text: TextSpan(
                                                                children: <TextSpan>[
                                                              TextSpan(
                                                                  text: AppLocalizations.of(
                                                                          context)!
                                                                      .dateOfBirth,
                                                                  // "Date of Birth ",
                                                                  style: CustomTextStyle
                                                                      .fieldName),
                                                              const TextSpan(
                                                                  text: "*",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red))
                                                            ])),
                                                        Obx(() {
                                                          print(
                                                              "Selected Date ${_stepOneController.selectedDate.value}");
                                                          // Combine day, month, and year into a single string for the date input
                                                          String formattedDate = _stepOneController
                                                                      .selectedDate
                                                                      .value !=
                                                                  null
                                                              ? DateFormat(
                                                                      'dd/MM/yyyy')
                                                                  .format(_stepOneController
                                                                      .selectedDate
                                                                      .value!)
                                                              : ''; // If no date is selected, leave it as an empty string

                                                          // Create a single TextEditingController for the date
                                                          TextEditingController
                                                              dateController =
                                                              TextEditingController(
                                                                  text:
                                                                      formattedDate);

                                                          return CustomTextField(
                                                            suffixIcon: Icon(
                                                              Icons.edit,
                                                              color: Colors.grey
                                                                  .shade500,
                                                            ),
                                                            HintText: AppLocalizations
                                                                    .of(context)!
                                                                .selectDateOfBirth,
                                                            // "Select Date of Birth",
                                                            textEditingController:
                                                                dateController,
                                                            readonly: true,
                                                            ontap: () async {
                                                              DateTime
                                                                  currentDate =
                                                                  DateTime
                                                                      .now();

                                                              // Set max selectable date based on selected gender
                                                              DateTime
                                                                  maxSelectableDate;
                                                              if (_stepOneController
                                                                      .selectedGender
                                                                      .value ==
                                                                  "Male") {
                                                                maxSelectableDate = DateTime(
                                                                    currentDate
                                                                            .year -
                                                                        21,
                                                                    currentDate
                                                                        .month,
                                                                    currentDate
                                                                        .day);
                                                              } else if (_stepOneController
                                                                      .selectedGender
                                                                      .value ==
                                                                  "Female") {
                                                                maxSelectableDate = DateTime(
                                                                    currentDate
                                                                            .year -
                                                                        18,
                                                                    currentDate
                                                                        .month,
                                                                    currentDate
                                                                        .day);
                                                              } else {
                                                                // Default in case no gender is selected
                                                                maxSelectableDate =
                                                                    currentDate;
                                                              }

                                                              DateTime?
                                                                  selectedDate =
                                                                  _stepOneController
                                                                      .selectedDate
                                                                      .value;

                                                              // Set the initial date to the selected date if available, otherwise use maxSelectableDate
                                                              DateTime
                                                                  initialDate =
                                                                  selectedDate ??
                                                                      maxSelectableDate;

                                                              DateTime?
                                                                  pickedDate =
                                                                  await showDatePicker(
                                                                context:
                                                                    context,
                                                                initialDate:
                                                                    initialDate,
                                                                firstDate: DateTime(
                                                                    currentDate
                                                                            .year -
                                                                        70), // 70 years ago as minimum date
                                                                lastDate:
                                                                    maxSelectableDate, // Set max date based on gender selection
                                                              );

                                                              if (pickedDate !=
                                                                  null) {
                                                                // Update the selected date in the controller
                                                                _stepOneController
                                                                    .updateSelectedDate(
                                                                        pickedDate);
                                                                dateController
                                                                    .text = DateFormat(
                                                                        'dd/MM/yyyy')
                                                                    .format(
                                                                        pickedDate);
                                                              }
                                                            },
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please enter a valid date of birth';
                                                              }
                                                              return null;
                                                            },
                                                          );
                                                        }),
                                                        const SizedBox(
                                                            height: 30),
                                                        Obx(() {
                                                          if (_stepOneController
                                                                          .basicInfoData[
                                                                      "data"][
                                                                  "isProfileChangeRequest"] ==
                                                              0) {
                                                            return Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      16), // Add padding for spacing inside the container
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    230,
                                                                    232,
                                                                    235), // Background color
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12), // Rounded corners
                                                              ),
                                                              child: Text(
                                                                language == "en"
                                                                    ? "Double-check the requested information. Once updated, it cannot be reverted"
                                                                    : "माहिती भरून झाल्यानंतर पुनःश्च वाचून खात्री करा. ",
                                                                style: CustomTextStyle
                                                                    .bodytextbold,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            );
                                                          } else {
                                                            return Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      16), // Add padding for spacing inside the container
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    230,
                                                                    232,
                                                                    235),

                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12), // Rounded corners
                                                              ),
                                                              child: Text(
                                                                language == "en"
                                                                    ? "Thank you! Your request has been submitted. We'll respond soon"
                                                                    : "धन्यवाद, तुमची विनंती स्वीकारली आहे. आम्ही लवकरच प्रतिसाद देऊ.",
                                                                style: CustomTextStyle
                                                                    .bodytextbold,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            );
                                                          }
                                                        }),
                                                        const SizedBox(
                                                          height: 50,
                                                        ),
                                                        Obx(
                                                          () {
                                                            if (_stepOneController
                                                                            .basicInfoData[
                                                                        "data"][
                                                                    "isProfileChangeRequest"] ==
                                                                1) {
                                                              return const SizedBox();
                                                            } else {
                                                              if (_hasFormChanged() ||
                                                                  _stepOneController
                                                                      .hasTextChanged
                                                                      .value) {
                                                                return Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Center(
                                                                      child:
                                                                          Obx(
                                                                        () =>
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 18.0),
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                double.infinity,
                                                                            child:
                                                                                ElevatedButton(
                                                                              onPressed: _stepOneController.isLoading.value
                                                                                  ? null
                                                                                  : () {
                                                                                      print("Date of birth sel ${_stepOneController.genderInt.value} and show ${_stepOneController.selectedGenderShowInt}");
                                                                                      _stepOneController.isvalidate.value = true;
                                                                                      _stepOneController.selectedCountryCode.value = _stepOneController.phoneNumberController.initialValue.countryCode;
                                                                                      //   print("Caste: ${_castController.selectedSectionInt.value}");
                                                                                      if (_stepOneController.gendervalid.value == false) {
                                                                                        // Get.snackbar("Error", "Select valid age");
                                                                                        print("Gendervalid false");
                                                                                        if (_formKey.currentState!.validate()) {}
                                                                                      }
                                                                                      if (_formKey.currentState!.validate()) {
                                                                                        //
                                                                                        _stepOneController.BasicForm(
                                                                                          firstnamefromform: _stepOneController.firstNameController.text,
                                                                                          middlenamefromform: _stepOneController.middleNameController.text,
                                                                                          lastnamefromform: _stepOneController.lastNameController.text,
                                                                                          genderfromformfromform: _stepOneController.selectedGenderShowInt.value,
                                                                                          dateOfBirthfromform: _stepOneController.selectedDate.value.toString(),
                                                                                        );
                                                                                      }
                                                                                    },
                                                                              child: _stepOneController.isLoading.value ? const CircularProgressIndicator(color: Colors.white) : Text(language == "en" ? "Submit Request" : "विनंती दाखल करा ", style: CustomTextStyle.elevatedButton),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Obx(
                                                                      () {
                                                                        if (_stepOneController.selectedEditOption.value ==
                                                                            true) {
                                                                          return TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              _stepOneController.updateEditOption();
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              language == "en" ? "Cancel Changes" : "बदल रद्द करा",
                                                                              style: CustomTextStyle.textbutton,
                                                                            ),
                                                                          );
                                                                        } else {
                                                                          return const SizedBox();
                                                                        }
                                                                      },
                                                                    ),
                                                                  ],
                                                                );
                                                              } else {
                                                                return Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    const Center(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 18.0),
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              double.infinity,
                                                                          child:
                                                                              ElevatedButton(
                                                                            onPressed:
                                                                                null,
                                                                            child:
                                                                                Text("Submit Request", style: CustomTextStyle.elevatedButton),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Obx(
                                                                      () {
                                                                        if (_stepOneController.selectedEditOption.value ==
                                                                            true) {
                                                                          return TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              _stepOneController.updateEditOption();
                                                                            },
                                                                            child:
                                                                                const Text(
                                                                              "Cancel Changes",
                                                                              style: CustomTextStyle.textbutton,
                                                                            ),
                                                                          );
                                                                        } else {
                                                                          return const SizedBox();
                                                                        }
                                                                      },
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          50,
                                                                    ),
                                                                    Center(
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            18.0),
                                                                        child:
                                                                            RichText(
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          text:
                                                                              TextSpan(
                                                                            text:
                                                                                "Need assistance? Reach out at ",
                                                                            style:
                                                                                CustomTextStyle.bodytext.copyWith(
                                                                              letterSpacing: 0.5,
                                                                              height: 1.5, // Adjust height for spacing
                                                                            ),
                                                                            children: [
                                                                              TextSpan(
                                                                                text: "info@96kulimarathamarriage.com",
                                                                                style: TextStyle(
                                                                                  color: AppTheme.primaryColor,
                                                                                  fontSize: 14,
                                                                                  fontWeight: FontWeight.w600,
                                                                                  height: 1.5, // Ensure the same line height applies here
                                                                                ),
                                                                                recognizer: TapGestureRecognizer()
                                                                                  ..onTap = () {
                                                                                    openEmail("info@96kulimarathamarriage.com");
                                                                                  },
                                                                              ),
                                                                              TextSpan(
                                                                                text: "\nSupport time: 10 am to 6 pm",
                                                                                style: CustomTextStyle.bodytext.copyWith(
                                                                                  letterSpacing: 0.5,
                                                                                  height: 1.5, // Adjust height for spacing
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              }
                                                            }
                                                          },
                                                        )
                                                      ],
                                                    );
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    },
                                  ),
                                  Obx(
                                    () {
                                      if (_stepOneController
                                              .selectedEditOption.value ==
                                          true) {
                                        return const SizedBox();
                                      } else {
                                        return Column(
                                          children: [
                                            const SizedBox(
                                              height: 280,
                                            ),
                                            Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(
                                                    text: language == "en"
                                                        ? "Need assistance? Reach out at "
                                                        : "मदतीसाठी दिलेल्या ई-मेल वर संपर्क करा",
                                                    style: CustomTextStyle
                                                        .bodytext
                                                        .copyWith(
                                                      letterSpacing: 0.5,
                                                      height:
                                                          1.5, // Adjust height for spacing
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            " info@96kulimarathamarriage.com",
                                                        style: TextStyle(
                                                          color: AppTheme
                                                              .primaryColor,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          height:
                                                              1.5, // Ensure the same line height applies here
                                                        ),
                                                        recognizer:
                                                            TapGestureRecognizer()
                                                              ..onTap = () {
                                                                openEmail(
                                                                    "info@96kulimarathamarriage.com");
                                                              },
                                                      ),
                                                      TextSpan(
                                                        text: language == "en"
                                                            ? "\nSupport time: 10 am to 6 pm"
                                                            : "\n सपोर्ट वेळ : स.१० ते संध्या.६ वाजेपर्यत",
                                                        style: CustomTextStyle
                                                            .bodytext
                                                            .copyWith(
                                                          letterSpacing: 0.5,
                                                          height:
                                                              1.5, // Adjust height for spacing
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  )
                                ],
                              )),
                        ),
                      ],
                    ),
                  )),
                ],
              );
            }
          },
        ),
      )),
    );
  }
}
