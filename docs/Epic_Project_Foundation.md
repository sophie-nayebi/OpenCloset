# Epic: Project Foundation

## Goal

Build the cross-platform skeleton of OpenCloset — an offline-first, privacy-respecting wardrobe management application — with a clean layered architecture, multi-platform support, CI/CD, localization, and theming.

## Business Value

- **Fast time-to-market**: All platforms configured upfront so feature development isn't blocked by platform-specific configuration
- **Open-source readiness**: Clean structure makes contributions easy and maintainable long-term
- **Data ownership**: Local-first design ensures user data never leaves their device without explicit action

## Success Criteria

- Builds on iOS, Android, Linux, macOS, and Windows without changes
- CI/CD pipeline runs on every push (lint, analyze, test)
- All user-facing strings are localized
- Light/dark theme toggling works across platforms
- Settings page exists with theme toggle and export options
- Structured logging is available
- Repository follows the documented layered architecture

## Scope

### In Scope

| Story | Priority |
|-------|----------|
| Create project architecture | P0 |
| Configure Riverpod | P0 |
| Configure Drift | P0 |
| Configure routing | P0 |
| Create dependency injection | P0 |
| Create app settings | P0 |
| Create preferences service | P0 |
| GitHub Actions | P0 |

### Out of Scope

| Item |
|------|
| Wardrobe catalog feature |
| Image processing / background removal |
| Outfit builder |
| Wear tracking |
| Statistics/analytics |
| Import/Export |
| Sync |
| AI features |

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Linux/Windows Flutter platform gaps | Medium | High | Test early; defer non-critical desktop-only UI to Phase 2 |
| CI/CD takes too long | Low | Medium | Cache dependencies; run lint/analyze in parallel with tests |
| Architecture drift in P0 | Medium | High | Freeze architecture in this epic; no new packages |
| Localization framework adds complexity | Low | Medium | Start with English + 1 more locale; defer later |

## Dependencies

| Dependency | Status |
|------------|--------|
| Flutter 4.x+ | External |
| Riverpod | External |
| Drift / Drift Flutter | External |
| GoRouter | External |
| Flutter Internationalization | External |
| Provider | External (for preferences) |

## Features

| Feature | Purpose |
|---------|---------|
| **Project architecture** | Enforce layered, dependency-inverted structure from day one |
| **Riverpod configuration** | Provide reusable `AsyncNotifier`, `Notifier`, and `Provider` patterns |
| **Drift configuration** | Initialize DB schema, connect to mobile/desktop SQLite |
| **Routing** | GoRouter setup with named routes and deep linking stubs |
| **Dependency injection** | `riverpod`-based DI container in `lib/app/bootstrap.dart` |
| **App settings** | Settings page: theme toggle, export option, about info |
| **Preferences service** | Local storage for user preferences (theme, defaults) |
| **GitHub Actions** | CI pipeline: lint, analyze, test on every push and PR |

## Estimates

| Story | Story Points | Ideal Days | Likely Days | Worst Case | Confidence |
|-------|--------------|------------|-------------|------------|------------|
| Create project architecture | 5 | 2 | 3 | 5 | 80% |
| Configure Riverpod | 3 | 1 | 1 | 2 | 90% |
| Configure Drift | 5 | 2 | 3 | 5 | 75% |
| Configure routing | 3 | 1 | 2 | 3 | 85% |
| Create dependency injection | 3 | 1 | 1 | 2 | 90% |
| Create app settings | 5 | 2 | 2 | 3 | 80% |
| Create preferences service | 3 | 1 | 1 | 2 | 85% |
| GitHub Actions | 3 | 1 | 1 | 2 | 90% |
| **Total** | **30** | **11** | **14** | **23** | |

## Acceptance Criteria

### Architecture

- [ ] `lib/app/` exists with `app.dart`, `routes.dart`, `theme.dart`
- [ ] `lib/features/` has skeleton directories for each planned feature
- [ ] `lib/shared/` exists with `widgets/`, `utils/`, `constants/`
- [ ] `packages/core/`, `packages/database/`, `packages/design_system/` exist
- [ ] No business logic in widgets
- [ ] No infrastructure leaks into domain layer

### Riverpod

- [ ] `lib/providers/` directory exists
- [ ] Example `AsyncNotifier` provider demonstrates loading/error/success states
- [ ] Example `Notifier` provider demonstrates state mutation
- [ ] All feature providers are registered in `app.dart`

### Drift

- [ ] Database schema defined with at least one table (stub)
- [ ] Database connection established in `packages/database/`
- [ ] Migrations file exists (empty, ready for v1)

### Routing

- [ ] GoRouter configured in `lib/app/routes.dart`
- [ ] Named routes for `home`, `settings`
- [ ] Fallback route returns 404

### Dependency Injection

- [ ] `riverpod` provider container in `app.dart`
- [ ] No manual `new` calls for services; all via providers

### Settings

- [ ] Settings page renders with:
  - Theme toggle (light/dark)
  - About button
  - Export option
- [ ] Navigation to settings is accessible from app shell

### Preferences Service

- [ ] `shared/services/preferences.dart` exists
- [ ] Can read/write theme preference
- [ ] Defaults to light theme

### GitHub Actions

- [ ] `lib/.github/workflows/ci.yml` exists
- [ ] Pipeline runs on `push` to `main` and `pull_request`
- [ ] Steps: lint, analyze, test
- [ ] All jobs pass on a clean build

## Migration Strategy

No migration needed — this is the initial release.

## Open-Source Considerations

- Public API surface is `lib/app/app.dart` and feature entry points
- All public types are documented
- No private implementation details leak to public API
- README includes contribution guide

## CI/CD Implications

- Lint and analyze run on every PR; tests run on push
- First pass must be fast (<10 min) to encourage contributions
- Add PR template and CODEOWNERS in this epic

## Documentation Implications

- `README.md` must describe project structure, architecture, and how to run on all platforms
- `CONTRIBUTING.md` must document how to add a new feature
- `lib/app/README.md` explains bootstrapping

## Testing Implications

| Type | Location | Coverage Goal |
|------|----------|---------------|
| Unit | `test/unit/` | Use cases, models |
| Widget | `test/widgets/` | Settings, theme toggle |
| Integration | `integration_test/` | End-to-end flow stubs |

## Accessibility Considerations

- Theme toggle must have accessible label
- Settings page must be navigable via keyboard/screen reader
- All icons must have labels

## Localization Implications

- All strings in `lib/l10n/`
- `flutter_localizations` configured
- Minimum: English (`en`), Spanish (`es`)

## Security Considerations

- No network calls in P0
- No file uploads
- Local storage only

## Performance Considerations

- DB connection initialized lazily
- Route preloading for critical paths
- Theme switch must not cause full app rebuild

## Future Work

- P1: Add more locales (fr, de, zh)
- P2: Desktop-specific navigation adjustments
- P3: Add analytics for open-source contribution metrics

---

**Estimated Effort**: 30 story points | 11–14 likely days | 23 worst case days  
**Team Size**: 2–4 developers  
**Recommendation**: Start with architecture + DI + Riverpod, then add Drift + routing in parallel, finish with settings + preferences + CI/CD.
