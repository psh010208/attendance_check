import 'package:flutter/material.dart';
import 'package:attendance_check/feature/Home/model/homeModel.dart';
import 'package:attendance_check/feature/Home/widget/IdText.dart';

class ScheduleCard extends StatelessWidget {
  final List<Schedule> schedules;

  ScheduleCard({required this.schedules});

  // 왼쪽 바에 사용할 색상을 리스트로 정의
  final List<Color> barColors = [
    Color(0xFF3f51b5), // 일정 1
    Color(0xFF7986CB), // 일정 2
    Color(0xFF2962ff), // 일정 3
    Color(0xff6ab0f6), // 일정 4
    Color(0xFF0D47A1), // 일정 5
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    buildOverlappingCards(context,schedules), // 카드들이 겹쳐 보이도록
                  ],
                ),
              ),
            ],
          ),
        ]
    );
  }

  Widget buildScheduleCard(BuildContext context, Schedule schedule, int index) {
    // 화면 크기에 따라 카드의 크기를 설정
    final screenSize = MediaQuery
        .of(context)
        .size;
    final cardHeight = screenSize.height * 0.25; // 예: 화면 높이의 25%
    final cardWidth = screenSize.width * 0.9; // 예: 화면 너비의 90%

    // 색상 리스트를 반복 사용
    Color barColor = barColors[index % barColors.length];

    return Container(
        width: cardWidth, // 반응형 가로 길이
        height: cardHeight, // 반응형 세로 길이
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Card(
          elevation: 15, // 그림자 효과 추가
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // 모서리 둥글게
          ),
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
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 80,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/cardLogo.png'),
                            // 학교 마크 이미지 경로
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.1),
                              BlendMode.dstATop,
                            ),
                          ),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      CustomText(
                        id: schedule.title,
                        size: 12,
                      ),
                      SizedBox(height: 10,),
                      CustomText(
                        id: schedule.time,
                        size: 12,
                      ),
                      SizedBox(height: 10,),
                      CustomText(
                        id: schedule.location,
                        size: 12,
                      ),
                      SizedBox(height: 10,),
                      CustomText(
                        id: schedule.professor,
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ], // 스케쥴 정보 기입란
          ),
        )
    );
  }


  // 겹치는 카드들을 쌓아놓은 레이아웃을 구현
  Widget buildOverlappingCards(BuildContext context,List<Schedule> schedules) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Stack(
        children: schedules.reversed
            .toList()
            .asMap()
            .entries
            .map((entry) {
          // 펼친 이후 맨 위에 일정 1이 오게 하려고 리스트를 리버스
          int index = entry.key;
          var schedule = entry.value;
          return Positioned(
            top: index * 50, // 카드 사이의 간격
            left: 0,
            right: 0,
            child: buildScheduleCard(context, schedule, index), // Schedule 객체 전달
          );
        }).toList(),
      ),
    );
  }
}
