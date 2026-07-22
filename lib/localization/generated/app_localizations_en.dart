import 'app_localizations.dart';

class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn() : super('en');
  @override String get appName => 'NovaPDF';
  @override String get homeTitle => 'Home';
  @override String get readerTitle => 'Reader';
  @override String get recentFilesTitle => 'Recent files';
  @override String get favoritesTitle => 'Favorites';
  @override String get settingsTitle => 'Settings';
  @override String get openPdf => 'Open PDF';
  @override String get noRecentFiles => 'No recent files yet';
  @override String get noFavorites => 'No favorites yet';
  @override String get emptyStateHint => 'Open a document to begin building your library.';
}
