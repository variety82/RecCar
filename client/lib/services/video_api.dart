import 'dart:io';
import 'package:http/http.dart' as http;

// StreamedResponse 타입으로 지정
// Response 클래스를 상속하며, 추가로 속성과 메서드 제공함
// filePath를 제공받는 것으로 해당 경로에 있는 파일 가져옴!
Future<http.StreamedResponse> uploadVideo(String filePath) async {
  final url = Uri.parse('');
  final file = File(filePath);
  var request = http.MultipartRequest('POST', url);
  request.files.add(await http.MultipartFile.fromPath('video', filePath));

  var response = await request.send();

  // api 전송 성공 시 어쩌구 저쩌구~
  if (response.statusCode == 200) {
    return response;
  } else {
    return response;
  }
}
