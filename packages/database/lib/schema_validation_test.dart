import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

void main() {
  test('should have schema.csv file', () async {
    expect(await File('lib/schema.csv').exists(), isTrue);
  });

  test('should contain categories table definition', () async {
    final content = await File('lib/schema.csv').readAsString();
    expect(content, contains('# categories'));
  });

  test('should contain items table definition', () async {
    final content = await File('lib/schema.csv').readAsString();
    expect(content, contains('# items'));
  });

  test('should contain outfits table definition', () async {
    final content = await File('lib/schema.csv').readAsString();
    expect(content, contains('# outfits'));
  });

  test('should contain outfit_items table definition', () async {
    final content = await File('lib/schema.csv').readAsString();
    expect(content, contains('# outfit_items'));
  });

  test('should have column definitions', () async {
    final content = await File('lib/schema.csv').readAsString();
    expect(content, contains('id'));
    expect(content, contains('name'));
    expect(content, contains('description'));
  });

  test('should have header comment explaining schema', () async {
    final content = await File('lib/schema.csv').readAsString();
    expect(content, contains('# OpenCloset Database Schema'));
  });
}
