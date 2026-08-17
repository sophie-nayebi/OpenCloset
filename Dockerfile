# Dockerfile for OpenCloset Local CI/CD Pipeline
# Multi-stage build with shared base image for lint, analyze, and test stages

FROM cirrusci/flutter:3.24.0 AS base

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PUBLISH_DIR=/publish

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
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

# =============================================================================
# Stage: Lint Stage
# =============================================================================
FROM base AS lint
WORKDIR /workspace
RUN flutter pub get
CMD flutter format --set-exit-if-changed .

# =============================================================================
# Stage: Analyze Stage
# =============================================================================
FROM base AS analyze
WORKDIR /workspace
RUN flutter pub get
CMD flutter analyze --no-fatal-infos

# =============================================================================
# Stage: Test Stage
# =============================================================================
FROM base AS test
WORKDIR /workspace
RUN flutter pub get
CMD flutter test --no-pub --coverage

# =============================================================================
# Stage: Full Pipeline (All stages)
# =============================================================================
FROM base AS pipeline
WORKDIR /workspace
RUN flutter pub get && \
    flutter format --set-exit-if-changed . && \
    flutter analyze --no-fatal-infos && \
    flutter test --no-pub --coverage
CMD ["echo", "Pipeline completed successfully"]
