/// Base class for providers that load data asynchronously.
/// 
/// Provides a consistent three-state pattern (loading/error/data) for any
/// feature that needs to fetch data. Extend this class when your provider needs
/// to handle async data loading, such as fetching from a network or database.
/// 
/// Usage:
/// ```dart
/// class UserProvider extends _$UserProvider {
///   @override
///   AsyncState<User?> build() => AsyncState.loading();
/// 
///   @override
///   Future<void> refresh() async {
///     final user = await _userService.fetchUser();
///     state = AsyncState.data(user);
///   }
/// }
/// 
/// // Subscribe in your widget:
/// final userProvider = UserProvider();
/// final user = userProvider.read();
/// user.when(
///   loading: () => const CircularProgressIndicator(),
///   error: (e, _) => Text('Error: $e'),
///   data: (user) => Text(user?.name ?? 'No user'),
/// );
/// ```

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Three-state pattern for async operations.
///
/// Represents the state of an async operation with three possible states:
/// - **loading**: The operation is in progress
/// - **error**: The operation failed
/// - **data**: The operation completed successfully with a value

/// Generic type parameter:
/// - `T` is the data type returned on success

/// Usage in a Notifier:
/// ```dart
/// class FetchDataProvider extends AsyncNotifier<T> {
///   @override
///   Future<T> load() async {
///     return await fetchFromServer();
///   }
/// 
///   @override
///   void onLoad() => state = AsyncState.loading();
/// 
///   @override
///   void onError() => state = AsyncState.error(exception, stackTrace);
/// }
/// ```
class AsyncNotifier<T> extends Notifier<AsyncState<T>> {
  /// Executes the load operation and updates the state.
  /// 
  /// Call this method to manually trigger a refresh of the data.
  /// The `load()` method will be called and the state will be updated based on
  /// the result.
  Future<T> load() async {
    state = AsyncState.loading();
    try {
      final result = await loadImplementation();
      return state = AsyncState.data(result);
    } on Exception catch (e) {
      state = AsyncState.error(e, stackTrace);
      rethrow;
    }
  }

  /// Override this method to implement your data loading logic.
  /// Returns the loaded data of type `T`.
  /// 
  /// This is the core method that must be implemented by subclasses.
  abstract Future<T> loadImplementation();
}

/// A state machine representing an async operation with three states.
///
/// This follows the "three-state pattern" for async operations, providing a
/// type-safe way to represent the different states of a loading operation.
class AsyncState<T> {
  final _isData = _data != null;
  final _isError = _error != null;
  final _isLoading = _data == null && _error == null;

  final T? _data;
  final Object? _error;
  final StackTrace? _stackTrace;

  const AsyncState._({
    this._data,
    this._error,
    this._stackTrace,
  });

  /// A static constructor that creates a loading state.
  /// 
  /// Use this when the operation is currently in progress.
  /// 
  /// Example:
  /// ```dart
  /// final state = AsyncState.loading();
  /// ```
  factory AsyncState.loading() => const AsyncState._();

  /// A static constructor that creates a data state with the loaded value.
  /// 
  /// Use this when the operation completed successfully.
  /// 
  /// Example:
  /// ```dart
  /// final state = AsyncState.data(user);
  /// ```
  factory AsyncState.data(T data) => AsyncState._(data: data);

  /// A static constructor that creates an error state with the error details.
  /// 
  /// Use this when the operation failed.
  /// 
  /// Example:
  /// ```dart
  /// final state = AsyncState.error(error, stackTrace);
  /// ```
  factory AsyncState.error(Object error, StackTrace stackTrace) => AsyncState._(
    error: error,
    stackTrace: stackTrace,
  );

  /// Returns true if the state represents loading.
  bool get loading => _isLoading;

  /// Returns true if the state represents an error.
  bool get error => _isError;

  /// Returns true if the state represents data.
  bool get data => _isData;

  /// The loaded data, or null if the state is not data.
  T? get loadedData => _data;

  /// The error value, or null if the state is not error.
  Object? get loadedError => _error;

  /// The stack trace, or null if the state is not error.
  StackTrace? get stackTrace => _stackTrace;

  /// Maps the state to a value of type `U`.
  /// 
  /// Call this method to perform a different operation based on the current
  /// state of the async operation. This is a type-safe way to handle all
  /// three states without casting.
  /// 
  /// Example:
  /// ```dart
  /// final user = userProvider.read().when(
  ///   loading: () => CircularProgressIndicator(),
  ///   error: (e, stackTrace) => ErrorDialog(error: e, stackTrace: stackTrace),
  ///   data: (user) => UserCard(user: user!),
  /// );
  /// ```
  U when<T>(
    {
      U? loading,
      U? error,
      U? data,
    }) {
    if (loading != null && _isLoading) return loading;
    if (error != null && _isError) return error;
    if (data != null && _isData) return data;
    throw UnreachableError(
      'AsyncState ${_data != null ? 'data' : _isError ? 'error' : 'loading'} '
          'returned a null value for a provided callback',
    );
  }
}