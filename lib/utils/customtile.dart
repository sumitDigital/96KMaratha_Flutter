import 'package:flutter/material.dart';
import 'package:_96kuliapp/commons/textdecoration.dart';

class customtile extends StatelessWidget {
  const customtile({
    super.key,
    required this.leadingimg,
    required this.title,
    this.notification,
    this.onTap, // Optional onTap function
  });

  final String leadingimg;
  final String title;
  final int? notification;
  final Function? onTap; // Declare the optional onTap function

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        height: 18,
        width: 18,
        child: Image.asset(leadingimg),
      ),
      title: Text(
        title,
        style: CustomTextStyle.bodytext.copyWith(
          letterSpacing: 0.5,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: notification != 0 && notification != null
          ? CircleAvatar(
              radius: 9,
              backgroundColor: Colors.red,
              child: Text(
                notification.toString(),
                style: const TextStyle(fontSize: 10, color: Colors.white),
              ),
            )
          : null,
      onTap: onTap != null ? () => onTap!() : null, // Move the onTap here
    );
  }
}
