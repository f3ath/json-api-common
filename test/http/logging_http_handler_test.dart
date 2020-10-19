import 'package:json_api_common/http.dart';
import 'package:json_api_common/src/http/last_value_logger.dart';
import 'package:test/test.dart';

void main() {
  test('Logging handler can log', () async {
    final rq = HttpRequest('get', Uri.parse('http://localhost'));
    final rs = HttpResponse(200, body: 'Hello');
    final log = LastValueLogger();
    final handler =
        LoggingHttpHandler(HttpHandler.fromFunction((_) async => rs), log);
    await handler(rq);
    expect(log.requestOrNull, same(rq));
    expect(log.responseOrNull, same(rs));
  });
}
