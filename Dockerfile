# Dockerfile for OpenCloset Local CI/CD Pipeline
# Multi-stage build with shared base image for lint, analyze, and test stages

FROM ubuntu:24.04 AS base

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PUBLISH_DIR=/publish

# Install Flutter and dependencies
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
    wget \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.0-stable.tar.xz -o /tmp/flutter.tar.xz \
    && tar -xf /tmp/flutter.tar.xz -C /root --strip-components=1 \
    && rm /tmp/flutter.tar.xz \
    && /root/flutter/bin/flutter config --no-analytics \
    && /root/flutter/bin/flutter precache --release --verbose

# =============================================================================
# Stage: Lint Stage
# =============================================================================
FROM base AS lint
WORKDIR /workspace
RUN /root/flutter/bin/flutter pub get
CMD /root/flutter/bin/flutter format --set-exit-if-changed .

# =============================================================================
# Stage: Analyze Stage
# =============================================================================
FROM base AS analyze
WORKDIR /workspace
RUN /root/flutter/bin/flutter pub get
CMD /root/flutter/bin/flutter analyze --no-fatal-infos

# =============================================================================
# Stage: Test Stage
# =============================================================================
FROM base AS test
WORKDIR /workspace
RUN /root/flutter/bin/flutter pub get
CMD /root/flutter/bin/flutter test --no-pub --coverage

# =============================================================================
# Stage: Full Pipeline (All stages)
# =============================================================================
FROM base AS pipeline
WORKDIR /workspace
RUN /root/flutter/bin/flutter pub get && \
    /root/flutter/bin/flutter format --set-exit-if-changed . && \
    /root/flutter/bin/flutter analyze --no-fatal-infos && \
    /root/flutter/bin/flutter test --no-pub --coverage
CMD ["echo", "Pipeline completed successfully"]
