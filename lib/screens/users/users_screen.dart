import 'package:daelim_project/common/scaffold/app_scaffold.dart';
import 'package:daelim_project/extensions/context_extension.dart';
import 'package:daelim_project/helpers/api_helper.dart';
import 'package:daelim_project/models/user_data.dart';
import 'package:daelim_project/routes/app_screen.dart';
import 'package:daelim_project/screens/users/widgets/user_item.dart';
import 'package:easy_extension/easy_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<UserData> _users = [];
  List<UserData> _searchedUsers = [];

  final _defaultInputBorder = const OutlineInputBorder(
    borderSide: BorderSide(
      color: Color(0xFFE4E4E7),
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
  );

  @override
  void initState() {
    super.initState();
    _fetchUserList();
  }

  /// NOTE: 유저 목록 가져오기
  Future<void> _fetchUserList() async {
    _users = await ApiHelper.fetchUserList();

    setState(() {
      _searchedUsers = _users;
    });
  }

  // NOTE: 유저 검색
  void _onSearch(String value) {
    setState(() {
      _searchedUsers = _users
          .where(
            (e) => e.name.toLowerCase().contains(value.toLowerCase()),
          )
          .toList();
    });
  }

  // NOTE: 채팅방 개설
  Future<void> _onCreateRoom(UserData user) async {
    Log.green('채팅방 개설: ${user.name}');

    final (code, roomId) = await ApiHelper.createChatRoom(user.id);

    switch (code) {
      case 200:
        Log.green('채팅방 개설 완료: $roomId');
        break;
      case 1001:
        return context.showSnackBarText('상대방 ID는 필수입니다.');
      case 1002:
        return context.showSnackBarText('자신과 대화할 수 없습니다.');
      case 1003:
        return context.showSnackBarText('상대방 검색에 실패했습니다.');
      case 1004:
        return context.showSnackBarText('챗봇만 대화가 가능합니다.');
      case 1005:
        Log.green('채팅방 이미 개설되어 있음: $roomId');
        context.pushNamed(
          AppScreen.chat.name,
          pathParameters: {'roomId': roomId},
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userCount = _searchedUsers.length;

    return AppScaffold(
      appScreen: AppScreen.users,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NOTE: 유저 목록 타이틀
                Text(
                  '유저 목록 ($userCount)',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),

                15.heightBox,

                // NOTE: 검색바
                TextField(
                  onChanged: _onSearch,
                  decoration: InputDecoration(
                    filled: false,
                    enabledBorder: _defaultInputBorder,
                    focusedBorder: _defaultInputBorder.copyWith(
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    hintText: '유저 검색...',
                    prefixIcon: const Icon(LucideIcons.search),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          if (_searchedUsers.isEmpty)
            // NOTE: 검색 결과 없음
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 10),
              child: const Text(
                '검색결과가 없습니다.',
                style: TextStyle(fontSize: 20),
              ),
            )
          else
            // NOTE: 유저 리스트뷰
            Expanded(
              child: ListView.separated(
                itemCount: _searchedUsers.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final user = _searchedUsers[index];

                  return UserItem(
                    user: user,
                    onTap: () => _onCreateRoom(user),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
