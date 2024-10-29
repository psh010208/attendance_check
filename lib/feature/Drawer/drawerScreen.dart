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
  final bool isFriendView; // 친구 프로필 보기인지 여부 추가

  DrawerScreen({
    required this.role,
    required this.id,
    this.isFriendView = false, // 기본값은 본인 프로필 보기
  });

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  AttendanceViewModel viewModel = AttendanceViewModel();
  ScheduleViewModel scheduleViewModel = ScheduleViewModel();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Drawer(
      backgroundColor: Theme.of(context).primaryColorDark,
      child: Stack(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
            ),
            child: Stack(
              children: [
                Positioned(
                  top: screenHeight * 0,
                  left: screenWidth * 0.25,
                  child: CircleAvatar(
                    radius: 0.w,
                    child: Icon(Icons.account_circle, size: 70.w),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.1,
                  left: screenWidth * 0.23,
                  child: CustomText(
                    id: widget.role == '관리자' ? widget.role : '학부생',
                    size: 30.w,
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.15,
                  left: screenWidth * 0.23,
                  child: CustomText(
                    id: widget.id,
                    size: 20.w,
                  ),
                ),
              ],
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
          // 관리자인 경우 친구 보기 모드가 아니면 버튼 표시
          if (widget.role == '관리자' && !widget.isFriendView) ...[
            ParticipationButton(
              onPressed: () {},
              role: widget.role,
              id: widget.id,
            ),
            CurrentButton(
              onPressed: () {},
              role: widget.role,
              id: widget.id,
            ),
            RaffleButton(
              onPressed: () {},
              role: widget.role,
              id: widget.id,
            ),
            QrScreenButton(
              onPressed: () {},
              role: widget.role,
              id: widget.id,
            ),
          ] else if (widget.role == '학부생') ...[
            // 학부생이 친구 프로필을 보는 경우 FriendsListButton 숨기기
            if (!widget.isFriendView)
              FriendsListButton(
                onPressed: () {},
                id: widget.id,
                role: widget.role,
              ),
            FutureBuilder<int?>(
              future: viewModel.getTotalAttendanceByStudentId(widget.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return StreamBuilder<List<Schedule>>(
                    stream: scheduleViewModel.getScheduleStream(),
                    builder: (context, scheduleSnapshot) {
                      if (scheduleSnapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (scheduleSnapshot.hasError) {
                        return Text('Error: ${scheduleSnapshot.error}');
                      } else if (scheduleSnapshot.hasData) {
                        int currentProgress = snapshot.data ?? 0;
                        int totalProgress = scheduleSnapshot.data!.length;
                        return CurrentBar(
                          currentProgress: currentProgress,
                          totalProgress: totalProgress,
                          schedules: scheduleSnapshot.data!,
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
            if (!widget.isFriendView) // 친구 보기 모드가 아니면 표시
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
                        LogOutButton(),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Logo(onPressed: () {}),
                    SizedBox(height: screenHeight * 0.1),
                  ],
                ),
              ),
          ] else ...[
            LogInButton(onPressed: () {}),
            JoinButton(onPressed: () {}),
          ],
          if (widget.role == '관리자' && !widget.isFriendView) ...[
            LogOutButton(),
            Logo(onPressed: () {}),
          ]
        ],
      ),
    );
  }
}
