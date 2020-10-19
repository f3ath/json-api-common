import 'package:json_api_common/src/document/error_source.dart';
import 'package:json_api_common/src/document/link.dart';

/// [ErrorObject] represents an error occurred on the server.
///
/// More on this: https://jsonapi.org/format/#errors
class ErrorObject {
  /// Creates an instance of a JSON:API Error.
  /// The [links] map may contain custom links. The about link
  /// passed through the [links['about']] argument takes precedence and will overwrite
  /// the `about` key in [links].
  ErrorObject(
      {this.id = '',
      this.status = '',
      this.code = '',
      this.title = '',
      this.detail = '',
      Map<String, Object /*?*/ > meta = const {},
      String sourceParameter = '',
      String sourcePointer = '',
      Map<String, Link> links = const {}}) {
    this.meta.addAll(meta);
    this.links.addAll(links);
    source.parameter = sourceParameter;
    source.pointer = sourcePointer;
  }

  /// A unique identifier for this particular occurrence of the problem.
  String id;

  /// The HTTP status code applicable to this problem, expressed as a string value.
  String status;

  /// An application-specific error code, expressed as a string value.
  String code;

  /// A short, human-readable summary of the problem that SHOULD NOT change
  /// from occurrence to occurrence of the problem, except for purposes of localization.
  String title;

  /// A human-readable explanation specific to this occurrence of the problem.
  /// Like title, this field’s value can be localized.
  String detail;

  /// Meta data.
  final meta = <String, Object/*?*/>{};

  /// Error source.
  final source = ErrorSource();

  /// Error links.
  final links = <String, Link>{};

  Map<String, Object> toJson() => {
        if (id.isNotEmpty) 'id': id,
        if (status.isNotEmpty) 'status': status,
        if (code.isNotEmpty) 'code': code,
        if (title.isNotEmpty) 'title': title,
        if (detail.isNotEmpty) 'detail': detail,
        if (source.isNotEmpty) 'source': source,
        if (links.isNotEmpty) 'links': links,
        if (meta.isNotEmpty) 'meta': meta,
      };
}
