
import 'package:shared_preferences/shared_preferences.dart';

class ThemePersistance {


  Future<void> storeTheme (bool isDark) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    print("Theme load");
    preferences.setBool("isDark", isDark);

  }

  // Load the user saved theme from shared preferences
  Future<bool> loadTheme() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("Theme load");
    return preferences.getBool("isDark") ?? false;
  }
}