import 'dart:collection';

import 'package:maybe_just_nothing/maybe_just_nothing.dart';

/// Query parameters defining the sorting.
/// @see https://jsonapi.org/format/#fetching-sorting
class Sort with ListMixin<SortField> {
  /// The [fields] arguments is the list of sorting criteria.
  ///
  /// Example:
  /// ```dart
  /// Sort(['-created', 'title']);
  /// ```
  Sort([Iterable<String> fields]) {
    Maybe(fields).map((_) => _.map(SortField.parse)).ifPresent(addAll);
  }

  final _ = <SortField>[];

  static Sort fromUri(Uri uri) =>
      Sort((uri.queryParametersAll['sort']?.expand((_) => _.split(',')) ?? []));

  /// Converts to a map of query parameters
  Map<String, String> get asQueryParameters => {'sort': join(',')};

  @override
  int get length => _.length;

  @override
  SortField operator [](int index) => _[index];

  @override
  void operator []=(int index, SortField value) => _[index] = value;

  @override
  set length(int newLength) => _.length = newLength;
}

abstract class SortField {
  static SortField parse(String queryParam) => queryParam.startsWith('-')
      ? Desc(queryParam.substring(1))
      : Asc(queryParam);

  String get name;

  /// Returns 1 for Ascending fields, -1 for Descending
  int get factor;
}

class Asc implements SortField {
  const Asc(this.name);

  @override
  final String name;

  @override
  final int factor = 1;

  @override
  String toString() => name;
}

class Desc implements SortField {
  const Desc(this.name);

  @override
  final String name;

  @override
  final int factor = -1;

  @override
  String toString() => '-$name';
}
