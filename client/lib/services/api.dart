import 'dart:convert';
import 'package:http/http.dart' as http;

Future<dynamic> apiInstance({
  required String path,
  required String method,
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  Map<String, String>? body,
}) async {
    String URL = 'http://j8a102.p.ssafy.io:8080/api/v1$path';
    Map<String, String> headers =  {
      "Content-Type": "application/json;charset=utf-8",
  };

  if (method == 'get') {
    final url = Uri.parse(URL);
    final response = await http.get(
        url,
        headers: headers,
    );

    if (200 <= response.statusCode && response.statusCode < 300) {
      dynamic jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return success(jsonResponse);
    } else {
      fail('${response.statusCode} 에러');
    }
  }

  if (method == 'post') {
    final url = Uri.parse(URL);
    final response = await http.post(
      url,
      headers: headers,
      body : body,
    );

    if (200 <= response.statusCode && response.statusCode < 300) {
      List jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return success(jsonResponse);
    } else {
      fail('${response.statusCode} 에러');
    }
  }
}