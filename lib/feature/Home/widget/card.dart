import 'package:flutter/material.dart';
import 'package:attendance_check/feature/Home/model/homeModel.dart';
import 'package:attendance_check/feature/Home/widget/IdText.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:attendance_check/feature/Home/widget/SoonCheck.dart';

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
    // 모든 카드를 기본적으로 접힌 상태로 초기화
    isExpandedList = List.generate(widget.schedules.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    // Theme 색상과 함께 barColors 리스트를 build 메서드 안에서 선언
    final List<Color> barColors = [
      Theme.of(context).colorScheme.onPrimaryFixedVariant,
      Theme.of(context).colorScheme.onPrimaryContainer,
      Theme.of(context).colorScheme.inversePrimary,
      //Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.secondary,
    ];

    return Center(
      child: Column(
        children: [
          Container(
            height: isExpandedList.contains(true)
                ? MediaQuery.of(context).size.height * 0.05 // 펼쳤을 때 여백
                : MediaQuery.of(context).size.height * 0.2, // 접었을 때 여백
          ),
          Stack(
            alignment: Alignment.topCenter,
            children: buildOverlappingCards(context, widget.schedules, barColors),
          ),
        ],
      ),
    );
  }

  List<Widget> buildOverlappingCards(BuildContext context,
      List<Schedule> schedules, List<Color> barColors) {
    return schedules.asMap().entries.map((entry) {
      int index = entry.key;
      Schedule schedule = entry.value;

      return buildDraggableCard(schedule, index, barColors);
    }).toList();
  }

  Widget buildDraggableCard(Schedule schedule, int index, List<Color> barColors) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        // 드래그할 때의 상태를 업데이트
        if (isExpandedList.every((isExpanded) => isExpanded)) {
          // 모든 카드가 펼쳐졌을 때
          if (details.delta.dy < -10 && index == widget.schedules.length - 1) {
            // 마지막 카드에서 아래로 드래그
            setState(() {
              isExpandedList = List.filled(widget.schedules.length, false); // 모든 카드 접기
            });
          }
        } else {
          // 모든 카드가 접혔을 때
          if (details.delta.dy > 10) {
            setState(() {
              isExpandedList = List.filled(widget.schedules.length, true); // 모든 카드 펼치기
            });
          }
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500), // 애니메이션 지속시간
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(
          top: isExpandedList[index] ? 200.0 * index : 40.0 * index, // 카드 간의 겹침
        ),
        child: buildScheduleCard(schedule, index, isExpandedList[index], barColors), // Schedule 객체 전달
      ),
    );
  }


  Widget buildScheduleCard(Schedule schedule, int index, bool isExpanded, List<Color> barColors) {
    final screenSize = MediaQuery.of(context).size;
    final cardHeight = screenSize.height * 0.25; // 예: 화면 높이의 25%
    final cardWidth = screenSize.width * 0.86; // 예: 화면 너비의 90%

    Color barColor = barColors[index % barColors.length];

    double borderRadiusValue = 6.0 + index * 3.0;

    return Container(
        width: cardWidth, // 반응형 가로 길이
        height: cardHeight,
        margin: EdgeInsets.symmetric(vertical: 20), // 카드 간의 세로 간격
        child: Card(
          elevation: 15, // 그림자 효과 추가
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusValue), // 모서리 둥글게
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadiusValue),
            child: Row(
              children: [
                // 왼쪽 바
                Container(
                  width: 15, // 바의 고정 너비
                  decoration: BoxDecoration(
                    color: barColor, // 왼쪽 바 색상
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10), // 위쪽 왼쪽 끝 둥글게
                      bottomLeft: Radius.circular(10), // 아래쪽 왼쪽 끝 둥글게
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      // 상단 바 (제목과 시간)
                      Container(
                        height: 40, // 상단 바 높이
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        color: Theme.of(context).cardColor, // 상단 바 색상 지정
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 1, // 왼쪽 여백을 위한 비율
                              child: Container(), // 빈 컨테이너로 여백 추가
                            ),
                            Flexible(
                              flex: 3, // title이 차지하는 공간
                              child: CustomText(
                                id: schedule.title, // 강의 시간
                                size: 17.sp,
                                color: Theme.of(context).colorScheme.onSurface, // 테마의 텍스트 색상 사용 // fontWeight 추가
                              ),
                            ),
                            Flexible(
                              flex: 5, // time이 차지하는 공간
                              child: CustomText(
                                id: schedule.time, // 강의 시간
                                size: 17.sp,
                                color: Theme.of(context).colorScheme.onSurface, // 테마의 텍스트 색상 사용 // fontWeight 추가
                              ),
                            ),
                            Flexible(
                              flex: 1, // 오른쪽 여백을 위한 비율
                              child: Container(), // 빈 컨테이너로 여백 추가
                            ),
                          ],
                        ),
                      ),


                      Expanded(
                        child: Container(
                          color: Theme.of(context).cardColor,
                          height: MediaQuery.of(context).size.height * 0.17, // 화면 높이에 비례
                          child: Stack(
                            children: [
                              // 로고 이미지를 직접 추가
                              Positioned(
                                top: 0,
                                bottom: 20,
                                left: 85,
                                child: Opacity(
                                  opacity: 0.5, // 원하는 투명도 설정
                                  child: Image.asset(
                                    'assets/cardLogo.png',
                                    fit: BoxFit.cover, // 로고가 꽉 차도록
                                  ),
                                ),
                              ),

                              // 텍스트 배치
                              Positioned(
                                top: MediaQuery.of(context).size.height * 0.025, // 원하는 위치 조정
                                left: 85, // 원하는 위치 조정
                                child: CustomText(
                                  id: schedule.location, // 강의실 번호
                                  size: 45.sp,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              Positioned(
                                top: MediaQuery.of(context).size.height * 0.055, // 원하는 위치 조정
                                left: 190, // 원하는 위치 조정
                                child: CustomText(
                                  id: '강의실', // 고정 텍스트
                                  size: 15.sp,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              Positioned(
                                top: MediaQuery.of(context).size.height * 0.100, // 원하는 위치 조정
                                left: 100, // 원하는 위치 조정
                                child: CustomText(
                                  id: schedule.professor, // 교수명
                                  size: 20.sp,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              Positioned(
                                top: MediaQuery.of(context).size.height * 0.100, // 원하는 위치 조정
                                left: 160, // 원하는 위치 조정
                                child: CustomText(
                                  id: '교수님', // 고정 텍스트
                                  size: 20.sp,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),// SoonCheck 위젯 추가
                ],
              ),
            ),
          ],
        ),
      ),
      )
    );
  }
}
