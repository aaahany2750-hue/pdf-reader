import '../entities/recent_file.dart';

/// Persists and retrieves recently opened PDF metadata.
abstract class RecentFilesRepository {
  Future<List<RecentFile>> getRecentFiles({int limit = 50});
  Future<void> upsertRecentFile(RecentFile file);
  Future<void> setFavorite(String documentPath, bool isFavorite);
  Future<void> deleteRecentFile(String documentPath);
}
