import '../entities/search_result.dart';

/// Provides incremental full-text search over indexed PDF page text.
abstract class SearchRepository {
  Future<List<SearchResult>> search(String documentPath, String query);
  Future<List<String>> getSearchHistory(String documentPath);
  Future<void> rememberSearch(String documentPath, String query);
  Future<void> clearSearchHistory(String documentPath);
}
