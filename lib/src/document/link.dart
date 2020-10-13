/// A JSON:API link
/// https://jsonapi.org/format/#document-links
class Link {
  Link(this.uri, {Map<String, dynamic>? meta}) {
    this.meta.addAll(meta ?? {});
  }

  /// Link URL
  final Uri uri;

  /// Link meta data
  final meta = <String, dynamic>{};

  /// Decodes Link from [json]. Returns the decoded object.
  /// If the [json] has incorrect format, throws  [FormatException].
  static Link fromJson(dynamic json) {
    if (json is String) return Link(Uri.parse(json));
    if (json is Map) {
      final meta = json['meta'] ?? <String, dynamic>{};
      if (meta is Map<String, dynamic>) {
        try {
          return Link(Uri.parse(json['href']), meta: meta);
        } on TypeError catch (e) {
          throw FormatException('Invalid JSON: $e');
        }
      }
    }
    throw FormatException('Invalid JSON');
  }

  /// Decodes a map of [Link] from [json]. Returns the decoded object.
  /// If the [json] has incorrect format, throws  [FormatException].
  static Map<String, Link> mapFromJson(dynamic json) {
    if (json is Map) {
      return json.map((k, v) => MapEntry(k.toString(), Link.fromJson(v)));
    }
    throw FormatException('Invalid JSON');
  }

  @override
  String toString() => uri.toString();

  Object toJson() =>
      meta.isNotEmpty ? {'href': uri.toString(), 'meta': meta} : uri.toString();
}
