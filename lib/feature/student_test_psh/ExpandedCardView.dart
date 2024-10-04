import 'package:flutter/material.dart';

class ExpandedCardView extends StatelessWidget {
  final List<Map<String, String>> schedules;
  final List<Color> barColors;
  final VoidCallback onCollapse;

  ExpandedCardView(
      {required this.schedules,
      required this.barColors,
      required this.onCollapse});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: onCollapse,
          child: Text("밀어서 접기",
              style: TextStyle(decoration: TextDecoration.underline)),
        ),
        Expanded(
          child: Stack(
            children: [
              ListView(
                children: schedules.map((schedule) {
                  // schedule 정보를 사용하여 카드 생성
                  int index = schedules.indexOf(schedule);
                  return buildScheduleCard(
                      schedule["title"]!,
                      schedule["time"]!,
                      schedule["location"]!,
                      barColors[index]);
                }).toList(),
              ),
            ],
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
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 65, // 체크 버튼, 장소, 알림 버튼의 위치를 카드 정 중앙으로
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 40),
                      // 내용 패딩
                      title: Text(title,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      trailing: Text(time,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.check_circle_outline,
                                size: 30,
                              ),
                              onPressed: () {
                                // 체크 아이콘 눌렀을 때 동작
                              },
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '$location',
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(width: 10),
                            IconButton(
                              icon: Icon(
                                Icons.alarm,
                                size: 30,
                              ),
                              onPressed: () {
                                // 알림 아이콘 눌렀을 때 동작
                              },
                            ),
                          ],
                        )
                      ],
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
