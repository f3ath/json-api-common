import 'package:json_api_common/src/document/identity.dart';

/// A Resource Identifier object
class Identifier with Identity {
  Identifier(this.type, this.id, {Map<String, dynamic>? meta}) {
    this.meta.addAll(meta ?? {});
  }

  /// Decodes Identifier from [json]. Returns the decoded object.
  /// If the [json] has incorrect format, throws  [FormatException].
  static Identifier fromJson(dynamic json) {
    if (json is Map) {
      final type = json['type'];
      final id = json['id'];
      final meta = json['meta'] ?? {};
      if (id != null && type != null && meta is Map) {
        return Identifier(type, id, meta: json['meta']);
      }
    }
    throw FormatException('A JSON:API identifier must be a JSON object');
  }

  static Identifier fromKey(String key) {
    final parts = Identity.split(key);
    if (parts.length != 2) throw ArgumentError('Invalid key');
    return Identifier(parts.first, parts.last);
  }

  @override
  final String type;

  @override
  final String id;

  final meta = <String, dynamic>{};

  Map<String, Object> toJson() =>
      {'type': type, 'id': id, if (meta.isNotEmpty) 'meta': meta};
}
