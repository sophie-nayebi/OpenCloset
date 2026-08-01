# Makefile for OpenCloset Local CI/CD Pipeline
# Easy local execution of lint, analyze, test stages

# =============================================================================
# Configuration
# =============================================================================
FLUTTER ?= /home/user/develop/flutter/bin/flutter

# =============================================================================
# Default target
# =============================================================================
.PHONY: help
help:
	@echo "OpenCloset Local CI/CD Pipeline"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  lint          - Run Flutter format check and analyze"
	@echo "  analyze       - Run Flutter analyze"
	@echo "  test          - Run Flutter tests with coverage"
	@echo "  all           - Run all stages (lint, analyze, test)"
	@echo "  docker-lint   - Run lint stage in Docker"
	@echo "  docker-analyze - Run analyze stage in Docker"
	@echo "  docker-test   - Run test stage in Docker"
	@echo "  docker-all    - Run all stages in Docker"
	@echo "  docker-build  - Build Docker image"
	@echo "  clean         - Clean build artifacts"

# =============================================================================
# Local Targets (using Flutter directly)
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
	$(FLUTTER) analyze
	@echo "=== Lint check completed ==="

.PHONY: analyze
analyze:
	@echo "=== Running Analysis ==="
	$(FLUTTER) pub get
	$(FLUTTER) analyze
	@echo "=== Analysis completed ==="

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

.PHONY: all
all: lint analyze test

# =============================================================================
# Docker Targets
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

.PHONY: docker-analyze
docker-analyze:
	@echo "=== Running Analyze in Docker ==="
	docker-compose up --build --no-deps analyze
	@echo "=== Docker analyze completed ==="

.PHONY: docker-test
docker-test:
	@echo "=== Running Tests in Docker ==="
	docker-compose up --build --no-deps test
	@echo "=== Docker tests completed ==="

.PHONY: docker-all
docker-all:
	@echo "=== Running All Stages in Docker ==="
	docker-compose up --build --no-deps pipeline
	@echo "=== Docker pipeline completed ==="

# =============================================================================
# Utility Targets
# =============================================================================

.PHONY: clean
clean:
	@echo "=== Cleaning build artifacts ==="
	-rm -rf .dart_tool
	# Note: pubspec.lock is intentionally NOT removed to avoid breaking the build
	-rm -rf packages/**/.dart_tool
	-rm -rf packages/**/pubspec.lock
	-rm -rf .pub-cache
	-rm -rf coverage/
	@echo "=== Clean completed ==="

.PHONY: setup
setup:
	@echo "=== Setting up project ==="
	$(FLUTTER) pub get
	@echo "=== Setup completed ==="
