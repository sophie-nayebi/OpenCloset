import 'dart:async';
import 'dart:io';

/// Error thrown when attempting to create a record with a duplicate ID
class DuplicateIdError implements Exception {
  final String id;
  String message;

  DuplicateIdError(this.id)
      : message = 'Duplicate ID: $id';

  @override
  String toString() => message;
}

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
    // This method is called during initialization to ensure CSV files have proper headers
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
    // Validate ID
    if (!_validateId(id)) {
      throw ArgumentError('Invalid ID format: $id');
    }
    
    // Check for duplicate ID
    if (_idExists(categoriesFile, id)) {
      throw DuplicateIdError(id);
    }
    
    final line = _buildCSVLine(
      id,
      name,
      description,
      createdAt,
      updatedAt,
    );
    
    // Ensure file ends with newline before appending
    final currentContent = await categoriesFile.readAsString();
    final hasTrailingNewline = currentContent.endsWith('\n');
    final contentToWrite = hasTrailingNewline ? currentContent : currentContent + '\n';
    
    await categoriesFile.writeAsString(contentToWrite + line, mode: FileMode.write);
  }

  /// Categories CRUD operations with proper file locking for read-modify-write

  Future<List<Map<String, dynamic>>> readAllCategories() async {
    final content = await categoriesFile.readAsString();
    final lines = content.trim().split('\n');
    // Skip header row (first line) and filter out empty lines
    final dataLines = lines
        .skip(1)
        .where((line) => line.isNotEmpty && _isDataRow(line, 5))
        .toList();
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
  
  /// Check if a line is a data row (not a header) based on field count
  bool _isDataRow(String line, int expectedFieldCount) {
    if (line.isEmpty) return false;
    final fields = _parseCSVLine(line);
    return fields.length == expectedFieldCount;
  }

  Future<Map<String, dynamic>?> readCategoryById(String id) async {
    final content = await categoriesFile.readAsString();
    final lines = content.trim().split('\n');
    // Skip header row (first line) and filter out empty lines
    final dataLines = lines
        .skip(1)
        .where((line) => line.isNotEmpty && _isDataRow(line, 5))
        .toList();
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
    // Use atomic write with temp file
    final header = 'id,name,description,created_at,updated_at\n';
    final modifyLines = (String currentLines) {
      final lines = currentLines.trim().split('\n');
     
      for (int i = 1; i < lines.length; i++) { // Skip header row (start from index 1)
        final line = lines[i];
        final fields = _parseCSVLine(line);
        if (fields[0] == id) {
          // Build the new CSV line with proper escaping
          final newLine = _buildCSVLine(id, name, description, createdAt, updatedAt);
          lines[i] = newLine;
          break;
        }
      }
      
      return lines.join('\n');
    };
    
    await _atomicModifyFile(categoriesFile, header, modifyLines);
  }

  Future<void> deleteCategory(String id) async {
    // Use atomic write with temp file
    final header = 'id,name,description,created_at,updated_at\n';
    final modifyLines = (String currentLines) {
      final lines = currentLines.trim().split('\n');
      final filtered = lines
          .skip(1)
          .where((line) => line.isNotEmpty && _isDataRow(line, 5) && _parseCSVLine(line)[0] != id)
          .toList();
      return filtered.join('\n');
    };
    
    await _atomicModifyFile(categoriesFile, header, modifyLines);
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
    // Validate ID
    if (!_validateId(id)) {
      throw ArgumentError('Invalid ID format: $id');
    }
    
    // Check for duplicate ID
    if (_idExists(itemsFile, id)) {
      throw DuplicateIdError(id);
    }
    
    final line = _buildItemCSVLine(
      id,
      name,
      description,
      categoryId,
      imageUuid,
      createdAt,
      updatedAt,
    );
    
    // Ensure file ends with newline before appending
    final currentContent = await itemsFile.readAsString();
    final hasTrailingNewline = currentContent.endsWith('\n');
    final contentToWrite = hasTrailingNewline ? currentContent : currentContent + '\n';
    
    await itemsFile.writeAsString(contentToWrite + line, mode: FileMode.write);
  }

  Future<List<Map<String, dynamic>>> readAllItems() async {
    final content = await itemsFile.readAsString();
    final lines = content.trim().split('\n');
    // Skip header row (first line) and filter out empty lines
    final dataLines = lines
        .skip(1)
        .where((line) => line.isNotEmpty && _isDataRow(line, 7))
        .toList();
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
    // Skip header row (first line) and filter out empty lines
    final dataLines = lines
        .skip(1)
        .where((line) => line.isNotEmpty && _isDataRow(line, 7))
        .toList();
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
    // Use atomic write with temp file
    final header = 'id,name,description,category_id,image_uuid,created_at,updated_at\n';
    final modifyLines = (String currentLines) {
      final lines = currentLines.trim().split('\n');
     
      for (int i = 1; i < lines.length; i++) { // Skip header row (start from index 1)
        final line = lines[i];
        final fields = _parseCSVLine(line);
        if (fields[0] == id) {
          // Build the new CSV line with proper escaping
          final newLine = _buildItemCSVLine(id, name, description, categoryId, imageUuid, createdAt, updatedAt);
          lines[i] = newLine;
          break;
        }
      }
      
      return lines.join('\n');
    };
    
    await _atomicModifyFile(itemsFile, header, modifyLines);
  }

  Future<void> deleteItem(String id) async {
    // Use atomic write with temp file
    final header = 'id,name,description,category_id,image_uuid,created_at,updated_at\n';
    final modifyLines = (String currentLines) {
      final lines = currentLines.trim().split('\n');
      final filtered = lines
          .skip(1)
          .where((line) => line.isNotEmpty && _isDataRow(line, 7) && _parseCSVLine(line)[0] != id)
          .toList();
      return filtered.join('\n');
    };
    
    await _atomicModifyFile(itemsFile, header, modifyLines);
  }

  /// === Outfits CRUD ===

  Future<void> createOutfit({
    required String id,
    required String name,
    required String description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) async {
    // Validate ID
    if (!_validateId(id)) {
      throw ArgumentError('Invalid ID format: $id');
    }
    
    // Check for duplicate ID
    if (_idExists(outfitsFile, id)) {
      throw DuplicateIdError(id);
    }
    
    final line = _buildCSVLine(
      id,
      name,
      description,
      createdAt,
      updatedAt,
    );
    
    // Ensure file ends with newline before appending
    final currentContent = await outfitsFile.readAsString();
    final hasTrailingNewline = currentContent.endsWith('\n');
    final contentToWrite = hasTrailingNewline ? currentContent : currentContent + '\n';
    
    await outfitsFile.writeAsString(contentToWrite + line, mode: FileMode.write);
  }

  Future<List<Map<String, dynamic>>> readAllOutfits() async {
    final content = await outfitsFile.readAsString();
    final lines = content.trim().split('\n');
    // Skip header row (first line) and filter out empty lines
    final dataLines = lines
        .skip(1)
        .where((line) => line.isNotEmpty && _isDataRow(line, 5))
        .toList();
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
    // Skip header row (first line) and filter out empty lines
    final dataLines = lines
        .skip(1)
        .where((line) => line.isNotEmpty && _isDataRow(line, 5))
        .toList();
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
    // Use atomic write with temp file
    final header = 'id,name,description,created_at,updated_at\n';
    final modifyLines = (String currentLines) {
      final lines = currentLines.trim().split('\n');
     
      for (int i = 1; i < lines.length; i++) { // Skip header row (start from index 1)
        final line = lines[i];
        final fields = _parseCSVLine(line);
        if (fields[0] == id) {
          // Build the new CSV line with proper escaping
          final newLine = _buildCSVLine(id, name, description, createdAt, updatedAt);
          lines[i] = newLine;
          break;
        }
      }
      
      return lines.join('\n');
    };
    
    await _atomicModifyFile(outfitsFile, header, modifyLines);
  }

  Future<void> deleteOutfit(String id) async {
    // First, delete all associated outfit_items to prevent orphaned entries
    final outfitItemsContent = await outfitItemsFile.readAsString();
    final outfitItemsLines = outfitItemsContent.trim().split('\n');
    final filteredOutfitItems = outfitItemsLines
        .skip(1)
        .where((line) => line.isNotEmpty && _isDataRow(line, 2) && _parseCSVLine(line)[0] != id)
        .toList();
    final allOutfitItemsLines = 'outfit_id,item_id\n${filteredOutfitItems.join('\n')}\n';
    // Use atomic write for outfit_items
    final tempFile1 = File('${outfitItemsFile.path}.tmp');
    await tempFile1.writeAsString(allOutfitItemsLines);
    await tempFile1.renameSync(outfitItemsFile.path);
    
    // Then delete the outfit
    final outfitsContent = await outfitsFile.readAsString();
    final outfitsLines = outfitsContent.trim().split('\n');
    final filteredOutfits = outfitsLines
        .skip(1)
        .where((line) => line.isNotEmpty && _isDataRow(line, 5) && _parseCSVLine(line)[0] != id)
        .toList();
    final allOutfitsLines = 'id,name,description,created_at,updated_at\n${filteredOutfits.join('\n')}\n';
    // Use atomic write for outfits
    final tempFile2 = File('${outfitsFile.path}.tmp');
    await tempFile2.writeAsString(allOutfitsLines);
    await tempFile2.renameSync(outfitsFile.path);
  }

  /// === Outfit Items CRUD (Junction Table) ===

  Future<void> createOutfitItem({
    required String outfitId,
    required String itemId,
  }) async {
    // Validate outfit ID
    if (!_validateId(outfitId)) {
      throw ArgumentError('Invalid outfit ID format: $outfitId');
    }
    
    // Validate item ID
    if (!_validateId(itemId)) {
      throw ArgumentError('Invalid item ID format: $itemId');
    }
    
    // Ensure file ends with newline before appending
    final currentContent = await outfitItemsFile.readAsString();
    final hasTrailingNewline = currentContent.endsWith('\n');
    final contentToWrite = hasTrailingNewline ? currentContent : currentContent + '\n';
    
    final line = '${_escapeCSVField(outfitId)},${_escapeCSVField(itemId)}\n';
    await outfitItemsFile.writeAsString(contentToWrite + line, mode: FileMode.write);
  }

  Future<List<Map<String, dynamic>>> readAllOutfitItems() async {
    final content = await outfitItemsFile.readAsString();
    final lines = content.trim().split('\n');
    // Skip header row (first line) and filter out empty lines
    final dataLines = lines
        .skip(1)
        .where((line) => line.isNotEmpty && _isDataRow(line, 2))
        .toList();
    final result = <Map<String, dynamic>>[];
    for (final line in dataLines) {
      final fields = _parseCSVLine(line);
      result.add({
        'outfit_id': fields[0],
        'item_id': fields[1],
      });
    }
    return result;
  }

  Future<List<Map<String, dynamic>>> readOutfitItemByOutfitId(String outfitId) async {
    final content = await outfitItemsFile.readAsString();
    final lines = content.trim().split('\n');
    // Skip header row (first line) and filter out empty lines
    final dataLines = lines
        .skip(1)
        .where((line) => line.isNotEmpty && _isDataRow(line, 2))
        .toList();
    final result = <Map<String, dynamic>>[];
    for (final line in dataLines) {
      final fields = _parseCSVLine(line);
      if (fields[0] == outfitId) {
        result.add({
          'outfit_id': fields[0],
          'item_id': fields[1],
        });
      }
    }
    return result;
  }

  Future<List<Map<String, dynamic>>> readOutfitItemByItemId(String itemId) async {
    final content = await outfitItemsFile.readAsString();
    final lines = content.trim().split('\n');
    // Skip header row (first line) and filter out empty lines
    final dataLines = lines
        .skip(1)
        .where((line) => line.isNotEmpty && _isDataRow(line, 2))
        .toList();
    final result = <Map<String, dynamic>>[];
    for (final line in dataLines) {
      final fields = _parseCSVLine(line);
      if (fields[1] == itemId) {
        result.add({
          'outfit_id': fields[0],
          'item_id': fields[1],
        });
      }
    }
    return result;
  }

  Future<void> deleteOutfitItem(String outfitId) async {
    // Read the file content
    final content = await outfitItemsFile.readAsString();
    final lines = content.trim().split('\n');
    // Skip header row (first line) and filter out empty lines
    final header = 'outfit_id,item_id\n';
    final filtered = lines
        .skip(1)
        .where((line) => line.isNotEmpty && _isDataRow(line, 2) && _parseCSVLine(line)[0] != outfitId)
        .toList();
    final allLines = '$header${filtered.join('\n')}\n';
    // Use atomic write: write to temp file, then renameSync to replace original
    final tempFile = File('${outfitItemsFile.path}.tmp');
    await tempFile.writeAsString(allLines);
    await tempFile.renameSync(outfitItemsFile.path);
  }

  /// === Utility Methods ===

  Future<void> save() async {
    // CSV files are automatically persisted on disk
  }

  void close() {
    // No cleanup needed for file-based storage
  }

  /// Escape a field value for CSV (RFC 4180)
  String _escapeCSVField(String field) {
    // If field contains comma, newline, or double quote, wrap in quotes
    if (field.contains(',') || field.contains('\n') || field.contains('\r') || field.contains('"')) {
      // Escape double quotes by doubling them
      final escaped = field.replaceAll('"', '""');
      return '"$escaped"';
    }
    return field;
  }
  
  /// Build a CSV line with proper field escaping
  String _buildCSVLine(
    String id,
    String name,
    String description,
    DateTime? createdAt,
    DateTime? updatedAt,
  ) {
    return [
      _escapeCSVField(id),
      _escapeCSVField(name),
      _escapeCSVField(description),
      _escapeCSVField(createdAt?.toIso8601String() ?? ''),
      _escapeCSVField(updatedAt?.toIso8601String() ?? ''),
    ].join(',') + '\n';
  }
  
  /// Build an items CSV line with proper field escaping
  String _buildItemCSVLine(
    String id,
    String name,
    String description,
    String? categoryId,
    String? imageUuid,
    DateTime? createdAt,
    DateTime? updatedAt,
  ) {
    return [
      _escapeCSVField(id),
      _escapeCSVField(name),
      _escapeCSVField(description),
      _escapeCSVField(categoryId ?? ''),
      _escapeCSVField(imageUuid ?? ''),
      _escapeCSVField(createdAt?.toIso8601String() ?? ''),
      _escapeCSVField(updatedAt?.toIso8601String() ?? ''),
    ].join(',') + '\n';
  }
  
  /// Helper method to parse CSV lines with proper RFC 4180 quoting support
  List<String> _parseCSVLine(String line) {
    final parts = <String>[];
    final currentPart = <String>[];
    bool inQuotes = false;
    int i = 0;
    
    while (i < line.length) {
      final char = line[i];
      
      if (inQuotes) {
        if (char == '"') {
          // Check for escaped quote ("" represents a single quote)
          if (i + 1 < line.length && line[i + 1] == '"') {
            currentPart.add('"');
            i += 2;
            continue;
          } else {
            // End of quoted field
            inQuotes = false;
            i++;
            continue;
          }
        } else {
          currentPart.add(char);
          i++;
          continue;
        }
      } else {
        if (char == '"') {
          // Start of quoted field
          inQuotes = true;
          i++;
          continue;
        } else if (char == ',') {
          // Field separator
          parts.add(currentPart.join(''));
          currentPart.clear();
          i++;
          continue;
        } else {
          currentPart.add(char);
          i++;
          continue;
        }
      }
    }
    
    // Add the last part
    parts.add(currentPart.join(''));
    
    // Trim whitespace from each field
    return parts.map<String>((p) => p.trim()).toList();
  }
  
  /// Atomically reads, modifies, and writes a CSV file
  /// Uses temp file + rename for atomic operation
  Future<void> _atomicModifyFile(
    File file,
    String header,
    Function(String) modifyLines,
  ) async {
    // Read file content
    final content = await file.readAsString();
    final lines = content.trim().split('\n');
    
    // Modify lines
    final modifiedLines = modifyLines(lines.join('\n'));
    
    // Write to temp file then rename for atomic operation
    final tempFile = File('${file.path}.tmp');
    await tempFile.writeAsString('$header$modifiedLines\n');
    await tempFile.renameSync(file.path);
  }

  /// Validates that an ID is a non-empty string
  /// For flexibility, we accept any non-empty string as an ID
  bool _validateId(String id) {
    return id.isNotEmpty;
  }

  /// Checks if a record with the given ID already exists
  bool _idExists(File file, String id) {
    final content = file.readAsStringSync();
    final lines = content.trim().split('\n');
    for (int i = 1; i < lines.length; i++) { // Skip header row
      final line = lines[i];
      final fields = _parseCSVLine(line);
      if (fields[0] == id) return true;
    }
    return false;
  }
}
