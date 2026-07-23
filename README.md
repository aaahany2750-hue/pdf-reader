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

## Reader Core Architecture Decisions

- The Reader feature remains feature-first and layered into `domain`, `data`, and `presentation` so repositories, controllers, cache, and UI can be tested independently.
- `ReaderSessionManager` owns volatile reading state such as page, zoom, rotation, scroll, reading time, progress, and interaction timestamps outside the widget tree.
- `PdfPageCache` is an in-memory LRU cache abstraction for rendered page artifacts. It is intentionally generic so native renderers, thumbnails, or future raster pipelines can reuse the same eviction policy.
- Search, bookmarks, recent files, and reader settings are separated behind repositories to keep future Drift DAO implementations replaceable without changing view models.
- The Reader UI uses lazy rendering through `pdfrx` and stores only bounded metadata locally, which keeps large PDFs responsive and minimizes memory pressure.

## Phase 3 Reader Core Scope

Phase 3 introduces the advanced reader core without adding OCR, AI, editing, annotation, merge/split, conversion, or cloud sync. The new core includes:

- Session management for document, page, zoom, rotation, scroll offset, reading time, progress, and interaction timestamps.
- LRU rendered-page cache abstraction designed to avoid unnecessary rerendering while remaining memory-safe.
- Repository boundaries for reader, bookmarks, recents, search, and reader settings.
- Search indexing primitives for incremental full-text search, search history, and result navigation.
- Bookmark and recent-file repositories that can be swapped to generated Drift DAOs without changing presentation code.
- Drift schema definitions for bookmarks, recents, search history, and reader statistics.
