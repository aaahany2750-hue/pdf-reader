import '../../domain/entities/reader_bookmark.dart';
import '../../domain/entities/reader_document.dart';
import '../../domain/entities/reader_session.dart';
import '../../domain/entities/reading_statistics.dart';
import '../../domain/entities/search_result.dart';

/// Reader UI lifecycle state.
enum ReaderStatus { empty, loading, ready, error }

/// Immutable view model consumed by Reader widgets.
class ReaderState {
  const ReaderState({
    required this.status,
    this.document,
    this.session,
    this.statistics,
    this.bookmarks = const [],
    this.searchResults = const [],
    this.activeSearchResultIndex = -1,
    this.currentPage = 1,
    this.pageCount,
    this.errorMessage,
  });

  const ReaderState.empty() : this(status: ReaderStatus.empty);
  const ReaderState.loading({ReaderDocument? document})
      : this(status: ReaderStatus.loading, document: document);
  const ReaderState.ready({
    required ReaderDocument document,
    ReaderSession? session,
    ReadingStatistics? statistics,
    List<ReaderBookmark> bookmarks = const [],
    List<SearchResult> searchResults = const [],
    int activeSearchResultIndex = -1,
    int currentPage = 1,
    int? pageCount,
  }) : this(
          status: ReaderStatus.ready,
          document: document,
          session: session,
          statistics: statistics,
          bookmarks: bookmarks,
          searchResults: searchResults,
          activeSearchResultIndex: activeSearchResultIndex,
          currentPage: currentPage,
          pageCount: pageCount,
        );
  const ReaderState.error(String message)
      : this(status: ReaderStatus.error, errorMessage: message);

  final ReaderStatus status;
  final ReaderDocument? document;
  final ReaderSession? session;
  final ReadingStatistics? statistics;
  final List<ReaderBookmark> bookmarks;
  final List<SearchResult> searchResults;
  final int activeSearchResultIndex;
  final int currentPage;
  final int? pageCount;
  final String? errorMessage;

  ReaderState copyWith({
    ReaderStatus? status,
    ReaderDocument? document,
    ReaderSession? session,
    ReadingStatistics? statistics,
    List<ReaderBookmark>? bookmarks,
    List<SearchResult>? searchResults,
    int? activeSearchResultIndex,
    int? currentPage,
    int? pageCount,
    String? errorMessage,
  }) =>
      ReaderState(
        status: status ?? this.status,
        document: document ?? this.document,
        session: session ?? this.session,
        statistics: statistics ?? this.statistics,
        bookmarks: bookmarks ?? this.bookmarks,
        searchResults: searchResults ?? this.searchResults,
        activeSearchResultIndex: activeSearchResultIndex ?? this.activeSearchResultIndex,
        currentPage: currentPage ?? this.currentPage,
        pageCount: pageCount ?? this.pageCount,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
