import 'package:attendance_check/feature/screen/student/MainCardScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:attendance_check/feature/screen/manager/PrizeDrawPage.dart';
import 'package:attendance_check/feature/screen/SplashScreen.dart';
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
          home: PrizeDrawPage(), // 메인 페이지 설정
          theme: FlexThemeData.light(
            scheme: usedScheme,
            background: FlexColor.lightSurface,
            textTheme:  TextTheme(
              //, color: Theme.of(context).primaryColor
              titleLarge: TextStyle(fontFamily: "soonchunhyang",),
              titleSmall: TextStyle(fontFamily: "Abel-Regular", fontSize: 32),
            ),
          ),

        );
      },
    );
  }
}