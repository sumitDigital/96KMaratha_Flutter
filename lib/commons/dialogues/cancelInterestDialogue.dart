import 'package:_96kuliapp/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';

class CancleInterestDialogue extends StatelessWidget {
  const CancleInterestDialogue({super.key, required this.matchid});
  final int matchid;

  @override
  Widget build(BuildContext context) {
    String? language = sharedPreferences?.getString("Language");
    final DashboardController dashboardController =
        Get.put(DashboardController());
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
                            ? "Want to Cancel Interest?"
                            : "इंटरेस्ट रद्द करायचा आहे?",
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
                            child: Image.asset("assets/cancel.png"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 18.0, right: 18, bottom: 8, top: 8),
                    child: Text(
                      textAlign: TextAlign.center,
                      language == "en"
                          ? "If you cancel your interest, you won’t be able to interact with this profile further. Are you sure you want to proceed?"
                          : "तुम्ही तुमचा इंटरेस्ट रद्द केल्यास तुम्हाला यापुढे सदर प्रोफाईलशी संपर्क करता येणार नाही. तुम्ही पुढे जाऊ इच्छिता? ",
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
                            //   print("this is Member ID \$memberID");
                            dashboardController.cancelInterest(
                                memberid: matchid);
                          },
                          icon: SizedBox(
                            height: 14,
                            width: 14,
                            child: Image.asset(
                                "assets/Express-interest-button.png"),
                          ),
                          label: Text(
                            language == "en"
                                ? " CANCEL INTEREST"
                                : "इंटरेस्ट रद्द करा",
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
                                language == "en"
                                    ? " Don't Cancle"
                                    : "रद्द करू नका ",
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
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*

          SizedBox(height: 180, width: 286, child: Image.asset("assets/acceptInterest.png"),), 

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
                   _dashboardController.acceptedrequest(memberid: matchid);
                Get.back();
                    

                    }, child: const Text("Accept" , style: CustomTextStyle.elevatedButtonSmall,))), 

                ],)
            ),*/
