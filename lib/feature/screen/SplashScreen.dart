import 'package:flutter/material.dart';
import 'dart:async';
import 'package:attendance_check/feature/screen/manager/PrizeDrawPage.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 타이머를 설정하여 3초 후에 다음 화면으로 이동
    Timer(Duration(seconds: 3000), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => PrizeDrawPage()), // 메인 화면으로 이동
      );
    });

    return Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 로고 이미지
            Image.asset(
              'assets/appLogo.png', // 로고 파일 경로
              width: 150.w, // 반응형 너비 설정
              height: 150.h, // 반응형 높이 설정
            ),
            SizedBox(height: 20.h), // 반응형 간격 설정
            // 앱 이름 텍스트
            Text(
              'Soon CHeck',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 50.sp, // 반응형 폰트 크기 설정
                overflow: TextOverflow.ellipsis, // 넘치는 텍스트 생략 처리
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('메인 화면')),
      body: Center(child: Text('메인 화면 콘텐츠')),
    );
  }
}
