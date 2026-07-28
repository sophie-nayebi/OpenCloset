# AGENTS.md

## Before Coding

Read:

- PROJECT_CONTEXT.md
- Relevant specification
- Existing code

Implement using small testable vertical slices. Avoid implementing a whole class at once as that violates TDD.

This project is hosted on github under user sophie-nayebi and with the name OpenCloset. Work is tracked with github issues available through the github MCP.

---

## Build

For database package, cd into the directory and use:
```
flutter test packages/database/ # To test
```

---

## Stack

- Flutter
- Dart
- Riverpod
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

Use CSV file storage.

Store metadata only.

Images remain on disk.

No SQL or external database dependencies.

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

## Testing

New functionality should include:

- Unit tests
- Widget tests when appropriate
- Integration tests for critical flows

Bug fixes should include regression tests.

ALWAYS use TDD (test driven development)

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
