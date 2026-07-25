/// Unsupported platform database connection implementation.
///
/// This module throws a [StateError] for platforms that are not supported
/// by OpenCloset's database layer.

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

/// Throws an error for unsupported platforms.
///
/// This is the fallback for any platform that is neither native nor web.
/// Such platforms should not exist with the current OpenCloset architecture.
DriftDatabase create() {
  throw StateError('Database not supported on this platform.');
}

/// Returns whether the current platform is a native platform.
bool isNative() {
  return false;
}

/// Returns whether the current platform is unsupported.
bool isUnsupported() {
  return true;
}

/// Creates an in-memory database connection for testing.
DriftDatabase createForTesting() {
  return driftDatabase(name: 'opencloset.db');
}
