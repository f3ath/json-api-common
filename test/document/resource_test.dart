import 'dart:convert';

import 'package:json_api_common/document.dart';
import 'package:test/test.dart';

void main() {
  group('Resource', () {
    test('Decode from minimal JSON', () {
      final json = {'type': 'test_type', 'id': 'test_id'};
      final r = Resource.fromJson(json);
      expect(r.type, 'test_type');
      expect(r.id, 'test_id');
      expect(r.attributes, isEmpty);
      expect(r.relationships, isEmpty);
      expect(r.meta, isEmpty);
      expect(jsonDecode(jsonEncode(r)), json);
    });
    test('Decode from complete JSON', () {
      final json = {
        'type': 'test_type',
        'id': 'test_id',
        'attributes': {'foo': 42},
        'relationships': {
          'rel': {
            'data': {'type': 'rel_type', 'id': 'rel_id'}
          }
        },
        'meta': {'bar': true},
      };
      final r = Resource.fromJson(json);
      expect(r.type, 'test_type');
      expect(r.id, 'test_id');
      expect(r.attributes['foo'], 42);
      expect((r.relationships['rel'] as One).identifier!.id, 'rel_id');
      expect(r.meta['bar'], isTrue);
      expect(jsonDecode(jsonEncode(r)), json);
    });
    test('Decode from invalid JSON', () {
      expect(() => Resource.fromJson(null), throwsFormatException);
      expect(() => Resource.fromJson({}), throwsFormatException);
      expect(() => Resource.fromJson({'id': []}), throwsFormatException);
      expect(() => Resource.fromJson({'type': []}), throwsFormatException);
    });
  });
}
