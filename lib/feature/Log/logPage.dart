import 'package:attendance_check/feature/Log/widget/SignInForm.dart';
import 'package:attendance_check/feature/Log/widget/SignUpForm.dart';
import 'package:flutter/material.dart';


class logPage extends StatelessWidget {
  final bool isLogin; // true: 로그인, false: 회원가입

  logPage({required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLogin ? SignInForm() : SignUpForm(),
      ),
    );
  }
}
