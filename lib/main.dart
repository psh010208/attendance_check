import 'package:attendance_check/feature/screen/StartPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Startpage(), // 메인 페이지 설정
      routes: {
        '/signin': (context) => SignInPage(), // 로그인 페이지 경로 등록
        '/signup': (context) => SignUpPage(), // 회원가입 페이지 경로 등록
        '/stmain': (context) => MainCardScreen(), // 회원가입 페이지 경로 등록
        '/admain': (context) => MainAdminScreen(), // 회원가입 페이지 경로 등록
      },
    );
  }
}
