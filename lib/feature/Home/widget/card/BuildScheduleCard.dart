import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../model/homeModel.dart';
import 'SchduleCardDesign.dart';

class Buildschedulecard extends StatefulWidget {
  final List<Schedule> schedules;

  Buildschedulecard({required this.schedules});

  @override
  _ScheduleCardState createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<Buildschedulecard> {
  late List<bool> isExpandedList;
  double? cardHeight;
  double? cardWidth;

  @override
  void initState() {
    super.initState();
    isExpandedList = List.generate(widget.schedules.length, (index) => false); // 초기화
  }

  @override
  void didUpdateWidget(Buildschedulecard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.schedules.length != oldWidget.schedules.length) {
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
              height: isExpandedList.contains(true)  // 카드 높이
                  ? MediaQuery.of(context).size.height * 0.025.h
                  : MediaQuery.of(context).size.height * 0.22.h,
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
      onVerticalDragUpdate: (details) {
        setState(() {
          if (details.delta.dy > 10) {
            for (int i = 0; i < isExpandedList.length; i++) {
              isExpandedList[i] = true;
            }
          } else if (details.delta.dy < -10) {
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
          top: (isExpandedList[index]
              ? (cardHeight ?? MediaQuery.of(context).size.height * 0.09) * 1.05  // Expanded 상태에서의 겹침 정도
              : (cardHeight ?? MediaQuery.of(context).size.height * 0.5) * 0.28)* index,
        ),
        child: buildScheduleCard(schedule, index, isExpandedList[index], barColors),
      ),
    );
  }


  Widget buildScheduleCard(Schedule schedule, int index, bool isExpanded, List<Color> barColors) {
    Color barColor = barColors[index % barColors.length];

    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.symmetric(vertical: 20.h),
      child: ScheduleCardDesign(
        schedule: schedule,
        index: index,
        barColor: barColor,
        isExpanded: isExpanded,
        onSizeCalculated: (height, width) {
          setState(() {
            cardHeight = height;
            cardWidth = width;
          });
        },
      ),
    );
  }
}
