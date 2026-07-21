# Contributing to OpenCloset

Thank you for your interest in contributing! Below are the guidelines and conventions that help keep the project maintainable and consistent.

## Contribution Process

1. **Find an issue** — Look for issues marked `good first issue`, `help wanted`, or propose your own.
2. **Discuss first** — For significant changes, open a discussion in the issue or create a draft PR.
3. **Fork and branch** — Create a feature branch from `main`.
4. **Write tests** — Unit tests for logic, widget tests for UI.
5. **Keep it focused** — Each PR should address a single concern.
6. **Submit PR** — Ensure CI passes and review guidelines are followed.

## Code Style

- Small files, small widgets, small functions
- Prefer composition over inheritance
- Prefer immutable models
- Follow [Dart Effective Code](https://dart.dev/effective/dart) conventions
- Run `flutter analyze` before submitting

## Architecture

```
Presentation → Application → Domain → Infrastructure
```

- **Widgets never contain business logic**
- **Infrastructure is accessed through abstractions**
- Each layer depends only on layers below it

## Development Setup

### Local Environment

```bash
flutter doctor
flutter run
```

### Common Tasks

- **Run tests:** `flutter test`
- **Run linter:** `flutter analyze`
- **Run tests on a platform:** `flutter test --platform ios`

## Quality Standards

Prioritize:
- Readability
- Simplicity
- Testability
- Modularity
- Documentation

Avoid:
- Clever code that is hard to understand
- Premature optimization
- Dead code
- Debug prints left in production

## Reporting Issues

When reporting a bug or feature request:

1. Use the issue template
2. Include steps to reproduce
3. Mention the platform and Flutter version
4. Include screenshots or logs when applicable

## License

Contributions are submitted under the [MIT License](LICENSE).
