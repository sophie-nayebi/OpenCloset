/// Unit tests for the OpenCloset database layer.
///
/// Tests verify:
/// - Database connection initialization
/// - Platform detection
/// - Migration strategy creation
/// - Database connection lifecycle
///
/// Note: These tests use in-memory connections via `createForTesting()`.

import 'package:drift/drift.dart';
import 'package:opencloset/packages/database/lib/database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';

/// Default timestamp for test insert operations.
const _now = DateTime.now;

void main() {
  group('OpenClosetDatabase', () {
    group('Connection Initialization', () {
      test('creates a valid database connection', () {
        final database = OpenClosetDatabase(createForTesting());

        expect(database, isA<OpenClosetDatabase>());
        expect(database.schemaVersion, 1);
      });

      test('schema version is correctly set', () {
        final database = OpenClosetDatabase(createForTesting());
        expect(database.schemaVersion, 1);
      });

      test('migration strategy is non-null', () {
        final database = OpenClosetDatabase(createForTesting());
        expect(database.migrationStrategy, isNotNull);
      });
    });

 group('Platform Detection', () {
    test('isNative returns true on native platforms', () {
      // In Flutter, this runs on the native platform
      expect(isNativePlatform(), true);
    });

    test('isUnsupported returns false on supported platforms', () {
      expect(isUnsupportedPlatform(), false);
    });
  });

    group('Database Connection Lifecycle', () {
      test('database opens and closes successfully', () async {
        final database = OpenClosetDatabase(createForTesting());

        await database.open();
        await database.close();
      });

      test('in-memory database works for basic queries', () async {
        final database = OpenClosetDatabase(createForTesting());

        try {
          await database.open();

          // Verify we can query the sqlite_master table
          final tables = await database.customQuery(
            "SELECT name FROM sqlite_master WHERE type = 'table' ORDER BY name;",
          ).get();

          expect(tables.length, 4);
          expect(tables.contains('categories'), true);
          expect(tables.contains('items'), true);
          expect(tables.contains('outfits'), true);
          expect(tables.contains('outfit_items'), true);
        } finally {
          await database.close();
        }
      });

      test('createForTesting creates independent database', () async {
        final database = OpenClosetDatabase(createForTesting());

        try {
          await database.open();

       await database.categories.insertBatch([
          CategoriesCompanion.insert(name: 'Test Category', createdAt: _now()),
        ]);

          final categories = await database.categories.getAll();
          expect(categories.length, 1);
          expect(categories[0].name, 'Test Category');
        } finally {
          await database.close();
        }
      });
    });

    group('Application Directory Detection', () {
      test('application directory is accessible', () async {
        final directory = await getApplicationDocumentsDirectory();
        expect(directory, isNotNull);
        expect(directory.path, matchesRegexp('.+'));
      });

      test('application directory path is valid', () async {
        final directory = await getApplicationDocumentsDirectory();
        expect(directory.path, isString);
        expect(directory.path.isNotEmpty, true);
      });
    });
  });
}
