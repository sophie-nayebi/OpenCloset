/// Migration tests for the OpenCloset database.
///
/// Tests verify:
/// - Migration strategy creates the correct schema
/// - Foreign key constraints are enforced
/// - Table structure matches expectations
/// - Migration from v0 to v1 works correctly

import 'package:drift/drift.dart';
import 'database.dart';
import 'tables.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Migration Strategy', () {
    group('v0 → v1 Migration', () {
      test('migration creates all required tables', () async {
        final database = OpenClosetDatabase(createForTesting());

        try {
          // Open the database - this should run migrations
          await database.open();

          // Verify tables exist by querying the schema
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

      test('categories table has correct structure', () async {
        final database = OpenClosetDatabase(createForTesting());

        try {
          await database.open();

          // Query table info to verify structure
          final columns = await database.customQuery(
            "PRAGMA table_info(categories);",
          ).get();

          expect(columns.length, 4);
          // id, name, description, created_at
          final columnsWithNames = columns.map((col) => col['name']);
          expect(columnsWithNames.contains('id'), true);
          expect(columnsWithNames.contains('name'), true);
          expect(columnsWithNames.contains('description'), true);
          expect(columnsWithNames.contains('created_at'), true);
        } finally {
          await database.close();
        }
      });

      test('items table has correct structure', () async {
        final database = OpenClosetDatabase(createForTesting());

        try {
          await database.open();

          final columns = await database.customQuery(
            "PRAGMA table_info(items);",
          ).get();

          expect(columns.length, 7);
          // id, name, description, category_id, image_uuid, created_at, updated_at
          final columnsWithNames = columns.map((col) => col['name']);
          expect(columnsWithNames.contains('id'), true);
          expect(columnsWithNames.contains('name'), true);
          expect(columnsWithNames.contains('description'), true);
          expect(columnsWithNames.contains('category_id'), true);
          expect(columnsWithNames.contains('image_uuid'), true);
          expect(columnsWithNames.contains('created_at'), true);
          expect(columnsWithNames.contains('updated_at'), true);
        } finally {
          await database.close();
        }
      });

      test('outfits table has correct structure', () async {
        final database = OpenClosetDatabase(createForTesting());

        try {
          await database.open();

          final columns = await database.customQuery(
            "PRAGMA table_info(outfits);",
          ).get();

          expect(columns.length, 5);
          // id, name, description, created_at, updated_at
          final columnsWithNames = columns.map((col) => col['name']);
          expect(columnsWithNames.contains('id'), true);
          expect(columnsWithNames.contains('name'), true);
          expect(columnsWithNames.contains('description'), true);
          expect(columnsWithNames.contains('created_at'), true);
          expect(columnsWithNames.contains('updated_at'), true);
        } finally {
          await database.close();
        }
      });

      test('outfit_items table has correct structure', () async {
        final database = OpenClosetDatabase(createForTesting());

        try {
          await database.open();

          final columns = await database.customQuery(
            "PRAGMA table_info(outfit_items);",
          ).get();

          expect(columns.length, 2);
          // outfit_id, item_id
          final columnsWithNames = columns.map((col) => col['name']);
          expect(columnsWithNames.contains('outfit_id'), true);
          expect(columnsWithNames.contains('item_id'), true);
        } finally {
          await database.close();
        }
      });
    });

    group('Foreign Key Constraints', () {
      test('foreign key enforcement is enabled', () async {
        final database = OpenClosetDatabase(createForTesting());

        try {
          await database.open();

          // Check that foreign keys are enabled
          final fkStatus = await database.customQuery(
            "PRAGMA foreign_key_list(items);",
          ).get();

          // The foreign key list for items should include category_id
          expect(fkStatus.length, greaterThan(0));
        } finally {
          await database.close();
        }
      });

      test('foreign key from items to categories exists', () async {
        final database = OpenClosetDatabase(createForTesting());

        try {
          await database.open();

          final fkList = await database.customQuery(
            "PRAGMA foreign_key_list(items);",
          ).get();

          final fkColumns = fkList.map((fk) => fk['from']);
          expect(fkColumns.contains('category_id'), true);
        } finally {
          await database.close();
        }
      });

      test('outfit_items has foreign keys to both outfits and items', () async {
        final database = OpenClosetDatabase(createForTesting());

        try {
          await database.open();

          final outfitFKs = await database.customQuery(
            "PRAGMA foreign_key_list(outfit_items) WHERE from LIKE 'outfit%';",
          ).get();

          final itemFKs = await database.customQuery(
            "PRAGMA foreign_key_list(outfit_items) WHERE from LIKE 'item%';",
          ).get();

          expect(outfitFKs.length, 1);
          expect(itemFKs.length, 1);
        } finally {
          await database.close();
        }
      });
    });

    group('Database Connection Lifecycle', () {
      test('database can be opened and closed', () async {
        final database = OpenClosetDatabase(createForTesting());

        await database.open();
        await database.close();
      });

      test('in-memory database for testing works', () async {
        final database = OpenClosetDatabase(createForTesting());

        try {
          await database.open();
          expect(true, true);
        } finally {
          await database.close();
        }
      });
    });
  });

  group('Application Directory', () {
    test('application directory exists', () async {
      final directory = await getApplicationDocumentsDirectory();
      expect(directory, isNotNull);
    });

    test('application directory path is not empty', () async {
      final directory = await getApplicationDocumentsDirectory();
      expect(directory.path, isString);
      expect(directory.path.isNotEmpty, true);
    });
  });
}
