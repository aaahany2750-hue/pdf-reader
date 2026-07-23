/// Aggregated reading statistics for the active document.
class ReadingStatistics {
  const ReadingStatistics({
    required this.pagesRead,
    required this.readingPercentage,
    required this.totalReadingTime,
    required this.estimatedRemainingPages,
  });

  final int pagesRead;
  final double readingPercentage;
  final Duration totalReadingTime;
  final int estimatedRemainingPages;
}
