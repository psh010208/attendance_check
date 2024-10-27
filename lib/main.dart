import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:attendance_check/feature/Home/Load/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:attendance_check/feature/Store/MyStore.dart';

import 'feature/NotificationService/NotificationService.dart';
import 'feature/NotificationService/ViewModel/NotificationServiceViewModel.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();  // Firebase 초기화
    await AndroidAlarmManager.initialize();  // 알람 매니저 초기화
    await NotificationService.init();  // 로컬 알림 초기화
    print('Firebase 초기화 성공');

    // NotificationServiceViewModel 인스턴스를 생성하고 알림 예약 호출
    final notificationServiceViewModel = NotificationServiceViewModel();
    await notificationServiceViewModel.scheduleNotifications();  // 모든 일정에 대해 알림 예약
  } catch (e) {
    print('Firebase 초기화 중 오류 발생: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyStore()),  // MyStore Provider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('ScreenUtil 적용 확인');

    return ScreenUtilInit(
      minTextAdapt: true, // 작은 화면에서 텍스트 크기를 자동으로 조정
      splitScreenMode: true, // 화면 분할 시에도 적절하게 조정
      designSize: const Size(390, 844), // 기준 해상도를 모바일에 맞춰 설정
      builder: (context, child) {
        return MaterialApp(
          home: const SplashScreen(), // 메인 페이지 설정
          debugShowCheckedModeBanner: false, // 디버그 마크 제거
          theme: FlexThemeData.light(
              scheme: FlexScheme.blueM3, // M3 Blue Delight 테마 선택
              useMaterial3: false,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue[800]!,  // Applying Colors.blue[800]
              ),
              textTheme: const TextTheme(
                  titleLarge: TextStyle(fontFamily: "soonchunhyang"),
                  titleSmall: TextStyle(fontFamily: "Abel-Regular")),
              background: Theme.of(context).colorScheme.surface,
              surface: Theme.of(context).colorScheme.surface
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
            background: Theme.of(context).colorScheme.surface, // 다크 모드 배경색
            surface: Theme.of(context).colorScheme.surface, // 다크 모드 서피스 색상
          ),
          themeMode: context.watch<MyStore>().isDarkMode ? ThemeMode.dark : ThemeMode.light, // 테마 모드를 상태에 따라 설정
        );
      },
    );
  }
}
