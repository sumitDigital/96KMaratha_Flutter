// import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import 'package:get/get.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/ExploreApController/exploreAppController.dart';
import 'package:_96kuliapp/controllers/auth/logincontroller.dart';
import 'package:_96kuliapp/controllers/locationcontroller/LocationController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/accounts_and_settings/deleteAccount.dart';
import 'package:_96kuliapp/screens/auth_Screens/forgetPasswordScreen.dart';
import 'package:_96kuliapp/screens/auth_Screens/loginwithOTPScreen.dart';
import 'package:_96kuliapp/screens/auth_Screens/registerScreen.dart';
import 'package:_96kuliapp/screens/onboarding/welcomeScreen.dart';
import 'package:_96kuliapp/screens/plans/upgradeScreen.dart';
import 'package:_96kuliapp/screens/userInfoForms/userinfoStepFour.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/customtextform.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:_96kuliapp/utils/selectlanguage.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:text_divider/text_divider.dart';

class LoginScreen2 extends StatelessWidget {
  const LoginScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    Get.delete<LocationController>();
    Get.delete<ExploreAppController>();
    LoginController logincontroller = Get.put(LoginController());

    return WillPopScope(
      onWillPop: () async {
        if (navigatorKey.currentState!.canPop()) {
          Get.back();
        } else {
          navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
            builder: (context) => WelcomeScreen(),
          ));
        }
        return false;
      },
      child: Scaffold(
        body: SafeArea(
            child: Column(
          children: [
            Center(
              child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(204, 40, 77, 1),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 80,
                            width: 150,
                            child: Image.asset("assets/96klogo.png"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Obx(
                          () => InkWell(
                            onTap: () {
                              logincontroller
                                  .updateSelectedOption("Phone Number");
                              logincontroller.errordata.value = {};
                            },
                            child: Row(
                              children: [
                                Radio(
                                  fillColor: WidgetStateProperty.all(
                                      AppTheme.primaryColor),
                                  value: "Phone Number",
                                  groupValue:
                                      logincontroller.selectedOption.value,
                                  onChanged: (value) {
                                    logincontroller
                                        .updateSelectedOption(value as String);
                                    logincontroller.errordata.value = {};
                                  },
                                ),
                                Text(
                                  AppLocalizations.of(context)!.mobileNumber,
                                  style: CustomTextStyle.fieldName,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 30),
                        Obx(
                          () => InkWell(
                            onTap: () {
                              logincontroller.updateSelectedOption("email");
                              logincontroller.errordata.value = {};
                            },
                            child: Row(
                              children: [
                                Radio(
                                  fillColor: WidgetStateProperty.all(
                                      AppTheme.primaryColor),
                                  value: "email",
                                  groupValue:
                                      logincontroller.selectedOption.value,
                                  onChanged: (value) {
                                    logincontroller
                                        .updateSelectedOption(value as String);
                                    logincontroller.errordata.value = {};
                                  },
                                ),
                                Text(
                                  AppLocalizations.of(context)!.emailID,
                                  style: CustomTextStyle.fieldName,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Obx(() {
                      if (logincontroller.selectedOption.value == "email") {
                        return emailAddress(context);
                      } else if (logincontroller.selectedOption.value ==
                          "Phone Number") {
                        return phoneNumber(context);
                      } else {
                        return const SizedBox();
                      }
                    }),
                  ],
                ),
              ),
            ),
            // Fixed "Register" Section at the Bottom
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
              child: Center(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.donthaveProfile,
                      style: CustomTextStyle.bodytext,
                      textAlign: TextAlign.center,
                    ),
                    InkWell(
                      onTap: () {
                        navigatorKey.currentState!.push(MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ));
                      },
                      child: Text(
                        AppLocalizations.of(context)!.registerNowExplamation,
                        style: CustomTextStyle.textbuttonRed,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}

Column emailAddress(BuildContext context) {
  final facebookAppEvents = FacebookAppEvents();
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  validateEmail(String? value) {
    value = value?.trim();
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.pleaseEnterRegisteredEmail;
    }

    // Updated regex for stricter email validation (TLD length between 2 and 4)
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9]+[a-zA-Z0-9._%+-]*@[a-zA-Z0-9.-]+\.[a-zA-Z]{3,4}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return AppLocalizations.of(context)!.pleaseEnterRegisteredEmail;
    }

    return null; // Email is valid
  }

  LoginController logincontroller = Get.find<LoginController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        AppLocalizations.of(context)!.loginwithotporPasswordDecForEmail,
        style: CustomTextStyle.bodytextSmall,
      ),
      const SizedBox(
        height: 20,
      ),
      Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.loginwithEmail,
                style: CustomTextStyle.fieldName,
              ),
              CustomTextField(
                  onChange: (phoneNumber) {
                    // Clear the identifier error messages
                    logincontroller.errordata['errorData']?['identifier'] = [];

                    // Trigger an update by re-assigning the observable map
                    logincontroller.errordata.refresh();

                    print('Changed to $phoneNumber');
                    return null;
                  },
                  textEditingController: logincontroller.emailController,
                  validator: validateEmail,
                  HintText: AppLocalizations.of(context)!.enterEmailAddress),
              Obx(() {
                // Debugging: Check the contents of errordata
                print("Error Data: ${logincontroller.errordata}");

                if (logincontroller.errordata.isNotEmpty) {
                  // Extract error messages
                  List<dynamic>? identifierMessages =
                      logincontroller.errordata['errorData']?['identifier'];

                  // Create a list to hold all error messages
                  List<String> allErrorMessages = [];

                  // Add identifier messages if they exist
                  if (identifierMessages != null &&
                      identifierMessages.isNotEmpty) {
                    allErrorMessages.addAll(
                        identifierMessages.map((msg) => msg.toString()));
                  }

                  // Display all error messages if any exist
                  if (allErrorMessages.isNotEmpty) {
                    String errorMessage = allErrorMessages
                        .join(', '); // Join all messages into a single string
                    return Padding(
                      padding: const EdgeInsets.only(left: 18.0, top: 5),
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                }
                return const SizedBox(); // Return an empty widget if no error
              }),
              const SizedBox(
                height: 20,
              ),
              Text(
                AppLocalizations.of(context)!.password,
                style: CustomTextStyle.fieldName,
              ),
              CustomTextField(
                  onChange: (phoneNumber) {
                    // Clear the identifier error messages
                    logincontroller.errordata['errorData']?['password'] = [];

                    // Trigger an update by re-assigning the observable map
                    logincontroller.errordata.refresh();

                    print('Changed to $phoneNumber');
                    return null;
                  },
                  suffixIcon: logincontroller.hidePassword.value
                      ? IconButton(
                          onPressed: () {
                            logincontroller.alterPasswordVisiblity();
                          },
                          icon: Icon(
                            Icons.visibility,
                            color: AppTheme.selectedOptionColor,
                          ))
                      : IconButton(
                          onPressed: () {
                            logincontroller.alterPasswordVisiblity();
                          },
                          icon: Icon(
                            Icons.visibility_off,
                            color: Colors.grey.shade500,
                          )),
                  obscuretext:
                      logincontroller.hidePassword.value ? false : true,
                  textEditingController: logincontroller.passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!
                          .pleaseenterYourPassword;
                    }
                    return null; // Return null if the validation passes
                  },
                  HintText: AppLocalizations.of(context)!.enterPasswordLogin),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                        onTap: () {
                          //  Get.toNamed(AppRouteNames.forgetPasswordScreen);
                          navigatorKey.currentState!.push(MaterialPageRoute(
                            builder: (context) => const ForgetPasswordScreen(),
                          ));
                        },
                        child: Text(
                          AppLocalizations.of(context)!.forgotPasswordQuestion,
                          style: CustomTextStyle.textbutton,
                        )),
                  )
                ],
              ),
              Obx(() {
                // Debugging: Check the contents of errordata
                print("Error Data: ${logincontroller.errordata}");

                if (logincontroller.errordata.isNotEmpty) {
                  // Extract error messages
                  List<dynamic>? passwordMessages =
                      logincontroller.errordata['errorData']?['password'];

                  // Create a list to hold all error messages
                  List<String> allErrorMessages = [];

                  // Add identifier messages if they exist

                  // Add password messages if they exist
                  if (passwordMessages != null && passwordMessages.isNotEmpty) {
                    allErrorMessages
                        .addAll(passwordMessages.map((msg) => msg.toString()));
                  }

                  // Display all error messages if any exist
                  if (allErrorMessages.isNotEmpty) {
                    String errorMessage = allErrorMessages
                        .join(', '); // Join all messages into a single string
                    return Padding(
                      padding: const EdgeInsets.only(left: 18.0, top: 5),
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                }
                return const SizedBox(); // Return an empty widget if no error
              }),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: SizedBox(
                    width: 180,
                    child: ElevatedButton(onPressed: () {
                      print("Email login");
                      /*analytics.logEvent(
  name: 'app_login_with_pass_complete',
  parameters: {'method': 'password'}
).then((_) => print('Event logged successfully'))
  .catchError((e) => print('Error logging event: $e'));*/
                      /*  Navigator.push(context, MaterialPageRoute(builder: (context) {
               return UpgradePlan();
             },));*/
                      // navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => UserInfoStepFour(),), (route) => false,);
                      if (formKey.currentState!.validate()) {
                        print(
                            "This is ${logincontroller.emailController} and ${logincontroller.passwordController}");
                        logincontroller.loginwithEmailPassword(
                            email: logincontroller.emailController.text.trim(),
                            password:
                                logincontroller.passwordController.text.trim());
                      }
                    }, child: Obx(
                      () {
                        if (logincontroller.isLoading.value) {
                          return const CircularProgressIndicator(
                            color: Colors.white,
                          );
                        } else {
                          return FittedBox(
                              child: Text(
                            AppLocalizations.of(context)!.loginMe,
                            style: CustomTextStyle.elevatedButton,
                          ));
                        }
                      },
                    )),
                  ),
                ),
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextDivider.horizontal(
                  text: const Text(
                    "OR",
                    style: CustomTextStyle.bodytext,
                  ),
                ),
              )),
              Center(
                child: SizedBox(
                  width: 180,
                  child: ElevatedButton(
                    onPressed: () {
                      // _logincontroller.loginWithOtpEmail(email: _logincontroller.emailController.text.trim());
                      logincontroller.errordata.value = {};
                      navigatorKey.currentState!.push(
                        MaterialPageRoute(
                          builder: (context) => const LoginWithOTPScreen(),
                        ),
                      );
                    },
                    child: FittedBox(
                      child: Text(
                        AppLocalizations.of(context)!.loginwithOTP,
                        style: CustomTextStyle.elevatedButton,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ))
    ],
  );
}

Column phoneNumber(BuildContext context) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  LoginController logincontroller = Get.find<LoginController>();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        AppLocalizations.of(context)!.loginwithotporPasswordDecForMobile,
        style: CustomTextStyle.bodytextSmall,
      ),
      const SizedBox(
        height: 20,
      ),
      Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.loginwithMobile,
                style: CustomTextStyle.fieldName,
              ),
              const SizedBox(
                height: 10,
              ),
              PhoneFormField(
                autocorrect: true,
                controller: logincontroller.phoneNumberController,
                style: CustomTextStyle.bodytext,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  errorStyle: CustomTextStyle.errorText,
                  contentPadding: const EdgeInsets.all(18),
                  hintText:
                      AppLocalizations.of(context)!.entermobileNumberLogin,
                  labelStyle: CustomTextStyle.bodytext,
                  hintStyle: CustomTextStyle.hintText,
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
                ),
                validator: PhoneValidator.compose([
                  PhoneValidator.required(
                      errorText: AppLocalizations.of(context)!
                          .pleaseEnterRegisteredMobileNumber,
                      context),
                  PhoneValidator.validMobile(
                      errorText: AppLocalizations.of(context)!
                          .pleaseEntervalidPhoneNumber,
                      context)
                ]),
                countrySelectorNavigator: const CountrySelectorNavigator.page(),
                onChanged: (phoneNumber) {
                  // Clear the identifier error messages
                  logincontroller.errordata['errorData']?['identifier'] = [];

                  // Trigger an update by re-assigning the observable map
                  logincontroller.errordata.refresh();

                  print('Changed to $phoneNumber');
                },
                enabled: true,
                isCountrySelectionEnabled: true,
                isCountryButtonPersistent: true,
                countryButtonStyle: const CountryButtonStyle(
                    showDialCode: true,
                    showIsoCode: false,
                    showFlag: true,
                    flagSize: 16),
              ),
              Obx(() {
                // Debugging: Check the contents of errordata
                print("Error Data: ${logincontroller.errordata}");

                if (logincontroller.errordata.isNotEmpty) {
                  // Extract error messages
                  List<dynamic>? identifierMessages =
                      logincontroller.errordata['errorData']?['identifier'];
                  List<dynamic>? mobileMessages =
                      logincontroller.errordata['errorData']?['mobile'];

                  // Create a list to hold all error messages
                  List<String> allErrorMessages = [];

                  // Add identifier messages if they exist
                  if (identifierMessages != null &&
                      identifierMessages.isNotEmpty) {
                    allErrorMessages.addAll(
                        identifierMessages.map((msg) => msg.toString()));
                  }
                  if (mobileMessages != null && mobileMessages.isNotEmpty) {
                    allErrorMessages.addAll(mobileMessages.map(
                      (e) => e.toString(),
                    ));
                  }
                  // Add password messages if they exist

                  // Display all error messages if any exist
                  if (allErrorMessages.isNotEmpty) {
                    String errorMessage = allErrorMessages
                        .join(', '); // Join all messages into a single string
                    return Padding(
                      padding: const EdgeInsets.only(left: 18.0, top: 5),
                      child:
                          Text(errorMessage, style: CustomTextStyle.errorText),
                    );
                  }
                }
                return const SizedBox(); // Return an empty widget if no error
              }),
              const SizedBox(
                height: 20,
              ),
              Text(
                AppLocalizations.of(context)!.password,
                style: CustomTextStyle.fieldName,
              ),
              CustomTextField(
                  onChange: (p0) {
                    logincontroller.errordata['errorData']?['password'] = [];

                    // Trigger an update by re-assigning the observable map
                    logincontroller.errordata.refresh();

                    print('Changed to $phoneNumber');
                    return null;
                  },
                  suffixIcon: logincontroller.hidePassword.value
                      ? IconButton(
                          onPressed: () {
                            logincontroller.alterPasswordVisiblity();
                          },
                          icon: Icon(
                            Icons.visibility,
                            color: AppTheme.selectedOptionColor,
                          ))
                      : IconButton(
                          onPressed: () {
                            logincontroller.alterPasswordVisiblity();
                          },
                          icon: Icon(
                            Icons.visibility_off,
                            color: Colors.grey.shade500,
                          )),
                  obscuretext:
                      logincontroller.hidePassword.value ? false : true,
                  textEditingController: logincontroller.passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!
                          .pleaseenterYourPassword;
                    }
                    return null; // Return null if the validation passes
                  },
                  HintText: AppLocalizations.of(context)!.enterPasswordLogin),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      navigatorKey.currentState!.push(MaterialPageRoute(
                        builder: (context) => const ForgetPasswordScreen(),
                      ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppLocalizations.of(context)!.forgotPasswordQuestion,
                        style: CustomTextStyle.textbutton,
                      ),
                    ),
                  )
                ],
              ),
              Obx(() {
                // Debugging: Check the contents of errordata
                print("Error Data: ${logincontroller.errordata}");

                if (logincontroller.errordata.isNotEmpty) {
                  // Extract error messages
                  List<dynamic>? passwordMessages =
                      logincontroller.errordata['errorData']?['password'];

                  // Create a list to hold all error messages
                  List<String> allErrorMessages = [];

                  // Add password messages if they exist
                  if (passwordMessages != null && passwordMessages.isNotEmpty) {
                    allErrorMessages
                        .addAll(passwordMessages.map((msg) => msg.toString()));
                  }

                  // Display all error messages if any exist
                  if (allErrorMessages.isNotEmpty) {
                    String errorMessage = allErrorMessages
                        .join(', '); // Join all messages into a single string
                    return Padding(
                      padding: const EdgeInsets.only(left: 18.0, top: 5),
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                }
                return const SizedBox(); // Return an empty widget if no error
              }),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: SizedBox(
                    width: 180,
                    child: ElevatedButton(onPressed: () {
                      if (formKey.currentState!.validate()) {
                        logincontroller.loginwithPhonePassword(
                            password:
                                logincontroller.passwordController.text.trim(),
                            phoneNumber: logincontroller
                                .phoneNumberController.value.nsn);
                      }
                      /*    if(_logincontroller.phNumberController.text.trim() == ""){
        print("Empty ph");
        _logincontroller.phvalidation.value = false;
    
       _logincontroller.phautovalidation.value = true;
      }else{
        _logincontroller.phvalidation.value = true;
      }*/
                    }, child: Obx(
                      () {
                        if (logincontroller.isLoading.value == true) {
                          return const CircularProgressIndicator(
                            color: Colors.white,
                          );
                        } else {
                          return FittedBox(
                              child: Text(
                            AppLocalizations.of(context)!.loginMe,
                            style: CustomTextStyle.elevatedButton,
                          ));
                        }
                      },
                    )),
                  ),
                ),
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextDivider.horizontal(
                  text: const Text(
                    "OR",
                    style: CustomTextStyle.bodytext,
                  ),
                ),
              )),
              Center(
                  child: SizedBox(
                width: 180,
                child: ElevatedButton(
                    onPressed: () {
                      logincontroller.errordata.value = {};
                      logincontroller.phvalidation.value = true;
                      navigatorKey.currentState!.push(MaterialPageRoute(
                        builder: (context) => const LoginWithOTPScreen(),
                      ));
                    },
                    child: FittedBox(
                        child: Text(
                      AppLocalizations.of(context)!.loginwithOTP,
                      style: CustomTextStyle.elevatedButton,
                    ))),
              )),
              const SizedBox(
                height: 10,
              ),
            ],
          )),
    ],
  );
}
