import 'dart:collection';

import 'package:maybe_just_nothing/maybe_just_nothing.dart';

/// Query parameters defining Sparse Fieldsets
/// @see https://jsonapi.org/format/#fetching-sparse-fieldsets
class Fields with MapMixin<String, List<String>> {
  /// The [fields] argument maps the resource type to a list of fields.
  ///
  /// Example:
  /// ```dart
  /// Fields({'articles': ['title', 'body'], 'people': ['name']});
  /// ```
  Fields([Map<String, List<String>> fields]) {
    Maybe(fields).ifPresent(addAll);
  }

  /// Extracts the requested fields from the [uri].
  static Fields fromUri(Uri uri) =>
      Fields(uri.queryParametersAll.map((k, v) => MapEntry(
          _regex.firstMatch(k)?.group(1),
          v.expand((_) => _.split(',')).toList()))
        ..removeWhere((k, v) => k == null));

  final _ = <String, List<String>>{};

  /// Converts to a map of query parameters
  Map<String, String> get asQueryParameters =>
      _.map((k, v) => MapEntry('fields[$k]', v.join(',')));

  @override
  void operator []=(String key, List<String> value) => _[key] = value;

  @override
  void clear() => _.clear();

  @override
  Iterable<String> get keys => _.keys;

  @override
  List<String> remove(Object key) => _.remove(key);

  @override
  List<String> operator [](Object key) => _[key];
}

final _regex = RegExp(r'^fields\[(.+)\]$');
