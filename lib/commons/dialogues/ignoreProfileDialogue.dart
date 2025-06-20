import 'package:_96kuliapp/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';

class IgnoreProfileDialogue extends StatelessWidget {
  const IgnoreProfileDialogue({super.key, required this.matchid});
  final int matchid;

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardcontroller =
        Get.find<DashboardController>();
    String? language = sharedPreferences?.getString("Language");

    return Dialog(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        language == "en"
                            ? "Want to Ignore This Profile?"
                            : "ही प्रोफाईल दुर्लक्ष करायची का?",
                        style: TextStyle(
                          fontFamily: "WORKSANS",
                          color: AppTheme.popupHeading,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    height: 109,
                    width: 329,
                    child: Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            height: 180,
                            width: 286,
                            child: Image.asset("assets/ignoreProfile.png"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 18.0, right: 18, top: 8),
                    child: Text(
                      textAlign: TextAlign.center,
                      language == "en"
                          ? "If you ignore this profile you won't be able to connect with them again. Think carefully..!"
                          : "तुम्ही या प्रोफाईलकडे दुर्लक्ष केले तर तुम्ही त्यांच्याशी पुन्हा कनेक्ट होऊ शकणार नाही. विचार करून निर्णय घ्या..!",
                      style: CustomTextStyle.bodytext,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                          ),
                          onPressed: () {
                            print("this is Member ID \$memberID");
                            //    dashboardController.sendInterest(memberid: memberID);
                            //     Get.back();
                            dashboardcontroller
                                .ignoreProfiles(memberid: matchid)
                                .then(
                                  (value) {},
                                );
                          },
                          icon: SizedBox(
                            height: 14,
                            width: 14,
                            child: Image.asset(
                                "assets/Express-interest-button.png"),
                          ),
                          label: Text(
                            language == "en"
                                ? " Yes Ignore"
                                : "प्रोफाईल कडे दुर्लक्ष करा",
                            style: CustomTextStyle.elevatedButtonWhiteLarge,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: SizedBox(
                                  height: 12,
                                  child: Image.asset("assets/no-thanks.png"),
                                ),
                              ),
                              Text(
                                language == "en" ? " Don't Ignore" : "मागे जा",
                                style: CustomTextStyle.bodytextbold,
                              ),
                            ],
                          ),
                        ),
                        /*    TextButton.icon(
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(5))),
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Get.back();
                          },
                          icon: Padding(
                            padding: const EdgeInsets.all(0),
                            child: SizedBox(height: 12, child: Image.asset("assets/no-thanks.png"),),
                          ),
                          label: const Text(
                            " No, Thanks",
                            style: CustomTextStyle.bodytextbold,
                          ),
                        ),*/
                      ],
                    ),
                  )
                ],
              ),
            ),
            // Close icon at the top right corner, half outside the dialog
            Positioned(
              top: -7,
              right: -7,
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        child: Image.asset(
                            height: 24, width: 24, "assets/close-popup.png"),
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
  Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
        backgroundColor: Colors.white , side: const BorderSide(color: Colors.red )  ), 
      onPressed: (){
      Get.back();
    }, child:  const Text("Cancel" , style: CustomTextStyle.elevatedButtonSmallRed,))),
    const SizedBox(width: 10,),
                  Expanded(child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),

                    ),
                    onPressed: (){
                       dashboardcontroller.ignoreProfiles(memberid: matchid).then((value) {
                        

                            
                       },);
                    

                    }, child: const Text("Ignore" , style: CustomTextStyle.elevatedButtonSmall,))), 

                ],)
            )*/
