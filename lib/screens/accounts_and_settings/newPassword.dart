import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/auth/updatePasswordController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/screens/auth_Screens/loginScreen2.dart';
import 'package:_96kuliapp/utils/backHeader.dart';
import 'package:_96kuliapp/utils/customtextform.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UpdatePasswordController updatePasswordController =
        Get.put(UpdatePasswordController());
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String? language = sharedPreferences?.getString("Language");

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
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
                      const SizedBox(width: 10),
                      Text(language == "en" ? "New Password" : "नवीन पासवर्ड",
                          style: CustomTextStyle.bodytextLarge),
                    ],
                  ),
                  TextButton(
                      onPressed: () async {
                        await sharedPreferences?.clear();
                        Get.deleteAll();
                        navigatorKey.currentState!.pushAndRemoveUntil(
                          MaterialPageRoute(
                            maintainState: false,
                            builder: (context) => const LoginScreen2(),
                          ),
                          (route) => false,
                        );
                      },
                      child: Text(
                        // "Logout",
                        AppLocalizations.of(context)!.logout,
                        style: CustomTextStyle.textbuttonRed,
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      language == 'en' ? "New Password" : "नवीन पासवर्ड",
                      style: CustomTextStyle.fieldName,
                    ),
                    Obx(
                      () {
                        return CustomTextField(
                          suffixIcon:
                              updatePasswordController.hidePassword.value
                                  ? IconButton(
                                      onPressed: () {
                                        updatePasswordController
                                            .alterPasswordVisiblity();
                                      },
                                      icon: const Icon(
                                        Icons.visibility,
                                        color: Colors.blue,
                                      ))
                                  : IconButton(
                                      onPressed: () {
                                        updatePasswordController
                                            .alterPasswordVisiblity();
                                      },
                                      icon: Icon(
                                        Icons.visibility_off,
                                        color: Colors.grey.shade500,
                                      )),
                          obscuretext:
                              updatePasswordController.hidePassword.value
                                  ? false
                                  : true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return language == 'en'
                                  ? 'Please enter your new password'
                                  : "कृपया नवीन पासवर्ड प्रविष्ट करा";
                            }

                            if (value.length < 6) {
                              return language == 'en'
                                  ? 'Please enter a minimum 6-character password'
                                  : "कृपया किमान 6-अक्षरी पासवर्ड प्रविष्ट करा";
                            }
                            return null;
                          },
                          textEditingController:
                              updatePasswordController.passwordController,
                          HintText: language == 'en'
                              ? "Enter New Password"
                              : "नवीन पासवर्ड प्रविष्ट करा",
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      language == 'en'
                          ? "Re-enter Password"
                          : "परत पासवर्ड टाका",
                      style: CustomTextStyle.fieldName,
                    ),
                    Obx(
                      () {
                        return CustomTextField(
                            suffixIcon:
                                updatePasswordController.hidePassword.value
                                    ? IconButton(
                                        onPressed: () {
                                          updatePasswordController
                                              .alterPasswordVisiblity();
                                        },
                                        icon: const Icon(
                                          Icons.visibility,
                                          color: Colors.blue,
                                        ))
                                    : IconButton(
                                        onPressed: () {
                                          updatePasswordController
                                              .alterPasswordVisiblity();
                                        },
                                        icon: Icon(
                                          Icons.visibility_off,
                                          color: Colors.grey.shade500,
                                        )),
                            obscuretext:
                                updatePasswordController.hidePassword.value
                                    ? false
                                    : true,
                            textEditingController: updatePasswordController
                                .confirmPasswordController,
                            HintText: language == 'en'
                                ? "Enter password again"
                                : "पासवर्ड पुन्हा प्रविष्ट करा",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return language == 'en'
                                    ? 'Please confirm your password'
                                    : "कृपया आपला पासवर्ड जुळतो आहे का याची खात्री करा";
                              }

                              if (value.trim() !=
                                  updatePasswordController
                                      .passwordController.text
                                      .trim()) {
                                return language == 'en'
                                    ? 'Passwords did not match'
                                    : "पासवर्ड जुळत नाही, कृपया पुन्हा तपासा.";
                              }

                              return null;
                            });
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: Obx(() => ElevatedButton(
                            onPressed: updatePasswordController
                                        .isloading.value ==
                                    false
                                ? () {
                                    if (formKey.currentState!.validate()) {
                                      updatePasswordController
                                          .newPasswordUpdate(
                                        password: updatePasswordController
                                            .passwordController.text
                                            .trim(),
                                      );
                                    }
                                  }
                                : () {}, // Disable button when isloading is true
                            child: updatePasswordController.isloading.value
                                ? const CircularProgressIndicator(
                                    color: Colors.white) // Add color if needed
                                : Text(
                                    language == 'en'
                                        ? "Save New Password"
                                        : "पासवर्ड बदला",
                                    style: CustomTextStyle.elevatedButton,
                                  ),
                          )),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
