import 'package:json_api_common/routing.dart';

/// URL Design recommended by the standard.
/// See https://jsonapi.org/recommendations/#urls
class RecommendedUrlDesign implements UrlDesign {
  /// Creates an instance of RecommendedUrlDesign.
  /// The [base] URI will be used as a prefix for the generated URIs.
  ///
  /// To generate URIs without a hostname, pass `Uri(path: '/')` as [base].
  const RecommendedUrlDesign(this.base);

  /// A "path only" version of the recommended URL design, e.g.
  /// `/books`, `/books/42`, `/books/42/authors`
  static final pathOnly = RecommendedUrlDesign(Uri(path: '/'));

  final Uri base;

  /// Returns a URL for the primary resource collection of type [type].
  /// E.g. `/books`.
  @override
  Uri collection(String type) => _resolve([type]);

  /// Returns a URL for the primary resource of type [type] with id [id].
  /// E.g. `/books/123`.
  @override
  Uri resource(String type, String id) => _resolve([type, id]);

  /// Returns a URL for the relationship itself.
  /// The [type] and [id] identify the primary resource and the [relationship]
  /// is the relationship name.
  /// E.g. `/books/123/relationships/authors`.
  @override
  Uri relationship(String type, String id, String relationship) =>
      _resolve([type, id, 'relationships', relationship]);

  /// Returns a URL for the related resource or collection.
  /// The [type] and [id] identify the primary resource and the [relationship]
  /// is the relationship name.
  /// E.g. `/books/123/authors`.
  @override
  Uri related(String type, String id, String relationship) =>
      _resolve([type, id, relationship]);

  Uri _resolve(List<String> pathSegments) =>
      base.resolveUri(Uri(pathSegments: pathSegments));
}
