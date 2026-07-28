import 'package:flutter_test/flutter_test.dart';
import 'package:opencloset_database/database.dart';
import 'dart:io';

void main() {
  group('Database Integration Tests', () {
    test('should write a new category', () async {
      final db = OpenClosetDatabase('/tmp/test_db');
      
      final category = '123e4567-e89b-12d3-a456-426614174000,Denim Jacket,Casual denim jacket\n';
      await db.categories.writeAsString(category);
      
      final content = await db.categories.readAsString();
      expect(content, contains('Denim Jacket'));
    });

    test('should read a category by index', () async {
      final db = OpenClosetDatabase('/tmp/test_db');
      await db.categories.writeAsString('123e4567-e89b-12d3-a456-426614174000,Denim Jacket,Casual denim jacket\n');
      
      final content = await db.categories.readAsString();
      final lines = content.split('\n');
      expect(lines[0].split(',')[1], 'Denim Jacket');
    });

    test('should write a new item', () async {
      final db = OpenClosetDatabase('/tmp/test_db');
      
      final item = '123e4567-e89b-12d3-a456-426614174000,T-Shirt,Cotton t-shirt,1,abc123,2024-01-01T00:00:00Z,2024-01-01T00:00:00Z\n';
      await db.items.writeAsString(item);
      
      final content = await db.items.readAsString();
      expect(content, contains('T-Shirt'));
    });

    test('should read an item by index', () async {
      final db = OpenClosetDatabase('/tmp/test_db');
      await db.items.writeAsString('123e4567-e89b-12d3-a456-426614174000,T-Shirt,Cotton t-shirt,1,abc123,2024-01-01T00:00:00Z,2024-01-01T00:00:00Z\n');
      
      final content = await db.items.readAsString();
      final lines = content.split('\n');
      final fields = lines[0].split(',');
      expect(fields[1], 'T-Shirt');
    });

    test('should write a new outfit', () async {
      final db = OpenClosetDatabase('/tmp/test_db');
      
      final outfit = '123e4567-e89b-12d3-a456-426614174000,Summer Outfit,Beach ready outfit\n';
      await db.outfits.writeAsString(outfit);
      
      final content = await db.outfits.readAsString();
      expect(content, contains('Summer Outfit'));
    });

    test('should read an outfit by index', () async {
      final db = OpenClosetDatabase('/tmp/test_db');
      await db.outfits.writeAsString('123e4567-e89b-12d3-a456-426614174000,Summer Outfit,Beach ready outfit\n');
      
      final content = await db.outfits.readAsString();
      final lines = content.split('\n');
      final fields = lines[0].split(',');
      expect(fields[1], 'Summer Outfit');
    });

    test('should write an outfit_item relationship', () async {
      final db = OpenClosetDatabase('/tmp/test_db');
      
      final outfitItem = '123e4567-e89b-12d3-a456-426614174000,123e4567-e89b-12d3-a456-426614174000\n';
      await db.outfitItems.writeAsString(outfitItem);
      
      final content = await db.outfitItems.readAsString();
      expect(content, contains('123e4567-e89b-12d3-a456-426614174000'));
    });

    test('should read an outfit_item by index', () async {
      final db = OpenClosetDatabase('/tmp/test_db');
      await db.outfitItems.writeAsString('123e4567-e89b-12d3-a456-426614174000,123e4567-e89b-12d3-a456-426614174000\n');
      
      final content = await db.outfitItems.readAsString();
      final lines = content.split('\n');
      final fields = lines[0].split(',');
      expect(fields[1], '123e4567-e89b-12d3-a456-426614174000');
    });

    test('should work with different database paths', () async {
      final db1 = OpenClosetDatabase('/tmp/db1');
      final db2 = OpenClosetDatabase('/tmp/db2');
      
      expect(db1.categories.path, isNot(equals(db2.categories.path)));
    });
  });
}
