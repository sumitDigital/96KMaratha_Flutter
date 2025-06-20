import 'package:_96kuliapp/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/accounts_and_settings_controller/chnagepasswordController.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/backHeader.dart';
import 'package:_96kuliapp/utils/customtextform.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? language = sharedPreferences?.getString("Language");

  @override
  Widget build(BuildContext context) {
    final ChangePasswordController changePasswordController =
        Get.put(ChangePasswordController());

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BackHeader(
                onTap: () {
                  Get.back();
                },
                title: language == 'en' ? "Change Password" : "पासवर्ड बदला "),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: _formKey, // Link the Form to the _formKey
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(language == 'en' ? "Old Password" : "जुना पासवर्ड",
                        style: CustomTextStyle.fieldName),
                    Obx(
                      () {
                        return CustomTextField(
                          obscuretext:
                              changePasswordController.hidePassword.value
                                  ? false
                                  : true,
                          suffixIcon:
                              changePasswordController.hidePassword.value
                                  ? IconButton(
                                      onPressed: () {
                                        changePasswordController
                                            .alterPasswordVisiblity();
                                      },
                                      icon: Icon(
                                        Icons.visibility,
                                        color: AppTheme.selectedOptionColor,
                                      ))
                                  : IconButton(
                                      onPressed: () {
                                        changePasswordController
                                            .alterPasswordVisiblity();
                                      },
                                      icon: Icon(
                                        Icons.visibility_off,
                                        color: Colors.grey.shade500,
                                      )),
                          onChange: (p0) {
                            changePasswordController.errormsg.value = {};
                            return null;
                          },
                          textEditingController:
                              changePasswordController.oldPasswordController,
                          HintText: language == 'en'
                              ? "Enter Old Password"
                              : "जुना पासवर्ड प्रविष्ट करा",
                          validator: (value) {
                            // Trim the input value
                            String trimmedValue = value?.trim() ?? '';

                            if (trimmedValue.isEmpty) {
                              return language == 'en'
                                  ? 'Please enter your old password'
                                  : 'कृपया जुना पासवर्ड प्रविष्ट करा';
                            }

                            if (trimmedValue.length < 6) {
                              return language == 'en'
                                  ? 'Please enter a minimum 6-character password'
                                  : 'कृपया किमान 6-अक्षरी पासवर्ड प्रविष्ट करा';
                            }

                            return null;
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(language == 'en' ? "New Password" : "नवीन पासवर्ड",
                        style: CustomTextStyle.fieldName),
                    Obx(
                      () {
                        return CustomTextField(
                          obscuretext:
                              changePasswordController.hidePassword.value
                                  ? false
                                  : true,
                          suffixIcon:
                              changePasswordController.hidePassword.value
                                  ? IconButton(
                                      onPressed: () {
                                        changePasswordController
                                            .alterPasswordVisiblity();
                                      },
                                      icon: Icon(
                                        Icons.visibility,
                                        color: AppTheme.selectedOptionColor,
                                      ))
                                  : IconButton(
                                      onPressed: () {
                                        changePasswordController
                                            .alterPasswordVisiblity();
                                      },
                                      icon: Icon(
                                        Icons.visibility_off,
                                        color: Colors.grey.shade500,
                                      )),
                          onChange: (p0) {
                            changePasswordController.errormsg.value = {};
                            return null;
                          },
                          textEditingController:
                              changePasswordController.newPasswordController,
                          HintText: language == 'en'
                              ? "Enter New Password"
                              : "नवीन पासवर्ड प्रविष्ट करा",
                          validator: (value) {
                            // Trim the input value
                            String trimmedValue = value?.trim() ?? '';

                            if (trimmedValue.isEmpty) {
                              return language == 'en'
                                  ? 'Please enter your new password'
                                  : "कृपया नवीन पासवर्ड प्रविष्ट करा";
                            }

                            if (trimmedValue.length < 6) {
                              return language == 'en'
                                  ? 'Please enter a minimum 6-character password'
                                  : "कृपया किमान 6-अक्षरी पासवर्ड प्रविष्ट करा";
                            }

                            return null;
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Obx(() {
                      if (changePasswordController.errormsg.isNotEmpty) {
                        // Display the error message
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            changePasswordController.errormsg["message"],
                            style: const TextStyle(
                                color: Colors.red, fontSize: 14),
                          ),
                        );
                      } else {
                        // Return an empty container if there's no error message
                        return const SizedBox.shrink();
                      }
                    }),
                    const SizedBox(height: 40),
                    Center(
                      child: Obx(
                        () {
                          if (changePasswordController.updating.value == true) {
                            return const ElevatedButton(
                              onPressed:
                                  null, // Disable the button while updating
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          } else {
                            return ElevatedButton(
                              onPressed: () {
                                // Validate the form
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  // If valid, call the API
                                  changePasswordController.updatePassword(
                                    oldPassword: changePasswordController
                                        .oldPasswordController.text
                                        .trim(),
                                    newPassword: changePasswordController
                                        .newPasswordController.text
                                        .trim(),
                                  );
                                }
                              },
                              child: Text(
                                  language == 'en'
                                      ? "Update Password"
                                      : "पासवर्ड अपडेट",
                                  style: CustomTextStyle.elevatedButton),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
