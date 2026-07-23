import '../entities/reader_bookmark.dart';

/// Manages named bookmarks independently from the reader UI.
abstract class BookmarkRepository {
  Future<List<ReaderBookmark>> watchDocumentBookmarks(String documentPath);
  Future<ReaderBookmark> addBookmark(String documentPath, int pageNumber, String name);
  Future<void> updateBookmark(ReaderBookmark bookmark);
  Future<void> deleteBookmark(String documentPath, String bookmarkId);
}
