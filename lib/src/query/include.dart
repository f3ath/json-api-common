import 'dart:collection';

import 'package:maybe_just_nothing/maybe_just_nothing.dart';

/// Query parameter defining inclusion of related resources.
/// @see https://jsonapi.org/format/#fetching-includes
class Include with ListMixin<String> {
  /// Example:
  /// ```dart
  /// Include(['comments', 'comments.author']);
  /// ```
  Include([Iterable<String> resources]) {
    Maybe(resources).ifPresent(addAll);
  }

  static Include fromUri(Uri uri) => Include(
      uri.queryParametersAll['include']?.expand((_) => _.split(',')) ?? []);

  final _ = <String>[];

  /// Converts to a map of query parameters
  Map<String, String> get asQueryParameters => {'include': join(',')};

  @override
  Iterator<String> get iterator => _.iterator;

  @override
  int get length => _.length;

  @override
  set length(int newLength) => _.length = newLength;

  @override
  String operator [](int index) => _[index];

  @override
  void operator []=(int index, String value) => _[index] = value;
}
