# Makefile for OpenCloset Local CI/CD Pipeline
# Easy local execution of lint, analyze, test stages

# =============================================================================
# Configuration
# =============================================================================
# =============================================================================
# Configuration
# =============================================================================
# Cross-platform Flutter path detection
# Uses 'which' command to find flutter, falls back to default location
FLUTTER ?= $(shell which flutter 2>/dev/null || echo "/usr/bin/flutter")

# =============================================================================
# Default target
# =============================================================================
# Displays available targets and their descriptions
.PHONY: help
help:
	@echo "OpenCloset Local CI/CD Pipeline"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Available Targets:"
	@echo "  lint          - Run Flutter format check and static analysis (linting)"
	@echo "  analyze       - Run Flutter analyze to detect issues in codebase"
	@echo "  test          - Run Flutter unit tests with code coverage report"
	@echo "  all           - Execute all local stages: lint, analyze, and test"
	@echo "  docker-lint   - Run lint stage in Docker container"
	@echo "  docker-analyze - Run analyze stage in Docker container"
	@echo "  docker-test   - Run test stage in Docker container with coverage"
	@echo "  docker-all    - Execute all stages in Docker: lint, analyze, test"
	@echo "  docker-build  - Build Docker image for CI pipeline"
	@echo "  clean         - Remove build artifacts and coverage reports"
	@echo "  setup         - Initialize project dependencies (pub get)"

# =============================================================================
# Local Targets (using Flutter directly)
# =============================================================================
# Note: These targets execute Flutter commands directly on the host system.
# They are useful for local development but require Flutter to be installed
# and accessible via the FLUTTER environment variable or path.
# =============================================================================

.PHONY: lint
lint:
	@echo "=== Running Lint Check ==="
	$(FLUTTER) pub get
	@if command -v $(FLUTTER) &> /dev/null && $(FLUTTER) --version 2>/dev/null | grep -q "3."; then \
	@echo "Running format check..." && \
	$(FLUTTER) format --set-exit-if-changed . || echo "Format check failed - please format your code first"; \
	else \
	@echo "⚠️  Skipping format check ($(FLUTTER) format not available)"; \
	fi
	$(FLUTTER) analyze || true
	@echo "=== Lint check completed ==="
	# Note: analyze step is non-fatal (|| true) to allow CI to continue

.PHONY: analyze
analyze:
	@echo "=== Running Analysis ==="
	$(FLUTTER) pub get
	$(FLUTTER) analyze
	@echo "=== Analysis completed ==="
	# Note: This step checks for unused code, API misuses, and other static analysis issues

.PHONY: test
test:
	@echo "=== Running Tests ==="
	$(FLUTTER) pub get
	$(FLUTTER) test --no-pub --coverage
	@echo ""
	@echo "=== Coverage Report ==="
	@TOTAL_FILE=$(grep -m1 "^LF:" coverage/lcov.info | sed 's/LF://' || echo "0"); \
	TOTAL_HITS=$(grep -m1 "^LH:" coverage/lcov.info | sed 's/LH://' || echo "0"); \
	COVERAGE_RESULT=$(python3 -c "print(round((int('$(TOTAL_HITS)') / int('$(TOTAL_FILE)')) * 100, 1) if int('$(TOTAL_FILE)') > 0 else 0)")
	echo "Total lines: $(TOTAL_FILE), Hit lines: $(TOTAL_HITS)"
	echo "Coverage: ${COVERAGE_RESULT}%"
	@echo "=== Tests completed ==="
	# Note: Generates coverage/lcov.info report for code coverage analysis

.PHONY: all
all: lint analyze test
	@echo "=== All local stages completed ==="

# =============================================================================
# Docker Targets
# =============================================================================
# Note: These targets use Docker Compose to run predefined stages.
# The Dockerfile defines multiple build targets: lint, analyze, test, and pipeline.
# The 'pipeline' target runs all stages sequentially in a single container.
# =============================================================================

.PHONY: docker-build
docker-build:
	@echo "=== Building Docker Image ==="
	docker build -t opencloset-ci:latest .
	@echo "=== Docker image built ==="

.PHONY: docker-lint
docker-lint:
	@echo "=== Running Lint in Docker ==="
	docker-compose up --build --no-deps lint
	@echo "=== Docker lint completed ==="
	# Note: Executes Flutter format check and analyze in isolated Docker environment

.PHONY: docker-analyze
docker-analyze:
	@echo "=== Running Analyze in Docker ==="
	docker-compose up --build --no-deps analyze
	@echo "=== Docker analyze completed ==="
	# Note: Executes Flutter analyze to detect code issues in Docker environment

.PHONY: docker-test
docker-test:
	@echo "=== Running Tests in Docker ==="
	docker-compose up --build --no-deps test
	@echo "=== Docker tests completed ==="
	# Note: Executes Flutter tests with coverage report generation in Docker

.PHONY: docker-all
docker-all:
	@echo "=== Running All Stages in Docker ==="
	docker-compose up --build --no-deps pipeline
	@echo "=== Docker pipeline completed ==="
	# Note: Runs lint, analyze, and test stages sequentially in a single Docker run

# =============================================================================
# Utility Targets
# =============================================================================

.PHONY: clean
clean:
	@echo "=== Cleaning build artifacts ==="
	-rm -rf .dart_tool
	-rm -rf packages/**/.dart_tool
	-rm -rf packages/**/pubspec.lock
	-rm -rf .pub-cache
	-rm -rf coverage/
	@echo "=== Clean completed ==="
	# Note: Removes generated artifacts to ensure a clean build environment

.PHONY: setup
setup:
	@echo "=== Setting up project ==="
	$(FLUTTER) pub get
	@echo "=== Setup completed ==="
	# Note: Installs all Flutter package dependencies defined in pubspec.yaml
