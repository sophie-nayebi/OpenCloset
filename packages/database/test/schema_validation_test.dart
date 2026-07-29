import 'package:flutter_test/flutter_test.dart';
import 'package:opencloset_database/database.dart';
import 'dart:io';

void main() {
  test('should have schema.csv file', () async {
    expect(await File('packages/database/lib/schema.csv').exists(), isTrue);
  });

  test('should contain categories table definition', () async {
    final content = await File('packages/database/lib/schema.csv').readAsString();
    expect(content, contains('# categories'));
  });

  test('should contain items table definition', () async {
    final content = await File('packages/database/lib/schema.csv').readAsString();
    expect(content, contains('# items'));
  });

  test('should contain outfits table definition', () async {
    final content = await File('packages/database/lib/schema.csv').readAsString();
    expect(content, contains('# outfits'));
  });

  test('should contain outfit_items table definition', () async {
    final content = await File('packages/database/lib/schema.csv').readAsString();
    expect(content, contains('# outfit_items'));
  });

  test('should have column definitions', () async {
    final content = await File('packages/database/lib/schema.csv').readAsString();
    expect(content, contains('id'));
    expect(content, contains('name'));
    expect(content, contains('description'));
  });

  test('should have header comment explaining schema', () async {
    final content = await File('packages/database/lib/schema.csv').readAsString();
    expect(content, contains('# OpenCloset Database Schema'));
  });

  group('Schema validation', () {
    test('should validate categories CSV schema', () async {
      final dbPath = '/tmp/schema_test1';
      final db = OpenClosetDatabase(dbPath);
      
      // Check categories file has correct header
      final categoriesContent = await db.categories.readAsString();
      expect(categoriesContent, contains('id,name,description,created_at,updated_at'));
    });

    test('should validate items CSV schema', () async {
      final dbPath = '/tmp/schema_test2';
      final db = OpenClosetDatabase(dbPath);
      
      // Check items file has correct header
      final itemsContent = await db.items.readAsString();
      expect(itemsContent, contains('id,name,description,category_id,image_uuid,created_at,updated_at'));
    });

    test('should validate outfits CSV schema', () async {
      final dbPath = '/tmp/schema_test3';
      final db = OpenClosetDatabase(dbPath);
      
      // Check outfits file has correct header
      final outfitsContent = await db.outfits.readAsString();
      expect(outfitsContent, contains('id,name,description,created_at,updated_at'));
    });

    test('should validate outfit_items CSV schema', () async {
      final dbPath = '/tmp/schema_test4';
      final db = OpenClosetDatabase(dbPath);
      
      // Check outfit_items file has correct header
      final outfitItemsContent = await db.outfitItems.readAsString();
      expect(outfitItemsContent, contains('outfit_id,item_id'));
    });
  });
}
