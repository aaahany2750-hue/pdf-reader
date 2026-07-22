import 'package:flutter/material.dart';

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
