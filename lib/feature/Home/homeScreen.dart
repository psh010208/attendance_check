import 'package:flutter/material.dart';
import 'package:attendance_check/feature/Home/model/homeModel.dart'; // Schedule 모델 임포트
import 'package:attendance_check/feature/Home/widget/card.dart'; // 카드 디자인을 임포트합니다
import 'package:attendance_check/feature/Drawer/drawerScreen.dart';
import 'package:attendance_check/feature/Home/widget/SoonCheck.dart';

class HomeScreen extends StatelessWidget {
  final String role;
  final String id;

  HomeScreen({
    required this.role,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface, // AppBar 배경색
        iconTheme: IconThemeData(
          color: Colors.black, // AppBar 아이콘 색상 검정으로 설정
        ),
        flexibleSpace: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, // 상단 안전 영역 고려
            left: MediaQuery.of(context).size.width * 0.05, // 왼쪽 여백 설정
            right: MediaQuery.of(context).size.width * 0.5, // 오른쪽 여백 설정
          ),
          child: Center(
            child: Image.asset(
              'assets/logo.png',
              height: MediaQuery.of(context).size.height * 0.1, // 화면 높이에 비례하여 크기 조정
              fit: BoxFit.contain, // 이미지 비율 유지
            ),
          ),
        ),
        // AppBar에서 드로어 버튼에 기능 연결
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  // 새로운 context에서 Scaffold의 endDrawer를 열기
                  Scaffold.of(context).openEndDrawer();
                },
                color: Colors.black, // 개별 아이콘 색상 명시적으로 설정
              );
            },
          ),
        ],
      ),
      endDrawer: drawerScreen(
        role: role, // 필요한 파라미터 전달
        id: id,
      ),
      drawerScrimColor: Colors.black.withOpacity(0.5),
      body: Column( // SingleChildScrollView 제거
        children: [
          // 카드를 만들기 위한 메서드 호출
          //SoonCheckWidget(bottom: 1, left: 1),
          buildScheduleCard(context),
        ],
      ),
    );
  }

  Widget buildScheduleCard(BuildContext context) {
    // 샘플 Schedule 데이터 생성
    List<Schedule> schedules = [
      Schedule(title: '일정 1', time: '09:00 - 10:00', location: '1506', professor: '민세동'),
      Schedule(title: '일정 2', time: '10:00 - 11:00', location: '1507', professor: '김상대'),
      Schedule(title: '일정 3', time: '12:00 - 13:00', location: '1058', professor: '오동익'),
      Schedule(title: '일정 4', time: '10:30 - 11:30', location: '1059', professor: '권춘기'),
      Schedule(title: '일정 5', time: '10:30 - 11:30', location: '1059', professor: '권춘기'),
      // 추가적인 Schedule 객체를 여기에 추가하세요
    ];
    return ScheduleCard(
      schedules: schedules, // 생성한 schedules 리스트를 전달합니다
    );
  }
}
