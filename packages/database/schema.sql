-- OpenCloset Database Schema
--
-- This schema defines the PostgreSQL/SQLite-compatible table structures
-- used by the OpenCloset wardrobe management application.
--
-- Tables
--   items       – Wardrobe items (clothing, shoes, accessories)
--   categories  – Item categories (tops, bottoms, shoes, accessories, etc.)
--   outfits     – User-created outfits
--   outfit_items – Junction table linking outfits to items
--
-- Migration History
--   v0 → v1: Initial schema (empty stub)

CREATE TABLE items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  description TEXT,
  category_id INTEGER,
  image_uuid TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (category_id) REFERENCES categories (id)
);

CREATE TABLE categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  description TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE outfits (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  description TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE outfit_items (
  outfit_id INTEGER NOT NULL,
  item_id INTEGER NOT NULL,
  PRIMARY KEY (outfit_id, item_id),
  FOREIGN KEY (outfit_id) REFERENCES outfits (id) ON DELETE CASCADE,
  FOREIGN KEY (item_id) REFERENCES items (id) ON DELETE CASCADE
);
