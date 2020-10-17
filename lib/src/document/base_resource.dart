import 'package:json_api_common/src/document/relationship.dart';

abstract class BaseResource {
  BaseResource(
      {Map<String, Object?>? meta,
      Map<String, Object?>? attributes,
      Map<String, Relationship>? relationships}) {
    this.meta.addAll(meta ?? {});
    this.relationships.addAll(relationships ?? {});
    this.attributes.addAll(attributes ?? {});
  }

  /// Resource meta data.
  final meta = <String, Object?>{};

  /// Resource attributes.
  ///
  /// See https://jsonapi.org/format/#document-resource-object-attributes
  final attributes = <String, Object?>{};

  /// Resource relationships.
  ///
  /// See https://jsonapi.org/format/#document-resource-object-relationships
  final relationships = <String, Relationship>{};
}
