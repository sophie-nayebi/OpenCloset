import 'package:flutter_test/flutter_test.dart';
import 'package:opencloset_database/database.dart';
import 'dart:io';

void main() {
  test('should create database instance', () {
    expect(() => OpenClosetDatabase('/tmp'), returnsNormally);
  });

  test('should create CSV files on initialization', () async {
    final db = OpenClosetDatabase('/tmp/test_db');
    expect(await File('/tmp/test_db/categories.csv').exists(), isTrue);
    expect(await File('/tmp/test_db/items.csv').exists(), isTrue);
    expect(await File('/tmp/test_db/outfits.csv').exists(), isTrue);
    expect(await File('/tmp/test_db/outfit_items.csv').exists(), isTrue);
  });

  test('should read categories CSV', () async {
    final db = OpenClosetDatabase('/tmp/test_db');
    final content = await db.categories.readAsString();
    expect(content, isEmpty);
  });

  test('should read items CSV', () async {
    final db = OpenClosetDatabase('/tmp/test_db');
    final content = await db.items.readAsString();
    expect(content, isEmpty);
  });

  test('should read outfits CSV', () async {
    final db = OpenClosetDatabase('/tmp/test_db');
    final content = await db.outfits.readAsString();
    expect(content, isEmpty);
  });

  test('should read outfit_items CSV', () async {
    final db = OpenClosetDatabase('/tmp/test_db');
    final content = await db.outfitItems.readAsString();
    expect(content, isEmpty);
  });

  test('should create a category', () async {
    final db = OpenClosetDatabase('/tmp/test_db');
    await db.createCategory(
      id: 'cat1',
      name: 'T-Shirt',
      description: 'Cotton t-shirt',
    );
    final content = await db.readAllCategories();
    expect(content.length, greaterThan(0));
  });

  test('should read all categories', () async {
    final db = OpenClosetDatabase('/tmp/test_db');
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
    final db = OpenClosetDatabase('/tmp/test_db');
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
    final db = OpenClosetDatabase('/tmp/test_db');
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
    final db = OpenClosetDatabase('/tmp/test_db');
    await db.createCategory(
      id: 'cat1',
      name: 'T-Shirt',
      description: 'Cotton t-shirt',
    );
    await db.deleteCategory('cat1');
    final content = await db.readAllCategories();
    expect(content.length, 0);
  });

  test('should create an item', () async {
    final db = OpenClosetDatabase('/tmp/test_db');
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
    final db = OpenClosetDatabase('/tmp/test_db');
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
    final db = OpenClosetDatabase('/tmp/test_db');
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
    final db = OpenClosetDatabase('/tmp/test_db');
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
    final db = OpenClosetDatabase('/tmp/test_db');
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

  test('should create an outfit', () async {
    final db = OpenClosetDatabase('/tmp/test_db');
    await db.createOutfit(
      id: 'outfit1',
      name: 'Summer Outfit',
      description: 'Beach ready outfit',
    );
    final content = await db.readAllOutfits();
    expect(content.length, greaterThan(0));
  });

  test('should read all outfits', () async {
    final db = OpenClosetDatabase('/tmp/test_db');
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
    final db = OpenClosetDatabase('/tmp/test_db');
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
    final db = OpenClosetDatabase('/tmp/test_db');
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
    final db = OpenClosetDatabase('/tmp/test_db');
    await db.createOutfit(
      id: 'outfit1',
      name: 'Summer Outfit',
      description: 'Beach ready outfit',
    );
    await db.deleteOutfit('outfit1');
    final content = await db.readAllOutfits();
    expect(content.length, 0);
  });

  test('should create an outfit-item relationship', () async {
    final db = OpenClosetDatabase('/tmp/test_db');
    await db.createOutfitItem(
      outfitId: 'outfit1',
      itemId: 'item1',
    );
    final content = await db.readAllOutfitItems();
    expect(content.length, greaterThan(0));
  });

  test('should read outfit-item by outfit ID', () async {
    final db = OpenClosetDatabase('/tmp/test_db');
    await db.createOutfitItem(
      outfitId: 'outfit1',
      itemId: 'item1',
    );
    final outfitItem = await db.readOutfitItemByOutfitId('outfit1');
    expect(outfitItem, isNotNull);
    expect(outfitItem?['item_id'], 'item1');
  });

  test('should read all outfit items', () async {
    final db = OpenClosetDatabase('/tmp/test_db');
    await db.createOutfitItem(
      outfitId: 'outfit1',
      itemId: 'item1',
    );
    final content = await db.readAllOutfitItems();
    expect(content.length, greaterThan(0));
    expect(content[0]['outfit_id'], 'outfit1');
  });

  test('should read outfit-item by outfit ID', () async {
    final db = OpenClosetDatabase('/tmp/test_db');
    await db.createOutfitItem(
      outfitId: 'outfit1',
      itemId: 'item1',
    );
    final outfitItem = await db.readOutfitItemByOutfitId('outfit1');
    expect(outfitItem, isNotNull);
    expect(outfitItem?['item_id'], 'item1');
  });

  test('should delete an outfit-item relationship', () async {
    final db = OpenClosetDatabase('/tmp/test_db');
    await db.createOutfitItem(
      outfitId: 'outfit1',
      itemId: 'item1',
    );
    await db.deleteOutfitItem('outfit1');
    final content = await db.readAllOutfitItems();
    expect(content.length, 0);
  });
}
