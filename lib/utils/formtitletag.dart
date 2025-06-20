import 'package:_96kuliapp/controllers/userform/formstep1Controller.dart';
import 'package:_96kuliapp/utils/selectlanguage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:_96kuliapp/commons/dialogues/logoutDialogoue.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/main.dart';
import 'package:_96kuliapp/screens/onboarding/welcomeScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FormsTitleTag extends StatelessWidget {
  const FormsTitleTag({
    super.key,
    required this.title,
    this.onTap,
    this.onTaplang,
    this.arrowback = true,
    this.lang,
    required this.pageName,
    this.styleform,
  });
  final bool? arrowback;
  final String pageName;
  final String title;
  final bool? styleform;
  final Function()? onTap;
  final Function()? onTaplang;
  final bool? lang;
  @override
  Widget build(BuildContext context) {
    final StepOneController stepOneController = Get.put(StepOneController());
    return Container(
      color: const Color.fromRGBO(204, 40, 77, 1),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                arrowback == true
                    ? GestureDetector(
                        onTap: onTap,
                        child: SizedBox(
                            width: 25,
                            height: 20,
                            child: Image.asset("assets/arrowbackwhite.png")))
                    : const SizedBox(),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: styleform == true
                      ? CustomTextStyle.bodytextLarge.copyWith(
                          color: Colors.white, height: 1, fontSize: 16)
                      : CustomTextStyle.bodytextLarge
                          .copyWith(color: Colors.white, height: 1),
                ),
              ],
            ),
            lang != true
                ? GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Logout(
                            page: pageName,
                          );
                        },
                      );
                    },
                    child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(color: Colors.white)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7.0, vertical: 4),
                          child: Text(
                            AppLocalizations.of(context)!.logout,
                            style: const TextStyle(
                              fontFamily: "WORKSANSLIGHT",
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        )),
                  )
                : SizedBox(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Logout(
                                  page: pageName,
                                );
                              },
                            );
                          },
                          child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  border: Border.all(color: Colors.white)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7.0, vertical: 4),
                                child: Text(
                                  AppLocalizations.of(context)!.logout,
                                  style: const TextStyle(
                                    fontFamily: "WORKSANSLIGHT",
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              )),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const SizedBox(
                          height: 25,
                          child: VerticalDivider(
                            width: 2,
                            thickness: 1,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SelectLanguage(
                          color: Colors.white,
                          pading: true,
                          onChanged: () {
                            onTaplang!();
                            // _stepOneController.fetchBasicInfo();
                            // final StepOneController controller =
                            //     Get.find<StepOneController>();
                            // controller.zodiacsigList();
                          },
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
