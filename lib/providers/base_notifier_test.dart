/// Tests for [BaseNotifier<T] and its synchronous state management.
///
/// Tests verify that the notifier base class correctly handles:
/// - State immutability via assignment
/// - The build() method returns the initial state
/// - State updates via immutable assignment

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import '../base_notifier.dart';

/// Test provider that extends [BaseNotifier] and exposes mutable state.
/// Used to test the base notifier behavior in a controlled environment.
class _TestCounterNotifier extends BaseNotifier<int> {
  int _value = 0;

  @override
  int build() => _value;
}

void main() {
  test('build() returns initial state', () {
    final provider = Provider<_TestCounterNotifier>(_TestCounterNotifier());
    final value = provider.read();

    expect(value, 0);
  });

  test('state = newState updates state via immutable assignment', () {
    final notifier = _TestCounterNotifier();
    notifier.state = 10;

    expect(notifier.state, 10);
  });

  test('state immutability - value can be reassigned', () {
    final notifier = _TestCounterNotifier();
    notifier.state = 5;
    notifier.state = 10;
    notifier.state = 15;

    expect(notifier.state, 15);
  });

  test('state starts at default value (0)', () {
    final notifier = _TestCounterNotifier();
    
    expect(notifier.state, 0);
  });

  test('state updates are persistent', () {
    final notifier = _TestCounterNotifier();
    notifier.state = 42;
    
    expect(notifier.state, 42);
  });
}
