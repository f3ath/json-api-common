import 'package:json_api_common/src/document/base_resource.dart';
import 'package:json_api_common/src/document/relationship.dart';

/// A new (to-be-created) resource which does not yet have the id.
class NewResource extends BaseResource {
  NewResource(this.type,
      {Map<String, dynamic>? meta,
      Map<String, dynamic>? attributes,
      Map<String, Relationship>? relationships}) {
    ArgumentError.checkNotNull(type);
    this.meta.addAll(meta ?? {});
    this.relationships.addAll(relationships ?? {});
    this.attributes.addAll(attributes ?? {});
  }

  static NewResource fromJson(dynamic json) {
    if (json is Map) {
      final type = json['type'];
      final attributes = json['attributes'] ?? <String, dynamic>{};
      final relationships = json['relationships'] ?? <String, dynamic>{};
      final meta = json['meta'] ?? <String, dynamic>{};
      if (type is String &&
          attributes is Map<String, dynamic> &&
          relationships is Map &&
          meta is Map<String, dynamic>) {
        return NewResource(type,
            attributes: attributes,
            relationships: Relationship.mapFromJson(relationships),
            meta: meta);
      }
    }
    throw FormatException('Invalid JSON');
  }

  /// Resource type
  final String type;

  Map<String, Object> toJson() => {
        'type': type,
        if (attributes.isNotEmpty) 'attributes': attributes,
        if (relationships.isNotEmpty) 'relationships': relationships,
        if (meta.isNotEmpty) 'meta': meta,
      };
}
