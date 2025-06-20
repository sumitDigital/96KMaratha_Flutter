import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/editforms_controllers/editEducationController.dart';
import 'package:_96kuliapp/controllers/editforms_controllers/editlifestyleController.dart';
import 'package:_96kuliapp/controllers/formfields/rasController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';
import 'package:_96kuliapp/screens/profile_screens/edit_profile.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/backheader.dart';
import 'package:_96kuliapp/utils/buttonContainer.dart';
import 'package:_96kuliapp/utils/customtextform.dart';
import 'package:shimmer/shimmer.dart';

class EditLifestyleDetails extends StatefulWidget {
  const EditLifestyleDetails({super.key});

  @override
  State<EditLifestyleDetails> createState() => _EditLifestyleDetailsState();
}

class _EditLifestyleDetailsState extends State<EditLifestyleDetails> {
  final EditLifestylecontroller _editLifestylecontroller =
      Get.put(EditLifestylecontroller());
  String? language = sharedPreferences?.getString("Language");
  TimeOfDay selectedTime = TimeOfDay.now();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormFieldState> _languageKnown = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _dietryHabitKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _SmokingHabitKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _DrinkingHabitKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _motherTongueKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _hobbiesKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _interestKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _dressStyleKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _sportsKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _favouriteMusicKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _favouriteFoodKey =
      GlobalKey<FormFieldState>();

  late String gender;
  String? gender2;
  String? gender3;
  String? gender4;

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

  final mybox = Hive.box('myBox');

  @override
  void initState() {
    super.initState();
    gender = selectgender();

    // _editLifestylecontroller.fetchhobbiesFromApi();
    // _editLifestylecontroller.fetchInterestFromApi();
    // _editLifestylecontroller.fetchdressStyleFromApi();
    // _editLifestylecontroller.fetchSportsFromApi();
    // _editLifestylecontroller.fetchMusicFromApi();
    // _editLifestylecontroller.fetchFoodFromApi();
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

  @override
  Widget build(BuildContext context) {
    // String gender = mybox.get("gender") == 2 ? "groom" : "bride";

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

              if (_editLifestylecontroller.isPageLoading.value == true) {
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
                                  AppLocalizations.of(context)!
                                      .editLifestyleDetails,
                                  style: CustomTextStyle.bodytextLarge,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
                            AppLocalizations.of(context)!.editLifestyleDetails),
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
                              const SizedBox(
                                height: 20,
                              ),
                              RichText(
                                  key: _dietryHabitKey,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .dietryhabit,
                                        // "Dietry habit ",
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
                                          _editLifestylecontroller
                                              .updateEatingHabit(FieldModel(
                                                  id: 1, name: "Vegetarian"));
                                        },
                                        child: CustomContainer(
                                          height: 60,
                                          title: AppLocalizations.of(context)!
                                              .vegitarian,
                                          width: 105,
                                          color: _editLifestylecontroller
                                                      .selectedEatingHabit
                                                      .value
                                                      .id ==
                                                  1
                                              ? AppTheme.selectedOptionColor
                                              : null,
                                          textColor: _editLifestylecontroller
                                                      .selectedEatingHabit
                                                      .value
                                                      .id ==
                                                  1
                                              ? Colors.white
                                              : null,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _editLifestylecontroller
                                              .updateEatingHabit(FieldModel(
                                                  id: 2, name: "Non-Veg"));
                                        },
                                        child: CustomContainer(
                                          height: 60,
                                          title: AppLocalizations.of(context)!
                                              .nonVegitarian,
                                          width: 138,
                                          color: _editLifestylecontroller
                                                      .selectedEatingHabit
                                                      .value
                                                      .id ==
                                                  2
                                              ? AppTheme.selectedOptionColor
                                              : null,
                                          textColor: _editLifestylecontroller
                                                      .selectedEatingHabit
                                                      .value
                                                      .id ==
                                                  2
                                              ? Colors.white
                                              : null,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _editLifestylecontroller
                                              .updateEatingHabit(FieldModel(
                                                  id: 5, name: "Vegan"));
                                        },
                                        child: CustomContainer(
                                          height: 60,
                                          title: AppLocalizations.of(context)!
                                              .vegan,
                                          width: 105,
                                          color: _editLifestylecontroller
                                                      .selectedEatingHabit
                                                      .value
                                                      .id ==
                                                  5
                                              ? AppTheme.selectedOptionColor
                                              : null,
                                          textColor: _editLifestylecontroller
                                                      .selectedEatingHabit
                                                      .value
                                                      .id ==
                                                  5
                                              ? Colors.white
                                              : null,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _editLifestylecontroller
                                              .updateEatingHabit(FieldModel(
                                                  id: 4, name: "Eggetarian"));
                                        },
                                        child: CustomContainer(
                                          height: 60,
                                          title: AppLocalizations.of(context)!
                                              .eggitarian,
                                          width: 105,
                                          color: _editLifestylecontroller
                                                      .selectedEatingHabit
                                                      .value
                                                      .id ==
                                                  4
                                              ? AppTheme.selectedOptionColor
                                              : null,
                                          textColor: _editLifestylecontroller
                                                      .selectedEatingHabit
                                                      .value
                                                      .id ==
                                                  4
                                              ? Colors.white
                                              : null,
                                        ),
                                      ),
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     _editLifestylecontroller
                                      //         .updateEatingHabit(FieldModel(
                                      //             id: 6, name: "Jain"));
                                      //   },
                                      //   child: CustomContainer(
                                      //     height: 60,
                                      //     title: AppLocalizations.of(context)!
                                      //         .jain,
                                      //     width: 105,
                                      //     color: _editLifestylecontroller
                                      //                 .selectedEatingHabit
                                      //                 .value
                                      //                 .id ==
                                      //             6
                                      //         ? AppTheme.selectedOptionColor
                                      //         : null,
                                      //     textColor: _editLifestylecontroller
                                      //                 .selectedEatingHabit
                                      //                 .value
                                      //                 .id ==
                                      //             6
                                      //         ? Colors.white
                                      //         : null,
                                      //   ),
                                      // ),
                                      GestureDetector(
                                        onTap: () {
                                          _editLifestylecontroller
                                              .updateEatingHabit(FieldModel(
                                                  id: 3,
                                                  name:
                                                      "Occasionally Non-veg"));
                                        },
                                        child: CustomContainer(
                                          height: 60,
                                          title: AppLocalizations.of(context)!
                                              .occasionallynonveg,
                                          width: 105,
                                          color: _editLifestylecontroller
                                                      .selectedEatingHabit
                                                      .value
                                                      .id ==
                                                  3
                                              ? AppTheme.selectedOptionColor
                                              : null,
                                          textColor: _editLifestylecontroller
                                                      .selectedEatingHabit
                                                      .value
                                                      .id ==
                                                  3
                                              ? Colors.white
                                              : null,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _editLifestylecontroller
                                              .updateEatingHabit(FieldModel(
                                                  id: 7, name: "Other"));
                                        },
                                        child: CustomContainer(
                                          height: 60,
                                          title: AppLocalizations.of(context)!
                                              .other,
                                          width: 105,
                                          color: _editLifestylecontroller
                                                      .selectedEatingHabit
                                                      .value
                                                      .id ==
                                                  7
                                              ? AppTheme.selectedOptionColor
                                              : null,
                                          textColor: _editLifestylecontroller
                                                      .selectedEatingHabit
                                                      .value
                                                      .id ==
                                                  7
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
                                  if (_editLifestylecontroller
                                              .selectedEatingHabitValidated
                                              .value ==
                                          false &&
                                      _editLifestylecontroller
                                              .isSubmitted.value ==
                                          true) {
                                    if (_editLifestylecontroller
                                            .selectedEatingHabit.value.id ==
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
                                              "Please select $gender dietary habits",
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
                                height: 20,
                              ),
                              RichText(
                                  key: _SmokingHabitKey,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .smokinghabit,
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
                                          _editLifestylecontroller
                                              .updateSmokingHabit(FieldModel(
                                                  id: 1, name: "yes"));
                                        },
                                        child: CustomContainer(
                                          textColor: _editLifestylecontroller
                                                      .selectedSmokingHabit
                                                      .value
                                                      .id ==
                                                  1
                                              ? Colors.white
                                              : null,
                                          height: 60,
                                          title:
                                              AppLocalizations.of(context)!.yes,
                                          width: 89,
                                          color: _editLifestylecontroller
                                                      .selectedSmokingHabit
                                                      .value
                                                      .id ==
                                                  1
                                              ? AppTheme.selectedOptionColor
                                              : null,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _editLifestylecontroller
                                              .updateSmokingHabit(FieldModel(
                                                  id: 2, name: "no"));
                                        },
                                        child: CustomContainer(
                                          textColor: _editLifestylecontroller
                                                      .selectedSmokingHabit
                                                      .value
                                                      .id ==
                                                  2
                                              ? Colors.white
                                              : null,
                                          height: 60,
                                          title:
                                              AppLocalizations.of(context)!.no,
                                          width: 89,
                                          color: _editLifestylecontroller
                                                      .selectedSmokingHabit
                                                      .value
                                                      .id ==
                                                  2
                                              ? AppTheme.selectedOptionColor
                                              : null,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _editLifestylecontroller
                                              .updateSmokingHabit(FieldModel(
                                                  id: 3, name: "Occasionally"));
                                        },
                                        child: CustomContainer(
                                          textColor: _editLifestylecontroller
                                                      .selectedSmokingHabit
                                                      .value
                                                      .id ==
                                                  3
                                              ? Colors.white
                                              : null,
                                          height: 60,
                                          title: AppLocalizations.of(context)!
                                              .occasionally,
                                          width: 117,
                                          color: _editLifestylecontroller
                                                      .selectedSmokingHabit
                                                      .value
                                                      .id ==
                                                  3
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
                                  print("Valid Mang");
                                  if (_editLifestylecontroller
                                              .selectedSmokingHabitValidated
                                              .value ==
                                          false &&
                                      _editLifestylecontroller
                                              .isSubmitted.value ==
                                          true) {
                                    if (_editLifestylecontroller
                                            .selectedSmokingHabit.value.id ==
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
                                              "Please select $gender smoking habits",
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
                                height: 20,
                              ),
                              RichText(
                                key: _DrinkingHabitKey,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .drinkinghabit,
                                        style: CustomTextStyle.fieldName),
                                    const TextSpan(
                                        text: "*",
                                        style: TextStyle(color: Colors.red))
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
                                          _editLifestylecontroller
                                              .updateDrinkingHabit(FieldModel(
                                                  id: 1, name: "yes"));
                                        },
                                        child: CustomContainer(
                                          textColor: _editLifestylecontroller
                                                      .selectedDrinkingHabit
                                                      .value
                                                      .id ==
                                                  1
                                              ? Colors.white
                                              : null,
                                          height: 60,
                                          title:
                                              AppLocalizations.of(context)!.yes,
                                          width: 89,
                                          color: _editLifestylecontroller
                                                      .selectedDrinkingHabit
                                                      .value
                                                      .id ==
                                                  1
                                              ? AppTheme.selectedOptionColor
                                              : null,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _editLifestylecontroller
                                              .updateDrinkingHabit(FieldModel(
                                                  id: 2, name: "no"));
                                        },
                                        child: CustomContainer(
                                          textColor: _editLifestylecontroller
                                                      .selectedDrinkingHabit
                                                      .value
                                                      .id ==
                                                  2
                                              ? Colors.white
                                              : null,
                                          height: 60,
                                          title:
                                              AppLocalizations.of(context)!.no,
                                          width: 89,
                                          color: _editLifestylecontroller
                                                      .selectedDrinkingHabit
                                                      .value
                                                      .id ==
                                                  2
                                              ? AppTheme.selectedOptionColor
                                              : null,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _editLifestylecontroller
                                              .updateDrinkingHabit(FieldModel(
                                                  id: 3,
                                                  name: "Occassionally"));
                                        },
                                        child: CustomContainer(
                                          textColor: _editLifestylecontroller
                                                      .selectedDrinkingHabit
                                                      .value
                                                      .id ==
                                                  3
                                              ? Colors.white
                                              : null,
                                          height: 60,
                                          title: AppLocalizations.of(context)!
                                              .occasionally,
                                          width: 117,
                                          color: _editLifestylecontroller
                                                      .selectedDrinkingHabit
                                                      .value
                                                      .id ==
                                                  3
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
                                  print("Valid Mang");
                                  if (_editLifestylecontroller
                                              .selectedDrinkingHabitValidated
                                              .value ==
                                          false &&
                                      _editLifestylecontroller
                                              .isSubmitted.value ==
                                          true) {
                                    if (_editLifestylecontroller
                                            .selectedDrinkingHabit.value.id ==
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
                                              "Please select $gender drinking habits",
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
                              const SizedBox(height: 20),
                              RichText(
                                  key: _languageKnown,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .languagesKnown,
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
                                  if (_editLifestylecontroller
                                      .selectedLanguages.isNotEmpty) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              _showLanguageSelectBottomSheet(
                                                  context);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey.shade300,
                                                    width: 1),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5)),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: ConstrainedBox(
                                                  constraints:
                                                      const BoxConstraints(
                                                          minWidth:
                                                              double.infinity),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Wrap(
                                                        direction:
                                                            Axis.horizontal,

                                                        spacing:
                                                            10, // Spacing between chips horizontally
                                                        runSpacing:
                                                            10, // Spacing between rows vertically
                                                        children: [
                                                          ...List.generate(
                                                            _editLifestylecontroller
                                                                        .selectedLanguages
                                                                        .length >
                                                                    4
                                                                ? 4
                                                                : _editLifestylecontroller
                                                                    .selectedLanguages
                                                                    .length,
                                                            (index) {
                                                              final item =
                                                                  _editLifestylecontroller
                                                                          .selectedLanguages[
                                                                      index];
                                                              return Chip(
                                                                deleteIcon:
                                                                    const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0),
                                                                  child: Icon(
                                                                      Icons
                                                                          .close,
                                                                      size: 12),
                                                                ),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(2),
                                                                labelPadding:
                                                                    const EdgeInsets
                                                                        .all(4),
                                                                backgroundColor:
                                                                    AppTheme
                                                                        .lightPrimaryColor,
                                                                side:
                                                                    const BorderSide(
                                                                  style:
                                                                      BorderStyle
                                                                          .none,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                                label: Text(
                                                                  item.name ??
                                                                      "",
                                                                  style: CustomTextStyle
                                                                      .bodytext
                                                                      .copyWith(
                                                                          fontSize:
                                                                              11),
                                                                ),
                                                                onDeleted: () {
                                                                  _editLifestylecontroller
                                                                      .toggleSelection(
                                                                          item);
                                                                },
                                                              );
                                                            },
                                                          ),
                                                          // Add button as a Chip
                                                          Obx(
                                                            () {
                                                              if (_editLifestylecontroller
                                                                      .selectedLanguages
                                                                      .length <=
                                                                  4) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    // Navigate to view all countries
                                                                    _showLanguageSelectBottomSheet(
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
                                                                    _showLanguageSelectBottomSheet(
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
                                                                      "(+${_editLifestylecontroller.selectedLanguages.length - 4}) ${language == "en" ? "More" : 'अधिक'}",
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
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Obx(
                                            () {
                                              if (_editLifestylecontroller
                                                          .listLengthValidate
                                                          .value ==
                                                      false &&
                                                  _editLifestylecontroller
                                                          .isSubmitted.value ==
                                                      true) {
                                                if (_editLifestylecontroller
                                                        .selectedLanguages
                                                        .length <
                                                    2) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 18.0,
                                                            top: 10),
                                                    child: Text(
                                                      "Please Select 4 or More Options to Move Forward",
                                                      style: CustomTextStyle
                                                          .errorText,
                                                    ),
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
                                    );
                                  } else {
                                    return CustomTextField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return language == "en"
                                              ? "Please select $gender languages known"
                                              : "कृपया $gender भाषा निवडा";
                                        }
                                        return null;
                                      },
                                      HintText: language == "en"
                                          ? "Select Languages known"
                                          : "भाषा निवडा",
                                      ontap: () {
                                        _showLanguageSelectBottomSheet(context);
                                      },
                                      readonly: true,
                                    );
                                  }
                                },
                              ),
                              const SizedBox(height: 20),
                              RichText(
                                  key: _motherTongueKey,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .motherTongue,
                                        // "Mother Tongue ",
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
                                  final TextEditingController ras =
                                      TextEditingController(
                                          text: _editLifestylecontroller
                                                  .selectedMotherTongue
                                                  .value
                                                  .name ??
                                              "");
                                  return CustomTextField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select $gender Mother tongue';
                                      }
                                      return null;
                                    },
                                    textEditingController: ras,
                                    HintText: language == "en"
                                        ? "Select Mother Tongue"
                                        : "मातृभाषा निवडा",
                                    ontap: () {
                                      _showMotherTongueBottomSheet(context);
                                    },
                                    readonly: true,
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              RichText(
                                key: _hobbiesKey,
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          language == "en" ? "Hobbies" : "छंद ",
                                      style: CustomTextStyle.fieldName),
                                  const TextSpan(
                                      text: "*",
                                      style: TextStyle(color: Colors.red))
                                ]),
                              ),
                              Obx(
                                () {
                                  if (_editLifestylecontroller
                                      .selectedHobbiesList.isNotEmpty) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              _showHobbiesBottomSheet(context);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey.shade300,
                                                    width: 1),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5)),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: ConstrainedBox(
                                                  constraints:
                                                      const BoxConstraints(
                                                          minWidth:
                                                              double.infinity),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Wrap(
                                                        direction:
                                                            Axis.horizontal,

                                                        spacing:
                                                            10, // Spacing between chips horizontally
                                                        runSpacing:
                                                            10, // Spacing between rows vertically
                                                        children: [
                                                          ...List.generate(
                                                            _editLifestylecontroller
                                                                        .selectedHobbiesList
                                                                        .length >
                                                                    4
                                                                ? 4
                                                                : _editLifestylecontroller
                                                                    .selectedHobbiesList
                                                                    .length,
                                                            (index) {
                                                              final item =
                                                                  _editLifestylecontroller
                                                                          .selectedHobbiesList[
                                                                      index];
                                                              return Chip(
                                                                deleteIcon:
                                                                    const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0),
                                                                  child: Icon(
                                                                      Icons
                                                                          .close,
                                                                      size: 12),
                                                                ),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(2),
                                                                labelPadding:
                                                                    const EdgeInsets
                                                                        .all(4),
                                                                backgroundColor:
                                                                    AppTheme
                                                                        .lightPrimaryColor,
                                                                side:
                                                                    const BorderSide(
                                                                  style:
                                                                      BorderStyle
                                                                          .none,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                                label: Text(
                                                                  item.name ??
                                                                      "",
                                                                  style: CustomTextStyle
                                                                      .bodytext
                                                                      .copyWith(
                                                                          fontSize:
                                                                              11),
                                                                ),
                                                                onDeleted: () {
                                                                  _editLifestylecontroller
                                                                      .toggleSelection(
                                                                          item);
                                                                },
                                                              );
                                                            },
                                                          ),
                                                          // Add button as a Chip
                                                          Obx(
                                                            () {
                                                              if (_editLifestylecontroller
                                                                      .selectedHobbiesList
                                                                      .length <=
                                                                  4) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    // Navigate to view all countries
                                                                    _showHobbiesBottomSheet(
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
                                                                    _showHobbiesBottomSheet(
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
                                                                      "(+${_editLifestylecontroller.selectedHobbiesList.length - 4}) ${language == "en" ? "More" : 'अधिक'}",
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
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Obx(
                                            () {
                                              if (_editLifestylecontroller
                                                          .listLengthValidate
                                                          .value ==
                                                      false &&
                                                  _editLifestylecontroller
                                                          .isSubmitted.value ==
                                                      true) {
                                                if (_editLifestylecontroller
                                                        .selectedHobbiesList
                                                        .length <
                                                    2) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 18.0,
                                                            top: 10),
                                                    child: Text(
                                                      "Please select 2 or More Options to Move Forward",
                                                      style: CustomTextStyle
                                                          .errorText,
                                                    ),
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
                                    );
                                  } else {
                                    return CustomTextField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please select $gender hobbies";
                                        }
                                        return null;
                                      },
                                      HintText: language == "en"
                                          ? "Select hobbies"
                                          : "छंद निवडा",
                                      ontap: () {
                                        _showHobbiesBottomSheet(context);
                                      },
                                      readonly: true,
                                    );
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              RichText(
                                  key: _interestKey,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: language == "en"
                                            ? "Interests "
                                            : "आवड",
                                        style: CustomTextStyle.fieldName),
                                    const TextSpan(
                                        text: "*",
                                        style: TextStyle(color: Colors.red))
                                  ])),
                              Obx(
                                () {
                                  if (_editLifestylecontroller
                                      .selectedInterestList.isNotEmpty) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              _showHInterestBottomSheet(
                                                  context);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey.shade300,
                                                    width: 1),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5)),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: ConstrainedBox(
                                                  constraints:
                                                      const BoxConstraints(
                                                          minWidth:
                                                              double.infinity),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Wrap(
                                                        direction:
                                                            Axis.horizontal,

                                                        spacing:
                                                            10, // Spacing between chips horizontally
                                                        runSpacing:
                                                            10, // Spacing between rows vertically
                                                        children: [
                                                          ...List.generate(
                                                            _editLifestylecontroller
                                                                        .selectedInterestList
                                                                        .length >
                                                                    4
                                                                ? 4
                                                                : _editLifestylecontroller
                                                                    .selectedInterestList
                                                                    .length,
                                                            (index) {
                                                              final item =
                                                                  _editLifestylecontroller
                                                                          .selectedInterestList[
                                                                      index];
                                                              return Chip(
                                                                deleteIcon:
                                                                    const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0),
                                                                  child: Icon(
                                                                      Icons
                                                                          .close,
                                                                      size: 12),
                                                                ),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(2),
                                                                labelPadding:
                                                                    const EdgeInsets
                                                                        .all(4),
                                                                backgroundColor:
                                                                    AppTheme
                                                                        .lightPrimaryColor,
                                                                side:
                                                                    const BorderSide(
                                                                  style:
                                                                      BorderStyle
                                                                          .none,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                                label: Text(
                                                                  item.name ??
                                                                      "",
                                                                  style: CustomTextStyle
                                                                      .bodytext
                                                                      .copyWith(
                                                                          fontSize:
                                                                              11),
                                                                ),
                                                                onDeleted: () {
                                                                  _editLifestylecontroller
                                                                      .toggleSelection(
                                                                          item);
                                                                },
                                                              );
                                                            },
                                                          ),
                                                          // Add button as a Chip
                                                          Obx(
                                                            () {
                                                              if (_editLifestylecontroller
                                                                      .selectedInterestList
                                                                      .length <=
                                                                  4) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    // Navigate to view all countries
                                                                    _showHInterestBottomSheet(
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
                                                                    _showHInterestBottomSheet(
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
                                                                      "(+${_editLifestylecontroller.selectedInterestList.length - 4}) ${language == "en" ? "More" : 'अधिक'}",
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
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Obx(
                                            () {
                                              if (_editLifestylecontroller
                                                          .listLengthValidate
                                                          .value ==
                                                      false &&
                                                  _editLifestylecontroller
                                                          .isSubmitted.value ==
                                                      true) {
                                                if (_editLifestylecontroller
                                                        .selectedInterestList
                                                        .length <
                                                    2) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 18.0,
                                                            top: 10),
                                                    child: Text(
                                                      "Please select 2 or More Options to Move Forward",
                                                      style: CustomTextStyle
                                                          .errorText,
                                                    ),
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
                                    );
                                  } else {
                                    return CustomTextField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please select $gender Interests";
                                        }
                                        return null;
                                      },
                                      HintText: language == "en"
                                          ? "Select Interests"
                                          : "आवड निवडा ",
                                      ontap: () {
                                        _showHInterestBottomSheet(context);
                                      },
                                      readonly: true,
                                    );
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              RichText(
                                  key: _dressStyleKey,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: language == "en"
                                            ? "Dress Style "
                                            : "ड्रेस शैली",
                                        style: CustomTextStyle.fieldName),
                                    const TextSpan(
                                        text: "*",
                                        style: TextStyle(color: Colors.red))
                                  ])),
                              Obx(
                                () {
                                  if (_editLifestylecontroller
                                      .selecteddressstyleList.isNotEmpty) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              _showhDressStyleBottomSheet(
                                                  context);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey.shade300,
                                                    width: 1),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5)),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: ConstrainedBox(
                                                  constraints:
                                                      const BoxConstraints(
                                                          minWidth:
                                                              double.infinity),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Wrap(
                                                        direction:
                                                            Axis.horizontal,

                                                        spacing:
                                                            10, // Spacing between chips horizontally
                                                        runSpacing:
                                                            10, // Spacing between rows vertically
                                                        children: [
                                                          ...List.generate(
                                                            _editLifestylecontroller
                                                                        .selecteddressstyleList
                                                                        .length >
                                                                    4
                                                                ? 4
                                                                : _editLifestylecontroller
                                                                    .selecteddressstyleList
                                                                    .length,
                                                            (index) {
                                                              final item =
                                                                  _editLifestylecontroller
                                                                          .selecteddressstyleList[
                                                                      index];
                                                              return Chip(
                                                                deleteIcon:
                                                                    const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0),
                                                                  child: Icon(
                                                                      Icons
                                                                          .close,
                                                                      size: 12),
                                                                ),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(2),
                                                                labelPadding:
                                                                    const EdgeInsets
                                                                        .all(4),
                                                                backgroundColor:
                                                                    AppTheme
                                                                        .lightPrimaryColor,
                                                                side:
                                                                    const BorderSide(
                                                                  style:
                                                                      BorderStyle
                                                                          .none,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                                label: Text(
                                                                  item.name ??
                                                                      "",
                                                                  style: CustomTextStyle
                                                                      .bodytext
                                                                      .copyWith(
                                                                          fontSize:
                                                                              11),
                                                                ),
                                                                onDeleted: () {
                                                                  _editLifestylecontroller
                                                                      .toggleSelectiondressStyle(
                                                                          item);
                                                                },
                                                              );
                                                            },
                                                          ),
                                                          // Add button as a Chip
                                                          Obx(
                                                            () {
                                                              if (_editLifestylecontroller
                                                                      .selecteddressstyleList
                                                                      .length <=
                                                                  4) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    // Navigate to view all countries
                                                                    _showhDressStyleBottomSheet(
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
                                                                    _showhDressStyleBottomSheet(
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
                                                                      "(+${_editLifestylecontroller.selecteddressstyleList.length - 4}) ${language == "en" ? "More" : 'अधिक'}",
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
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Obx(
                                            () {
                                              if (_editLifestylecontroller
                                                          .listLengthValidate
                                                          .value ==
                                                      false &&
                                                  _editLifestylecontroller
                                                          .isSubmitted.value ==
                                                      true) {
                                                if (_editLifestylecontroller
                                                        .selecteddressstyleList
                                                        .length <
                                                    2) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 18.0,
                                                            top: 10),
                                                    child: Text(
                                                      "Please select 2 or More Options to Move Forward",
                                                      style: CustomTextStyle
                                                          .errorText,
                                                    ),
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
                                    );
                                  } else {
                                    return CustomTextField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please select $gender dressstyle";
                                        }
                                        return null;
                                      },
                                      HintText: language == "en"
                                          ? "Select dress style"
                                          : "ड्रेस शैली निवडा",
                                      ontap: () {
                                        _showhDressStyleBottomSheet(context);
                                      },
                                      readonly: true,
                                    );
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              RichText(
                                  key: _sportsKey,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: language == "en"
                                            ? "Sports "
                                            : "खेळ",
                                        style: CustomTextStyle.fieldName),
                                    const TextSpan(
                                        text: "*",
                                        style: TextStyle(color: Colors.red))
                                  ])),
                              Obx(
                                () {
                                  if (_editLifestylecontroller
                                      .selectedSportsList.isNotEmpty) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              _showhSportsBottomSheet(context);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey.shade300,
                                                    width: 1),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5)),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: ConstrainedBox(
                                                  constraints:
                                                      const BoxConstraints(
                                                          minWidth:
                                                              double.infinity),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Wrap(
                                                        direction:
                                                            Axis.horizontal,

                                                        spacing:
                                                            10, // Spacing between chips horizontally
                                                        runSpacing:
                                                            10, // Spacing between rows vertically
                                                        children: [
                                                          ...List.generate(
                                                            _editLifestylecontroller
                                                                        .selectedSportsList
                                                                        .length >
                                                                    4
                                                                ? 4
                                                                : _editLifestylecontroller
                                                                    .selectedSportsList
                                                                    .length,
                                                            (index) {
                                                              final item =
                                                                  _editLifestylecontroller
                                                                          .selectedSportsList[
                                                                      index];
                                                              return Chip(
                                                                deleteIcon:
                                                                    const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0),
                                                                  child: Icon(
                                                                      Icons
                                                                          .close,
                                                                      size: 12),
                                                                ),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(2),
                                                                labelPadding:
                                                                    const EdgeInsets
                                                                        .all(4),
                                                                backgroundColor:
                                                                    AppTheme
                                                                        .lightPrimaryColor,
                                                                side:
                                                                    const BorderSide(
                                                                  style:
                                                                      BorderStyle
                                                                          .none,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                                label: Text(
                                                                  item.name ??
                                                                      "",
                                                                  style: CustomTextStyle
                                                                      .bodytext
                                                                      .copyWith(
                                                                          fontSize:
                                                                              11),
                                                                ),
                                                                onDeleted: () {
                                                                  _editLifestylecontroller
                                                                      .toggleSelectionSports(
                                                                          item);
                                                                },
                                                              );
                                                            },
                                                          ),
                                                          // Add button as a Chip
                                                          Obx(
                                                            () {
                                                              if (_editLifestylecontroller
                                                                      .selectedSportsList
                                                                      .length <=
                                                                  4) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    // Navigate to view all countries
                                                                    _showhSportsBottomSheet(
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
                                                                    _showhSportsBottomSheet(
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
                                                                      "(+${_editLifestylecontroller.selectedSportsList.length - 4}) ${language == "en" ? "More" : 'अधिक'}",
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
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Obx(
                                            () {
                                              if (_editLifestylecontroller
                                                          .listLengthValidate
                                                          .value ==
                                                      false &&
                                                  _editLifestylecontroller
                                                          .isSubmitted.value ==
                                                      true) {
                                                if (_editLifestylecontroller
                                                        .selectedSportsList
                                                        .length <
                                                    2) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 18.0,
                                                            top: 10),
                                                    child: Text(
                                                      "Please select 2 or More Options to Move Forward",
                                                      style: CustomTextStyle
                                                          .errorText,
                                                    ),
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
                                    );
                                  } else {
                                    return CustomTextField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please select $gender favourite sports";
                                        }
                                        return null;
                                      },
                                      HintText: language == "en"
                                          ? "Select Sports"
                                          : "तुमचे आवडते खेळ निवडा",
                                      ontap: () {
                                        _showhSportsBottomSheet(context);
                                      },
                                      readonly: true,
                                    );
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              RichText(
                                  key: _favouriteMusicKey,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: language == "en"
                                            ? "Favourite Music "
                                            : "आवडते संगीत",
                                        style: CustomTextStyle.fieldName),
                                    const TextSpan(
                                        text: "*",
                                        style: TextStyle(color: Colors.red))
                                  ])),
                              Obx(
                                () {
                                  if (_editLifestylecontroller
                                      .selectedMusicList.isNotEmpty) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              _showhMusicBottomSheet(context);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey.shade300,
                                                    width: 1),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5)),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: ConstrainedBox(
                                                  constraints:
                                                      const BoxConstraints(
                                                          minWidth:
                                                              double.infinity),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Wrap(
                                                        direction:
                                                            Axis.horizontal,

                                                        spacing:
                                                            10, // Spacing between chips horizontally
                                                        runSpacing:
                                                            10, // Spacing between rows vertically
                                                        children: [
                                                          ...List.generate(
                                                            _editLifestylecontroller
                                                                        .selectedMusicList
                                                                        .length >
                                                                    4
                                                                ? 4
                                                                : _editLifestylecontroller
                                                                    .selectedMusicList
                                                                    .length,
                                                            (index) {
                                                              final item =
                                                                  _editLifestylecontroller
                                                                          .selectedMusicList[
                                                                      index];
                                                              return Chip(
                                                                deleteIcon:
                                                                    const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0),
                                                                  child: Icon(
                                                                      Icons
                                                                          .close,
                                                                      size: 12),
                                                                ),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(2),
                                                                labelPadding:
                                                                    const EdgeInsets
                                                                        .all(4),
                                                                backgroundColor:
                                                                    AppTheme
                                                                        .lightPrimaryColor,
                                                                side:
                                                                    const BorderSide(
                                                                  style:
                                                                      BorderStyle
                                                                          .none,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                                label: Text(
                                                                  item.name ??
                                                                      "",
                                                                  style: CustomTextStyle
                                                                      .bodytext
                                                                      .copyWith(
                                                                          fontSize:
                                                                              11),
                                                                ),
                                                                onDeleted: () {
                                                                  _editLifestylecontroller
                                                                      .toggleSelectionMusic(
                                                                          item);
                                                                },
                                                              );
                                                            },
                                                          ),
                                                          // Add button as a Chip
                                                          Obx(
                                                            () {
                                                              if (_editLifestylecontroller
                                                                      .selectedMusicList
                                                                      .length <=
                                                                  4) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    // Navigate to view all countries
                                                                    _showhMusicBottomSheet(
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
                                                                    _showhMusicBottomSheet(
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
                                                                      "(+${_editLifestylecontroller.selectedMusicList.length - 4}) ${language == "en" ? "More" : 'अधिक'}",
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
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Obx(
                                            () {
                                              if (_editLifestylecontroller
                                                          .listLengthValidate
                                                          .value ==
                                                      false &&
                                                  _editLifestylecontroller
                                                          .isSubmitted.value ==
                                                      true) {
                                                if (_editLifestylecontroller
                                                        .selectedMusicList
                                                        .length <
                                                    2) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 18.0,
                                                            top: 10),
                                                    child: Text(
                                                      "Please select 2 or More Options to Move Forward",
                                                      style: CustomTextStyle
                                                          .errorText,
                                                    ),
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
                                    );
                                  } else {
                                    return CustomTextField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please select $gender favourite music";
                                        }
                                        return null;
                                      },
                                      HintText: language == "en"
                                          ? "Select Music"
                                          : "आवडते संगीत निवडा",
                                      ontap: () {
                                        _showhMusicBottomSheet(context);
                                      },
                                      readonly: true,
                                    );
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              RichText(
                                key: _favouriteFoodKey,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: language == "en"
                                            ? "Favourite Food "
                                            : "आवडते खाद्यपदार्थ ",
                                        style: CustomTextStyle.fieldName),
                                    const TextSpan(
                                        text: "*",
                                        style: TextStyle(color: Colors.red))
                                  ],
                                ),
                              ),
                              Obx(
                                () {
                                  if (_editLifestylecontroller
                                      .selectedFoodList.isNotEmpty) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              _showhFoodBottomSheet(context);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey.shade300,
                                                    width: 1),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5)),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: ConstrainedBox(
                                                  constraints:
                                                      const BoxConstraints(
                                                          minWidth:
                                                              double.infinity),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Wrap(
                                                        direction:
                                                            Axis.horizontal,

                                                        spacing:
                                                            10, // Spacing between chips horizontally
                                                        runSpacing:
                                                            10, // Spacing between rows vertically
                                                        children: [
                                                          ...List.generate(
                                                            _editLifestylecontroller
                                                                        .selectedFoodList
                                                                        .length >
                                                                    4
                                                                ? 4
                                                                : _editLifestylecontroller
                                                                    .selectedFoodList
                                                                    .length,
                                                            (index) {
                                                              final item =
                                                                  _editLifestylecontroller
                                                                          .selectedFoodList[
                                                                      index];
                                                              return Chip(
                                                                deleteIcon:
                                                                    const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0),
                                                                  child: Icon(
                                                                      Icons
                                                                          .close,
                                                                      size: 12),
                                                                ),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(2),
                                                                labelPadding:
                                                                    const EdgeInsets
                                                                        .all(4),
                                                                backgroundColor:
                                                                    AppTheme
                                                                        .lightPrimaryColor,
                                                                side:
                                                                    const BorderSide(
                                                                  style:
                                                                      BorderStyle
                                                                          .none,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                                label: Text(
                                                                  item.name ??
                                                                      "",
                                                                  style: CustomTextStyle
                                                                      .bodytext
                                                                      .copyWith(
                                                                          fontSize:
                                                                              11),
                                                                ),
                                                                onDeleted: () {
                                                                  _editLifestylecontroller
                                                                      .toggleSelectionFood(
                                                                          item);
                                                                },
                                                              );
                                                            },
                                                          ),
                                                          // Add button as a Chip
                                                          Obx(
                                                            () {
                                                              if (_editLifestylecontroller
                                                                      .selectedFoodList
                                                                      .length <=
                                                                  4) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    // Navigate to view all countries
                                                                    _showhFoodBottomSheet(
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
                                                                    _showhFoodBottomSheet(
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
                                                                      "(+${_editLifestylecontroller.selectedFoodList.length - 4}) ${language == "en" ? "More" : 'अधिक'}",
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
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Obx(
                                            () {
                                              if (_editLifestylecontroller
                                                          .listLengthValidate
                                                          .value ==
                                                      false &&
                                                  _editLifestylecontroller
                                                          .isSubmitted.value ==
                                                      true) {
                                                if (_editLifestylecontroller
                                                        .selectedFoodList
                                                        .length <
                                                    2) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 18.0,
                                                            top: 10),
                                                    child: Text(
                                                      "Please select 2 or More Options to Move Forward",
                                                      style: CustomTextStyle
                                                          .errorText,
                                                    ),
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
                                    );
                                  } else {
                                    return CustomTextField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please select $gender favourite food";
                                        }
                                        return null;
                                      },
                                      HintText: language == "en"
                                          ? "Select Food"
                                          : "आवडते खाद्यपदार्थ निवडा ",
                                      ontap: () {
                                        _showhFoodBottomSheet(context);
                                      },
                                      readonly: true,
                                    );
                                  }
                                },
                              ),
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
                                          onPressed: _editLifestylecontroller
                                                  .isLoading.value
                                              ? null
                                              : () {
                                                  //   print("This is ph number in save ${_stepOneController.phoneNumberController.value.isoCode}");
                                                  // Validation for each field
                                                  //   bool parentsContactValid = _phoneNumberController.value.toString() == "" ? false : true;

                                                  bool isEatingHabitValid =
                                                      _editLifestylecontroller
                                                              .selectedEatingHabit
                                                              .value
                                                              .id !=
                                                          null;
                                                  bool isSmokingHabitValid =
                                                      _editLifestylecontroller
                                                              .selectedSmokingHabit
                                                              .value
                                                              .id !=
                                                          null;
                                                  bool isDrinkingHabitValid =
                                                      _editLifestylecontroller
                                                              .selectedDrinkingHabit
                                                              .value
                                                              .id !=
                                                          null;
                                                  bool islanguagesValid =
                                                      _editLifestylecontroller
                                                              .selectedLanguages
                                                              .length >=
                                                          2;
                                                  bool ishobbiesValid =
                                                      _editLifestylecontroller
                                                              .selectedHobbiesList
                                                              .length >=
                                                          2;
                                                  bool isInterestValid =
                                                      _editLifestylecontroller
                                                              .selectedInterestList
                                                              .length >=
                                                          2;
                                                  bool isdressStyleValid =
                                                      _editLifestylecontroller
                                                              .selecteddressstyleList
                                                              .length >=
                                                          2;
                                                  bool isSportsValid =
                                                      _editLifestylecontroller
                                                              .selectedSportsList
                                                              .length >=
                                                          2;
                                                  bool isMusicValid =
                                                      _editLifestylecontroller
                                                              .selectedMusicList
                                                              .length >=
                                                          2;
                                                  bool isFoodValid =
                                                      _editLifestylecontroller
                                                              .selectedFoodList
                                                              .length >=
                                                          2;

                                                  // Children validation based on marital status

                                                  _editLifestylecontroller
                                                      .selectedEatingHabitValidated
                                                      .value = isEatingHabitValid;
                                                  _editLifestylecontroller
                                                      .selectedSmokingHabitValidated
                                                      .value = isSmokingHabitValid;
                                                  _editLifestylecontroller
                                                      .selectedDrinkingHabitValidated
                                                      .value = isDrinkingHabitValid;

                                                  // Set submitted state
                                                  _editLifestylecontroller
                                                      .isSubmitted.value = true;

                                                  // Validate form
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    // Check if all validations are passed
                                                    if (!isEatingHabitValid ||
                                                            !isSmokingHabitValid ||
                                                            !isDrinkingHabitValid ||
                                                            !islanguagesValid ||
                                                            !ishobbiesValid ||
                                                            !isInterestValid ||
                                                            !isdressStyleValid ||
                                                            !isSportsValid ||
                                                            !isMusicValid ||
                                                            !isFoodValid

                                                        //    !parentsContactValid ||
                                                        ) {
                                                      if (!isEatingHabitValid) {
                                                        _scrollToWidget(
                                                            _dietryHabitKey);
                                                      } else if (!isSmokingHabitValid) {
                                                        _scrollToWidget(
                                                            _SmokingHabitKey);
                                                      } else if (!isDrinkingHabitValid) {
                                                        _scrollToWidget(
                                                            _DrinkingHabitKey);
                                                      } else if (!islanguagesValid) {
                                                        _scrollToWidget(
                                                            _languageKnown);
                                                      } else if (_editLifestylecontroller
                                                              .selectedMotherTongue
                                                              .value
                                                              .id ==
                                                          null) {
                                                        _scrollToWidget(
                                                            _motherTongueKey);
                                                      }
                                                      // mother tongue
                                                      else if (!ishobbiesValid) {
                                                        _scrollToWidget(
                                                            _hobbiesKey);
                                                      } else if (!isInterestValid) {
                                                        _scrollToWidget(
                                                            _interestKey);
                                                      } else if (!isdressStyleValid) {
                                                        _scrollToWidget(
                                                            _dressStyleKey);
                                                      } else if (!isSportsValid) {
                                                        _scrollToWidget(
                                                            _sportsKey);
                                                      } else if (!isMusicValid) {
                                                        _scrollToWidget(
                                                            _favouriteMusicKey);
                                                      } else if (!isFoodValid) {
                                                        _scrollToWidget(
                                                            _favouriteFoodKey);
                                                      }
                                                      // Show error message if validation fails
                                                      //  Get.snackbar("Error", "Please fill all required fields");
                                                    } else {
                                                      // Start loading state
                                                      _editLifestylecontroller
                                                          .isLoading
                                                          .value = true;

                                                      // API call
                                                      _editLifestylecontroller
                                                          .BasicForm(
                                                        dressStyle: _editLifestylecontroller
                                                            .selecteddressstyleList
                                                            .where((field) =>
                                                                field.id !=
                                                                null) // Filter out null ids
                                                            .map((field) =>
                                                                field.id!)
                                                            .toList(),
                                                        food: _editLifestylecontroller
                                                            .selectedFoodList
                                                            .where((field) =>
                                                                field.id !=
                                                                null) // Filter out null ids
                                                            .map((field) =>
                                                                field.id!)
                                                            .toList(),
                                                        hobbies: _editLifestylecontroller
                                                            .selectedHobbiesList
                                                            .where((field) =>
                                                                field.id !=
                                                                null) // Filter out null ids
                                                            .map((field) =>
                                                                field.id!)
                                                            .toList(),
                                                        interest: _editLifestylecontroller
                                                            .selectedInterestList
                                                            .where((field) =>
                                                                field.id !=
                                                                null) // Filter out null ids
                                                            .map((field) =>
                                                                field.id!)
                                                            .toList(),
                                                        languagesKnown:
                                                            _editLifestylecontroller
                                                                .selectedLanguages
                                                                .where((field) =>
                                                                    field.id !=
                                                                    null) // Filter out null ids
                                                                .map((field) =>
                                                                    field.id!)
                                                                .toList(),
                                                        music: _editLifestylecontroller
                                                            .selectedMusicList
                                                            .where((field) =>
                                                                field.id !=
                                                                null) // Filter out null ids
                                                            .map((field) =>
                                                                field.id!)
                                                            .toList(),
                                                        sports: _editLifestylecontroller
                                                            .selectedSportsList
                                                            .where((field) =>
                                                                field.id !=
                                                                null) // Filter out null ids
                                                            .map((field) =>
                                                                field.id!)
                                                            .toList(),
                                                        motherTongue:
                                                            _editLifestylecontroller
                                                                    .selectedMotherTongue
                                                                    .value
                                                                    .id ??
                                                                0,
                                                        dietryHabits:
                                                            _editLifestylecontroller
                                                                    .selectedEatingHabit
                                                                    .value
                                                                    .id ??
                                                                0,
                                                        smokingHabits:
                                                            _editLifestylecontroller
                                                                    .selectedSmokingHabit
                                                                    .value
                                                                    .id ??
                                                                0,
                                                        drinkingHabits:
                                                            _editLifestylecontroller
                                                                    .selectedDrinkingHabit
                                                                    .value
                                                                    .id ??
                                                                0,
                                                      ).then((result) {
                                                        // Reset loading state
                                                        _editLifestylecontroller
                                                            .isLoading
                                                            .value = false;
                                                        // Handle successful result (optional)
                                                      }).catchError((error) {
                                                        // Handle error and reset loading state
                                                        _editLifestylecontroller
                                                            .isLoading
                                                            .value = false;
                                                        print("Error: $error");
                                                      });
                                                    }
                                                  } else {
                                                    // Show error if form validation fails
                                                    //   Get.snackbar("Error", "Please Fill all required Fields");
                                                    /*   !isEatingHabitValid ||
                             !isSmokingHabitValid ||
                             !isDrinkingHabitValid || 
                             !islanguagesValid || 
                             !ishobbiesValid || 
                             !isInterestValid || 
                             !isdressStyleValid || 
                             !isSportsValid || 
                             !isMusicValid || 
                             !isFoodValid*/
                                                    if (!isEatingHabitValid) {
                                                      _scrollToWidget(
                                                          _dietryHabitKey);
                                                    } else if (!isSmokingHabitValid) {
                                                      _scrollToWidget(
                                                          _SmokingHabitKey);
                                                    } else if (!isDrinkingHabitValid) {
                                                      _scrollToWidget(
                                                          _DrinkingHabitKey);
                                                    } else if (!islanguagesValid) {
                                                      _scrollToWidget(
                                                          _languageKnown);
                                                    } else if (_editLifestylecontroller
                                                            .selectedMotherTongue
                                                            .value
                                                            .id ==
                                                        null) {
                                                      _scrollToWidget(
                                                          _motherTongueKey);
                                                    }
                                                    // mother tongue
                                                    else if (!ishobbiesValid) {
                                                      _scrollToWidget(
                                                          _hobbiesKey);
                                                    } else if (!isInterestValid) {
                                                      _scrollToWidget(
                                                          _interestKey);
                                                    } else if (!isdressStyleValid) {
                                                      _scrollToWidget(
                                                          _dressStyleKey);
                                                    } else if (!isSportsValid) {
                                                      _scrollToWidget(
                                                          _sportsKey);
                                                    } else if (!isMusicValid) {
                                                      _scrollToWidget(
                                                          _favouriteMusicKey);
                                                    } else if (!isFoodValid) {
                                                      _scrollToWidget(
                                                          _favouriteFoodKey);
                                                    }
                                                  }
                                                },
                                          child: _editLifestylecontroller
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

  void _showMotherTongueBottomSheet(BuildContext context) {
    // Access the ZodiacController
    final EditLifestylecontroller editLifestyleController =
        Get.find<EditLifestylecontroller>();
    String? language = sharedPreferences?.getString("Language");

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
                        ? "Select Mother Tongue"
                        : "मातृभाषा निवडा",
                    style: CustomTextStyle.bodytextboldLarge),
                const SizedBox(height: 10),

                // Dynamic list of zodiac signs from the controller
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: editLifestyleController.motherTongueList
                      .map((FieldModel sign) {
                    return Obx(() {
                      // Only this part rebuilds when the selectedZodiacSign value changes
                      final isSelected = editLifestyleController
                              .selectedMotherTongue.value.id ==
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
                            //  _editLifestyleController(sign);
                            editLifestyleController.updateMotherTongue(sign);
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

  void _showhDressStyleBottomSheet(BuildContext context) {
    final EditLifestylecontroller hobbiesController =
        Get.put(EditLifestylecontroller());
    String? language = sharedPreferences?.getString("Language");

    // Fetch hobbies data when modal opens
    hobbiesController.fetchdressStyleFromApi();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
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
                      ? "Select Your Dress style"
                      : "ड्रेस शैली निवडा",
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
                        ? "Search dress Style..."
                        : 'ड्रेस शैली शोधा',
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
                    hobbiesController.filterdressStyle(query);
                  },
                ),
                const SizedBox(height: 10),

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
                            hobbiesController.allSelecteddressstyle.value
                                ? AppLocalizations.of(context)!.deselectall
                                : AppLocalizations.of(context)!.selectall,
                            // ? "Deselect All"
                            // : "Select All",
                            style: CustomTextStyle.bodytext.copyWith(
                              fontSize: 14,
                              color:
                                  hobbiesController.allSelecteddressstyle.value
                                      ? Colors.white
                                      : AppTheme.secondryColor,
                            ),
                          ),
                          selected:
                              hobbiesController.allSelecteddressstyle.value,
                          onSelected: (bool selected) {
                            hobbiesController
                                .toggleSelectAllDressStyle(); // Toggle all hobbies as selected/deselected
                          },
                          selectedColor: AppTheme.selectedOptionColor,
                          backgroundColor: AppTheme.lightPrimaryColor,
                          labelStyle: CustomTextStyle.bodytext.copyWith(
                            fontSize: 14,
                            color: hobbiesController.allSelected.value
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
                    if (hobbiesController.isloadingdressstyle.value) {
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

                    if (hobbiesController.filteredDressStyleList.isEmpty) {
                      return const Center(child: Text('No data found'));
                    }

                    // Display filtered list of items in ChoiceChips
                    return SingleChildScrollView(
                      child: Wrap(
                        spacing: 5,
                        runSpacing: 10,
                        children: hobbiesController.filteredDressStyleList
                            .map((FieldModel item) {
                          final isSelected = hobbiesController
                              .selecteddressstyleList
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
                              hobbiesController.toggleSelectiondressStyle(item);
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

  void _showhFoodBottomSheet(BuildContext context) {
    final EditLifestylecontroller hobbiesController =
        Get.put(EditLifestylecontroller());
    String? language = sharedPreferences?.getString("Language");

    // Fetch hobbies data when modal opens
    hobbiesController.fetchFoodFromApi();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
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
                      ? "Select Your favoured Food"
                      : 'आवडते खाद्यपदार्थ निवडा',
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
                        ? "Search Food..."
                        : "आवडते खाद्यपदार्थ शोधा ",
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
                    hobbiesController.filterFood(query);
                  },
                ),
                const SizedBox(height: 10),

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
                            hobbiesController.allSelectedFood.value
                                ? AppLocalizations.of(context)!.deselectall
                                : AppLocalizations.of(context)!.selectall,
                            style: CustomTextStyle.bodytext.copyWith(
                              fontSize: 14,
                              color: hobbiesController.allSelectedFood.value
                                  ? Colors.white
                                  : AppTheme.secondryColor,
                            ),
                          ),
                          selected: hobbiesController.allSelectedFood.value,
                          onSelected: (bool selected) {
                            hobbiesController
                                .toggleSelectAllFood(); // Toggle all hobbies as selected/deselected
                          },
                          selectedColor: AppTheme.selectedOptionColor,
                          backgroundColor: AppTheme.lightPrimaryColor,
                          labelStyle: CustomTextStyle.bodytext.copyWith(
                            fontSize: 14,
                            color: hobbiesController.allSelected.value
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
                    if (hobbiesController.isloadingFood.value) {
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

                    if (hobbiesController.filteredFoodList.isEmpty) {
                      return const Center(child: Text('No data found'));
                    }

                    // Display filtered list of items in ChoiceChips
                    return SingleChildScrollView(
                      child: Wrap(
                        spacing: 5,
                        runSpacing: 10,
                        children: hobbiesController.filteredFoodList
                            .map((FieldModel item) {
                          final isSelected = hobbiesController.selectedFoodList
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
                              hobbiesController.toggleSelectionFood(item);
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

  void _showhMusicBottomSheet(BuildContext context) {
    final EditLifestylecontroller hobbiesController =
        Get.put(EditLifestylecontroller());
    String? language = sharedPreferences?.getString("Language");
    // Fetch hobbies data when modal opens
    hobbiesController.fetchMusicFromApi();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
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
                      ? "Select Your favoured Music"
                      : "आवडते संगीत निवडा ",
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
                        ? "Search Music..."
                        : "आवडते संगीत शोधा...",
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
                    hobbiesController.filterMusic(query);
                  },
                ),
                const SizedBox(height: 10),

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
                            hobbiesController.allSelectedMusic.value
                                ? AppLocalizations.of(context)!.deselectall
                                : AppLocalizations.of(context)!.selectall,
                            style: CustomTextStyle.bodytext.copyWith(
                              fontSize: 14,
                              color: hobbiesController.allSelectedMusic.value
                                  ? Colors.white
                                  : AppTheme.secondryColor,
                            ),
                          ),
                          selected: hobbiesController.allSelectedMusic.value,
                          onSelected: (bool selected) {
                            hobbiesController
                                .toggleSelectAllMusic(); // Toggle all hobbies as selected/deselected
                          },
                          selectedColor: AppTheme.selectedOptionColor,
                          backgroundColor: AppTheme.lightPrimaryColor,
                          labelStyle: CustomTextStyle.bodytext.copyWith(
                            fontSize: 14,
                            color: hobbiesController.allSelected.value
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
                    if (hobbiesController.isloadingMusic.value) {
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

                    if (hobbiesController.filteredMusicList.isEmpty) {
                      return const Center(child: Text('No data found'));
                    }

                    // Display filtered list of items in ChoiceChips
                    return SingleChildScrollView(
                      child: Wrap(
                        spacing: 5,
                        runSpacing: 10,
                        children: hobbiesController.filteredMusicList
                            .map((FieldModel item) {
                          final isSelected = hobbiesController.selectedMusicList
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
                              hobbiesController.toggleSelectionMusic(item);
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

  void _showhSportsBottomSheet(BuildContext context) {
    final EditLifestylecontroller hobbiesController =
        Get.put(EditLifestylecontroller());
    String? language = sharedPreferences?.getString("Language");
    // Fetch hobbies data when modal opens
    hobbiesController.fetchSportsFromApi();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
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
                      ? "Select Your favoured Sports"
                      : "तुमचे आवडते खेळ निवडा ",
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
                        ? "Search Sports..."
                        : "आवडते खेळ शोधा",
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
                    hobbiesController.filterSports(query);
                  },
                ),
                const SizedBox(height: 10),

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
                            hobbiesController.allSelectedSports.value
                                ? AppLocalizations.of(context)!.deselectall
                                : AppLocalizations.of(context)!.selectall,
                            style: CustomTextStyle.bodytext.copyWith(
                              fontSize: 14,
                              color: hobbiesController.allSelectedSports.value
                                  ? Colors.white
                                  : AppTheme.secondryColor,
                            ),
                          ),
                          selected: hobbiesController.allSelectedSports.value,
                          onSelected: (bool selected) {
                            hobbiesController
                                .toggleSelectAllSports(); // Toggle all hobbies as selected/deselected
                          },
                          selectedColor: AppTheme.selectedOptionColor,
                          backgroundColor: AppTheme.lightPrimaryColor,
                          labelStyle: CustomTextStyle.bodytext.copyWith(
                            fontSize: 14,
                            color: hobbiesController.allSelected.value
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
                    if (hobbiesController.isloadingSports.value) {
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

                    if (hobbiesController.filteredSportsList.isEmpty) {
                      return const Center(child: Text('No data found'));
                    }

                    // Display filtered list of items in ChoiceChips
                    return SingleChildScrollView(
                      child: Wrap(
                        spacing: 5,
                        runSpacing: 10,
                        children: hobbiesController.filteredSportsList
                            .map((FieldModel item) {
                          final isSelected = hobbiesController
                              .selectedSportsList
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
                              hobbiesController.toggleSelectionSports(item);
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

  void _showHInterestBottomSheet(BuildContext context) {
    final EditLifestylecontroller hobbiesController =
        Get.put(EditLifestylecontroller());
    String? language = sharedPreferences?.getString("Language");
    // Fetch hobbies data when modal opens
    hobbiesController.fetchInterestFromApi();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  language == "en" ? "Select Your Interests" : "आवड निवडा ",
                  style: CustomTextStyle.bodytextboldLarge,
                ),
                const SizedBox(height: 10),

                // Search TextField
                TextField(
                  decoration: InputDecoration(
                    errorMaxLines: 5,
                    errorStyle: CustomTextStyle.errorText,
                    labelStyle: CustomTextStyle.bodytext,
                    hintText:
                        language == "en" ? "Search Interest..." : "आवड शोधा...",
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
                    hobbiesController.filterInterests(query);
                  },
                ),
                const SizedBox(height: 10),

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
                            hobbiesController.allSelectedInterest.value
                                ? AppLocalizations.of(context)!.deselectall
                                : AppLocalizations.of(context)!.selectall,
                            style: CustomTextStyle.bodytext.copyWith(
                              fontSize: 14,
                              color: hobbiesController.allSelectedInterest.value
                                  ? Colors.white
                                  : AppTheme.secondryColor,
                            ),
                          ),
                          selected: hobbiesController.allSelectedInterest.value,
                          onSelected: (bool selected) {
                            hobbiesController
                                .toggleSelectAllInterest(); // Toggle all hobbies as selected/deselected
                          },
                          selectedColor: AppTheme.selectedOptionColor,
                          backgroundColor: AppTheme.lightPrimaryColor,
                          labelStyle: CustomTextStyle.bodytext.copyWith(
                            fontSize: 14,
                            color: hobbiesController.allSelected.value
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
                    if (hobbiesController.isloadinginterests.value) {
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

                    if (hobbiesController.filteredInterestsList.isEmpty) {
                      return const Center(child: Text('No data found'));
                    }

                    // Display filtered list of items in ChoiceChips
                    return SingleChildScrollView(
                      child: Wrap(
                        spacing: 5,
                        runSpacing: 10,
                        children: hobbiesController.filteredInterestsList
                            .map((FieldModel item) {
                          final isSelected = hobbiesController
                              .selectedInterestList
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
                              hobbiesController.toggleSelectionInterest(item);
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

  void _showHobbiesBottomSheet(BuildContext context) {
    final EditLifestylecontroller hobbiesController =
        Get.put(EditLifestylecontroller());
    String? language = sharedPreferences?.getString("Language");
    // Fetch hobbies data when modal opens
    hobbiesController.fetchhobbiesFromApi();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  language == "en" ? "Select Your Hobbies" : "छंद निवडा",
                  style: CustomTextStyle.bodytextboldLarge,
                ),
                const SizedBox(height: 10),

                // Search TextField
                TextField(
                  decoration: InputDecoration(
                    errorMaxLines: 5,
                    errorStyle: CustomTextStyle.errorText,
                    labelStyle: CustomTextStyle.bodytext,
                    hintText:
                        language == "en" ? "Search hobbies..." : "छंद शोधा...",
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
                    hobbiesController.filterHobbies(query);
                  },
                ),
                const SizedBox(height: 10),

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
                            hobbiesController.allSelected.value
                                ? AppLocalizations.of(context)!.deselectall
                                : AppLocalizations.of(context)!.selectall,
                            style: CustomTextStyle.bodytext.copyWith(
                              fontSize: 14,
                              color: hobbiesController.allSelected.value
                                  ? Colors.white
                                  : AppTheme.secondryColor,
                            ),
                          ),
                          selected: hobbiesController.allSelected.value,
                          onSelected: (bool selected) {
                            hobbiesController
                                .toggleSelectAll(); // Toggle all hobbies as selected/deselected
                          },
                          selectedColor: AppTheme.selectedOptionColor,
                          backgroundColor: AppTheme.lightPrimaryColor,
                          labelStyle: CustomTextStyle.bodytext.copyWith(
                            fontSize: 14,
                            color: hobbiesController.allSelected.value
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
                    if (hobbiesController.isloadingHobbies.value) {
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

                    if (hobbiesController.filteredHobbiesList.isEmpty) {
                      return const Center(child: Text('No data found'));
                    }

                    // Display filtered list of items in ChoiceChips
                    return SingleChildScrollView(
                      child: Wrap(
                        spacing: 5,
                        runSpacing: 10,
                        children: hobbiesController.filteredHobbiesList
                            .map((FieldModel item) {
                          final isSelected = hobbiesController
                              .selectedHobbiesList
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
                              hobbiesController.toggleSelectionHobbies(item);
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

  void _showLanguageSelectBottomSheet(BuildContext context) {
    String? language = sharedPreferences?.getString("Language");
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
                        ? "Select Known Languages"
                        : "ज्ञात भाषा निवडा",
                    style: CustomTextStyle.bodytextboldLarge),
                const SizedBox(height: 10),
                Obx(
                  () {
                    // Show shimmer effect while data is being loaded
                    final isAllSelected =
                        _editLifestylecontroller.languagesList.length ==
                            _editLifestylecontroller.selectedLanguages.length;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // "Select All" chip at the top
                        ChoiceChip(
                          labelPadding: const EdgeInsets.all(4),
                          label: Text(
                            // "Select All",
                            AppLocalizations.of(context)!.selectall,
                            style: CustomTextStyle.bodytext.copyWith(
                              fontSize: 14,
                              color: isAllSelected
                                  ? Colors.white
                                  : AppTheme.secondryColor,
                            ),
                          ),
                          selected: isAllSelected,
                          onSelected: (bool selected) {
                            if (selected) {
                              _editLifestylecontroller.selectAllItems();
                            } else {
                              _editLifestylecontroller.clearAllSelections();
                            }
                          },
                          selectedColor: AppTheme.selectedOptionColor,
                          backgroundColor: AppTheme.lightPrimaryColor,
                          labelStyle: CustomTextStyle.bodytext.copyWith(
                            fontSize: 14,
                            color: isAllSelected
                                ? Colors.white
                                : AppTheme.secondryColor,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Display the actual data once loaded
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _editLifestylecontroller.languagesList
                              .map((item) {
                            final isSelected = _editLifestylecontroller
                                .selectedLanguages
                                .any((selectedItem) =>
                                    selectedItem.id == item.id);
                            return ChoiceChip(
                              labelPadding: const EdgeInsets.all(4),
                              checkmarkColor: Colors.white,
                              backgroundColor: AppTheme.lightPrimaryColor,
                              label: Text(
                                item.name ?? "",
                                style: CustomTextStyle.bodytext.copyWith(
                                  fontSize: 14,
                                  color: isSelected
                                      ? Colors.white
                                      : AppTheme.secondryColor,
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (bool selected) {
                                _editLifestylecontroller.toggleSelection(item);
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
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
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
