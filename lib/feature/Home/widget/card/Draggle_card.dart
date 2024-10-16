import 'package:flutter/material.dart';
import 'package:attendance_check/feature/Home/model/homeModel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Schedule_card_info.dart';

class DraggableCard extends StatelessWidget {
  final Schedule schedule;
  final int index;
  final List<bool> isExpandedList;
  final Function(List<bool>) onExpansionChanged;

  const DraggableCard({
    Key? key,
    required this.schedule,
    required this.index,
    required this.isExpandedList,
    required this.onExpansionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        updateExpansionState(details);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(top: 20.0.h), // 카드 사이의 간격 설정
        child: Column(
          children: [
            // ScheduleCardInfo(schedule: schedule), // 카드 정보
          ],
        ),
      ),
    );
  }

  void updateExpansionState(DragUpdateDetails details) {
    if (isExpandedList.every((isExpanded) => isExpanded)) {
      if (details.delta.dy < -10 && index == isExpandedList.length - 1) {
        onExpansionChanged(List.filled(isExpandedList.length, false)); // 카드 접기
      }
    } else {
      if (details.delta.dy > 10) {
        onExpansionChanged(List.filled(isExpandedList.length, true)); // 카드 펼치기
      }
    }
  }
}
