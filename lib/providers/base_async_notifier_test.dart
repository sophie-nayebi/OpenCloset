/// Tests for [AsyncNotifier<T>] and [AsyncState<T>] classes.
///
/// Tests verify that the async notifier correctly handles the three states:
/// loading, data, and error.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import '../base_async_notifier.dart';

/// Helper to assert that a future throws an exception.
void expectThrowsThrowsError(Future<void> future) async {
  await expectAsync(() => future).throwsException;
}

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

  test('AsyncNotifier transitions loading → data states', () async {
    final notifier = _TestDataProvider();
    expect(notifier.state.loading, isTrue); // initial state
    
    final data = await notifier.load();
    expect(notifier.state.loading, isFalse);
    expect(notifier.state.data, isTrue);
    expect(notifier.state.loadedData, 'test-data');
  });

  test('AsyncNotifier transitions to error on exception', () async {
    final notifier = _TestDataProvider();
    notifier.setShouldFail(true);
    
    await expectThrowsThrowsError(notifier.load());
    expect(notifier.state.error, isTrue);
  });
}
