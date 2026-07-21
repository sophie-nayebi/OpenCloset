# PROJECT_CONTEXT.md

## Project

Wardrobe is an open-source, offline-first wardrobe management application.

Users can catalog clothing, automatically remove backgrounds from photos, create outfits, track daily wear, and analyze wardrobe usage over time.

The application is designed for long-term personal ownership of data.

No account should be required.

---

## Goals

- Open source
- Offline first
- Cross-platform
- Fast
- Privacy respecting
- Easy to contribute to
- Long-term maintainable

---

## Supported Platforms

Priority order:

1. iPhone
2. Android
3. Linux Desktop
4. macOS
5. Windows

All core functionality should work on every platform.

---

## Target Users

People who:

- own many clothes
- build outfits
- want wardrobe statistics
- practice capsule wardrobes
- travel frequently
- enjoy personal organization

---

## Core Features

- Clothing catalog
- Clothing photography
- Background removal
- Manual image editing
- Outfit builder
- Daily wear tracking
- Statistics
- Import / Export
- Optional synchronization
- Optional AI assistance

---

## Non-Goals

This is NOT:

- a shopping platform
- a social network
- a fashion marketplace
- cloud dependent
- AI-first

AI assists the user.

AI never replaces user ownership.

---

## Design Principles

User owns their data.

Everything important works offline.

Cloud features are optional.

Images never leave the device unless explicitly exported.

Data formats remain open.

---

## Technology

UI:
Flutter

Language:
Dart

Database:
SQLite (Drift)

Routing:
GoRouter

State:
Riverpod

Image Processing:
ONNX Runtime

Charts:
Flutter charts

Testing:
flutter_test + integration_test

CI:
GitHub Actions

---

## Architecture

Presentation

↓

Application

↓

Domain

↓

Infrastructure

Business logic never belongs in widgets.

Infrastructure should be replaceable.

---

## Data Ownership

Images are stored as files.

Database stores metadata.

Exports are ZIP archives containing:

- JSON
- Images
- Masks
- Thumbnails

Users should never be locked into the application.

---

## AI

AI is optional.

Primary uses:

- Background removal
- Clothing classification
- Attribute detection
- Outfit suggestions

AI should run locally whenever practical.

---

## Roadmap

1. Foundation
2. Wardrobe
3. Images
4. Outfit Builder
5. Wear Tracking
6. Statistics
7. Import / Export
8. Sync
9. AI
10. Polish

Each phase should produce a usable release.

---

## Quality Standards

Prioritize:

- Readability
- Simplicity
- Testability
- Modularity
- Documentation

Avoid unnecessary complexity.

Prefer boring solutions that will still be easy to maintain five years from now.