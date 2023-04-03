import 'package:client/services/api.dart';

void getDetectionInfo({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  required String? carId,
}) {
  apiInstance(
    path : '/detection?carId=$carId',
    method : Method.get,
    success: success,
    fail: fail,
  );
}