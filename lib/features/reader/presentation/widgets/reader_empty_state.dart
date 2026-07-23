import 'package:flutter/material.dart';

import '../../../../localization/generated/app_localizations.dart';

/// Empty reader view shown before a PDF document is selected.
class ReaderEmptyState extends StatelessWidget {
  const ReaderEmptyState({required this.onOpenPdf, super.key});

  final VoidCallback onOpenPdf;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.picture_as_pdf_outlined, size: 72, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 24),
            Text(l10n.readerEmptyTitle, style: textTheme.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(l10n.readerEmptyMessage, style: textTheme.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onOpenPdf,
              icon: const Icon(Icons.folder_open_outlined),
              label: Text(l10n.openPdf),
            ),
          ],
        ),
      ),
    );
  }
}
