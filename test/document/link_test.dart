import 'dart:convert';

import 'package:json_api_common/document.dart';
import 'package:test/test.dart';

void main() {
  group('Link', () {
    test('simple url can be encoded and decoded', () {
      final link = Link(Uri.parse('http://example.com'));
      expect(Link.fromJson(jsonDecode(jsonEncode(link))).uri.toString(),
          'http://example.com');
    });

    test('link object can be encoded and decoded', () {
      final link = Link(Uri.parse('http://example.com'), meta: {'foo': 'bar'});

      final parsed = Link.fromJson(json.decode(json.encode(link)));
      expect(parsed.uri.toString(), 'http://example.com');
      expect(parsed.meta['foo'], 'bar');
    });

    test('link object without meta can be encoded and decoded', () {
      final parsed = Link.fromJson({'href': 'http://example.com'});
      expect(parsed.uri.toString(), 'http://example.com');
      expect(parsed.meta, isEmpty);
    });

    test('a map of link object can be parsed from JSON', () {
      final links = Link.mapFromJson({
        'first': 'http://example.com/first',
        'last': 'http://example.com/last'
      });
      expect(links['first']!.uri.toString(), 'http://example.com/first');
      expect(links['last']!.uri.toString(), 'http://example.com/last');
    });

    test('throws FormatException on invalid JSON', () {
      expect(() => Link.fromJson([]), throwsFormatException);
      expect(() => Link.fromJson({'meta': true}), throwsFormatException);
      expect(() => Link.mapFromJson([]), throwsFormatException);
    });
  });
}
