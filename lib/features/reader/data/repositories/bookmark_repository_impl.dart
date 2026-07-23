import '../../../../core/logging/app_logger.dart';
import '../../../../services/preferences/preferences_service.dart';
import '../../domain/entities/reader_bookmark.dart';
import '../../domain/repositories/bookmark_repository.dart';

/// Local bookmark repository with deterministic storage keys per document.
class BookmarkRepositoryImpl implements BookmarkRepository {
  const BookmarkRepositoryImpl({required PreferencesService preferences}) : _preferences = preferences;

  final PreferencesService _preferences;

  @override
  Future<List<ReaderBookmark>> watchDocumentBookmarks(String documentPath) async =>
      _read(documentPath);

  @override
  Future<ReaderBookmark> addBookmark(String documentPath, int pageNumber, String name) async {
    final now = DateTime.now();
    final bookmark = ReaderBookmark(
      id: '${now.microsecondsSinceEpoch}-$pageNumber',
      documentPath: documentPath,
      pageNumber: pageNumber,
      name: name.trim().isEmpty ? 'Page $pageNumber' : name.trim(),
      createdAt: now,
      updatedAt: now,
    );
    final bookmarks = [...await _read(documentPath), bookmark]
      ..sort((left, right) => left.pageNumber.compareTo(right.pageNumber));
    await _write(documentPath, bookmarks);
    appLogger.i('Bookmark added at page $pageNumber.');
    return bookmark;
  }

  @override
  Future<void> updateBookmark(ReaderBookmark bookmark) async {
    final bookmarks = await _read(bookmark.documentPath);
    final next = bookmarks
        .map((candidate) => candidate.id == bookmark.id ? bookmark : candidate)
        .toList(growable: false);
    await _write(bookmark.documentPath, next);
    appLogger.i('Bookmark updated: ${bookmark.id}.');
  }

  @override
  Future<void> deleteBookmark(String documentPath, String bookmarkId) async {
    final bookmarks = await _read(documentPath);
    await _write(
      documentPath,
      bookmarks.where((bookmark) => bookmark.id != bookmarkId).toList(growable: false),
    );
    appLogger.i('Bookmark deleted: $bookmarkId.');
  }

  Future<List<ReaderBookmark>> _read(String documentPath) async =>
      (_preferences.readStringList(_key(documentPath)) ?? const [])
          .map((value) => value.split('|'))
          .where((parts) => parts.length == 5)
          .map(
            (parts) => ReaderBookmark(
              id: parts[4],
              documentPath: documentPath,
              pageNumber: int.tryParse(parts[0]) ?? 1,
              name: Uri.decodeComponent(parts[1]),
              createdAt: DateTime.tryParse(parts[2]) ?? DateTime.now(),
              updatedAt: DateTime.tryParse(parts[3]) ?? DateTime.now(),
            ),
          )
          .toList(growable: false);

  Future<void> _write(String documentPath, List<ReaderBookmark> bookmarks) async {
    await _preferences.writeStringList(
      _key(documentPath),
      bookmarks
          .map(
            (bookmark) => [
              bookmark.pageNumber,
              Uri.encodeComponent(bookmark.name),
              bookmark.createdAt.toIso8601String(),
              bookmark.updatedAt.toIso8601String(),
              bookmark.id,
            ].join('|'),
          )
          .toList(growable: false),
    );
  }

  String _key(String documentPath) => 'reader.bookmarks.${Uri.encodeComponent(documentPath)}';
}
