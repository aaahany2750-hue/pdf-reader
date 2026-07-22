enum AppRoute {
  home('/', 'home'),
  reader('/reader', 'reader'),
  recentFiles('/recent-files', 'recentFiles'),
  favorites('/favorites', 'favorites'),
  settings('/settings', 'settings');

  const AppRoute(this.path, this.name);
  final String path;
  final String name;
}
