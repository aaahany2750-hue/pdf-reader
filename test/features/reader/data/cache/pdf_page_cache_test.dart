import 'package:flutter_test/flutter_test.dart';
import 'package:novapdf/features/reader/data/cache/pdf_page_cache.dart';

void main() {
  test('PdfPageCache evicts the least recently used page', () {
    final cache = PdfPageCache<String>(maximumEntries: 2);
    const first = PdfPageCacheKey(
      documentPath: 'a.pdf',
      pageNumber: 1,
      zoomBucket: 100,
      rotationDegrees: 0,
    );
    const second = PdfPageCacheKey(
      documentPath: 'a.pdf',
      pageNumber: 2,
      zoomBucket: 100,
      rotationDegrees: 0,
    );
    const third = PdfPageCacheKey(
      documentPath: 'a.pdf',
      pageNumber: 3,
      zoomBucket: 100,
      rotationDegrees: 0,
    );

    cache.write(first, 'one');
    cache.write(second, 'two');
    expect(cache.read(first), 'one');

    cache.write(third, 'three');

    expect(cache.read(second), isNull);
    expect(cache.read(first), 'one');
    expect(cache.read(third), 'three');
  });
}
