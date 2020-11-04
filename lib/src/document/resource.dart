import 'package:json_api_common/src/document/identifier.dart';
import 'package:json_api_common/src/document/identity.dart';
import 'package:json_api_common/src/document/link.dart';
import 'package:json_api_common/src/document/new_resource.dart';
import 'package:json_api_common/src/document/relationship/relationship.dart';

class Resource extends NewResource with Identity {
  Resource(String type, this.id,
      {Map<String, Link> links = const {},
      Map<String, Object /*?*/ > meta = const {},
      Map<String, Object /*?*/ > attributes = const {},
      Map<String, Identifier> one = const {},
      Map<String, Iterable<Identifier>> many = const {},
      Map<String /*!*/, Relationship> relationships = const {}})
      : super(type,
            attributes: attributes,
            one: one,
            many: many,
            relationships: relationships,
            meta: meta) {
    ArgumentError.checkNotNull(id);
    this.links.addAll(links);
  }

  @override
  final String id;

  final links = <String, Link>{};

  Identifier get identifier => Identifier(type, id);

  @override
  Map<String, Object> toJson() => {
        'type': type,
        'id': id,
        if (attributes.isNotEmpty) 'attributes': attributes,
        if (relationships.isNotEmpty) 'relationships': relationships,
        if (links.isNotEmpty) 'links': links,
        if (meta.isNotEmpty) 'meta': meta,
      };
}
