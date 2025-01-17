


import 'package:flutter/material.dart';
import 'package:healthcare/constants/themes.dart';
import 'package:healthcare/services/theme_percistances.dart';

class ThemeProvide extends ChangeNotifier {
  
  ThemeData _themeData = ThemesModeData().lightMode;

  ThemeProvide() {
    _loadTheme();
  }
  void updateTheme(bool isDark) {
    setThemeData = isDark ? ThemesModeData().darkMode : ThemesModeData().lightMode;
    _themePersistance.storeTheme(isDark);
  }
  final ThemePersistance _themePersistance = ThemePersistance();


  // getter
  ThemeData get getThemeData => _themeData;

  // setter
  set setThemeData (ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }

  // load the theme from shared pref
  Future<void> _loadTheme () async {
   bool isDark = await  _themePersistance.loadTheme();
   setThemeData = isDark ? ThemesModeData().darkMode : ThemesModeData().lightMode;
  }

  //todo: toggle theme
  Future<void> toggleTheme(bool isDark) async {

   setThemeData = isDark ? ThemesModeData().darkMode : ThemesModeData().lightMode;

  await _themePersistance.storeTheme(isDark);
  notifyListeners();
  }

//   Future<void> toggleTheme(bool isDark) async {
//   setThemeData = isDark ? ThemesModeData().darkMode : ThemesModeData().lightMode;
//   await _themePersistance.storeTheme(isDark);
//   // Do not call notifyListeners() here, as it affects the entire app rebuild.
// }


}