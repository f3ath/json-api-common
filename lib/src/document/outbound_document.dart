import 'package:json_api_common/document.dart';
import 'package:json_api_common/src/document/link.dart';
import 'package:json_api_common/src/document/resource.dart';

/// An empty outbound document.
class OutboundDocument {
  /// The document "meta" object.
  final meta = <String, Object>{};

  Map<String, Object> toJson() => {'meta': meta};
}

/// An outbound error document.
class OutboundErrorDocument extends OutboundDocument {
  /// The list of errors.
  final errors = <ErrorObject>[];

  @override
  Map<String, Object> toJson() => {
        'errors': errors,
        if (meta.isNotEmpty) 'meta': meta,
      };
}

/// An outbound data document.
class OutboundDataDocument extends OutboundDocument {
  /// Creates an instance of a document containing a single resource as the primary data.
  OutboundDataDocument.resource(Resource resource) {
    _json['data'] = resource;
  }

  /// Creates an instance of a document containing a collection of resources as the primary data.
  OutboundDataDocument.collection(Iterable<Resource> collection) {
    _json['data'] = collection.toList();
  }

  /// Creates an instance of a document containing a relationship.
  OutboundDataDocument.relationship(Relationship relationship) {
    if (relationship is One) {
      _json['data'] = relationship.identifierOrNull;
    }
    if (relationship is Many) {
      _json['data'] = relationship.toList();
    }
    meta.addAll(relationship.meta);
    links.addAll(relationship.links);
  }

  /// Links related to the primary data.
  final links = <String, Link>{};

  /// A list of included resources.
  final included = <Resource>[];

  final _json = <String, Object>{};

  @override
  Map<String, Object> toJson() => {
        ..._json,
        if (links.isNotEmpty) 'links': links,
        if (included.isNotEmpty) 'included': included,
        if (meta.isNotEmpty || _json.isEmpty) 'meta': meta,
      };
}
