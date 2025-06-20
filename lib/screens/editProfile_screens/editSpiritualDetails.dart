import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/editforms_controllers/editSpiritualController.dart';
import 'package:_96kuliapp/controllers/formfields/rasController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';
import 'package:_96kuliapp/screens/profile_screens/edit_profile.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/backheader.dart';
import 'package:_96kuliapp/utils/buttonContainer.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/customtextform.dart';

class EditSpiritualDetailsScreen extends StatefulWidget {
  const EditSpiritualDetailsScreen({super.key});

  @override
  State<EditSpiritualDetailsScreen> createState() =>
      _EditSpiritualDetailsScreenState();
}

class _EditSpiritualDetailsScreenState
    extends State<EditSpiritualDetailsScreen> {
  final Rascontroller _rascontroller = Get.put(Rascontroller());

  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String locationText = "";

  TimeOfDay selectedTime = TimeOfDay.now();

  late String gender;
  String? gender2;
  String? gender3;
  String? gender4;
  String? language = sharedPreferences?.getString("Language");
  final mybox = Hive.box('myBox');

  @override
  void initState() {
    super.initState(); // Call the superclass's method
    gender = selectgender();
    _stepOneController.fetchBasicInfo();
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormFieldState> _timeFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _placeofbirthKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _rasKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _manglikKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _nakshatraKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _ganKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _charanKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _nadiKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _gotraKey = GlobalKey<FormFieldState>();

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

  final EditSpiritualController _stepOneController =
      Get.put(EditSpiritualController());
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
                          title: AppLocalizations.of(context)!
                              .editSpiritualDetails),
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
                        title:
                            AppLocalizations.of(context)!.editSpiritualDetails),
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
                                          return '$gender रास टाकणे अनिवार्य आहे.';
                                        }
                                      }
                                      return null;
                                    },
                                    textEditingController: ras,
                                    HintText: language == "en"
                                        ? "Select Ras"
                                        : "$gender रास टाका",
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
                                                    "$gender2 मंगळ वराचा दोष निवडा",
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
                              const SizedBox(
                                height: 10,
                              ),
                              RichText(
                                  key: _nakshatraKey,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .nakshatra,
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
                                                  .selectedNakshatra
                                                  .value
                                                  ?.name ??
                                              "");
                                  return CustomTextField(
                                    validator: (value) {
                                      if (language == "en") {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select $gender nakshatra';
                                        }
                                      } else {
                                        if (value == null || value.isEmpty) {
                                          return 'कृपया $gender4 नक्षत्र येथे टाकणे अनिवार्य आहे';
                                        }
                                      }

                                      return null;
                                    },
                                    textEditingController: ras,
                                    HintText: language == "en"
                                        ? "Select Nakshatra"
                                        : "$gender4 नक्षत्र निवडा",
                                    ontap: () {
                                      _showNakshatraSelection(context);
                                    },
                                    readonly: true,
                                  );
                                },
                              ),

                              const SizedBox(
                                height: 10,
                              ),
                              RichText(
                                  key: _ganKey,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: AppLocalizations.of(context)!.gan,
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
                                                  .selectedGan.value?.name ??
                                              "");
                                  return CustomTextField(
                                    validator: (value) {
                                      if (language == "en") {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select $gender gan';
                                        }
                                      } else {
                                        if (value == null || value.isEmpty) {
                                          return 'कृपया $gender2 गण येथे टाकणे अनिवार्य आहे';
                                        }
                                      }

                                      return null;
                                    },
                                    textEditingController: ras,
                                    HintText: language == "en"
                                        ? "Select $gender Gan"
                                        : "$gender2 गण निवडा",
                                    ontap: () {
                                      _showGanSelection(context);
                                    },
                                    readonly: true,
                                  );
                                },
                              ),

                              const SizedBox(
                                height: 10,
                              ),
                              RichText(
                                  key: _charanKey,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .charan,
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
                                                  .selectedCharan.value?.name ??
                                              "");
                                  return CustomTextField(
                                    validator: (value) {
                                      if (language == "en") {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select $gender charan';
                                        }
                                      } else {
                                        if (value == null || value.isEmpty) {
                                          return 'कृपया $gender4 चरण येथे टाकणे अनिवार्य आहे';
                                        }
                                      }

                                      return null;
                                    },
                                    textEditingController: ras,
                                    HintText: language == "en"
                                        ? "Select $gender Charan"
                                        : "$gender4 चरण निवडा",
                                    ontap: () {
                                      _showCharanSelection(context);
                                    },
                                    readonly: true,
                                  );
                                },
                              ),

                              const SizedBox(
                                height: 10,
                              ),
                              RichText(
                                  key: _nadiKey,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            AppLocalizations.of(context)!.nadi,
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
                                                  .selectedNadi.value?.name ??
                                              "");
                                  return CustomTextField(
                                    validator: (value) {
                                      if (language == "en") {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select $gender nadi';
                                        }
                                      } else {
                                        if (value == null || value.isEmpty) {
                                          return 'कृपया $gender नाडी येथे टाकणे अनिवार्य आहे';
                                        }
                                      }

                                      return null;
                                    },
                                    textEditingController: ras,
                                    HintText: language == "en"
                                        ? "Select $gender nadi"
                                        : "$gender नाडी निवडा",
                                    ontap: () {
                                      _showNadiSelection(context);
                                    },
                                    readonly: true,
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              RichText(
                                  key: _gotraKey,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            AppLocalizations.of(context)!.gotra,
                                        style: CustomTextStyle.fieldName),
                                    const TextSpan(
                                        text: "*",
                                        style: TextStyle(color: Colors.red))
                                  ])),
                              CustomTextField(
                                  validator: (value) {
                                    if (language == "en") {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select $gender gotra';
                                      }
                                    } else {
                                      if (value == null || value.isEmpty) {
                                        return 'कृपया $gender4 गोत्र येथे टाकणे अनिवार्य आहे';
                                      }
                                    }

                                    return null;
                                  },
                                  textEditingController:
                                      _stepOneController.gotraController,
                                  HintText: language == "en"
                                      ? "Enter $gender Gotra"
                                      : "$gender4 गोत्र "),

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
                                                  bool isManglikValid =
                                                      _stepOneController
                                                              .manglikSelected
                                                              .value
                                                              .id !=
                                                          null;

                                                  // Children validation based on marital status

                                                  // Update validation statuses in the controller
                                                  _stepOneController
                                                      .selectedManglikValidated
                                                      .value = isManglikValid;
                                                  //    _stepOneController.phvalidation.value = parentsContactValid;

                                                  // Set submitted state
                                                  _stepOneController
                                                      .isSubmitted.value = true;

                                                  // Validate form
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    // Check if all validations are passed
                                                    if (!isManglikValid) {
                                                      _scrollToWidget(
                                                          _manglikKey);

                                                      // Show error message if validation fails
                                                      //   Get.snackbar("Error", "Please fill all required fields");
                                                    } else {
                                                      // Start loading state
                                                      _stepOneController
                                                          .isLoading
                                                          .value = true;

                                                      // API call
                                                      _stepOneController
                                                          .BasicForm(
                                                        charan: _stepOneController
                                                                .selectedCharan
                                                                .value
                                                                ?.id ??
                                                            0,
                                                        nadi: _stepOneController
                                                                .selectedNadi
                                                                .value
                                                                ?.id ??
                                                            0,
                                                        gan: _stepOneController
                                                                .selectedGan
                                                                .value
                                                                ?.id ??
                                                            0,
                                                        nakshatra:
                                                            _stepOneController
                                                                    .selectedNakshatra
                                                                    .value
                                                                    ?.id ??
                                                                0,
                                                        gotra:
                                                            _stepOneController
                                                                .gotraController
                                                                .text
                                                                .trim(),
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
                                                    // Show error if form validation fails
                                                    //   Get.snackbar("Error", "Please Fill all required Fields");
                                                    if (_stepOneController
                                                            .selectedZodiacSign
                                                            .value
                                                            ?.id ==
                                                        null) {
                                                      _scrollToWidget(_rasKey);
                                                    } else if (_stepOneController
                                                            .manglikSelected
                                                            .value
                                                            .id ==
                                                        null) {
                                                      _scrollToWidget(
                                                          _manglikKey);
                                                    } else if (_stepOneController
                                                            .selectedNakshatra
                                                            .value
                                                            ?.id ==
                                                        null) {
                                                      _scrollToWidget(
                                                          _nakshatraKey);
                                                    } else if (_stepOneController
                                                            .selectedGan
                                                            .value
                                                            ?.id ==
                                                        null) {
                                                      _scrollToWidget(_ganKey);
                                                    } else if (_stepOneController
                                                            .selectedCharan
                                                            .value
                                                            ?.id ==
                                                        null) {
                                                      _scrollToWidget(
                                                          _charanKey);
                                                    } else if (_stepOneController
                                                        .gotraController.text
                                                        .trim()
                                                        .isEmpty) {
                                                      _scrollToWidget(
                                                          _gotraKey);
                                                    }
                                                    // mother tongue
                                                    else if (_stepOneController
                                                            .selectedNadi
                                                            .value
                                                            ?.id ==
                                                        null) {
                                                      _scrollToWidget(_nadiKey);
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

  void _showNadiSelection(BuildContext context) {
    final EditSpiritualController zodiacController =
        Get.find<EditSpiritualController>();

    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Allows the sheet to take the minimum height necessary
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Makes the column take minimum space
              children: [
                Text(language == "en" ? "Select Nadi" : "नाडी निवडा",
                    style: CustomTextStyle.bodytextboldLarge),
                const SizedBox(height: 10),

                // Dynamic list of zodiac signs from the controller
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: zodiacController.Nadi.map((FieldModel sign) {
                    return Obx(() {
                      final isSelected =
                          zodiacController.selectedNadi.value?.id == sign.id;

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
                            zodiacController.updateNadi(sign);
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

                // Done button at the bottom of the modal
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
        );
      },
    );
  }

  void _showCharanSelection(BuildContext context) {
    final EditSpiritualController zodiacController =
        Get.find<EditSpiritualController>();

    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Allows the sheet to take the minimum height necessary
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Makes the column take minimum space
              children: [
                Text(language == "en" ? "Select Charan" : "चरण निवडा",
                    style: CustomTextStyle.bodytextboldLarge),
                const SizedBox(height: 10),

                // Dynamic list of zodiac signs from the controller
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: zodiacController.Charan.map((FieldModel sign) {
                    return Obx(() {
                      final isSelected =
                          zodiacController.selectedCharan.value?.id == sign.id;

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
                            zodiacController.updateCharan(sign);
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

                // Done button at the bottom of the modal
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
        );
      },
    );
  }

  void _showGanSelection(BuildContext context) {
    final EditSpiritualController zodiacController =
        Get.find<EditSpiritualController>();

    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Allows the sheet to take the minimum height necessary
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Makes the column take minimum space
              children: [
                Text(language == "en" ? "Select Gan" : "गण निवडा",
                    style: CustomTextStyle.bodytextboldLarge),
                const SizedBox(height: 10),

                // Dynamic list of zodiac signs from the controller
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: zodiacController.Gan.map((FieldModel sign) {
                    return Obx(() {
                      final isSelected =
                          zodiacController.selectedGan.value?.id == sign.id;

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
                            zodiacController.updateGan(sign);
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
                // Done button at the bottom of the modal
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

  void _showNakshatraSelection(BuildContext context) {
    final EditSpiritualController zodiacController =
        Get.find<EditSpiritualController>();

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
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            language == "en"
                                ? "Select Nakshatra"
                                : "नक्षत्र निवडा",
                            style: CustomTextStyle.bodytextboldLarge),
                        const SizedBox(height: 10),
                        // Dynamic list of zodiac signs from the controller
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children:
                              zodiacController.Nakshatra.map((FieldModel sign) {
                            return Obx(() {
                              final isSelected = zodiacController
                                      .selectedNakshatra.value?.id ==
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
                                    zodiacController.updateNakshatra(sign);
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
                      ],
                    ),
                  ),
                ),

                // Done button at the bottom of the modal
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

  void _showZodiacSelection(BuildContext context) {
    // Access the ZodiacController
    final EditSpiritualController zodiacController =
        Get.find<EditSpiritualController>();

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
                Text(language == "en" ? "Select Zodiac Sign" : "रास निवडा ",
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
                          )),
                    ),
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
                  "Select Ras",
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
