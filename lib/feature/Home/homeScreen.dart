import 'package:attendance_check/feature/Home/widget/Button/AnimationButton.dart';
import 'package:attendance_check/feature/Home/widget/Icon/AdminIcon.dart';
import 'package:attendance_check/feature/Home/widget/QRService/QrScanner.dart';
import 'package:attendance_check/feature/Home/widget/SoonCheck.dart';
import 'package:attendance_check/feature/Home/widget/card/BuildScheduleCard.dart';
import 'package:flutter/material.dart';
import 'package:attendance_check/feature/Home/model/homeModel.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:attendance_check/feature/Home/view_model/HomeViewModel.dart';
import 'package:attendance_check/feature/Drawer/drawerScreen.dart';
import 'package:attendance_check/feature/Home/widget/Button/AddScheduleButton.dart'; // 카드 위젯 임포트
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:attendance_check/feature/Store/MyStore.dart';

import '../NotificationService/ViewModel/NotificationServiceViewModel.dart';

class HomeScreen extends HookWidget {
  final String role;
  final String id;

  HomeScreen({
    required this.role,
    required this.id,
  });

  ScheduleViewModel scheduleViewModel = ScheduleViewModel(); // ViewModel 선언

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
        flexibleSpace: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top.h,
            left: MediaQuery.of(context).size.width * 0.05.w,
            right: MediaQuery.of(context).size.width * 0.5.w,
          ),
          child: Image.asset(
            'assets/logo.png',
            height: MediaQuery.of(context).size.height * 0.1.h,
            fit: BoxFit.contain,
          ),
        ),
        elevation: 1,
        actions: [
          if (role == '관리자')
        Builder(
        builder: (BuildContext context) {
      return AdminIcon(
        onPressed: () {
          // 다이얼로그 호출
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddScheduleDialog(); // AddScheduleDialog 호출
            },
          );
        },
      );
    },
    ),
          Builder(
            builder: (BuildContext context) {
              final isAlarmEnabled = context.watch<MyStore>().onAlarm;
              return IconButton(
                icon: Icon(
                  isAlarmEnabled ? Icons.notifications : Icons.notifications_off,
                ),
                onPressed: () {
                  context.read<MyStore>().changeAlarm(); // Toggle alarm status

                  // 알림 예약 호출
                  NotificationServiceViewModel().scheduleNotifications(context);
                },
                color: Theme.of(context).iconTheme.color,
              );
            },
          ),
          Builder(
            builder: (BuildContext context) {
              final isDarkMode = context.watch<MyStore>().isDarkMode;
              return IconButton(
                icon: Icon(
                  isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () {
                  context.read<MyStore>().changeMode();
                },
                color: Theme.of(context).iconTheme.color,
              );
            },
          ),
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                color: Theme.of(context).iconTheme.color,
              );
            },
          ),
        ],
      ),
      endDrawer: DrawerScreen(
        role: role,
        id: id,
      ),
      drawerScrimColor: Colors.black.withOpacity(0.5),
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
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width, // 화면 너비에 맞추기
            height: MediaQuery.of(context).size.height, // 화면 높이에 맞추기
            child: Stack(
              // Stack의 children 내의 위젯들 위치 조정
              children: [
                SoonCheckWidget(
                  bottom: MediaQuery.of(context).size.height * 0.85, // 비례 조정
                  left: MediaQuery.of(context).size.width * 0.21,
                ),
                buildScheduleCard(context),
                if (role == '학부생')
                  Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.25, // 비율에 따른 위치
                    left: MediaQuery.of(context).size.width * 0.368,
                    child: Padding(
                      padding: EdgeInsets.all(10.0.w), // 패딩도 비율에 맞추기
                      child: animationButton(
                        icon: Icons.qr_code_scanner,
                        iconSize: MediaQuery.of(context).size.width * 0.1, // 화면에 비례하는 아이콘 크기
                        iconColor: Theme.of(context).colorScheme.surface,
                        defaultSize: Offset(
                          MediaQuery.of(context).size.width * 0.2,
                          MediaQuery.of(context).size.width * 0.2,
                        ),
                        clickedSize: Offset(
                          MediaQuery.of(context).size.width * 0.175,
                          MediaQuery.of(context).size.width * 0.175,
                        ),
                        defaultButtonColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.8),
                        clickedButtonColor: Theme.of(context).colorScheme.inversePrimary,
                        circularRadius: 50.r, // 반지름도 비율에 맞추기
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QrScanner(studentId: id),
                            ),
                          );
                        },
                      ),
                    ),
                  ), // 일정 카드
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<double> buildScheduleCardHeight(BuildContext context) async {
    List<Schedule> schedules = await scheduleViewModel.getScheduleStream().first;
    final double cardHeight = MediaQuery.of(context).size.height * 0.25.h;
    final double totalHeight = cardHeight * schedules.length;
    return totalHeight;
  }

  Widget buildScheduleCard(BuildContext context) {
    return StreamBuilder<List<Schedule>>(
      stream: scheduleViewModel.getScheduleStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          print('오류 세부사항: ${snapshot.error}');
          return Center(child: Text('일정을 불러오는 중 오류가 발생했습니다: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('등록된 일정이 없습니다.'));
        }

        List<Schedule> schedules = snapshot.data!;
        return ScheduleCard(schedules: schedules);
      },
    );
  }
}
