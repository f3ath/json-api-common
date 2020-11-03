import 'package:json_api_common/src/document/base_resource.dart';
import 'package:json_api_common/src/document/identifier.dart';
import 'package:json_api_common/src/document/identity.dart';
import 'package:json_api_common/src/document/link.dart';
import 'package:json_api_common/src/document/relationship/relationship.dart';

class Resource extends BaseResource with Identity {
  Resource(this.type, this.id,
      {Map<String, Link> links = const {},
      Map<String, Object /*?*/ > meta = const {},
      Map<String, Object /*?*/ > attributes = const {},
      Map<String, Identifier> one = const {},
      Map<String, Iterable<Identifier>> many = const {},
      Map<String /*!*/, Relationship> relationships = const {}})
      : super(
            attributes: attributes,
            one: one,
            many: many,
            relationships: relationships,
            meta: meta) {
    ArgumentError.checkNotNull(type);
    ArgumentError.checkNotNull(id);
    this.links.addAll(links);
  }

  @override
  final String type;

  @override
  final String id;

  final links = <String, Link>{};

  Identifier get identifier => Identifier(type, id);

  Map<String, Object> toJson() => {
        'type': type,
        'id': id,
        if (attributes.isNotEmpty) 'attributes': attributes,
        if (relationships.isNotEmpty) 'relationships': relationships,
        if (links.isNotEmpty) 'links': links,
        if (meta.isNotEmpty) 'meta': meta,
      };
}
