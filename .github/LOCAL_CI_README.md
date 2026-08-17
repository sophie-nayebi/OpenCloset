# Local CI/CD Pipeline

This directory contains the local CI/CD pipeline for OpenCloset, allowing you to run the same CI checks locally before committing or pushing code.

## Overview

The pipeline consists of three main stages:
- **Lint**: Format and static analysis checks
- **Analyze**: Dependency and code quality analysis
- **Test**: Unit tests with coverage reporting

## Quick Start

### Using Make (Recommended)

```bash
# Run all stages
make all

# Run individual stages
make lint          # Format and analyze
make analyze       # Static analysis only
make test          # Unit tests with coverage

# Use Docker
make docker-all    # Run all stages in Docker
make docker-lint   # Run lint in Docker
make docker:test   # Run tests in Docker
```

### Using Docker Compose

```bash
# Run all stages
docker-compose up --build pipeline

# Run individual stages
docker-compose up --build lint
docker-compose up --build analyze
docker-compose up --build test
```

### Using Git Hook

```bash
# Setup pre-commit hook
cp .git/hooks/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

# Now 'git commit' will run the pipeline automatically
```

## Architecture

### Multi-Stage Docker Build

The Dockerfile uses a multi-stage build with separate layers:

```
┌─────────────────────────────────────┐
│  Base Stage (Ubuntu 22.04)          │
│  - Flutter SDK                      │
│  - Dependencies                     │
└─────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────┐
│  Lint Stage                          │
│  - Format check                     │
└─────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────┐
│  Analyze Stage                       │
│  - Static analysis                  │
└─────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────┐
│  Test Stage                          │
│  - Unit tests with coverage         │
└─────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────┐
│  Pipeline Stage                      │
│  - Runs all stages sequentially      │
└─────────────────────────────────────┘
```

## Configuration

### Environment Variables

- `COVERAGE_THRESHOLD`: Minimum code coverage percentage (default: 80)
- `FLUTTER_SDK_PATH`: Custom Flutter SDK path (optional)

### Coverage Threshold

```bash
# Set custom coverage threshold
export COVERAGE_THRESHOLD=85
make all
```

## Security Considerations

- **No secrets**: The pipeline does not handle secrets or API keys
- **Volume mounts**: Docker volumes are mounted read-write for development
- **Coverage reports**: Uploaded as artifacts (not secrets)
- **Flutter SDK**: Installed during build, not stored persistently

## Integration with CI

The local pipeline uses the same commands as the GitHub Actions CI workflow:

- **Lint**: `flutter format --set-exit-if-changed .`
- **Analyze**: `flutter analyze`
- **Test**: `flutter test --no-pub --coverage`

This ensures consistency between local development and CI/CD.

## Testing

Tests are included to verify the pre-commit hook functionality:

```bash
# Run pre-commit hook tests
flutter test test/pre_commit_hook_test.dart
```

## Related Files

- `Dockerfile` - Multi-stage Docker build
- `docker-compose.yml` - Docker Compose configuration
- `Makefile` - Easy local execution
- `.pre-commit-config.yaml` - Pre-commit hooks configuration
- `.git/hooks/pre-commit` - Git pre-commit hook script
- `.github/workflows/local-docker-ci.yml` - GitHub Actions for local CI
- `LOCAL_CI.md` - Full documentation

## Troubleshooting

### Flutter not found

```bash
# Add Flutter to PATH
export PATH=/path/to/flutter/bin:$PATH
```

### Coverage report not found

```bash
# Ensure test coverage is enabled
flutter test --no-pub --coverage
```

## Best Practices

1. **Use Docker for consistency**: Ensures same environment as CI
2. **Run hooks before committing**: Catches issues early
3. **Check coverage regularly**: Maintain code quality
4. **Use make targets**: Simplifies command execution
5. **Document failures**: If tests fail, document why

## License

MIT
