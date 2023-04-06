import 'package:client/services/api.dart';

// 로그인
void login({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  Map<String, String>? body,
}) {
  apiInstance(
    path : '/user/tokenLogin',
    method : Method.post,
    body: body,
    success: success,
    fail: fail,
  );
}