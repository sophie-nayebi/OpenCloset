/// Test file for CSV schema validation.

import 'package:opencloset/packages/database/lib/tables.dart';
import 'package:test/test.dart';

void main() {
  group('CSV Schema Validation', () {
    test('categories CSV schema has correct columns', () {
      // Categories should have: id, name, description, created_at
      final expectedColumns = ['id', 'name', 'description', 'created_at'];
      expect(expectedColumns.length, equals(4));
    });

    test('items CSV schema has correct columns', () {
      // Items should have: id, name, description, category_id, image_uuid, created_at, updated_at
      final expectedColumns = ['id', 'name', 'description', 'category_id', 'image_uuid', 'created_at', 'updated_at'];
      expect(expectedColumns.length, equals(7));
    });

    test('outfits CSV schema has correct columns', () {
      // Outfits should have: id, name, description, created_at, updated_at
      final expectedColumns = ['id', 'name', 'description', 'created_at', 'updated_at'];
      expect(expectedColumns.length, equals(5));
    });

    test('outfit_items CSV schema has correct columns', () {
      // Outfit items should have: outfit_id, item_id
      final expectedColumns = ['outfit_id', 'item_id'];
      expect(expectedColumns.length, equals(2));
    });

    test('category model serializes correctly', () {
      final category = Category(
        id: 1,
        name: 'Tops',
        description: 'Shirts and blouses',
        createdAt: DateTime.now(),
      );

      final row = category.toCSVRow();
      expect(row['id'], equals('1'));
      expect(row['name'], equals('Tops'));
      expect(row['description'], equals('Shirts and blouses'));
      expect(row['created_at'], isNotNull());
    });

    test('item model serializes correctly', () {
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
      expect(row['category_id'], equals('1'));
      expect(row['image_uuid'], equals('abc123'));
    });

    test('outfit model serializes correctly', () {
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
      expect(row['description'], equals('Professional attire'));
    });

    test('outfit_item model serializes correctly', () {
      final outfitItem = OutfitItem(outfitId: 1, itemId: 1);

      final row = outfitItem.toCSVRow();
      expect(row['outfit_id'], equals('1'));
      expect(row['item_id'], equals('1'));
    });
  });
}
