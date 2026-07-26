# Epic: Project Foundation — User Stories Per Feature

---

## Story 1: Create Project Architecture

### Overview

Establish the layered, dependency-inverted folder structure and scaffold all package roots so feature teams can start building immediately.

### Purpose

Prevent architectural drift by defining the directory layout and entry points before any feature work begins.

### Business Value

- All feature teams share a consistent structure
- New contributors can understand the codebase on day one
- Prevents cross-package coupling

### Technical Value

- No reorganization needed later
- Clear separation of concerns from day one
- Easy to locate any file

### Dependencies

- None

### Risks

- Low risk — this is scaffolding work
- Risk of over-engineering if we add too many packages too soon

### Complexity

Low

### Estimate

| Metric | Value |
|--------|-------|
| Story Points | 5 |
| Ideal Days | 2 |
| Likely Days | 3 |
| Worst Case | 5 |
| Confidence | 80% |

---

### As a contributor  
I want a well-organized folder structure with clear package boundaries  
So that I can find where to add new features without guessing.

#### Description

Create the directory layout specified in the architecture document, populate each directory with a minimal entry file that documents its purpose.

#### Acceptance Criteria

- [ ] `lib/app/` directory exists
  - [ ] `app.dart` — application entry point
  - [ ] `routes.dart` — GoRouter configuration
  - [ ] `theme.dart` — Material 3 theme definitions
- [ ] `lib/features/` directory exists with skeleton subdirectories:
  - [ ] `lib/features/wardrobe/` — wardrobe catalog
  - [ ] `lib/features/outfits/` — outfit builder
  - [ ] `lib/features/statistics/` — analytics
  - [ ] `lib/features/import_export/` — import/export
  - [ ] `lib/features/sync/` — optional sync
  - [ ] `lib/features/settings/` — settings page
- [ ] `lib/shared/` directory exists:
  - [ ] `lib/shared/widgets/` — reusable widgets
  - [ ] `lib/shared/utils/` — utilities
  - [ ] `lib/shared/constants/` — shared constants
- [ ] `packages/core/` directory exists with `lib/core.dart`
- [ ] `packages/database/` directory exists with `lib/database.dart`
- [ ] `packages/design_system/` directory exists with `lib/design_system.dart`
- [ ] `packages/image_processing/` directory exists with `lib/image_processing.dart`
- [ ] `packages/statistics/` directory exists with `lib/statistics.dart`
- [ ] `packages/sync/` directory exists with `lib/sync.dart`
- [ ] `packages/import_export/` directory exists with `lib/import_export.dart`
- [ ] No empty directories remain (each has a `.dart` entry file)

#### Technical Tasks

1. Create all directories under `lib/`
2. Create all directories under `packages/`
3. Add a `.dart` entry file to each directory with a comment describing its purpose
4. Verify the tree matches the architecture document

#### Tests

- No tests required — this is structural scaffolding

#### Definition of Done

- `git tree` matches the architecture diagram exactly
- Every entry file has a comment header with its purpose
- No `.dart` files contain business logic

---

## Story 2: Configure Riverpod

### Overview

Set up Riverpod as the state management layer with reusable patterns for async, sync, and static providers.

### Purpose

Provide a consistent provider API so all feature teams use the same patterns for state management.

### Business Value

- UI state and application state follow the same convention
- Consistent loading/error/success handling everywhere
- New features can reuse existing provider patterns

### Technical Value

- One source of truth for state management
- Easier to audit state flow
- Easier to test providers in isolation

### Dependencies

- `riverpod` (Flutter package)
- `flutter_riverpod`

### Risks

- Low risk — Riverpod is well-documented
- Risk of overcomplicating with too many custom base classes

### Complexity

Low

### Estimate

| Metric | Value |
|--------|-------|
| Story Points | 3 |
| Ideal Days | 1 |
| Likely Days | 1 |
| Worst Case | 2 |
| Confidence | 90% |

---

### As a developer  
I want reusable Riverpod provider patterns for async, sync, and static state  
So that I can add new features without reinventing how providers work.

#### Description

Create a `lib/providers/` directory containing base classes and examples demonstrating the three main provider types:
1. `AsyncNotifier` for async data (loading/error/success)
2. `Notifier` for synchronous state
3. `Provider` for static/immutable values

#### Acceptance Criteria

- [ ] `lib/providers/` directory exists
- [ ] `lib/providers/base_async_notifier.dart` — base class for async providers:
  - [ ] Implements `AsyncNotifier`
  - [ ] Has `loading`, `error`, and `data` state
  - [ ] Has `refresh()` method stub
- [ ] `lib/providers/base_notifier.dart` — base class for sync providers:
  - [ ] Implements `Notifier`
  - [ ] Has `state` property with immutable update
- [ ] `lib/providers/static_provider.dart` — example of static provider:
  - [ ] Uses `Provider` (not `AsyncNotifier` or `Notifier`)
  - [ ] Demonstrates immutable configuration value
- [ ] Each provider class has a clear comment explaining when to use it
- [ ] No providers are registered globally yet (they remain examples)

#### Technical Tasks

1. Add `flutter_riverpod` dependency to `pubspec.yaml`
2. Create `lib/providers/` directory
3. Write `base_async_notifier.dart` with the three-state pattern
4. Write `base_notifier.dart` with immutable state updates
5. Write `static_provider.dart` with a configuration example
6. Document usage guidelines in each file

#### Tests

- [ ] Unit test: `base_async_notifier_test.dart` — verifies loading/error/success transitions
- [ ] Unit test: `base_notifier_test.dart` — verifies state immutability
- [ ] Unit test: `static_provider_test.dart` — verifies immutable value

#### Definition of Done

- Each provider file has a matching test
- Tests demonstrate correct state transitions
- No production code uses these yet — they remain documentation/stubs

---

## Story 3: Configure CSV Storage

### Overview

Set up a simple CSV file-based storage layer so all features can persist data without SQLite or raw SQL.

### Purpose

Provide a lightweight, zero-config data persistence layer so all features can store and retrieve items, categories, and outfits.

### Business Value

- Data persistence works from day one
- No external database dependencies to manage
- Data is human-readable and portable (plain CSV files)
- Simple file operations make debugging easy

### Technical Value

- No Drift/SQLite complexity to manage
- No migrations to worry about
- File-based storage is trivially portable across platforms
- Easy to implement export/import (CSV files are already portable)
- Zero configuration for desktop and web platforms

### Dependencies

- None — pure Dart file I/O
- `path_provider` for platform-appropriate storage paths

### Risks

- Low risk — file I/O is straightforward
- Low risk — no complex migration strategy needed
- Low risk — no platform-specific quirks

### Complexity

Low

### Estimate

| Metric | Value |
|--------|-------|
| Story Points | 3 |
| Ideal Days | 1 |
| Likely Days | 1 |
| Worst Case | 2 |
| Confidence | 95% |

---

### As a contributor  
I want a simple CSV file storage layer with schema and connection setup  
So that I can persist clothing and user data without worrying about a database.

#### Description

Set up CSV storage with:
1. A schema file (`packages/database/schema.csv`) that defines all columns for each table
2. Database connection code that works on iOS, Android, Linux, macOS, and Windows
3. Platform-appropriate file paths in the user's application directory

#### Acceptance Criteria

- [ ] `packages/database/` directory exists
- [ ] `packages/database/lib/database.dart` contains:
  - [ ] Platform-agnostic storage path resolution (`DocumentsDirectory`, `ApplicationDocumentsDirectory`)
  - [ ] `OpenClosetDatabase` class with CRUD methods for items, categories, outfits
  - [ ] CSV file loading and saving (no SQLite or Drift)
  - [ ] Connection closure on app exit
- [ ] `packages/database/schema.csv` exists with:
  - [ ] Column definitions for all entities (items, categories, outfits, outfit_items)
  - [ ] Data types for each column
  - [ ] Header comment explaining the schema structure
- [ ] No raw SQL or SQLite dependencies in the codebase
- [ ] Database connection is testable (injectable file path parameter)
- [ ] All data operations are wrapped in a single abstract storage API

#### Technical Tasks

1. Add `path_provider` to `pubspec.yaml`
2. Create `packages/database/schema.csv` with column definitions for:
   - `categories` (id, name, description)
   - `items` (id, name, description, category_id, image_uuid, created_at, updated_at)
   - `outfits` (id, name, description, created_at, updated_at)
   - `outfit_items` (outfit_id, item_id)
3. Create platform-aware database connection code in `packages/database/lib/connection/`:
   - `connection.dart` — platform detection and path resolution
   - `native.dart` — mobile (iOS, Android) path handling
   - `desktop.dart` — desktop (Linux, macOS, Windows) path handling
   - `web.dart` — web path handling
   - `unsupported.dart` — fallback for unsupported platforms
4. Create `packages/database/lib/database.dart` with:
   - `OpenClosetDatabase` class with:
     - `categories` — CRUD for category table
     - `items` — CRUD for items table
     - `outfits` — CRUD for outfits table
     - `outfit_items` — CRUD for junction table
     - `create()` method for initial file creation
     - `save()` method for persisting changes
     - `close()` method for cleanup
5. Create empty data files (empty CSVs with headers) on first app launch
6. Create a factory method for creating DB instances (testable with mock file paths)

#### Tests

- [ ] Unit test: `database_test.dart` — verifies file creation and CRUD operations
- [ ] Unit test: `path_resolution_test.dart` — verifies correct platform paths
- [ ] Unit test: `schema_validation_test.dart` — verifies CSV schema matches code
- [ ] Integration test: `db_integration_test.dart` — verifies full read/write cycle

#### Definition of Done

- Database connection creates/loads CSV files on first run
- All CRUD operations work on CSV files
- No SQL or database dependencies in the codebase
- All tests pass
- Storage abstraction is testable with mock file paths

---

## Story 4: Configure Routing

### Overview

Set up GoRouter as the navigation layer with named routes, deep linking stubs, and a fallback 404.

### Purpose

Provide a predictable navigation system so all features have a defined route and can be deep-linked.

### Business Value

- App shell with consistent navigation
- URL-based navigation (deep linking)
- Consistent routing conventions

### Technical Value

- GoRouter handles all navigation
- Routes are declarative and easy to audit
- Easy to add deep links later

### Dependencies

- `go_router` (Flutter package)

### Risks

- Low risk — GoRouter is well-documented
- Risk of route explosion if features add routes too aggressively

### Complexity

Low

### Estimate

| Metric | Value |
|--------|-------|
| Story Points | 3 |
| Ideal Days | 1 |
| Likely Days | 2 |
| Worst Case | 3 |
| Confidence | 85% |

---

### As a developer  
I want a configured GoRouter with named routes and a fallback 404  
So that navigation is predictable and I know exactly what route each feature uses.

#### Description

Set up GoRouter in `lib/app/routes.dart` with:
1. Named routes for `home` and `settings`
2. A 404 fallback for unknown routes
3. Deep linking stub (currently no handlers)

#### Acceptance Criteria

- [ ] `lib/app/routes.dart` exists and exports the router
- [ ] GoRouter is configured with:
  - [ ] Named route `home` → `HomeScreen`
  - [ ] Named route `settings` → `SettingsScreen`
  - [ ] Fallback route returns 404
- [ ] `app.dart` instantiates GoRouter with routes
- [ ] Navigation via `GoRouterNamed` works for both routes
- [ ] Unknown routes show 404
- [ ] Deep linking stub exists (no handlers yet)

#### Technical Tasks

1. Add `go_router` to `pubspec.yaml`
2. Create `lib/app/routes.dart` with GoRouter configuration
3. Create `lib/app/app.dart` entry point that uses the router
4. Create placeholder screens: `HomeScreen` and `SettingsScreen`
5. Wire router to app entry point

#### Tests

- [ ] Widget test: `routing_test.dart` — verifies home and settings routes work
- [ ] Widget test: `routing_test.dart` — verifies 404 on unknown routes
- [ ] Unit test: `router_config_test.dart` — verifies route configuration

#### Definition of Done

- App runs with routing without errors
- All named routes are testable
- Router is exported from `lib/app/routes.dart`

---

## Story 5: Create Dependency Injection

### Overview

Set up Riverpod as the application's dependency injection container with a bootstrap file that wires all providers.

### Purpose

Provide a single source of truth for all providers so services are always available and testable.

### Business Value

- Services are globally accessible where needed
- Easy to swap implementations in tests
- No manual service location code

### Technical Value

- All providers registered in one place
- Easy to audit what's in the container
- Test isolation is simple (isolated providers)

### Dependencies

- `riverpod` (Flutter package)

### Risks

- Low risk — Riverpod DI is straightforward
- Risk of circular dependencies if not careful

### Complexity

Low

### Estimate

| Metric | Value |
|--------|-------|
| Story Points | 3 |
| Ideal Days | 1 |
| Likely Days | 1 |
| Worst Case | 2 |
| Confidence | 90% |

---

### As a developer  
I want a centralized provider container so all services are available everywhere  
So that I don't need to pass dependencies through 10 layers of constructors.

#### Description

Create `lib/app/bootstrap.dart` that:
1. Registers all app-level providers (theme, preferences, router)
2. Exports a provider scope that can be used in `app.dart`
3. Uses `Riverpod` container with `ProviderScope`

#### Acceptance Criteria

- [ ] `lib/app/bootstrap.dart` exists and exports the provider configuration
- [ ] `lib/app/app.dart` uses `Riverpod` container with providers from bootstrap
- [ ] Provider scope wraps the entire app
- [ ] No providers are registered twice
- [ ] Each provider has a clear comment explaining its purpose
- [ ] Providers are lazy-loaded (not eagerly initialized)

#### Technical Tasks

1. Create `lib/app/bootstrap.dart` with provider registration
2. Update `lib/app/app.dart` to use the provider container
3. Add any app-level providers (theme, preferences stub)
4. Ensure no circular dependencies

#### Tests

- [ ] Unit test: `bootstrap_test.dart` — verifies providers are registered
- [ ] Unit test: `bootstrap_test.dart` — verifies no duplicate providers

#### Definition of Done

- `app.dart` uses Riverpod container
- All providers are registered once
- No `Error` at runtime from missing providers

---

## Story 6: Create App Settings

### Overview

Build the Settings page with theme toggle, about info, and export option.

### Purpose

Provide a place for users to configure the app and understand what they're using.

### Business Value

- Users can change theme preference
- Users know about the app and its purpose
- Users can export their data

### Technical Value

- Reusable settings components for future pages
- Theme toggle wireframes the local storage pattern
- Export stub prepares for future implementation

### Dependencies

- Settings page requires `Settings` widget
- Theme toggle requires Riverpod state
- Export requires `Share` plugin (optional, stub for now)

### Risks

- Low risk — standard Flutter UI work
- Risk of scope creep if we add too many settings

### Complexity

Low

### Estimate

| Metric | Value |
|--------|-------|
| Story Points | 5 |
| Ideal Days | 2 |
| Likely Days | 2 |
| Worst Case | 3 |
| Confidence | 80% |

---

### As a developer  
I want a Settings page with theme toggle, about info, and export option  
So that users can configure the app and understand their data ownership.

#### Description

Build `lib/features/settings/settings_screen.dart` with:
1. Theme toggle (light/dark) wired to preferences
2. About section with app name, version, and data ownership note
3. Export option (disabled stub with info dialog)

#### Acceptance Criteria

- [ ] `lib/features/settings/settings_screen.dart` exists
- [ ] Theme toggle widget:
  - [ ] Switch or segmented control
  - [ ] Toggles between light/dark themes
  - [ ] Persists choice via preferences service
  - [ ] Accessible label
- [ ] About section:
  - [ ] Shows app name: "OpenCloset"
  - [ ] Shows version (from pubspec)
  - [ ] Shows data ownership note
  - [ ] Link to GitHub repository
- [ ] Export option:
  - [ ] Button or list tile
  - [ ] Disabled with info dialog explaining future feature
- [ ] Navigation: back button and title "Settings"
- [ ] Settings page is accessible from home route

#### Technical Tasks

1. Create `lib/features/settings/settings_screen.dart`
2. Implement theme toggle widget with Riverpod connection
3. Implement about section with static info
4. Implement export stub with disabled state
5. Wire settings route in `lib/app/routes.dart`

#### Tests

- [ ] Widget test: `settings_screen_test.dart` — renders with all three sections
- [ ] Widget test: `settings_screen_test.dart` — theme toggle works
- [ ] Widget test: `settings_screen_test.dart` — about section displays correctly
- [ ] Widget test: `settings_screen_test.dart` — export is disabled

#### Definition of Done

- Settings page renders without errors
- Theme toggle changes theme
- About section displays app info
- Export shows disabled state with info

---

## Story 7: Create Preferences Service

### Overview

Build a local storage preferences service that persists user settings across app restarts.

### Purpose

Provide a consistent way to read/write user preferences (theme, defaults) with persistence across app launches.

### Business Value

- Users' theme choice survives app restart
- Settings are consistent across platforms
- Easy to add more preferences later

### Technical Value

- Single source of truth for preferences
- Platform-agnostic storage (uses `shared_preferences` abstraction)
- Easy to mock in tests

### Dependencies

- `shared_preferences` (Flutter package)
- Must work on all platforms (mobile and desktop)

### Risks

- Low risk — `shared_preferences` is straightforward
- Risk of platform-specific quirks (especially Linux)

### Complexity

Low

### Estimate

| Metric | Value |
|--------|-------|
| Story Points | 3 |
| Ideal Days | 1 |
| Likely Days | 1 |
| Worst Case | 2 |
| Confidence | 85% |

---

### As a developer  
I want a preferences service that persists user settings like theme choice  
So that I can store user preferences without reinventing storage for every feature.

#### Description

Create `lib/shared/services/preferences.dart` that:
1. Wraps `shared_preferences` for cross-platform storage
2. Provides typed access to preferences (no raw string keys)
3. Has default values for all preferences
4. Is testable via interface

#### Acceptance Criteria

- [ ] `lib/shared/services/preferences.dart` exists
- [ ] `Preferences` class with:
  - [ ] `theme` property (light/dark enum)
  - [ ] `readTheme()` method
  - [ ] `saveTheme()` method
  - [ ] Default value: light
- [ ] Preferences service is singleton or provider-based
- [ ] No direct `shared_preferences` access in other files
- [ ] Service is injectable (for testing)
- [ ] Works on all platforms (iOS, Android, Linux, macOS, Windows)

#### Technical Tasks

1. Add `shared_preferences` to `pubspec.yaml`
2. Create `Preferences` class in `lib/shared/services/`
3. Implement `readTheme()` and `saveTheme()` methods
4. Implement `Preferences` interface/abstract class for testing
5. Register `Preferences` provider in bootstrap

#### Tests

- [ ] Unit test: `preferences_test.dart` — verify theme read/write
- [ ] Unit test: `preferences_test.dart` — verify default value
- [ ] Unit test: `preferences_test.dart` — verify persistence (mocked)

#### Definition of Done

- Theme preference is saved and restored across app restart
- Default value is light theme
- Service is mockable for tests
- Works on at least one platform

---

## Story 8: GitHub Actions

### Overview

Create a CI/CD pipeline that runs lint, analyze, and tests on every push and pull request.

### Purpose

Automate quality checks so every contribution is validated before merge.

### Business Value

- No bad code reaches main
- Consistent checks across all contributors
- Fast feedback for contributors

### Technical Value

- Lint and analyze run automatically
- Tests run on every PR
- Contributors get immediate feedback

### Dependencies

- GitHub Actions workflow
- Flutter CLI for testing
- `flutter analyze` and `flutter format` for linting

### Risks

- Medium risk — first CI pipeline can take time to stabilize
- Risk of flaky tests blocking the pipeline

### Complexity

Low

### Estimate

| Metric | Value |
|--------|-------|
| Story Points | 3 |
| Ideal Days | 1 |
| Likely Days | 1 |
| Worst Case | 2 |
| Confidence | 90% |

---

### As a contributor  
I want CI/CD that runs lint, analyze, and tests on every PR  
So that code quality is checked automatically and I get feedback before merging.

#### Description

Create `lib/.github/workflows/ci.yml` with:
1. Trigger on `push` to `main` and `pull_request`
2. Jobs for: lint, analyze, test
3. Fast first pass (<10 min)
4. Proper caching

#### Acceptance Criteria

- [ ] `lib/.github/workflows/ci.yml` exists
- [ ] Workflow triggers on:
  - `push` to `main`
  - `pull_request`
- [ ] Jobs:
  - [ ] **lint**: runs `flutter format --dry-run` and `flutter analyze`
  - [ ] **analyze**: runs `flutter analyze`
  - [ ] **test**: runs `flutter test`
- [ ] Caching configured for Flutter SDK and dependencies
- [ ] Workflow passes on the current codebase
- [ ] No required checks for merging to main

#### Technical Tasks

1. Create `lib/.github/workflows/ci.yml`
2. Add workflow triggers (push, pull_request)
3. Add lint job (format + analyze)
4. Add analyze job
5. Add test job
6. Configure caching
7. Test the workflow with a PR

#### Tests

- [ ] Workflow triggers on push to main
- [ ] Workflow triggers on pull_request
- [ ] All jobs pass on current codebase
- [ ] Lint job reports format errors
- [ ] Lint job reports analyze warnings

#### Definition of Done

- Pipeline runs on push and pull_request
- All jobs pass on the main branch
- Pipeline time is under 10 minutes
- PR cannot be merged while checks are failing

---

## Summary

| Story | Story Points | Ideal | Likely | Worst Case | Confidence |
|-------|--------------|-------|--------|------------|------------|
| 1. Project Architecture | 5 | 2d | 3d | 5d | 80% |
| 2. Configure Riverpod | 3 | 1d | 1d | 2d | 90% |
| 3. Configure CSV Storage | 3 | 1d | 1d | 2d | 95% |
| 4. Configure Routing | 3 | 1d | 2d | 3d | 85% |
| 5. Dependency Injection | 3 | 1d | 1d | 2d | 90% |
| 6. Create App Settings | 5 | 2d | 2d | 3d | 80% |
| 7. Create Preferences Service | 3 | 1d | 1d | 2d | 85% |
| 8. GitHub Actions | 3 | 1d | 1d | 2d | 90% |
| **Total** | **28** | **10d** | **12d** | **19d** | |

## Parallelization Strategy

| Phase | Stories | Estimated Duration |
|-------|---------|-------------------|
| Phase 1: Foundation | 1, 2, 5 | 3d |
| Phase 2: Data & Nav | 3, 4 | 2d |
| Phase 3: Features | 6, 7 | 2d |
| Phase 4: Automation | 8 | 1d |
| **Total** | | **8d** (parallel) |

## Open-Source Considerations

- All story artifacts must be well-documented
- PR templates should mention this epic
- Contributors should be able to work on any story independently
- No secrets or private config in the repository

## Migration Strategy

No migration needed — this is the initial release.
