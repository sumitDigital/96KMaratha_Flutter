import 'package:flutter/material.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';
import 'package:_96kuliapp/utils/Apptheme.dart';

class DisplayUserDetail extends StatelessWidget {
  const DisplayUserDetail(
      {super.key,
      required this.assetImage,
      required this.title,
      required this.widget});
  final String assetImage;
  final String title;
  final Widget widget;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 14,
                width: 14,
                child: Image.asset(
                  assetImage,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(
                width: 7,
              ),
              Text(
                title,
                style: CustomTextStyle.bodytextbold,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Divider(
            color: AppTheme.dividerDarkColor,
          ),
          const SizedBox(
            height: 10,
          ),
          widget,
        ],
      ),
    );
  }
}
/*
   const SizedBox(height: 10,), 
        const Text("Hello, I'm glad you are interested in my daughter's profile.She is currently living in Ahmedabad. With hard work and determination in achieving her goals, she has built a successful career. We are looking for a qualified and well settled professional with a promising career path & a pleasing personality." , style: CustomTextStyle.bodytext,)
           , const SizedBox(height: 20,) , 
           Text("Personals Details" , style: CustomTextStyle.fieldName.copyWith(fontSize: 14),) ,*/
