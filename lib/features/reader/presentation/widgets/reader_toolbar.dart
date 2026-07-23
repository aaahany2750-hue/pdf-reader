import 'package:flutter/material.dart';

import '../../../../localization/generated/app_localizations.dart';

class ReaderToolbar extends StatelessWidget {
  const ReaderToolbar({
    required this.currentPage,
    required this.pageCount,
    required this.onPreviousPage,
    required this.onNextPage,
    required this.onJumpToPage,
    required this.onZoomOut,
    required this.onZoomIn,
    super.key,
  });

  final int currentPage;
  final int? pageCount;
  final VoidCallback onPreviousPage;
  final VoidCallback onNextPage;
  final VoidCallback onJumpToPage;
  final VoidCallback onZoomOut;
  final VoidCallback onZoomIn;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final totalPages = pageCount;
    final label = totalPages == null
        ? '${l10n.readerPage} $currentPage'
        : l10n.readerPageOf(currentPage, totalPages);
    return Material(
      elevation: 2,
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              IconButton(onPressed: onZoomOut, icon: const Icon(Icons.zoom_out)),
              IconButton(onPressed: onZoomIn, icon: const Icon(Icons.zoom_in)),
              const Spacer(),
              IconButton(
                onPressed: currentPage > 1 ? onPreviousPage : null,
                icon: const Icon(Icons.chevron_left),
              ),
              TextButton(onPressed: onJumpToPage, child: Text(label)),
              IconButton(
                onPressed: totalPages == null || currentPage < totalPages
                    ? onNextPage
                    : null,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
