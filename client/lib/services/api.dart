import 'dart:convert';
import 'package:http/http.dart' as http;

enum Method { get, post }

// apiInstance를 만듭니다
Future<dynamic> apiInstance({
  // parameter로 path, method, success 콜백함수, fail 콜백함수, body를 받습니다
  required String path,
  required Method method,
  String? accessToken,
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  Map<String, dynamic>? body,
}) async {
  // api URL 주소를 넣습니다
  String URL = 'http://j8a102.p.ssafy.io:8080/api/v1$path';
  // uri 형식으로 변경합니다
  final url = Uri.parse(URL);

  // 기본 headers
  Map<String, String> headers = {
    "Content-Type": "application/json;charset=utf-8",
    "authorization": '$accessToken',
  };

  // response 값입니다
  late http.Response response;

  // method에 따라 다르게 요청하고 response값을 받습니다
  switch (method) {
    case Method.get:
      try {
        response = await http.get(url, headers: headers);
      } catch (error) {
        fail('HTTP 요청 처리 중 오류 발생: $error');
      }
      break;
    case Method.post:
      try {
        response =
            await http.post(url, headers: headers, body: json.encode(body));
      } catch (error) {
        fail('HTTP 요청 처리 중 오류 발생: $error');
      }
      break;
  }

  if (200 <= response.statusCode && response.statusCode < 300) {
    // statuse가 200대이면 성공으로 해서 jsonResponse를 쓰는 콜백함수로 보내줍니다
    late dynamic jsonResponse;
    if (response.body.isNotEmpty) {
      jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      jsonResponse = {};
    }
    return success(jsonResponse);
  } else {
    // 200대가 아니면 에러 코드를 보내줍니다
    fail('${response.statusCode} 에러');
  }
}
