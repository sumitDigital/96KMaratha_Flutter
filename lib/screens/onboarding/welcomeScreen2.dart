import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/routes/routenames.dart';
import 'package:_96kuliapp/screens/auth_Screens/loginScreen2.dart';

class Welcomescreen2 extends StatelessWidget {
  const Welcomescreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Center(
                child: SizedBox(
              height: 50,
              width: 150,
              child: Image.asset("assets/applogo.png"),
            )),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Welcome .. ",
            style: CustomTextStyle.boldHeading,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 35.0, right: 35),
            child: Text(
              "Welcome to no.1 Jain match's making services. ",
              style: CustomTextStyle.bodytextbold,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: SizedBox(
              height: 344,
              child: Image.asset("assets/welcome2.png"),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
              width: 270,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  onPressed: () {
                    navigatorKey.currentState!.push(MaterialPageRoute(
                      builder: (context) => const LoginScreen2(),
                    ));
                  },
                  child: const Text(
                    "Continue with Sign In",
                    style: CustomTextStyle.elevatedButton,
                  ))),
          const SizedBox(
            height: 10,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "New User ? ",
                style: CustomTextStyle.fieldName,
              ),
              Text(
                "Register Now",
                style: CustomTextStyle.textbuttonRed,
              )
            ],
          )
        ],
      )),
    );
  }
}
