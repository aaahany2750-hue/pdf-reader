import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final languageControllerProvider = NotifierProvider<LanguageController, Locale?>(LanguageController.new);

class LanguageController extends Notifier<Locale?> {
  @override
  Locale? build() => null;

  void useSystemLanguage() => state = null;
  void setLanguage(Locale locale) => state = locale;
}
