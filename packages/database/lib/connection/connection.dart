/// Platform-specific database connection factory.
///
/// This module uses conditional exports to expose the right connection factory
/// depending on the platform (native vs web).
///
/// On native platforms (iOS, Android, Linux, macOS, Windows), this delegates
/// to native.dart which uses file-based SQLite storage.
/// On web platforms, this delegates to web.dart which uses in-memory storage.
/// On unsupported platforms, this delegates to unsupported.dart which throws.

export 'unsupported.dart'
    if (dart.library.js_interop) 'web.dart'
    if (dart.library.ffi) 'native.dart';
