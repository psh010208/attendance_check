import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Home/widget/SoonCheck.dart';
import 'package:attendance_check/feature/Home/homeScreen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 3초 후에 다음 화면으로 이동 (logPage로)
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen(role: '', id: '',)),
      );
    });

    // 화면 너비와 높이 가져오기
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.onInverseSurface,
              Theme.of(context).primaryColorLight,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.3, 0.9],
          ),
        ),
        child: Center(
          child: Stack(
            children: [
              // 로고 이미지 위치 및 크기
              Positioned(
                top: screenHeight * 0.3, // 화면 높이에 비례하여 위치 조정
                left: screenWidth/ 3, // 화면 너비에 비례하여 중앙 정렬
                child: Image.asset(
                  'assets/appLogo.png', // 로고 파일 경로
                  width: 150.w, // 반응형 너비 설정
                  height: 150.h, // 반응형 높이 설정
                ),
              ),

              // 재사용 가능한 SoonCheckWidget
              SoonCheckWidget(
                bottom: screenHeight * 0.38, // 화면 높이에 비례한 위치 조정
                left: screenWidth / 4.5, // 화면 너비에 비례하여 중앙 정렬
              ),
            ],
          ),
        ),
      ),
    );
  }
}
