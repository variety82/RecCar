import 'package:client/services/api.dart';

// 일정 불러오기
void getEvents({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  Map<String, String>? body,
}) {
  apiInstance(
    path : '/calendar/2',
    method : Method.get,
    body: body,
    success: success,
    fail: fail,
  );
}

// 렌트 내역
void getRentInfo({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  Map<String, String>? body,
}) {
  apiInstance(
    path : '/car/history/1',
    method : Method.get,
    body: body,
    success: success,
    fail: fail,
  );
}