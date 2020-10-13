abstract class UrlDesign {
  /// Returns a URL for the primary resource collection of type [type].
  /// E.g. `/books`.
  Uri collection(String type);

  /// Returns a URL for the primary resource of type [type] with id [id].
  /// E.g. `/books/123`.
  Uri resource(String type, String id);

  /// Returns a URL for the relationship itself.
  /// The [type] and [id] identify the primary resource and the [relationship]
  /// is the relationship name.
  /// E.g. `/books/123/relationships/authors`.
  Uri relationship(String type, String id, String relationship);

  /// Returns a URL for the related resource or collection.
  /// The [type] and [id] identify the primary resource and the [relationship]
  /// is the relationship name.
  /// E.g. `/books/123/authors`.
  Uri related(String type, String id, String relationship);
}
