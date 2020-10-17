import 'package:json_api_common/src/document/base_resource.dart';
import 'package:json_api_common/src/document/identity.dart';
import 'package:json_api_common/src/document/link.dart';
import 'package:json_api_common/src/document/relationship.dart';

class Resource extends BaseResource with Identity {
  Resource(this.type, this.id,
      {Map<String, Link>? links,
      Map<String, Object?>? meta,
      Map<String, Object?>? attributes,
      Map<String, Relationship>? relationships})
      : super(
            attributes: attributes, relationships: relationships, meta: meta) {
    this.links.addAll(links ?? {});
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
