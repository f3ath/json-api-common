import 'package:json_api_common/src/document/identity.dart';

/// A Resource Identifier object
class Identifier with Identity {
  Identifier(this.type, this.id, {Map<String, Object?>? meta}) {
    this.meta.addAll(meta ?? {});
  }

  @override
  final String type;

  @override
  final String id;

  final meta = <String, Object?>{};

  Map<String, Object> toJson() =>
      {'type': type, 'id': id, if (meta.isNotEmpty) 'meta': meta};
}
