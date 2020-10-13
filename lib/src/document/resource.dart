import 'package:json_api_common/src/document/base_resource.dart';
import 'package:json_api_common/src/document/identity.dart';
import 'package:json_api_common/src/document/link.dart';
import 'package:json_api_common/src/document/relationship.dart';

class Resource extends BaseResource with Identity {
  Resource(this.type, this.id,
      {Map<String, Link>? links,
      Map<String, Object>? meta,
      Map<String, Object>? attributes,
      Map<String, Relationship>? relationships})
      : super(
            attributes: attributes, relationships: relationships, meta: meta) {
    this.links.addAll(links ?? {});
  }

  static Resource fromJson(dynamic json) {
    if (json is Map) {
      final type = json['type'];
      final id = json['id'];
      final attributes = json['attributes'] ?? <String, Object>{};
      final relationships = json['relationships'] ?? <String, Object>{};
      final links = json['links'] ?? <String, Object>{};
      final meta = json['meta'] ?? <String, Object>{};
      if (type is String &&
          id is String &&
          attributes is Map<String, Object> &&
          relationships is Map &&
          links is Map &&
          meta is Map<String, Object>) {
        return Resource(type, id,
            attributes: attributes,
            relationships: Relationship.mapFromJson(relationships),
            links: Link.mapFromJson(links),
            meta: meta);
      }
    }
    throw FormatException('Invalid JSON');
  }

  @override
  final String type;

  @override
  final String id;

  final links = <String, Link>{};

  Map<String, Object> toJson() => {
        'type': type,
        'id': id,
        if (attributes.isNotEmpty) 'attributes': attributes,
        if (relationships.isNotEmpty) 'relationships': relationships,
        if (meta.isNotEmpty) 'meta': meta,
        if (links.isNotEmpty) 'links': links,
      };
}
