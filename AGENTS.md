# AGENTS.md

## Before Coding

Read:

- PROJECT_CONTEXT.md
- Relevant specification
- Existing code

Reuse existing patterns before creating new ones.

---

## Principles

Prioritize:

1. Simplicity
2. Readability
3. Testability
4. Maintainability

Avoid clever code.

---

## Stack

- Flutter
- Dart
- Riverpod
- Drift
- GoRouter
- Material 3

Do not introduce dependencies without justification.

---

## Architecture

Presentation

↓

Application

↓

Domain

↓

Infrastructure

Widgets never contain business logic.

Infrastructure is accessed through abstractions.

---

## Project Structure

lib/
    app/
    features/
    shared/

packages/
    core/
    database/
    image_processing/
    statistics/
    sync/
    import_export/
    design_system/

Keep packages loosely coupled.

---

## State

Use Riverpod.

UI state may live in widgets.

Application state belongs in providers.

---

## Database

Use Drift.

Store metadata only.

Images remain on disk.

Avoid raw SQL.

---

## Images

Store:

- Original
- Transparent PNG
- Mask
- Thumbnail

Reference them by UUID.

---

## UI

Support:

- Phone
- Tablet
- Desktop

Use Material 3.

Localize all user-facing strings.

Support accessibility.

---

## Code Style

Small files.

Small widgets.

Small functions.

Prefer composition.

Prefer immutable models.

Document public APIs.

---

## Testing

New functionality should include:

- Unit tests
- Widget tests when appropriate
- Integration tests for critical flows

Bug fixes should include regression tests.

---

## Security

Validate imported data.

Never trust archive contents.

Never upload user images without explicit user action.

---

## Definition of Done

- Builds successfully
- Analyzer passes
- Tests pass
- Documentation updated
- No dead code
- No debug prints
- Localization added
- Accessibility considered

---

## When Unsure

Prefer the solution that reduces future maintenance.

Ask before making large architectural changes.

Keep changes focused on a single concern.