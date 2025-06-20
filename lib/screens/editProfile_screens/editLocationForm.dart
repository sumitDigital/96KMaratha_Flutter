import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/editforms_controllers/editLocationController.dart';
import 'package:_96kuliapp/controllers/formfields/educationController.dart';
import 'package:_96kuliapp/controllers/formfields/employedInController.dart';
import 'package:_96kuliapp/controllers/formfields/occupationController.dart';
import 'package:_96kuliapp/controllers/formfields/specializationController.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/profile_screens/edit_profile.dart';
import 'package:_96kuliapp/screens/userInfoForms/location/presentAddress/presentCountry.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/backheader.dart';
import 'package:_96kuliapp/utils/buttonContainer.dart';
import 'package:_96kuliapp/utils/customtextform.dart';
import 'package:shimmer/shimmer.dart';

class EditLocationForm extends StatefulWidget {
  const EditLocationForm({super.key});

  @override
  State<EditLocationForm> createState() => _EditLocationFormState();
}

class _EditLocationFormState extends State<EditLocationForm> {
// final StepTwoController _stepTwoController = Get.put(StepTwoController());
  final EditLocationController _editLocationController =
      Get.put(EditLocationController());
  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController countryPermanent = TextEditingController();
  TextEditingController statePermanent = TextEditingController();
  TextEditingController cityPermanent = TextEditingController();

  final LocationController locationController = Get.put(LocationController());
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
    return Scaffold(
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
            if (_editLocationController.isPageLoading.value) {
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
                                    .editLocationDetails,
                                style: CustomTextStyle.bodytextLarge,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Textfield
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
                      title: AppLocalizations.of(context)!.editLocationDetails),
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
                  Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            RichText(
                                text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .presentAddress,
                                  style: CustomTextStyle.fieldName),
                              const TextSpan(
                                  text: "*",
                                  style: TextStyle(color: Colors.red))
                            ])),
                            Obx(
                              () {
                                final TextEditingController
                                    locationTextController =
                                    TextEditingController();

                                final selectedLocation = [
                                  locationController
                                      .presentselectedCity.value.name,
                                  locationController
                                      .presentselectedState.value.name,
                                  locationController
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
                                          return 'Please your select $gender present address';
                                        } else if (locationController
                                                .presentselectedState
                                                .value
                                                .name ==
                                            null) {
                                          return 'Please your select $gender present state';
                                        } else if (locationController
                                                .presentselectedCity
                                                .value
                                                .name ==
                                            null) {
                                          return 'Please your select $gender present district';
                                        }
                                      } else {
                                        if (value == null || value.isEmpty) {
                                          return '$gender2 सध्याचा पत्ता टाकणे अनिवार्य आहे';
                                        } else if (locationController
                                                .permanentSelectedState
                                                .value
                                                .name ==
                                            null) {
                                          return '$gender4 सध्याचे राज्य निवडणे अनिवार्य आहे.';
                                        } else if (locationController
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
                                      navigatorKey.currentState!
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            const PresentCountrySelectScreen(),
                                      ));
                                    },
                                    HintText: language == "en"
                                        ? "Select $gender Location"
                                        : "$gender2 सध्याचा पत्ता");
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Obx(
                              () {
                                return GestureDetector(
                                  onTap: () {
                                    _editLocationController.updateSameAddress();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                            value: _editLocationController
                                                .isSameAdress.value,
                                            onChanged: (value) {
                                              _editLocationController
                                                  .updateSameAddress();
                                            },
                                          )),
                                      Text(
                                        language == "en"
                                            ? "Same Address"
                                            : " सारखे ठिकाण",
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
                                if (_editLocationController
                                        .isSameAdress.value ==
                                    false) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                          text: TextSpan(children: <TextSpan>[
                                        TextSpan(
                                            text: AppLocalizations.of(context)!
                                                .permanentAddress,
                                            style: CustomTextStyle.fieldName),
                                        const TextSpan(
                                            text: "*",
                                            style: TextStyle(color: Colors.red))
                                      ])),
                                      Obx(
                                        () {
                                          final TextEditingController
                                              locationTextController =
                                              TextEditingController();

                                          final selectedLocation = [
                                            locationController
                                                .permanentSelectedCity
                                                .value
                                                .name,
                                            locationController
                                                .permanentSelectedState
                                                .value
                                                .name,
                                            locationController
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
                                                    return 'Please select your $gender permanent address';
                                                  } else if (locationController
                                                          .permanentSelectedState
                                                          .value
                                                          .name ==
                                                      null) {
                                                    return 'Please select your $gender permanent state';
                                                  } else if (locationController
                                                          .permanentSelectedCity
                                                          .value
                                                          .name ==
                                                      null) {
                                                    return 'Please select your $gender permanent city';
                                                  }
                                                } else {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return '$gender2 कायमचा पत्ता टाकणे अनिवार्य आहे';
                                                  } else if (locationController
                                                          .permanentSelectedState
                                                          .value
                                                          .name ==
                                                      null) {
                                                    return '$gender4 कायमचे राज्य निवडणे अनिवार्य आहे.';
                                                  } else if (locationController
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
                                                      const PresentCountrySelectScreen(),
                                                ));
                                              },
                                              HintText: language == "en"
                                                  ? "Select $gender Location"
                                                  : "$gender2 कायमचा पत्ता");
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
                                text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text:
                                      AppLocalizations.of(context)!.nativePlace,
                                  style: CustomTextStyle.fieldName),
                              const TextSpan(
                                  text: "*",
                                  style: TextStyle(color: Colors.red))
                            ])),
                            CustomTextField(
                                textEditingController:
                                    _editLocationController.nativePlace,
                                validator: (value) {
                                  if (language == "en") {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter $gender native place';
                                    }
                                  } else {
                                    if (value == null || value.isEmpty) {
                                      return '$gender4 मूळ ठिकाण टाकणे अनिवार्य आहे';
                                    }
                                  }
                                  return null;
                                },
                                HintText: language == "en"
                                    ? "Enter $gender Native place"
                                    : "$gender4 मूळ ठिकाण"),
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
                                          //  Get.offNamed(AppRouteNames.userInfoStepOne);
                                          Get.back();
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)!.back,
                                          style: CustomTextStyle.elevatedButton
                                              .copyWith(color: Colors.red),
                                        ))),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: ElevatedButton(
                                  onPressed: () {
                                    _editLocationController.isSubmitted.value =
                                        true;

                                    // Get.toNamed(AppRouteNames.userInfoStepThree);

                                    if (_formKey.currentState!.validate()) {
                                      print("VaLID");
                                      _editLocationController.LocationForm(
                                          nativePlace: _editLocationController
                                              .nativePlace.text
                                              .trim(),
                                          presentCountry: locationController
                                                  .presentselectedCountry
                                                  .value
                                                  .id ??
                                              0,
                                          presentState: locationController
                                                  .presentselectedState
                                                  .value
                                                  .id ??
                                              0,
                                          presentCity: locationController
                                                  .presentselectedCity
                                                  .value
                                                  .id ??
                                              0,
                                          permanentCountry: locationController
                                                  .permanentSelectedCountry
                                                  .value
                                                  .id ??
                                              0,
                                          permanentState: locationController
                                                  .permanentSelectedState
                                                  .value
                                                  .id ??
                                              0,
                                          permanentCity: locationController
                                                  .permanentSelectedCity
                                                  .value
                                                  .id ??
                                              0,
                                          sameAddress: 1);
                                    } else {
                                      // Get.snackbar("Error", "Please Fill all required Fields");
                                    }
                                  },
                                  child: Obx(() {
                                    return _editLocationController
                                            .isLoading.value
                                        ? const CircularProgressIndicator(
                                            color: Colors
                                                .white, // Set the indicator color if needed
                                          )
                                        : Text(
                                            AppLocalizations.of(context)!.save,
                                            style:
                                                CustomTextStyle.elevatedButton);
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
                    const Text("You Are Employed In",
                        style: CustomTextStyle.bodytextboldLarge),
                    const SizedBox(height: 10),

                    // Search bar for filtering
                    TextField(
                      style: CustomTextStyle.bodytext,
                      decoration: InputDecoration(
                        errorMaxLines: 5,
                        errorStyle: CustomTextStyle.errorText,
                        labelStyle: CustomTextStyle.bodytext,
                        hintText: "Search ",
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
                const Text("Select Specialization",
                    style: CustomTextStyle.bodytextboldLarge),
                const SizedBox(height: 10),

                // Search field
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    errorMaxLines: 5,
                    errorStyle: CustomTextStyle.errorText,
                    labelStyle: CustomTextStyle.bodytext,
                    hintText: "Search Specialization",
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
                const Text("Select Occupation",
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
                    hintText: "Search Occupation",
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
                const Text("Select Highest Education",
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
                    hintText: "Search Education",
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
