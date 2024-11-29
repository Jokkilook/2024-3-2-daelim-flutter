import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum AppScreen { login, chat, users, chattingRooms, setting }

extension AppScreenExtension on AppScreen {
  String get toPath {
    switch (this) {
      case AppScreen.login:
        return '/login';
      case AppScreen.users:
        return '/users';
      case AppScreen.chattingRooms:
        return '/chatting-rooms';
      case AppScreen.chat:
        return '/chat';
      case AppScreen.setting:
        return '/setting';
    }
  }

  IconData get getIcon {
    switch (this) {
      case AppScreen.users:
        return LucideIcons.users;
      case AppScreen.chattingRooms:
        return LucideIcons.messageCircleMore;
      case AppScreen.setting:
        return LucideIcons.settings2;
      default:
        return LucideIcons.dot;
    }
  }
}
