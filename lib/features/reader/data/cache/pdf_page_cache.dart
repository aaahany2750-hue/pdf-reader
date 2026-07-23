import 'dart:collection';

import '../../../../core/logging/app_logger.dart';

/// Memory-safe least-recently-used cache for rendered PDF page artifacts.
class PdfPageCache<T extends Object> {
  PdfPageCache({this.maximumEntries = 24}) : assert(maximumEntries > 0);

  final int maximumEntries;
  final LinkedHashMap<PdfPageCacheKey, T> _entries = LinkedHashMap<PdfPageCacheKey, T>();

  int get length => _entries.length;

  T? read(PdfPageCacheKey key) {
    final value = _entries.remove(key);
    if (value == null) {
      return null;
    }
    _entries[key] = value;
    return value;
  }

  void write(PdfPageCacheKey key, T value) {
    _entries.remove(key);
    _entries[key] = value;
    _evictIfNeeded();
  }

  void invalidateDocument(String documentPath) {
    _entries.removeWhere((key, _) => key.documentPath == documentPath);
  }

  void clear() => _entries.clear();

  void _evictIfNeeded() {
    while (_entries.length > maximumEntries) {
      final oldestKey = _entries.keys.first;
      _entries.remove(oldestKey);
      appLogger.d('Evicted rendered PDF page ${oldestKey.pageNumber} from cache.');
    }
  }
}

/// Identifies a rendered page variant by document, page, zoom, and rotation.
class PdfPageCacheKey {
  const PdfPageCacheKey({
    required this.documentPath,
    required this.pageNumber,
    required this.zoomBucket,
    required this.rotationDegrees,
  });

  final String documentPath;
  final int pageNumber;
  final int zoomBucket;
  final int rotationDegrees;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PdfPageCacheKey &&
          documentPath == other.documentPath &&
          pageNumber == other.pageNumber &&
          zoomBucket == other.zoomBucket &&
          rotationDegrees == other.rotationDegrees;

  @override
  int get hashCode => Object.hash(documentPath, pageNumber, zoomBucket, rotationDegrees);
}
