import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  const PreferencesService._(this._preferences);

  final SharedPreferences _preferences;

  static Future<PreferencesService> load() async =>
      PreferencesService._(await SharedPreferences.getInstance());

  String? readString(String key) => _preferences.getString(key);
  Future<bool> writeString(String key, String value) => _preferences.setString(key, value);
}
