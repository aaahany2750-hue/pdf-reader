import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../localization/generated/app_localizations.dart';
import '../../../../routing/app_routes.dart';
import '../../../../widgets/empty_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appName)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FilledButton.icon(
            onPressed: () => context.go(AppRoute.reader.path),
            icon: const Icon(Icons.picture_as_pdf_outlined),
            label: Text(l10n.openPdf),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.recentFilesTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          EmptySection(title: l10n.noRecentFiles, message: l10n.emptyStateHint),
          const SizedBox(height: 24),
          Text(
            l10n.favoritesTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          EmptySection(title: l10n.noFavorites, message: l10n.emptyStateHint),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          final routes = [
            AppRoute.home,
            AppRoute.recentFiles,
            AppRoute.favorites,
            AppRoute.settings,
          ];
          context.go(routes[index].path);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.homeTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.history_outlined),
            selectedIcon: const Icon(Icons.history),
            label: l10n.recentFilesTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.star_outline),
            selectedIcon: const Icon(Icons.star),
            label: l10n.favoritesTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.settingsTitle,
          ),
        ],
      ),
    );
  }
}
