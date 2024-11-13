import 'dart:convert';

import 'package:daelim_project/config.dart';
import 'package:daelim_project/models/auth_data.dart';
import 'package:easy_extension/easy_extension.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  static Future<AuthData?> signIn({
    required String email,
    required String password,
  }) async {
    final loginData = {
      'email': email,
      'password': password,
    };

    final response = await http.post(
      Uri.parse(getTokenUrl),
      body: jsonEncode(loginData),
    );

    final statusCode = response.statusCode;
    final body = utf8.decode(response.bodyBytes);

    if (statusCode != 200) return null;

    final bodyJson = jsonDecode(body) as Map<String, dynamic>;

    bodyJson.addAll({'email': email});

    try {
      return AuthData.fromMap(bodyJson);
    } catch (e, stack) {
      Log.red('유저 정보 파싱 에러: $e\n$stack');
      return null;
    }
  }
}
