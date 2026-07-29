import 'package:flutter_test/flutter_test.dart';
import 'package:opencloset_database/database.dart';

void main() {
  group('Database Integration Tests', () {
    test('should work with different database paths', () async {
      final db1 = OpenClosetDatabase('/tmp/db1');
      final db2 = OpenClosetDatabase('/tmp/db2');
      
      expect(db1.categories.path, isNot(equals(db2.categories.path)));
    });

    test('should write a new category using CRUD API', () async {
      final db = OpenClosetDatabase('/tmp/test_db');
      
      await db.createCategory(
        id: '123e4567-e89b-12d3-a456-426614174000',
        name: 'Denim Jacket',
        description: 'Casual denim jacket',
      );
      
      final content = await db.categories.readAsString();
      expect(content, contains('Denim Jacket'));
    });

    test('should read a category by ID using CRUD API', () async {
      final db = OpenClosetDatabase('/tmp/test_db');
      await db.createCategory(
        id: '123e4567-e89b-12d3-a456-426614174000',
        name: 'Denim Jacket',
        description: 'Casual denim jacket',
      );
      
      final category = await db.readCategoryById('123e4567-e89b-12d3-a456-426614174000');
      expect(category, isNotNull);
      expect(category?['name'], equals('Denim Jacket'));
    });

    test('should write a new item using CRUD API', () async {
      final db = OpenClosetDatabase('/tmp/test_db');
      
      await db.createItem(
        id: '123e4567-e89b-12d3-a456-426614174000',
        name: 'T-Shirt',
        description: 'Cotton t-shirt',
        categoryId: '1',
        imageUuid: 'abc123',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      final content = await db.items.readAsString();
      expect(content, contains('T-Shirt'));
    });

    test('should read an item by ID using CRUD API', () async {
      final db = OpenClosetDatabase('/tmp/test_db');
      await db.createItem(
        id: '123e4567-e89b-12d3-a456-426614174000',
        name: 'T-Shirt',
        description: 'Cotton t-shirt',
        categoryId: '1',
        imageUuid: 'abc123',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      final item = await db.readItemById('123e4567-e89b-12d3-a456-426614174000');
      expect(item, isNotNull);
      expect(item?['name'], equals('T-Shirt'));
    });

    test('should write a new outfit using CRUD API', () async {
      final db = OpenClosetDatabase('/tmp/test_db');
      
      await db.createOutfit(
        id: '123e4567-e89b-12d3-a456-426614174000',
        name: 'Summer Outfit',
        description: 'Beach ready outfit',
      );
      
      final content = await db.outfits.readAsString();
      expect(content, contains('Summer Outfit'));
    });

    test('should read an outfit by ID using CRUD API', () async {
      final db = OpenClosetDatabase('/tmp/test_db');
      await db.createOutfit(
        id: '123e4567-e89b-12d3-a456-426614174000',
        name: 'Summer Outfit',
        description: 'Beach ready outfit',
      );
      
      final outfit = await db.readOutfitById('123e4567-e89b-12d3-a456-426614174000');
      expect(outfit, isNotNull);
      expect(outfit?['name'], equals('Summer Outfit'));
    });

    test('should write an outfit_item relationship using CRUD API', () async {
      final db = OpenClosetDatabase('/tmp/test_db');
      
      await db.createOutfitItem(
        outfitId: '123e4567-e89b-12d3-a456-426614174000',
        itemId: '123e4567-e89b-12d3-a456-426614174000',
      );
      
      final content = await db.outfitItems.readAsString();
      expect(content, contains('123e4567-e89b-12d3-a456-426614174000'));
    });

    test('should read an outfit_item by outfit ID using CRUD API', () async {
      final db = OpenClosetDatabase('/tmp/test_db');
      await db.createOutfitItem(
        outfitId: '123e4567-e89b-12d3-a456-426614174000',
        itemId: '123e4567-e89b-12d3-a456-426614174000',
      );
      
      final outfitItems = await db.readOutfitItemByOutfitId('123e4567-e89b-12d3-a456-426614174000');
      expect(outfitItems, isNotEmpty);
      expect(outfitItems.first['item_id'], equals('123e4567-e89b-12d3-a456-426614174000'));
    });
  });
}
