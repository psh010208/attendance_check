import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:attendance_check/feature/Home/model/homeModel.dart';

class ScheduleCardDesign extends StatelessWidget {
  final Schedule schedule;

  const ScheduleCardDesign({Key? key, required this.schedule}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 바 색상 및 디자인 설정
    Color barColor = Theme.of(context).colorScheme.secondary; // 원하는 색상으로 변경 가능
    double borderRadiusValue = 10.0; // 카드 모서리 둥글기 설정

    return Container(
      height: 40.h, // 카드 헤더 높이 설정
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(borderRadiusValue),
      ),
      child: Row(
        children: [
          Container(
            width: 19,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadiusValue),
                bottomLeft: Radius.circular(borderRadiusValue),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: Text(
                  schedule.scheduleName.isNotEmpty ? schedule.scheduleName : "이름 없음",
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
