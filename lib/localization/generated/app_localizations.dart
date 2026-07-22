import 'package:flutter/widgets.dart';

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

abstract class AppLocalizations {
  AppLocalizations(this.localeName);

  final String localeName;

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
  static const supportedLocales = [Locale('en'), Locale('ar')];

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  String get appName;
  String get homeTitle;
  String get readerTitle;
  String get recentFilesTitle;
  String get favoritesTitle;
  String get settingsTitle;
  String get openPdf;
  String get noRecentFiles;
  String get noFavorites;
  String get emptyStateHint;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => switch (locale.languageCode) {
        'ar' => AppLocalizationsAr(),
        _ => AppLocalizationsEn(),
      };

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
