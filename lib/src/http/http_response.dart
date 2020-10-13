import 'package:json_api_common/src/http/headers.dart';

/// The response sent by the server and received by the client
class HttpResponse {
  HttpResponse(this.statusCode, {this.body = '', Map<String, String>? headers}) {
    this.headers.addAll(headers ?? {});
  }

  /// Response status code
  final int statusCode;

  /// Response body
  final String body;

  /// Response headers. Lowercase keys
  final headers = Headers();
}
