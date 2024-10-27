import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../model/homeModel.dart';
import 'Schedule_card_info.dart';

class ScheduleCardDesign extends StatelessWidget {
  final Schedule schedule;
  final int index;
  final Color barColor;
  final bool isExpanded;
  final Function(double, double) onSizeCalculated; // 높이와 너비를 전달하는 콜백 함수

  const ScheduleCardDesign({
    Key? key,
    required this.schedule,
    required this.index,
    required this.barColor,
    required this.isExpanded,
    required this.onSizeCalculated, // 콜백 함수 추가
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double borderRadiusValue = 9.0.sp; // 카드 모서리 둥글기 설정

    // MediaQuery를 사용하여 화면 비율을 기반으로 카드 높이 및 너비 설정
    double cardHeight = MediaQuery.of(context).size.height * 0.24; // 카드 높이를 화면 높이의 23%로 설정
    double cardWidth = MediaQuery.of(context).size.width * 0.83; // 카드 너비를 화면 너비의 83%로 설정

    // 빌드가 완료된 후 높이와 너비를 콜백을 통해 전달
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onSizeCalculated(cardHeight, cardWidth);
    });

    return Container(
      height: cardHeight, // 카드 높이 설정
      width: cardWidth, // 카드 너비 설정
      decoration: BoxDecoration(
        color: schedule.endTime.isBefore(DateTime.now())
            ? Colors.grey // endTime이 현재 시각보다 이전인 경우 회색
            : (Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).secondaryHeaderColor // 다크 모드 색상
            : Colors.white // 라이트 모드 색상
        ),
        borderRadius: BorderRadius.circular(borderRadiusValue),
      ),
      child: Stack(
        clipBehavior: Clip.none, // Stack에서 자르지 않도록 설정
        children: [
          Positioned.fill(
            child: ScheduleCardInfo(
              schedule: schedule,
              cardHeight: cardHeight, // 카드 높이 전달
              cardWidth: cardWidth, // 카드 너비 전달
            ), // ScheduleCardInfo 사용
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
