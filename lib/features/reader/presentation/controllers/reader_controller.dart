import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/logging/app_logger.dart';
import '../../../../services/preferences/preferences_service.dart';
import '../../data/datasources/pdf_file_picker_data_source.dart';
import '../../data/datasources/reader_preferences_data_source.dart';
import '../../data/repositories/reader_repository_impl.dart';
import '../../domain/repositories/reader_repository.dart';
import 'reader_state.dart';

final readerRepositoryProvider = FutureProvider<ReaderRepository>((ref) async {
  final preferences = await PreferencesService.load();
  return ReaderRepositoryImpl(
    pickerDataSource: PdfFilePickerDataSource(),
    preferencesDataSource: ReaderPreferencesDataSource(preferences),
  );
});

final readerControllerProvider =
    AsyncNotifierProvider<ReaderController, ReaderState>(ReaderController.new);

class ReaderController extends AsyncNotifier<ReaderState> {
  @override
  Future<ReaderState> build() async => const ReaderState.empty();

  Future<void> pickAndOpenPdf() async {
    state = const AsyncData(ReaderState.loading());
    try {
      final repository = await ref.read(readerRepositoryProvider.future);
      final document = await repository.pickPdfDocument();
      if (document == null) {
        state = const AsyncData(ReaderState.empty());
        return;
      }
      state = AsyncData(
        ReaderState.ready(
          document: document,
          currentPage: document.initialPage,
        ),
      );
    } catch (error, stackTrace) {
      appLogger.e('Reader failed to open PDF.', error: error, stackTrace: stackTrace);
      state = AsyncData(ReaderState.error(error.toString()));
    }
  }

  Future<void> onPageChanged({required int pageNumber, int? pageCount}) async {
    final current = state.valueOrNull;
    final document = current?.document;
    if (current == null || document == null || pageNumber < 1) {
      return;
    }

    state = AsyncData(
      current.copyWith(
        currentPage: pageNumber,
        pageCount: pageCount ?? current.pageCount,
      ),
    );

    final repository = await ref.read(readerRepositoryProvider.future);
    await repository.saveLastOpenedPage(document.path, pageNumber);
  }
}
