// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/editforms_controllers/editAboutMeController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/screens/profile_screens/edit_profile.dart';
import 'package:_96kuliapp/utils/backheader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:shimmer/shimmer.dart';

class EditAboutMeScreen extends StatefulWidget {
  const EditAboutMeScreen({super.key});

  @override
  State<EditAboutMeScreen> createState() => _EditAboutMeScreenState();
}

class _EditAboutMeScreenState extends State<EditAboutMeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final EditAboutmeController _editastrodetailscontroller =
      Get.put(EditAboutmeController());
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
      child: Scaffold(body: SingleChildScrollView(
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
                                      .editIntroduction,
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
                        title: AppLocalizations.of(context)!.editIntroduction),
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
                                    text: AppLocalizations.of(context)!.aboutMe,
                                    //  "About Me ",
                                    style: CustomTextStyle.fieldName),
                                const TextSpan(
                                    text: "*",
                                    style: TextStyle(color: Colors.red))
                              ])),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                // keyboardType: textInputType,
                                maxLines: 7,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,

                                // readOnly: readonly,

                                //onTap: ontap,
                                //inputFormatters: inputFormatters ?? [],
                                //  obscureText: obscuretext,
                                controller: _editastrodetailscontroller.aboutMe,
                                style: CustomTextStyle.bodytext,
                                decoration: InputDecoration(
                                  errorMaxLines: 5,
                                  errorStyle: CustomTextStyle.errorText,
                                  labelStyle: CustomTextStyle.bodytext,

                                  hintText: "Enter Intro",
                                  contentPadding: const EdgeInsets.all(20),
                                  hintStyle: CustomTextStyle.hintText,
                                  filled: true,

                                  fillColor: Colors.white,
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade300),
                                  ),
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
                                  //  suffixIcon: suffixIcon,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter $gender Intro';
                                  }
                                  return null;
                                },

                                //   onChanged: onChange,
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Back Button
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

                                  // Save Button
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
                                                  // Your save button logic here, uncomment and complete the function as needed
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    _editastrodetailscontroller
                                                        .AboutMe(
                                                            aboutme:
                                                                _editastrodetailscontroller
                                                                    .aboutMe
                                                                    .text
                                                                    .trim());
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
      )),
    );
  }
}
