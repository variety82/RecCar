import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

// enum Method { get, post }

// apiInstance를 만듭니다
Future<dynamic> analysisCarDamageApi({
  // parameter로 path, method, success 콜백함수, fail 콜백함수, body를 받습니다
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  required String filePath,
  required String? user_id,
}) async {
  // api URL 주소를 넣습니다
  final encodedUserId = Uri.encodeComponent(user_id!);
  String URL =
      'http://j8a102.p.ssafy.io:8081/ai-api/v1/damage?user_id=$encodedUserId';
  // uri 형식으로 변경합니다
  final url = Uri.parse(URL);

  // 기본 headers
  Map<String, String> headers = {
    "accept": "application/json",
    "Content-Type": "multipart/form-data",
  };

  var request = http.MultipartRequest("POST", url);
  request.headers.addAll(headers);
  File file = File(filePath);

  request.files.add(await http.MultipartFile.fromPath("file", filePath));
  var response = await request.send();

  if (200 <= response.statusCode && response.statusCode < 300) {
    // statuse가 200대이면 성공으로 해서 jsonResponse를 쓰는 콜백함수로 보내줍니다
    String responseBody = await response.stream.transform(utf8.decoder).join();
    dynamic jsonResponse = jsonDecode(responseBody);
    dynamic jsonList = jsonResponse;

    List<Map<String, dynamic>> carDamagesAllList = [];

    if (jsonList.length > 0) {
      for (int i = 0; i < jsonList.length; i++) {
        Map<String, dynamic> carDamageState = {
          "index": i,
          "Damage_Image_URL": jsonList[i]['url'],
          "part": "",
          "Scratch": 0,
          "Crushed": 0,
          "Breakage": 0,
          "Separated": 0,
          "timeStamp": i,
          "damageView": '미정',
          "memo": "",
          "selected": false,
        };
        carDamagesAllList.add(carDamageState);
      }
    }

    return success(carDamagesAllList);
  } else {
    // 200대가 아니면 에러 코드를 보내줍니다
    print(response.statusCode);
    fail('${response.statusCode} 에러');
  }
}
