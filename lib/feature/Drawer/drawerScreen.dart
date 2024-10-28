import 'package:attendance_check/feature/Drawer/widget/IdText.dart';
import 'package:attendance_check/feature/Drawer/widget/button.dart';
import 'package:attendance_check/feature/Drawer/widget/currentBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Home/model/homeModel.dart';
import 'model/AttendanceViewModel.dart';

class DrawerScreen extends StatefulWidget {
  final String role;
  final String id;

  DrawerScreen({
    required this.role,
    required this.id,
  });

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  AttendanceViewModel viewModel = AttendanceViewModel(); // ViewModel 인스턴스 생성
  ScheduleViewModel scheduleViewModel = ScheduleViewModel(); // 일정 ViewModel 생성

  @override
  Widget build(BuildContext context) {
    // MediaQuery를 사용하여 화면 크기 가져오기
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Drawer(
      backgroundColor: Theme.of(context).primaryColorDark,
      child: Container(
        child: Stack(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorDark,
              ),
              child: Container(
                height: screenHeight * 0.3, // 화면 높이의 30%로 설정
                child: Stack(
                  children: [
                    Positioned(
                      top: screenHeight * 0, // 반응형 높이 설정
                      left: screenWidth * 0.25, // 반응형 위치 설정
                      child: CircleAvatar(
                        radius: 35.w, // 반응형 반지름
                        child: Icon(Icons.account_circle, size: 70.w),
                      ),
                    ),
                    if (widget.role != '관리자' && widget.role != '학부생') ...[
                      Positioned(
                        top: screenHeight * 0.1, // 반응형 높이 설정
                        left: screenWidth * 0.20, // 반응형 위치 설정
                        child: CustomText(
                          id: '정보없음',
                          size: 30.w, // 역할 표시
                        ),
                      ),
                    ],
                    if (widget.role == '관리자' || widget.role == '학부생') ...[
                      Positioned(
                        top: screenHeight * 0.1, // 반응형 높이 설정
                        left: screenWidth * 0.23, // 반응형 위치 설정
                        child: CustomText(
                          id: widget.role,
                          size: 30.w, // 역할 표시
                        ),
                      ),
                      Positioned(
                        top: screenHeight * 0.15, // 반응형 높이 설정
                        left: screenWidth * 0.23, // 반응형 위치 설정
                        child: CustomText(
                          id: widget.id,
                          size: 20.w, // 아이디 표시
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.25,
              left: screenWidth * 0.0,
              right: screenWidth * 0.0,
              child: Divider(
                color: Colors.grey,
                thickness: 3,
              ),
            ),
            if (widget.role == '관리자') ...[
              ParticipationButton( //참여 학생
                onPressed: () {},
                role: widget.role,
                id: widget.id,
              ),
              CurrentButton( // 현황
                onPressed: () {},
                role: widget.role,
                id: widget.id,
              ),
              RaffleButton( //추첨
                onPressed: () {},
                role: widget.role,
                id: widget.id,
              ),
              QrScreenButton( // 현황
                onPressed: () {},
                role: widget.role,
                id: widget.id,
              ),
            ] else if (widget.role == '학부생') ...[
              FriendsListButton(
                onPressed: () {},
                role: widget.role,
                id: widget.id,
              ),
              FutureBuilder<int?>(
                future: viewModel.getTotalAttendanceByStudentId(widget.id), // student_id를 통해 데이터 가져옴
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // 로딩 상태 표시
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    // StreamBuilder로 일정 데이터에서 totalProgress 가져오기
                    return StreamBuilder<List<Schedule>>(
                      stream: scheduleViewModel.getScheduleStream(), // 일정 스트림을 구독
                      builder: (context, scheduleSnapshot) {
                        if (scheduleSnapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator(); // 로딩 상태 표시
                        } else if (scheduleSnapshot.hasError) {
                          return Text('Error: ${scheduleSnapshot.error}');
                        } else if (scheduleSnapshot.hasData) {
                          int currentProgress = snapshot.data ?? 0; // Firestore에서 가져온 출석 데이터
                          int totalProgress = scheduleSnapshot.data!.length; // 일정 수를 총 출석 가능 횟수로 사용
                          return CurrentBar(
                            currentProgress: currentProgress, // Firestore 출석 값 반영
                            totalProgress: totalProgress, // Firestore 일정 수 반영
                            schedules: scheduleSnapshot.data!, // Schedule 리스트 전달
                          );
                        } else {
                          return Text('No schedule data available');
                        }
                      },
                    );
                  } else {
                    return Text('No attendance data available');
                  }
                },
              ),

              SizedBox.expand(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AskButton(
                          onPressed: () {},
                          role: widget.role,
                          id: widget.id,
                        ),
                        LogOutButton(onPressed: () {}),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02), // 반응형 여백
                    Logo(onPressed: () {}),
                    SizedBox(height: screenHeight * 0.1), // 반응형 여백
                  ],
                ),
              ),
            ] else ...[ // 로그인 전에 로그인 버튼과 회원가입 버튼
              LogInButton(onPressed: () {}),
              JoinButton(onPressed: () {}),
            ],
            if (widget.role == '관리자') ...[
              LogOutButton(onPressed: () {}),
              Logo(onPressed: () {}),
            ]
          ],
        ),
      ),
    );
  }
}
