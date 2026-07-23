import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../../../localization/generated/app_localizations.dart';
import '../controllers/reader_controller.dart';
import '../controllers/reader_state.dart';
import '../widgets/reader_empty_state.dart';
import '../widgets/reader_error_state.dart';
import '../widgets/reader_toolbar.dart';

class ReaderPage extends ConsumerStatefulWidget {
  const ReaderPage({super.key});

  @override
  ConsumerState<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends ConsumerState<ReaderPage> {
  final PdfViewerController _pdfController = PdfViewerController();

  @override
  void initState() {
    super.initState();
    _pdfController.addListener(_handleViewerChanged);
  }

  @override
  void dispose() {
    _pdfController.removeListener(_handleViewerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final readerState = ref.watch(readerControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.readerTitle),
        actions: [
          IconButton(
            tooltip: l10n.openPdf,
            onPressed: () =>
                ref.read(readerControllerProvider.notifier).pickAndOpenPdf(),
            icon: const Icon(Icons.folder_open_outlined),
          ),
        ],
      ),
      body: readerState.when(
        data: _buildBody,
        error: (error, _) => ReaderErrorState(
          message: error.toString(),
          onRetry: () => ref.read(readerControllerProvider.notifier).pickAndOpenPdf(),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildBody(ReaderState state) {
    return switch (state.status) {
      ReaderStatus.empty => ReaderEmptyState(
          onOpenPdf: () => ref.read(readerControllerProvider.notifier).pickAndOpenPdf(),
        ),
      ReaderStatus.loading => const Center(child: CircularProgressIndicator()),
      ReaderStatus.error => ReaderErrorState(
          message: state.errorMessage ?? AppLocalizations.of(context).readerUnknownError,
          onRetry: () => ref.read(readerControllerProvider.notifier).pickAndOpenPdf(),
        ),
      ReaderStatus.ready => _ReaderDocumentView(
          state: state,
          controller: _pdfController,
          onPreviousPage: _goToPreviousPage,
          onNextPage: _goToNextPage,
          onJumpToPage: _showJumpToPageDialog,
          onZoomOut: _zoomOut,
          onZoomIn: _zoomIn,
        ),
    };
  }

  void _handleViewerChanged() {
    if (!_pdfController.isReady) {
      return;
    }
    final pageNumber = _pdfController.pageNumber;
    if (pageNumber == null) {
      return;
    }
    ref.read(readerControllerProvider.notifier).onPageChanged(
          pageNumber: pageNumber,
          pageCount: _pdfController.pageCount,
        );
  }

  Future<void> _goToPreviousPage() async {
    if (!_pdfController.isReady) {
      return;
    }
    final current = _pdfController.pageNumber ?? 1;
    await _pdfController.goToPage(pageNumber: current - 1);
  }

  Future<void> _goToNextPage() async {
    if (!_pdfController.isReady) {
      return;
    }
    final current = _pdfController.pageNumber ?? 1;
    await _pdfController.goToPage(pageNumber: current + 1);
  }

  Future<void> _zoomOut() async {
    if (_pdfController.isReady) {
      await _pdfController.zoomDown();
    }
  }

  Future<void> _zoomIn() async {
    if (_pdfController.isReady) {
      await _pdfController.zoomUp();
    }
  }

  Future<void> _showJumpToPageDialog() async {
    if (!_pdfController.isReady) {
      return;
    }
    final textController = TextEditingController(
      text: '${_pdfController.pageNumber ?? 1}',
    );
    final page = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).readerJumpToPage),
        content: TextField(
          controller: textController,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: '1 - ${_pdfController.pageCount}'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context).readerCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(int.tryParse(textController.text)),
            child: Text(AppLocalizations.of(context).readerGo),
          ),
        ],
      ),
    );
    textController.dispose();
    if (page == null || page < 1 || page > _pdfController.pageCount) {
      return;
    }
    await _pdfController.goToPage(pageNumber: page);
  }
}

class _ReaderDocumentView extends StatelessWidget {
  const _ReaderDocumentView({
    required this.state,
    required this.controller,
    required this.onPreviousPage,
    required this.onNextPage,
    required this.onJumpToPage,
    required this.onZoomOut,
    required this.onZoomIn,
  });

  final ReaderState state;
  final PdfViewerController controller;
  final VoidCallback onPreviousPage;
  final VoidCallback onNextPage;
  final VoidCallback onJumpToPage;
  final VoidCallback onZoomOut;
  final VoidCallback onZoomIn;

  @override
  Widget build(BuildContext context) {
    final document = state.document!;
    return Column(
      children: [
        Expanded(
          child: PdfViewer.file(
            document.path,
            key: ValueKey(document.path),
            controller: controller,
            initialPageNumber: document.initialPage,
          ),
        ),
        ReaderToolbar(
          currentPage: state.currentPage,
          pageCount: state.pageCount,
          onPreviousPage: onPreviousPage,
          onNextPage: onNextPage,
          onJumpToPage: onJumpToPage,
          onZoomOut: onZoomOut,
          onZoomIn: onZoomIn,
        ),
      ],
    );
  }
}
