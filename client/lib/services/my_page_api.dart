import 'package:client/services/api.dart';

// 렌트 내역
void getSimpleRentInfo({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  Map<String, String>? body,
}) {
  apiInstance(
    path : '/car/history',
    method : Method.get,
    body: body,
    success: success,
    fail: fail,
  );
}

// 렌트 상세 내역
void getDetailRentInfo({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  required int carId,
  Map<String, String>? body,
}) {
  apiInstance(
    path: '/detection/rental?carId=${carId}',
    method: Method.get,
    body: body,
    success: success,
    fail: fail,
  );
}

// 파손 내역
void getSimpleDamageInfo({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  required int carId,
  Map<String, String>? body,
}) {
  apiInstance(
    path: '/detection?carId=${carId}',
    method: Method.get,
    body: body,
    success: success,
    fail: fail,
  );
}

// 파손 상세 내역
void getDetailDamageInfo({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  required int damageId,
  Map<String, String>? body,
}) {
  apiInstance(
    path: '/detection/${damageId}',
    method: Method.get,
    body: body,
    success: success,
    fail: fail,
  );
}
