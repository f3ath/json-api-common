import 'dart:convert';
import 'dart:io';

import 'package:json_api_common/document.dart';
import 'package:test/test.dart';

void main() {
  group('Document', () {
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

    group('Parsing', () {
      Map readMock(String name) =>
          jsonDecode(File('test/document/json/$name.json').readAsStringSync());
      final example = readMock('example');
      final resource = readMock('resource');
      final newResource = readMock('new-resource');
      final relatedEmpty = readMock('related-empty');
      final one = readMock('rel-one');
      final oneEmpty = readMock('rel-one-empty');
      final many = readMock('rel-many');
      final manyEmpty = readMock('rel-many-empty');

      test('can parse the standard example', () {
        final doc = Document(example);
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
        expect(doc.links()['self'].toString(), 'http://example.com/articles');
        expect(doc.meta(), isEmpty);
      });

      test('can parse primary resource', () {
        final doc = Document(resource);
        final article = doc.asResource();
        expect(article.id, '1');
        expect(article.attributes['title'], 'JSON:API paints my bikeshed!');
        expect(article.relationships['author'], isA<IncompleteRelationship>());
        expect(doc.included(), isEmpty);
        expect(doc.links()['self'].toString(), 'http://example.com/articles/1');
        expect(doc.meta(), isEmpty);
      });

      test('can parse a new resource', () {
        final doc = Document(newResource);
        final article = doc.asNewResource();
        expect(article.attributes['title'], 'A new article');
        expect(doc.included(), isEmpty);
        expect(doc.links(), isEmpty);
        expect(doc.meta(), isEmpty);
      });

      test('can parse related resource', () {
        final doc = Document(relatedEmpty);
        expect(doc.asResourceOrNull(), isNull);
        expect(doc.included(), isEmpty);
        expect(doc.links()['self'].toString(),
            'http://example.com/articles/1/author');
        expect(doc.meta(), isEmpty);
      });

      test('can parse to-one', () {
        final doc = Document(one);
        expect(doc.asRelationship(), isA<One>());
        expect(doc.asRelationship(), isNotEmpty);
        expect(doc.asRelationship().first.type, 'people');
        expect(doc.included(), isEmpty);
        expect(
            doc.links()['self'].toString(), '/articles/1/relationships/author');
        expect(doc.meta(), isEmpty);
      });

      test('can parse empty to-one', () {
        final doc = Document(oneEmpty);
        expect(doc.asRelationship(), isA<One>());
        expect(doc.asRelationship(), isEmpty);
        expect(doc.included(), isEmpty);
        expect(
            doc.links()['self'].toString(), '/articles/1/relationships/author');
        expect(doc.meta(), isEmpty);
      });

      test('can parse to-many', () {
        final doc = Document(many);
        expect(doc.asRelationship(), isA<Many>());
        expect(doc.asRelationship(), isNotEmpty);
        expect(doc.asRelationship().first.type, 'tags');
        expect(doc.included(), isEmpty);
        expect(
            doc.links()['self'].toString(), '/articles/1/relationships/tags');
        expect(doc.meta(), isEmpty);
      });

      test('can parse empty to-many', () {
        final doc = Document(manyEmpty);
        expect(doc.asRelationship(), isA<Many>());
        expect(doc.asRelationship(), isEmpty);
        expect(doc.included(), isEmpty);
        expect(
            doc.links()['self'].toString(), '/articles/1/relationships/tags');
        expect(doc.meta(), isEmpty);
      });

      test('throws on invalid doc', () {
        expect(() => Document(manyEmpty).asResourceOrNull(),
            throwsFormatException);
        expect(() => Document(newResource).asResource(), throwsFormatException);
        expect(() => Document(newResource).asResourceOrNull(),
            throwsFormatException);
        expect(() => Document({}).asResourceOrNull(), throwsFormatException);
        expect(() => Document({'data': 42}).asRelationship(),
            throwsFormatException);
        expect(
            () => Document({
                  'links': {'self': 42}
                }).asRelationship(),
            throwsFormatException);
      });
    });
  });
}
