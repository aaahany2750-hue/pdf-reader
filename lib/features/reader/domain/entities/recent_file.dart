/// Metadata for a document recently opened in the reader.
class RecentFile {
  const RecentFile({
    required this.filename,
    required this.path,
    required this.page,
    required this.readingProgress,
    required this.lastOpenedAt,
    required this.thumbnailPlaceholder,
    required this.isFavorite,
  });

  final String filename;
  final String path;
  final int page;
  final double readingProgress;
  final DateTime lastOpenedAt;
  final String thumbnailPlaceholder;
  final bool isFavorite;
}
