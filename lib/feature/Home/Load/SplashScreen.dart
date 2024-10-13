import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Home/widget/SoonCheck.dart';
import '../../Log/logPage.dart'; // Log Page import
import '../../Drawer/drawerScreen.dart'; // Drawer import
import 'package:attendance_check/feature/Home/homeScreen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 3초 후에 다음 화면으로 이동 (logPage로)
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });

    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            // 로고 이미지 위치 및 크기
            Positioned(
              top: (ScreenUtil().screenWidth / 1.w) - (230.w / 2.w), // 반응형 높이 설정
              left: (ScreenUtil().screenWidth / 2.w) - (70.w), // 중앙 정렬을 위한 좌표 계산
              child: Image.asset(
                'assets/appLogo.png', // 로고 파일 경로
                width: 150.w, // 반응형 너비 설정
                height: 150.h, // 반응형 높이 설정
              ),
            ),

            // 재사용 가능한 SoonCheckWidget
            SoonCheckWidget(
              bottom: (ScreenUtil().screenWidth / 1.w) - (140.w /1.w ), // 반응형 설정
              left: (ScreenUtil().screenWidth / 2.w) - (380.w / 2.w), // 중앙 정렬을 위한 계산
            ),
          ],
        ),
      ),
    );
  }
}
