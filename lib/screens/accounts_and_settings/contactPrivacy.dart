import 'package:_96kuliapp/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/accounts_and_settings_controller/contactPrivacyController.dart';
import 'package:_96kuliapp/models/forms/fields/fieldModel.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:_96kuliapp/utils/backHeader.dart';
import 'package:shimmer/shimmer.dart';

class EditContactPrivacy extends StatefulWidget {
  const EditContactPrivacy({super.key});

  @override
  State<EditContactPrivacy> createState() => _EditContactPrivacyState();
}

class _EditContactPrivacyState extends State<EditContactPrivacy> {
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String locationText = "";

  TimeOfDay selectedTime = TimeOfDay.now();
  String? language = sharedPreferences?.getString("Language");

  final mybox = Hive.box('myBox');

  late String gender;
  String? gender2;
  String? gender3;
  String? gender4;

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
        gender4 = "वराला";
        return "वराची";
      } else {
        gender2 = "वधूचा";
        gender3 = "वधूच्या";
        gender4 = "वधूला";

        return "वधूची";
      }
    }
  }

  @override
  void initState() {
    super.initState();
    gender = selectgender();
  }

  // final LocationController locationController = Get.put(LocationController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ContactPrivacyController _editastrodetailscontroller =
      Get.put(ContactPrivacyController());
  @override
  Widget build(BuildContext context) {
    final mybox = Hive.box('myBox');
    String gender = mybox.get("gender") == 2 ? "groom" : "bride";

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
            if (_editastrodetailscontroller.isPageLoading.value == true) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BackHeader(
                        onTap: () {
                          Get.back();
                        },
                        title: language == "en"
                            ? "Edit Contact Privacy"
                            : "संपर्क क्रमांकाची प्रायव्हसी सेटिंग बदला "),
                  ],
                ),
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BackHeader(
                      onTap: () {
                        Get.back();
                      },
                      title: language == "en"
                          ? "Edit Contact Privacy"
                          : "संपर्क क्रमांकाची प्रायव्हसी सेटिंग बदला "),
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
                            text: TextSpan(
                              children: <TextSpan>[
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
                              ],
                            ),
                          ),
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
                              height: 10,
                            ),
                            RichText(
                                text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: language == "en"
                                      ? "Contact Number Visibility "
                                      : "संपर्क क्रमांक दाखवण्याविषयी ",
                                  style: CustomTextStyle.fieldName),
                              const TextSpan(
                                  text: "*",
                                  style: TextStyle(color: Colors.red))
                            ])),
                            const SizedBox(
                              height: 10,
                            ),
                            Obx(() {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RadioListTile<int>(
                                    contentPadding: const EdgeInsets.all(0),
                                    value:
                                        1, // Using the FieldModel.id directly
                                    groupValue: _editastrodetailscontroller
                                        .parentContactSelected.value.id,
                                    onChanged: (int? value) {
                                      if (value != null) {
                                        // Update the selected value and the corresponding FieldModel
                                        _editastrodetailscontroller
                                            .updateParentContact(FieldModel(
                                                id: value,
                                                name:
                                                    "Show my contact number to all"));
                                      }
                                    },
                                    title: Text(
                                      language == "en"
                                          ? "Show my contact number to all."
                                          : "${AppLocalizations.of(context)!.only} $gender2 संपर्क क्रमांक दाखवा.",
                                      style: CustomTextStyle.bodytext
                                          .copyWith(color: AppTheme.textColor),
                                    ),
                                    selected: _editastrodetailscontroller
                                            .parentContactSelected.value.id ==
                                        1,
                                    activeColor: AppTheme
                                        .secondryColor, // Change this to your desired active color
                                  ),
                                  const SizedBox(
                                      height: 10), // Spacing between items
                                  RadioListTile<int>(
                                    contentPadding: const EdgeInsets.all(0),
                                    value:
                                        3, // Using the FieldModel.id directly
                                    groupValue: _editastrodetailscontroller
                                        .parentContactSelected.value.id,
                                    onChanged: (int? value) {
                                      if (value != null) {
                                        _editastrodetailscontroller
                                            .updateParentContact(FieldModel(
                                                id: value, name: "no"));
                                      }
                                    },
                                    title: Text(
                                      AppLocalizations.of(context)!
                                          .showParentContactNumberToAll,
                                      style: CustomTextStyle.bodytext
                                          .copyWith(color: AppTheme.textColor),
                                    ),
                                    selected: _editastrodetailscontroller
                                            .parentContactSelected.value.id ==
                                        3,
                                    activeColor: AppTheme
                                        .secondryColor, // Change this to your desired active color
                                  ),
                                  const SizedBox(height: 10),
                                  RadioListTile<int>(
                                    contentPadding: const EdgeInsets.all(0),
                                    value:
                                        2, // Using the FieldModel.id directly
                                    groupValue: _editastrodetailscontroller
                                        .parentContactSelected.value.id,
                                    onChanged: (int? value) {
                                      if (value != null) {
                                        _editastrodetailscontroller
                                            .updateParentContact(FieldModel(
                                                id: value,
                                                name:
                                                    "Show my & my parent's contact number to all"));
                                      }
                                    },
                                    title: Text(
                                      "${language == 'en' ? gender : gender2} ${AppLocalizations.of(context)!.showmyandparentscontactnumbertoall}",
                                      style: CustomTextStyle.bodytext
                                          .copyWith(color: AppTheme.textColor),
                                    ),
                                    selected: _editastrodetailscontroller
                                            .parentContactSelected.value.id ==
                                        2,
                                    activeColor: AppTheme
                                        .secondryColor, // Change this to your desired active color
                                  ),
                                ],
                              );
                            }),
                            Obx(
                              () {
                                print("Valid Mang");
                                if (_editastrodetailscontroller
                                            .parentContactValidated.value ==
                                        false &&
                                    _editastrodetailscontroller
                                            .isSubmitted.value ==
                                        true) {
                                  if (_editastrodetailscontroller
                                          .parentContactSelected.value.id ==
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
                                            "Please select one of the above option",
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
                              height: 40,
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
                                      Get.back();
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.back,
                                      style: CustomTextStyle.elevatedButton
                                          .copyWith(color: Colors.red),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Obx(
                                  () {
                                    return Expanded(
                                      child: ElevatedButton(
                                          onPressed: _editastrodetailscontroller
                                                      .sendingdata.value ==
                                                  true
                                              ? null
                                              : () {
                                                  _editastrodetailscontroller
                                                      .updateContactNumberVisibility(
                                                          contactNumberVisibility:
                                                              _editastrodetailscontroller
                                                                      .parentContactSelected
                                                                      .value
                                                                      .id ??
                                                                  0);
                                                },
                                          child: _editastrodetailscontroller
                                                      .sendingdata.value ==
                                                  true
                                              ? const CircularProgressIndicator(
                                                  color: Colors.white,
                                                )
                                              : Text(
                                                  AppLocalizations.of(context)!
                                                      .save,
                                                  style: CustomTextStyle
                                                      .elevatedButton,
                                                )),
                                    );
                                  },
                                )
                              ],
                            )
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
