import 'package:client/services/analysis_car_damage_api.dart';
import 'package:client/services/api.dart';

void getCarAnalysis({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  required String filePath,
  Map<String, String>? body,
  required int video_time,
}) {
  analysisCarDamageApi(
    success: success,
    fail: fail,
    filePath: filePath,
    user_id: 'default_name',
    video_time: video_time,
  );
}

void postCarDamageInfo({
  // success 콜백함수와 fail 콜백함수, body를 받아줍니다
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  List<Map<String, dynamic>>? bodyList,
}) {
  // path 및 method를 입력해줍니다
  apiInstance(
    path: '/detection',
    method: Method.post,
    success: success,
    fail: fail,
    bodyList: bodyList,
  );
}
