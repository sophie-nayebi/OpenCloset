/// Tests for [AsyncNotifier<T>] and [AsyncState<T>] classes.
///
/// Tests verify that the async notifier correctly handles the three states:
/// loading, data, and error.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import '../base_async_notifier.dart';

/// Test provider that extends [AsyncNotifier] and provides a simple load implementation.
/// Used to test the async notifier behavior in a controlled environment.
class _TestDataProvider extends AsyncNotifier<String> {
  late String _loadedData;
  bool _shouldFail = false;

  @override
  Future<String> loadImplementation() async {
    if (_shouldFail) {
      throw Exception('Simulated error');
    }
    _loadedData = 'test-data';
    return _loadedData;
  }

  void setShouldFail(bool value) {
    _shouldFail = value;
  }
}

void main() {
  test('AsyncState.loading() creates a loading state', () {
    final state = AsyncState.loading();

    expect(state.loading, isTrue);
    expect(state.error, isFalse);
    expect(state.data, isFalse);
    expect(state.loadedData, null);
    expect(state.loadedError, null);
  });

  test('AsyncState.data(value) creates a data state', () {
    const String value = 'test-data';
    final state = AsyncState.data(value);

    expect(state.loading, isFalse);
    expect(state.error, isFalse);
    expect(state.data, isTrue);
    expect(state.loadedData, value);
    expect(state.loadedError, null);
  });

  test('AsyncState.error(e, st) creates an error state', () {
    const Exception error = Exception('Simulated error');
    final stackTrace = StackTrace();
    final state = AsyncState.error(error, stackTrace);

    expect(state.loading, isFalse);
    expect(state.error, isTrue);
    expect(state.data, isFalse);
    expect(state.loadedData, null);
    expect(state.loadedError, error);
    expect(state.stackTrace, stackTrace);
  });

  test('AsyncState.loading().loading returns true', () {
    const AsyncState<String> loadingState = AsyncState.loading();
    expect(loadingState.loading, isTrue);
  });

  test('AsyncState.loading().data returns false', () {
    const AsyncState<String> loadingState = AsyncState.loading();
    expect(loadingState.data, isFalse);
  });

  test('AsyncState.loading().error returns false', () {
    const AsyncState<String> loadingState = AsyncState.loading();
    expect(loadingState.error, isFalse);
  });
}
