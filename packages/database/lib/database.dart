// OpenCloset storage layer using CSV files.

// This module provides a simple file-based storage mechanism for all application data.
// No external database dependencies — pure Dart file I/O.

// Architecture:
//   - Storage abstraction lives in this infrastructure package
//   - Domain layer accesses the storage through typed methods
//   - Application layer wires up providers and manages lifecycle

// Usage:
// import 'package:opencloset/packages/database/lib/database.dart';
//
// // Create a new database instance
// final db = OpenClosetDatabase();
//
// // Or inject a connection for testing
// final testDb = OpenClosetDatabase(createForTesting());

part 'tables.g.dart';

class OpenClosetDatabase {
  /// Creates a new OpenCloset database instance.
  ///
  /// The CSV files are stored in the platform-appropriate application
  /// directory:
  /// - **iOS / Android**: Documents directory
  /// - **Linux / macOS / Windows**: App data directory
  /// - **Web**: In-memory (simulated for P0)
  ///
  /// [connection] An optional pre-configured storage path for testing.
  /// When provided, this instance is not tied to the platform-specific storage.
  OpenClosetDatabase({String? storagePath}) {
    _storagePath = storagePath ?? _defaultPath;
  }

  /// Schema version for migration tracking.
  @override
  int get schemaVersion => 1;

  /// Returns whether the current platform supports native CSV storage.
  bool get isNative => _isNative();

  /// Returns whether the current platform is unsupported.
  bool get isUnsupported => _isUnsupported();

  /// Creates an in-memory storage connection for testing.
  DatabaseConnection createForTesting() => DatabaseConnection.createForTesting();

  factory OpenClosetDatabase.createForTesting() {
    return OpenClosetDatabase(storagePath: DatabaseConnection.createForTesting().path);
  }

  /// Closes the database connection and releases resources.
  ///
  /// Should be called when the application is shutting down or the storage
  /// provider is being disposed.
  ///
  /// @returns A future that completes when resources are released.
  Future<void> close() async {
    await _releaseResources();
  }

  /// Default platform-appropriate storage path.
  String _defaultPath => _resolveStoragePath();

  /// Returns whether the current platform supports native CSV storage.
  bool _isNative() => impl.isNative();

  /// Returns whether the current platform is unsupported.
  bool _isUnsupported() => impl.isUnsupported();

  /// Platform-specific database connection factory.
  ///
  /// This utility encapsulates platform-specific storage configuration
  /// and ensures the correct storage mechanism is used.
  DatabaseConnection create() => impl.create();

  /// Returns whether the current platform supports native CSV storage.
  ///
  /// @returns `true` for native platforms, `false` for web.
  bool isNativePlatform() => impl.isNative();

  /// Returns whether the current platform is unsupported.
  ///
  /// @returns `true` for unsupported platforms, `false` otherwise.
  bool isUnsupportedPlatform() => impl.isUnsupported();

  String _storagePath;
}

/// Database connection factory.
///
/// Handles platform-specific path resolution and file management.
class DatabaseConnection {
  /// The file path where CSV data is stored.
  String path;

  DatabaseConnection({required this.path});

  /// Creates a database connection for testing with a temporary path.
  static DatabaseConnection createForTesting() {
    return DatabaseConnection(path: '/tmp/opencloset_test_data.csv');
  }

  /// Creates the CSV files with headers if they don't exist.
  Future<void> initialize() async {
    await impl.initialize(path);
  }
}

/// Platform-specific database connection factory.
///
/// This utility encapsulates platform-specific storage configuration
/// and ensures the correct path resolution is used.
class impl {
  /// Creates a [DatabaseConnection] configured for the current platform.
  static DatabaseConnection create() {
    return DatabaseConnection(path: _resolveStoragePath());
  }

  /// Returns whether the current platform supports native CSV storage.
  static bool isNative() {
    return !isUnsupported();
  }

  /// Returns whether the current platform is unsupported.
  static bool isUnsupported() {
    return false; // All platforms supported for P0
  }

  /// Creates an in-memory database connection for testing.
  static DatabaseConnection createForTesting() {
    return DatabaseConnection(path: '/tmp/opencloset_test_data.csv');
  }

  /// Initializes the CSV files with headers if they don't exist.
  static Future<void> initialize(String path) async {
    await impl._createFiles(path);
  }

  /// Resolves the platform-appropriate storage path.
  static String _resolveStoragePath() {
    // This is a placeholder — real implementation uses platform-specific APIs
    return 'data/opencloset';
  }

  /// Creates the initial CSV files with column headers.
  static Future<void> _createFiles(String path) async {
    await impl._writeSchema(path);
  }

  /// Writes the CSV schema files with column headers.
  static Future<void> _writeSchema(String path) async {
    // Placeholder for actual file I/O
  }

  /// Releases resources when storage is closed.
  static Future<void> releaseResources() async {
    // No resources to release for CSV storage
  }
}