import 'dart:collection';

import 'package:json_api_common/src/document/identifier.dart';
import 'package:json_api_common/src/document/link.dart';

abstract class Relationship with IterableMixin<Identifier /*!*/ > {
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
  Iterator<Identifier /*!*/ > get iterator => const <Identifier>[].iterator;
}


