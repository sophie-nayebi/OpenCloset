/// Table definitions for the OpenCloset database using Drift.
///
/// These classes define the database schema and are used to generate
/// Drift DAO (Data Access Object) classes.

import 'package:drift/drift.dart';

/// Represents the `categories` table.
/// Stores item categories such as tops, bottoms, shoes, etc.
@DataClassName('Category')
class Categories extends Table with AutoIncrementingPrimaryKey {
  /// Human-readable category name (e.g., "Tops", "Shoes", "Accessories").
  TextColumn get name => text()();

  /// Optional description of what items belong to this category.
  TextColumn get description => text().nullable()();

  /// Timestamp when the category was created.
  DateTimeColumn get createdAt => dateTime()();
}

/// Represents the `items` table.
/// Stores wardrobe items (clothing, shoes, accessories).
@DataClassName('Item')
class Items extends Table with AutoIncrementingPrimaryKey {
  /// Display name of the wardrobe item.
  TextColumn get name => text()();

  /// Optional description of the item.
  TextColumn get description => text().nullable()();

  /// Optional category this item belongs to.
  IntColumn get categoryId => integer().nullable().references(Categories, #id)();

  /// UUID of the image stored on disk for this item.
  TextColumn get imageUuid => text()();

  /// Timestamp when the item was created.
  DateTimeColumn get createdAt => dateTime()();

  /// Timestamp when the item was last updated.
  DateTimeColumn get updatedAt => dateTime()();
}

/// Represents the `outfits` table.
/// Stores user-created outfits (collections of items).
@DataClassName('Outfit')
class Outfits extends Table with AutoIncrementingPrimaryKey {
  /// Human-readable name of the outfit.
  TextColumn get name => text()();

  /// Optional description of the outfit.
  TextColumn get description => text().nullable()();

  /// Timestamp when the outfit was created.
  DateTimeColumn get createdAt => dateTime()();

  /// Timestamp when the outfit was last updated.
  DateTimeColumn get updatedAt => dateTime()();
}

/// Represents the `outfit_items` junction table.
/// Links outfits to their constituent items (many-to-many relationship).
@DataClassName('OutfitItem')
class OutfitItems extends Table {
  /// Foreign key to the outfits table.
  IntColumn get outfitId => integer().references(Outfits, #id)();

  /// Foreign key to the items table.
  IntColumn get itemId => integer().references(Items, #id)();
}

/// Mixin that provides auto-incrementing primary key for tables.
/// This replaces the need to define an `id` column manually.
mixin AutoIncrementingPrimaryKey on Table {
  IntColumn get id => integer().autoIncrement()();
}
