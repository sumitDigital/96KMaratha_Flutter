import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/auth/forgetPasswordController.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:_96kuliapp/utils/customtextform.dart';
import 'package:_96kuliapp/utils/selectlanguage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:text_divider/text_divider.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final facebookAppEvents = FacebookAppEvents();

    facebookAppEvents.logEvent(name: "Fb_96k_app_forget_password_screenview");

    final ForgetPasswordcontroller forgetPasswordController =
        Get.put(ForgetPasswordcontroller());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: SafeArea(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: SizedBox(
                        width: 25,
                        height: 20,
                        child: SvgPicture.asset(
                          "assets/arrowback.svg",
                          fit: BoxFit.fitWidth,
                        ),
                      )),
                  //    const SelectLanguage()
                ],
              ),

              Center(
                  child: SizedBox(
                height: 200,
                width: 200,
                child: Image.asset("assets/ForgetPassword.png"),
              )),
              const SizedBox(
                height: 10,
              ),
              // Forget
              Center(
                  child: Text(
                      AppLocalizations.of(context)!.forgotPasswordQuestion,
                      style: CustomTextStyle.headlineMain)),
              const SizedBox(
                height: 50,
              ),
              Text(
                AppLocalizations.of(context)!.enterEmailNoOrPhoneNumber,
                style: CustomTextStyle.headlineMain2.copyWith(fontSize: 17),
              ),
              Text(
                AppLocalizations.of(context)!.weWillSendYouOTPToReset,
                style: CustomTextStyle.textbutton,
              ),
              const SizedBox(
                height: 20,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() => InkWell(
                        onTap: () {
                          forgetPasswordController
                              .updateSelectedOption("Phone Number");
                          forgetPasswordController.errordata.value = {};
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio(
                              fillColor:
                                  WidgetStatePropertyAll(AppTheme.primaryColor),
                              value: "Phone Number",
                              groupValue:
                                  forgetPasswordController.selectedOption.value,
                              onChanged: (value) {
                                forgetPasswordController
                                    .updateSelectedOption(value as String);
                                forgetPasswordController.errordata.value = {};
                              },
                            ),
                            Text(
                              AppLocalizations.of(context)!.mobileNumber,
                              style: CustomTextStyle.fieldName,
                            )
                          ],
                        ),
                      )),
                  const SizedBox(
                    width: 30,
                  ),
                  Obx(() => InkWell(
                        onTap: () {
                          forgetPasswordController
                              .updateSelectedOption("email");
                          forgetPasswordController.errordata.value = {};
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Radio(
                              fillColor:
                                  WidgetStatePropertyAll(AppTheme.primaryColor),
                              value: "email",
                              groupValue:
                                  forgetPasswordController.selectedOption.value,
                              onChanged: (value) {
                                forgetPasswordController
                                    .updateSelectedOption(value as String);
                                forgetPasswordController.errordata.value = {};
                              },
                            ),
                            Text(
                              AppLocalizations.of(context)!.emailID,
                              style: CustomTextStyle.fieldName,
                            )
                          ],
                        ),
                      )),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(
                () {
                  if (forgetPasswordController.selectedOption.value ==
                      "email") {
                    return emailAddress(context);
                  } else {
                    return phoneNumber(context);
                  }
                },
              )
            ],
          )),
        ),
      ),
    );
  }

  Column phoneNumber(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    //  LoginController _logincontroller = Get.find<LoginController>();
    ForgetPasswordcontroller forgetPasswordController =
        Get.put(ForgetPasswordcontroller());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
//  Text("Login with OTP or password by entering your registered mobile number to login." , style: CustomTextStyle.bodytextSmall,),

        Text(
          AppLocalizations.of(context)!.mobileNumber,
          style: CustomTextStyle.fieldName,
        ),
        Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*    Padding(
  padding: const EdgeInsets.only(top: 6.0),
  child: SizedBox(
    child: IntlPhoneField(
  pickerDialogStyle: PickerDialogStyle(backgroundColor: Colors.white),
  controller: _logincontroller.phNumberController,
  dropdownIconPosition: IconPosition.trailing,
  flagsButtonPadding: const EdgeInsets.all(15),
  initialCountryCode: 'IN',
  dropdownTextStyle: CustomTextStyle.hintText,
  dropdownIcon: Icon(
    Icons.arrow_drop_down,
    color: Colors.grey.shade600,
  ),
  keyboardType: TextInputType.phone,
  style: CustomTextStyle.bodytext,
  decoration: InputDecoration(
    errorStyle: CustomTextStyle.errorText,
    contentPadding: const EdgeInsets.all(18),
    hintText: "Enter Phone Number",
    labelStyle: CustomTextStyle.bodytext,
    hintStyle: CustomTextStyle.hintText,
    errorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(color: Colors.red),
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
  autovalidateMode: AutovalidateMode.disabled,
  validator: (value) {
    if (value == null || value.number.isEmpty) {
      return 'Phone Number cannot be empty';
    } else if (value.number.length < 10) {
      return 'Phone Number must be at least 10 digits';
    }
    return null;
  },
  onChanged: (phone) {
    // Capture and store the country code in registrationController
  },
  disableLengthCheck: true,
),

  ),
),*/
/*
Obx(() {
  if(_logincontroller.phvalidation.value == false){
 return Padding(
   padding: const EdgeInsets.all(8.0),
   child: Text("Phone Number Field Cannot be Empty" , style: CustomTextStyle.errorText,),
 ) ;
}else{
  return SizedBox();
}
},),*/
                const SizedBox(
                  height: 10,
                ),
                PhoneFormField(
                  controller: forgetPasswordController.phoneNumberController,
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
                            .pleaseEntervalidPhoneNumber /* "Enter valid phone number" */,
                        context)
                  ]),
                  countrySelectorNavigator:
                      const CountrySelectorNavigator.page(),
                  onChanged: (phoneNumber) {
                    // Clear the identifier error messages
                    forgetPasswordController.errordata['errorData']
                        ?['identifier'] = [];

                    // Trigger an update by re-assigning the observable map
                    forgetPasswordController.errordata.refresh();

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
                  print("Error Data: ${forgetPasswordController.errordata}");

                  if (forgetPasswordController.errordata.isNotEmpty) {
                    // Extract error messages
                    List<dynamic>? identifierMessages = forgetPasswordController
                        .errordata['errorData']?['identifier'];
                    List<dynamic>? passwordMessages = forgetPasswordController
                        .errordata['errorData']?['password'];
                    List<dynamic>? mobileMessages = forgetPasswordController
                        .errordata['errorData']?['mobile'];

                    // Create a list to hold all error messages
                    List<String> allErrorMessages = [];

                    // Add identifier messages if they exist
                    if (identifierMessages != null &&
                        identifierMessages.isNotEmpty) {
                      allErrorMessages.addAll(
                          identifierMessages.map((msg) => msg.toString()));
                    }

                    // Add password messages if they exist
                    if (passwordMessages != null &&
                        passwordMessages.isNotEmpty) {
                      allErrorMessages.addAll(
                          passwordMessages.map((msg) => msg.toString()));
                    }

                    if (mobileMessages != null && mobileMessages.isNotEmpty) {
                      allErrorMessages.addAll(mobileMessages.map(
                        (e) => e.toString(),
                      ));
                    }

                    // Display all error messages if any exist
                    if (allErrorMessages.isNotEmpty) {
                      String errorMessage = allErrorMessages
                          .join(', '); // Join all messages into a single string
                      return Padding(
                        padding: const EdgeInsets.only(left: 18.0, top: 5),
                        child: Text(errorMessage,
                            style: CustomTextStyle.errorText),
                      );
                    }
                  }
                  return const SizedBox(); // Return an empty widget if no error
                }),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: ElevatedButton(onPressed: () {
                      if (formKey.currentState!.validate()) {
                        //  _forgetPasswordController.loginWithOtpMobile(mobile: _logincontroller.phNumberController.text.trim() );
                        forgetPasswordController.phoneOTP(
                            phoneNumber: forgetPasswordController
                                .phoneNumberController.value.nsn);
                      }
                      /*   if(_logincontroller.phNumberController.text.trim() == ""){
      print("Empty ph");
      _logincontroller.phvalidation.value = false;
   

    }else{
     
      
      _logincontroller.phvalidation.value = true;
    }*/
                    }, child: Obx(
                      () {
                        if (forgetPasswordController.isLoading.value == true) {
                          return const CircularProgressIndicator(
                            color: Colors.white,
                          );
                        } else {
                          return Text(
                            AppLocalizations.of(context)!.sendOTP,
                            style: CustomTextStyle.elevatedButton,
                          );
                        }
                      },
                    )),
                  ),
                ),
              ],
            )),
      ],
    );
  }

  Column emailAddress(BuildContext context) {
    ForgetPasswordcontroller forgetPasswordcontroller =
        Get.put(ForgetPasswordcontroller());
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text("Login with OTP or password by entering your registered Email Address to login." , style: CustomTextStyle.bodytextSmall,),

        Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.emailID,
                  style: CustomTextStyle.fieldName,
                ),
                CustomTextField(
                    onChange: (value) {
                      forgetPasswordcontroller.errordata['errorData']
                          ?['identifier'] = [];

                      // Trigger an update by re-assigning the observable map
                      forgetPasswordcontroller.errordata.refresh();
                      return null;
                    },
                    textEditingController:
                        forgetPasswordcontroller.emailController,
                    validator: validateEmail,
                    HintText: AppLocalizations.of(context)!.enterEmailAddress),
                const SizedBox(
                  height: 20,
                ),
                Obx(() {
                  // Debugging: Check the contents of errordata
                  print("Error Data: ${forgetPasswordcontroller.errordata}");

                  if (forgetPasswordcontroller.errordata.isNotEmpty) {
                    // Extract error messages
                    List<dynamic>? identifierMessages = forgetPasswordcontroller
                        .errordata['errorData']?['identifier'];
                    List<dynamic>? passwordMessages = forgetPasswordcontroller
                        .errordata['errorData']?['password'];
                    List<dynamic>? mobileMessages = forgetPasswordcontroller
                        .errordata['errorData']?['mobile'];

                    // Create a list to hold all error messages
                    List<String> allErrorMessages = [];

                    // Add identifier messages if they exist
                    if (identifierMessages != null &&
                        identifierMessages.isNotEmpty) {
                      allErrorMessages.addAll(
                          identifierMessages.map((msg) => msg.toString()));
                    }

                    // Add password messages if they exist
                    if (passwordMessages != null &&
                        passwordMessages.isNotEmpty) {
                      allErrorMessages.addAll(
                          passwordMessages.map((msg) => msg.toString()));
                    }

                    if (mobileMessages != null && mobileMessages.isNotEmpty) {
                      allErrorMessages.addAll(mobileMessages.map(
                        (e) => e.toString(),
                      ));
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
                    child: ElevatedButton(onPressed: () {
                      if (formKey.currentState!.validate()) {
                        print(
                            "This is ${forgetPasswordcontroller.emailController.text} ");
                        // _forgetPasswordcontroller.loginWithOtpEmail(email: _forgetPasswordcontroller.emailController.text.trim());
                        forgetPasswordcontroller.emailOTP(
                            email: forgetPasswordcontroller.emailController.text
                                .trim());
                      }
                    }, child: Obx(
                      () {
                        if (forgetPasswordcontroller.isLoading.value == true) {
                          return const CircularProgressIndicator(
                            color: Colors.white,
                          );
                        } else {
                          return Text(
                            AppLocalizations.of(context)!.sendOTP,
                            style: CustomTextStyle.elevatedButton,
                          );
                        }
                      },
                    )),
                  ),
                ),
              ],
            ))
      ],
    );
  }
}
