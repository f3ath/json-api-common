import 'package:json_api_common/src/routing/url_design.dart';

abstract class Target {
  Uri uri(UrlDesign urls);
}

class CollectionTarget implements Target {
  const CollectionTarget(this.type);

  final String type;

  @override
  Uri uri(UrlDesign urls) => urls.collection(type);
}

class ResourceTarget implements Target {
  const ResourceTarget(this.type, this.id);

  final String type;
  final String id;

  @override
  Uri uri(UrlDesign urls) => urls.resource(type, id);

  CollectionTarget get collection => CollectionTarget(type);
}

class RelatedTarget implements Target {
  const RelatedTarget(this.type, this.id, this.relationship);

  final String type;
  final String id;
  final String relationship;

  @override
  Uri uri(UrlDesign urls) => urls.related(type, id, relationship);

  CollectionTarget get collection => CollectionTarget(type);

  ResourceTarget get resource => ResourceTarget(type, id);
}

class RelationshipTarget implements Target {
  const RelationshipTarget(this.type, this.id, this.relationship);

  final String type;
  final String id;
  final String relationship;

  Uri uri(UrlDesign urls) => urls.relationship(type, id, relationship);

  CollectionTarget get collection => CollectionTarget(type);

  ResourceTarget get resource => ResourceTarget(type, id);
}
