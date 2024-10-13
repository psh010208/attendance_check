import 'package:flutter/material.dart';
import 'package:attendance_check/feature/Home/model/homeModel.dart';
import 'package:attendance_check/feature/Home/widget/IdText.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    isExpandedList = List.generate(widget.schedules.length, (index) => false);
  }

  final List<Color> barColors = [
    Color(0xFF3f51b5),
    Color(0xFF7986CB),
    Color(0xFF2962ff),
    Color(0xff6ab0f6),
    Color(0xFF0D47A1),
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            height: isExpandedList.contains(true)
                ? MediaQuery.of(context).size.height * 0.05
                : MediaQuery.of(context).size.height * 0.2,
          ),
          Stack(
            alignment: Alignment.topCenter,
            children: buildOverlappingCards(context, widget.schedules),
          ),
        ],
      ),
    );
  }

  List<Widget> buildOverlappingCards(BuildContext context, List<Schedule> schedules) {
    return schedules.asMap().entries.map((entry) {
      int index = entry.key;
      Schedule schedule = entry.value;

      return buildDraggableCard(schedule, index);
    }).toList();
  }

  Widget buildDraggableCard(Schedule schedule, int index) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy > 10) { // 위로 드래그
          setState(() {
            isExpandedList = List.filled(widget.schedules.length, true);
          });
        } else if (details.delta.dy < -10) { // 아래로 드래그
          setState(() {
            isExpandedList = List.filled(widget.schedules.length, false);
          });
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(
          top: isExpandedList[index] ? 200.0 * index : 40.0 * index,
        ),
        child: buildScheduleCard(schedule, index, isExpandedList[index]),
      ),
    );
  }

  Widget buildScheduleCard(Schedule schedule, int index, bool isExpanded) {
    final screenSize = MediaQuery.of(context).size;
    final cardHeight = screenSize.height * 0.25;
    final cardWidth = screenSize.width * 0.86;

    Color barColor = barColors[index % barColors.length];
    double borderRadiusValue = 6.0 + index * 3.0;

    return Container(
      width: cardWidth,
      height: cardHeight,
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Card(
        elevation: 15,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusValue),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadiusValue),
          child: Row(
            children: [
              Container(
                width: 15,
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      color: Theme.of(context).cardColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Container()),
                          Flexible(
                            flex: 3,
                            child: CustomText(
                              id: schedule.title,
                              size: 16.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Flexible(
                            flex: 5,
                            child: CustomText(
                              id: schedule.time,
                              size: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Flexible(child: Container()),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            bottom: 20,
                            left: 100,
                            child: Image.asset(
                              'assets/cardLogo.png',
                              fit: BoxFit.cover,
                              color: Colors.black.withOpacity(0.11),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height * 0.025,
                            left: 85,
                            child: CustomText(
                              id: schedule.location,
                              size: 45.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height * 0.100,
                            left: 100,
                            child: CustomText(
                              id: schedule.professor,
                              size: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
