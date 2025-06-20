import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';

class BackHeader extends StatelessWidget {
  const BackHeader({super.key, required this.title, required this.onTap});
  final String title;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: const Color.fromARGB(255, 222, 222, 226).withOpacity(0.25),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: onTap,
                  child: SizedBox(
                    width: 25,
                    height: 40,
                    child: SvgPicture.asset(
                      "assets/arrowback.svg",
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text("$title ", style: CustomTextStyle.bodytextLarge),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
