import '../../../../core/logging/app_logger.dart';
import '../../domain/entities/reader_document.dart';
import '../../domain/exceptions/reader_exception.dart';
import '../../domain/repositories/reader_repository.dart';
import '../datasources/pdf_file_picker_data_source.dart';
import '../datasources/reader_preferences_data_source.dart';

/// Production reader repository coordinating file picking and page persistence.
class ReaderRepositoryImpl implements ReaderRepository {
  const ReaderRepositoryImpl({
    required PdfFilePickerDataSource pickerDataSource,
    required ReaderPreferencesDataSource preferencesDataSource,
  })  : _pickerDataSource = pickerDataSource,
        _preferencesDataSource = preferencesDataSource;

  final PdfFilePickerDataSource _pickerDataSource;
  final ReaderPreferencesDataSource _preferencesDataSource;

  @override
  Future<ReaderDocument?> pickPdfDocument() async {
    try {
      final document = await _pickerDataSource.pickPdfDocument(initialPage: 1);
      if (document == null) {
        appLogger.i('PDF picking canceled by user.');
        return null;
      }
      final lastPage = await readLastOpenedPage(document.path);
      appLogger.i('PDF selected: ${document.name}');
      return ReaderDocument(
        path: document.path,
        name: document.name,
        size: document.size,
        initialPage: lastPage,
      );
    } on ReaderException {
      rethrow;
    } catch (error, stackTrace) {
      appLogger.e('Failed to pick PDF document.', error: error, stackTrace: stackTrace);
      throw ReaderException('Unable to open the selected PDF.', error);
    }
  }

  @override
  Future<int> readLastOpenedPage(String documentPath) =>
      _preferencesDataSource.readLastOpenedPage(documentPath);

  @override
  Future<void> saveLastOpenedPage(String documentPath, int pageNumber) async {
    try {
      await _preferencesDataSource.saveLastOpenedPage(documentPath, pageNumber);
    } catch (error, stackTrace) {
      appLogger.w('Failed to persist reader page.', error: error, stackTrace: stackTrace);
    }
  }
}
