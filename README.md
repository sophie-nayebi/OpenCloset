# OpenCloset

An open-source, offline-first wardrobe management application.

Catalog clothing, photograph items, remove backgrounds automatically, create outfits, track daily wear, and analyze wardrobe usage over time.

## Goals

- Open source
- Offline first
- Cross-platform
- Fast
- Privacy respecting
- Easy to contribute to
- Long-term maintainable

## Supported Platforms

| Priority | Platform |
|----------|----------|
| 1        | iPhone   |
| 2        | Android  |
| 3        | Linux Desktop |
| 4        | macOS    |
| 5        | Windows  |

All core functionality works on every platform.

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

## Non-Goals

This is **NOT**:
- A shopping platform
- A social network
- A fashion marketplace
- Cloud dependent
- AI-first

AI assists the user and never replaces user ownership.

## Technology

| Layer          | Technology       |
|----------------|------------------|
| UI             | Flutter          |
| Language       | Dart             |
| Database       | SQLite (Drift)   |
| Routing        | GoRouter         |
| State          | Riverpod         |
| Image Processing | ONNX Runtime    |
| Charts         | Flutter charts   |
| Testing        | flutter_test + integration_test |
| CI             | GitHub Actions   |

## Architecture

```
Presentation (Widgets + Riverpod)
    ↓
Application (Use Cases)
    ↓
Domain (Models + Use Case abstractions)
    ↓
Infrastructure (Database, Image Processing, Storage)
```

Business logic never belongs in widgets. Infrastructure is replaceable.

## Data Ownership

- Images are stored as files on disk.
- Database stores metadata only.
- Exports are ZIP archives containing JSON, images, masks, and thumbnails.
- Users are never locked into the application.

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

Each phase produces a usable release.

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Dart SDK (included with Flutter)
- macOS, Linux, or Windows

### Setup

```bash
# Clone the repository
git clone https://github.com/<username>/opencloset.git
cd opencloset

# Run Flutter doctor to verify setup
flutter doctor

# Run the app
flutter run
```

## Project Structure

```
lib/
├── app/             # Application entry, routing, providers
├── features/        # Feature modules (wardrobe, outfits, stats, etc.)
└── shared/          # Common widgets, utilities, constants
packages/
├── core/            # Shared core logic and utilities
├── database/        # Drift database layer
├── image_processing/# Image manipulation, background removal
├── statistics/      # Wardrobe analytics and charts
├── sync/            # Optional cloud synchronization
├── import_export/   # Import/export functionality
└── design_system/   # Design tokens, typography, colors
```

## Development

```bash
# Run tests
flutter test

# Run linting
flutter analyze

# Run with hot reload
flutter run

# Run on specific platform
flutter run --platform ios
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

## License

MIT
