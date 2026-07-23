import '../../../../core/logging/app_logger.dart';
import '../../../../services/preferences/preferences_service.dart';
import '../../domain/entities/recent_file.dart';
import '../../domain/repositories/recent_files_repository.dart';

/// Local recents repository optimized for fast startup and bounded history.
class RecentFilesRepositoryImpl implements RecentFilesRepository {
  const RecentFilesRepositoryImpl({required PreferencesService preferences}) : _preferences = preferences;

  final PreferencesService _preferences;

  static const _key = 'reader.recentFiles';
  static const _separator = '\u001f';

  @override
  Future<List<RecentFile>> getRecentFiles({int limit = 50}) async {
    final values = _preferences.readStringList(_key) ?? const [];
    return values.map(_decode).whereType<RecentFile>().take(limit).toList(growable: false);
  }

  @override
  Future<void> upsertRecentFile(RecentFile file) async {
    final files = [file, ...await getRecentFiles(limit: 200)]
        .fold<Map<String, RecentFile>>(<String, RecentFile>{}, (map, entry) {
          map.putIfAbsent(entry.path, () => entry);
          return map;
        })
        .values
        .toList(growable: false)
      ..sort((left, right) => right.lastOpenedAt.compareTo(left.lastOpenedAt));
    await _preferences.writeStringList(
      _key,
      files.take(200).map(_encode).toList(growable: false),
    );
    appLogger.i('Recent file updated: ${file.filename}.');
  }

  @override
  Future<void> setFavorite(String documentPath, bool isFavorite) async {
    final files = await getRecentFiles(limit: 200);
    await _preferences.writeStringList(
      _key,
      files
          .map(
            (file) => _encode(
              file.path == documentPath
                  ? RecentFile(
                      filename: file.filename,
                      path: file.path,
                      page: file.page,
                      readingProgress: file.readingProgress,
                      lastOpenedAt: file.lastOpenedAt,
                      thumbnailPlaceholder: file.thumbnailPlaceholder,
                      isFavorite: isFavorite,
                    )
                  : file,
            ),
          )
          .toList(growable: false),
    );
  }

  @override
  Future<void> deleteRecentFile(String documentPath) async {
    final files = await getRecentFiles(limit: 200);
    await _preferences.writeStringList(
      _key,
      files.where((file) => file.path != documentPath).map(_encode).toList(growable: false),
    );
  }

  String _encode(RecentFile file) => [
        Uri.encodeComponent(file.filename),
        Uri.encodeComponent(file.path),
        file.page,
        file.readingProgress,
        file.lastOpenedAt.toIso8601String(),
        Uri.encodeComponent(file.thumbnailPlaceholder),
        file.isFavorite,
      ].join(_separator);

  RecentFile? _decode(String value) {
    final parts = value.split(_separator);
    if (parts.length != 7) {
      return null;
    }
    return RecentFile(
      filename: Uri.decodeComponent(parts[0]),
      path: Uri.decodeComponent(parts[1]),
      page: int.tryParse(parts[2]) ?? 1,
      readingProgress: double.tryParse(parts[3]) ?? 0,
      lastOpenedAt: DateTime.tryParse(parts[4]) ?? DateTime.fromMillisecondsSinceEpoch(0),
      thumbnailPlaceholder: Uri.decodeComponent(parts[5]),
      isFavorite: parts[6].toLowerCase() == 'true',
    );
  }
}
