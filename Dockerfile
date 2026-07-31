# Dockerfile for OpenCloset Local CI/CD Pipeline
# Multi-stage build with separate layers for lint, analyze, and test stages

# =============================================================================
# Stage 1: Base Setup (Shared by all stages)
# =============================================================================
FROM ubuntu:22.04 AS base

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV FLUTTER_VERSION=stable
ENV PATH="$PATH:/root/flutter/bin"

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    make \
    pkg-config \
    libglu1-mesa \
    libgtk-3-dev \
    libx11-dev \
    libx11-xcb-dev \
    libxrandr-dev \
    libxcomposite-dev \
    libxext-dev \
    libxi-dev \
    libxtst-dev \
    libxss-dev \
    libasound2-dev \
    libudev-dev \
    libdrm-dev \
    libxshmfence-dev \
    libegl1-mesa-dev \
    libxkbcommon-x11-dev \
    libwayland-dev \
    libatspi2.0-dev \
    libnss3-dev \
    libglib2.0-dev \
    libxkbcommon-dev \
    libvulkan-dev \
    libx11-dev \
    libx11-xcb-dev \
    libxrandr-dev \
    libxcomposite-dev \
    libxext-dev \
    libxi-dev \
    libxtst-dev \
    libxss-dev \
    libasound2-dev \
    libudev-dev \
    libdrm-dev \
    libxshmfence-dev \
    libegl1-mesa-dev \
    libxkbcommon-x11-dev \
    libwayland-dev \
    libatspi2.0-dev \
    libnss3-dev \
    libglib2.0-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter
RUN curl -fsSL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.0-stable.tar.xz | \
    tar -xf - -C /root/flutter --strip-components=1

# =============================================================================
# Stage 2: Lint Stage
# =============================================================================
FROM base AS lint

WORKDIR /workspace

# Install dependencies
RUN flutter pub get

# Run lint checks
CMD ["flutter", "format", "--set-exit-if-changed", "."]

# =============================================================================
# Stage 3: Analyze Stage
# =============================================================================
FROM base AS analyze

WORKDIR /workspace

# Install dependencies
RUN flutter pub get

# Run analysis
CMD ["flutter", "analyze"]

# =============================================================================
# Stage 4: Test Stage
# =============================================================================
FROM base AS test

WORKDIR /workspace

# Install dependencies
RUN flutter pub get

# Run tests with coverage
CMD ["flutter", "test", "--no-pub", "--coverage"]

# =============================================================================
# Stage 5: Full Pipeline (All stages)
# =============================================================================
FROM base AS pipeline

WORKDIR /workspace

# Install dependencies
RUN flutter pub get

# Create a script to run all stages sequentially
RUN echo '#!/bin/bash' > /run-pipeline.sh && \
    echo 'set -e' >> /run-pipeline.sh && \
    echo 'echo "=== Running Lint ==="' >> /run-pipeline.sh && \
    echo 'flutter format --set-exit-if-changed .' >> /run-pipeline.sh && \
    echo 'echo "=== Running Analyze ==="' >> /run-pipeline.sh && \
    echo 'flutter analyze' >> /run-pipeline.sh && \
    echo 'echo "=== Running Tests ==="' >> /run-pipeline.sh && \
    echo 'flutter test --no-pub --coverage' >> /run-pipeline.sh && \
    echo 'echo "=== All stages completed successfully ==="' >> /run-pipeline.sh && \
    chmod +x /run-pipeline.sh

CMD ["/run-pipeline.sh"]
