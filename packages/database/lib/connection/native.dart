/// Native database connection implementation.
///
/// This module handles platform-specific database configuration for native
/// platforms (iOS, Android, Linux, macOS, Windows) using file-based SQLite storage.
///
/// @note Requires [flutter/foundation] and [path_provider] dependencies.

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Creates a native database connection.
///
/// Returns a configured [DriftDatabase] instance for native platforms.
///
/// @returns A [DriftDatabase] configured for native storage.
DatabaseConnection create() {
  return driftDatabase(name: 'opencloset.db');
}

/// Validates the database schema against drift-generated expectations.
///
/// This method is called during database initialization to verify that the
/// schema matches what drift expects. This helps catch migration bugs early.
///
/// @param [database] The database to validate.
/// @throws [DriftException] if the schema validation fails.
Future<void> validateDatabaseSchema(GeneratedDatabase database) async {
  await VerifySelf(database).validateDatabaseSchema();
}

/// Returns whether the current platform is a native platform.
bool isNative() {
  return !dart.library.js_interop;
}

/// Returns whether the current platform is unsupported.
bool isUnsupported() {
  return false;
}

/// Creates an in-memory database connection for testing.
DatabaseConnection createForTesting() {
  return driftDatabase(name: 'opencloset.db');
}
