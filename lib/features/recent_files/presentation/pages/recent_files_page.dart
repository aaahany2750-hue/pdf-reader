import 'package:flutter/material.dart';

import '../../../../localization/generated/app_localizations.dart';

class RecentFilesPage extends StatelessWidget {
  const RecentFilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.recentFilesTitle
favoritesTitle)),
      body: Center(child: Text(l10n.recentFilesTitle
favoritesTitle)),
    );
  }
}
