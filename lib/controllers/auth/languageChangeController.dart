import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageChangeController with ChangeNotifier {
  Locale? _applocale;
  Locale? get appLocale => _applocale;

  LanguageChangeController() {
    _loadSavedLocale();
  }

  void _loadSavedLocale() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? localeCode = sp.getString('Language');

    if (localeCode != null && localeCode.isNotEmpty) {
      _applocale = Locale(localeCode);
      notifyListeners();
    } else {
      await sp.setString("Language", "en");

      _applocale = const Locale('en');
    }
  }

  Future<void> changeLanguage(Locale type) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _applocale = type;

    if (type == const Locale('en')) {
      await sp.setString("Language", "en");
    } else {
      await sp.setString("Language", "mr");
    }
    notifyListeners();
  }
}
