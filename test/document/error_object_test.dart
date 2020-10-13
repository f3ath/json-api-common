import 'dart:convert';

import 'package:json_api_common/document.dart';
import 'package:test/test.dart';

void main() {
  group('ErrorObject', () {
    test('Decode from minimal JSON', () {
      final e = ErrorObject.fromJson({});
      expect(e.id, '');
      expect(e.status, '');
      expect(e.code, '');
      expect(e.title, '');
      expect(e.detail, '');
      expect(e.source.parameter, '');
      expect(e.source.pointer, '');
      expect(e.source.isEmpty, true);
      expect(e.source.isNotEmpty, false);
      expect(e.links, isEmpty);
      expect(e.meta, isEmpty);

      expect(jsonEncode(e), '{}');
    });
    test('Decode from complete JSON', () {
      final json = {
        'id': 'test_id',
        'status': 'test_status',
        'code': 'test_code',
        'title': 'test_title',
        'detail': 'test_detail',
        'source': {'parameter': 'test_parameter', 'pointer': 'test_pointer'},
        'links': {'foo': '/bar'},
        'meta': {'foo': 42},
      };
      final e = ErrorObject.fromJson(json);
      expect(e.id, 'test_id');
      expect(e.status, 'test_status');
      expect(e.code, 'test_code');
      expect(e.title, 'test_title');
      expect(e.detail, 'test_detail');
      expect(e.source.parameter, 'test_parameter');
      expect(e.source.pointer, 'test_pointer');
      expect(e.source.isEmpty, false);
      expect(e.source.isNotEmpty, true);
      expect(e.links['foo'].toString(), '/bar');
      expect(e.meta['foo'], 42);
      expect(jsonEncode(e), jsonEncode(json));
    });

    test('Decode from invalid JSON', () {
      expect(() => ErrorObject.fromJson({'id': []}), throwsFormatException);
      expect(() => ErrorObject.fromJson({'source': 42}), throwsFormatException);
      expect(
              () => ErrorObject.fromJson({
            'source': {'pointer': 42}
          }),
          throwsFormatException);
      expect(() => ErrorObject.fromJson(null), throwsFormatException);
      expect(() => ErrorObject.fromJson(null), throwsFormatException);
    });
  });
}
