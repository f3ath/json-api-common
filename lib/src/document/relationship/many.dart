import 'package:json_api_common/src/document/identifier.dart';
import 'package:json_api_common/src/document/link.dart';
import 'package:json_api_common/src/document/relationship/relationship.dart';

class Many extends Relationship {
  Many(Iterable<Identifier> identifiers,
      {Map<String, Link> links = const {},
      Map<String, Object /*?*/ > meta = const {}})
      : super(links: links, meta: meta) {
    identifiers.forEach((_) => _map[_.key] = _);
  }

  final _map = <String, Identifier>{};

  @override
  Map<String, Object /*?*/ > toJson() =>
      {'data': _map.values.toList(), ...super.toJson()};

  @override
  Iterator<Identifier> get iterator => _map.values.iterator;
}
