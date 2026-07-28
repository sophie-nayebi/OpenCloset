import 'dart:io';
import 'package:csv/csv.dart';

/// OpenClosetDatabase - CSV-based data persistence layer
class OpenClosetDatabase {
  final String basePath;
  late final File categoriesFile;
  late final File itemsFile;
  late final File outfitsFile;
  late final File outfitItemsFile;

  OpenClosetDatabase(this.basePath) {
    _ensureDirectoryExists();
    _createFiles();
  }

  File get categories => categoriesFile;
  File get items => itemsFile;
  File get outfits => outfitsFile;
  File get outfitItems => outfitItemsFile;

  void _ensureDirectoryExists() {
    Directory(basePath).createSync(recursive: true);
  }

  void _createFiles() {
    categoriesFile = File('$basePath/categories.csv');
    itemsFile = File('$basePath/items.csv');
    outfitsFile = File('$basePath/outfits.csv');
    outfitItemsFile = File('$basePath/outfit_items.csv');
    _initializeCSVs();
  }

  void _initializeCSVs() {
    categoriesFile.writeAsStringSync('');
    itemsFile.writeAsStringSync('');
    outfitsFile.writeAsStringSync('');
    outfitItemsFile.writeAsStringSync('');
  }

  /// === Categories CRUD ===
  
  Future<void> createCategory({
    required String id,
    required String name,
    required String description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) async {
    final csvString = [
      id,
      name,
      description,
      createdAt?.toIso8601String() ?? '',
      updatedAt?.toIso8601String() ?? ''
    ].join(',');
    await categoriesFile.writeAsString(csvString, mode: FileMode.append);
    await categoriesFile.writeAsString('\n', mode: FileMode.append);
  }

  Future<List<Map<String, dynamic>>> readAllCategories() async {
    final content = await categoriesFile.readAsString();
    final lines = content.trim().split('\n').where((line) => line.isNotEmpty);
    return lines.map((line) {
      final fields = line.split(',');
      return {
        'id': fields[0] as String,
        'name': fields[1] as String,
        'description': fields[2] as String,
        'created_at': fields[3] as String,
        'updated_at': fields[4] as String,
      };
    }).toList();
  }

  Future<Map<String, dynamic>?> readCategoryById(String id) async {
    final content = await categoriesFile.readAsString();
    final lines = content.trim().split('\n');
    final index = lines.indexWhere((line) {
      final fields = line.split(',');
      return fields[0] == id;
    });
    if (index != -1) {
      final fields = lines[index].split(',');
      return {
        'id': fields[0] as String,
        'name': fields[1] as String,
        'description': fields[2] as String,
        'created_at': fields[3] as String,
        'updated_at': fields[4] as String,
      };
    }
    return null;
  }

  Future<void> updateCategory({
    required String id,
    required String name,
    required String description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) async {
    final content = await categoriesFile.readAsString();
    final lines = content.trim().split('\n');
    final index = lines.indexWhere((line) {
      final fields = line.split(',');
      return fields[0] == id;
    });
    if (index != -1) {
      lines[index] = '$id,$name,$description,'
          '${createdAt?.toIso8601String() ?? ''},'
          '${updatedAt?.toIso8601String() ?? ''}';
      await categoriesFile.writeAsString(lines.join('\n'), mode: FileMode.write);
    }
  }

  Future<void> deleteCategory(String id) async {
    final content = await categoriesFile.readAsString();
    final lines = content.trim().split('\n');
    final filtered = lines.where((line) {
      final fields = line.split(',');
      return fields[0] != id;
    }).toList();
    await categoriesFile.writeAsString(filtered.join('\n'), mode: FileMode.write);
  }

  /// === Items CRUD ===
  
  Future<void> createItem({
    required String id,
    required String name,
    required String description,
    required String? categoryId,
    required String? imageUuid,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) async {
    final csvString = [
      id,
      name,
      description,
      categoryId ?? '',
      imageUuid ?? '',
      createdAt?.toIso8601String() ?? '',
      updatedAt?.toIso8601String() ?? ''
    ].join(',');
    await itemsFile.writeAsString(csvString, mode: FileMode.append);
    await itemsFile.writeAsString('\n', mode: FileMode.append);
  }

  Future<List<Map<String, dynamic>>> readAllItems() async {
    final content = await itemsFile.readAsString();
    final lines = content.trim().split('\n').where((line) => line.isNotEmpty);
    return lines.map((line) {
      final fields = line.split(',');
      return {
        'id': fields[0] as String,
        'name': fields[1] as String,
        'description': fields[2] as String,
        'category_id': fields[3] as String,
        'image_uuid': fields[4] as String,
        'created_at': fields[5] as String,
        'updated_at': fields[6] as String,
      };
    }).toList();
  }

  Future<Map<String, dynamic>?> readItemById(String id) async {
    final content = await itemsFile.readAsString();
    final lines = content.trim().split('\n');
    final index = lines.indexWhere((line) {
      final fields = line.split(',');
      return fields[0] == id;
    });
    if (index != -1) {
      final fields = lines[index].split(',');
      return {
        'id': fields[0] as String,
        'name': fields[1] as String,
        'description': fields[2] as String,
        'category_id': fields[3] as String,
        'image_uuid': fields[4] as String,
        'created_at': fields[5] as String,
        'updated_at': fields[6] as String,
      };
    }
    return null;
  }

  Future<void> updateItem({
    required String id,
    required String name,
    required String description,
    required String? categoryId,
    required String? imageUuid,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) async {
    final content = await itemsFile.readAsString();
    final lines = content.trim().split('\n');
    final index = lines.indexWhere((line) {
      final fields = line.split(',');
      return fields[0] == id;
    });
    if (index != -1) {
      lines[index] = '$id,$name,$description,'
          '${categoryId ?? ''},'
          '${imageUuid ?? ''},'
          '${createdAt?.toIso8601String() ?? ''},'
          '${updatedAt?.toIso8601String() ?? ''}';
      await itemsFile.writeAsString(lines.join('\n'), mode: FileMode.write);
    }
  }

  Future<void> deleteItem(String id) async {
    final content = await itemsFile.readAsString();
    final lines = content.trim().split('\n');
    final filtered = lines.where((line) {
      final fields = line.split(',');
      return fields[0] != id;
    }).toList();
    await itemsFile.writeAsString(filtered.join('\n'), mode: FileMode.write);
  }

  /// === Outfits CRUD ===
  
  Future<void> createOutfit({
    required String id,
    required String name,
    required String description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) async {
    final csvString = [
      id,
      name,
      description,
      createdAt?.toIso8601String() ?? '',
      updatedAt?.toIso8601String() ?? ''
    ].join(',');
    await outfitsFile.writeAsString(csvString, mode: FileMode.append);
    await outfitsFile.writeAsString('\n', mode: FileMode.append);
  }

  Future<List<Map<String, dynamic>>> readAllOutfits() async {
    final content = await outfitsFile.readAsString();
    final lines = content.trim().split('\n').where((line) => line.isNotEmpty);
    return lines.map((line) {
      final fields = line.split(',');
      return {
        'id': fields[0] as String,
        'name': fields[1] as String,
        'description': fields[2] as String,
        'created_at': fields[3] as String,
        'updated_at': fields[4] as String,
      };
    }).toList();
  }

  Future<Map<String, dynamic>?> readOutfitById(String id) async {
    final content = await outfitsFile.readAsString();
    final lines = content.trim().split('\n');
    final index = lines.indexWhere((line) {
      final fields = line.split(',');
      return fields[0] == id;
    });
    if (index != -1) {
      final fields = lines[index].split(',');
      return {
        'id': fields[0] as String,
        'name': fields[1] as String,
        'description': fields[2] as String,
        'created_at': fields[3] as String,
        'updated_at': fields[4] as String,
      };
    }
    return null;
  }

  Future<void> updateOutfit({
    required String id,
    required String name,
    required String description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) async {
    final content = await outfitsFile.readAsString();
    final lines = content.trim().split('\n');
    final index = lines.indexWhere((line) {
      final fields = line.split(',');
      return fields[0] == id;
    });
    if (index != -1) {
      lines[index] = '$id,$name,$description,'
          '${createdAt?.toIso8601String() ?? ''},'
          '${updatedAt?.toIso8601String() ?? ''}';
      await outfitsFile.writeAsString(lines.join('\n'), mode: FileMode.write);
    }
  }

  Future<void> deleteOutfit(String id) async {
    final content = await outfitsFile.readAsString();
    final lines = content.trim().split('\n');
    final filtered = lines.where((line) {
      final fields = line.split(',');
      return fields[0] != id;
    }).toList();
    await outfitsFile.writeAsString(filtered.join('\n'), mode: FileMode.write);
  }

  /// === Outfit Items CRUD (Junction Table) ===
  
  Future<void> createOutfitItem({
    required String outfitId,
    required String itemId,
  }) async {
    final csvString = [outfitId, itemId].join(',');
    await outfitItemsFile.writeAsString(csvString, mode: FileMode.append);
    await outfitItemsFile.writeAsString('\n', mode: FileMode.append);
  }

  Future<List<Map<String, dynamic>>> readAllOutfitItems() async {
    final content = await outfitItemsFile.readAsString();
    final lines = content.trim().split('\n').where((line) => line.isNotEmpty);
    return lines.map((line) {
      final fields = line.split(',');
      return {
        'outfit_id': fields[0] as String,
        'item_id': fields[1] as String,
      };
    }).toList();
  }

  Future<Map<String, dynamic>?> readOutfitItemByOutfitId(String outfitId) async {
    final content = await outfitItemsFile.readAsString();
    final lines = content.trim().split('\n');
    final index = lines.indexWhere((line) {
      final fields = line.split(',');
      return fields[0] == outfitId;
    });
    if (index != -1) {
      final fields = lines[index].split(',');
      return {
        'outfit_id': fields[0] as String,
        'item_id': fields[1] as String,
      };
    }
    return null;
  }

  Future<Map<String, dynamic>?> readOutfitItemByItemId(String itemId) async {
    final content = await outfitItemsFile.readAsString();
    final lines = content.trim().split('\n');
    final index = lines.indexWhere((line) {
      final fields = line.split(',');
      return fields[1] == itemId;
    });
    if (index != -1) {
      final fields = lines[index].split(',');
      return {
        'outfit_id': fields[0] as String,
        'item_id': fields[1] as String,
      };
    }
    return null;
  }

  Future<void> deleteOutfitItem(String outfitId) async {
    final content = await outfitItemsFile.readAsString();
    final lines = content.trim().split('\n');
    final filtered = lines.where((line) {
      final fields = line.split(',');
      return fields[0] != outfitId;
    }).toList();
    await outfitItemsFile.writeAsString(filtered.join('\n'), mode: FileMode.write);
  }

  /// === Utility Methods ===
  
  void save() {
    // CSV files are automatically persisted on disk
  }

  void close() {
    // No cleanup needed for file-based storage
  }
}
