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
    isExpandedList = List.generate(widget.schedules.length, (index) => false); // 카드 펼침 상태 초기화
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> barColors = [
      Theme.of(context).colorScheme.onPrimaryFixedVariant,
      Theme.of(context).colorScheme.onPrimaryContainer,
      Theme.of(context).colorScheme.inversePrimary,
      Theme.of(context).colorScheme.secondary,
    ];

    return Center(
      child: Column(
        children: [
          Container(
            height: isExpandedList.contains(true)
                ? MediaQuery.of(context).size.height * 0.05
                : MediaQuery.of(context).size.height * 0.25,
          ),
          Stack(
            clipBehavior: Clip.none, // 카드가 영역을 벗어나도 잘리지 않도록 설정
            alignment: Alignment.topCenter,
            children: buildOverlappingCards(context, widget.schedules, barColors),
          ),
        ],
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
        // 드래그할 때 카드 상태 업데이트
        if (details.delta.dy > 10) {
          // 아래로 드래그 시 카드 펼치기
          setState(() {
            isExpandedList[index] = true;
          });
        } else if (details.delta.dy < -10) {
          // 위로 드래그 시 카드 접기
          setState(() {
            isExpandedList[index] = false;
          });
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(
          top: isExpandedList[index] ? 200.0 * index : 40.0 * index,
        ),
        child: buildScheduleCard(schedule, index, isExpandedList[index], barColors),
      ),
    );
  }

  Widget buildScheduleCard(Schedule schedule, int index, bool isExpanded, List<Color> barColors) {
    final screenSize = MediaQuery.of(context).size;
    final cardHeight = screenSize.height * 0.25; // Responsive card height
    final cardWidth = screenSize.width * 0.80; // Responsive card width

    Color barColor = barColors[index % barColors.length];
    double borderRadiusValue = 10.0; // 카드의 모서리 둥글기 값을 설정

    return Container(
      width: cardWidth,
      height: cardHeight,
      margin: EdgeInsets.symmetric(vertical: 20.h), // 반응형 여백 설정
      child: Card(
        elevation: 15, // 카드 색상 설정
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusValue),
        ),
        child: ScheduleCardDesign(
          schedule: schedule,
          index: index,
          barColor: barColor,
          cardHeight: cardHeight, // 카드 높이 설정
          isExpanded: isExpanded, // isExpanded 상태 추가
        ),
      ),
    );
  }
}
