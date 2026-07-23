import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  const PreferencesService._(this._preferences);

  final SharedPreferences _preferences;

  static Future<PreferencesService> load() async =>
      PreferencesService._(await SharedPreferences.getInstance());

  String? readString(String key) => _preferences.getString(key);
  int? readInt(String key) => _preferences.getInt(key);
  double? readDouble(String key) => _preferences.getDouble(key);
  bool? readBool(String key) => _preferences.getBool(key);
  List<String>? readStringList(String key) => _preferences.getStringList(key);

  Future<bool> writeString(String key, String value) => _preferences.setString(key, value);
  Future<bool> writeInt(String key, int value) => _preferences.setInt(key, value);
  Future<bool> writeDouble(String key, double value) => _preferences.setDouble(key, value);
  Future<bool> writeBool(String key, bool value) => _preferences.setBool(key, value);
  Future<bool> writeStringList(String key, List<String> value) =>
      _preferences.setStringList(key, value);
}
