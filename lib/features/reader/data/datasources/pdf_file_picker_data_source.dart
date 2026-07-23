import 'package:file_picker/file_picker.dart';

import '../../domain/entities/reader_document.dart';
import '../../domain/exceptions/reader_exception.dart';

/// Adapter around native file picking restricted to PDF documents.
class PdfFilePickerDataSource {
  Future<ReaderDocument?> pickPdfDocument({required int initialPage}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['pdf'],
        allowMultiple: false,
        withData: false,
      );

      if (result == null || result.files.isEmpty) {
        return null;
      }

      final file = result.files.single;
      final path = file.path;
      if (path == null || path.isEmpty) {
        throw const ReaderException('The selected PDF file is unavailable.');
      }

      return ReaderDocument(
        path: path,
        name: file.name,
        size: file.size,
        initialPage: initialPage,
      );
    } on ReaderException {
      rethrow;
    } catch (error) {
      throw ReaderException('Unable to pick a PDF file.', error);
    }
  }
}
