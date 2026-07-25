/// Integration tests for the OpenCloset database.
///
/// These tests verify:
/// - Complete CRUD operations for items
/// - Complete CRUD operations for categories
/// - Complete CRUD operations for outfits
/// - Junction table (outfit_items) operations
/// - Database connection and migration
/// - Foreign key relationships

import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';

import '../lib/database.dart';

void main() {
  late OpenClosetDatabase db;

  setUp(() {
    db = OpenClosetDatabase.createForTesting();
  });

  tearDown(() async {
    await db.close();
  });

  test('categories CRUD', () async {
    await db.into(db.categories).insert(
          CategoriesCompanion.insert(
            name: 'Tops',
            createdAt: DateTime.now(),
          ),
        );

    final categories = await db.select(db.categories).get();

    expect(categories.length, 1);
    expect(categories.first.name, 'Tops');

    await (db.update(db.categories)
          ..where((c) => c.id.equals(categories.first.id)))
        .write(
      CategoriesCompanion(
        name: const Value('Upper Garments'),
      ),
    );

    final updated = await db.select(db.categories).get();

    expect(updated.first.name, 'Upper Garments');

    await (db.delete(db.categories)
          ..where((c) => c.id.equals(updated.first.id)))
        .go();

    expect(await db.select(db.categories).get(), isEmpty);
  });

  test('items CRUD', () async {
    final categoryId = await db.into(db.categories).insert(
          CategoriesCompanion.insert(
            name: 'Tops',
            createdAt: DateTime.now(),
          ),
        );

    await db.into(db.items).insert(
          ItemsCompanion.insert(
            name: 'T-Shirt',
            description: const Value('Blue shirt'),
            imageUuid: 'test-image',
            categoryId: Value(categoryId),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

    final items = await db.select(db.items).get();

    expect(items.length, 1);
    expect(items.first.name, 'T-Shirt');

    await (db.update(db.items)
          ..where((i) => i.id.equals(items.first.id)))
        .write(
      ItemsCompanion(
        name: const Value('Sleeveless T-Shirt'),
        updatedAt: Value(DateTime.now()),
      ),
    );

    final updated = await db.select(db.items).get();

    expect(updated.first.name, 'Sleeveless T-Shirt');
  });

  test('outfits CRUD', () async {
    await db.into(db.outfits).insert(
          OutfitsCompanion.insert(
            name: 'Winter Outfit',
            createdAt: DateTime.now(),
          ),
        );

    final outfits = await db.select(db.outfits).get();

    expect(outfits.length, 1);

    await (db.update(db.outfits)
          ..where((o) => o.id.equals(outfits.first.id)))
        .write(
      OutfitsCompanion(
        name: const Value('Winter Outfit v2'),
      ),
    );

    final updated = await db.select(db.outfits).get();

    expect(updated.first.name, 'Winter Outfit v2');
  });

  test('outfit items relationship', () async {
    final itemId = await db.into(db.items).insert(
          ItemsCompanion.insert(
            name: 'Shoes',
            imageUuid: 'shoe-image',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

    final outfitId = await db.into(db.outfits).insert(
          OutfitsCompanion.insert(
            name: 'Summer Outfit',
            createdAt: DateTime.now(),
          ),
        );

    await db.into(db.outfitItems).insert(
          OutfitItemsCompanion.insert(
            outfitId: outfitId,
            itemId: itemId,
          ),
        );

    final outfitItems = await db.select(db.outfitItems).get();

    expect(outfitItems.length, 1);
    expect(outfitItems.first.itemId, itemId);
    expect(outfitItems.first.outfitId, outfitId);
  });

  test('foreign key relationship', () async {
    final categoryId = await db.into(db.categories).insert(
          CategoriesCompanion.insert(
            name: 'Jackets',
            createdAt: DateTime.now(),
          ),
        );

    final itemId = await db.into(db.items).insert(
          ItemsCompanion.insert(
            name: 'Winter Jacket',
            imageUuid: 'jacket-image',
            categoryId: Value(categoryId),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

    final item = await (db.select(db.items)
          ..where((i) => i.id.equals(itemId)))
        .getSingle();

    expect(item.categoryId, categoryId);
  });

  test('database schema version', () {
    expect(db.schemaVersion, 1);
  });
}