import 'dart:collection';

import 'package:json_api_common/src/document/identifier.dart';
import 'package:json_api_common/src/document/link.dart';

abstract class Relationship with IterableMixin<Identifier> {
  Relationship(
      {Map<String, Link> links = const {},
      Map<String, Object /*?*/ > meta = const {}}) {
    this.meta.addAll(meta);
    this.links.addAll(links);
  }

  final links = <String, Link>{};
  final meta = <String, Object /*?*/ >{};

  Map<String, dynamic> toJson() => {
        if (links.isNotEmpty) 'links': links,
        if (meta.isNotEmpty) 'meta': meta,
      };

  @override
  Iterator<Identifier> get iterator => const <Identifier>[].iterator;
}

class One extends Relationship {
  One(this.identifierOrNull,
      {Map<String, Link> links = const {},
      Map<String, Object /*?*/ > meta = const {}})
      : super(links: links, meta: meta);

  One.empty(
      {Map<String, Link> links = const {},
      Map<String, Object /*?*/ > meta = const {}})
      : identifierOrNull = null,
        super(links: links, meta: meta);

  @override
  Map<String, dynamic> toJson() =>
      {...super.toJson(), 'data': identifierOrNull};

  /// Nullable
  final Identifier /*?*/ identifierOrNull;

  @override
  Iterator<Identifier> get iterator => identifierOrNull == null
      ? <Identifier>[].iterator
      : [identifierOrNull].iterator;
}

class Many extends Relationship {
  Many(Iterable<Identifier> identifiers,
      {Map<String, Link> links = const {},
      Map<String, Object /*?*/ > meta = const {}})
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
      {Map<String, Link> links = const {},
      Map<String, Object /*?*/ > meta = const {}})
      : super(links: links, meta: meta);
}
