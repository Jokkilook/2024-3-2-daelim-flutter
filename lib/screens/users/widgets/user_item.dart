// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:daelim_project/models/user_data.dart';
import 'package:flutter/material.dart';

class UserItem extends StatelessWidget {
  final UserData user;
  final VoidCallback onTap;

  const UserItem({
    super.key,
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFEAEAEA),
        foregroundImage: NetworkImage(
          user.profileImageUrl,
        ),
      ),
      title: Text(
        user.name,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(user.studentNumber),
    );
  }
}
