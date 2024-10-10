import 'package:attendance_check/feature/screen/StartPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

import 'feature/screen/SignInPage.dart';  // 로그인 페이지 import
import 'feature/screen/SignUpPage.dart';  // 회원가입 페이지 import
import 'feature/screen/student/MainCardScreen.dart';  // 학생 메인 페이지 import
import 'feature/screen/manager/MainAdminScreen.dart';  // 학생 메인 페이지 import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    runApp(const MyApp());
    print('Firebase 초기화 성공');
  } catch (e) {
    print('Firebase 초기화 중 오류 발생: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final FlexScheme usedScheme = FlexScheme.blueM3;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Startpage(), // 메인 페이지 설정
      theme: FlexThemeData.light(
        scheme: usedScheme,
        textTheme: const TextTheme(
            titleLarge: TextStyle(fontFamily: "soonchunhyang"),
            titleSmall: TextStyle(fontFamily: "Abel-Regular",fontSize: 32)),
      ),
    );
  }
}
