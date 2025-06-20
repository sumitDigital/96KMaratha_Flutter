import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/editforms_controllers/editPersonalInfoController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:_96kuliapp/screens/profile_screens/edit_profile.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/backheader.dart';
import 'package:_96kuliapp/utils/buttonContainer.dart';
import 'package:_96kuliapp/utils/customtextform.dart';
import 'package:shimmer/shimmer.dart';

class EditPersonalInfoScreen extends StatefulWidget {
  const EditPersonalInfoScreen({super.key});

  @override
  State<EditPersonalInfoScreen> createState() => _EditPersonalInfoScreenState();
}

class _EditPersonalInfoScreenState extends State<EditPersonalInfoScreen> {
  //final Rascontroller _rascontroller = Get.put(Rascontroller());

  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String locationText = "";

  TimeOfDay selectedTime = TimeOfDay.now();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormFieldState> _timeFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _placeofbirthKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _rasKey = GlobalKey<FormFieldState>();

  final GlobalKey<FormFieldState> _heightKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _bloodeGroupKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _disabilityKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _maritialStatusKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _complexionKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _lensKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _spectaclesKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _weightKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _childrenKey = GlobalKey<FormFieldState>();

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

  String? language = sharedPreferences?.getString("Language");

  late String gender;
  String? gender2;
  String? gender3;
  String? gender4;

  final mybox = Hive.box('myBox');

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
        gender3 = "वराचे";
        gender4 = "वराला ";
        return "वराची";
      } else {
        gender2 = "वधूचा";
        gender3 = "वधूचे";
        gender4 = "वधूला";

        return "वधूची";
      }
    }
  }

  @override
  void initState() {
    super.initState(); // Call the superclass's method
    gender = selectgender();
  }

  final EditPersonalInfoController _editPersonalInfoScreen =
      Get.put(EditPersonalInfoController());
  @override
  Widget build(BuildContext context) {
    /*  Get.delete<MyProfileController>();
    Get.delete<EditPersonalInfoController>();

    // Replace the current page with a new page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => EditProfile()),
    );*/
    // Returning false prevents the default back navigation

    return Scaffold(
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
                  gender3 = "वराचे";
                  gender4 = "वराला ";
                  return "वराची";
                } else {
                  gender2 = "वधूचा";
                  gender3 = "वधूचे";
                  gender4 = "वधूला";
                  return "वधूची";
                }
              }
            }

            gender = selectgender();
            if (_editPersonalInfoScreen.isPageLoading.value == true) {
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
                        title: AppLocalizations.of(context)!.editPersonalInfo),

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
                      title: AppLocalizations.of(context)!.editPersonalInfo),

                  // const StepsFormHeader(title: "Update Your Basic Information", desc: "Begin your journey to finding your soulmate by sharing your basic details. It's quick and effortless" , image: "assets/formstep1.png", statusPercent: "20%", statusdesc: "Submit this form to boost your profile visibility by",),
                  //    const StepsFormHeader(title: "Update Your Basic Information", desc: "Finding your Perfect soulmate is just a step away" , image: "assets/formstep1.png", statusPercent: "20%", statusdesc: "Update profile & boost visibility by",),

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
                                ])),
                            Obx(
                              () {
                                final TextEditingController maxage =
                                    TextEditingController(
                                        text: _editPersonalInfoScreen
                                            .selectedHeight.value?.name);
                                return CustomTextField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return language == "en"
                                          ? 'Please select $gender height'
                                          : "कृपया $gender उंची निवडा";
                                    }
                                    return null;
                                  },
                                  readonly: true,
                                  textEditingController: maxage,
                                  HintText: language == "en"
                                      ? "Select Height"
                                      : "$gender उंची टाका",
                                  ontap: () {
                                    _editPersonalInfoScreen
                                            .searchedHeightList.value =
                                        _editPersonalInfoScreen.heightInFeet;

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
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0, top: 8),
                                                  child: TextField(
                                                    decoration: InputDecoration(
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
                                                      _editPersonalInfoScreen
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
                                                            Radius.circular(5)),
                                                    color: Colors.white,
                                                  ),
                                                  height:
                                                      400, // Set a height for the list inside the dialog
                                                  child: Obx(() {
                                                    return ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          _editPersonalInfoScreen
                                                              .searchedHeightList
                                                              .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        final item =
                                                            _editPersonalInfoScreen
                                                                    .searchedHeightList[
                                                                index];
                                                        bool isSelected =
                                                            _editPersonalInfoScreen
                                                                    .selectedHeight
                                                                    .value
                                                                    ?.id ==
                                                                item.id;

                                                        return GestureDetector(
                                                          onTap: () {
                                                            // Update the selected value and close the dialog
                                                            _editPersonalInfoScreen
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
                                key: _bloodeGroupKey,
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
                                        text: _editPersonalInfoScreen
                                            .selectedBloodGroup.value?.name);
                                return CustomTextField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select $gender blood group';
                                    }
                                    return null;
                                  },
                                  readonly: true,
                                  textEditingController: maxage,
                                  HintText: "Select Blood Group ",
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
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
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
                                                          _editPersonalInfoScreen
                                                              .bloodGroups
                                                              .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        final item =
                                                            _editPersonalInfoScreen
                                                                    .bloodGroups[
                                                                index];
                                                        bool isSelected =
                                                            _editPersonalInfoScreen
                                                                    .selectedBloodGroup
                                                                    .value
                                                                    ?.id ==
                                                                item.id;

                                                        return GestureDetector(
                                                          onTap: () {
                                                            // Update the selected value and close the dialog
                                                            _editPersonalInfoScreen
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
                                key: _disabilityKey,
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .disability,
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
                                        _editPersonalInfoScreen
                                            .updatePhysicalStatus(
                                                FieldModel(id: 2, name: "yes"));
                                      },
                                      child: CustomContainer(
                                        textColor: _editPersonalInfoScreen
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
                                        color: _editPersonalInfoScreen
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
                                        _editPersonalInfoScreen
                                            .updatePhysicalStatus(
                                                FieldModel(id: 1, name: "no"));
                                      },
                                      child: CustomContainer(
                                        textColor: _editPersonalInfoScreen
                                                    .selectedPhysicalStatus
                                                    .value
                                                    .id ==
                                                1
                                            ? Colors.white
                                            : null,
                                        height: 60,
                                        title: AppLocalizations.of(context)!.no,
                                        width: 89,
                                        color: _editPersonalInfoScreen
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
                                if (_editPersonalInfoScreen
                                            .selectedPhysicalStatusValidated
                                            .value ==
                                        false &&
                                    _editPersonalInfoScreen.isSubmitted.value ==
                                        true) {
                                  if (_editPersonalInfoScreen
                                          .selectedPhysicalStatus.value.id ==
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
                                              const EdgeInsets.only(left: 18.0),
                                          child: Text(
                                            "Please select $gender physical status",
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
                            Obx(
                              () {
                                if (_editPersonalInfoScreen
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
                                          _editPersonalInfoScreen
                                              .physicalStatus,
                                      HintText: "Explain Desability");
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            RichText(
                                key: _maritialStatusKey,
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .maritalstatus,
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
                                          _editPersonalInfoScreen
                                              .updateMaritalStatus(FieldModel(
                                                  id: 1,
                                                  name: "Never Married"));
                                          _editPersonalInfoScreen
                                              .numberchilren.text = "";
                                          _editPersonalInfoScreen
                                              .selectedChildren.value.id = 0;
                                        },
                                        child: CustomContainer(
                                          height: 60,
                                          title: AppLocalizations.of(context)!
                                              .neverMarried,
                                          width: 122,
                                          color: _editPersonalInfoScreen
                                                      .selectedMaritalStatus
                                                      .value
                                                      .id ==
                                                  1
                                              ? AppTheme.selectedOptionColor
                                              : null,
                                          textColor: _editPersonalInfoScreen
                                                      .selectedMaritalStatus
                                                      .value
                                                      .id ==
                                                  1
                                              ? Colors.white
                                              : null,
                                        )),
                                    GestureDetector(
                                        onTap: () {
                                          _editPersonalInfoScreen
                                              .updateMaritalStatus(FieldModel(
                                                  id: 3, name: "Divorced"));
                                        },
                                        child: CustomContainer(
                                          height: 60,
                                          title: AppLocalizations.of(context)!
                                              .divorced,
                                          width: 105,
                                          color: _editPersonalInfoScreen
                                                      .selectedMaritalStatus
                                                      .value
                                                      .id ==
                                                  3
                                              ? AppTheme.selectedOptionColor
                                              : null,
                                          textColor: _editPersonalInfoScreen
                                                      .selectedMaritalStatus
                                                      .value
                                                      .id ==
                                                  3
                                              ? Colors.white
                                              : null,
                                        )),
                                    GestureDetector(
                                        onTap: () {
                                          _editPersonalInfoScreen
                                              .updateMaritalStatus(FieldModel(
                                                  id: 5, name: "Seprated"));
                                        },
                                        child: CustomContainer(
                                          height: 60,
                                          title: AppLocalizations.of(context)!
                                              .separated,
                                          width: 105,
                                          color: _editPersonalInfoScreen
                                                      .selectedMaritalStatus
                                                      .value
                                                      .id ==
                                                  5
                                              ? AppTheme.selectedOptionColor
                                              : null,
                                          textColor: _editPersonalInfoScreen
                                                      .selectedMaritalStatus
                                                      .value
                                                      .id ==
                                                  5
                                              ? Colors.white
                                              : null,
                                        )),
                                    GestureDetector(
                                        onTap: () {
                                          _editPersonalInfoScreen
                                              .updateMaritalStatus(FieldModel(
                                                  id: 4,
                                                  name: "Awaiting Response"));
                                        },
                                        child: CustomContainer(
                                          height: 60,
                                          title: AppLocalizations.of(context)!
                                              .awaitingresponse,
                                          width: 155,
                                          color: _editPersonalInfoScreen
                                                      .selectedMaritalStatus
                                                      .value
                                                      .id ==
                                                  4
                                              ? AppTheme.selectedOptionColor
                                              : null,
                                          textColor: _editPersonalInfoScreen
                                                      .selectedMaritalStatus
                                                      .value
                                                      .id ==
                                                  4
                                              ? Colors.white
                                              : null,
                                        )),
                                    GestureDetector(
                                        onTap: () {
                                          _editPersonalInfoScreen
                                              .updateMaritalStatus(FieldModel(
                                                  id: 2, name: "Widow"));
                                        },
                                        child: CustomContainer(
                                          height: 60,
                                          title: AppLocalizations.of(context)!
                                              .widoworwidower,
                                          width: 144,
                                          color: _editPersonalInfoScreen
                                                      .selectedMaritalStatus
                                                      .value
                                                      .id ==
                                                  2
                                              ? AppTheme.selectedOptionColor
                                              : null,
                                          textColor: _editPersonalInfoScreen
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
                                if (_editPersonalInfoScreen
                                            .selectedMaritialStatusValidated
                                            .value ==
                                        false &&
                                    _editPersonalInfoScreen.isSubmitted.value ==
                                        true) {
                                  if (_editPersonalInfoScreen
                                          .selectedMaritalStatus.value.id ==
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
                                              const EdgeInsets.only(left: 18.0),
                                          child: Text(
                                            "Please select $gender marital status",
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
                            Obx(
                              () {
                                if (_editPersonalInfoScreen.selectedMaritalStatus.value.id == 2 ||
                                    _editPersonalInfoScreen
                                            .selectedMaritalStatus.value.id ==
                                        3 ||
                                    _editPersonalInfoScreen
                                            .selectedMaritalStatus.value.id ==
                                        4 ||
                                    _editPersonalInfoScreen
                                            .selectedMaritalStatus.value.id ==
                                        5) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                          key: _childrenKey,
                                          text: TextSpan(children: <TextSpan>[
                                            TextSpan(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .haveChildren,
                                                style:
                                                    CustomTextStyle.fieldName),
                                            const TextSpan(
                                                text: "*",
                                                style: TextStyle(
                                                    color: Colors.red))
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
                                              _editPersonalInfoScreen
                                                  .updateChildren(FieldModel(
                                                      id: 1, name: "no"));
                                            },
                                            child: CustomContainer(
                                              textColor: _editPersonalInfoScreen
                                                          .selectedChildren
                                                          .value
                                                          .id ==
                                                      1
                                                  ? Colors.white
                                                  : null,
                                              height: 60,
                                              title:
                                                  AppLocalizations.of(context)!
                                                      .no,
                                              width: 89,
                                              color: _editPersonalInfoScreen
                                                          .selectedChildren
                                                          .value
                                                          .id ==
                                                      1
                                                  ? AppTheme.selectedOptionColor
                                                  : null,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _editPersonalInfoScreen
                                                  .updateChildren(FieldModel(
                                                      id: 2,
                                                      name:
                                                          "yes , Living Together"));
                                            },
                                            child: CustomContainer(
                                              textColor: _editPersonalInfoScreen
                                                          .selectedChildren
                                                          .value
                                                          .id ==
                                                      2
                                                  ? Colors.white
                                                  : null,
                                              height: 60,
                                              title: "Yes,  Living Together",
                                              width: 89,
                                              color: _editPersonalInfoScreen
                                                          .selectedChildren
                                                          .value
                                                          .id ==
                                                      2
                                                  ? AppTheme.selectedOptionColor
                                                  : null,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _editPersonalInfoScreen
                                                  .updateChildren(FieldModel(
                                                      id: 3,
                                                      name:
                                                          "yes, Not Living Together"));
                                            },
                                            child: CustomContainer(
                                              textColor: _editPersonalInfoScreen
                                                          .selectedChildren
                                                          .value
                                                          .id ==
                                                      3
                                                  ? Colors.white
                                                  : null,
                                              height: 60,
                                              title: "Yes, Not Living Together",
                                              width: 89,
                                              color: _editPersonalInfoScreen
                                                          .selectedChildren
                                                          .value
                                                          .id ==
                                                      3
                                                  ? AppTheme.selectedOptionColor
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
                                          if (_editPersonalInfoScreen
                                                      .selectedChildrenValidated
                                                      .value ==
                                                  false &&
                                              _editPersonalInfoScreen
                                                      .isSubmitted.value ==
                                                  true) {
                                            if (_editPersonalInfoScreen
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
                                                      "Please select if you have children",
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
                                          if (_editPersonalInfoScreen
                                                      .selectedChildren
                                                      .value
                                                      .id ==
                                                  2 ||
                                              _editPersonalInfoScreen
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
                                                          style: CustomTextStyle
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
                                                            text: _editPersonalInfoScreen
                                                                .selectedNumberOfChildren
                                                                .value
                                                                ?.name);
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
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
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          16.0),
                                                                  child: Column(
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
                                                                        child: Obx(
                                                                            () {
                                                                          return ListView
                                                                              .builder(
                                                                            shrinkWrap:
                                                                                true,
                                                                            itemCount:
                                                                                _editPersonalInfoScreen.numberOfChildren.length,
                                                                            itemBuilder:
                                                                                (context, index) {
                                                                              final item = _editPersonalInfoScreen.numberOfChildren[index];
                                                                              bool isSelected = _editPersonalInfoScreen.selectedNumberOfChildren.value?.id == item.id;

                                                                              return GestureDetector(
                                                                                onTap: () {
                                                                                  // Update the selected value and close the dialog
                                                                                  _editPersonalInfoScreen.updateNumberOfChildren(item); // Update the selected item and index in the controller
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
                            const SizedBox(
                              height: 10,
                            ),
                            RichText(
                                key: _complexionKey,
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .complexion,
                                      style: CustomTextStyle.fieldName),
                                  const TextSpan(
                                      text: "*",
                                      style: TextStyle(color: Colors.red))
                                ])),
                            Obx(
                              () {
                                final TextEditingController ras =
                                    TextEditingController(
                                        text: _editPersonalInfoScreen
                                                .selectedComplexion
                                                .value
                                                ?.name ??
                                            "");
                                return CustomTextField(
                                  validator: (value) {
                                    if (language == "en") {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select $gender Complexion';
                                      }
                                    } else {
                                      if (value == null || value.isEmpty) {
                                        return 'कृपया $gender2 रंग निवडा';
                                      }
                                    }

                                    return null;
                                  },
                                  textEditingController: ras,
                                  HintText: language == "en"
                                      ? "Select Complexion"
                                      : "$gender2 रंग",
                                  ontap: () {
                                    _showComplexionSelection(context);
                                  },
                                  readonly: true,
                                );
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            RichText(
                                key: _lensKey,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            AppLocalizations.of(context)!.lens,
                                        style: CustomTextStyle.fieldName),
                                    const TextSpan(
                                        text: "*",
                                        style: TextStyle(color: Colors.red))
                                  ],
                                )),
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
                                        _editPersonalInfoScreen
                                            .updateLensStatus(
                                                FieldModel(id: 1, name: "yes"));
                                      },
                                      child: CustomContainer(
                                        textColor: _editPersonalInfoScreen
                                                    .selectedLens.value.id ==
                                                1
                                            ? Colors.white
                                            : null,
                                        height: 60,
                                        title:
                                            AppLocalizations.of(context)!.yes,
                                        width: 89,
                                        color: _editPersonalInfoScreen
                                                    .selectedLens.value.id ==
                                                1
                                            ? AppTheme.selectedOptionColor
                                            : null,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _editPersonalInfoScreen
                                            .updateLensStatus(
                                                FieldModel(id: 2, name: "no"));
                                      },
                                      child: CustomContainer(
                                        textColor: _editPersonalInfoScreen
                                                    .selectedLens.value.id ==
                                                2
                                            ? Colors.white
                                            : null,
                                        height: 60,
                                        title: AppLocalizations.of(context)!.no,
                                        width: 89,
                                        color: _editPersonalInfoScreen
                                                    .selectedLens.value.id ==
                                                2
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
                                if (_editPersonalInfoScreen
                                            .selectedLensValidated.value ==
                                        false &&
                                    _editPersonalInfoScreen.isSubmitted.value ==
                                        true) {
                                  if (_editPersonalInfoScreen
                                          .selectedLens.value.id ==
                                      0) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 18.0),
                                          child: Text(
                                            language == "en"
                                                ? "Please select $gender Lens information"
                                                : "कृपया $gender लेन्ससंबंधी माहिती निवडा",
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
                              height: 15,
                            ),
                            RichText(
                                key: _spectaclesKey,
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .spectacles,
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
                                        _editPersonalInfoScreen
                                            .updateSpectackleStatus(
                                                FieldModel(id: 1, name: "yes"));
                                      },
                                      child: CustomContainer(
                                        textColor: _editPersonalInfoScreen
                                                    .selectedSpectackle
                                                    .value
                                                    .id ==
                                                1
                                            ? Colors.white
                                            : null,
                                        height: 60,
                                        title:
                                            AppLocalizations.of(context)!.yes,
                                        width: 89,
                                        color: _editPersonalInfoScreen
                                                    .selectedSpectackle
                                                    .value
                                                    .id ==
                                                1
                                            ? AppTheme.selectedOptionColor
                                            : null,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _editPersonalInfoScreen
                                            .updateSpectackleStatus(
                                                FieldModel(id: 2, name: "no"));
                                      },
                                      child: CustomContainer(
                                        textColor: _editPersonalInfoScreen
                                                    .selectedSpectackle
                                                    .value
                                                    .id ==
                                                2
                                            ? Colors.white
                                            : null,
                                        height: 60,
                                        title: AppLocalizations.of(context)!.no,
                                        width: 89,
                                        color: _editPersonalInfoScreen
                                                    .selectedSpectackle
                                                    .value
                                                    .id ==
                                                2
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
                                if (_editPersonalInfoScreen
                                            .selectedSpectackleValidated
                                            .value ==
                                        false &&
                                    _editPersonalInfoScreen.isSubmitted.value ==
                                        true) {
                                  if (_editPersonalInfoScreen
                                          .selectedSpectackle.value.id ==
                                      0) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 18.0),
                                          child: Text(
                                            language == "en"
                                                ? "Please select $gender Spectacles information"
                                                : "$gender4 चष्मा आहे का ते निवडा ",
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
                              height: 15,
                            ),
                            RichText(
                                key: _weightKey,
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          AppLocalizations.of(context)!.weight,
                                      style: CustomTextStyle.fieldName),
                                  const TextSpan(
                                      text: "*",
                                      style: TextStyle(color: Colors.red))
                                ])),
                            Obx(
                              () {
                                final TextEditingController maxage =
                                    TextEditingController(
                                        text: _editPersonalInfoScreen
                                            .selectedWeight.value?.name);
                                return CustomTextField(
                                  validator: (value) {
                                    if (language == "en") {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select $gender weight';
                                      }
                                    } else {
                                      if (value == null || value.isEmpty) {
                                        return 'कृपया $gender3 वजन निवडा ';
                                      }
                                    }
                                    return null;
                                  },
                                  readonly: true,
                                  textEditingController: maxage,
                                  HintText: language == "en"
                                      ? "Select Weight"
                                      : "वजन निवडा ",
                                  ontap: () {
                                    _editPersonalInfoScreen
                                            .searchedWeightList.value =
                                        _editPersonalInfoScreen.weightList;

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
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0, top: 8),
                                                  child: TextField(
                                                    decoration: InputDecoration(
                                                      errorMaxLines: 5,
                                                      errorStyle:
                                                          CustomTextStyle
                                                              .errorText,
                                                      labelStyle:
                                                          CustomTextStyle
                                                              .bodytext,
                                                      hintText: language == "en"
                                                          ? "Search Weight"
                                                          : "वजन निवडा",
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
                                                      _editPersonalInfoScreen
                                                          .searchWeight(
                                                              query); // Filter the list in the controller
                                                    },
                                                  ),
                                                ),
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
                                                          _editPersonalInfoScreen
                                                              .searchedWeightList
                                                              .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        final item =
                                                            _editPersonalInfoScreen
                                                                    .searchedWeightList[
                                                                index];
                                                        bool isSelected =
                                                            _editPersonalInfoScreen
                                                                    .selectedWeight
                                                                    .value
                                                                    ?.id ==
                                                                item.id;

                                                        return GestureDetector(
                                                          onTap: () {
                                                            // Update the selected value and close the dialog
                                                            _editPersonalInfoScreen
                                                                .updateWeight(
                                                                    item); // Update the selected height and index in the controller

                                                            // Update the controller text based on selection

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
                                );
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
                                        onPressed: _editPersonalInfoScreen
                                                .isLoading.value
                                            ? null
                                            : () {
                                                //   print("This is ph number in save ${_stepOneController.phoneNumberController.value.isoCode}");
                                                // Validation for each field
                                                //   bool parentsContactValid = _phoneNumberController.value.toString() == "" ? false : true;
                                                //  bool contactsOptionValid = _stepOneController.parentContactSelected.value.id != null ;
                                                print(
                                                    "THIS IS DATA FOR ${_editPersonalInfoScreen.selectedSpectackle.value.id} ${_editPersonalInfoScreen.isSubmitted.value} ${_editPersonalInfoScreen.selectedLensValidated.value}");
                                                bool isMaritalStatusValid =
                                                    _editPersonalInfoScreen
                                                            .selectedMaritalStatus
                                                            .value
                                                            .id !=
                                                        null;
                                                bool isPhysicalStatusValid =
                                                    _editPersonalInfoScreen
                                                            .selectedPhysicalStatus
                                                            .value
                                                            .id !=
                                                        null;
                                                bool isLensStatusValid =
                                                    _editPersonalInfoScreen
                                                            .selectedLens
                                                            .value
                                                            .id !=
                                                        0;
                                                bool isSpectacleStatusValid =
                                                    _editPersonalInfoScreen
                                                            .selectedSpectackle
                                                            .value
                                                            .id !=
                                                        0;

                                                // Children validation based on marital status
                                                bool? isChildrenValid = true;
                                                if (_editPersonalInfoScreen.selectedMaritalStatus.value.id == 2 ||
                                                    _editPersonalInfoScreen
                                                            .selectedMaritalStatus
                                                            .value
                                                            .id ==
                                                        3 ||
                                                    _editPersonalInfoScreen
                                                            .selectedMaritalStatus
                                                            .value
                                                            .id ==
                                                        4 ||
                                                    _editPersonalInfoScreen
                                                            .selectedMaritalStatus
                                                            .value
                                                            .id ==
                                                        5) {
                                                  isChildrenValid =
                                                      _editPersonalInfoScreen
                                                              .selectedChildren
                                                              .value
                                                              .id !=
                                                          null;
                                                }

                                                // Update validation statuses in the controller
                                                //  _stepOneController.selectedManglikValidated.value = isManglikValid;
                                                //    _stepOneController.phvalidation.value = parentsContactValid;
                                                _editPersonalInfoScreen
                                                    .selectedMaritialStatusValidated
                                                    .value = isMaritalStatusValid;
                                                _editPersonalInfoScreen
                                                    .selectedPhysicalStatusValidated
                                                    .value = isPhysicalStatusValid;
                                                _editPersonalInfoScreen
                                                    .selectedLensValidated
                                                    .value = isLensStatusValid;
                                                _editPersonalInfoScreen
                                                    .selectedSpectackleValidated
                                                    .value = isSpectacleStatusValid;
                                                _editPersonalInfoScreen
                                                        .selectedChildrenValidated
                                                        .value =
                                                    isChildrenValid ?? true;

                                                // Set submitted state
                                                _editPersonalInfoScreen
                                                    .isSubmitted.value = true;

                                                // Validate form
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  // Check if all validations are passed
                                                  if (!isPhysicalStatusValid) {
                                                    _scrollToWidget(
                                                        _disabilityKey);
                                                  } else if (!isMaritalStatusValid) {
                                                    _scrollToWidget(
                                                        _maritialStatusKey);
                                                    // Show error message if validation fails
                                                    //  Get.snackbar("Error", "Please fill all required fields");
                                                  } else if (!isLensStatusValid) {
                                                    _scrollToWidget(_lensKey);
                                                  } else if (!isSpectacleStatusValid) {
                                                    _scrollToWidget(
                                                        _spectaclesKey);
                                                  } else if (isChildrenValid ==
                                                      false) {
                                                    _scrollToWidget(
                                                        _childrenKey);
                                                  } else {
                                                    // Start loading state
                                                    _editPersonalInfoScreen
                                                        .isLoading.value = true;

                                                    // API call
                                                    _editPersonalInfoScreen.EditPersonalInfo(
                                                            maritalStatus:
                                                                _editPersonalInfoScreen
                                                                        .selectedMaritalStatus
                                                                        .value
                                                                        .id ??
                                                                    0,
                                                            haveChildren: _editPersonalInfoScreen
                                                                    .selectedChildren
                                                                    .value
                                                                    .id ??
                                                                0,
                                                            numberOfChildren:
                                                                _editPersonalInfoScreen
                                                                        .selectedNumberOfChildren
                                                                        .value
                                                                        ?.id ??
                                                                    0,
                                                            height: _editPersonalInfoScreen
                                                                    .selectedHeight
                                                                    .value
                                                                    ?.id ??
                                                                0,
                                                            bloodGroup: _editPersonalInfoScreen
                                                                    .selectedBloodGroup
                                                                    .value
                                                                    ?.id ??
                                                                0,
                                                            disability: _editPersonalInfoScreen
                                                                    .selectedPhysicalStatus
                                                                    .value
                                                                    .id ??
                                                                0,
                                                            disabilityDesc:
                                                                _editPersonalInfoScreen.physicalStatus.text.trim(),
                                                            complexion: _editPersonalInfoScreen.selectedComplexion.value?.id ?? 0,
                                                            lens: _editPersonalInfoScreen.selectedLens.value.id ?? 0,
                                                            spectacles: _editPersonalInfoScreen.selectedSpectackle.value.id ?? 0,
                                                            weight: _editPersonalInfoScreen.selectedWeight.value?.id ?? 0)
                                                        .then((result) {
                                                      // Reset loading state
                                                      _editPersonalInfoScreen
                                                          .isLoading
                                                          .value = false;
                                                      // Handle successful result (optional)
                                                    }).catchError((error) {
                                                      // Handle error and reset loading state
                                                      _editPersonalInfoScreen
                                                          .isLoading
                                                          .value = false;
                                                      print("Error: $error");
                                                    });
                                                  }
                                                } else {
                                                  // Show error if form validation fails
                                                  //   Get.snackbar("Error", "Please Fill all required Fields");
                                                  if (_editPersonalInfoScreen
                                                          .selectedHeight
                                                          .value
                                                          ?.id ==
                                                      null) {
                                                    _scrollToWidget(_heightKey);
                                                  } else if (_editPersonalInfoScreen
                                                          .selectedBloodGroup
                                                          .value
                                                          ?.id ==
                                                      null) {
                                                    _scrollToWidget(
                                                        _bloodeGroupKey);
                                                  } else if (_editPersonalInfoScreen
                                                          .selectedPhysicalStatus
                                                          .value
                                                          .id ==
                                                      null) {
                                                    _scrollToWidget(
                                                        _disabilityKey);
                                                  } else if (_editPersonalInfoScreen
                                                          .selectedMaritalStatus
                                                          .value
                                                          .id ==
                                                      null) {
                                                    _scrollToWidget(
                                                        _maritialStatusKey);
                                                  } else if (_editPersonalInfoScreen
                                                          .selectedComplexion
                                                          .value
                                                          ?.id ==
                                                      null) {
                                                    _scrollToWidget(
                                                        _complexionKey);
                                                  } else if (_editPersonalInfoScreen
                                                          .selectedLens
                                                          .value
                                                          .id ==
                                                      null) {
                                                    _scrollToWidget(_lensKey);
                                                  } else if (_editPersonalInfoScreen
                                                          .selectedSpectackle
                                                          .value
                                                          .id ==
                                                      null) {
                                                    _scrollToWidget(
                                                        _spectaclesKey);
                                                  } else if (_editPersonalInfoScreen
                                                          .selectedWeight
                                                          .value
                                                          ?.id ==
                                                      null) {
                                                    _scrollToWidget(_weightKey);
                                                  }
                                                }
                                              },
                                        child: _editPersonalInfoScreen
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

  void _showComplexionSelection(BuildContext context) {
    // Access the ZodiacController
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
                Text(language == "en" ? "Select Complexion" : "रंग निवडा",
                    style: CustomTextStyle.bodytextboldLarge),
                const SizedBox(height: 10),

                // Dynamic list of zodiac signs from the controller
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children:
                      _editPersonalInfoScreen.complexion.map((FieldModel sign) {
                    return Obx(() {
                      // Only this part rebuilds when the selectedZodiacSign value changes
                      final isSelected = _editPersonalInfoScreen
                              .selectedComplexion.value?.id ==
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
                            _editPersonalInfoScreen.updateZodiacSign(sign);
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
}
