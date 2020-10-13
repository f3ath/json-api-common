/// Resource identity.
mixin Identity {
  /// Splits the [key] into type and id
  static List<String> split(String key) => key.split(_delimiter);

  /// Returns true if the two objects have the same key
  static bool equal(Identity a, Identity b) => a.key == b.key;

  static final _delimiter = ':';

  /// Resource type
  String get type;

  /// Resource id
  String get id;

  /// Compound key, uniquely identifying the resource
  String get key => '$type$_delimiter$id';

  @override
  String toString() => key;
}
