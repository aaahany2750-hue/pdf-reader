import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final databaseConnectionProvider = Provider<QueryExecutor>((ref) {
  final executor = driftDatabase(name: 'novapdf');
  ref.onDispose(executor.close);
  return executor;
});
