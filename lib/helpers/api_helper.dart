import 'dart:convert';
import 'dart:io';

import 'package:daelim_project/common/typedef/app_typedef.dart';
import 'package:daelim_project/config.dart';
import 'package:daelim_project/helpers/storage_helper.dart';
import 'package:daelim_project/models/auth_data.dart';
import 'package:daelim_project/models/user_data.dart';
import 'package:daelim_project/routes/app_screen.dart';
import 'package:easy_extension/easy_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  /// GET
  static Future<http.Response> get(String url) {
    final authData = StorageHelper.authData!;

    return http.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.authorizationHeader: '${authData.tokenType} ${authData.token}',
      },
    );
  }

  /// POST
  static Future<http.Response> post(
    String url, {
    Map<String, dynamic>? body,
  }) {
    final authData = StorageHelper.authData;

    return http.post(
      Uri.parse(url),
      headers: authData != null
          ? {
              HttpHeaders.authorizationHeader: '${authData.tokenType} ${authData.token}',
            }
          : null,
      body: body != null //
          ? jsonEncode(body)
          : null,
    );
  }

  /// NOTE: 로그인 API
  /// - [email] 이메일
  /// - [password] 비밀번호
  /// - [return]
  ///   - AuthData
  static Future<AuthData?> signIn({
    required String email,
    required String password,
  }) async {
    final loginData = {
      'email': email,
      'password': password,
    };

    final response = await post(
      Config.api.getToken,
      body: loginData,
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

  /// NOTE: 로그아웃 API
  static Future<void> signOut(BuildContext context) async {
    await StorageHelper.removeAuthData();

    if (!context.mounted) return;

    context.goNamed(AppScreen.login.name);
  }

  /// NOTE: 비밀번호 변경 API
  /// - [newPassword]: 새로운 비밀번호
  static Future<Result> changePassword(String newPassword) async {
    final response = await post(
      Config.api.changePassword,
      body: {
        'password': newPassword,
      },
    );

    final statusCode = response.statusCode;
    final body = utf8.decode(response.bodyBytes);

    if (statusCode != 200) return (false, body);

    return (true, '');
  }

  /// NOTE: 유저 목록 가져오는 API
  static Future<List<UserData>> fetchUserList() async {
    final response = await get(Config.api.getUserList);

    final statusCode = response.statusCode;
    final body = utf8.decode(response.bodyBytes);

    if (statusCode != 200) return [];

    final bodyJson = jsonDecode(body);
    final List<dynamic> data = bodyJson['data'] ?? [];

    return data.map((e) => UserData.fromMap(e)).toList();
  }

  /// NOTE: 채팅방 생성 API
  /// - [userId] 상대방 ID
  static Future<ResultWithCode> createChatRoom(String userId) async {
    final response = await post(
      Config.api.createRoom,
      body: {
        'user_id': userId,
      },
    );

    final statusCode = response.statusCode;
    final body = utf8.decode(response.bodyBytes);

    if (statusCode != 200) {
      return (statusCode, body);
    }

    final bodyJson = jsonDecode(body);

    final int code = bodyJson['code'] ?? 404;
    final Map<String, dynamic> message = bodyJson['message'] ?? {};
    final String roomId = message['room_id'] ?? '';

    return (code, roomId);
  }
}
