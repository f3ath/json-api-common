import 'dart:convert';
import 'dart:io';

import 'package:json_api_common/document.dart';
import 'package:test/test.dart';

void main() {
  group('Errors', () {
    test('Minimal', () {
      final e = Document({
        'errors': [{}]
      }).errors().first;
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
    });
    test('Full', () {
      final error = {
        'id': 'test_id',
        'status': 'test_status',
        'code': 'test_code',
        'title': 'test_title',
        'detail': 'test_detail',
        'source': {'parameter': 'test_parameter', 'pointer': 'test_pointer'},
        'links': {'foo': '/bar'},
        'meta': {'foo': 42},
      };
      final e = Document({
        'errors': [error]
      }).errors().first;

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
    });

    test('Invalid', () {
      expect(
          () => Document({
                'errors': [
                  {'id': []}
                ]
              }).errors().first,
          throwsFormatException);
    });
  });

  test('Example', () {
    final json =
        jsonDecode(File('test/document/example.json').readAsStringSync());
    final doc = Document(json);
    expect(
        doc
            .asResourceCollection()
            .first
            .relationships['author']
            .links['self']
            .uri
            .toString(),
        'http://example.com/articles/1/relationships/author');
    expect(doc.included().first.attributes['firstName'], 'Dan');
  });
}
