import 'package:flutter_test/flutter_test.dart';
import 'package:opencloset_database/database.dart';
import 'dart:io';

/// Helper method to clean up all test directories
Future<void> _cleanupAllDirectories() async {
  // Get all directories starting with /tmp/test
  final patterns = [
    '/tmp/test_db',
    '/tmp/test_db2',
    '/tmp/csv_test',
    '/tmp/cascade_test',
    '/tmp/cascade_test101',
    '/tmp/cascade_test102',
    '/tmp/concurrent_test',
    '/tmp/concurrent_test101',
    '/tmp/concurrent_test102',
    '/tmp/concurrent_test201',
    '/tmp/concurrent_test202',
    '/tmp/concurrent_test301',
    '/tmp/concurrent_test302',
    '/tmp/category_test',
    '/tmp/category_test1',
    '/tmp/category_test2',
    '/tmp/category_test101',
    '/tmp/category_test102',
    '/tmp/category_test103',
    '/tmp/category_test104',
    '/tmp/category_test105',
    '/tmp/category_test106',
    '/tmp/category_test107',
    '/tmp/category_test108',
    '/tmp/category_test109',
    '/tmp/category_test110',
    '/tmp/category_test201',
    '/tmp/category_test202',
    '/tmp/category_test301',
    '/tmp/category_test302',
    '/tmp/items_test',
    '/tmp/items_test1',
    '/tmp/items_test2',
    '/tmp/items_test3',
    '/tmp/items_test101',
    '/tmp/items_test102',
    '/tmp/outfit_test1',
    '/tmp/outfit_test2',
    '/tmp/outfit_test3',
    '/tmp/outfit_test101',
    '/tmp/outfit_test102',
    '/tmp/outfititem_test1',
    '/tmp/outfititem_test2',
    '/tmp/outfititem_test3',
    '/tmp/outfititem_test101',
    '/tmp/outfititem_test102',
    '/tmp/csv_quoting_1',
    '/tmp/csv_quoting_2',
    '/tmp/csv_quoting_3',
    '/tmp/id_validation_empty',
    '/tmp/id_validation_simple',
    '/tmp/id_validation_uuid',
    '/tmp/id_validation_dup',
  ];

  for (final pattern in patterns) {
    try {
      await Directory(pattern).delete(recursive: true);
    } catch (e) {
      // Ignore errors - directory might not exist
    }
  }
}

void main() {
  setUp(() async {
    // Each test creates its own database instance with unique directory
    // The setUpAll above handles cleanup of test directories
  });

  setUpAll(() async {
    // Clean up any existing test directories
    await _cleanupAllDirectories();
  });

 

  test('should create database instance', () {
    expect(() => OpenClosetDatabase('/tmp'), returnsNormally);
  });

  test('should create CSV files on initialization', () async {
    final dbPath = '/tmp/test_db';
    OpenClosetDatabase(dbPath); // Create database to initialize files
    expect(await File('$dbPath/categories.csv').exists(), isTrue);
    expect(await File('$dbPath/items.csv').exists(), isTrue);
    expect(await File('$dbPath/outfits.csv').exists(), isTrue);
    expect(await File('$dbPath/outfit_items.csv').exists(), isTrue);
  });

  test('should initialize CSV files with headers', () async {
    final dbPath = '/tmp/test_db2';
    final db = OpenClosetDatabase(dbPath);
    final content = await db.categories.readAsString();
    expect(content, contains('id,name,description,created_at,updated_at'));
  });

  group('Categories', () {
    test('should create a category', () async {
      final db = OpenClosetDatabase('/tmp/category_test1');
      await db.createCategory(
        id: 'cat1',
        name: 'T-Shirt',
        description: 'Cotton t-shirt',
      );
      final content = await db.readAllCategories();
      expect(content.length, greaterThan(0));
    });

    test('should read all categories', () async {
      final db = OpenClosetDatabase('/tmp/category_test2');
      await db.createCategory(
        id: 'cat1',
        name: 'T-Shirt',
        description: 'Cotton t-shirt',
      );
      final content = await db.readAllCategories();
      expect(content.length, greaterThan(0));
      expect(content[0]['name'], 'T-Shirt');
    });

    test('should read category by ID', () async {
      final db = OpenClosetDatabase('/tmp/category_test3');
      await db.createCategory(
        id: 'cat1',
        name: 'T-Shirt',
        description: 'Cotton t-shirt',
      );
      final category = await db.readCategoryById('cat1');
      expect(category, isNotNull);
      expect(category?['name'], 'T-Shirt');
    });

    test('should update a category', () async {
      final db = OpenClosetDatabase('/tmp/category_test101');
      await db.createCategory(
        id: 'cat1',
        name: 'T-Shirt',
        description: 'Cotton t-shirt',
      );
      await db.updateCategory(
        id: 'cat1',
        name: 'Updated T-Shirt',
        description: 'Updated description',
      );
      final category = await db.readCategoryById('cat1');
      expect(category?['name'], 'Updated T-Shirt');
    });

    test('should delete a category', () async {
      final db = OpenClosetDatabase('/tmp/category_test102');
      await db.createCategory(
        id: 'cat1',
        name: 'T-Shirt',
        description: 'Cotton t-shirt',
      );
      await db.deleteCategory('cat1');
      final content = await db.readAllCategories();
      expect(content.length, 0);
    });
  });

  group('Items', () {
    test('should create an item', () async {
      final db = OpenClosetDatabase('/tmp/item_test1');
      await db.createItem(
        id: 'item1',
        name: 'Denim Jacket',
        description: 'Blue denim jacket',
        categoryId: 'cat1',
        imageUuid: null,
      );
      final content = await db.readAllItems();
      expect(content.length, greaterThan(0));
    });

    test('should read all items', () async {
      final db = OpenClosetDatabase('/tmp/item_test2');
      await db.createItem(
        id: 'item1',
        name: 'Denim Jacket',
        description: 'Blue denim jacket',
        categoryId: 'cat1',
        imageUuid: null,
      );
      final content = await db.readAllItems();
      expect(content.length, greaterThan(0));
      expect(content[0]['name'], 'Denim Jacket');
    });

    test('should read item by ID', () async {
      final db = OpenClosetDatabase('/tmp/item_test3');
      await db.createItem(
        id: 'item1',
        name: 'Denim Jacket',
        description: 'Blue denim jacket',
        categoryId: 'cat1',
        imageUuid: null,
      );
      final item = await db.readItemById('item1');
      expect(item, isNotNull);
      expect(item?['name'], 'Denim Jacket');
    });

    test('should update an item', () async {
      final db = OpenClosetDatabase('/tmp/item_test101');
      await db.createItem(
        id: 'item1',
        name: 'Denim Jacket',
        description: 'Blue denim jacket',
        categoryId: 'cat1',
        imageUuid: null,
      );
      await db.updateItem(
        id: 'item1',
        name: 'Updated Denim Jacket',
        description: 'Updated description',
        categoryId: 'cat1',
        imageUuid: null,
      );
      final item = await db.readItemById('item1');
      expect(item?['name'], 'Updated Denim Jacket');
    });

    test('should delete an item', () async {
      final db = OpenClosetDatabase('/tmp/item_test102');
      await db.createItem(
        id: 'item1',
        name: 'Denim Jacket',
        description: 'Blue denim jacket',
        categoryId: 'cat1',
        imageUuid: null,
      );
      await db.deleteItem('item1');
      final content = await db.readAllItems();
      expect(content.length, 0);
    });
  });

  group('Outfits', () {
    test('should create an outfit', () async {
      final db = OpenClosetDatabase('/tmp/outfit_test1');
      await db.createOutfit(
        id: 'outfit1',
        name: 'Summer Outfit',
        description: 'Beach ready outfit',
      );
      final content = await db.readAllOutfits();
      expect(content.length, greaterThan(0));
    });

    test('should read all outfits', () async {
      final db = OpenClosetDatabase('/tmp/outfit_test2');
      await db.createOutfit(
        id: 'outfit1',
        name: 'Summer Outfit',
        description: 'Beach ready outfit',
      );
      final content = await db.readAllOutfits();
      expect(content.length, greaterThan(0));
      expect(content[0]['name'], 'Summer Outfit');
    });

    test('should read outfit by ID', () async {
      final db = OpenClosetDatabase('/tmp/outfit_test3');
      await db.createOutfit(
        id: 'outfit1',
        name: 'Summer Outfit',
        description: 'Beach ready outfit',
      );
      final outfit = await db.readOutfitById('outfit1');
      expect(outfit, isNotNull);
      expect(outfit?['name'], 'Summer Outfit');
    });

    test('should update an outfit', () async {
      final db = OpenClosetDatabase('/tmp/outfit_test101');
      await db.createOutfit(
        id: 'outfit1',
        name: 'Summer Outfit',
        description: 'Beach ready outfit',
      );
      await db.updateOutfit(
        id: 'outfit1',
        name: 'Updated Summer Outfit',
        description: 'Updated description',
      );
      final outfit = await db.readOutfitById('outfit1');
      expect(outfit?['name'], 'Updated Summer Outfit');
    });

    test('should delete an outfit', () async {
      final db = OpenClosetDatabase('/tmp/outfit_test102');
      await db.createOutfit(
        id: 'outfit1',
        name: 'Summer Outfit',
        description: 'Beach ready outfit',
      );
      await db.deleteOutfit('outfit1');
      final content = await db.readAllOutfits();
      expect(content.length, 0);
    });
  });

  group('Outfit Items', () {
    test('should create an outfit-item relationship', () async {
      final db = OpenClosetDatabase('/tmp/outfititem_test1');
      await db.createOutfitItem(
        outfitId: 'outfit1',
        itemId: 'item1',
      );
      final content = await db.readAllOutfitItems();
      expect(content.length, greaterThan(0));
    });

    test('should read outfit-item by outfit ID', () async {
      final db = OpenClosetDatabase('/tmp/outfititem_test2');
      await db.createOutfitItem(
        outfitId: 'outfit1',
        itemId: 'item1',
      );
      final outfitItems = await db.readOutfitItemByOutfitId('outfit1');
      expect(outfitItems, isNotEmpty);
      expect(outfitItems[0]['item_id'], 'item1');
    });

    test('should read all outfit items', () async {
      final db = OpenClosetDatabase('/tmp/outfititem_test3');
      await db.createOutfitItem(
        outfitId: 'outfit1',
        itemId: 'item1',
      );
      final content = await db.readAllOutfitItems();
      expect(content.length, greaterThan(0));
      expect(content[0]['outfit_id'], 'outfit1');
    });

    test('should read outfit-item by item ID (multiple outfits)', () async {
      final db = OpenClosetDatabase('/tmp/outfititem_test101');
      await db.createOutfitItem(
        outfitId: 'outfit1',
        itemId: 'item1',
      );
      await db.createOutfitItem(
        outfitId: 'outfit2',
        itemId: 'item1',
      );
      final outfitItems = await db.readOutfitItemByItemId('item1');
      expect(outfitItems, isNotEmpty);
      expect(outfitItems.length, 2);
      expect(outfitItems[0]['outfit_id'], 'outfit1');
      expect(outfitItems[1]['outfit_id'], 'outfit2');
    });

    test('should delete an outfit-item relationship', () async {
      final db = OpenClosetDatabase('/tmp/outfititem_test102');
      await db.createOutfitItem(
        outfitId: 'outfit1',
        itemId: 'item1',
      );
      await db.deleteOutfitItem('outfit1');
      final content = await db.readAllOutfitItems();
      expect(content.length, 0);
    });
  });

  group('CSV quoting and escaping', () {
    test('should handle field with comma in value', () async {
      try {
        await Directory('/tmp/csv_quoting_1').delete(recursive: true);
      } catch (_) {}
      final dbPath = '/tmp/csv_quoting_1';
      final db = OpenClosetDatabase(dbPath);
      await db.createCategory(
        id: 'cat1',
        name: 'Red, blue',
        description: 'Multi-colored item',
      );
      final categories = await db.readAllCategories();
      expect(categories.length, 1);
      expect(categories[0]['name'], 'Red, blue');
    });

    test('should handle field with double quotes', () async {
      try {
        await Directory('/tmp/csv_quoting_2').delete(recursive: true);
      } catch (_) {}
      final dbPath = '/tmp/csv_quoting_2';
      final db = OpenClosetDatabase(dbPath);
      await db.createCategory(
        id: 'cat1',
        name: 'Quote test "item"',
        description: 'Test description',
      );
      final categories = await db.readAllCategories();
      expect(categories.length, 1);
      expect(categories[0]['name'], 'Quote test "item"');
    });

    test('should handle field with both comma and quotes', () async {
      try {
        await Directory('/tmp/csv_quoting_3').delete(recursive: true);
      } catch (_) {}
      final dbPath = '/tmp/csv_quoting_3';
      final db = OpenClosetDatabase(dbPath);
      await db.createCategory(
        id: 'cat1',
        name: 'Red, "blue" shirt',
        description: 'Test, test',
      );
      final categories = await db.readAllCategories();
      expect(categories.length, 1);
      expect(categories[0]['name'], 'Red, "blue" shirt');
      expect(categories[0]['description'], 'Test, test');
    });
  });

  group('Cascade deletes', () {
    test('should cascade delete outfit_items when outfit is deleted', () async {
      try {
        await Directory('/tmp/cascade_items_1').delete(recursive: true);
      } catch (_) {}
      final dbPath = '/tmp/cascade_items_1';
      final db = OpenClosetDatabase(dbPath);
      await db.createOutfit(
        id: 'cascade_outfit_1',
        name: 'Outfit 1',
        description: 'First outfit',
      );
      await db.createOutfitItem(
        outfitId: 'cascade_outfit_1',
        itemId: 'cascade_item_1',
      );
      await db.createOutfitItem(
        outfitId: 'cascade_outfit_1',
        itemId: 'cascade_item_2',
      );
      
      final outfitItemsBefore = await db.readAllOutfitItems();
      expect(outfitItemsBefore.length, 2);
      
      await db.deleteOutfit('cascade_outfit_1');
      
      final outfitItemsAfter = await db.readAllOutfitItems();
      expect(outfitItemsAfter.length, 0);
    });

    test('should not orphan outfit_items after outfit deletion', () async {
      try {
        await Directory('/tmp/cascade_items_2').delete(recursive: true);
      } catch (_) {}
      final dbPath = '/tmp/cascade_items_2';
      final db = OpenClosetDatabase(dbPath);
      await db.createOutfit(
        id: 'cascade_outfit_2',
        name: 'Outfit 1',
        description: 'First outfit',
      );
      await db.createOutfitItem(
        outfitId: 'cascade_outfit_2',
        itemId: 'cascade_item_3',
      );
      
      await db.deleteOutfit('cascade_outfit_2');
      
      // The outfit should be deleted
      final outfits = await db.readAllOutfits();
      expect(outfits.length, 0);
      
      // No orphaned entries should exist
      final outfitItems = await db.readAllOutfitItems();
      expect(outfitItems.length, 0);
    });
  });

  group('ID validation', () {
    test('should reject empty ID', () async {
      try {
        await Directory('/tmp/id_validation_empty').delete(recursive: true);
      } catch (_) {}
      final db = OpenClosetDatabase('/tmp/id_validation_empty');
      expect(() async => await db.createCategory(
        id: '',
        name: 'T-Shirt',
        description: 'Cotton t-shirt',
      ), throwsArgumentError);
    });
    
    test('should accept simple string IDs', () async {
      try {
        await Directory('/tmp/id_validation_simple').delete(recursive: true);
      } catch (_) {}
      final db = OpenClosetDatabase('/tmp/id_validation_simple');
      await db.createCategory(
        id: 'cat1',
        name: 'T-Shirt',
        description: 'Cotton t-shirt',
      );
      final categories = await db.readAllCategories();
      expect(categories.length, 1);
    });
    
    test('should accept UUID format IDs', () async {
      try {
        await Directory('/tmp/id_validation_uuid').delete(recursive: true);
      } catch (_) {}
      final db = OpenClosetDatabase('/tmp/id_validation_uuid');
      await db.createCategory(
        id: '550e8400-e29b-41d4-a716-446655440000',
        name: 'T-Shirt',
        description: 'Cotton t-shirt',
      );
      final categories = await db.readAllCategories();
      expect(categories.length, 1);
    });
    
    test('should reject duplicate ID', () async {
      try {
        await Directory('/tmp/id_validation_dup').delete(recursive: true);
      } catch (_) {}
      final db = OpenClosetDatabase('/tmp/id_validation_dup');
      await db.createCategory(
        id: 'cat1',
        name: 'T-Shirt',
        description: 'Cotton t-shirt',
      );
      
      expect(() async => await db.createCategory(
        id: 'cat1',
        name: 'T-Shirt 2',
        description: 'Cotton t-shirt 2',
      ), throwsA(isA<DuplicateIdError>()));
    });
  });
}
