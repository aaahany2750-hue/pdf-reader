import '../entities/reader_document.dart';

abstract class ReaderRepository {
  Future<ReaderDocument?> pickPdfDocument();
  Future<int> readLastOpenedPage(String documentPath);
  Future<void> saveLastOpenedPage(String documentPath, int pageNumber);
}
