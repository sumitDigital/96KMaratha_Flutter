import 'package:flutter/material.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';

class ForceBlockDialogue extends StatelessWidget {
  const ForceBlockDialogue({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent dialog from closing on back press
      child: Dialog(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          width: MediaQuery.of(context).size.width *
              0.9, // Adjust the width to fit better
          padding:
              const EdgeInsets.only(left: 12.0, right: 12, top: 25, bottom: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Profile Under Review!', // Replace with your desired text
                style: CustomTextStyle.bodytextboldPrimary,
                textAlign: TextAlign.center,
              ),
              Image.asset(
                'assets/your_image.png', // Replace with your image asset path
                height: 150, // Adjust the image size as needed
                width: MediaQuery.of(context).size.width * 0.7,
                fit: BoxFit.contain, // Adjust the fit as necessary
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  textAlign: TextAlign.center,
                  "Thank you for \n submitting your profile.",
                  style:
                      CustomTextStyle.bodytextboldLarge.copyWith(fontSize: 15),
                ),
              ),
              const Padding(
                padding:
                    EdgeInsets.only(left: 8.0, right: 8.0, top: 4, bottom: 4),
                child: Text(
                  textAlign: TextAlign.center,
                  "We are reviewing it and will update you as soon as it’s activated..!",
                  style: CustomTextStyle.bodytext,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
