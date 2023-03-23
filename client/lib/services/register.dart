import 'package:client/services/api.dart';

void getCarinfo({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  Map<String, String>? body,
}) {
  apiInstance(
    path : '/car/catalog',
    method : Method.get,
    body: body,
    success: success,
    fail: fail,
  );
}

