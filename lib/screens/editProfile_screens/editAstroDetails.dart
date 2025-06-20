import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/editforms_controllers/editAstroDetailsController.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/profile_screens/edit_profile.dart';
import 'package:_96kuliapp/screens/userInfoForms/location/birthPlace/selectBirthPlace.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/backheader.dart';
import 'package:_96kuliapp/utils/buttonContainer.dart';
import 'package:_96kuliapp/utils/customtextform.dart';
import 'package:shimmer/shimmer.dart';

class AstroDetailsScreen extends StatefulWidget {
  const AstroDetailsScreen({super.key});

  @override
  State<AstroDetailsScreen> createState() => _AstroDetailsScreenState();
}

class _AstroDetailsScreenState extends State<AstroDetailsScreen> {
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String locationText = "";

  TimeOfDay selectedTime = TimeOfDay.now();

  final LocationController locationController = Get.put(LocationController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormFieldState> _timeFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _placeofbirthKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _rasKey = GlobalKey<FormFieldState>();

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

  final Editastrodetailscontroller _editastrodetailscontroller =
      Get.put(Editastrodetailscontroller());
  @override
  Widget build(BuildContext context) {
    Future<void> selectTime(BuildContext context) async {
      // Check if there's an existing time in the controller and parse it
      TimeOfDay initialTime;
      if (_editastrodetailscontroller.selectedHour.value.isNotEmpty &&
          _editastrodetailscontroller.selectedMinute.value.isNotEmpty &&
          _editastrodetailscontroller.selectedTimeFormat.value.isNotEmpty) {
        int hour = int.parse(_editastrodetailscontroller.selectedHour.value);
        final int minute =
            int.parse(_editastrodetailscontroller.selectedMinute.value);

        // Convert to 24-hour format if needed
        if (_editastrodetailscontroller.selectedTimeFormat.value == "PM" &&
            hour < 12) {
          hour += 12; // Convert to 24-hour time
        } else if (_editastrodetailscontroller.selectedTimeFormat.value ==
                "AM" &&
            hour == 12) {
          hour = 0; // 12 AM is 0 in 24-hour time
        }

        initialTime = TimeOfDay(hour: hour, minute: minute);
      } else {
        // Default to the current time if no time is pre-selected
        initialTime = TimeOfDay.now();
      }

      final TimeOfDay? pickedTime = await showTimePicker(
        initialEntryMode: TimePickerEntryMode.dialOnly,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        },
        context: context,
        initialTime: initialTime,
      );

      if (pickedTime != null) {
        _editastrodetailscontroller.updateTime(pickedTime, context);
      }
    }

    //  int selectedIndex = _stepOneController.selectedBloodGroup.value?.id ?? 0;

    // Ensure the index is within the bounds of bloodGroups
    //  ListItems selectedBloodGroup = bloodGroups[selectedIndex];
    //  int selectedIndexHeight = _stepOneController.selectedHeightIndex.value;

    // Ensure the index is within the bounds of heightInFeet
    //  ListItems selectedHeight = heightInFeet[selectedIndexHeight];
    return Scaffold(body: SingleChildScrollView(
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
            if (_editastrodetailscontroller.isPageLoading.value == true) {
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
                        title: AppLocalizations.of(context)!.editAStroDetails),
                  ],
                ),
              );
            } else {
              return Column(
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
                      title: AppLocalizations.of(context)!.editAStroDetails),
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
                                text: "*", style: TextStyle(color: Colors.red)),
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
                                text: "*", style: TextStyle(color: Colors.red)),
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

                              title: _editastrodetailscontroller.dateofbirth
                                  .value, // Default if no date is selected
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            RichText(
                                text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text:
                                      AppLocalizations.of(context)!.timeofBirth,
                                  style: CustomTextStyle.fieldName),
                              const TextSpan(
                                  text: "*",
                                  style: TextStyle(color: Colors.red))
                            ])),
                            Obx(() {
                              // Concatenate the hour, minute, and time format into a single string
                              final String formattedTime =
                                  (_editastrodetailscontroller
                                              .selectedHour.value !=
                                          "")
                                      ? "${_editastrodetailscontroller.selectedHour.value}:${_editastrodetailscontroller.selectedMinute.value} ${_editastrodetailscontroller.selectedTimeFormat.value}"
                                      : "";

                              // Use the concatenated string in a single TextEditingController
                              final TextEditingController timeController =
                                  TextEditingController(text: formattedTime);

                              return CustomTextField(
                                validator: (value) {
                                  if (language == "en") {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Select $gender the time of birth';
                                    }
                                  } else {
                                    return "$gender जन्मतारीख टाकणे अनिवार्य आहे.";
                                  }

                                  return null;
                                },
                                textEditingController: timeController,
                                readonly: true,
                                HintText: language == "en"
                                    ? "Select Time of Birth"
                                    : "$gender जन्मवेळ टाका", // Updated hint to reflect format
                                ontap: () async {
                                  await selectTime(
                                      context); // Trigger time selection

                                  // After time is selected, update the controller and validate the field
                                  if (_editastrodetailscontroller
                                      .selectedHour.value.isNotEmpty) {
                                    timeController.text =
                                        "${_editastrodetailscontroller.selectedHour.value}:${_editastrodetailscontroller.selectedMinute.value} ${_editastrodetailscontroller.selectedTimeFormat.value}";

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
                                text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .placeofBirth,
                                  style: CustomTextStyle.fieldName),
                              const TextSpan(
                                  text: "*",
                                  style: TextStyle(color: Colors.red))
                            ])),
                            Obx(() {
                              // Use a controller from locationController, rather than recreating it each time
                              final TextEditingController placeOfBirth =
                                  TextEditingController(
                                      text: locationController
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
                                      return '$gender जन्म स्थळाजवळील जिल्हा निवडा.';
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

                                  // Ensure that the selected place is updated
                                  if (locationController
                                          .selectedPlace.value.name !=
                                      null) {
                                    if (locationController
                                        .selectedPlace.value.name!.isNotEmpty) {
                                      // Update the TextEditingController with the new place of birth
                                      placeOfBirth.text = locationController
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
                                },
                                HintText: language == "en"
                                    ? "Select $gender Place of Birth"
                                    : "$gender जन्मठिकाण टाका",
                              );
                            }),
                            const SizedBox(
                              height: 50,
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
                                          style: CustomTextStyle.elevatedButton
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
                                        onPressed: _editastrodetailscontroller
                                                .isLoading.value
                                            ? null
                                            : () {
                                                // Update validation statuses in the controller

                                                // Set submitted state
                                                _editastrodetailscontroller
                                                    .isSubmitted.value = true;

                                                // Validate form
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  // Check if all validations are passed
                                                  _editastrodetailscontroller
                                                      .BasicForm(
                                                    timeOfBirth:
                                                        _editastrodetailscontroller
                                                            .selected24HourFormat
                                                            .value,
                                                    placeOfBirth:
                                                        locationController
                                                            .selectedPlace
                                                            .value
                                                            .id
                                                            .toString(),
                                                  ).then((result) {
                                                    // Reset loading state
                                                    _editastrodetailscontroller
                                                        .isLoading
                                                        .value = false;
                                                    // Handle successful result (optional)
                                                  }).catchError((error) {
                                                    // Handle error and reset loading state
                                                    _editastrodetailscontroller
                                                        .isLoading
                                                        .value = false;
                                                    print("Error: $error");
                                                  });
                                                } else {
                                                  // Show error if form validation fails
                                                  //   Get.snackbar("Error", "Please Fill all required Fields");
                                                }
                                              },
                                        child: _editastrodetailscontroller
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
    ));
  }
}
