import 'package:flutter/material.dart';
import 'dart:async';
import 'package:attendance_check/feature/screen/manager/PrizeDrawPage.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 타이머를 설정하여 3초 후에 다음 화면으로 이동
    Timer(Duration(seconds: 100000), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => PrizeDrawPage()), // 메인 화면으로 이동
      );
    });

    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Column(
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
                Positioned(
                  top: 300.w,
                  left: 300.w,
                  child: Text(
                    'Soon CHeck',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: 50.sp, // 반응형 폰트 크기 설정
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 5
                        ..color = Theme.of(context).primaryColor,
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
                Positioned(
                  child: Text(
                    'Soon CHeck',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: 50.sp, // 반응형 폰트 크기 설정
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 5
                        ..color = Colors.black,
                      shadows: const <Shadow>[
                        Shadow(offset: Offset(0, 3),
                          blurRadius: 10,
                          color: Colors.grey,
                        ),
                      ],
                      // shadows: [
                      //   // 첫 번째 외곽선 (검정색)
                      //   Shadow(
                      //     offset: Offset(0, 0),
                      //     blurRadius: 1.6, // 외곽선 두께
                      //     color: Color(0xFF0B0C0C), // 검정색 외곽선
                      //   ),
                      //   // 두 번째 외곽선 (파란색)
                      //   Shadow(
                      //     offset: Offset(0, 0),
                      //     blurRadius: 1.2, // 외곽선 두께
                      //     color: Color(0xFF0C3C73), // 파란색 외곽선
                      //   ),
                      // ],
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