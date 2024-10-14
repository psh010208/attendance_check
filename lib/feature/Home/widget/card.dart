import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//qwe
import '../model/homeModel.dart';
import '../view_model/HomeViewModel.dart';

class ScheduleCard extends StatefulWidget {
  final List<Schedule> schedules;

  ScheduleCard({required this.schedules});

  @override
  _ScheduleCardState createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  ScheduleViewModel scheduleViewModel = ScheduleViewModel(); // ViewModel 선언
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
        if (isExpandedList.every((isExpanded) => isExpanded)) {
          if (details.delta.dy < -10 && index == widget.schedules.length - 1) {
            setState(() {
              isExpandedList = List.filled(widget.schedules.length, false); // 카드 접기
            });
          }
        } else {
          if (details.delta.dy > 10) {
            setState(() {
              isExpandedList = List.filled(widget.schedules.length, true); // 카드 펼치기
            });
          }
        }
      },
      child: Stack(
        clipBehavior: Clip.none, // Stack에서 자르지 않도록 설정
        children: [
          // 이미지 배치
          Positioned(
            top: -130.h, // 카드 위로 이미지 배치
            left: 0.w,
            right: 0.w,
            child: Opacity(
              opacity: isExpandedList[index] ? 0 : 1, // 카드가 펼쳐지면 이미지가 사라지도록 설정
              child: Container(
                height: 80.h,
                child: Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? 'assets/dark_ver.png'  // 다크 모드 이미지
                      : 'assets/light_ver.png', // 라이트 모드 이미지
                  fit: BoxFit.contain, // 이미지가 화면에 맞게 조절되도록 설정
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            margin: EdgeInsets.only(
              top: isExpandedList[index] ? 200.0 * index : 40.0 * index,
            ),
            child: buildScheduleCard(schedule, index, isExpandedList[index], barColors),
          ),
        ],
      ),
    );
  }

  Widget buildScheduleCard(Schedule schedule, int index, bool isExpanded, List<Color> barColors) {
    final screenSize = MediaQuery.of(context).size;
    final cardHeight = screenSize.height * 0.25; // Responsive card height
    final cardWidth = screenSize.width * 0.80; // Responsive card width

    Color barColor = barColors[index % barColors.length];
    double borderRadiusValue = 10.0; // 카드의 모서리 둥글기 값을 설정

    // 시간 포맷팅
    String formattedStartTime = schedule.startTime.toDate().toLocal().toString().split(' ')[1].substring(0, 5);
    String formattedEndTime = schedule.endTime.toDate().toLocal().toString().split(' ')[1].substring(0, 5);

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
                width: 19,
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
                      height: 40.h,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      color: Theme.of(context).cardColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            schedule.scheduleName.isNotEmpty ? schedule.scheduleName : "이름 없음",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Text(
                            "$formattedStartTime - $formattedEndTime",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Expanded(
                      child: Container(
                        color: Theme.of(context).cardColor,
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              bottom: 5,
                              left: 80,
                              child: Opacity(
                                opacity: 0.4,
                                child: Image.asset(
                                  'assets/cardLogo.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.location_on, color: Theme.of(context).colorScheme.onSurface),
                                    SizedBox(width: 8.w),
                                    Text(
                                      schedule.location.isNotEmpty ? schedule.location : "위치 없음",
                                      style: TextStyle(
                                        fontSize: 25.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      '강의실',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.person, color: Theme.of(context).colorScheme.onSurface),
                                    SizedBox(width: 8.w),
                                    Text(
                                      schedule.instructorName.isNotEmpty ? schedule.instructorName : "교수 없음",
                                      style: TextStyle(
                                        fontSize: 23.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      '교수님',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
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
