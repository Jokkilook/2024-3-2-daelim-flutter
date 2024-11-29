import 'package:daelim_project/helpers/storage_helper.dart';
import 'package:daelim_project/routes/app_screen.dart';
import 'package:daelim_project/screens/chat/chat_screen.dart';
import 'package:daelim_project/screens/login/login_screen.dart';
import 'package:daelim_project/screens/rooms/rooms_screen.dart';
import 'package:daelim_project/screens/setting/setting_screen.dart';
import 'package:daelim_project/screens/users/users_screen.dart';
import 'package:easy_extension/easy_extension.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: AppScreen.login.toPath,
  redirect: (context, state) {
    Log.green('Route FullPath: ${state.fullPath}');

    if (state.fullPath == AppScreen.login.toPath) {
      return null;
    }

    if (StorageHelper.authData == null) {
      return AppScreen.login.toPath;
    }

    return null;
  },
  routes: [
    // NOTE: 로그인 화면
    GoRoute(
      path: AppScreen.login.toPath,
      name: AppScreen.login.name,
      builder: (context, state) => const LoginScreen(),
    ),
    // NOTE: 유저 목록 화면
    GoRoute(
      path: AppScreen.users.toPath,
      name: AppScreen.users.name,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: UsersScreen(),
      ),
    ),
    // NOTE: 채팅 목록 화면
    GoRoute(
      path: AppScreen.chattingRooms.toPath,
      name: AppScreen.chattingRooms.name,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: RoomsScreen(),
      ),
    ),
    // NOTE: 채팅 화면
    GoRoute(
      path: '${AppScreen.chat.toPath}/:roomId',
      name: AppScreen.chat.name,
      pageBuilder: (context, state) {
        final roomId = state.pathParameters['roomId'];

        Log.green('채팅화면 전환: $roomId');

        return NoTransitionPage(
          child: ChatScreen(
            roomId: roomId!,
          ),
        );
      },
    ),
    // NOTE: 설정 화면
    GoRoute(
      path: AppScreen.setting.toPath,
      name: AppScreen.setting.name,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: SettingScreen(),
      ),
    ),
  ],
);
