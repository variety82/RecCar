import 'dart:convert';
import 'package:http/http.dart' as http;

enum Method { get, post }

Future<dynamic> apiInstance({
  required String path,
  required Method method,
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  Map<String, String>? body,
}) async {
  String URL = 'http://j8a102.p.ssafy.io:8080/api/v1$path';
  Map<String, String> headers = {
    "Content-Type": "application/json;charset=utf-8",
  };

  final url = Uri.parse(URL);
  late http.Response response;

  switch (method) {
    case Method.get:
      response = await http.get(
          url,
          headers: headers
      );
      break;
    case Method.post:
      response = await http.post(
          url,
          headers: headers,
          body: body
      );
      break;
  }

  if (200 <= response.statusCode && response.statusCode < 300) {
    dynamic jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
    return success(jsonResponse);
  } else {
    fail('${response.statusCode} 에러');
  }
}