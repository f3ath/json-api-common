/// A JSON:API link
/// https://jsonapi.org/format/#document-links
class Link {
  Link(this.uri, {Map<String, Object /*?*/ > meta = const {}}) {
    this.meta.addAll(meta);
  }

  /// Link URL
  final Uri uri;

  /// Link meta data
  final meta = <String, Object /*?*/ >{};

  @override
  String toString() => uri.toString();

  Object toJson() =>
      meta.isNotEmpty ? {'href': uri.toString(), 'meta': meta} : uri.toString();
}
