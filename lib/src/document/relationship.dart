import 'dart:collection';

import 'package:json_api_common/src/document/identifier.dart';
import 'package:json_api_common/src/document/link.dart';

abstract class Relationship with IterableMixin<Identifier> {
  Relationship({Map<String, Link>? links, Map<String, Object?>? meta}) {
    this.meta.addAll(meta ?? {});
    this.links.addAll(links ?? {});
  }

  final links = <String, Link>{};
  final meta = <String, Object?>{};

  Map<String, dynamic> toJson() => {
        if (links.isNotEmpty) 'links': links,
        if (meta.isNotEmpty) 'meta': meta,
      };

  @override
  Iterator<Identifier> get iterator => const <Identifier>[].iterator;
}

class One extends Relationship {
  One(this.identifier, {Map<String, Link>? links, Map<String, Object?>? meta})
      : super(links: links, meta: meta);

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
      {Map<String, Link>? links, Map<String, Object?>? meta})
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
  IncompleteRelationship({Map<String, Link>? links, Map<String, Object?>? meta})
      : super(links: links, meta: meta);
}
