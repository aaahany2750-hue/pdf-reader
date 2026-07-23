/// A single full-text search hit within a PDF page.
class SearchResult {
  const SearchResult({
    required this.pageNumber,
    required this.startIndex,
    required this.endIndex,
    required this.snippet,
  });

  final int pageNumber;
  final int startIndex;
  final int endIndex;
  final String snippet;
}
