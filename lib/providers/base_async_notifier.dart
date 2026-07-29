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
///   Future<T> build() async {
///     return await loadImplementation();
///   }
/// 
///   Future<T> load() async {
///     return await loadImplementation();
///   }
/// 
///   Future<T> loadImplementation() async {
///     return await fetchFromServer();
///   }
/// }
/// ```
abstract class AsyncNotifier<T> extends Notifier<AsyncState<T>> {
  /// Executes the load operation and updates the state.
  /// 
  /// Call this method to manually trigger a refresh of the data.
  /// The `load()` method will be called and the state will be updated based on
  /// the result.
  Future<AsyncState<T>> load() async {
    state = AsyncState.loading();
    try {
      final result = await loadImplementation();
      return state = AsyncState.data(result);
    } on Exception catch (e) {
      state = AsyncState.error(e, StackTrace.current);
      rethrow;
    }
  }

  /// Override this method to implement your data loading logic.
  /// Returns the loaded data of type `T`.
  /// 
  /// This is the core method that must be implemented by subclasses.
  Future<T> loadImplementation() async {
    throw UnimplementedError();
  }

  /// Override this method to return the current state.
  ///
  /// This is the core method that determines the provider's value.
  /// The returned value becomes the provider's `state`.
  @override
  AsyncState<T> build();
}

/// A state machine representing an async operation with three states.
///
/// This follows the "three-state pattern" for async operations, providing a
/// type-safe way to represent the different states of a loading operation.
class AsyncState<T> {
  final bool _isData;
  final bool _isError;
  final bool _isLoading;

  final T? _data;
  final Object? _error;
  final StackTrace? _stackTrace;

  const AsyncState._({
    required this._data,
    required this._error,
    required this._stackTrace,
    required this._isData,
    required this._isError,
    required this._isLoading,
  });

  /// A static constructor that creates a loading state.
  /// 
   /// Use this when the operation is currently in progress.
   /// 
   /// Example:
   /// ```dart
   /// final state = AsyncState.loading();
   /// ```
   factory AsyncState.loading() => AsyncState._(
     _data: null,
     _error: null,
     _stackTrace: null,
     _isData: false,
     _isError: false,
     _isLoading: true,
   );

  /// A static constructor that creates a data state with the loaded value.
  /// 
  /// Use this when the operation completed successfully.
  /// 
  /// Example:
  /// ```dart
  /// final state = AsyncState.data(user);
  /// ```
  factory AsyncState.data(T data) => AsyncState._(
    _data: data,
    _error: null,
    _stackTrace: null,
    _isData: true,
    _isError: false,
    _isLoading: false,
  );

  /// A static constructor that creates an error state with the error details.
  /// 
  /// Use this when the operation failed.
  /// 
  /// Example:
  /// ```dart
  /// final state = AsyncState.error(error, stackTrace);
  /// ```
  factory AsyncState.error(Object error, StackTrace stackTrace) => AsyncState._(
    _data: null,
    _error: error,
    _stackTrace: stackTrace,
    _isData: false,
    _isError: true,
    _isLoading: false,
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
  U when<T>({
    U Function()? loading,
    U Function(Object error, StackTrace stackTrace)? error,
    U Function(T)? data,
  }) {
    if (loading != null && _isLoading) return loading();
    if (error != null && _isError) return error(_error!, _stackTrace!);
    if (data != null && _isData) return data(_data!);
    throw UnsupportedError(
      'AsyncState ${_data != null ? 'data' : _isError ? 'error' : 'loading'} '
          'returned a null value for a provided callback',
    );
  }
}