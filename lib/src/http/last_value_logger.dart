import 'package:json_api_common/src/http/http_logger.dart';
import 'package:json_api_common/src/http/http_request.dart';
import 'package:json_api_common/src/http/http_response.dart';

class LastValueLogger implements HttpLogger {
  @override
  void onRequest(HttpRequest request) => requestOrNull = request;

  @override
  void onResponse(HttpResponse response) => responseOrNull = response;

  HttpResponse /*?*/ responseOrNull;
  HttpRequest /*?*/ requestOrNull;
}
