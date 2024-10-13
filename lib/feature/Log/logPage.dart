import 'package:attendance_check/feature/Log/widget/SignInForm.dart';
import 'package:attendance_check/feature/Log/widget/SignUpForm.dart';
import 'package:flutter/material.dart';


class logPage extends StatelessWidget {
  final bool isLogin; // true: 로그인, false: 회원가입이니까 참고해용!

  logPage({required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLogin ? SignInForm() : SignUpForm(),
      ),
    );
  }
}
