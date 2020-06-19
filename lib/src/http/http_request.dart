/// The request which is sent by the client and received by the server
class HttpRequest {
  HttpRequest(String method, Uri uri,
      {String body, Map<String, String> headers})
      : this._(method.toLowerCase(), uri, _normalize(headers), body ?? '');

  HttpRequest._(this.method, this.uri, this.headers, this.body);

  /// Requested URI
  final Uri uri;

  /// Request method, lowercase
  final String method;

  /// Request body
  final String body;

  /// Request headers. Unmodifiable. Lowercase keys
  final Map<String, String> headers;

  static Map<String, String> _normalize(Map<String, String> headers) =>
      Map.unmodifiable(
          (headers ?? {}).map((k, v) => MapEntry(k.toLowerCase(), v)));

  HttpRequest withHeaders(Map<String, String> headers) =>
      HttpRequest._(method, uri, _normalize(headers), body);

  HttpRequest withUri(Uri uri) => HttpRequest._(method, uri, headers, body);

  bool get isGet => method == 'get';

  bool get isPost => method == 'post';

  bool get isDelete => method == 'delete';

  bool get isPatch => method == 'patch';

  bool get isOptions => method == 'options';
}
