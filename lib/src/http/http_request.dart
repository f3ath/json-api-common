import 'package:json_api_common/src/http/headers.dart';

/// The request which is sent by the client and received by the server
class HttpRequest {
  HttpRequest(String method, this.uri,
      {this.body = '', Map<String, String> headers = const {}})
      : method = method.toLowerCase() {
    this.headers.addAll(headers);
  }

  /// Requested URI
  final Uri uri;

  /// Request method, lowercase
  final String method;

  /// Request body
  final String body;

  /// Request headers. Lowercase keys
  final headers = Headers();
}
