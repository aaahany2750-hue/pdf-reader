import '../entities/reader_settings.dart';

/// Stores reader-specific preferences.
abstract class SettingsRepository {
  Future<ReaderSettings> readSettings();
  Future<void> saveSettings(ReaderSettings settings);
}
