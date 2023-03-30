import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

enum Method { get, post }

// apiInstance를 만듭니다
Future<dynamic> analysisCarDamageApi({
  // parameter로 path, method, success 콜백함수, fail 콜백함수, body를 받습니다
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  required String filePath,
  required int user_id,
}) async {
  // api URL 주소를 넣습니다
  String URL =
      'http://j8a102.p.ssafy.io:8081/ai-api/v1/damage?user_id=${user_id}';
  // uri 형식으로 변경합니다
  final url = Uri.parse(URL);
  print(filePath);
  ByteData byteData = await rootBundle.load('lib/assets/car_video/video.mp4');
  Uint8List uint8List = byteData.buffer.asUint8List();
  String fileData = base64Encode(uint8List);
  print(fileData);
  // 기본 headers
  Map<String, String> headers = {
    "accept": "application/json",
    "Content-Type": "multipart/form-data",
  };

  var request = http.MultipartRequest("POST", url);
  request.headers.addAll(headers);
  File file = File(filePath);
  print('myname');
  print(file);
  request.files.add(await http.MultipartFile.fromPath("file", filePath));
  // request.files.add(await http.MultipartFile.fromBytes(
  //   'file',
  //   bytes,
  //   filename: 'video.mp4',
  //   contentType: MediaType('video', 'mp4'),
  // ));
  print(request);

  var response = await request.send();

  if (200 <= response.statusCode && response.statusCode < 300) {
    // statuse가 200대이면 성공으로 해서 jsonResponse를 쓰는 콜백함수로 보내줍니다
    String responseBody = await response.stream.transform(utf8.decoder).join();
    dynamic jsonResponse = jsonDecode(responseBody);
    dynamic jsonList = jsonResponse;

    List<Map<String, dynamic>> carDamagesAllList = [];

    int time_cnt = 0;
    int index_cnt = 0;
    if (jsonList.length > 0) {
      for (int i = 0; i < jsonList.length; i++) {
        index_cnt += 1;
        print(jsonList[i]['url']);
        Map<String, dynamic> carDamageState = {
          "index": index_cnt,
          "Damage_Image_URL": jsonList[i]['url'],
          "part": "",
          "Scratch": 0,
          "Crushed": 0,
          "Breakage": 0,
          "Separated": 0,
          // "damage": {
          //   "scratch": 0,
          //   "crushed": 0,
          //   "breakage": 0,
          //   "separated": 0,
          // },
          "timeStamp": time_cnt,
          "memo": "",
          "selected": false,
        };
        // carDamageState[carDamageState["damage"]] += 1;
        carDamagesAllList.add(carDamageState);
        if (index_cnt % 3 == 0) {
          time_cnt += 1;
        }
      }
    }

    return success(carDamagesAllList);
  } else {
    // 200대가 아니면 에러 코드를 보내줍니다
    print(response.statusCode);
    fail('${response.statusCode} 에러');
  }
}
