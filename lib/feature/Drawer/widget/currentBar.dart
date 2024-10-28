import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../ApproveList/widget/CustomText.dart';
import '../../Home/model/homeModel.dart';

class CurrentBar extends StatelessWidget {
  final int currentProgress;
  final int totalProgress;
  final List<Schedule> schedules; // Schedule 리스트

  CurrentBar({
    required this.currentProgress,
    required this.totalProgress,
    required this.schedules, // Schedule 데이터 전달
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final barWidth = screenSize.width * 0.8; // 전체 너비의 80%를 사용
    final barHeight = 60.h; // 고정 높이
    return Positioned(
      top: screenSize.height * 0.3, // 화면의 30% 위치에 배치
      left: (screenSize.width ) / (totalProgress*1.3), // 중앙
      child: Column(
        children: [
          CustomText(
            id: '출석 현황    $currentProgress / $totalProgress',
            color: Theme.of(context).dialogBackgroundColor,
            size: 24.sp,
          ),
          SizedBox(height: 18.h,),
          buildCustomProgressBar(currentProgress, totalProgress, schedules), // Schedule 리스트 전달
        ],
      ),
    );
  }
}

// 둥근 끝을 가진 커스텀 막대
Widget buildCustomProgressBar(int progress, int totalSteps, List<Schedule> schedules) {
  DateTime now = DateTime.now();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm"); // startTime의 형식에 맞게 수정 필요

  // startTime 기준으로 일정 정렬
  schedules.sort((a, b) {
    DateTime aTime = dateFormat.parse(a.startTime); // startTime을 DateTime으로 변환
    DateTime bTime = dateFormat.parse(b.startTime);
    return aTime.compareTo(bTime); // 빠른 순서대로 정렬
  });

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(totalSteps, (index) {
      DateTime? startTime;

      // startTime을 DateTime으로 변환, 변환 실패 시 null 반환
      try {
        startTime = dateFormat.parse(schedules[index].startTime);
      } catch (e) {
        print("Invalid date format for startTime: ${schedules[index].startTime}");
      }

      // 출석 가능 시간 10분 이후 경과 여부 계산
      bool isOverdue = startTime != null &&
          now.isAfter(startTime.add(Duration(minutes: 10))); // 출석 가능 시간이 지난 경우

      return Container(
        width: 25.sp,
        height: 15.sp,
        margin: EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: index < progress
              ? Colors.green // 이미 출석한 경우는 초록색
              : isOverdue
              ? Colors.red // 출석 가능 시간이 지난 경우 빨간색
              : Colors.grey, // 출석하지 않은 경우 회색
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(index == 0 ? 5 : 0),
            right: Radius.circular(index == totalSteps - 1 ? 5 : 0),
          ),
        ),
      );
    }),
  );
}