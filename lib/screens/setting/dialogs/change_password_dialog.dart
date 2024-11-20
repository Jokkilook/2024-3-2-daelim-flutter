import 'package:daelim_project/extensions/context_extension.dart';
import 'package:daelim_project/helpers/api_helper.dart';
import 'package:daelim_project/helpers/storage_helper.dart';
import 'package:daelim_project/routes/app_screen.dart';
import 'package:easy_extension/easy_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _currentPwController = TextEditingController();
  final _newPwController = TextEditingController();
  final _newConfirmPwController = TextEditingController();

  final _currentPwFormKey = GlobalKey<FormState>();
  final _newPwFormKey = GlobalKey<FormState>();
  final _newConfirmPwFormKey = GlobalKey<FormState>();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureNewConfirm = true;

  final _bgColor = const Color(0xFFF3F4F6);

  String _currentPasswordValidateMsg = '';

  @override
  void dispose() {
    _currentPwController.dispose();
    _newPwController.dispose();
    _newConfirmPwController.dispose();
    super.dispose();
  }

  /// NOTE: 입력란 검증
  /// - Empty Value 체크
  String? _validator(String? value) {
    if (value == null || value.isEmpty || value.trim().isEmpty) {
      return '이 입력란을 작성하세요.';
    }
    return null;
  }

  /// NOTE: 비밀번호 변경
  void _onChangedPassword() async {
    setState(() => _currentPasswordValidateMsg = '');

    final currentValidate = _currentPwFormKey.currentState?.validate() ?? false;
    final newValidate = _newPwFormKey.currentState?.validate() ?? false;
    final newConfirmValidate = _newConfirmPwFormKey.currentState?.validate() ?? false;

    if (!currentValidate || !newValidate || !newConfirmValidate) {
      return;
    }

    final currentPassword = _currentPwController.text;
    final newPassword = _newPwController.text;

    // TODO: 현재 비밀번호 검사 -> 검사 실패 시 에러 표시
    final authData = await ApiHelper.signIn(
      email: StorageHelper.authData!.email,
      password: currentPassword,
    );

    if (authData == null) {
      return setState(() {
        _currentPasswordValidateMsg = '현재 비밀번호가 일치하지 않습니다';
      });
    }

    final (success, error) = await ApiHelper.changePassword(newPassword);

    // NOTE: 비밀번호 변경 에러
    if (!success) {
      Log.red('비밀번호 변경 에러: $error');
      if (mounted) {
        context.showSnackBarText('비밀번호를 변경할 수 없습니다.');
      }
      return;
    }

    // NOTE: 비밀번호 변경 성공
    await StorageHelper.removeAuthData();

    if (mounted) {
      context.showSnackBarText(
        '비밀번호를 변경했습니다. 다시 로그인해주세요.',
      );
      context.goNamed(AppScreen.login.name);
    }
  }

  // NOTE: 비밀번호 입력 위젯
  Widget _buildTextField({
    required Key formKey,
    required TextEditingController textController,
    required String hintText,
    bool obscureText = true,
    String? Function(String? value)? validator,
    VoidCallback? onObscurePressed,
  }) {
    return ListTile(
      dense: true,
      title: Form(
        key: formKey,
        child: TextFormField(
          controller: textController,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            filled: false,
            suffixIcon: InkWell(
              onTap: onObscurePressed,
              child: Icon(
                obscureText //
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
            ),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: _bgColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 40,
          horizontal: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '비밀번호 변경',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            30.heightBox,
            Card(
              elevation: 0,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: context.theme.dividerColor,
                ),
              ),
              child: Column(
                children: ListTile.divideTiles(
                  context: context,
                  tiles: [
                    // NOTE: 현재 비밀번호 입력란
                    _buildTextField(
                      formKey: _currentPwFormKey,
                      textController: _currentPwController,
                      hintText: '현재 비밀번호',
                      obscureText: _obscureCurrent,
                      validator: (value) {
                        return _validator(value);
                      },
                      onObscurePressed: () {
                        setState(() {
                          _obscureCurrent = !_obscureCurrent;
                        });
                      },
                    ),

                    Container(
                      height: 20,
                      color: _bgColor,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _currentPasswordValidateMsg,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),

                    // NOTE: 새 비밀번호 입력란
                    _buildTextField(
                      formKey: _newPwFormKey,
                      textController: _newPwController,
                      hintText: '새 비밀번호',
                      obscureText: _obscureNew,
                      validator: (value) {
                        final isEmptyValidate = _validator(value);

                        if (isEmptyValidate != null) {
                          return isEmptyValidate;
                        }

                        if (value!.length < 6) {
                          return '6글자 이상 설정해야합니다.';
                        }

                        return null;
                      },
                      onObscurePressed: () {
                        setState(() {
                          _obscureNew = !_obscureNew;
                        });
                      },
                    ),
                    // NOTE: 새 비밀번호 확인 입력란
                    _buildTextField(
                      formKey: _newConfirmPwFormKey,
                      textController: _newConfirmPwController,
                      hintText: '새 비밀번호 확인',
                      obscureText: _obscureNewConfirm,
                      validator: (value) {
                        final isEmptyValidate = _validator(value);

                        if (isEmptyValidate != null) {
                          return isEmptyValidate;
                        }

                        final newPassword = _newPwController.text;

                        if (value != newPassword) {
                          return '비밀번호가 일치하지 않습니다';
                        }

                        return null;
                      },
                      onObscurePressed: () {
                        setState(() {
                          _obscureNewConfirm = !_obscureNewConfirm;
                        });
                      },
                    ),
                  ],
                ).toList(),
              ),
            ),

            20.heightBox,

            // NOTE: 비밀번호 변경 버튼
            ElevatedButton(
              onPressed: _onChangedPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4E46DC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '변경하기',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
