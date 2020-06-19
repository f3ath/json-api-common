import 'package:json_api_common/src/document/relationship.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';

class NewResource {
  NewResource(this.type,
      {Map<String, Object> meta = const {},
      Map<String, Object> attributes = const {},
      Map<String, Relationship> relationships = const {}})
      : meta = Map.unmodifiable(meta ?? {}),
        relationships = Map.unmodifiable(relationships ?? {}),
        attributes = Map.unmodifiable(attributes ?? {});

  static NewResource fromJson(dynamic json) {
    if (json is Map) {
      return NewResource(
          Maybe(json['type'])
              .cast<String>()
              .orThrow(() => FormatException('Invalid resource type')),
          attributes: Maybe(json['attributes']).cast<Map>().or(const {}),
          relationships: Maybe(json['relationships'])
              .cast<Map>()
              .map((t) => t.map((key, value) =>
                  MapEntry(key.toString(), Relationship.fromJson(value))))
              .orGet(() => {}),
          meta: json['meta']);
    }
    throw FormatException('A JSON:API resource must be a JSON object');
  }

  final String type;
  final Map<String, Object> meta;
  final Map<String, Object> attributes;
  final Map<String, Relationship> relationships;

  Map<String, Object> toJson() => {
        'type': type,
        if (attributes.isNotEmpty) 'attributes': attributes,
        if (relationships.isNotEmpty) 'relationships': relationships,
        if (meta.isNotEmpty) 'meta': meta,
      };
}
