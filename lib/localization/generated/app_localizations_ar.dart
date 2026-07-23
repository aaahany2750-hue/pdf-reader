import 'app_localizations.dart';

class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr() : super('ar');
  @override String get appName => 'نوفا PDF';
  @override String get homeTitle => 'الرئيسية';
  @override String get readerTitle => 'القارئ';
  @override String get recentFilesTitle => 'الملفات الحديثة';
  @override String get favoritesTitle => 'المفضلة';
  @override String get settingsTitle => 'الإعدادات';
  @override String get openPdf => 'فتح ملف PDF';
  @override String get noRecentFiles => 'لا توجد ملفات حديثة بعد';
  @override String get noFavorites => 'لا توجد عناصر مفضلة بعد';
  @override String get emptyStateHint => 'افتح مستنداً لبدء إنشاء مكتبتك.';
  @override String get readerEmptyTitle => 'لا يوجد ملف PDF مفتوح';
  @override String get readerEmptyMessage => 'اختر ملف PDF من مساحة تخزين الجهاز لبدء القراءة.';
  @override String get readerOpenErrorTitle => 'تعذر فتح ملف PDF';
  @override String get readerChooseAnotherPdf => 'اختر ملف PDF آخر';
  @override String get readerUnknownError => 'خطأ غير معروف في القارئ';
  @override String get readerJumpToPage => 'الانتقال إلى صفحة';
  @override String get readerCancel => 'إلغاء';
  @override String get readerGo => 'انتقال';
  @override String get readerPage => 'صفحة';
  @override String readerPageOf(Object currentPage, Object pageCount) => 'صفحة $currentPage من $pageCount';
}
