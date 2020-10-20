import 'package:json_api_common/src/document/link.dart';
import 'package:json_api_common/src/document/relationship/relationship.dart';

class IncompleteRelationship extends Relationship {
  IncompleteRelationship(
      {Map<String, Link> links = const {},
      Map<String, Object /*?*/ > meta = const {}})
      : super(links: links, meta: meta);
}
