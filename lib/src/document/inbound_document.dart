import 'package:json_api_common/document.dart';
import 'package:json_api_common/src/document/error_source.dart';
import 'package:json_api_common/src/document/relationship/many.dart';
import 'package:json_api_common/src/document/relationship/one.dart';
import 'package:json_api_common/src/extensions.dart';
import 'package:json_api_common/src/nullable.dart';

/// A generic inbound JSON:API document
class InboundDocument {
  InboundDocument(this._json);

  final Map /*!*/ _json;

  /// Included resources
  Iterable<Resource> included() => _json
      .get<List>('included', orGet: () => [])
      .whereType<Map>()
      .map(_resource);

  /// Error objects
  Iterable<ErrorObject> errors() => _json
      .get<List>('errors', orGet: () => [])
      .whereType<Map>()
      .map(_errorObject);

  /// Document meta
  Map<String, Object /*?*/ > meta() => _getMeta(_json);

  /// Document links
  Map<String /*!*/, Link> links() => _getLinks(_json);

  Relationship asRelationship() => _relationship(_json);

  Iterable<Resource> asResourceCollection() =>
      _json.get<List>('data').whereType<Map>().map(_resource);

  Resource asResource() =>
      _resource(_json.get<Map<String, Object /*?*/ >>('data'));

  NewResource asNewResource() =>
      _newResource(_json.get<Map<String, Object /*?*/ >>('data'));

  Resource /*?*/ asResourceOrNull() =>
      nullable(_resource)(_json.getNullable<Map>('data'));

  static Resource _resource(Map json) =>
      Resource(json.get<String>('type'), json.get<String>('id'),
          attributes: _getAttributes(json),
          relationships: _getRelationships(json),
          links: _getLinks(json),
          meta: _getMeta(json));

  static NewResource _newResource(Map json) =>
      NewResource(json.get<String>('type'),
          attributes: _getAttributes(json),
          relationships: _getRelationships(json),
          meta: _getMeta(json));

  static Relationship _relationship(Map json) {
    final links = _getLinks(json);
    final meta = _getMeta(json);
    if (json.containsKey('data')) {
      final data = json['data'];
      if (data == null) {
        return One.empty(links: links, meta: meta);
      }
      if (data is Map) {
        return One(_identifier(data), links: links, meta: meta);
      }
      if (data is List) {
        return Many(data.whereType<Map>().map(_identifier),
            links: links, meta: meta);
      }
      throw FormatException('Invalid relationship object');
    }
    return Relationship(links: links, meta: meta);
  }

  /// Decodes Identifier from [json]. Returns the decoded object.
  /// If the [json] has incorrect format, throws  [FormatException].
  static Identifier _identifier(Map json) =>
      Identifier(json.get<String>('type'), json.get<String>('id'),
          meta: _getMeta(json));

  static ErrorObject _errorObject(Map json) {
    final source = _errorSource(json.get<Map>('source', orGet: () => {}));
    return ErrorObject(
        id: json.get<String>('id', orGet: () => ''),
        status: json.get<String>('status', orGet: () => ''),
        code: json.get<String>('code', orGet: () => ''),
        title: json.get<String>('title', orGet: () => ''),
        detail: json.get<String>('detail', orGet: () => ''),
        sourcePointer: source.pointer,
        sourceParameter: source.parameter,
        meta: _getMeta(json),
        links: _getLinks(json));
  }

  /// Decodes ErrorSource from [json]. Returns the decoded object.
  /// If the [json] has incorrect format, throws  [FormatException].
  static ErrorSource _errorSource(Map json) => ErrorSource(
      pointer: json.get<String>('pointer', orGet: () => ''),
      parameter: json.get<String>('parameter', orGet: () => ''));

  /// Decodes Link from [json]. Returns the decoded object.
  /// If the [json] has incorrect format, throws  [FormatException].
  static Link _link(Object json) {
    if (json is String) return Link(Uri.parse(json));
    if (json is Map) {
      return Link(Uri.parse(json['href']), meta: _getMeta(json));
    }
    throw FormatException('Invalid JSON');
  }

  static Map<String, Object /*?*/ > _getAttributes(Map json) =>
      json.get<Map<String, Object /*?*/ >>('attributes', orGet: () => {});

  static Map<String, Relationship> _getRelationships(Map json) => json
      .get<Map>('relationships', orGet: () => {})
      .map((key, value) => MapEntry(key, _relationship(value)));

  static Map<String /*!*/, Link> _getLinks(Map json) => json
      .get<Map>('links', orGet: () => {})
      .map((k, v) => MapEntry(k.toString(), _link(v)));

  static Map<String, Object /*?*/ > _getMeta(Map json) =>
      json.get<Map<String, Object /*?*/ >>('meta', orGet: () => {});
}
