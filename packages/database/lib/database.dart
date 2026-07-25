/// OpenCloset database layer using Drift.
///
/// This module provides the database connection, platform-specific setup,
/// and the main `OpenClosetDatabase` class that extends the Drift-generated
/// database.
///
/// Architecture:
///   - Database abstraction lives in this infrastructure package
///   - Domain layer accesses the database through DAOs
///   - Application layer wires up providers and manages lifecycle
///
/// Usage:
/// ```dart
/// import 'package:opencloset/packages/database/lib/database.dart';
///
/// // Create a new database instance
/// final db = OpenClosetDatabase();
///
/// // Or inject a connection for testing
/// final testDb = OpenClosetDatabase(createForTesting());
/// ```

import 'package:drift/drift.dart';
import 'tables.dart';
import 'connection/connection.dart' as impl;

part 'database.g.dart';

/// OpenCloset database class.
///
/// This class extends the Drift-generated base class [$_$OpenClosetDatabase]
/// and provides platform-specific database initialization and migration strategies.
///
/// @example
/// ```dart
/// final database = OpenClosetDatabase();
/// ```
///
/// @example
/// ```dart
/// // For testing
/// final testDb = OpenClosetDatabase(createForTesting());
/// ```
@DriftDatabase(tables: [Categories, Items, Outfits, OutfitItems], include: {'sql.drift'})
class OpenClosetDatabase extends _$OpenClosetDatabase {
  /// Creates a new OpenCloset database instance.
  ///
  /// The database file is stored in the platform-appropriate application
  /// directory:
  /// - **iOS / Android**: Documents directory
  /// - **Linux / macOS / Windows**: App data directory
  /// - **Web**: In-memory (WebSQLite/IndexedDB setup requires additional config)
  ///
  /// [connection] An optional pre-configured [DatabaseConnection] for testing.
  /// When provided, this instance is not tied to the platform-specific storage.
  OpenClosetDatabase({DatabaseConnection? connection})
      : super(
          connection ?? impl.create(),
        );

  /// Schema version for migration tracking.
  /// Increment this when adding, removing, or altering columns.
  @override
  int get schemaVersion => 1;

  /// Returns whether the current platform supports native SQLite storage.
  bool get isNative => impl.isNative();

  /// Returns whether the current platform is unsupported.
  bool get isUnsupported => impl.isUnsupported();

  /// Creates an in-memory database connection for testing.
  DatabaseConnection createForTesting() => impl.createForTesting();

  factory OpenClosetDatabase.createForTesting() {
  return OpenClosetDatabase(
    connection: impl.createForTesting(),
  );
}

  /// Closes the database connection and releases resources.
  ///
  /// Should be called when the application is shutting down or the database
  /// provider is being disposed.
  ///
  /// @returns A future that completes when the connection is closed.
  @override
  Future<void> close() async {
    return super.close();
  }
}

/// Platform-specific database connection factory.
///
/// This utility encapsulates platform-specific database configuration
/// and ensures the correct storage mechanism is used.
///
/// @returns A [DriftDatabase] configured for the current platform.
DatabaseConnection create() => impl.create();

/// Returns whether the current platform supports native SQLite storage.
///
/// @returns `true` for native platforms, `false` for web.
bool isNativePlatform() => impl.isNative();

/// Returns whether the current platform is unsupported.
///
/// @returns `true` for unsupported platforms, `false` otherwise.
bool isUnsupportedPlatform() => impl.isUnsupported();
