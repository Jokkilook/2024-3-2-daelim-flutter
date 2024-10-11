import 'dart:convert';
import 'dart:io';
import 'package:daelim_project/common/scaffold/app_scaffold.dart';
import 'package:daelim_project/config.dart';
import 'package:daelim_project/helpers/storage_helper.dart';
import 'package:daelim_project/routes/app_screen.dart';
import 'package:easy_extension/easy_extension.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  Future<Map<String, dynamic>> fetchUserData() async {
    final tokenType = StorageHelper.authData!.tokenType.firstUpperCase;
    final token = StorageHelper.authData!.token;

    final response = await http.get(
      Uri.parse(getUserDataUrl),
      headers: {HttpHeaders.authorizationHeader: "$tokenType $token"},
    );

    final body = utf8.decode(response.bodyBytes);

    await Future.delayed(const Duration(seconds: 2));

    if (response.statusCode != 200) {
      throw Exception(response.body);
    } else {
      return jsonDecode(body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appScreen: AppScreen.setting,
      child: Column(
        children: [
          FutureBuilder(
            future: fetchUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(
                  child: Container(
                      margin: const EdgeInsets.all(20),
                      child: const CircularProgressIndicator()),
                );
              }

              final error = snapshot.error;

              final userData = snapshot.data;

              String name = "";
              String studentNumber = "";
              String imageUrl =
                  "https://daelim-server.fleecy.dev/storage/v1/object/public/icons/user.png";

              if (error != null) {
                name = "데이터를 불러올 수 없습니다.";
                studentNumber = '$error';
              } else {
                name = userData?["name"] ?? "";
                studentNumber = userData?["student_number"] ?? "";
                imageUrl = userData?["profile_image"] ??
                    "https://daelim-server.fleecy.dev/storage/v1/object/public/icons/user.png";
              }

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                ),
                title: Text(name),
                subtitle: Text(studentNumber),
              );
            },
          ),
        ],
      ),
    );
  }
}
