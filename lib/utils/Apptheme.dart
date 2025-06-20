import 'package:flutter/material.dart';

class AppTheme {
  static Color selectedOptionColor = const Color.fromARGB(255, 80, 93, 126);
  static Color floatingActionBG = const Color.fromARGB(255, 230, 232, 235);

  static Color primaryColor = const Color.fromRGBO(204, 40, 77, 1);
  // rgba(9, 39, 73, 1)
  static Color popupHeading = const Color.fromRGBO(9, 39, 73, 1);

  static Color primaryColorLight =
      const Color.fromARGB(255, 234, 52, 74).withOpacity(2);

  static Color secondryColor = const Color.fromARGB(255, 80, 93, 126);

  static Color dividerColor =
      const Color.fromARGB(255, 80, 93, 126).withOpacity(0.4);
  static Color dividerDarkColor =
      const Color.fromARGB(255, 80, 93, 126).withOpacity(0.4);
  static Color lightPrimaryColor = const Color.fromARGB(255, 245, 245, 245);
  static Color textColor = const Color.fromARGB(
    255,
    80,
    93,
    126,
  );
  static Color darkcolorBotomNav = const Color.fromARGB(
    255,
    80,
    93,
    126,
  );

// rgba(80, 93, 126, 1)
}
/*
     Center(
                child: ElevatedButton(onPressed: (){}, child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, 
                  mainAxisSize: MainAxisSize.min, 
                  children: [
                    Container(height: 13, width: 13, child: Image.asset("assets/astrowhite.png"),) , 
                    const SizedBox(width: 5,) , 
                    const Text("View Gun Milan" , style: CustomTextStyle.elevatedButton,)
                  ],)),
              )*/
