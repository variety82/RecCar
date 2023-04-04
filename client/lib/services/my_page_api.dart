import 'package:client/services/api.dart';

// 렌트 내역
void getSimpleRentInfo({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  Map<String, String>? body,
}) {
  apiInstance(
    path: '/car/history',
    method: Method.get,
    body: body,
    success: success,
    fail: fail,
  );
}

// 렌트 상세 내역
void getDetailRentInfo({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  Map<String, dynamic>? body,
  required int carId,
}) {
  apiInstance(
    path: '/detection?carId=${carId}',
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
  Map<String, dynamic>? body,
  required int carId,
}) {
  apiInstance(
    path: '/detection?carId=${carId}',
    method: Method.get,
    body: body,
    success: success,
    fail: fail,
  );
}

// 회원 정보 초기화
void deleteUserInfo({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  Map<String, String>? body,
}) {
  apiInstance(
    path: '/user/delete',
    method: Method.delete,
    body: body,
    success: success,
    fail: fail,
  );
}

// 현재 대여중인 차량 조회
void getRentedCarInfo({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  Map<String, String>? body,
}) {
  apiInstance(
    path: '/car/current',
    method: Method.get,
    body: body,
    success: success,
    fail: fail,
  );
}

// 차량 정보 수정
void putCarInfo({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  Map<String, dynamic>? body,
}) {
  apiInstance(
    path: '/car/',
    method: Method.put,
    body: body,
    success: success,
    fail: fail,
  );
}

// 차량 정보 삭제
void deleteCarInfo({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  Map<String, dynamic>? body,
  required int carId,
}) {
  apiInstance(
    path: '/car/${carId}',
    method: Method.delete,
    body: body,
    success: success,
    fail: fail,
  );
}
