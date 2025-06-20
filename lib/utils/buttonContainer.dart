import 'package:flutter/material.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer(
      {super.key,
      required this.height,
      required this.title,
      required this.width,
      this.textColor,
      this.color,
      this.fontsize});

  final double height;
  final double width;
  final String title;
  final Color? color;
  final Color? textColor;
  final double? fontsize;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 89, // Fixed minimum width
        maxWidth: double.infinity, // Allows it to expand as needed
      ),
      decoration: BoxDecoration(
        color: color ?? AppTheme.lightPrimaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Makes the Row as small as possible
          children: [
            Text(
              title,
              style: CustomTextStyle.bodytext.copyWith(
                fontSize: fontsize ?? 14,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
