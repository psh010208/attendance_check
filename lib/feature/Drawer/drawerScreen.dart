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
    return Drawer(
      backgroundColor: Theme.of(context).primaryColorDark,
      child: Container(
        child: Stack(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorDark,
              ),
              // DrawerHeader의 높이를 200.h로 설정하여 크기를 조정
              child: Container(
                height: 300.h, // DrawerHeader의 높이 설정
                child: Stack(
                  children: [
                    Positioned(
                      top: -5.h, // 반응형 높이 설정
                      left: 99.w,
                      child: CircleAvatar(
                        radius: 0,
                        child: Icon(Icons.account_circle, size: 70.w),
                      ),
                    ),
                    if (widget.role != '관리자' && widget.role != '학부생')
                      Positioned(
                        top: 80.h, // 반응형 높이 설정
                        left: 82.w,
                        child: CustomText(
                          id: '정보없음',
                          size: 30.w, // 역할 표시
                        ),
                      ),
                    if (widget.role == '관리자' || widget.role == '학부생') ... [
                      Positioned(
                        top: 75.h, // 반응형 높이 설정
                        left: 94.w,
                        child: CustomText(
                          id: widget.role,
                          size: 30.w, // 역할 표시
                        ),
                      ),
                      Positioned(
                        top: 127.h, // 반응형 높이 설정
                        left: 94.w,
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
              top: 210.h, // 첫 번째 버튼의 위치를 조정
              left: 0.w,
              right: 0.w,
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
                    SizedBox(height: 15),
                    Logo(onPressed: () {}),
                    SizedBox(height: 40),
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