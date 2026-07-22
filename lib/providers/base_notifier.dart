/// Base class for synchronous providers.
///
/// Extends [Notifier<T>] from flutter_riverpod and provides a clean base
/// for any provider that manages synchronous state. Use this when your provider
/// needs to expose mutable state that is computed on demand (e.g., derived data,
/// filtered collections).
///
/// ## When to use
///
/// - State changes in response to user actions (e.g., toggling a filter)
/// - Computed/derived state from other providers
/// - Form state or editing state
///
/// ## Example
///
/// ```dart
/// class ThemeNotifier extends _$ThemeNotifier {
///   bool _isDark = false;
/// 
///   @override
///   bool build() => _isDark;
/// 
///   @override
///   void onChanged() {
///     state = !state; // immutable update
///   }
/// }
/// ```

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Base class for providers that manage synchronous state.
///
/// Subclasses override `build()` to return the current state and optionally
/// override `onChanged()` or `onDispose()` for side effects.
///
/// The `state` property provides an immutable update pattern: always assign
/// a new value rather than mutating existing state.
///
/// Example:
/// ```dart
/// class CounterNotifier extends _$CounterNotifier {
///   @override
///   int build() => _value;
/// 
///   @override
///   void onChanged() {
///     state = state + 1; // immutable update
///   }
/// }
/// ```
class BaseNotifier<T> extends Notifier<T> {
  /// Override this method to return the current state.
  ///
  /// This is the core method that determines the provider's value.
  /// The returned value becomes the provider's `state`.
  @override
  T build();
}
