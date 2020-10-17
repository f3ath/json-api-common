import 'dart:convert';

import 'package:json_api_common/document.dart';
import 'package:test/test.dart';

void main() {
  group('Identifier', () {
    test('Minimal', () {
      expect(jsonEncode(Identifier('test_type', 'test_id')),
          jsonEncode({'type': 'test_type', 'id': 'test_id'}));
    });
    test('Full', () {
      expect(
          jsonEncode(Identifier('test_type', 'test_id', meta: {'foo': []})),
          jsonEncode({
            'type': 'test_type',
            'id': 'test_id',
            'meta': {'foo': []}
          }));
    });
  });
}
