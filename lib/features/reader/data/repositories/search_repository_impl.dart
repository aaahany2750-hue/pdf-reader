import '../../../../core/logging/app_logger.dart';
import '../../../../services/preferences/preferences_service.dart';
import '../../domain/entities/search_result.dart';
import '../../domain/repositories/search_repository.dart';

/// Incremental search implementation over lazily supplied page text.
class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl({required PreferencesService preferences}) : _preferences = preferences;

  final PreferencesService _preferences;
  final Map<String, Map<int, String>> _pageTextIndex = <String, Map<int, String>>{};

  void indexPageText(String documentPath, int pageNumber, String text) {
    _pageTextIndex.putIfAbsent(documentPath, () => <int, String>{})[pageNumber] = text;
  }

  @override
  Future<List<SearchResult>> search(String documentPath, String query) async {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return const [];
    }
    await rememberSearch(documentPath, query);
    final results = <SearchResult>[];
    final pages = _pageTextIndex[documentPath] ?? const <int, String>{};
    for (final entry in pages.entries) {
      final lowerText = entry.value.toLowerCase();
      var start = lowerText.indexOf(normalizedQuery);
      while (start >= 0) {
        final end = start + normalizedQuery.length;
        results.add(
          SearchResult(
            pageNumber: entry.key,
            startIndex: start,
            endIndex: end,
            snippet: _snippet(entry.value, start, end),
          ),
        );
        start = lowerText.indexOf(normalizedQuery, end);
      }
    }
    appLogger.i('Search completed with ${results.length} results.');
    return results;
  }

  @override
  Future<List<String>> getSearchHistory(String documentPath) async =>
      _preferences.readStringList(_historyKey(documentPath)) ?? const [];

  @override
  Future<void> rememberSearch(String documentPath, String query) async {
    final normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty) {
      return;
    }
    final history = [
      normalizedQuery,
      ...await getSearchHistory(documentPath),
    ].toSet().take(20).toList(growable: false);
    await _preferences.writeStringList(_historyKey(documentPath), history);
  }

  @override
  Future<void> clearSearchHistory(String documentPath) async {
    await _preferences.writeStringList(_historyKey(documentPath), const []);
  }

  String _historyKey(String documentPath) =>
      'reader.searchHistory.${Uri.encodeComponent(documentPath)}';

  String _snippet(String text, int start, int end) {
    final snippetStart = (start - 40).clamp(0, text.length);
    final snippetEnd = (end + 40).clamp(0, text.length);
    return text.substring(snippetStart, snippetEnd);
  }
}
