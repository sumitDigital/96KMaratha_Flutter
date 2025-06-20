import 'package:flutter/material.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class editformcontainer extends StatelessWidget {
  const editformcontainer(
      {super.key,
      required this.assetimage,
      required this.title,
      required this.widget,
      this.ontap});
  final String assetimage;
  final String title;
  final Widget widget;
  final VoidCallback? ontap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Colors.white,
        elevation: 3,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 12.0, left: 12, right: 12, bottom: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 14,
                        width: 14,
                        child: Image.asset(assetimage),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        title,
                        style: CustomTextStyle.bodytextbold.copyWith(
                            fontSize: 14, fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: ontap,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.edit,
                            style: CustomTextStyle.textbuttonRed
                                .copyWith(fontWeight: FontWeight.w300),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          SizedBox(
                              height: 10,
                              width: 13,
                              child: Image.asset(
                                "assets/editprofilered.png",
                              ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Divider(
                color: AppTheme.dividerDarkColor,
              ),
              const SizedBox(
                height: 10,
              ),
              widget
            ],
          ),
        ),
      ),
    );
  }
}
