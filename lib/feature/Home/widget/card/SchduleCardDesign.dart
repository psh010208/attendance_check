import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../model/homeModel.dart';
import 'Schedule_card_info.dart';

class ScheduleCardDesign extends StatelessWidget {
  final Schedule schedule;
  final int index; // 인덱스
  final double cardHeight; // 카드 높이
  final Color barColor; // 바 색상
  final bool isExpanded; // 카드를 펼치는 상태

  const ScheduleCardDesign({
    Key? key,
    required this.schedule,
    required this.index,
    required this.cardHeight,
    required this.barColor,
    required this.isExpanded, // 새로운 매개변수 추가
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double borderRadiusValue = 9.0.sp; // 카드 모서리 둥글기 설정

    return Container(
      height: cardHeight, // 카드 높이 설정
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).secondaryHeaderColor
            : Colors.white,
        borderRadius: BorderRadius.circular(borderRadiusValue),
      ),
      child: Stack(
        clipBehavior: Clip.none, // Stack에서 자르지 않도록 설정
        children: [
          Positioned.fill(
            child: ScheduleCardInfo(schedule: schedule), // ScheduleCardInfo 사용
          ),
          // 왼쪽 바
          Container(
            width: 20.w, // 바의 너비 설정
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadiusValue),
                bottomLeft: Radius.circular(borderRadiusValue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
