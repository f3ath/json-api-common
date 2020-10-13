import 'package:json_api_common/src/routing/url_design.dart';

abstract class Target {
  Uri uri(UrlDesign urls);

  T map<T>(TargetMapper<T> mapper);
}

abstract class TargetMapper<T> {
  T collection(CollectionTarget target);

  T resource(ResourceTarget target);

  T related(RelatedTarget target);

  T relationship(RelationshipTarget target);
}

class CollectionTarget implements Target {
  const CollectionTarget(this.type);

  final String type;

  @override
  Uri uri(UrlDesign urls) => urls.collection(type);

  @override
  T map<T>(TargetMapper<T> mapper) => mapper.collection(this);
}

class ResourceTarget implements Target {
  const ResourceTarget(this.type, this.id);

  final String type;
  final String id;

  @override
  Uri uri(UrlDesign urls) => urls.resource(type, id);

  CollectionTarget get collection => CollectionTarget(type);

  @override
  T map<T>(TargetMapper<T> mapper) => mapper.resource(this);
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

  @override
  T map<T>(TargetMapper<T> mapper) => mapper.related(this);
}

class RelationshipTarget implements Target {
  const RelationshipTarget(this.type, this.id, this.relationship);

  final String type;
  final String id;
  final String relationship;

  @override
  Uri uri(UrlDesign urls) => urls.relationship(type, id, relationship);

  CollectionTarget get collection => CollectionTarget(type);

  ResourceTarget get resource => ResourceTarget(type, id);

  @override
  T map<T>(TargetMapper<T> mapper) => mapper.relationship(this);
}
