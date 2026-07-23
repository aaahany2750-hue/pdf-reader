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
  @override String get readerEmptyTitle => 'No PDF open';
  @override String get readerEmptyMessage => 'Choose a PDF from device storage to start reading.';
  @override String get readerOpenErrorTitle => 'Unable to open PDF';
  @override String get readerChooseAnotherPdf => 'Choose another PDF';
  @override String get readerUnknownError => 'Unknown reader error';
  @override String get readerJumpToPage => 'Jump to page';
  @override String get readerCancel => 'Cancel';
  @override String get readerGo => 'Go';
  @override String get readerPage => 'Page';
  @override String readerPageOf(Object currentPage, Object pageCount) => 'Page $currentPage of $pageCount';
}
