# Local CI/CD Pipeline Documentation

This document describes how to run the OpenCloset CI/CD pipeline locally using Docker.

## Overview

The local CI/CD pipeline uses a multi-stage Docker build with separate layers for:
- **Lint**: Format and style checking
- **Analyze**: Static analysis and dependency checking
- **Test**: Unit tests with coverage reporting
- **Pipeline**: Runs all stages sequentially

## Quick Start

### Using Make (Recommended)

```bash
# Run all stages
make all

# Run individual stages
make lint          # Format check
make analyze       # Static analysis
make test          # Unit tests

# Use Docker
make docker:all    # Run all stages in Docker
make docker:lint   # Run lint in Docker
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

# Rebuild without dependencies
docker-compose up --build --no-deps pipeline
```

### Using Git Hook

```bash
# Setup pre-commit hook
cp .git/hooks/pre-commit.example .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

# Or install pre-commit
pre-commit install

# Now 'git commit' will run the pipeline automatically
```

## Docker Usage

### Build Docker Image

```bash
docker build -t opencloset-ci:latest .
```

### Run Stages

```bash
# Lint stage
docker run --rm -v $PWD:/workspace opencloset-ci:latest sh -c "flutter pub get && flutter format --set-exit-if-changed ."

# Analyze stage
docker run --rm -v $PWD:/workspace opencloset-ci:latest sh -c "flutter pub get && flutter analyze"

# Test stage
docker run --rm -v $PWD:/workspace opencloset-ci:latest sh -c "flutter pub get && flutter test --no-pub --coverage"
```

## Pre-commit Hook

### Manual Setup

```bash
# Copy the pre-commit script to hooks directory
cp .git/hooks/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

# Or create a symbolic link
ln -s .git/hooks/pre-commit .git/hooks/pre-commit
```

### Using pre-commit framework (Optional)

```bash
# Install pre-commit
pip install pre-commit

# Initialize hooks
pre-commit install

# Or run hooks manually
pre-commit run --all-files
```

## Integration with CI

The local pipeline uses the same commands as the GitHub Actions CI workflow:

- **Lint**: `flutter format --set-exit-if-changed .`
- **Analyze**: `flutter analyze`
- **Test**: `flutter test --no-pub --coverage`

This ensures consistency between local development and CI/CD.

## Environment Variables

### Coverage Threshold

```bash
# Set custom coverage threshold
export COVERAGE_THRESHOLD=85
make all
```

### Flutter SDK Path

```bash
# Specify custom Flutter SDK location
export FLUTTER_SDK_PATH=/path/to/flutter
make all
```

## Troubleshooting

### Issue: Flutter not found

```bash
# Add Flutter to PATH
export PATH=/path/to/flutter/bin:$PATH
```

### Issue: Permission denied on volume mount

```bash
# On macOS, ensure Docker can access the project directory
# Add project directory to Docker's shared volumes
```

### Issue: Coverage report not found

```bash
# Ensure test coverage is enabled
flutter test --no-pub --coverage
```

## Architecture

The Dockerfile uses a multi-stage build:

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

## Security Considerations

- Docker volumes are mounted read-write for development
- For production CI, consider using read-only mounts
- No secrets or API keys are required for the pipeline
- Coverage reports are uploaded as artifacts (not secrets)

## Best Practices

1. **Use Docker for consistency**: Ensures same environment as CI
2. **Run hooks before committing**: Catches issues early
3. **Check coverage regularly**: Maintain code quality
4. **Use make targets**: Simplifies command execution
5. **Document failures**: If tests fail, document why

## Related Files

- `Dockerfile` - Multi-stage Docker build
- `docker-compose.yml` - Docker Compose configuration
- `Makefile` - Easy local execution
- `.pre-commit-config.yaml` - Pre-commit hooks configuration
- `.git/hooks/pre-commit` - Git pre-commit hook script
- `.github/workflows/local-docker-ci.yml` - GitHub Actions for local CI
- `LOCAL_CI.md` - This documentation
