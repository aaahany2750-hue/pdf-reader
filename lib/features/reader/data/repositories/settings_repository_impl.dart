import '../../../../core/logging/app_logger.dart';
import '../../../../services/preferences/preferences_service.dart';
import '../../domain/entities/reader_settings.dart';
import '../../domain/repositories/settings_repository.dart';

/// SharedPreferences-backed reader settings repository.
class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl({required PreferencesService preferences}) : _preferences = preferences;

  final PreferencesService _preferences;

  static const _darkModeKey = 'reader.settings.darkModeRendering';
  static const _keepScreenOnKey = 'reader.settings.keepScreenOn';
  static const _defaultZoomKey = 'reader.settings.defaultZoom';
  static const _readingDirectionKey = 'reader.settings.readingDirection';
  static const _pageLayoutModeKey = 'reader.settings.pageLayoutMode';

  @override
  Future<ReaderSettings> readSettings() async {
    final defaults = const ReaderSettings.defaults();
    return ReaderSettings(
      darkModeRendering: _preferences.readBool(_darkModeKey) ?? defaults.darkModeRendering,
      keepScreenOn: _preferences.readBool(_keepScreenOnKey) ?? defaults.keepScreenOn,
      defaultZoom: _preferences.readDouble(_defaultZoomKey) ?? defaults.defaultZoom,
      readingDirection: _readingDirection(
        _preferences.readString(_readingDirectionKey),
        defaults.readingDirection,
      ),
      pageLayoutMode: _pageLayoutMode(
        _preferences.readString(_pageLayoutModeKey),
        defaults.pageLayoutMode,
      ),
    );
  }

  @override
  Future<void> saveSettings(ReaderSettings settings) async {
    await Future.wait([
      _preferences.writeBool(_darkModeKey, settings.darkModeRendering),
      _preferences.writeBool(_keepScreenOnKey, settings.keepScreenOn),
      _preferences.writeDouble(_defaultZoomKey, settings.defaultZoom),
      _preferences.writeString(_readingDirectionKey, settings.readingDirection.name),
      _preferences.writeString(_pageLayoutModeKey, settings.pageLayoutMode.name),
    ]);
    appLogger.i('Reader settings saved.');
  }

  ReadingDirection _readingDirection(String? value, ReadingDirection fallback) {
    for (final item in ReadingDirection.values) {
      if (item.name == value) {
        return item;
      }
    }
    return fallback;
  }

  PageLayoutMode _pageLayoutMode(String? value, PageLayoutMode fallback) {
    for (final item in PageLayoutMode.values) {
      if (item.name == value) {
        return item;
      }
    }
    return fallback;
  }
}
