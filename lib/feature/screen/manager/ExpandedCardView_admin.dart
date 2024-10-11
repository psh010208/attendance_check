import 'package:flutter/material.dart';

class ExpandedCardView_admin extends StatelessWidget {
  final List<Map<String, String>> schedules;
  final List<Color> barColors;
  final VoidCallback onCollapse;

  ExpandedCardView_admin({
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
      elevation: 15,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 15,
              color: barColor, // 안전한 색상 할당
            ),
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 65,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 40),
                      title: Text(
                        title,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        time,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}