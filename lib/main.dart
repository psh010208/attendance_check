import 'package:flutter/material.dart';
import 'LoginPage.dart';  // 로그인 페이지 import
import 'SignUpPage.dart';  // 회원가입 페이지 import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(), // 메인 페이지 설정
      routes: {
        '/login': (context) => LoginPage(), // 로그인 페이지 경로 등록
        '/signup': (context) => SignUpPage(), // 회원가입 페이지 경로 등록
      },
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Image.asset(
              'assets/logo.png',
              height: 60,
              width: 150,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 120),
            const Text(
              '제 1회 SW융합대학 학술제',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 200),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login'); // '/login' 페이지로 이동
                  },
                  child: Text('로그인'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup'); // '/signup' 페이지로 이동
                  },
                  child: Text('회원가입'),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
