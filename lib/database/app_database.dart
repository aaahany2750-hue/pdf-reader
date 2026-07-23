import 'package:drift/drift.dart';

/// Drift table definitions for NovaPDF persistence.
///
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
}

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

const novaPdfSchemaVersion = 1;
