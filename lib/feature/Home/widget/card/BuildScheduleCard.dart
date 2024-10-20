import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../model/homeModel.dart';
import 'SchduleCardDesign.dart';

class ScheduleCard extends StatefulWidget {
  final List<Schedule> schedules;

  ScheduleCard({required this.schedules});

  @override
  _ScheduleCardState createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  late List<bool> isExpandedList;

  @override
  void initState() {
    super.initState();
    isExpandedList = List.generate(widget.schedules.length, (index) => false); // 초기화
  }

  @override
  void didUpdateWidget(ScheduleCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.schedules.length != oldWidget.schedules.length) {
      // 일정의 개수가 변경될 때, isExpandedList를 다시 설정
      isExpandedList = List.generate(widget.schedules.length, (index) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> barColors = [
      Theme.of(context).primaryColorLight,
      Theme.of(context).colorScheme.secondaryContainer,
      Theme.of(context).colorScheme.secondary,
      Theme.of(context).disabledColor,
    ];

    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Container(
              height: isExpandedList.contains(true)
                  ? MediaQuery.of(context).size.height * 0.025.h
                  : MediaQuery.of(context).size.height * 0.22.h,       // 카드 높낮이
            ),
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: buildOverlappingCards(context, widget.schedules, barColors),
            ),
          ],
        ),
      ),
    );
  }


  List<Widget> buildOverlappingCards(BuildContext context, List<Schedule> schedules, List<Color> barColors) {
    return schedules.asMap().entries.map((entry) {
      int index = entry.key;
      Schedule schedule = entry.value;
      return buildDraggableCard(schedule, index, barColors);
    }).toList();
  }

  Widget buildDraggableCard(Schedule schedule, int index, List<Color> barColors) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        // 드래그 종료 시 카드 상태 업데이트
        setState(() {
          if (details.velocity.pixelsPerSecond.dy > 0) {
            // 아래로 드래그 시 모든 카드를 펼치기
            for (int i = 0; i < isExpandedList.length; i++) {
              isExpandedList[i] = true;
            }
          } else if (details.velocity.pixelsPerSecond.dy < 0) {
            // 위로 드래그 시 모든 카드를 접기
            for (int i = 0; i < isExpandedList.length; i++) {
              isExpandedList[i] = false;
            }
          }
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(
          top: isExpandedList[index]
              ? MediaQuery.of(context).size.height * 0.283.h * index
              : MediaQuery.of(context).size.height * 0.0735.h * index,   // 카드 접힘 정도
        ),
        child: buildScheduleCard(schedule, index, isExpandedList[index], barColors),
      ),
    );
  }

  Widget buildScheduleCard(Schedule schedule, int index, bool isExpanded, List<Color> barColors) {
    final screenSize = MediaQuery.of(context).size;
    final cardHeight = screenSize.height * 0.28.h;
    final cardWidth = screenSize.width * 0.78.w;

    Color barColor = barColors[index % barColors.length];
    double borderRadiusValue = 20.0;

    return Container(
      color: Colors.transparent,
      width: cardWidth,
      height: cardHeight,
      margin: EdgeInsets.symmetric(vertical: 20.h),
      child: Card(
        elevation: 15,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusValue),
        ),
        child: ScheduleCardDesign(
          schedule: schedule,
          index: index,
          barColor: barColor,
          cardHeight: cardHeight,
          isExpanded: isExpanded,
        ),
      ),
    );
  }
}
