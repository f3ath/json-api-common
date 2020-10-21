import 'package:json_api_common/src/document/identifier.dart';
import 'package:json_api_common/src/document/relationship/many.dart';
import 'package:json_api_common/src/document/relationship/one.dart';
import 'package:json_api_common/src/document/relationship/relationship.dart';

abstract class BaseResource {
  BaseResource(
      {Map<String, Object /*?*/ > meta = const {},
      Map<String, Object /*?*/ > attributes = const {},
      Map<String, Identifier> one = const {},
      Map<String, Iterable<Identifier>> many = const {},
      Map<String /*!*/, Relationship> relationships = const {}}) {
    this.meta.addAll(meta);
    this.relationships
      ..addAll(one.map((key, value) => MapEntry(key, One(value))))
      ..addAll(many.map((key, value) => MapEntry(key, Many(value))))
      ..addAll(relationships);
    this.attributes.addAll(attributes);
  }

  /// Resource meta data.
  final meta = <String, Object /*?*/ >{};

  /// Resource attributes.
  ///
  /// See https://jsonapi.org/format/#document-resource-object-attributes
  final attributes = <String, Object /*?*/ >{};

  /// Resource relationships.
  ///
  /// See https://jsonapi.org/format/#document-resource-object-relationships
  final relationships = <String, Relationship>{};
}
