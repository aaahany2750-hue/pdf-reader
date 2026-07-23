import '../../../../core/logging/app_logger.dart';
import '../entities/reader_document.dart';
import '../entities/reader_session.dart';
import '../entities/reading_statistics.dart';

/// Coordinates the volatile state of an open document without coupling it to UI.
class ReaderSessionManager {
  ReaderSession? _session;
  final Set<int> _visitedPages = <int>{};

  ReaderSession? get session => _session;

  ReaderSession start({
    required ReaderDocument document,
    required int pageCount,
    double initialZoom = 1,
  }) {
    final now = DateTime.now();
    final currentPage = document.initialPage.clamp(1, pageCount).toInt();
    _visitedPages
      ..clear()
      ..add(currentPage);
    _session = ReaderSession(
      document: document,
      currentPage: currentPage,
      pageCount: pageCount,
      zoomLevel: initialZoom,
      rotationDegrees: 0,
      scrollOffset: 0,
      readingTime: Duration.zero,
      lastInteractionAt: now,
      startedAt: now,
    );
    appLogger.i('Reader session started for ${document.name}.');
    return _session!;
  }

  ReaderSession? updateInteraction({
    int? currentPage,
    int? pageCount,
    double? zoomLevel,
    int? rotationDegrees,
    double? scrollOffset,
  }) {
    final current = _session;
    if (current == null) {
      return null;
    }
    final now = DateTime.now();
    final nextPage = currentPage?.clamp(1, pageCount ?? current.pageCount).toInt();
    if (nextPage != null) {
      _visitedPages.add(nextPage);
    }
    _session = current.copyWith(
      currentPage: nextPage,
      pageCount: pageCount,
      zoomLevel: zoomLevel,
      rotationDegrees: rotationDegrees,
      scrollOffset: scrollOffset,
      readingTime: current.readingTime + now.difference(current.lastInteractionAt),
      lastInteractionAt: now,
    );
    return _session;
  }

  ReadingStatistics statistics() {
    final current = _session;
    if (current == null) {
      return const ReadingStatistics(
        pagesRead: 0,
        readingPercentage: 0,
        totalReadingTime: Duration.zero,
        estimatedRemainingPages: 0,
      );
    }
    final progress = current.readingProgress.clamp(0, 1).toDouble();
    return ReadingStatistics(
      pagesRead: _visitedPages.length,
      readingPercentage: progress * 100,
      totalReadingTime: current.readingTime,
      estimatedRemainingPages: (current.pageCount - current.currentPage).clamp(0, current.pageCount).toInt(),
    );
  }
}
