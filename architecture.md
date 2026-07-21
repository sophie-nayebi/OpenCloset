# Architecture

## Overview

OpenCloset follows a layered, dependency-inverted architecture. This ensures clean separation of concerns, testability, and maintainability.

```
┌─────────────────────────────────────────┐
│           Presentation Layer            │
│  Widgets  │  Riverpod State  │  Navigation│
└─────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────┐
│           Application Layer             │
│  Use Cases  │  State Management  │  Logic│
└─────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────┐
│              Domain Layer               │
│  Models  │  Entities  │  Use Case       │
│          │  Interfaces│  Contracts     │
└─────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────┐
│           Infrastructure Layer          │
│  Database  │  Image Processing  │ Storage│
│  (Drift)   │  (ONNX Runtime)  │  (File) │
└─────────────────────────────────────────┘
```

## Principles

### 1. Business Logic Never Belongs in Widgets

Widgets are responsible for rendering and user interaction only. They should never contain business logic, data fetching, or validation.

### 2. Infrastructure Should Be Replaceable

The infrastructure layer (database, image processing, storage) is abstracted behind interfaces. This makes it possible to:
- Swap SQLite for an in-memory database in tests
- Replace background removal implementations
- Mock storage for integration tests

### 3. Dependency Inversion

The domain layer defines interfaces, and the infrastructure layer implements them. The domain layer knows nothing about the infrastructure.

### 4. Each Feature Is Self-Contained

Features live in isolated directories under `lib/features/`. They expose their public API clearly and have minimal coupling with other features.

## Layer Responsibilities

### Presentation

- UI widgets and layouts
- Navigation routing
- User input handling
- Riverpod providers for UI state

### Application

- Use cases and business logic orchestration
- Complex state management
- Multi-step operations (e.g., outfit creation, image import)

### Domain

- Domain models and entities
- Use case interfaces
- Domain-specific rules and invariants

### Infrastructure

- Database access (Drift)
- Image processing (ONNX Runtime, masking, thumbnails)
- File storage and management
- Export/import handlers

## Data Flow

1. User interacts with a widget
2. Widget triggers a provider or state update
3. Provider executes a use case (application layer)
4. Use case interacts with domain models and infrastructure
5. Results flow back up through providers to the widget
6. Widget re-renders with updated data

## Folder Structure

```
lib/
├── app/              # App bootstrapping, routing, theme
│   ├── app.dart      # Application entry point
│   ├── routes.dart   # GoRouter configuration
│   └── theme.dart    # Material 3 theme
│
├── features/         # Feature modules
│   ├── wardrobe/      # Clothing catalog feature
│   ├── outfits/      # Outfit builder feature
│   ├── statistics/   # Analytics feature
│   └── ...           # Other features
│
├── shared/           # Cross-cutting concerns
│   ├── widgets/      # Reusable widgets
│   ├── utils/        # Utilities
│   └── constants/    # Shared constants
│
packages/             # Library packages
└── ...               # Self-contained packages
```

## State Management

Riverpod is the primary state management solution:

- **UI state** — Can live in widgets using `NotifierProvider`
- **Application state** — Lives in providers under `lib/features/*/providers/`
- **Async data** — Uses `AsyncNotifier` for loading/error/success states
- **Static config** — Uses `Provider` for immutable values

## Testing

| Type        | What to Test                     | Where                     |
|-------------|----------------------------------|---------------------------|
| Unit        | Use cases, models, utilities     | `test/unit/`              |
| Widget      | Widget rendering, interactions   | `test/widgets/`           |
| Integration | End-to-end user flows            | `integration_test/`        |
