import 'dart:collection';

import 'package:json_api_common/src/document/identifier.dart';
import 'package:json_api_common/src/document/link.dart';

abstract class Relationship with IterableMixin<Identifier> {
  Relationship({Map<String, Link>? links, Map<String, dynamic>? meta}) {
    this.meta.addAll(meta ?? {});
    this.links.addAll(links ?? {});
  }

  /// Reconstructs a JSON:API Document or the `relationship` member of a Resource object.
  static Relationship fromJson(dynamic json) {
    if (json is Map) {
      final links = Link.mapFromJson(json['links'] ?? {});
      final meta = json['meta'] ?? <String, Object>{};
      if (json.containsKey('data')) {
        final data = json['data'];
        if (data == null) {
          return One.empty(links: links, meta: meta);
        }
        if (data is Map) {
          return One(Identifier.fromJson(data), links: links, meta: meta);
        }
        if (data is List) {
          return Many(data.map(Identifier.fromJson), links: links, meta: meta);
        }
        throw FormatException('Invalid relationship object');
      }
      return IncompleteRelationship(links: links, meta: meta);
    }
    throw FormatException('Invalid relationship object');
  }

  static Map<String, Relationship> mapFromJson(dynamic json) {
    if (json == null) return {};
    if (json is Map) {
      return json
          .map((k, v) => MapEntry(k.toString(), Relationship.fromJson(v)));
    }
    throw FormatException(' Invalid relationships object');
  }

  final links = <String, Link>{};
  final meta = <String, dynamic>{};

  Map<String, dynamic> toJson() => {
        if (links.isNotEmpty) 'links': links,
        if (meta.isNotEmpty) 'meta': meta,
      };

  @override
  Iterator<Identifier> get iterator => const <Identifier>[].iterator;
}

class One extends Relationship {
  One(this.identifier, {Map<String, Link>? links, Map<String, dynamic>? meta})
      : super(links: links, meta: meta);

  One.empty({Map<String, Link>? links, Map<String, dynamic>? meta})
      : identifier = null,
        super(links: links, meta: meta);

  @override
  Map<String, dynamic> toJson() => {...super.toJson(), 'data': identifier};

  /// Nullable
  final Identifier? identifier;

  @override
  Iterator<Identifier> get iterator =>
      identifier == null ? <Identifier>[].iterator : [identifier!].iterator;
}

class Many extends Relationship {
  Many(Iterable<Identifier> identifiers,
      {Map<String, Link>? links, Map<String, Object>? meta})
      : super(links: links, meta: meta) {
    identifiers.forEach((_) => _map[_.key] = _);
  }

  final _map = <String, Identifier>{};

  @override
  Map<String, Object> toJson() =>
      {...super.toJson(), 'data': _map.values.toList()};

  @override
  Iterator<Identifier> get iterator => _map.values.iterator;
}

class IncompleteRelationship extends Relationship {
  IncompleteRelationship({Map<String, Link>? links, Map<String, Object>? meta})
      : super(links: links, meta: meta);
}
