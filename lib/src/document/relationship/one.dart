import 'package:json_api_common/src/document/identifier.dart';
import 'package:json_api_common/src/document/link.dart';
import 'package:json_api_common/src/document/relationship/relationship.dart';

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
      {'data': identifierOrNull, ...super.toJson()};

  /// Nullable
  final Identifier /*?*/ identifierOrNull;

  @override
  Iterator<Identifier /*!*/ > get iterator => identifierOrNull == null
      ? <Identifier>[].iterator
      : [identifierOrNull].iterator;
}
