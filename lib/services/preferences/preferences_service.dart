import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  const PreferencesService._(this._preferences);

  final SharedPreferences _preferences;

  static Future<PreferencesService> load() async =>
      PreferencesService._(await SharedPreferences.getInstance());

  String? readString(String key) => _preferences.getString(key);
  int? readInt(String key) => _preferences.getInt(key);
  Future<bool> writeString(String key, String value) => _preferences.setString(key, value);
  Future<bool> writeInt(String key, int value) => _preferences.setInt(key, value);
  Future<bool> writeString(String key, String value) => _preferences.setString(key, value);
}
