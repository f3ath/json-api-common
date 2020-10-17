import 'package:json_api_common/document.dart';
import 'package:json_api_common/src/document/error_source.dart';
import 'package:json_api_common/src/extensions.dart';
import 'package:json_api_common/src/nullable.dart';

/// A generic incoming JSON:API document
class Document {
  Document(this._json);

  final Map _json;

  /// Included resources
  Iterable<Resource> included() => _json
      .getAs<List>('included', orGet: () => [])
      .whereType<Map>()
      .map(_resource);

  /// Error objects
  Iterable<ErrorObject> errors() => _json
      .getAs<List>('errors', orGet: () => [])
      .whereType<Map>()
      .map(_errorObject);

  /// Document meta
  Map<String, Object?> meta() => _getMeta(_json);

  /// Document links
  Map<String, Link> links() => _getLinks(_json);

  Relationship asRelationship() => _relationship(_json);

  Iterable<Resource> asResourceCollection() =>
      _json.getAs<List>('data').whereType<Map>().map(_resource);

  Resource asResource() => _resource(_json.getAs<Map<String, Object?>>('data'));

  NewResource asNewResource() =>
      _newResource(_json.getAs<Map<String, Object?>>('data'));

  Resource? asResourceOrNull() => nullable(_resource)(_json.getAs<Map?>('data'));

  static Resource _resource(Map json) => Resource(
      json.getAs<String>('type'), json.getAs<String>('id'),
      attributes:
          json.getAs<Map<String, Object?>>('attributes', orGet: () => {}),
      relationships: json.getAs<Map>('relationships', orGet: () => {}).map(
          (key, value) => MapEntry(key.toString(),
              _relationship(value is Map ? value : throw FormatException()))),
      links: _getLinks(json),
      meta: _getMeta(json));

  static NewResource _newResource(Map json) =>
      NewResource(json.getAs<String>('type'),
          attributes:
              json.getAs<Map<String, Object?>>('attributes', orGet: () => {}),
          relationships: json
              .getAs<Map<String, Map>>('relationships', orGet: () => {})
              .map((key, value) => MapEntry(key, _relationship(value))),
          meta: _getMeta(json));

  static Relationship _relationship(Map json) {
    if (json.containsKey('data')) {
      final data = json['data'];
      if (data is Map?) {
        return One(nullable(_identifier)(data),
            links: _getLinks(json), meta: _getMeta(json));
      }
      if (data is List) {
        return Many(data.whereType<Map>().map(_identifier),
            links: _getLinks(json), meta: _getMeta(json));
      }
      throw FormatException('Invalid relationship object');
    }
    return IncompleteRelationship(links: _getLinks(json), meta: _getMeta(json));
  }

  /// Decodes Identifier from [json]. Returns the decoded object.
  /// If the [json] has incorrect format, throws  [FormatException].
  static Identifier _identifier(Map json) =>
      Identifier(json.getAs<String>('type'), json.getAs<String>('id'),
          meta: _getMeta(json));

  static ErrorObject _errorObject(Map json) {
    final source = _errorSource(json.getAs<Map>('source', orGet: () => {}));
    return ErrorObject(
        id: json.getAs<String>('id', orGet: () => ''),
        status: json.getAs<String>('status', orGet: () => ''),
        code: json.getAs<String>('code', orGet: () => ''),
        title: json.getAs<String>('title', orGet: () => ''),
        detail: json.getAs<String>('detail', orGet: () => ''),
        sourcePointer: source.pointer,
        sourceParameter: source.parameter,
        meta: _getMeta(json),
        links: _getLinks(json));
  }

  /// Decodes ErrorSource from [json]. Returns the decoded object.
  /// If the [json] has incorrect format, throws  [FormatException].
  static ErrorSource _errorSource(Map json) => ErrorSource(
      pointer: json.getAs<String>('pointer', orGet: () => ''),
      parameter: json.getAs<String>('parameter', orGet: () => ''));

  /// Decodes Link from [json]. Returns the decoded object.
  /// If the [json] has incorrect format, throws  [FormatException].
  static Link _link(Object json) {
    if (json is String) return Link(Uri.parse(json));
    if (json is Map) {
      return Link(Uri.parse(json['href']), meta: _getMeta(json));
    }
    throw FormatException('Invalid JSON');
  }

  static Map<String, Link> _getLinks(Map json) => json
      .getAs<Map>('links', orGet: () => {})
      .map((k, v) => MapEntry(k.toString(), _link(v)));

  static Map<String, Object?> _getMeta(Map json) =>
      json.getAs<Map<String, Object?>>('meta', orGet: () => {});
}
