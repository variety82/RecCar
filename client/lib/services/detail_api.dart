import 'package:client/services/api.dart';

void getCarInfo({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
}) {
  apiInstance(
    path : '/car/current',
    method : Method.get,
    success: success,
    fail: fail,
  );
}

void getCarReturn({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
}) {
  apiInstance(
    path : '/car/return',
    method : Method.get,
    success: success,
    fail: fail,
  );
}