import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/logging/app_logger.dart';
import '../../../../services/preferences/preferences_service.dart';
import '../../data/cache/pdf_page_cache.dart';
import '../../data/datasources/pdf_file_picker_data_source.dart';
import '../../data/datasources/reader_preferences_data_source.dart';
import '../../data/repositories/bookmark_repository_impl.dart';
import '../../data/repositories/reader_repository_impl.dart';
import '../../data/repositories/recent_files_repository_impl.dart';
import '../../data/repositories/search_repository_impl.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/entities/reader_bookmark.dart';
import '../../domain/entities/reader_session.dart';
import '../../domain/entities/recent_file.dart';
import '../../domain/repositories/bookmark_repository.dart';
import '../../domain/repositories/reader_repository.dart';
import '../../domain/repositories/recent_files_repository.dart';
import '../../domain/repositories/search_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/services/reader_session_manager.dart';
import 'reader_state.dart';

final readerPreferencesProvider = FutureProvider<PreferencesService>((ref) {
  return PreferencesService.load();
});

final readerSessionManagerProvider = Provider<ReaderSessionManager>((ref) {
  return ReaderSessionManager();
});

final pdfPageCacheProvider = Provider<PdfPageCache<Object>>((ref) {
  return PdfPageCache<Object>();
});

final readerRepositoryProvider = FutureProvider<ReaderRepository>((ref) async {
  final preferences = await ref.watch(readerPreferencesProvider.future);
import '../../data/datasources/pdf_file_picker_data_source.dart';
import '../../data/datasources/reader_preferences_data_source.dart';
import '../../data/repositories/reader_repository_impl.dart';
import '../../domain/repositories/reader_repository.dart';
import 'reader_state.dart';

final readerRepositoryProvider = FutureProvider<ReaderRepository>((ref) async {
  final preferences = await PreferencesService.load();
  return ReaderRepositoryImpl(
    pickerDataSource: PdfFilePickerDataSource(),
    preferencesDataSource: ReaderPreferencesDataSource(preferences),
  );
});

final bookmarkRepositoryProvider = FutureProvider<BookmarkRepository>((ref) async {
  final preferences = await ref.watch(readerPreferencesProvider.future);
  return BookmarkRepositoryImpl(preferences: preferences);
});

final recentFilesRepositoryProvider = FutureProvider<RecentFilesRepository>((ref) async {
  final preferences = await ref.watch(readerPreferencesProvider.future);
  return RecentFilesRepositoryImpl(preferences: preferences);
});

final searchRepositoryProvider = FutureProvider<SearchRepository>((ref) async {
  final preferences = await ref.watch(readerPreferencesProvider.future);
  return SearchRepositoryImpl(preferences: preferences);
});

final settingsRepositoryProvider = FutureProvider<SettingsRepository>((ref) async {
  final preferences = await ref.watch(readerPreferencesProvider.future);
  return SettingsRepositoryImpl(preferences: preferences);
});

final readerControllerProvider =
    AsyncNotifierProvider<ReaderController, ReaderState>(ReaderController.new);

/// Riverpod-backed reader view model that coordinates repositories and session state.
final readerControllerProvider =
    AsyncNotifierProvider<ReaderController, ReaderState>(ReaderController.new);

class ReaderController extends AsyncNotifier<ReaderState> {
  @override
  Future<ReaderState> build() async => const ReaderState.empty();

  Future<void> pickAndOpenPdf() async {
    state = const AsyncData(ReaderState.loading());
    try {
      final repository = await ref.read(readerRepositoryProvider.future);
      final document = await repository.pickPdfDocument();
      if (document == null) {
        state = const AsyncData(ReaderState.empty());
        return;
      }
      final settings = await (await ref.read(settingsRepositoryProvider.future)).readSettings();
      final session = ref.read(readerSessionManagerProvider).start(
            document: document,
            pageCount: document.initialPage,
            initialZoom: settings.defaultZoom,
          );
      await _recordRecent(session);
      state = AsyncData(
        ReaderState.ready(
          document: document,
          session: session,
          statistics: ref.read(readerSessionManagerProvider).statistics(),
          bookmarks: await _loadBookmarks(document.path),
          currentPage: document.initialPage,
          pageCount: document.initialPage,
      state = AsyncData(
        ReaderState.ready(
          document: document,
          currentPage: document.initialPage,
        ),
      );
    } catch (error, stackTrace) {
      appLogger.e('Reader failed to open PDF.', error: error, stackTrace: stackTrace);
      state = AsyncData(ReaderState.error(error.toString()));
    }
  }

  Future<void> onPageChanged({required int pageNumber, int? pageCount}) async {
    final current = state.valueOrNull;
    final document = current?.document;
    if (current == null || document == null || pageNumber < 1) {
      return;
    }

    final session = ref.read(readerSessionManagerProvider).updateInteraction(
          currentPage: pageNumber,
          pageCount: pageCount,
        );
    final statistics = ref.read(readerSessionManagerProvider).statistics();
    state = AsyncData(
      current.copyWith(
        session: session,
        statistics: statistics,
    state = AsyncData(
      current.copyWith(
        currentPage: pageNumber,
        pageCount: pageCount ?? current.pageCount,
      ),
    );

    final repository = await ref.read(readerRepositoryProvider.future);
    await repository.saveLastOpenedPage(document.path, pageNumber);
    if (session != null) {
      await _recordRecent(session);
    }
  }

  Future<void> updateZoom(double zoomLevel) async {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    final session = ref.read(readerSessionManagerProvider).updateInteraction(zoomLevel: zoomLevel);
    state = AsyncData(current.copyWith(session: session));
  }

  Future<void> rotateClockwise() async {
    final current = state.valueOrNull;
    final session = current?.session;
    if (current == null || session == null) {
      return;
    }
    final nextRotation = (session.rotationDegrees + 90) % 360;
    final updated = ref.read(readerSessionManagerProvider).updateInteraction(
          rotationDegrees: nextRotation,
        );
    state = AsyncData(current.copyWith(session: updated));
  }

  Future<void> search(String query) async {
    final current = state.valueOrNull;
    final document = current?.document;
    if (current == null || document == null) {
      return;
    }
    final repository = await ref.read(searchRepositoryProvider.future);
    final results = await repository.search(document.path, query);
    state = AsyncData(
      current.copyWith(searchResults: results, activeSearchResultIndex: results.isEmpty ? -1 : 0),
    );
  }

  void nextSearchResult() => _moveSearchResult(1);

  void previousSearchResult() => _moveSearchResult(-1);

  void _moveSearchResult(int delta) {
    final current = state.valueOrNull;
    if (current == null || current.searchResults.isEmpty) {
      return;
    }
    final length = current.searchResults.length;
    final next = (current.activeSearchResultIndex + delta) % length;
    state = AsyncData(current.copyWith(activeSearchResultIndex: next < 0 ? length - 1 : next));
  }

  Future<void> addBookmark(String name) async {
    final current = state.valueOrNull;
    final document = current?.document;
    if (current == null || document == null) {
      return;
    }
    final repository = await ref.read(bookmarkRepositoryProvider.future);
    await repository.addBookmark(document.path, current.currentPage, name);
    state = AsyncData(current.copyWith(bookmarks: await _loadBookmarks(document.path)));
  }

  Future<void> updateBookmarkName(String bookmarkId, String name) async {
    final current = state.valueOrNull;
    final bookmark = _bookmarkById(current, bookmarkId);
    if (current == null || bookmark == null) {
      return;
    }
    final repository = await ref.read(bookmarkRepositoryProvider.future);
    await repository.updateBookmark(
      bookmark.copyWith(name: name, updatedAt: DateTime.now()),
    );
    state = AsyncData(current.copyWith(bookmarks: await _loadBookmarks(bookmark.documentPath)));
  }

  Future<void> deleteBookmark(String bookmarkId) async {
    final current = state.valueOrNull;
    final document = current?.document;
    if (current == null || document == null) {
      return;
    }
    final repository = await ref.read(bookmarkRepositoryProvider.future);
    await repository.deleteBookmark(document.path, bookmarkId);
    state = AsyncData(current.copyWith(bookmarks: await _loadBookmarks(document.path)));
  }

  ReaderBookmark? _bookmarkById(ReaderState? current, String bookmarkId) {
    if (current == null) {
      return null;
    }
    for (final bookmark in current.bookmarks) {
      if (bookmark.id == bookmarkId) {
        return bookmark;
      }
    }
    return null;
  }

  Future<List<ReaderBookmark>> _loadBookmarks(String documentPath) async {
    final repository = await ref.read(bookmarkRepositoryProvider.future);
    return repository.watchDocumentBookmarks(documentPath);
  }

  Future<void> _recordRecent(ReaderSession session) async {
    final repository = await ref.read(recentFilesRepositoryProvider.future);
    await repository.upsertRecentFile(
      RecentFile(
        filename: session.document.name,
        path: session.document.path,
        page: session.currentPage,
        readingProgress: session.readingProgress,
        lastOpenedAt: DateTime.now(),
        thumbnailPlaceholder: 'pdf',
        isFavorite: false,
      ),
    );
  }
}
