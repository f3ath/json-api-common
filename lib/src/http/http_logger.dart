import 'package:json_api_common/http.dart';

abstract class HttpLogger {
  void onRequest(HttpRequest request);

  void onResponse(HttpResponse response);
}
