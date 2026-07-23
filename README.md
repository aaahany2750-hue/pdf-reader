# NovaPDF

NovaPDF is a production-oriented Flutter foundation for an Android-first PDF application. Phase 1 establishes architecture, configuration, navigation, state management, persistence primitives, theming, and localization only.

## Phase 1 Scope

- Clean Architecture, MVVM, feature-first structure, repository-ready boundaries.
- Material 3 light/dark themes with Android dynamic color support.
- Riverpod dependency injection and state management.
- GoRouter navigation for Home, Reader, Recent Files, Favorites, and Settings.
- PDF rendering foundation powered by pdfrx/PDFium and native file picking.
- Drift database schema for recent files, favorites, reading history, bookmarks, and app settings.
- SharedPreferences service wrapper.
- English and Arabic localization with RTL support through Flutter localization delegates.
- Android 8.0+ configuration with edge-to-edge UI.

## Project Structure

```text
lib/
 ├── app/
 ├── core/
 ├── database/
 ├── features/
 ├── localization/
 ├── routing/
 ├── services/
 ├── shared/
 ├── theme/
 └── widgets/
```

## Development

Install dependencies and generate code:

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

Run quality checks:

```bash
flutter analyze
flutter test
flutter build apk --debug
```

## Notes

PDF rendering is limited to opening, viewing, zooming, panning, vertical scrolling, page jumping, and restoring the last page. Editing, OCR, AI, annotations, conversion, and cloud sync remain out of scope.
