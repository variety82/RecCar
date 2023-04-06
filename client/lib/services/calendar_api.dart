import 'package:client/services/api.dart';

// 일정 불러오기
void getEvents({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  Map<String, String>? body,
}) {
  apiInstance(
    path : '/calendar/',
    method : Method.get,
    body: body,
    success: success,
    fail: fail,
  );
}

void postEvent({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  Map<String, dynamic>? body,
}) {
  apiInstance(
    path: '/calendar/',
    method: Method.post,
    success: success,
    fail: fail,
    body: body,
  );
}

// 일정 수정
void putEvent({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  Map<String, dynamic>? body,
}) {
  apiInstance(
    path: '/calendar/',
    method: Method.put,
    success: success,
    fail: fail,
    body: body,
  );
}

// 일정 삭제
void deleteEvent({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  Map<String, dynamic>? body,
  required int calendarId,
}) {
  apiInstance(
    path: '/calendar/${calendarId}',
    method: Method.delete,
    success: success,
    fail: fail,
    body: body,
  );
}
// // 렌트 내역
// void getRentInfo({
//   required dynamic Function(dynamic) success,
//   required Function(String error) fail,
//   Map<String, String>? body,
// }) {
//   apiInstance(
//     path : '/car/history/1',
//     method : Method.get,
//     body: body,
//     success: success,
//     fail: fail,
//   );
// }