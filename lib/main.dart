


import 'package:attendance_check/feature/Drawer/drawerScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:attendance_check/feature/Drawer/MyPage.dart';
import 'feature/Drawer/MainAdminScreen.dart';
import 'feature/Home/Load/SplashScreen.dart';
import 'feature/Log/logPage.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 // Primary Dark 색상 사용);
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
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: const Size(390, 844),
      builder: (context, child) {
        return MaterialApp(
          home: logPage(isLogin: false), // 메인 페이지 설정
          theme: FlexThemeData.light(
            scheme: FlexScheme.blueM3, // M3 Blue Delight 테마 선택
            useMaterial3: false,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue[800]!,  // Applying Colors.blue[800]
                background: Theme.of(context).colorScheme.surface,
                surface: Theme.of(context).colorScheme.surface
            ),
            textTheme: const TextTheme(
                titleLarge: TextStyle(fontFamily: "soonchunhyang"),
                titleSmall: TextStyle(fontFamily: "Abel-Regular")),


          ),
          darkTheme: FlexThemeData.dark(
            scheme: FlexScheme.blueM3, // M3 Blue Delight 테마 선택
            useMaterial3: false,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue[800]!,  // Applying Colors.blue[800] in dark mode
              brightness: Brightness.dark,   // 다크 모드 적용
            ),
            textTheme: const TextTheme(
              titleLarge: TextStyle(fontFamily: "soonchunhyang"),
              titleSmall: TextStyle(fontFamily: "Abel-Regular"),
            ),
            // 다크 모드에서 배경 및 서피스 색상 설정
            background: Colors.black, // 다크 모드 배경색
            surface: Colors.grey[900]!, // 다크 모드 서피스 색상
          ),
          themeMode: ThemeMode.light
          ,
        );
      },
    );
  }
}