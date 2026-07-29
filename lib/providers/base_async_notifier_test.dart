/// Tests for [AsyncNotifier<T>] and [AsyncState<T>] classes.
///
/// Tests verify that the async notifier correctly handles the three states:
/// loading, data, and error.

import 'package:flutter_test/flutter_test.dart';
import 'base_async_notifier.dart' as async_notifier;

/// Helper to assert that a future throws an exception.
Future<void> expectThrowsThrowsError(Future<void> future) async {
  try {
    await future;
    fail('Expected Future to throw but it did not');
  } catch (_) {
    // Expected
  }
}

/// Test provider that extends [async_notifier.AsyncNotifier] and provides a simple load implementation.
/// Used to test the async notifier behavior in a controlled environment.
class _TestDataProvider extends async_notifier.AsyncNotifier<String> {
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

@override
async_notifier.AsyncState<String> build() =>
      async_notifier.AsyncState.loading();
}

void main() {
test('AsyncState.loading() creates a loading state', () {
    final state = async_notifier.AsyncState.loading();

    expect(state.loading, isTrue);
    expect(state.error, isFalse);
    expect(state.data, isFalse);
    expect(state.loadedData, null);
    expect(state.loadedError, null);
  });

  test('AsyncState.data(value) creates a data state', () {
    const String value = 'test-data';
    final state = async_notifier.AsyncState.data(value);

    expect(state.loading, isFalse);
    expect(state.error, isFalse);
    expect(state.data, isTrue);
    expect(state.loadedData, value);
    expect(state.loadedError, null);
  });

  test('AsyncState.error(error, stackTrace) creates an error state', () {
    const Exception error = Exception('Simulated error');
    final stackTrace = StackTrace();
    final state = async_notifier.AsyncState.error(error, stackTrace);
    
    expect(state.loading, isFalse);
    expect(state.error, isTrue);
    expect(state.data, isFalse);
    expect(state.loadedData, null);
    expect(state.loadedError, error);
    expect(state.stackTrace, stackTrace);
  });

 }
