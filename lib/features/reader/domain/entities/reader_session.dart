import 'reader_document.dart';

/// Immutable snapshot of an active reader session.
class ReaderSession {
  const ReaderSession({
    required this.document,
    required this.currentPage,
    required this.pageCount,
    required this.zoomLevel,
    required this.rotationDegrees,
    required this.scrollOffset,
    required this.readingTime,
    required this.lastInteractionAt,
    required this.startedAt,
  });

  final ReaderDocument document;
  final int currentPage;
  final int pageCount;
  final double zoomLevel;
  final int rotationDegrees;
  final double scrollOffset;
  final Duration readingTime;
  final DateTime lastInteractionAt;
  final DateTime startedAt;

  double get readingProgress => pageCount <= 0 ? 0 : currentPage / pageCount;

  ReaderSession copyWith({
    ReaderDocument? document,
    int? currentPage,
    int? pageCount,
    double? zoomLevel,
    int? rotationDegrees,
    double? scrollOffset,
    Duration? readingTime,
    DateTime? lastInteractionAt,
    DateTime? startedAt,
  }) =>
      ReaderSession(
        document: document ?? this.document,
        currentPage: currentPage ?? this.currentPage,
        pageCount: pageCount ?? this.pageCount,
        zoomLevel: zoomLevel ?? this.zoomLevel,
        rotationDegrees: rotationDegrees ?? this.rotationDegrees,
        scrollOffset: scrollOffset ?? this.scrollOffset,
        readingTime: readingTime ?? this.readingTime,
        lastInteractionAt: lastInteractionAt ?? this.lastInteractionAt,
        startedAt: startedAt ?? this.startedAt,
      );
}
