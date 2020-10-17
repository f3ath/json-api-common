import 'package:json_api_common/src/document/base_resource.dart';
import 'package:json_api_common/src/document/relationship.dart';

/// A new (to-be-created) resource which does not yet have the id.
class NewResource extends BaseResource {
  NewResource(this.type,
      {Map<String, Object?>? meta,
      Map<String, Object?>? attributes,
      Map<String, Relationship>? relationships}) {
    ArgumentError.checkNotNull(type);
    this.meta.addAll(meta ?? {});
    this.relationships.addAll(relationships ?? {});
    this.attributes.addAll(attributes ?? {});
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
