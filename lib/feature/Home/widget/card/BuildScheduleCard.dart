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
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    isExpandedList = List.generate(widget.schedules.length, (index) => false);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      print("Scroll Position: ${_scrollController.position.pixels}");
      print("Max Scroll Extent: ${_scrollController.position.maxScrollExtent}");
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

    return Container(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: isExpandedList.contains(true)
                  ? AlwaysScrollableScrollPhysics()
                  : NeverScrollableScrollPhysics(),
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
                      top: isExpandedList.contains(true) ? -MediaQuery.of(context).size.height : -0.5,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      child: AnimatedOpacity(
                        opacity: isExpandedList.contains(true) ? 0 : 1,
                        duration: Duration(milliseconds: 200),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: SoonCheckWidget(
                            bottom: MediaQuery.of(context).size.height * 0.85,
                            left: MediaQuery.of(context).size.width * 0.21,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: isExpandedList.contains(true) ? 80 : 0), // 펼쳐졌을 때만 공간 차지
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
        setState(() {
          bool isAtBottom = _scrollController.position.pixels >= _scrollController.position.maxScrollExtent;

          if (details.delta.dy > 10) {
            for (int i = 0; i < isExpandedList.length; i++) {
              isExpandedList[i] = true;
            }
          } else if (details.delta.dy < -10 && isAtBottom) {
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
            cardHeight = height; // 카드 높이 저장
            cardWidth = width;   // 카드 너비 저장
          });
        },
      ),
    );
  }
}
