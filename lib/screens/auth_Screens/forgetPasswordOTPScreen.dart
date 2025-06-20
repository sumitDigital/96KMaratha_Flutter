import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:_96kuliapp/commons/dialogues/logoutDialogoue.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/auth/forgetPasswordController.dart';
import 'package:_96kuliapp/controllers/timerControllerForOTP.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/auth_Screens/loginScreen2.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgetPasswordOTP extends StatelessWidget {
  const ForgetPasswordOTP({super.key});

  @override
  Widget build(BuildContext context) {
    String? language = sharedPreferences!.getString("Language");

    final TimerControllerForOTP timerController =
        Get.put(TimerControllerForOTP());
    final ForgetPasswordcontroller forgetPasswordcontroller =
        Get.put(ForgetPasswordcontroller());
    forgetPasswordcontroller.resendOTP();
    timerController.resendOtp();
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
                      // "Logout",
                      style: CustomTextStyle.textbuttonRed,
                    ),
                  ),
                ],
              ),
              Center(
                  child: SizedBox(
                height: 200,
                width: 200,
                child: Image.asset("assets/otpScreen.png"),
              )),
              const SizedBox(
                height: 20,
              ),
              Center(
                  child: Text(
                textAlign: TextAlign.center,
                // "OTP Verification",
                AppLocalizations.of(context)!.otpverificationTitle,
                style: CustomTextStyle.headlineMain,
              )),
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Text(
                  textAlign: TextAlign.center,
                  // "Enter OTP",
                  AppLocalizations.of(context)!.enterotp,
                  style: CustomTextStyle.headlineMain.copyWith(fontSize: 17),
                ),
              ),
              Center(
                  child: Text(
                // "The verification code has been sent to your registered email ID & mobile number",
                AppLocalizations.of(context)!.otpVerificationSubTitle,
                style: CustomTextStyle.textbutton,
                textAlign: TextAlign.center,
              )),
              const SizedBox(
                height: 20,
              ),
              Center(
                  child: Pinput(
                controller: forgetPasswordcontroller.otpController,
                length: 6,
                onCompleted: (value) {
                  print("Value is this $value");
                  forgetPasswordcontroller.verifyOtp(otp: value);
                },
              )),
              const SizedBox(
                height: 20,
              ),
              Center(
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
                            timerController.resendOtp(); // Restart the timer
                            forgetPasswordcontroller.resendOTP();
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
                print("Error Data: ${forgetPasswordcontroller.errordata}");

                if (forgetPasswordcontroller.errordata.isNotEmpty) {
                  // Extract error messages
                  List<dynamic>? identifierMessages = forgetPasswordcontroller
                      .errordata['errorData']?['identifier'];
                  List<dynamic>? passwordMessages = forgetPasswordcontroller
                      .errordata['errorData']?['password'];
                  List<dynamic>? mobileMessages = forgetPasswordcontroller
                      .errordata['errorData']?['mobile'];
                  List<dynamic>? otpMessages =
                      forgetPasswordcontroller.errordata['errorData']?['otp'];

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
                  if (passwordMessages != null && passwordMessages.isNotEmpty) {
                    allErrorMessages
                        .addAll(passwordMessages.map((msg) => msg.toString()));
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
  }
}
