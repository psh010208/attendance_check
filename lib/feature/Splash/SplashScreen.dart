import 'package:flutter/material.dart';
import 'dart:async';
import 'package:attendance_check/feature/screen/manager/PrizeDrawPage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 타이머를 설정하여 3초 후에 다음 화면으로 이동
    Timer(Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => PrizeDrawPage()), // 메인 화면으로 이동
      );
    });

    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            // 로고 이미지
            Positioned(
              top: 300.h, // 반응형 높이 설정
              left: 130.w, // 반응형 너비 설정
              child: Image.asset(
                'assets/appLogo.png', // 로고 파일 경로
                width: 150.w, // 반응형 너비 설정
                height: 150.h, // 반응형 높이 설정
              ),
            ),

            // 앱 이름 텍스트
            Stack(
              children: [
                // 첫 번째 텍스트 (외곽선)
                Positioned(
                  bottom: 300.h, // 반응형 위치 설정
                  left: 80.w, // 반응형 위치 설정
                  child: Text(
                    'Soon CHeck',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: 50.sp, // 반응형 폰트 크기 설정
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 6.w // 반응형 외곽선 두께
                        ..color = Theme.of(context).shadowColor,
                      shadows: const <Shadow>[
                        Shadow(
                          offset: Offset(0, 10),
                          blurRadius: 10,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),

                // 두 번째 텍스트 (채우기 색상)
                Positioned(
                  bottom: 300.h, // 반응형 위치 설정
                  left: 80.w, // 반응형 위치 설정
                  child: Text(
                    'Soon CHeck',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: 50.sp, // 반응형 폰트 크기 설정
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),

                // 가운데 일부 텍스트
                Positioned(
                  bottom: 300.h, // 반응형 위치 설정
                  left: 82.8.w, // 반응형 위치 설정
                  child: Text(
                    '  oon',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: 50.sp, // 반응형 폰트 크기 설정
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),

                // 오른쪽 일부 텍스트
                Positioned(
                  bottom: 300.h, // 반응형 위치 설정
                  left: 54.2.w, // 반응형 위치 설정
                  child: Text(
                    '                eck',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: 50.sp, // 반응형 폰트 크기 설정
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
