import 'package:client/services/analysis_car_damage_api.dart';

// 일정 불러오기
void getCarAnalysis({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  required String filePath,
  Map<String, String>? body,
}) {
  analysisCarDamageApi(
    success: success,
    fail: fail,
    filePath: filePath,
    user_id: 1,
  );
}
