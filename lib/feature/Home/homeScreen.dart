import 'package:attendance_check/feature/Home/widget/Button/AddScheduleButton.dart';
import 'package:attendance_check/feature/Home/widget/card/BuildScheduleCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:attendance_check/feature/Drawer/drawerScreen.dart';
import 'package:attendance_check/feature/Home/widget/SoonCheck.dart';
import '../Drawer/model/AttendanceViewModel.dart'; // 새로 추가

class HomeScreen extends HookWidget {
  final String role;
  final String id;

  HomeScreen({required this.role, required this.id});

  final ScheduleViewModel scheduleViewModel = ScheduleViewModel(); // ViewModel 선언

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        flexibleSpace: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.5,
          ),
          child: Image.asset(
            'assets/logo.png',
            height: MediaQuery.of(context).size.height * 0.1,
            fit: BoxFit.contain,
          ),
        ),
        elevation: 1,
        actions: [
          if (role == '관리자') // role이 '관리자'일 때만 버튼 추가
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(Icons.add, size: 25), // 일정 추가 아이콘
                  onPressed: () {
                    AddSchedule(context); // 일정 추가 다이얼로그 호출
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
                color: Theme.of(context).iconTheme.color, // 테마에 따라 아이콘 색상 설정
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
      body: SingleChildScrollView(
        child: SizedBox(
          width: 500,
          height: 500,
          child: Stack(
            children: [
              SoonCheckWidget(bottom: 400, left: 45),
              // 일정 카드 표시
              ScheduleCardBuilder(scheduleViewModel: scheduleViewModel), // 분리된 위젯 사용
            ],
          ),
        ),
      ),
    );
  }
}
