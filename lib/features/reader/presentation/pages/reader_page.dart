import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../../../localization/generated/app_localizations.dart';
import '../controllers/reader_controller.dart';
import '../controllers/reader_state.dart';
import '../widgets/reader_empty_state.dart';
import '../widgets/reader_error_state.dart';
import '../widgets/reader_toolbar.dart';

/// Main PDF reader screen that renders documents and exposes reader controls.
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
            tooltip: l10n.readerSearch,
            onPressed: _showSearchDialog,
            icon: const Icon(Icons.search),
          ),
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
          onPreviousSearchResult: _previousSearchResult,
          onNextSearchResult: _nextSearchResult,
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

  Future<void> _showSearchDialog() async {
    final textController = TextEditingController();
    final query = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).readerSearch),
        content: TextField(
          controller: textController,
          autofocus: true,
          textInputAction: TextInputAction.search,
          onSubmitted: (value) => Navigator.of(context).pop(value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context).readerCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(textController.text),
            child: Text(AppLocalizations.of(context).readerSearch),
          ),
        ],
      ),
    );
    textController.dispose();
    if (query == null || query.trim().isEmpty) {
      return;
    }
    await ref.read(readerControllerProvider.notifier).search(query);
    await _goToActiveSearchResult();
  }

  Future<void> _nextSearchResult() async {
    ref.read(readerControllerProvider.notifier).nextSearchResult();
    await _goToActiveSearchResult();
  }

  Future<void> _previousSearchResult() async {
    ref.read(readerControllerProvider.notifier).previousSearchResult();
    await _goToActiveSearchResult();
  }

  Future<void> _goToActiveSearchResult() async {
    final current = ref.read(readerControllerProvider).valueOrNull;
    if (current == null || current.activeSearchResultIndex < 0) {
      return;
    }
    final result = current.searchResults[current.activeSearchResultIndex];
    await _pdfController.goToPage(pageNumber: result.pageNumber);
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
    required this.onPreviousSearchResult,
    required this.onNextSearchResult,
  });

  final ReaderState state;
  final PdfViewerController controller;
  final VoidCallback onPreviousPage;
  final VoidCallback onNextPage;
  final VoidCallback onJumpToPage;
  final VoidCallback onZoomOut;
  final VoidCallback onZoomIn;
  final VoidCallback onPreviousSearchResult;
  final VoidCallback onNextSearchResult;

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
          searchResultCount: state.searchResults.length,
          activeSearchResultIndex: state.activeSearchResultIndex,
          onPreviousSearchResult: onPreviousSearchResult,
          onNextSearchResult: onNextSearchResult,
        ),
      ],
        ),
      ],

import '../../../../localization/generated/app_localizations.dart';

class ReaderPage extends StatelessWidget {
  const ReaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.readerTitle
recentFilesTitle
favoritesTitle)),
      body: Center(child: Text(l10n.readerTitle
recentFilesTitle
favoritesTitle)),
    );
  }
}
