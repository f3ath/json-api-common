/// An object containing references to the source of the error.
class ErrorSource {
  ErrorSource({this.pointer = '', this.parameter = ''});

  /// Decodes ErrorSource from [json]. Returns the decoded object.
  /// If the [json] has incorrect format, throws  [FormatException].
  static ErrorSource fromJson(dynamic json) {
    if (json is Map) {
      return ErrorSource(
          pointer: json['pointer'] ?? '', parameter: json['parameter'] ?? '');
    }
    throw FormatException('A JSON:API error source must be a JSON object');
  }

  /// A JSON Pointer [RFC6901] to the associated entity in the request document.
  String pointer;

  /// A string indicating which URI query parameter caused the error.
  String parameter;

  bool get isEmpty => pointer.isEmpty && parameter.isEmpty;

  bool get isNotEmpty => !isEmpty;

  Map<String, String> toJson() => {
        if (parameter.isNotEmpty) 'parameter': parameter,
        if (pointer.isNotEmpty) 'pointer': pointer
      };
}
