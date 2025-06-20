import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/ExploreApController/exploreAppController.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/screens/auth_Screens/loginScreen2.dart';
import 'package:_96kuliapp/screens/exploreAppScreens/exploreAppBeforeLogin/exploreAppBeforeLoginScreen.dart';
import 'package:_96kuliapp/screens/userInfoForms/location/presentAddress/PresentState.dart';
import 'package:_96kuliapp/screens/userInfoForms/location/presentStateForExplore.dart';
import 'package:_96kuliapp/utils/backHeader.dart';
import 'package:_96kuliapp/utils/customtextform.dart';
import 'package:text_divider/text_divider.dart';

class ExploreAppForm extends StatefulWidget {
  const ExploreAppForm({super.key});

  @override
  State<ExploreAppForm> createState() => _ExploreAppFormState();
}

class _ExploreAppFormState extends State<ExploreAppForm> {
  final ExploreAppController _exploreAppController =
      Get.put(ExploreAppController());
  final LocationController _locationController = Get.put(LocationController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String presentlocationText = "";
  String? language = sharedPreferences?.getString("Language");

  @override
  Widget build(BuildContext context) {
    int? ID = sharedPreferences?.getInt("UnregisteredID");
    print("THIS IS ID $ID");
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BackHeader(
            title: AppLocalizations.of(context)!.exploreProfiles,
            onTap: () {
              Get.back();
            },
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
                        text: AppLocalizations.of(context)!.selectGender,
                        style: CustomTextStyle.fieldName),
                    const TextSpan(
                        text: "*", style: TextStyle(color: Colors.red))
                  ])),
                  // Text(AppLocalizations.of(context)!.selectGender , style : CustomTextStyle.fieldName),
                  Obx(() {
                    return Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                _exploreAppController.updateOption("Male");
                              },
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Radio<String>(
                                          activeColor: const Color.fromARGB(
                                              255, 80, 93, 126),
                                          value: "Male",
                                          groupValue: _exploreAppController
                                              .selectedGender.value,
                                          onChanged: (String? value) {
                                            _exploreAppController
                                                .selectedGender.value = value!;

                                            _exploreAppController
                                                .updateOption(value);
                                          }),
                                      Text(AppLocalizations.of(context)!.male,
                                          style: CustomTextStyle.bodytext),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset(height: 30, "assets/male.png")
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
                                _exploreAppController.selectedGender.value =
                                    "Female";
                                _exploreAppController.updateOption("Female");
                              },
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Radio<String>(
                                          activeColor: const Color.fromARGB(
                                              255, 80, 93, 126),
                                          value: "Female",
                                          groupValue: _exploreAppController
                                              .selectedGender.value,
                                          onChanged: (String? value) {
                                            _exploreAppController
                                                .selectedGender.value = value!;

                                            _exploreAppController
                                                .updateOption(value);
                                          }),
                                      Text(AppLocalizations.of(context)!.female,
                                          style: CustomTextStyle.bodytext),
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
                      if (_exploreAppController.isSubmited.value) {
                        if (_exploreAppController.selectedGender.isEmpty) {
                          if (language == "en") {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 18.0, top: 5),
                              child: Text(
                                "Please select your gender",
                                style: CustomTextStyle.errorText,
                              ),
                            );
                          } else {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 18.0, top: 5),
                              child: Text(
                                "तुमचे लिंग निवडणे अनिवार्य आहे",
                                style: CustomTextStyle.errorText,
                              ),
                            );
                          }
                        } else {
                          return const SizedBox();
                        }
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // RichText(
                  //   text: TextSpan(children: <TextSpan>[
                  //     TextSpan(
                  //         text: AppLocalizations.of(context)!.selectDistricts,
                  //         style: CustomTextStyle.fieldName),
                  //     const TextSpan(
                  //         text: "*", style: TextStyle(color: Colors.red))
                  //   ]),
                  // ),
                  // //  Text( style : CustomTextStyle.fieldName),
                  // Obx(
                  //   () {
                  //     final TextEditingController locationTextController =
                  //         TextEditingController();
                  //     print(
                  //         "Partner State ${_locationController.presentselectedCity.value.id}");
                  //     final selectedLocation = [
                  //       _locationController.presentselectedCity.value.name,
                  //       // _locationController.presentselectedState.value.name,
                  //       // _locationController.presentselectedCountry.value.name
                  //     ]
                  //         .where((element) =>
                  //             element != null &&
                  //             element
                  //                 .isNotEmpty) // Check for null and empty strings
                  //         .join(' , ');

                  //     locationTextController.text =
                  //         selectedLocation.isEmpty ? "" : selectedLocation;
                  //     presentlocationText = locationTextController.text;

                  //     return CustomTextField(
                  //       textEditingController: locationTextController,
                  //       validator: (value) {
                  //         if (value == null || value.isEmpty) {
                  //           return AppLocalizations.of(context)!
                  //               .pleaseSelectyourDistrict;
                  //         }

                  //         return null;
                  //       },
                  //       readonly: true,
                  //       ontap: () {
                  //         //    Get.toNamed(AppRouteNames.presentselectCountry);
                  //         navigatorKey.currentState!.push(MaterialPageRoute(
                  //           builder: (context) =>
                  //               const PresentStateScreenForExplore(
                  //             StateId: "22",
                  //           ),
                  //         ));
                  //       },
                  //       HintText: language == "en"
                  //           ? "Select your state"
                  //           : "जिल्हा निवडा",
                  //     );
                  //   },
                  // ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 5,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28, vertical: 15)),
                      onPressed: () async {
                        _exploreAppController.isSubmited.value = true;
                        if (_exploreAppController
                            .selectedGender.value.isEmpty) {
                          if (_formKey.currentState!.validate()) {}
                        } else {
                          if (_formKey.currentState!.validate()) {
                            if (_exploreAppController
                                .selectedGender.value.isEmpty) {
                            } else {
                              _exploreAppController.exploreMacthesPage.value =
                                  1;
                              _exploreAppController
                                  .exploreMacthesHasMore.value = true;
                              _exploreAppController.exploreMatchesList.clear();
                              _exploreAppController
                                  .exploreMatchesListfetching.value = true;
                              await Future.delayed(Duration.zero);
                              navigatorKey.currentState!.push(MaterialPageRoute(
                                builder: (context) =>
                                    const ExploReAppBeforeLoginScreen(),
                              ));
                            }
                          }
                        }
                      },
                      child: Text(
                        AppLocalizations.of(context)!.exploreProfiles,
                        style: CustomTextStyle.elevatedButton,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      )),
    );
  }
}
