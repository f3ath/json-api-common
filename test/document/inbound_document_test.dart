import 'dart:convert';
import 'dart:io';

import 'package:json_api_common/document.dart';
import 'package:test/test.dart';

void main() {
  group('InboundDocument', () {
    group('Errors', () {
      test('Minimal', () {
        final e = InboundDocument({
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
        final e = InboundDocument({
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
            () => InboundDocument({
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
        final doc = InboundDocument(example);
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
        final doc = InboundDocument(resource);
        final article = doc.asResource();
        expect(article.id, '1');
        expect(article.attributes['title'], 'JSON:API paints my bikeshed!');
        expect(article.relationships['author'], isA<Relationship>());
        expect(doc.included(), isEmpty);
        expect(doc.links()['self'].toString(), 'http://example.com/articles/1');
        expect(doc.meta(), isEmpty);
      });

      test('can parse a new resource', () {
        final doc = InboundDocument(newResource);
        final article = doc.asNewResource();
        expect(article.attributes['title'], 'A new article');
        expect(doc.included(), isEmpty);
        expect(doc.links(), isEmpty);
        expect(doc.meta(), isEmpty);
      });

      test('can parse related resource', () {
        final doc = InboundDocument(relatedEmpty);
        expect(doc.asResourceOrNull(), isNull);
        expect(doc.included(), isEmpty);
        expect(doc.links()['self'].toString(),
            'http://example.com/articles/1/author');
        expect(doc.meta(), isEmpty);
      });

      test('can parse to-one', () {
        final doc = InboundDocument(one);
        expect(doc.asRelationship(), isA<One>());
        expect(doc.asRelationship(), isNotEmpty);
        expect(doc.asRelationship().first.type, 'people');
        expect(doc.included(), isEmpty);
        expect(
            doc.links()['self'].toString(), '/articles/1/relationships/author');
        expect(doc.meta(), isEmpty);
      });

      test('can parse empty to-one', () {
        final doc = InboundDocument(oneEmpty);
        expect(doc.asRelationship(), isA<One>());
        expect(doc.asRelationship(), isEmpty);
        expect(doc.included(), isEmpty);
        expect(
            doc.links()['self'].toString(), '/articles/1/relationships/author');
        expect(doc.meta(), isEmpty);
      });

      test('can parse to-many', () {
        final doc = InboundDocument(many);
        expect(doc.asRelationship(), isA<Many>());
        expect(doc.asRelationship(), isNotEmpty);
        expect(doc.asRelationship().first.type, 'tags');
        expect(doc.included(), isEmpty);
        expect(
            doc.links()['self'].toString(), '/articles/1/relationships/tags');
        expect(doc.meta(), isEmpty);
      });

      test('can parse empty to-many', () {
        final doc = InboundDocument(manyEmpty);
        expect(doc.asRelationship(), isA<Many>());
        expect(doc.asRelationship(), isEmpty);
        expect(doc.included(), isEmpty);
        expect(
            doc.links()['self'].toString(), '/articles/1/relationships/tags');
        expect(doc.meta(), isEmpty);
      });

      test('throws on invalid doc', () {
        expect(() => InboundDocument(manyEmpty).asResourceOrNull(),
            throwsFormatException);
        expect(() => InboundDocument(newResource).asResource(), throwsFormatException);
        expect(() => InboundDocument(newResource).asResourceOrNull(),
            throwsFormatException);
        expect(() => InboundDocument({}).asResourceOrNull(), throwsFormatException);
        expect(() => InboundDocument({'data': 42}).asRelationship(),
            throwsFormatException);
        expect(
            () => InboundDocument({
                  'links': {'self': 42}
                }).asRelationship(),
            throwsFormatException);
      });
    });
  });
}
