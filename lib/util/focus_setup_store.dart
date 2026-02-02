import 'package:shared_preferences/shared_preferences.dart';

class FocusSetupStore {
  static const _key = 'ios_focus_setup_done';

  static Future<bool> isDone() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(_key) ?? false;
  }

  static Future<void> setDone(bool value) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_key, value);
  }
}
