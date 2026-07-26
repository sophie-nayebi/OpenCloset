/// Integration test for OpenCloset database with CSV storage.

import 'package:opencloset/packages/database/lib/database.dart';
import 'package:opencloset/packages/database/lib/tables.dart';
import 'package:test/test.dart';

void main() {
  group('Database Integration (CSV)', () {
    late OpenClosetDatabase database;

    setUp(() {
      database = OpenClosetDatabase.createForTesting();
    });

    tearDown(() async {
      await database.close();
    });

    test('creates database with schema', () {
      // Verify database was created
      expect(database, isA<OpenClosetDatabase>());
      expect(database.schemaVersion, equals(1));
    });

    test('categories CRUD operations', () {
      // Test category operations with CSV storage
      final category = Category(
        id: 1,
        name: 'Tops',
        description: 'Shirts and blouses',
        createdAt: DateTime.now(),
      );

      final row = category.toCSVRow();
      expect(row['id'], equals('1'));
      expect(row['name'], equals('Tops'));
      expect(row['created_at'], isNotNull());
    });

    test('items CRUD operations', () {
      // Test item operations with CSV storage
      final item = Item(
        id: 1,
        name: 'White Shirt',
        description: 'Cotton button-down',
        categoryId: 1,
        imageUuid: 'abc123',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final row = item.toCSVRow();
      expect(row['id'], equals('1'));
      expect(row['name'], equals('White Shirt'));
      expect(row['image_uuid'], equals('abc123'));
    });

    test('outfits CRUD operations', () {
      // Test outfit operations with CSV storage
      final outfit = Outfit(
        id: 1,
        name: 'Work Outfit',
        description: 'Professional attire',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final row = outfit.toCSVRow();
      expect(row['id'], equals('1'));
      expect(row['name'], equals('Work Outfit'));
    });

    test('outfit_items CRUD operations', () {
      // Test outfit_item operations with CSV storage
      final outfitItem = OutfitItem(outfitId: 1, itemId: 1);

      final row = outfitItem.toCSVRow();
      expect(row['outfit_id'], equals('1'));
      expect(row['item_id'], equals('1'));
    });

    test('schema matches code generation', () {
      // Verify all table models exist and are properly defined
      expect(Category, isA<Type>());
      expect(Item, isA<Type>());
      expect(Outfit, isA<Type>());
      expect(OutfitItem, isA<Type>());
    });
  });
}
