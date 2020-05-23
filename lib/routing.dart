/// Routing determines the design of URLs on the server.
/// See https://jsonapi.org/recommendations/#urls
class Routing {
  /// Creates an instance of Routing. If [base] uri is provided, it will be used
  /// as a prefix for the generated URIs. Otherwise the prefix will be "/".
  Routing([Uri base]) : _base = base ?? Uri(path: '/');
  final Uri _base;

  /// Returns a URL for the primary resource collection of type [type]
  Uri collection(String type) => _resolve([type]);

  /// Returns a URL for the primary resource of type [type] with id [id]
  Uri resource(String type, String id) => _resolve([type, id]);

  /// Returns a URL for the relationship itself.
  /// The [type] and [id] identify the primary resource and the [relationship]
  /// is the relationship name.
  Uri relationship(String type, String id, String relationship) =>
      _resolve([type, id, 'relationships', relationship]);

  /// Returns a URL for the related resource/collection.
  /// The [type] and [id] identify the primary resource and the [relationship]
  /// is the relationship name.
  Uri related(String type, String id, String relationship) =>
      _resolve([type, id, relationship]);

  Uri _resolve(List<String> pathSegments) =>
      _base.resolveUri(Uri(pathSegments: pathSegments));
}
