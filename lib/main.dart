
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:attendance_check/feature/screen/manager/PrizeDrawPage.dart';
import 'package:attendance_check/feature/screen/manager/MainAdminScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
          home: MainAdminScreen(id: '김형은'), // 메인 페이지 설정
          theme: FlexThemeData.light(
            scheme: FlexScheme.blueM3,
            textTheme: const TextTheme(
                titleLarge: TextStyle(fontFamily: "soonchunhyang"),
                titleSmall: TextStyle(fontFamily: "Abel-Regular")),
            colorScheme: ColorScheme.light(
              background: Theme.of(context).colorScheme.surface,
               surface: Theme.of(context).colorScheme.surface
            ),
          ),
          darkTheme: FlexThemeData.dark(
            scheme: FlexScheme.blueM3,
            useMaterial3: true,
            colorScheme: ColorScheme.dark(
              background: Theme.of(context).colorScheme.onSurface,
              surface:Theme.of(context).colorScheme.onSurface
            ),
          ),
          themeMode: ThemeMode.system,
        );
      },
    );
  }
}