import 'package:flutter/material.dart';
import 'package:_96kuliapp/controllers/auth/languageChangeController.dart';
import 'package:provider/provider.dart';

class SelectLanguage extends StatelessWidget {
  final Color? color;
  final bool? pading;
  final VoidCallback? onChanged;
  final bool? dashboard;
  const SelectLanguage({
    super.key,
    this.color,
    this.pading,
    this.onChanged,
    this.dashboard,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageChangeController>(
      builder: (context, value, child) {
        print("applocale value is ${value.appLocale}");
        return GestureDetector(
          onTapDown: (TapDownDetails details) async {
            final result = await showMenu<String>(
              color: Colors.white,
              shadowColor: Theme.of(context).primaryColor,
              context: context,
              position: RelativeRect.fromLTRB(
                  details.globalPosition.dx, details.globalPosition.dy, 0, 0),
              items: [
                PopupMenuItem<String>(
                  value: 'en',
                  child: Text(
                    'English',
                    style: TextStyle(
                        color: value.appLocale.toString() == "en"
                            ? Theme.of(context).primaryColor
                            : const Color.fromARGB(255, 9, 39, 73)),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'mr',
                  child: Text(
                    'मराठी',
                    style: TextStyle(
                      color: value.appLocale.toString() == "mr"
                          ? Theme.of(context).primaryColor
                          : const Color.fromARGB(255, 9, 39, 73),
                    ),
                  ),
                ),
              ],
              elevation: 3.0,
            );

            if (result != null) {
              print("result is $result");
              await Provider.of<LanguageChangeController>(context,
                      listen: false)
                  .changeLanguage(Locale(result));

              if (onChanged != null) {
                onChanged!(); // 🔥 Call the onChanged callback here
              }
            }
          },
          child: Container(
            decoration: BoxDecoration(
                color: color ?? Colors.transparent,
                borderRadius: BorderRadius.circular(20)),
            padding:
                pading == true ? const EdgeInsets.all(4.0) : EdgeInsets.zero,
            height: 32,
            width: 32,
            child: Image.asset("assets/changelanguage.png"),
          ),
        );
      },
    );
  }
}
