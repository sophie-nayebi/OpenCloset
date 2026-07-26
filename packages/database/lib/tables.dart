/// Table definitions for the OpenCloset database using CSV storage.
///
/// These classes define the storage schema and are used to generate
/// CSV column mappings and data access helpers.

/// Represents the `categories` table.
/// Stores item categories such as tops, bottoms, shoes, etc.
class Category {
  /// Unique identifier for the category.
  int id;

  /// Human-readable category name (e.g., "Tops", "Shoes", "Accessories").
  String name;

  /// Optional description of what items belong to this category.
  String? description;

  /// Timestamp when the category was created.
  DateTime createdAt;

  Category({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
  });

  /// Creates a new category from CSV row values.
  factory Category.fromCSVRow(Map<String, String> row) {
    return Category(
      id: int.parse(row['id'] ?? '0'),
      name: row['name'] ?? '',
      description: row['description']?.trim().isEmpty ? null : row['description'],
      createdAt: DateTime.parse(row['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  /// Serializes the category to CSV-compatible map.
  Map<String, String> toCSVRow() {
    return {
      'id': id.toString(),
      'name': name,
      'description': description ?? '',
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// Represents the `items` table.
/// Stores wardrobe items (clothing, shoes, accessories).
class Item {
  /// Unique identifier for the item.
  int id;

  /// Display name of the wardrobe item.
  String name;

  /// Optional description of the item.
  String? description;

  /// Optional category this item belongs to.
  int? categoryId;

  /// UUID of the image stored on disk for this item.
  String imageUuid;

  /// Timestamp when the item was created.
  DateTime createdAt;

  /// Timestamp when the item was last updated.
  DateTime updatedAt;

  Item({
    required this.id,
    required this.name,
    this.description,
    this.categoryId,
    required this.imageUuid,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a new item from CSV row values.
  factory Item.fromCSVRow(Map<String, String> row) {
    return Item(
      id: int.parse(row['id'] ?? '0'),
      name: row['name'] ?? '',
      description: row['description']?.trim().isEmpty ? null : row['description'],
      categoryId: row['category_id']?.trim().isEmpty ? null : int.parse(row['category_id']!),
      imageUuid: row['image_uuid'] ?? '',
      createdAt: DateTime.parse(row['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(row['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  /// Serializes the item to CSV-compatible map.
  Map<String, String> toCSVRow() {
    return {
      'id': id.toString(),
      'name': name,
      'description': description ?? '',
      'category_id': categoryId?.toString() ?? '',
      'image_uuid': imageUuid,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Represents the `outfits` table.
/// Stores user-created outfits (collections of items).
class Outfit {
  /// Unique identifier for the outfit.
  int id;

  /// Human-readable name of the outfit.
  String name;

  /// Optional description of the outfit.
  String? description;

  /// Timestamp when the outfit was created.
  DateTime createdAt;

  /// Timestamp when the outfit was last updated.
  DateTime updatedAt;

  Outfit({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a new outfit from CSV row values.
  factory Outfit.fromCSVRow(Map<String, String> row) {
    return Outfit(
      id: int.parse(row['id'] ?? '0'),
      name: row['name'] ?? '',
      description: row['description']?.trim().isEmpty ? null : row['description'],
      createdAt: DateTime.parse(row['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(row['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  /// Serializes the outfit to CSV-compatible map.
  Map<String, String> toCSVRow() {
    return {
      'id': id.toString(),
      'name': name,
      'description': description ?? '',
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Represents the `outfit_items` junction table.
/// Links outfits to their constituent items (many-to-many relationship).
class OutfitItem {
  /// Foreign key to the outfits table.
  int outfitId;

  /// Foreign key to the items table.
  int itemId;

  OutfitItem({required this.outfitId, required this.itemId});

  /// Creates a new outfit item from CSV row values.
  factory OutfitItem.fromCSVRow(Map<String, String> row) {
    return OutfitItem(
      outfitId: int.parse(row['outfit_id'] ?? '0'),
      itemId: int.parse(row['item_id'] ?? '0'),
    );
  }

  /// Serializes the outfit item to CSV-compatible map.
  Map<String, String> toCSVRow() {
    return {
      'outfit_id': outfitId.toString(),
      'item_id': itemId.toString(),
    };
  }
}