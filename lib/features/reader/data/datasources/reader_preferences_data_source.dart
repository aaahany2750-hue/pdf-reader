import '../../../../services/preferences/preferences_service.dart';

/// Persists lightweight reader values that must survive app restarts.
class ReaderPreferencesDataSource {
  const ReaderPreferencesDataSource(this._preferences);

  final PreferencesService _preferences;

  static const _lastPagePrefix = 'reader.lastPage.';

  Future<int> readLastOpenedPage(String documentPath) async {
    final value = _preferences.readInt(_keyFor(documentPath));
    if (value == null || value < 1) {
      return 1;
    }
    return value;
  }

  Future<void> saveLastOpenedPage(String documentPath, int pageNumber) async {
    if (pageNumber < 1) {
      return;
    }
    await _preferences.writeInt(_keyFor(documentPath), pageNumber);
  }

  String _keyFor(String documentPath) =>
      '$_lastPagePrefix${Uri.encodeComponent(documentPath)}';
}
