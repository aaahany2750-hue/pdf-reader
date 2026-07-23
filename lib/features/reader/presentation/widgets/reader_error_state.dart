import 'package:flutter/material.dart';

import '../../../../localization/generated/app_localizations.dart';

/// Error view used when a document cannot be opened or rendered.
class ReaderErrorState extends StatelessWidget {
  const ReaderErrorState({required this.message, required this.onRetry, super.key});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text(l10n.readerOpenErrorTitle, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton(onPressed: onRetry, child: Text(l10n.readerChooseAnotherPdf)),
          ],
        ),
      ),
    );
  }
}
