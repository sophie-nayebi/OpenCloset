/// Web database connection implementation.
///
/// This module handles database configuration for web platforms using in-memory
/// SQLite storage via WebAssembly (sqlite3.wasm).

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'package:flutter/foundation.dart';

/// Creates a web database connection using in-memory storage.
///
/// On web platforms, SQLite runs via WebAssembly through sqlite3.wasm.
/// The database is stored in memory during the session.
///
/// @returns A [DriftDatabase] configured for web storage.
DriftDatabase create() {
  return driftDatabase(name: 'opencloset.db');
}

/// Validates the database schema against drift-generated expectations.
///
/// @param [database] The database to validate.
/// @throws [DriftException] if the schema validation fails.
Future<void> validateDatabaseSchema(GeneratedDatabase database) async {
  await VerifySelf(database).validateDatabaseSchema();
}

/// Returns whether the current platform is a native platform.
bool isNative() => !kIsWeb;

/// Returns whether the current platform is unsupported.
bool isUnsupported() {
  return false;
}

/// Creates an in-memory database connection for testing.
DriftDatabase createForTesting() {
  return driftDatabase(name: 'opencloset.db');
}
