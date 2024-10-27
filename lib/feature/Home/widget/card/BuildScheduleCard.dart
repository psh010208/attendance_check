import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../model/homeModel.dart';
import '../SoonCheck.dart';
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
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              children: [
                Container(
                  height: isExpandedList.contains(true)
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
            AnimatedPositioned(
              top: isExpandedList.contains(true) ? -MediaQuery.of(context).size.height : -0.5, // 카드가 펼쳐지면 위로 이동
              duration: Duration(milliseconds: 500), // 애니메이션 지속 시간
              curve: Curves.easeInOut, // 애니메이션 곡선
              child: AnimatedOpacity(
                opacity: isExpandedList.contains(true) ? 0 : 1, // 카드가 펼쳐지면 숨김
                duration: Duration(milliseconds: 500), // 애니메이션 지속 시간
                child: Container(
                  width: MediaQuery.of(context).size.width, // 원하는 너비 지정
                  height: MediaQuery.of(context).size.height, // 원하는 높이 지정
                  child: SoonCheckWidget(
                    bottom: MediaQuery.of(context).size.height * 0.85, // 비례 조정
                    left: MediaQuery.of(context).size.width * 0.21, // 원하는 SoonCheckWidget 추가
                  ),
                ),
              ),
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
              ? (cardHeight ?? MediaQuery.of(context).size.height * 0.09) * 1.05
              : (cardHeight ?? MediaQuery.of(context).size.height * 0.5) * 0.28) * index,
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
