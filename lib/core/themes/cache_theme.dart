import 'package:shared_preferences/shared_preferences.dart';

class CashThemeHelper {
  
  Future<void> chashedTheme(int themeIndex) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setInt("THEME_INDEX", themeIndex);
  }

  Future<int> getChashedTheme( ) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final chashedTheme =  sharedPreferences.getInt("THEME_INDEX");
    if (chashedTheme != null) {
      return chashedTheme;
    } else {
      return 0;
    }
  }
}