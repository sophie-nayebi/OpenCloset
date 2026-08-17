# Dockerfile for OpenCloset Local CI/CD Pipeline
# Multi-stage build with shared base image for lint, analyze, and test stages

FROM ubuntu:22.04 AS base

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV FLUTTER_VERSION=stable
ENV PATH="/root/flutter/bin:$PATH"
ENV FLUTTER_ROOT=/root/flutter

# Install system dependencies
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
    && rm -rf /var/lib/apt/lists/*

# Install Flutter
RUN apt-get update && apt-get install -y --no-install-recommends wget \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /root/flutter /root/.pub-cache /tmp/flutter.tar.xz \
    && wget -q --show-progress https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.0-stable.tar.xz -O /tmp/flutter.tar.xz \
    && tar -xf /tmp/flutter.tar.xz -C /root --strip-components=1 \
    && rm /tmp/flutter.tar.xz

# =============================================================================
# Stage: Lint Stage
# =============================================================================
FROM base AS lint
WORKDIR /workspace
RUN $FLUTTER_ROOT/bin/flutter pub get
CMD $FLUTTER_ROOT/bin/flutter format --set-exit-if-changed .

# =============================================================================
# Stage: Analyze Stage
# =============================================================================
FROM base AS analyze
WORKDIR /workspace
RUN $FLUTTER_ROOT/bin/flutter pub get
CMD $FLUTTER_ROOT/bin/flutter analyze --no-fatal-infos

# =============================================================================
# Stage: Test Stage
# =============================================================================
FROM base AS test
WORKDIR /workspace
RUN $FLUTTER_ROOT/bin/flutter pub get
CMD $FLUTTER_ROOT/bin/flutter test --no-pub --coverage

# =============================================================================
# Stage: Full Pipeline (All stages)
# =============================================================================
FROM base AS pipeline
WORKDIR /workspace
RUN $FLUTTER_ROOT/bin/flutter pub get
# Create a script to run all stages sequentially
RUN echo '#!/bin/bash' > /run-pipeline.sh && \
    echo 'set -e' >> /run-pipeline.sh && \
    echo 'echo "=== Running Lint ==="' >> /run-pipeline.sh && \
    echo '$FLUTTER_ROOT/bin/flutter format --set-exit-if-changed .' >> /run-pipeline.sh && \
    echo 'echo "=== Running Analyze ==="' >> /run-pipeline.sh && \
    echo '$FLUTTER_ROOT/bin/flutter analyze --no-fatal-infos' >> /run-pipeline.sh && \
    echo 'echo "=== Running Tests ==="' >> /run-pipeline.sh && \
    echo '$FLUTTER_ROOT/bin/flutter test --no-pub --coverage' >> /run-pipeline.sh && \
    echo 'echo "=== All stages completed successfully ==="' >> /run-pipeline.sh && \
    chmod +x /run-pipeline.sh
CMD ["/run-pipeline.sh"]
