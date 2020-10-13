import 'dart:convert';

import 'package:json_api_common/document.dart';
import 'package:test/test.dart';

void main() {
  group('NewResource', () {
    test('Decode from minimal JSON', () {
      final json = {'type': 'test_type'};
      final r = NewResource.fromJson(json);
      expect(r.type, 'test_type');
      expect(r.attributes, isEmpty);
      expect(r.relationships, isEmpty);
      expect(r.meta, isEmpty);
      expect(jsonDecode(jsonEncode(r)), json);
    });
    test('Decode from complete JSON', () {
      final json = {
        'type': 'test_type',
        'attributes': {'foo': 42},
        'relationships': {
          'rel': {
            'data': {'type': 'rel_type', 'id': 'rel_id'}
          }
        },
        'meta': {'bar': true},
      };
      final r = NewResource.fromJson(json);
      expect(r.type, 'test_type');
      expect(r.attributes['foo'], 42);
      expect((r.relationships['rel'] as One).identifier!.id, 'rel_id');
      expect(r.meta['bar'], isTrue);
      expect(jsonDecode(jsonEncode(r)), json);
    });
    test('Decode from invalid JSON', () {
      expect(() => NewResource.fromJson(null), throwsFormatException);
      expect(() => NewResource.fromJson({}), throwsFormatException);
      expect(() => NewResource.fromJson({'id': []}), throwsFormatException);
      expect(() => NewResource.fromJson({'type': []}), throwsFormatException);
    });
  });
}
