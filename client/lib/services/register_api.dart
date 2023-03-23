import 'package:client/services/api.dart';

void getCarinfo({
  // success 콜백함수와 fail 콜백함수, body를 받아줍니다
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  Map<String, String>? body,
}) {
  // path 및 method를 입력해줍니다
  apiInstance(
    path : '/car/catalog',
    method : Method.get,
    success: success,
    fail: fail,
  );
}

