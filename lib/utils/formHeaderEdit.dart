import 'package:flutter/material.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';

class StepsFormHeaderEdit extends StatelessWidget {
  const StepsFormHeaderEdit(
      {super.key, required this.title, required this.desc});
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: const Color.fromARGB(255, 230, 232, 235).withOpacity(0.4),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              textAlign: TextAlign.center,
              title,
              style: CustomTextStyle.bodytextLarge
                  .copyWith(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10,
            ),
            Divider(
              endIndent: 50,
              indent: 50,
              thickness: 1,
              color: const Color.fromARGB(255, 80, 93, 126).withOpacity(0.5),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
                child: Text(
              desc,
              style: CustomTextStyle.bodytextbold,
              textAlign: TextAlign.center,
            )),
            const SizedBox(
              height: 10,
            ),
            //  SizedBox(height: 168.2, child: Image.asset(image , fit: BoxFit.cover,), ),
          ],
        ),
      ),
    );
  }
}
