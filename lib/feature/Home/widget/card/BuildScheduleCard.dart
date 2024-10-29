import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../model/homeModel.dart';
import '../SoonCheck.dart';
import 'SchduleCardDesign.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore 임포트 추가

// 삭제 함수 추가
Future<void> deleteScheduleFromDatabase(String scheduleId) async {
  try {
    await FirebaseFirestore.instance
        .collection('schedules') // 데이터베이스의 컬렉션 이름을 맞춰 주세요
        .doc(scheduleId) // 삭제할 문서의 ID
        .delete();
  } catch (e) {
    print('Failed to delete schedule: $e');
  }
}


class Buildschedulecard extends StatefulWidget {
  final List<Schedule> schedules;
  final String role; // role 추가

  Buildschedulecard({required this.schedules, required this.role}); // 생성자 수정

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
            child: ListView(
              controller: _scrollController,
              physics: isExpandedList.contains(true)
                  ? AlwaysScrollableScrollPhysics()
                  : NeverScrollableScrollPhysics(),
              children: [
                Stack(
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
                      top: isExpandedList.contains(true)
                          ? -MediaQuery.of(context).size.height
                          : -0.5,
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
              ],
            ),
          ),
          SizedBox(height: isExpandedList.contains(true) ? 80 : 0),
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
    return Listener(
      onPointerMove: (details) {
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
        child: SingleChildScrollView( // 카드 내부에 스크롤 가능하도록 추가
          child: buildScheduleCard(schedule, index, isExpandedList[index], barColors, widget.role),
        ),
      ),
    );
  }


  Widget buildScheduleCard(Schedule schedule, int index, bool isExpanded, List<Color> barColors, String role) {
    Color barColor = barColors[index % barColors.length];

    // 일반 사용자 카드
    if (role != '관리자') {
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
    // 관리자 카드
    else {
      return Container(
        color: Colors.transparent,
        margin: EdgeInsets.symmetric(vertical: 20.h),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Slidable(
              key: ValueKey(index),
              endActionPane: ActionPane(
                motion: DrawerMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) async {
                      setState(() {
                        widget.schedules.removeAt(index); // 로컬에서 삭제
                      });

                      // Firestore에서 일정 삭제
                      await deleteScheduleFromDatabase(schedule.id);
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
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
            ),
          ),
        ),
      );
    }
  }
}
