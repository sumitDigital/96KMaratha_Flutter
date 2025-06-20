import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/controllers/dashboardControllers/dashboardController.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExpressInterestDialogue extends StatelessWidget {
  const ExpressInterestDialogue({super.key, required this.memberID});
  final int memberID;

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController =
        Get.find<DashboardController>();
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
                  const SizedBox(
                    height: 20,
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
                            child: Image.asset("assets/sendInterest.gif"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        AppLocalizations.of(context)!.interestedInThisProfile,
                        style: TextStyle(
                          fontFamily: "WORKSANS",
                          color: AppTheme.popupHeading,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 18.0, right: 18, bottom: 8, top: 8),
                    child: Text(
                      textAlign: TextAlign.center,
                      AppLocalizations.of(context)!.interestSendDesc,
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
                            dashboardController.sendInterest(
                                memberid: memberID);
                            Get.back();
                          },
                          icon: SizedBox(
                            height: 14,
                            width: 14,
                            child: Image.asset(
                                "assets/Express-interest-button.png"),
                          ),
                          label: Text(
                            AppLocalizations.of(context)!.expressInterest,
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
                                AppLocalizations.of(context)!.noThanks,
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



         /*  Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
             ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
        backgroundColor: Colors.white , side: const BorderSide(color: Colors.red )  ), 
      onPressed: (){
      Get.back();
    }, child:  const Text(" No, Thanks" , style: CustomTextStyle.elevatedButtonSmallRed,)), 
            const SizedBox(height: 10,),
ElevatedButton(
                      style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                    
                      ),
                      onPressed: (){
                    print("this is Member ID ${memberID}");
                        dashboardController.sendInterest(memberid: memberID);
                      Get.back();
                      }, child: const Text(" Express Interest" , style: CustomTextStyle.elevatedButtonSmall,)),
    const SizedBox(width: 10,),
             

                ],)
            )*/