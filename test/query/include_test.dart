import 'package:json_api_common/src/query/include.dart';
import 'package:test/test.dart';

void main() {
  test('emptiness', () {
    expect(Include().isEmpty, isTrue);
    expect(Include().isNotEmpty, isFalse);
    expect(Include(['foo']).isEmpty, isFalse);
    expect(Include(['foo']).isNotEmpty, isTrue);
  });

  test('Can decode url without duplicate keys', () {
    final uri = Uri.parse('/articles/1?include=author,comments.author');
    final include = Include.fromUri(uri);
    expect(include, equals(['author', 'comments.author']));
  });

  test('Can decode url with duplicate keys', () {
    final uri =
        Uri.parse('/articles/1?include=author,comments.author&include=tags');
    final include = Include.fromUri(uri);
    expect(include, equals(['author', 'comments.author', 'tags']));
  });

  test('Can convert to query parameters', () {
    expect(Include(['author', 'comments.author']).asQueryParameters,
        {'include': 'author,comments.author'});
  });
}
