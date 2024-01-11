import 'package:shared_preferences/shared_preferences.dart';

// This class will help keep track of the number of questions answered correctly
class SharedPrefHelper {
  static late SharedPreferences _preferences;
  static const String _keyCount = 'count';

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future incrementValue() async {
    await _preferences.setInt(
        _keyCount, (_preferences.getInt(_keyCount) ?? 1) + 1);
  }

  static int getValue() {
    return _preferences.getInt(_keyCount) ?? 0;
  }
}
