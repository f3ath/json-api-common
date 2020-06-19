import 'dart:collection';

import 'package:json_api_common/src/document/identifier.dart';
import 'package:json_api_common/src/document/link.dart';
import 'package:maybe_just_nothing/maybe_just_nothing.dart';

abstract class Relationship with IterableMixin<Identifier> {
  Relationship(
      {Map<String, Link> links = const {}, Map<String, Object> meta = const {}})
      : links = Map.unmodifiable(links ?? {}),
        meta = Map.unmodifiable(meta ?? {});

  /// Reconstructs a JSON:API Document or the `relationship` member of a Resource object.
  static Relationship fromJson(dynamic json) {
    if (json is Map) {
      final links = Link.mapFromJson(json['links']);
      final meta = Maybe(json['meta']).cast<Map<String, Object>>().or(const {});
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

  final Map<String, Link> links;
  final Map<String, Object> meta;

  Map<String, Object> toJson() => {
        if (links.isNotEmpty) 'links': links,
        if (meta.isNotEmpty) 'meta': meta,
      };

  @override
  Iterator<Identifier> get iterator => const <Identifier>[].iterator;

  /// Narrows the type down to R if possible. Otherwise throws the [TypeError].
  R as<R extends Relationship>() => this is R ? this : throw TypeError();
}

class One extends Relationship {
  One(Identifier identifier,
      {Map<String, Link> links = const {}, Map<String, Object> meta = const {}})
      : identifier = Just(identifier),
        super(links: links, meta: meta);

  One.empty(
      {Map<String, Link> links = const {}, Map<String, Object> meta = const {}})
      : identifier = Nothing<Identifier>(),
        super(links: links, meta: meta);

  @override
  Map<String, Object> toJson() =>
      {...super.toJson(), 'data': identifier.or(null)};

  Maybe<Identifier> identifier;

  @override
  Iterator<Identifier> get iterator =>
      identifier.map((_) => [_]).or(const []).iterator;
}

class Many extends Relationship {
  Many(Iterable<Identifier> identifiers,
      {Map<String, Link> links = const {}, Map<String, Object> meta = const {}})
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
  IncompleteRelationship(
      {Map<String, Link> links = const {}, Map<String, Object> meta = const {}})
      : super(links: links, meta: meta);
}
