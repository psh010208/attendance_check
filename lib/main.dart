import 'package:attendance_check/feature/home/homeScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'feature/screen/LoginPage.dart';  // 로그인 페이지 import
import 'feature/screen/SignUpPage.dart';  // 회원가입 페이지 import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase 초기화

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: homeScreeen(), // 메인 페이지 설정
      routes: {
        '/login': (context) => LoginPage(), // 로그인 페이지 경로 등록
        '/signup': (context) => SignUpPage(), // 회원가입 페이지 경로 등록
      },
    );
  }
}
