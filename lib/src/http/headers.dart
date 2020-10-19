import 'dart:collection';

/// HTTP headers. All keys are converted to lowercase on the fly.
class Headers with MapMixin<String, String> {
  Headers([Map<String, String> headers = const {}]) {
    headers.forEach((key, value) {
      this[key] = value;
    });
  }

  final _map = <String, String>{};

  @override
  String /*?*/ operator [](Object /*?*/ key) =>
      key is String ? _map[key.toLowerCase()] : null;

  @override
  void operator []=(String key, String value) =>
      _map[key.toLowerCase()] = value;

  @override
  void clear() => _map.clear();

  @override
  Iterable<String> get keys => _map.keys;

  @override
  String /*?*/ remove(Object /*?*/ key) =>
      _map.remove(key is String ? key.toLowerCase() : key);

  /// Returns the headers as a map
  Map<String, String> get asMap => {..._map};
}
