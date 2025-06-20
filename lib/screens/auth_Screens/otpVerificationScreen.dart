import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/dialogues/logoutDialogoue.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/auth/logincontroller.dart';
import 'package:_96kuliapp/controllers/timerControllerForOTP.dart';
import 'package:_96kuliapp/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pinput/pinput.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());
    loginController.resendOTP();
    String? language = sharedPreferences!.getString("Language");

    final TimerControllerForOTP timerController =
        Get.put(TimerControllerForOTP());
    timerController.resendOtp();
    return Obx(
      () {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              child: SafeArea(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () async {
                            //       Get.back();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const Logout(
                                  page: "incompleteForms",
                                );
                              },
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context)!.logout,
                            style: CustomTextStyle.textbuttonRed,
                          ))
                    ],
                  ),
                  Center(
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: Image.asset("assets/otpScreen.png"),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      AppLocalizations.of(context)!.otpverificationTitle,
                      // "OTP Verification login",
                      style: CustomTextStyle.headlineMain,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      // "Enter OTP",
                      AppLocalizations.of(context)!.enterotp,
                      style:
                          CustomTextStyle.headlineMain.copyWith(fontSize: 17),
                    ),
                  ),
                  Center(
                      child: Text(
                    AppLocalizations.of(context)!.otpVerificationSubTitle,
                    style: CustomTextStyle.textbutton,
                    textAlign: TextAlign.center,
                  )),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Pinput(
                      controller: loginController.otpController,
                      length: 6,
                      onCompleted: (value) {
                        loginController.isLoading.value = true;
                        print("Value is this $value");
                        if (loginController.otpController.text.length == 6) {
                          loginController.isLoading.value = false;
                          loginController.verifyOtp(otp: value);
                        } else {
                          print("Please enter the OTP completely.");
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  loginController.isLoading.value == true
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.primaryColor,
                          ),
                        )
                      : Center(
                          child: Obx(() {
                            return timerController.timerActive.value
                                ? Text(
                                    language == "en"
                                        ? "You can resend OTP in ${timerController.remainingSeconds.value} sec"
                                        : "तुम्ही ${timerController.remainingSeconds.value} सेकंदांत ओटीपी पुन्हा पाठवू शकता.",
                                    style: CustomTextStyle.textbutton,
                                    textAlign: TextAlign.center,
                                  )
                                : TextButton(
                                    onPressed: () {
                                      timerController
                                          .resendOtp(); // Restart the timer
                                      loginController.resendOTP();
                                    },
                                    child: Text(
                                        language == "en"
                                            ? "Resend OTP"
                                            : "ओटीपी पुन्हा पाठवा",
                                        style: CustomTextStyle.textbutton),
                                  );
                          }),
                        ),
                  Obx(() {
                    // Debugging: Check the contents of errordata
                    print("Error Data: ${loginController.errordata}");

                    if (loginController.errordata.isNotEmpty) {
                      // Extract error messages
                      List<dynamic>? identifierMessages =
                          loginController.errordata['errorData']?['identifier'];
                      List<dynamic>? passwordMessages =
                          loginController.errordata['errorData']?['password'];
                      List<dynamic>? mobileMessages =
                          loginController.errordata['errorData']?['mobile'];
                      List<dynamic>? otpMessages =
                          loginController.errordata['errorData']?['otp'];

                      // Create a list to hold all error messages
                      List<String> allErrorMessages = [];

                      // Add identifier messages if they exist
                      if (identifierMessages != null &&
                          identifierMessages.isNotEmpty) {
                        allErrorMessages.addAll(
                            identifierMessages.map((msg) => msg.toString()));
                      }
                      if (otpMessages != null && otpMessages.isNotEmpty) {
                        allErrorMessages.addAll(otpMessages.map(
                          (e) => e.toString(),
                        ));
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
                        String errorMessage = allErrorMessages.join(
                            ', '); // Join all messages into a single string
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }
                    }
                    return const SizedBox(); // Return an empty widget if no error
                  }),
                ],
              )),
            ),
          ),
        );
      },
    );
  }
}
