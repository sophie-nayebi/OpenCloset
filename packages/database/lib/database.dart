import 'dart:io';

/// OpenClosetDatabase - CSV-based data persistence layer
/// Provides CRUD operations for items, categories, and outfits using CSV files
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
    // Write headers to each CSV file
    categoriesFile.writeAsStringSync('id,name,description,created_at,updated_at\n');
    itemsFile.writeAsStringSync('id,name,description,category_id,image_uuid,created_at,updated_at\n');
    outfitsFile.writeAsStringSync('id,name,description,created_at,updated_at\n');
    outfitItemsFile.writeAsStringSync('outfit_id,item_id\n');
  }

  /// === Categories CRUD ===

  Future<void> createCategory({
    required String id,
    required String name,
    required String description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) async {
    final line = '$id,$name,$description,'
        '${createdAt?.toIso8601String() ?? ''},'
        '${updatedAt?.toIso8601String() ?? ''}\n';
    await categoriesFile.writeAsString(line, mode: FileMode.append);
  }

  Future<List<Map<String, dynamic>>> readAllCategories() async {
    final content = await categoriesFile.readAsString();
    final lines = content.trim().split('\n');
    // Skip header row (first line)
    final dataLines = lines.skip(1).where((line) => line.isNotEmpty).toList();
    return dataLines.map((line) {
      final fields = _parseCSVLine(line);
      return {
        'id': fields[0],
        'name': fields[1],
        'description': fields[2],
        'created_at': fields[3],
        'updated_at': fields[4],
      };
    }).toList();
  }

  Future<Map<String, dynamic>?> readCategoryById(String id) async {
    final content = await categoriesFile.readAsString();
    final lines = content.trim().split('\n');
    // Skip header row (first line)
    final dataLines = lines.skip(1);
    for (final line in dataLines) {
      final fields = _parseCSVLine(line);
      if (fields[0] == id) {
        return {
          'id': fields[0],
          'name': fields[1],
          'description': fields[2],
          'created_at': fields[3],
          'updated_at': fields[4],
        };
      }
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
    bool updated = false;
    
    for (int i = 1; i < lines.length; i++) { // Skip header row (start from index 1)
      final line = lines[i];
      final fields = _parseCSVLine(line);
      if (fields[0] == id) {
        lines[i] = '$id,$name,$description,'
            '${createdAt?.toIso8601String() ?? ''},'
            '${updatedAt?.toIso8601String() ?? ''}\n';
        updated = true;
        break;
      }
    }
    
    if (updated) {
      // Remove trailing newline from the last line and write back
      final header = 'id,name,description,created_at,updated_at\n';
      final updatedLines = lines.join('\n').trim();
      await categoriesFile.writeAsString('$header$updatedLines', mode: FileMode.write);
    }
  }

  Future<void> deleteCategory(String id) async {
    final content = await categoriesFile.readAsString();
    final lines = content.trim().split('\n');
    // Skip header row (first line)
    final header = 'id,name,description,created_at,updated_at\n';
    final filtered = lines.skip(1).where((line) {
      final fields = _parseCSVLine(line);
      return fields[0] != id;
    }).toList();
    await categoriesFile.writeAsString('$header${filtered.join('')}', mode: FileMode.write);
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
    final line = '$id,$name,$description,'
        '${categoryId ?? ''},'
        '${imageUuid ?? ''},'
        '${createdAt?.toIso8601String() ?? ''},'
        '${updatedAt?.toIso8601String() ?? ''}\n';
    await itemsFile.writeAsString(line, mode: FileMode.append);
  }

  Future<List<Map<String, dynamic>>> readAllItems() async {
    final content = await itemsFile.readAsString();
    final lines = content.trim().split('\n');
    // Skip header row (first line)
    final dataLines = lines.skip(1).where((line) => line.isNotEmpty).toList();
    return dataLines.map((line) {
      final fields = _parseCSVLine(line);
      return {
        'id': fields[0],
        'name': fields[1],
        'description': fields[2],
        'category_id': fields[3],
        'image_uuid': fields[4],
        'created_at': fields[5],
        'updated_at': fields[6],
      };
    }).toList();
  }

  Future<Map<String, dynamic>?> readItemById(String id) async {
    final content = await itemsFile.readAsString();
    final lines = content.trim().split('\n');
    // Skip header row (first line)
    final dataLines = lines.skip(1);
    for (final line in dataLines) {
      final fields = _parseCSVLine(line);
      if (fields[0] == id) {
        return {
          'id': fields[0],
          'name': fields[1],
          'description': fields[2],
          'category_id': fields[3],
          'image_uuid': fields[4],
          'created_at': fields[5],
          'updated_at': fields[6],
        };
      }
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
    bool updated = false;
    
    for (int i = 1; i < lines.length; i++) { // Skip header row (start from index 1)
      final line = lines[i];
      final fields = _parseCSVLine(line);
      if (fields[0] == id) {
        lines[i] = '$id,$name,$description,'
            '${categoryId ?? ''},'
            '${imageUuid ?? ''},'
            '${createdAt?.toIso8601String() ?? ''},'
            '${updatedAt?.toIso8601String() ?? ''}\n';
        updated = true;
        break;
      }
    }
    
    if (updated) {
      // Remove trailing newline from the last line and write back
      final header = 'id,name,description,category_id,image_uuid,created_at,updated_at\n';
      final updatedLines = lines.join('\n').trim();
      await itemsFile.writeAsString('$header$updatedLines', mode: FileMode.write);
    }
  }

Future<void> deleteItem(String id) async {
    final content = await itemsFile.readAsString();
    final lines = content.trim().split('\n');
    // Skip header row (first line)
    final header = 'id,name,description,category_id,image_uuid,created_at,updated_at\n';
    final filtered = lines.skip(1).where((line) {
      final fields = _parseCSVLine(line);
      return fields[0] != id;
    }).toList();
    await itemsFile.writeAsString('$header${filtered.join('')}', mode: FileMode.write);
  }

  /// === Outfits CRUD ===

  Future<void> createOutfit({
    required String id,
    required String name,
    required String description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) async {
    final line = '$id,$name,$description,'
        '${createdAt?.toIso8601String() ?? ''},'
        '${updatedAt?.toIso8601String() ?? ''}\n';
    await outfitsFile.writeAsString(line, mode: FileMode.append);
  }

  Future<List<Map<String, dynamic>>> readAllOutfits() async {
    final content = await outfitsFile.readAsString();
    final lines = content.trim().split('\n');
    // Skip header row (first line)
    final dataLines = lines.skip(1).where((line) => line.isNotEmpty).toList();
    return dataLines.map((line) {
      final fields = _parseCSVLine(line);
      return {
        'id': fields[0],
        'name': fields[1],
        'description': fields[2],
        'created_at': fields[3],
        'updated_at': fields[4],
      };
    }).toList();
  }

  Future<Map<String, dynamic>?> readOutfitById(String id) async {
    final content = await outfitsFile.readAsString();
    final lines = content.trim().split('\n');
    // Skip header row (first line)
    final dataLines = lines.skip(1);
    for (final line in dataLines) {
      final fields = _parseCSVLine(line);
      if (fields[0] == id) {
        return {
          'id': fields[0],
          'name': fields[1],
          'description': fields[2],
          'created_at': fields[3],
          'updated_at': fields[4],
        };
      }
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
    bool updated = false;
    
    for (int i = 1; i < lines.length; i++) { // Skip header row (start from index 1)
      final line = lines[i];
      final fields = _parseCSVLine(line);
      if (fields[0] == id) {
        lines[i] = '$id,$name,$description,'
            '${createdAt?.toIso8601String() ?? ''},'
            '${updatedAt?.toIso8601String() ?? ''}\n';
        updated = true;
        break;
      }
    }
    
    if (updated) {
      // Remove trailing newline from the last line and write back
      final header = 'id,name,description,created_at,updated_at\n';
      final updatedLines = lines.join('\n').trim();
      await outfitsFile.writeAsString('$header$updatedLines', mode: FileMode.write);
    }
  }

Future<void> deleteOutfit(String id) async {
    final content = await outfitsFile.readAsString();
    final lines = content.trim().split('\n');
    // Skip header row (first line)
    final header = 'id,name,description,created_at,updated_at\n';
    final filtered = lines.skip(1).where((line) {
      final fields = _parseCSVLine(line);
      return fields[0] != id;
    }).toList();
    await outfitsFile.writeAsString('$header${filtered.join('')}', mode: FileMode.write);
  }

  /// === Outfit Items CRUD (Junction Table) ===

  Future<void> createOutfitItem({
    required String outfitId,
    required String itemId,
  }) async {
    final line = '$outfitId,$itemId\n';
    await outfitItemsFile.writeAsString(line, mode: FileMode.append);
  }

  Future<List<Map<String, dynamic>>> readAllOutfitItems() async {
    final content = await outfitItemsFile.readAsString();
    final lines = content.trim().split('\n');
    // Skip header row (first line)
    final dataLines = lines.skip(1).where((line) => line.isNotEmpty).toList();
    return dataLines.map((line) {
      final fields = _parseCSVLine(line);
      return {
        'outfit_id': fields[0],
        'item_id': fields[1],
      };
    }).toList();
  }

  Future<Map<String, dynamic>?> readOutfitItemByOutfitId(String outfitId) async {
    final content = await outfitItemsFile.readAsString();
    final lines = content.trim().split('\n');
    // Skip header row (first line)
    final dataLines = lines.skip(1);
    for (final line in dataLines) {
      final fields = _parseCSVLine(line);
      if (fields[0] == outfitId) {
        return {
          'outfit_id': fields[0],
          'item_id': fields[1],
        };
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> readOutfitItemByItemId(String itemId) async {
    final content = await outfitItemsFile.readAsString();
    final lines = content.trim().split('\n');
    // Skip header row (first line)
    final dataLines = lines.skip(1);
    for (final line in dataLines) {
      final fields = _parseCSVLine(line);
      if (fields[1] == itemId) {
        return {
          'outfit_id': fields[0],
          'item_id': fields[1],
        };
      }
    }
    return null;
  }

  Future<void> deleteOutfitItem(String outfitId) async {
    final content = await outfitItemsFile.readAsString();
    final lines = content.trim().split('\n');
    // Skip header row (first line)
    final header = 'outfit_id,item_id\n';
    final filtered = lines.skip(1).where((line) {
      final fields = _parseCSVLine(line);
      return fields[0] != outfitId;
    }).toList();
    await outfitItemsFile.writeAsString('$header${filtered.join('')}', mode: FileMode.write);
  }

  /// === Utility Methods ===

  void save() {
    // CSV files are automatically persisted on disk
  }

  void close() {
    // No cleanup needed for file-based storage
  }

  /// Helper method to parse CSV lines (simple comma-splitting without quotes)
  List<String> _parseCSVLine(String line) {
    final parts = line.split(',');
    return parts.map((p) => p.trim()).toList();
  }
}
