/// Unsupported platform handling.
///
/// For any platform that doesn't support the CSV storage layer, provide
/// a graceful fallback or error handling mechanism.

/// Returns whether the current platform is unsupported.
bool isUnsupportedPlatform() {
  // For P0, all platforms are supported.
  return false;
}

/// Creates an error message for unsupported platforms.
String unsupportedPlatformError() {
  return 'CSV storage is not supported on this platform.';
}