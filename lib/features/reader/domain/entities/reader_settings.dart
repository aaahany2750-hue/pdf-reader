/// Controls how documents are displayed by the reader engine.
class ReaderSettings {
  const ReaderSettings({
    required this.darkModeRendering,
    required this.keepScreenOn,
    required this.defaultZoom,
    required this.readingDirection,
    required this.pageLayoutMode,
  });

  const ReaderSettings.defaults()
      : darkModeRendering = false,
        keepScreenOn = false,
        defaultZoom = 1,
        readingDirection = ReadingDirection.leftToRight,
        pageLayoutMode = PageLayoutMode.continuous;

  final bool darkModeRendering;
  final bool keepScreenOn;
  final double defaultZoom;
  final ReadingDirection readingDirection;
  final PageLayoutMode pageLayoutMode;

  ReaderSettings copyWith({
    bool? darkModeRendering,
    bool? keepScreenOn,
    double? defaultZoom,
    ReadingDirection? readingDirection,
    PageLayoutMode? pageLayoutMode,
  }) =>
      ReaderSettings(
        darkModeRendering: darkModeRendering ?? this.darkModeRendering,
        keepScreenOn: keepScreenOn ?? this.keepScreenOn,
        defaultZoom: defaultZoom ?? this.defaultZoom,
        readingDirection: readingDirection ?? this.readingDirection,
        pageLayoutMode: pageLayoutMode ?? this.pageLayoutMode,
      );
}

/// Controls horizontal reading order for page navigation.
enum ReadingDirection { leftToRight, rightToLeft }

/// Controls whether pages flow continuously or one page at a time.
enum PageLayoutMode { continuous, singlePage }
