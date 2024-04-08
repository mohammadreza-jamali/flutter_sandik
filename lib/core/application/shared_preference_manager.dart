
import 'package:flutter_sandik/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceManager {
  SharedPreferenceManager._() {
    _preference = locator<SharedPreferences>();
  }
  static SharedPreferenceManager? _sharedPreferenceManager;
  static SharedPreferenceManager getInstanse() {
    if (_sharedPreferenceManager != null) return _sharedPreferenceManager!;
    _sharedPreferenceManager ??= SharedPreferenceManager._();
    return _sharedPreferenceManager!;
  }

  late SharedPreferences _preference;

  

  setThemeName(String value) {
    _preference.setString("currentTheme", value);
  }

  String getThemeName() {
    return _preference.getString("currentTheme") ?? "light";
  }

  bool getUrelExecuted(String id) {
    return (_preference.getString("executedUrlId") ?? "0") == id ? true : false;
  }

  void setUrelExecuted(String id) {
    _preference.setString("executedUrlId", id);
  }
}
