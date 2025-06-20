import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:_96kuliapp/commons/dialogues/AllFields/formfields/familyAssets.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/editforms_controllers/editFamilyDetailsController.dart';
import 'package:_96kuliapp/controllers/formfields/rasController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';
import 'package:_96kuliapp/screens/profile_screens/edit_profile.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/backheader.dart';
import 'package:_96kuliapp/utils/buttonContainer.dart';
import 'package:_96kuliapp/utils/customtextform.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:shimmer/shimmer.dart';

class EditFamilyDetailsScreen extends StatefulWidget {
  const EditFamilyDetailsScreen({super.key});

  @override
  State<EditFamilyDetailsScreen> createState() =>
      _EditFamilyDetailsScreenState();
}

class _EditFamilyDetailsScreenState extends State<EditFamilyDetailsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormFieldState> _motherNameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _parentsContactKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _fatherOccupationKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _motherOccupation =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _noOfBrothersKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _noOfMarriedBrothersKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _noOfSistersKey = GlobalKey<FormFieldState>();

  final GlobalKey<FormFieldState> _noOfMarriedSistersKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _familyAssetsKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _familyTypeKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _livingWithKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _familyStatusKey =
      GlobalKey<FormFieldState>();
  late String gender;
  String? gender2;
  String? gender3;
  String? gender4;
  final mybox = Hive.box('myBox');
  String? language = sharedPreferences?.getString("Language");

  @override
  void initState() {
    super.initState(); // Call the superclass's method
    gender = selectgender();
  }

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

  final _scrollController = ScrollController();

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

  final EditFamilyFetailsController _stepOneController =
      Get.put(EditFamilyFetailsController());
  @override
  Widget build(BuildContext context) {
    //  int selectedIndex = _stepOneController.selectedBloodGroup.value?.id ?? 0;
    // Ensure the index is within the bounds of bloodGroups
    //  ListItems selectedBloodGroup = bloodGroups[selectedIndex];
    //  int selectedIndexHeight = _stepOneController.selectedHeightIndex.value;
    // Ensure the index is within the bounds of heightInFeet
    //  ListItems selectedHeight = heightInFeet[selectedIndexHeight];
    return WillPopScope(
      onWillPop: () async {
        if (navigatorKey.currentState!.canPop()) {
          Get.back();
        } else {
          navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
            builder: (context) => const EditProfile(),
          ));
        }

        return false; // Prevent default back navigation
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
              if (_stepOneController.isPageLoading.value == true) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BackHeader(
                          onTap: () {
                            if (navigatorKey.currentState!.canPop()) {
                              Get.back();
                            } else {
                              navigatorKey.currentState!
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => const EditProfile(),
                              ));
                            }
                          },
                          title:
                              AppLocalizations.of(context)!.editFamilyDetails),
                    ],
                  ),
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BackHeader(
                      title: AppLocalizations.of(context)!.editFamilyDetails,
                      onTap: () {
                        if (navigatorKey.currentState!.canPop()) {
                          Get.back();
                        } else {
                          navigatorKey.currentState!
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => const EditProfile(),
                          ));
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
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
                                AppLocalizations.of(context)!.fatherName,
                                style: CustomTextStyle.fieldName,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomContainer(
                                height: 55,
                                width: 134,

                                title: _stepOneController.fatherName
                                    .value, // Default if no date is selected
                              ),
                              const SizedBox(
                                height: 10,
                              ),

                              RichText(
                                  key: _motherNameKey,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .motherName,
                                        style: CustomTextStyle.fieldName),
                                    const TextSpan(
                                        text: "*",
                                        style: TextStyle(color: Colors.red))
                                  ])),
                              CustomTextField(
                                textEditingController:
                                    _stepOneController.motherNameController,
                                validator: (value) {
                                  if (language == "en") {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter $gender mother name';
                                    }
                                  } else {
                                    if (value == null || value.isEmpty) {
                                      return 'कृपया $gender3 आईचे नाव येथे टाकणे अनिवार्य आहे';
                                    }
                                  }

                                  return null;
                                },
                                HintText: language == "en"
                                    ? "Enter Mother Name"
                                    : "आईचे नाव टाका",
                              ),
                              const SizedBox(
                                height: 10,
                              ),

                              const SizedBox(
                                height: 10,
                              ),
                              RichText(
                                  key: _parentsContactKey,
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
                              /*  IntlPhoneField(
        pickerDialogStyle: PickerDialogStyle(backgroundColor: Colors.white),
        controller: _phoneNumberController,
        dropdownIconPosition: IconPosition.trailing,
        flagsButtonPadding: const EdgeInsets.all(15),
        initialCountryCode: 'IN',
        dropdownTextStyle: CustomTextStyle.hintText,
        dropdownIcon: Icon(
          Icons.arrow_drop_down,
          color: Colors.grey.shade600,
        ),
        keyboardType: TextInputType.phone,
        style: CustomTextStyle.bodytext,
        decoration: InputDecoration(
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          errorStyle: CustomTextStyle.errorText,
          contentPadding: const EdgeInsets.all(18),
          hintText: "Enter Mobile Number",
          labelStyle: CustomTextStyle.bodytext,
          hintStyle: CustomTextStyle.hintText,
          errorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        
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
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value?.number == "" || value?.completeNumber == "") {
            return 'Phone Number cannot be empty';
          } else if (value!.number.length < 10) {
            return 'Please enter a valid mobile number';
          }
          return null;
        },
        onChanged: (phone) {
          _stepOneController.phvalidation.value = true;
          // Capture and store the country code in registrationController
          _stepOneController.selectedCountryCode.value = phone.countryCode;
          print("Selected country code: ${_stepOneController.selectedCountryCode.value}");
        },
        disableLengthCheck: false, 
        
      ),*/

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
                                  contentPadding: const EdgeInsets.all(18),
                                  hintText: "Enter Mobile Number",
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
                                          : "येथे $gender3 पालकांचा मोबाईल नंबर टाका.",
                                      context),
                                  PhoneValidator.validMobile(
                                      errorText: "Enter valid phone number",
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

                                // + all parameters of TextField
                                // + all parameters of FormField
                                // ...
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
                              RichText(
                                  key: _fatherOccupationKey,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .fatherOccupation,
                                        style: CustomTextStyle.fieldName),
                                    const TextSpan(
                                        text: "*",
                                        style: TextStyle(color: Colors.red))
                                  ])),
                              const SizedBox(
                                height: 4,
                              ),
                              Obx(
                                () {
                                  final TextEditingController ras =
                                      TextEditingController(
                                          text: _stepOneController
                                                  .selectedFatherOccupation
                                                  .value
                                                  .name ??
                                              "");
                                  return CustomTextField(
                                    validator: (value) {
                                      if (language == "en") {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select $gender father occupation';
                                        }
                                      } else {
                                        if (value == null || value.isEmpty) {
                                          return 'कृपया $gender3 वडिलांचा व्यवसाय येथे टाकणे अनिवार्य आहे';
                                        }
                                      }

                                      return null;
                                    },
                                    textEditingController: ras,
                                    HintText: language == "en"
                                        ? "Select Father occupation"
                                        : "वडिलांचा व्यवसाय निवडा",
                                    ontap: () {
                                      _showFatherOccupationBottomSheet(context);
                                    },
                                    readonly: true,
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              RichText(
                                key: _motherOccupation,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .motherOccupation,
                                        style: CustomTextStyle.fieldName),
                                    const TextSpan(
                                        text: "*",
                                        style: TextStyle(color: Colors.red))
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Obx(
                                () {
                                  final TextEditingController ras =
                                      TextEditingController(
                                          text: _stepOneController
                                                  .selectedMotherOccupation
                                                  .value
                                                  .name ??
                                              "");
                                  return CustomTextField(
                                    validator: (value) {
                                      if (language == "en") {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select $gender mother occupation';
                                        }
                                      } else {
                                        if (value == null || value.isEmpty) {
                                          return 'कृपया $gender3 आईचा व्यवसाय येथे टाकणे अनिवार्य आहे';
                                        }
                                      }

                                      return null;
                                    },
                                    textEditingController: ras,
                                    HintText: language == "en"
                                        ? "Select Mother occupation"
                                        : "आईचा व्यवसाय निवडा ",
                                    ontap: () {
                                      _showMotherOccupationBottomSheet(context);
                                    },
                                    readonly: true,
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              RichText(
                                  key: _noOfBrothersKey,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .noOfbrothers,
                                        style: CustomTextStyle.fieldName),
                                    const TextSpan(
                                        text: "*",
                                        style: TextStyle(color: Colors.red))
                                  ])),
                              const SizedBox(
                                height: 4,
                              ),
                              Obx(
                                () {
                                  final TextEditingController maxage =
                                      TextEditingController(
                                          text: _stepOneController
                                              .selectedNumberOfBrothers
                                              .value
                                              ?.name);
                                  return CustomTextField(
                                    validator: (value) {
                                      if (language == "en") {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select $gender number of brothers';
                                        }
                                      } else {
                                        if (value == null || value.isEmpty) {
                                          return 'कृपया $gender3 एकूण भावांची संख्या येथे टाकणे अनिवार्य आहे';
                                        }
                                      }

                                      return null;
                                    },
                                    readonly: true,
                                    textEditingController: maxage,
                                    HintText: language == "en"
                                        ? "Select Number of Brothers "
                                        : "एकूण भावांची संख्या निवडा",
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
                                                    // height:
                                                    //     400, // Set a height for the list inside the dialog
                                                    child: Obx(() {
                                                      return ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            _stepOneController
                                                                .baseList
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final item =
                                                              _stepOneController
                                                                      .baseList[
                                                                  index];
                                                          bool isSelected =
                                                              _stepOneController
                                                                      .selectedNumberOfBrothers
                                                                      .value
                                                                      ?.id ==
                                                                  item.id;

                                                          return GestureDetector(
                                                            onTap: () {
                                                              // Update the selected value and close the dialog
                                                              _stepOneController
                                                                  .updateNumberOfBrothers(
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
                              Obx(
                                () {
                                  if (_stepOneController.selectedNumberOfBrothers.value?.id == 2 ||
                                      _stepOneController
                                              .selectedNumberOfBrothers
                                              .value
                                              ?.id ==
                                          3 ||
                                      _stepOneController
                                              .selectedNumberOfBrothers
                                              .value
                                              ?.id ==
                                          4 ||
                                      _stepOneController
                                              .selectedNumberOfBrothers
                                              .value
                                              ?.id ==
                                          5) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: RichText(
                                          key: _noOfMarriedBrothersKey,
                                          text: TextSpan(children: <TextSpan>[
                                            TextSpan(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .noOfMarriedBrothers,
                                                style:
                                                    CustomTextStyle.fieldName),
                                            const TextSpan(
                                                text: "*",
                                                style: TextStyle(
                                                    color: Colors.red))
                                          ])),
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                              Obx(
                                () {
                                  final TextEditingController maxage =
                                      TextEditingController(
                                          text: _stepOneController
                                              .selectedMarriedNumberOfBrothers
                                              .value
                                              ?.name);
                                  if (_stepOneController.selectedNumberOfBrothers.value?.id == 2 ||
                                      _stepOneController
                                              .selectedNumberOfBrothers
                                              .value
                                              ?.id ==
                                          3 ||
                                      _stepOneController
                                              .selectedNumberOfBrothers
                                              .value
                                              ?.id ==
                                          4 ||
                                      _stepOneController
                                              .selectedNumberOfBrothers
                                              .value
                                              ?.id ==
                                          5) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: CustomTextField(
                                        validator: (value) {
                                          if (language == "en") {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please select $gender No. of Married Brothers';
                                            }
                                          } else {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'कृपया विवाहित भावांची संख्या निवडा ';
                                            }
                                          }

                                          return null;
                                        },
                                        readonly: true,
                                        textEditingController: maxage,
                                        HintText: language == "en"
                                            ? "Select No. of Married Brothers "
                                            : "विवाहित भावांची संख्या निवडा ",
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
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5)),
                                                          color: Colors.white,
                                                        ),
                                                        // height:
                                                        //     400, // Set a height for the list inside the dialog
                                                        child: Obx(() {
                                                          return ListView
                                                              .builder(
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                _stepOneController
                                                                    .marriedNumberOfBrothersList
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              final item =
                                                                  _stepOneController
                                                                          .marriedNumberOfBrothersList[
                                                                      index];
                                                              bool isSelected =
                                                                  _stepOneController
                                                                          .selectedMarriedNumberOfBrothers
                                                                          .value
                                                                          ?.id ==
                                                                      item.id;

                                                              return GestureDetector(
                                                                onTap: () {
                                                                  // Update the selected value and close the dialog
                                                                  _stepOneController
                                                                      .updateMarriedNumberOfBrothers(
                                                                          item); // Update the selected item and index in the controller
                                                                  // Update the selected height and index in the controller

                                                                  // Update the controller text based on selection

                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    Container(
                                                                  color: isSelected
                                                                      ? AppTheme
                                                                          .selectedOptionColor
                                                                      : Colors
                                                                          .white,
                                                                  child:
                                                                      ListTile(
                                                                    title: Text(
                                                                      item.name ??
                                                                          "",
                                                                      style: CustomTextStyle
                                                                          .bodytext
                                                                          .copyWith(
                                                                        color: isSelected
                                                                            ? Colors.white
                                                                            : AppTheme.textColor,
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
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              RichText(
                                  key: _noOfSistersKey,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .noOfSisters,
                                        style: CustomTextStyle.fieldName),
                                    const TextSpan(
                                        text: "*",
                                        style: TextStyle(color: Colors.red))
                                  ])),
                              const SizedBox(
                                height: 4,
                              ),
                              Obx(
                                () {
                                  final TextEditingController maxage =
                                      TextEditingController(
                                          text: _stepOneController
                                              .selectedNumberOfSisters
                                              .value
                                              ?.name);
                                  return CustomTextField(
                                    validator: (value) {
                                      if (language == "en") {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select $gender number of sisters';
                                        }
                                      } else {
                                        if (value == null || value.isEmpty) {
                                          return 'कृपया $gender3 एकूण बहिणींची संख्या येथे टाकणे अनिवार्य आहे';
                                        }
                                      }

                                      return null;
                                    },
                                    readonly: true,
                                    textEditingController: maxage,
                                    HintText: language == "en"
                                        ? "Select Number of Sisters "
                                        : "एकूण बहिणींची संख्या निवडा",
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
                                                    // height:
                                                    //     400, // Set a height for the list inside the dialog
                                                    child: Obx(() {
                                                      return ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            _stepOneController
                                                                .baseList
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final item =
                                                              _stepOneController
                                                                      .baseList[
                                                                  index];
                                                          bool isSelected =
                                                              _stepOneController
                                                                      .selectedNumberOfSisters
                                                                      .value
                                                                      ?.id ==
                                                                  item.id;

                                                          return GestureDetector(
                                                            onTap: () {
                                                              // Update the selected value and close the dialog
                                                              _stepOneController
                                                                  .updateNumberOfSisters(
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

                              Obx(
                                () {
                                  if (_stepOneController.selectedNumberOfSisters.value?.id == 2 ||
                                      _stepOneController.selectedNumberOfSisters
                                              .value?.id ==
                                          3 ||
                                      _stepOneController.selectedNumberOfSisters
                                              .value?.id ==
                                          4 ||
                                      _stepOneController.selectedNumberOfSisters
                                              .value?.id ==
                                          5) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: RichText(
                                          key: _noOfMarriedSistersKey,
                                          text: TextSpan(children: <TextSpan>[
                                            TextSpan(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .noOfMarriedSisters,
                                                style:
                                                    CustomTextStyle.fieldName),
                                            const TextSpan(
                                                text: "*",
                                                style: TextStyle(
                                                    color: Colors.red))
                                          ])),
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                              Obx(
                                () {
                                  final TextEditingController maxage =
                                      TextEditingController(
                                          text: _stepOneController
                                              .selectedMarriedNumberOfSisters
                                              .value
                                              ?.name);
                                  if (_stepOneController.selectedNumberOfSisters.value?.id == 2 ||
                                      _stepOneController.selectedNumberOfSisters
                                              .value?.id ==
                                          3 ||
                                      _stepOneController.selectedNumberOfSisters
                                              .value?.id ==
                                          4 ||
                                      _stepOneController.selectedNumberOfSisters
                                              .value?.id ==
                                          5) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: CustomTextField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return language == "en"
                                                ? 'Please select $gender No. of Married Sisters'
                                                : "कृपया विवाहित बहिणींची संख्या निवडा ";
                                          }
                                          return null;
                                        },
                                        readonly: true,
                                        textEditingController: maxage,
                                        HintText: language == "en"
                                            ? "Select No. of Married Sisters "
                                            : "विवाहित बहिणींची संख्या निवडा ",
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
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5)),
                                                          color: Colors.white,
                                                        ),
                                                        height:
                                                            400, // Set a height for the list inside the dialog
                                                        child: Obx(() {
                                                          return ListView
                                                              .builder(
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                _stepOneController
                                                                    .marriedNumberOfSisterList
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              final item =
                                                                  _stepOneController
                                                                          .marriedNumberOfSisterList[
                                                                      index];
                                                              bool isSelected =
                                                                  _stepOneController
                                                                          .selectedMarriedNumberOfSisters
                                                                          .value
                                                                          ?.id ==
                                                                      item.id;

                                                              return GestureDetector(
                                                                onTap: () {
                                                                  // Update the selected value and close the dialog
                                                                  _stepOneController
                                                                      .updateMarriedNumberOfSisters(
                                                                          item); // Update the selected item and index in the controller
                                                                  // Update the selected height and index in the controller

                                                                  // Update the controller text based on selection

                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    Container(
                                                                  color: isSelected
                                                                      ? AppTheme
                                                                          .selectedOptionColor
                                                                      : Colors
                                                                          .white,
                                                                  child:
                                                                      ListTile(
                                                                    title: Text(
                                                                      item.name ??
                                                                          "",
                                                                      style: CustomTextStyle
                                                                          .bodytext
                                                                          .copyWith(
                                                                        color: isSelected
                                                                            ? Colors.white
                                                                            : AppTheme.textColor,
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
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              RichText(
                                  key: _familyAssetsKey,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .familyAssets,
                                        style: CustomTextStyle.fieldName),
                                    const TextSpan(
                                        text: "*",
                                        style: TextStyle(color: Colors.red))
                                  ])),

                              Obx(() {
                                // Check if selectedSectionStringList is empty
                                if (_stepOneController
                                    .selectedFamilyAssetsList.isEmpty) {
                                  // If no sections selected, show the CustomTextField to select sections
                                  return CustomTextField(
                                    validator: (value) {
                                      if (language == "en") {
                                        if (value == null || value.isEmpty) {
                                          return "Please select $gender family assets";
                                        }
                                      } else {
                                        if (value == null || value.isEmpty) {
                                          return "$gender कौटुंबिक संपत्तीची स्थिती येथे टाका.";
                                        }
                                      }

                                      return null;
                                    },
                                    HintText: language == "en"
                                        ? "Select Family Assets"
                                        : "कौटुंबिक मालमत्ता निवडा",
                                    ontap: () {
                                      _showFamilyAssetsBottomSheet(context);
                                    },
                                    readonly: true,
                                  );
                                } else {
                                  // If sections are selected, show the container with chips
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        _showFamilyAssetsBottomSheet(context);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey.shade300,
                                              width: 1),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: ConstrainedBox(
                                            constraints: const BoxConstraints(
                                                minWidth: double.infinity),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Wrap(
                                                  direction: Axis.horizontal,

                                                  spacing:
                                                      10, // Spacing between chips horizontally
                                                  runSpacing:
                                                      10, // Spacing between rows vertically
                                                  children: [
                                                    ...List.generate(
                                                      _stepOneController
                                                                  .selectedFamilyAssetsList
                                                                  .length >
                                                              4
                                                          ? 4
                                                          : _stepOneController
                                                              .selectedFamilyAssetsList
                                                              .length,
                                                      (index) {
                                                        final item =
                                                            _stepOneController
                                                                    .selectedFamilyAssetsList[
                                                                index];
                                                        return Chip(
                                                          deleteIcon:
                                                              const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            child: Icon(
                                                                Icons.close,
                                                                size: 12),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2),
                                                          labelPadding:
                                                              const EdgeInsets
                                                                  .all(4),
                                                          backgroundColor: AppTheme
                                                              .lightPrimaryColor,
                                                          side:
                                                              const BorderSide(
                                                            style: BorderStyle
                                                                .none,
                                                            color: Colors.blue,
                                                          ),
                                                          label: Text(
                                                            item.name ?? "",
                                                            style:
                                                                CustomTextStyle
                                                                    .bodytext
                                                                    .copyWith(
                                                                        fontSize:
                                                                            11),
                                                          ),
                                                          onDeleted: () {
                                                            _stepOneController
                                                                .selectedFamilyAssetsList
                                                                .remove(item);
                                                          },
                                                        );
                                                      },
                                                    ),
                                                    // Add button as a Chip
                                                    Obx(
                                                      () {
                                                        if (_stepOneController
                                                                .selectedFamilyAssetsList
                                                                .length ==
                                                            _stepOneController
                                                                .familyAssetsList
                                                                .length) {
                                                          return const SizedBox();
                                                        } else {
                                                          return Obx(
                                                            () {
                                                              if (_stepOneController
                                                                      .selectedFamilyAssetsList
                                                                      .length <=
                                                                  4) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    // Navigate to view all countries
                                                                    _showFamilyAssetsBottomSheet(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            2,
                                                                        top:
                                                                            12.0),
                                                                    child: Text(
                                                                      language ==
                                                                              "en"
                                                                          ? "+ Add (+)"
                                                                          : "अधिक (+)",
                                                                      style: CustomTextStyle
                                                                          .bodytext
                                                                          .copyWith(
                                                                        color: AppTheme
                                                                            .selectedOptionColor,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              } else {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    // Navigate to view all countries
                                                                    _showFamilyAssetsBottomSheet(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            2,
                                                                        top:
                                                                            12.0),
                                                                    child: Text(
                                                                      "(+${_stepOneController.selectedFamilyAssetsList.length - 4}) More",
                                                                      style: CustomTextStyle
                                                                          .bodytext
                                                                          .copyWith(
                                                                        color: AppTheme
                                                                            .selectedOptionColor,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                          );
                                                        }
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }),

                              const SizedBox(
                                height: 10,
                              ),
                              RichText(
                                  key: _familyTypeKey,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .familyType,
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
                                          _stepOneController.updateFamilyType(
                                              FieldModel(
                                                  id: 1, name: "Joint Family"));
                                        },
                                        child: CustomContainer(
                                          height: 60,
                                          width: 89,
                                          color: _stepOneController
                                                      .SelectedFamilyType
                                                      .value
                                                      .id ==
                                                  1
                                              ? AppTheme.selectedOptionColor
                                              : null,
                                          title: AppLocalizations.of(context)!
                                              .jointFamily,
                                          textColor: _stepOneController
                                                      .SelectedFamilyType
                                                      .value
                                                      .id ==
                                                  1
                                              ? Colors.white
                                              : null,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _stepOneController.updateFamilyType(
                                              FieldModel(
                                                  id: 2,
                                                  name: "Nuclear Family"));
                                        },
                                        child: CustomContainer(
                                          color: _stepOneController
                                                      .SelectedFamilyType
                                                      .value
                                                      .id ==
                                                  2
                                              ? AppTheme.selectedOptionColor
                                              : null,
                                          height: 60,
                                          width: 89,
                                          title: AppLocalizations.of(context)!
                                              .neuclearFamily,
                                          textColor: _stepOneController
                                                      .SelectedFamilyType
                                                      .value
                                                      .id ==
                                                  2
                                              ? Colors.white
                                              : null,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _stepOneController.updateFamilyType(
                                              FieldModel(
                                                  id: 3, name: "Living Alone"));
                                        },
                                        child: CustomContainer(
                                          color: _stepOneController
                                                      .SelectedFamilyType
                                                      .value
                                                      .id ==
                                                  3
                                              ? AppTheme.selectedOptionColor
                                              : null,
                                          height: 60,
                                          width: 125,
                                          title: AppLocalizations.of(context)!
                                              .livingAlone,
                                          textColor: _stepOneController
                                                      .SelectedFamilyType
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
                                  if (_stepOneController
                                              .selectedFamilyTypeValidated
                                              .value ==
                                          false &&
                                      _stepOneController.isSubmitted.value ==
                                          true) {
                                    if (_stepOneController
                                            .SelectedFamilyType.value.id ==
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
                                              language == "en"
                                                  ? "Please select $gender family type"
                                                  : "कृपया $gender कुटुंब-प्रकार निवडा",
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
                              RichText(
                                  key: _livingWithKey,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .livingWithParents,
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
                                          _stepOneController.updateLivingStatus(
                                              FieldModel(
                                                  id: 1,
                                                  name: "Living with Parents"));
                                        },
                                        child: CustomContainer(
                                          height: 60,
                                          width: 89,
                                          color: _stepOneController
                                                      .selectedLivingParentType
                                                      .value
                                                      .id ==
                                                  1
                                              ? AppTheme.selectedOptionColor
                                              : null,
                                          title: language == "en"
                                              ? AppLocalizations.of(context)!
                                                  .livingWithParents
                                              : "पालकांसोबत राहतात",
                                          //  AppLocalizations.of(context)!
                                          //     .livingWithParents,
                                          textColor: _stepOneController
                                                      .selectedLivingParentType
                                                      .value
                                                      .id ==
                                                  1
                                              ? Colors.white
                                              : null,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _stepOneController.updateLivingStatus(
                                              FieldModel(
                                                  id: 2,
                                                  name:
                                                      "Not Living with Parents"));
                                        },
                                        child: CustomContainer(
                                          color: _stepOneController
                                                      .selectedLivingParentType
                                                      .value
                                                      .id ==
                                                  2
                                              ? AppTheme.selectedOptionColor
                                              : null,
                                          height: 60,
                                          width: 89,
                                          title: AppLocalizations.of(context)!
                                              .notLivingWithParents,
                                          textColor: _stepOneController
                                                      .selectedLivingParentType
                                                      .value
                                                      .id ==
                                                  2
                                              ? Colors.white
                                              : null,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _stepOneController.updateLivingStatus(
                                              FieldModel(
                                                  id: 3,
                                                  name:
                                                      "Occasionally Living with Parents"));
                                        },
                                        child: CustomContainer(
                                          color: _stepOneController
                                                      .selectedLivingParentType
                                                      .value
                                                      .id ==
                                                  3
                                              ? AppTheme.selectedOptionColor
                                              : null,
                                          height: 60,
                                          width: 125,
                                          title: AppLocalizations.of(context)!
                                              .occasionallyLivingwithParents,
                                          textColor: _stepOneController
                                                      .selectedLivingParentType
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
                                  if (_stepOneController
                                              .selectedLivingParentsValidated
                                              .value ==
                                          false &&
                                      _stepOneController.isSubmitted.value ==
                                          true) {
                                    if (_stepOneController
                                            .selectedLivingParentType
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
                                            padding: const EdgeInsets.only(
                                                left: 18.0),
                                            child: Text(
                                              language == "en"
                                                  ? "Please select $gender Living with parents status"
                                                  : "कृपया $gender पालकांसोबत राहण्याबाबतची माहिती निवडा ",
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
                              // family class
                              const SizedBox(
                                height: 10,
                              ),
                              RichText(
                                  key: _familyStatusKey,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .familyStatus,
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
                                          _stepOneController.updateFamilyClass(
                                              FieldModel(
                                                  id: 1, name: "Middle Class"));
                                        },
                                        child: CustomContainer(
                                          height: 60,
                                          width: 89,
                                          color: _stepOneController
                                                      .selectedFamilyClass
                                                      .value
                                                      .id ==
                                                  1
                                              ? AppTheme.selectedOptionColor
                                              : null,
                                          title: AppLocalizations.of(context)!
                                              .middleClass,
                                          textColor: _stepOneController
                                                      .selectedFamilyClass
                                                      .value
                                                      .id ==
                                                  1
                                              ? Colors.white
                                              : null,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _stepOneController.updateFamilyClass(
                                              FieldModel(
                                                  id: 2,
                                                  name: "Lower Middle Class"));
                                        },
                                        child: CustomContainer(
                                          color: _stepOneController
                                                      .selectedFamilyClass
                                                      .value
                                                      .id ==
                                                  2
                                              ? AppTheme.selectedOptionColor
                                              : null,
                                          height: 60,
                                          width: 89,
                                          title: AppLocalizations.of(context)!
                                              .lowerMiddleClass,
                                          textColor: _stepOneController
                                                      .selectedFamilyClass
                                                      .value
                                                      .id ==
                                                  2
                                              ? Colors.white
                                              : null,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _stepOneController.updateFamilyClass(
                                              FieldModel(
                                                  id: 3,
                                                  name: "Upper Middle Class"));
                                        },
                                        child: CustomContainer(
                                          color: _stepOneController
                                                      .selectedFamilyClass
                                                      .value
                                                      .id ==
                                                  3
                                              ? AppTheme.selectedOptionColor
                                              : null,
                                          height: 60,
                                          width: 125,
                                          title: AppLocalizations.of(context)!
                                              .upperMiddleClass,
                                          textColor: _stepOneController
                                                      .selectedFamilyClass
                                                      .value
                                                      .id ==
                                                  3
                                              ? Colors.white
                                              : null,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _stepOneController.updateFamilyClass(
                                              FieldModel(
                                                  id: 4,
                                                  name: "Working Class"));
                                        },
                                        child: CustomContainer(
                                          color: _stepOneController
                                                      .selectedFamilyClass
                                                      .value
                                                      .id ==
                                                  4
                                              ? AppTheme.selectedOptionColor
                                              : null,
                                          height: 60,
                                          width: 125,
                                          title: AppLocalizations.of(context)!
                                              .workingClass,
                                          textColor: _stepOneController
                                                      .selectedFamilyClass
                                                      .value
                                                      .id ==
                                                  4
                                              ? Colors.white
                                              : null,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _stepOneController.updateFamilyClass(
                                              FieldModel(
                                                  id: 5,
                                                  name:
                                                      "Middle Class with Financial Struggles"));
                                        },
                                        child: CustomContainer(
                                          color: _stepOneController
                                                      .selectedFamilyClass
                                                      .value
                                                      .id ==
                                                  5
                                              ? AppTheme.selectedOptionColor
                                              : null,
                                          height: 60,
                                          width: 125,
                                          title: AppLocalizations.of(context)!
                                              .middleClassWithFinancialStruggles,
                                          textColor: _stepOneController
                                                      .selectedFamilyClass
                                                      .value
                                                      .id ==
                                                  5
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
                                  if (_stepOneController
                                              .selectedLivingParentsValidated
                                              .value ==
                                          false &&
                                      _stepOneController.isSubmitted.value ==
                                          true) {
                                    if (_stepOneController
                                            .selectedLivingParentType
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
                                            padding: const EdgeInsets.only(
                                                left: 18.0),
                                            child: Text(
                                              language == "en"
                                                  ? "Please select $gender family status"
                                                  : "कृपया $gender कौटुंबिक माहिती निवडा ",
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
                                height: 50,
                              ),
                              Row(
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
                                              Get.back();
                                            } else {
                                              navigatorKey.currentState!
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                builder: (context) =>
                                                    const EditProfile(),
                                              ));
                                            }
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)!.back,
                                            style: CustomTextStyle
                                                .elevatedButton
                                                .copyWith(color: Colors.red),
                                          ))),
                                  const SizedBox(
                                      width: 20), // Spacing between buttons
                                  Expanded(
                                    child: SizedBox(
                                      height: 50,
                                      width: 170,
                                      child: Obx(
                                        () => ElevatedButton(
                                          onPressed: _stepOneController
                                                  .isLoading.value
                                              ? null
                                              : () {
                                                  // Validation for each field
                                                  //   bool parentsContactValid = _phoneNumberController.value.toString() == "" ? false : true;
                                                  bool contactsOptionValid =
                                                      _stepOneController
                                                              .parentContactSelected
                                                              .value
                                                              .id !=
                                                          null;
                                                  bool isFamilyTypeValid =
                                                      _stepOneController
                                                              .SelectedFamilyType
                                                              .value
                                                              .id !=
                                                          null;
                                                  bool
                                                      isLivingWithParentsValid =
                                                      _stepOneController
                                                              .selectedLivingParentType
                                                              .value
                                                              .id !=
                                                          null;
                                                  bool isfamilyStatus =
                                                      _stepOneController
                                                              .selectedFamilyClass
                                                              .value
                                                              .id !=
                                                          null;

                                                  // Children validation based on marital status
                                                  //    print("NUMBER OF MARRIED SIS ${}")

                                                  // Update validation statuses in the controller
                                                  _stepOneController
                                                      .selectedFamilyTypeValidated
                                                      .value = isFamilyTypeValid;
                                                  //    _stepOneController.phvalidation.value = parentsContactValid;
                                                  _stepOneController
                                                          .selectedLivingParentsValidated
                                                          .value =
                                                      isLivingWithParentsValid;
                                                  _stepOneController
                                                      .selectedFamilyClassValidated
                                                      .value = isfamilyStatus;

                                                  _stepOneController
                                                          .parentContactValidated
                                                          .value =
                                                      contactsOptionValid;
                                                  // Set submitted state
                                                  _stepOneController
                                                      .isSubmitted.value = true;

                                                  // Validate form
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    // Check if all validations are passed

                                                    if (!isFamilyTypeValid) {
                                                      _scrollToWidget(
                                                          _familyTypeKey);
                                                    } else if (!isLivingWithParentsValid) {
                                                      _scrollToWidget(
                                                          _livingWithKey);
                                                    } else if (!isfamilyStatus) {
                                                      _scrollToWidget(
                                                          _familyStatusKey);
                                                    } else {
                                                      // Start loading state
                                                      _stepOneController
                                                          .isLoading
                                                          .value = true;

                                                      // API call
                                                      // API call
                                                      _stepOneController
                                                          .BasicForm(
                                                        fatherName:
                                                            _stepOneController
                                                                .fatherName
                                                                .value,
                                                        motherName:
                                                            _stepOneController
                                                                .motherNameController
                                                                .text
                                                                .trim(),
                                                        contactNumberVisiblity:
                                                            _stepOneController
                                                                    .parentContactSelected
                                                                    .value
                                                                    .id ??
                                                                1,
                                                        parentsContactNumber:
                                                            _stepOneController
                                                                .phoneNumberController
                                                                .value
                                                                .nsn
                                                                .toString(),
                                                        fatherOccupation:
                                                            _stepOneController
                                                                    .selectedFatherOccupation
                                                                    .value
                                                                    .id ??
                                                                0,
                                                        motherOccupation:
                                                            _stepOneController
                                                                    .selectedMotherOccupation
                                                                    .value
                                                                    .id ??
                                                                0,
                                                        NoOfBrothers:
                                                            _stepOneController
                                                                    .selectedNumberOfBrothers
                                                                    .value
                                                                    ?.id ??
                                                                0,
                                                        NoOfMarriedBrothers:
                                                            _stepOneController
                                                                    .selectedMarriedNumberOfBrothers
                                                                    .value
                                                                    ?.id ??
                                                                1,
                                                        NoOfSisters:
                                                            _stepOneController
                                                                    .selectedNumberOfSisters
                                                                    .value
                                                                    ?.id ??
                                                                0,
                                                        NoOfMarriedSisters:
                                                            _stepOneController
                                                                    .selectedMarriedNumberOfSisters
                                                                    .value
                                                                    ?.id ??
                                                                1,
                                                        familyType:
                                                            _stepOneController
                                                                    .SelectedFamilyType
                                                                    .value
                                                                    .id ??
                                                                0,
                                                        familyStatus:
                                                            _stepOneController
                                                                    .selectedFamilyClass
                                                                    .value
                                                                    .id ??
                                                                0,
                                                        livingWithParents:
                                                            _stepOneController
                                                                    .selectedLivingParentType
                                                                    .value
                                                                    .id ??
                                                                0,
                                                        mobileCountryCode: "91",
                                                        familyAssets: _stepOneController
                                                            .selectedFamilyAssetsList
                                                            .where((field) =>
                                                                field.id !=
                                                                null) // Filter out null ids
                                                            .map((field) =>
                                                                field.id!)
                                                            .toList(),
                                                      ).then((result) {
                                                        // Reset loading state
                                                        _stepOneController
                                                            .isLoading
                                                            .value = false;
                                                        // Handle successful result (optional)
                                                      }).catchError((error) {
                                                        // Handle error and reset loading state
                                                        _stepOneController
                                                            .isLoading
                                                            .value = false;
                                                        print("Error: $error");
                                                      });
                                                    }
                                                  } else {
                                                    print("errrrrr");

                                                    // Show error if form validation fails
                                                    //   Get.snackbar("Error", "Please Fill all required Fields");
                                                    if (_stepOneController.motherNameController.text
                                                        .trim()
                                                        .isEmpty) {
                                                      _scrollToWidget(
                                                          _motherNameKey);
                                                    } else if (_stepOneController
                                                        .phoneNumberController
                                                        .value
                                                        .nsn
                                                        .toString()
                                                        .isEmpty) {
                                                      _scrollToWidget(
                                                          _parentsContactKey);
                                                    } else if (_stepOneController
                                                            .selectedFatherOccupation
                                                            .value
                                                            .id ==
                                                        null) {
                                                      _scrollToWidget(
                                                          _fatherOccupationKey);
                                                    } else if (_stepOneController
                                                            .selectedMotherOccupation
                                                            .value
                                                            .id ==
                                                        null) {
                                                      _scrollToWidget(
                                                          _motherOccupation);
                                                    } else if (_stepOneController
                                                            .selectedNumberOfBrothers
                                                            .value
                                                            ?.id ==
                                                        null) {
                                                      _scrollToWidget(
                                                          _noOfBrothersKey);
                                                    } else if (_stepOneController
                                                            .selectedMarriedNumberOfBrothers
                                                            .value
                                                            ?.id ==
                                                        null) {
                                                      _scrollToWidget(
                                                          _noOfMarriedBrothersKey);
                                                    } else if (_stepOneController
                                                            .selectedNumberOfSisters
                                                            .value
                                                            ?.id ==
                                                        null) {
                                                      _scrollToWidget(
                                                          _noOfSistersKey);
                                                    } else if (_stepOneController
                                                            .selectedMarriedNumberOfSisters
                                                            .value
                                                            ?.id ==
                                                        null) {
                                                      _scrollToWidget(
                                                          _noOfMarriedSistersKey);
                                                    } else if (_stepOneController.selectedFamilyAssetsList
                                                        .where((field) => field.id != null) // Filter out null ids
                                                        .map((field) => field.id!)
                                                        .toList()
                                                        .isEmpty) {
                                                      _scrollToWidget(
                                                          _familyAssetsKey);
                                                    } else if (_stepOneController.SelectedFamilyType.value.id == null) {
                                                      _scrollToWidget(
                                                          _familyTypeKey);
                                                    } else if (_stepOneController.selectedFamilyClass.value.id == null) {
                                                      _scrollToWidget(
                                                          _familyStatusKey);
                                                    } else if (_stepOneController.selectedLivingParentType.value.id == null) {
                                                      _scrollToWidget(
                                                          _livingWithKey);
                                                    }
                                                  }
                                                },
                                          child: _stepOneController
                                                  .isLoading.value
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
                                ],
                              ),
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

  void _showMotherOccupationBottomSheet(BuildContext context) {
    final EditFamilyFetailsController editfamilyDetailsController =
        Get.find<EditFamilyFetailsController>();

    // Fetch occupations and set loading state
    editfamilyDetailsController.fetchMotherOccupationsFromApi();

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
                  language == "en"
                      ? "Select Mother Occupation"
                      : "आईचा व्यवसाय निवडा ",
                  style: CustomTextStyle.bodytextboldLarge,
                ),
                const SizedBox(height: 10),

                // Display loading indicator or the list based on isLoading state
                Obx(() {
                  if (editfamilyDetailsController
                      .isloadingMotherOccupations.value) {
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
                              color: Colors.grey[300],
                            ),
                            selected: false,
                            onSelected: (_) {},
                          ),
                        );
                      }),
                    );
                  }

                  if (editfamilyDetailsController
                      .motherrOccupationsList.isEmpty) {
                    return const Center(
                      child: Text('No data found'),
                    );
                  }

                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: editfamilyDetailsController.motherrOccupationsList
                        .map((FieldModel sign) {
                      return Obx(() {
                        final isSelected = editfamilyDetailsController
                                .selectedMotherOccupation.value.id ==
                            sign.id;

                        return ChoiceChip(
                          labelPadding: const EdgeInsets.all(4),
                          checkmarkColor: Colors.white,
                          disabledColor: AppTheme.lightPrimaryColor,
                          backgroundColor: AppTheme.lightPrimaryColor,
                          label: Text(
                            sign.name ?? '',
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
                              editfamilyDetailsController
                                  .updateMotherOccupation(sign);
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

  void _showFatherOccupationBottomSheet(BuildContext context) {
    final EditFamilyFetailsController editLifestyleController =
        Get.find<EditFamilyFetailsController>();

    // Fetch occupations and set loading state
    editLifestyleController.fetchFatherOccupationsFromApi();

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
                  language == "en"
                      ? "Select Father Occupation"
                      : "वडिलांचा व्यवसाय निवडा ",
                  style: CustomTextStyle.bodytextboldLarge,
                ),
                const SizedBox(height: 10),

                // Display loading indicator or the list based on isLoading state
                Obx(() {
                  if (editLifestyleController
                      .isloadingFatherOccupations.value) {
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
                              color: Colors.grey[300],
                            ),
                            selected: false,
                            onSelected: (_) {},
                          ),
                        );
                      }),
                    );
                  } else {
                    return Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: editLifestyleController.fatherOccupationsList
                          .map((FieldModel sign) {
                        return Obx(() {
                          final isSelected = editLifestyleController
                                  .selectedFatherOccupation.value.id ==
                              sign.id;

                          return ChoiceChip(
                            labelPadding: const EdgeInsets.all(4),
                            checkmarkColor: Colors.white,
                            disabledColor: AppTheme.lightPrimaryColor,
                            backgroundColor: AppTheme.lightPrimaryColor,
                            label: Text(
                              sign.name ?? '',
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
                                editLifestyleController
                                    .updateFatherOccupation(sign);
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
                    );
                  }
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

  void _showFamilyAssetsBottomSheet(BuildContext context) {
    final EditFamilyFetailsController hobbiesController =
        Get.put(EditFamilyFetailsController());

    // Fetch hobbies data when modal opens
    hobbiesController.fetchfamilyAssetsFromApi();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  language == "en"
                      ? "Select Your Family assets"
                      : "आपल्या कुटुंबाच्या मालमत्ता निवडा",
                  style: CustomTextStyle.bodytextboldLarge,
                ),
                const SizedBox(height: 10),

                // Search TextField
                TextField(
                  decoration: InputDecoration(
                    errorMaxLines: 5,
                    errorStyle: CustomTextStyle.errorText,
                    labelStyle: CustomTextStyle.bodytext,
                    hintText: language == "en"
                        ? "Search asset..."
                        : "मालमत्ता शोधा...",
                    contentPadding: const EdgeInsets.all(20),
                    hintStyle: CustomTextStyle.hintText,
                    filled: true,
                    fillColor: Colors.white,
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
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
                    suffixIcon: Icon(Icons.search, color: Colors.grey.shade300),
                  ),
                  onChanged: (query) {
                    hobbiesController.filterFamilyAssets(query);
                  },
                ),
                Obx(() {
                  if (_stepOneController.selectedFamilyAssetsList.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 4),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(
                                color: AppTheme.dividerDarkColor, width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                spacing:
                                    10, // Spacing between chips horizontally
                                runSpacing:
                                    10, // Spacing between rows vertically
                                children: [
                                  ...List.generate(
                                    _stepOneController.selectedFamilyAssetsList
                                                .length >
                                            2
                                        ? 2
                                        : _stepOneController
                                            .selectedFamilyAssetsList.length,
                                    (index) {
                                      final item = _stepOneController
                                          .selectedFamilyAssetsList[index];
                                      return Chip(
                                        deleteIcon: const Padding(
                                          padding: EdgeInsets.all(0),
                                          child: Icon(Icons.close, size: 12),
                                        ),
                                        padding: const EdgeInsets.all(2),
                                        labelPadding: const EdgeInsets.all(4),
                                        backgroundColor:
                                            AppTheme.lightPrimaryColor,
                                        side: const BorderSide(
                                          style: BorderStyle.none,
                                          color: Colors.blue,
                                        ),
                                        label: Text(
                                          item.name ?? "",
                                          style: CustomTextStyle.bodytext
                                              .copyWith(fontSize: 11),
                                        ),
                                        onDeleted: () {
                                          // Handle onDeleted functionality
                                          hobbiesController
                                              .toggleSelectionFamilyAssets(
                                                  item);
                                        },
                                      );
                                    },
                                  ),
                                  Obx(() {
                                    if (_stepOneController
                                            .selectedFamilyAssetsList.length <=
                                        2) {
                                      return const SizedBox();
                                    } else {
                                      return GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return ShowAllFamilyAssets(
                                                  items: _stepOneController
                                                      .selectedFamilyAssetsList);
                                            },
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 2, top: 12.0),
                                          child: Text(
                                            "${language == "en" ? "View" : "बघा"} (+${_stepOneController.selectedFamilyAssetsList.length - 2})",
                                            style: CustomTextStyle.bodytext
                                                .copyWith(
                                              color:
                                                  AppTheme.selectedOptionColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  }),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(
                                color: AppTheme.dividerDarkColor, width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.selectvisible,
                                // "Selected items will be visible here.",
                                style: CustomTextStyle.hintText,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                }),

                // "Select All" ChoiceChip
                Obx(
                  () {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ChoiceChip(
                          checkmarkColor: Colors.white,
                          label: Text(
                            hobbiesController.allSelectedFamilyAssets.value
                                ? language == "en"
                                    ? "Deselect All"
                                    : "सर्व पर्याय काढून टाका"
                                : language == "en"
                                    ? "Select All"
                                    : "सर्व निवडा",
                            style: CustomTextStyle.bodytext.copyWith(
                              fontSize: 14,
                              color: hobbiesController
                                      .allSelectedFamilyAssets.value
                                  ? Colors.white
                                  : AppTheme.secondryColor,
                            ),
                          ),
                          selected:
                              hobbiesController.allSelectedFamilyAssets.value,
                          onSelected: (bool selected) {
                            hobbiesController
                                .toggleSelectAllFamilyAssets(); // Toggle all hobbies as selected/deselected
                          },
                          selectedColor: AppTheme.selectedOptionColor,
                          backgroundColor: AppTheme.lightPrimaryColor,
                          labelStyle: CustomTextStyle.bodytext.copyWith(
                            fontSize: 14,
                            color:
                                hobbiesController.allSelectedFamilyAssets.value
                                    ? Colors.white
                                    : AppTheme.secondryColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),

                // Use Expanded with Obx for a scrollable list
                Expanded(
                  child: Obx(() {
                    if (hobbiesController.isloadingfamilyAssets.value) {
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
                                color: Colors.grey[300],
                              ),
                              selected: false,
                              onSelected: (_) {},
                            ),
                          );
                        }),
                      );
                    }

                    if (hobbiesController.filteredFamilyAssetsList.isEmpty) {
                      return const Center(child: Text('No data found'));
                    }

                    // Display filtered list of items in ChoiceChips
                    return SingleChildScrollView(
                      child: Wrap(
                        spacing: 5,
                        runSpacing: 10,
                        children: hobbiesController.filteredFamilyAssetsList
                            .map((FieldModel item) {
                          final isSelected = hobbiesController
                              .selectedFamilyAssetsList
                              .any((element) => element.id == item.id);

                          return ChoiceChip(
                            labelPadding: const EdgeInsets.all(4),
                            checkmarkColor: Colors.white,
                            disabledColor: AppTheme.lightPrimaryColor,
                            backgroundColor: AppTheme.lightPrimaryColor,
                            label: Text(
                              item.name ?? "",
                              style: CustomTextStyle.bodytext.copyWith(
                                fontSize: 14,
                                color: isSelected
                                    ? AppTheme.lightPrimaryColor
                                    : AppTheme.selectedOptionColor,
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (bool selected) {
                              hobbiesController
                                  .toggleSelectionFamilyAssets(item);
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
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 20),

                // Done button to close the modal
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.done,
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
