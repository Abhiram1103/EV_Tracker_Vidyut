import 'dart:convert';
import 'package:http/http.dart' as http;

Future<bool> loginUser(String phone, String password) async {
  String basicAuth = 'Basic ${base64Encode(utf8.encode('$phone:$password'))}';
  var response = await http.get(
    Uri.parse('https://your-backend-api/login'),
    headers: {'authorization': basicAuth},
  );
  return response.statusCode == 200;
}
