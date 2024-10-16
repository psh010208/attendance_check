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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
          if (role == '관리자') // role이 '관리자'일 때만 버튼 추가
            Builder(
              builder: (BuildContext context) {
                return AdminIcon(
                    onPressed: () async {
                      AddSchedule(context); // 일정 추가 다이얼로그 호출,
                    }
                );
              },
            ),
          Builder(
            builder: (BuildContext context) {
              final isDarkMode = context.watch<MyStore>().isDarkMode; // 현재 모드 상태 확인
              return IconButton(
                icon: Icon(
                  isDarkMode ? Icons.light_mode : Icons.dark_mode, // 다크 모드이면 태양 아이콘, 아니면 밝기 아이콘
                ),
                onPressed: () {
                  context.read<MyStore>().changeMode();
                },
                color: Theme.of(context).iconTheme.color, // 테마에 따라 아이콘 색상 설정
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
          width: 500.w,
          height: 1000.h,
          child: Stack(
            children: [
              SoonCheckWidget(bottom: 850.h, left: 40.w),
              // 일정 카드 표시
              buildScheduleCard(context),

              // '학부생' 역할인 경우 QR 코드 스캐너 애니메이션 버튼 추가
              // QR 코드 버튼을 일정 카드 바로 아래에 위치하도록 수정
              if (role == '학부생')
                Positioned(
                  bottom: 250.h, // 카드 아래 위치 조정
                  left: MediaQuery.of(context).size.width * 0.368.w, // 중앙 정렬
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
    );
  }

  Widget buildScheduleCard(BuildContext context) {
    return StreamBuilder<List<Schedule>>(
      stream: scheduleViewModel.getScheduleStream(), // Firestore에서 일정 데이터 가져오기
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // 로딩 중일 때
        }
        if (snapshot.hasError) {
          print('오류 세부사항: ${snapshot.error}');
          return Center(child: Text('일정을 불러오는 중 오류가 발생했습니다: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('등록된 일정이 없습니다.'));
        }

        List<Schedule> schedules = snapshot.data!;
        return ScheduleCard(schedules: schedules); // 일정 데이터를 카드로 표시
      },
    );
  }
}