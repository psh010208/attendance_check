import 'package:attendance_check/feature/Home/widget/SoonCheck.dart';
import 'package:attendance_check/feature/Log/logPage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Drawer/drawerScreen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 타이머를 설정하여 3초 후에 다음 화면으로 이동
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => logPage(isLogin: false)),
      );
    });

    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            // 로고 이미지
            Positioned(
              top: 250.h, // 반응형 높이 설정
              left: 120.w, // 반응형 너비 설정
              child: Image.asset(
                'assets/appLogo.png', // 로고 파일 경로
                width: 150.w, // 반응형 너비 설정
                height: 150.h, // 반응형 높이 설정
              ),
            ),

            // 재사용 가능한 SoonCHeckWidget
            SoonCheckWidget(bottom:310.h,left:-4.w ),
          ],
        ),
      ),
    );
  }
}
