/// Test file for OpenCloset database connection.

import 'package:opencloset/packages/database/lib/database.dart';
import 'package:test/test.dart';

void main() {
  group('OpenClosetDatabase', () {
    late OpenClosetDatabase database;

    setUp(() {
      database = OpenClosetDatabase.createForTesting();
    });

    tearDown(() async {
      await database.close();
    });

    test('creates with platform detection', () {
      expect(database, isA<OpenClosetDatabase>());
      expect(database.schemaVersion, equals(1));
    });

    test('detects native platform support', () {
      // For testing, all platforms are supported
      expect(database.isNative, isTrue());
      expect(database.isUnsupported, isFalse());
    });

    test('testing connection is independent', () {
      final testDb = OpenClosetDatabase.createForTesting();
      expect(testDb, isNot(database));
    });
  });
}
