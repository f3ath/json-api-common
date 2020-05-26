import 'package:json_api_common/src/query/fields.dart';
import 'package:test/test.dart';

void main() {
  test('emptiness', () {
    expect(Fields().isEmpty, isTrue);
    expect(Fields().isNotEmpty, isFalse);

    expect(
        Fields({
          'foo': ['bar']
        }).isEmpty,
        isFalse);
    expect(
        Fields({
          'foo': ['bar']
        }).isNotEmpty,
        isTrue);
  });
  test('Can decode url without duplicate keys', () {
    final uri = Uri.parse(
        '/articles?include=author&fields%5Barticles%5D=title%2Cbody&fields%5Bpeople%5D=name');
    final fields = Fields.fromUri(uri);
    expect(fields['articles'], ['title', 'body']);
    expect(fields['people'], ['name']);
  });

  test('Can decode url with duplicate keys', () {
    final uri = Uri.parse(
        '/articles?include=author&fields%5Barticles%5D=title%2Cbody&fields%5Bpeople%5D=name&fields%5Bpeople%5D=age');
    final fields = Fields.fromUri(uri);
    expect(fields['articles'], ['title', 'body']);
    expect(fields['people'], ['name', 'age']);
  });

  test('Can convert to query parameters', () {
    expect(
        Fields({
          'articles': ['title', 'body'],
          'people': ['name']
        }).asQueryParameters,
        {'fields[articles]': 'title,body', 'fields[people]': 'name'});
  });
}
