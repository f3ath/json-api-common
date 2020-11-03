import 'package:json_api_common/routing.dart';
import 'package:test/test.dart';

void main() {
  group('RecommendedUrlDesign', () {
    test('uri generation', () {
      expect(RecommendedUrlDesign.pathOnly.collection('books').toString(),
          '/books');
      expect(RecommendedUrlDesign.pathOnly.resource('books', '42').toString(),
          '/books/42');
      expect(
          RecommendedUrlDesign.pathOnly
              .related('books', '42', 'author')
              .toString(),
          '/books/42/author');
      expect(
          RecommendedUrlDesign.pathOnly
              .relationship('books', '42', 'author')
              .toString(),
          '/books/42/relationships/author');
    });
  });
}
