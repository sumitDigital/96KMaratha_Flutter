import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/auth_Screens/loginScreen2.dart';
import 'package:_96kuliapp/screens/auth_Screens/otpVerificationScreen.dart';
import 'package:_96kuliapp/utils/customtextform.dart';
import 'package:_96kuliapp/utils/selectlanguage.dart';

class SendOTPScreen extends StatelessWidget {
  const SendOTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
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
                const SelectLanguage()
              ],
            ),
            Center(
                child: SizedBox(
              height: 200,
              width: 200,
              child: Image.asset("assets/login.jpg"),
            )),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              "Provide Your Registered Email ID Or Mobile Number",
              style: CustomTextStyle.headlineMain2.copyWith(fontSize: 17),
            ),
            const Text(
              "We will send you an OTP to reset your password",
              style: CustomTextStyle.textbutton,
            ),
            const SizedBox(
              height: 20,
            ),
            const CustomTextField(
                HintText: "Enter Your Registered Email ID or Mobile Number"),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: SizedBox(
                height: 50,
                width: 220.41,
                child: ElevatedButton(
                    onPressed: () {
                      //  Get.toNamed(AppRouteNames.otpVerificationScreen);

                      navigatorKey.currentState!.push(MaterialPageRoute(
                        builder: (context) => const VerificationScreen(),
                      ));
                    },
                    child: const Text(
                      "Get OTP",
                      style: CustomTextStyle.elevatedButton,
                    )),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn't Receive OTP ? ",
                  style: CustomTextStyle.bodytext,
                ),
                Text(
                  "Resend Now",
                  style: CustomTextStyle.textbuttonRed,
                )
              ],
            )
          ],
        )),
      ),
    );
  }
}
