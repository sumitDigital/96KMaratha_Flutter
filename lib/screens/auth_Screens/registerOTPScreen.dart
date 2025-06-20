import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:_96kuliapp/commons/dialogues/logoutDialogoue.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/auth/otpVerificationController.dart';
import 'package:_96kuliapp/controllers/auth/registerController.dart';
import 'package:_96kuliapp/controllers/timerControllerForOTP.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/auth_Screens/loginScreen2.dart';
import 'package:_96kuliapp/utils/buttonContainer.dart';
import 'package:_96kuliapp/utils/customtextform.dart';
import 'package:_96kuliapp/utils/selectlanguage.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterOTPScreen extends StatefulWidget {
  const RegisterOTPScreen({super.key});

  @override
  State<RegisterOTPScreen> createState() => _RegisterOTPScreenState();
}

class _RegisterOTPScreenState extends State<RegisterOTPScreen> {
  final RegistrationScreenController registrationScreenController =
      Get.put(RegistrationScreenController());
  final OtpVerificationController otpVerificationController =
      Get.put(OtpVerificationController());
  final TimerControllerForOTP timerController =
      Get.put(TimerControllerForOTP());
  final mybox = Hive.box('myBox');

  String? language = sharedPreferences!.getString("Language");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // registrationScreenController.resendOTP();

    print("THIS IS MEMBER ID on register ${mybox.get("memberIDOTP")}");
  }

  @override
  Widget build(BuildContext context) {
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
                        // "Logout",
                        style: CustomTextStyle.textbuttonRed,
                      ))
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
                  AppLocalizations.of(context)!.otpverificationTitle,
                  // "OTP Verification",
                  style: CustomTextStyle.headlineMain,
                ),
              ),
              Obx(
                () {
                  if (registrationScreenController.showOTPLOG.value == false) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Text(
                            AppLocalizations.of(context)!
                                .otpVerificationSubTitle2,
                            // "Complete your profile verification by sending an OTP to the provided registered Mobile Number / Email ID",
                            style: CustomTextStyle.textbutton,
                            textAlign: TextAlign.center,
                          ),
                        )),
                        Obx(() {
                          // Debugging: Check the contents of errordata
                          if (registrationScreenController
                                  .showOTPLOGerror.value ==
                              true) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Please Tap Send OTP to get OTP",
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          } else {
                            Obx(() {
                              // Debugging: Check the contents of errordata
                              print(
                                  "Error Data: ${otpVerificationController.errordata}");

                              // Ensure errordata is not empty
                              if (otpVerificationController
                                  .errordata.isNotEmpty) {
                                // Extract error messages
                                List<dynamic>? otpMessages =
                                    otpVerificationController
                                        .errordata['errors']?['otp'];

                                // Check if OTP messages exist
                                print("OTP Messages: $otpMessages");

                                // Create a list to hold all error messages
                                List<String> allErrorMessages = [];

                                // Add OTP messages if they exist
                                if (otpMessages != null &&
                                    otpMessages.isNotEmpty) {
                                  allErrorMessages.addAll(
                                      otpMessages.map((e) => e.toString()));
                                }

                                // Display all error messages if any exist
                                if (allErrorMessages.isNotEmpty) {
                                  String errorMessage = allErrorMessages.join(
                                      ', '); // Join all messages into a single string
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      errorMessage, // Removed extra "Error" suffix for clarity
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  );
                                }
                              }
                              return const SizedBox(); // Return an empty widget if no error
                            });
                          }
                          // Ensure errordata is not empty
                          if (otpVerificationController.errordata.isNotEmpty) {
                            // Extract error messages
                            List<dynamic>? otpMessages =
                                otpVerificationController.errordata['errors']
                                    ?['otp'];

                            // Check if OTP messages exist
                            print("OTP Messages: $otpMessages");

                            // Create a list to hold all error messages
                            List<String> allErrorMessages = [];

                            // Add OTP messages if they exist
                            if (otpMessages != null && otpMessages.isNotEmpty) {
                              allErrorMessages
                                  .addAll(otpMessages.map((e) => e.toString()));
                            }

                            // Display all error messages if any exist
                            if (allErrorMessages.isNotEmpty) {
                              String errorMessage = allErrorMessages.join(
                                  ', '); // Join all messages into a single string
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  errorMessage, // Removed extra "Error" suffix for clarity
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
                        Center(
                          child: ElevatedButton(
                              onPressed: () {
                                registrationScreenController.updateOTPLOG();
                              },
                              child: Text(
                                AppLocalizations.of(context)!.sendOTP,
                                // "Send OTP",
                                style: CustomTextStyle.elevatedButton,
                              )),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: Text(
                            AppLocalizations.of(context)!
                                .otpVerificationSubTitle,
                            // "The verification code has been sent to your registered email ID & mobile number",
                            style: CustomTextStyle.textbutton,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                            child: Pinput(
                          controller: otpVerificationController.otpController,
                          length: 6,
                          onCompleted: (value) {
                            print("Value is this $value");
                            //   loginController.verifyOtp(otp: value);
                            otpVerificationController.OTVerification(
                                OTP: value);
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
                                      registrationScreenController.resendOTP();
                                      timerController
                                          .resendOtp(); // Restart the timer
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
                          print(
                              "Error Data: ${otpVerificationController.errordata}");

                          // Ensure errordata is not empty
                          if (otpVerificationController.errordata.isNotEmpty) {
                            // Extract error messages
                            List<dynamic>? otpMessages =
                                otpVerificationController.errordata['errors']
                                    ?['otp'];

                            // Check if OTP messages exist
                            print("OTP Messages: $otpMessages");

                            // Create a list to hold all error messages
                            List<String> allErrorMessages = [];

                            // Add OTP messages if they exist
                            if (otpMessages != null && otpMessages.isNotEmpty) {
                              allErrorMessages
                                  .addAll(otpMessages.map((e) => e.toString()));
                            }

                            // Display all error messages if any exist
                            if (allErrorMessages.isNotEmpty) {
                              String errorMessage = allErrorMessages.join(
                                  ', '); // Join all messages into a single string
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  errorMessage, // Removed extra "Error" suffix for clarity
                                  style: const TextStyle(color: Colors.red),
                                ),
                              );
                            }
                          }
                          return const SizedBox(); // Return an empty widget if no error
                        }),
                      ],
                    );
                  }
                },
              )
            ],
          )),
        ),
      ),
    );
  }
}
