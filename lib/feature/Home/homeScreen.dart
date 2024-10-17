import 'package:attendance_check/feature/Home/widget/Button/AnimationButton.dart';
import 'package:attendance_check/feature/Home/widget/Icon/AdminIcon.dart';
import 'package:attendance_check/feature/Home/widget/QRService/QrScanner.dart';
import 'package:attendance_check/feature/Home/widget/SoonCheck.dart';
import 'package:attendance_check/feature/Home/widget/card/SchedulCard.dart';
import 'package:flutter/material.dart';
import 'package:attendance_check/feature/Home/model/homeModel.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:attendance_check/feature/Home/view_model/HomeViewModel.dart';
import 'package:attendance_check/feature/Drawer/drawerScreen.dart';
import 'package:attendance_check/feature/Home/widget/Button/AddScheduleButton.dart'; // 카드 위젯 임포트
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:attendance_check/feature/Store/MyStore.dart';

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
                  onPressed: () async {
                    AddSchedule(context); // 일정 추가 다이얼로그 호출,
                  },
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
            width: 500.w,
            height: 1000.h,
            child: Stack(
              children: [
                SoonCheckWidget(bottom: 850.h, left: 40.w),
                buildScheduleCard(context),
                if (role == '학부생')
                  Positioned(
                    bottom: 250.h,
                    left: MediaQuery.of(context).size.width * 0.368.w,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: animationButton(
                        icon: Icons.qr_code_scanner,
                        iconSize: 40.w,
                        iconColor: Theme.of(context).colorScheme.onSurface,
                        defaultSize: const Offset(80, 80),
                        clickedSize: const Offset(70, 70),
                        defaultButtonColor:
                        Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                        clickedButtonColor: Theme.of(context).colorScheme.primary,
                        circularRadius: 50.r,
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
                  ),
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
