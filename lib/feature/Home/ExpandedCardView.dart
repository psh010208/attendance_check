
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpandedCardView extends StatelessWidget {
  final List<Map<String, String>> schedules;
  final List<Color> barColors;
  final VoidCallback onCollapse;

  ExpandedCardView({
    required this.schedules,
    required this.barColors,
    required this.onCollapse,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: onCollapse,
          child: Text(
            "밀어서 접기",
            style: TextStyle(decoration: TextDecoration.underline),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              // barColors에서 안전하게 색상 선택
              final barColor = index < barColors.length
                  ? barColors[index]
                  : Colors.grey; // barColors의 길이를 초과하면 기본 색상 사용

              final schedule = schedules[index];
              return buildScheduleCard(
                schedule["title"]!,
                schedule["time"]!,
                schedule["location"]!,
                barColor,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildScheduleCard(
      String title, String time, String location, Color barColor) {
    return Card(
      elevation: 15, // 그림자 효과 추가
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // 모서리 둥글게
      ),
      child: Container(
        height: 180, // 카드의 세로 길이 조정
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/cardLogo.png'), // 학교 마크 이미지 경로
            fit: BoxFit.scaleDown, // 이미지가 카드의 전체 영역을 덮도록 설정
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.1), BlendMode.dstATop), // 투명도 조절
          ),
          borderRadius: BorderRadius.circular(10), // 모서리 둥글게
        ),
        child: Row(
          children: [
            Container(
              width: 15, // 왼쪽 바의 너비
              decoration: BoxDecoration(
                color: barColor, // 왼쪽 바의 색상 지정
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), // 위쪽 왼쪽 끝 둥글게
                  bottomLeft: Radius.circular(10), // 아래쪽 왼쪽 끝 둥글게
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}