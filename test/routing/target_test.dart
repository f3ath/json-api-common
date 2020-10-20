import 'package:json_api_common/routing.dart';
import 'package:test/test.dart';

void main() {
  group('Target', () {
    const collection = CollectionTarget('apples');
    const resource = ResourceTarget('apples', '42');
    const related = RelatedTarget('apples', '42', 'price');
    const relationship = RelationshipTarget('apples', '42', 'price');

    test('uri', () {
      final design = RecommendedUrlDesign(Uri.parse('/'));

      expect(collection.uri(design).toString(), '/apples');
      expect(resource.uri(design).toString(), '/apples/42');
      expect(related.uri(design).toString(), '/apples/42/price');
      expect(relationship.uri(design).toString(),
          '/apples/42/relationships/price');
    });

    test('map', () {
      expect(collection.map(_Mapper()), 'collection');
      expect(resource.map(_Mapper()), 'resource');
      expect(related.map(_Mapper()), 'related');
      expect(relationship.map(_Mapper()), 'relationship');
    });

    test('conversion', () {
      expect(resource.collection, collection);
      expect(relationship.collection, collection);
      expect(relationship.resource, resource);
      expect(related.collection, collection);
      expect(related.resource, resource);
    });

    test('equality', () {
      expect(CollectionTarget('apples'), CollectionTarget('apples'));
      expect(ResourceTarget('apples', '42'), ResourceTarget('apples', '42'));
      expect(RelatedTarget('apples', '42', 'price'),
          RelatedTarget('apples', '42', 'price'));
      expect(RelationshipTarget('apples', '42', 'price'),
          RelationshipTarget('apples', '42', 'price'));

      expect(CollectionTarget('apples').hashCode, 0);
      expect(ResourceTarget('apples', '42').hashCode, 0);
      expect(RelatedTarget('apples', '42', 'price').hashCode, 0);
      expect(RelationshipTarget('apples', '42', 'price').hashCode, 0);
    });
  });
}

class _Mapper implements TargetMapper<String> {
  @override
  String collection(CollectionTarget target) => 'collection';

  @override
  String related(RelatedTarget target) => 'related';

  @override
  String relationship(RelationshipTarget target) => 'relationship';

  @override
  String resource(ResourceTarget target) => 'resource';
}
