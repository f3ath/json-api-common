import 'dart:convert';

import 'package:json_api_common/document.dart';
import 'package:test/test.dart';

void main() {
  group('Identifier', () {
    test('Decode from minimal JSON', () {
      final json = {'id': 'test_id', 'type': 'test_type'};
      final id = Identifier.fromJson(json);

      expect(id.id, 'test_id');
      expect(id.type, 'test_type');
      expect(id.meta, isEmpty);
      expect(jsonDecode(jsonEncode(id)), json);
    });
    test('Decode from complete JSON', () {
      final json = {
        'id': 'test_id',
        'type': 'test_type',
        'meta': {'foo': []}
      };
      final id = Identifier.fromJson(json);

      expect(id.id, 'test_id');
      expect(id.type, 'test_type');
      expect(id.meta['foo'], []);
      expect(jsonDecode(jsonEncode(id)), json);
    });
    test('Decode from invalid JSON', () {
      expect(() => Identifier.fromJson(null), throwsFormatException);
      expect(() => Identifier.fromJson({}), throwsFormatException);
      expect(() => Identifier.fromJson({'id': []}), throwsFormatException);
      expect(
          () => Identifier.fromJson(
              {'id': 'test_id', 'type': 'test_type', 'meta': 42}),
          throwsFormatException);
    });
  });
}
