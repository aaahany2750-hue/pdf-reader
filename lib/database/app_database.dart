import 'package:drift/drift.dart';

/// Drift table definitions for NovaPDF persistence.
///
/// Phase 3 keeps database concerns schema-focused and repository-ready so DAOs
/// can be generated without changing feature contracts in future phases.
class RecentFiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get path => text().unique()();
  TextColumn get filename => text()();
  IntColumn get page => integer().withDefault(const Constant(1))();
  RealColumn get readingProgress => real().withDefault(const Constant(0))();
  DateTimeColumn get lastOpenedAt => dateTime()();
  TextColumn get thumbnailPlaceholder => text().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
/// Phase 1 intentionally defines schema only. Data access objects and feature
/// repositories will be added when product capabilities are implemented.
class RecentFiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uri => text().unique()();
  TextColumn get displayName => text()();
  IntColumn get fileSize => integer().nullable()();
  DateTimeColumn get openedAt => dateTime()();
}

class Favorites extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get fileUri => text().unique()();
  TextColumn get displayName => text()();
  DateTimeColumn get createdAt => dateTime()();
}

class ReadingHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get fileUri => text()();
  IntColumn get pageNumber => integer()();
  DateTimeColumn get readAt => dateTime()();
}

class Bookmarks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get fileUri => text()();
  IntColumn get pageNumber => integer()();
  TextColumn get title => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class SearchHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get fileUri => text()();
  TextColumn get query => text()();
  DateTimeColumn get searchedAt => dateTime()();
}

class ReaderStatistics extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get fileUri => text().unique()();
  IntColumn get pagesRead => integer().withDefault(const Constant(0))();
  RealColumn get readingPercentage => real().withDefault(const Constant(0))();
  IntColumn get totalReadingSeconds => integer().withDefault(const Constant(0))();
  IntColumn get estimatedRemainingPages => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime()();
}

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

const novaPdfSchemaVersion = 3;
const novaPdfSchemaVersion = 1;
