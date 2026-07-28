import 'dart:io';
import 'package:csv/csv.dart';

/// Mobile implementation of OpenClosetDatabase (iOS, Android)
class OpenClosetDatabaseMobile extends OpenClosetDatabase {
  late final File categoriesFile;
  late final File itemsFile;
  late final File outfitsFile;
  late final File outfitItemsFile;

  @override
  OpenClosetDatabaseMobile() {
    _initializeFiles();
  }

  void _initializeFiles() {
    categoriesFile = File('/mobile/app/documents/OpenCloset/data/categories.csv');
    itemsFile = File('/mobile/app/documents/OpenCloset/data/items.csv');
    outfitsFile = File('/mobile/app/documents/OpenCloset/data/outfits.csv');
    outfitItemsFile = File('/mobile/app/documents/OpenCloset/data/outfit_items.csv');
  }

  @override
  static Future<void> create({
    required String id,
    required String name,
    required String description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) async {
    final csvString = const CsvToListConverter().convert([
      [id, name, description, createdAt?.toIso8601String() ?? '', updatedAt?.toIso8601String() ?? '']
    ]);
    await categoriesFile.writeAsString(csvString, mode: FileMode.append);
  }

  @override
  static Future<List<Map<String, dynamic>>> readAll() async {
    final content = await categoriesFile.readAsString();
    final rows = const CsvToListConverter().convert(content);
    return rows.map((row) => {
      'id': row[0] as String,
      'name': row[1] as String,
      'description': row[2] as String,
      'created_at': row[3] as String,
      'updated_at': row[4] as String,
    }).toList();
  }

  @override
  static Future<Map<String, dynamic>?> readById(String id) async {
    final content = await categoriesFile.readAsString();
    final rows = const CsvToListConverter().convert(content);
    final row = rows.firstWhere(
      (r) => r[0] == id,
      orElse: () => [],
    );
    if (row.length > 0) {
      return {
        'id': row[0] as String,
        'name': row[1] as String,
        'description': row[2] as String,
        'created_at': row[3] as String,
        'updated_at': row[4] as String,
      };
    }
    return null;
  }

  @override
  static Future<void> update({
    required String id,
    required String name,
    required String description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) async {
    final content = await categoriesFile.readAsString();
    final rows = const CsvToListConverter().convert(content);
    final index = rows.indexWhere((r) => r[0] == id);
    if (index != -1) {
      rows[index] = [id, name, description, createdAt?.toIso8601String() ?? '', updatedAt?.toIso8601String() ?? ''];
      await categoriesFile.writeAsString(
        const CsvToListConverter().convert(rows),
        mode: FileMode.write,
      );
    }
  }

  @override
  static Future<void> delete(String id) async {
    final content = await categoriesFile.readAsString();
    final rows = const CsvToListConverter().convert(content);
    final filtered = rows.where((r) => r[0] != id).toList();
    await categoriesFile.writeAsString(
      const CsvToListConverter().convert(filtered),
      mode: FileMode.write,
    );
  }
}
