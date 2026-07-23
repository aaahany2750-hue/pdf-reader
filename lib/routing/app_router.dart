import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/favorites/presentation/pages/favorites_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/reader/presentation/pages/reader_page.dart';
import '../features/recent_files/presentation/pages/recent_files_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoute.home.path,
    routes: [
      GoRoute(path: AppRoute.home.path, name: AppRoute.home.name, builder: (_, __) => const HomePage()),
      GoRoute(path: AppRoute.reader.path, name: AppRoute.reader.name, builder: (_, __) => const ReaderPage()),
      GoRoute(path: AppRoute.recentFiles.path, name: AppRoute.recentFiles.name, builder: (_, __) => const RecentFilesPage()),
      GoRoute(path: AppRoute.favorites.path, name: AppRoute.favorites.name, builder: (_, __) => const FavoritesPage()),
      GoRoute(path: AppRoute.settings.path, name: AppRoute.settings.name, builder: (_, __) => const SettingsPage()),
    ],
  );
});

final navigationProvider = Provider<GoRouter>((ref) => ref.watch(appRouterProvider));
