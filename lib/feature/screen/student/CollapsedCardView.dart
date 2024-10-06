import 'package:flutter/material.dart';

class CollapsedCardView extends StatelessWidget {
  final List<Map<String, String>> schedules;
  final List<Color> barColors;
  final int currentProgress;
  final VoidCallback onExpand;

  CollapsedCardView(
      {required this.currentProgress,
        required this.schedules,
        required this.barColors,
        required this.onExpand});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Text('참여 상황: $currentProgress / 9', style: TextStyle(fontSize: 18)),
        SizedBox(height: 10),
        // 커스텀 막대
        buildCustomProgressBar(currentProgress),
        SizedBox(height: 20),
        Expanded(
          child: Stack(
            children: [
              buildOverlappingCards(), // 카드들이 겹쳐 보이도록
            ],
          ),
        ),
        TextButton(
          onPressed: onExpand,
          child: Text("밀어서 펼치기",
              style: TextStyle(decoration: TextDecoration.underline)),
        ),
        SizedBox(height: 30), // 버튼과 위의 내용 간격
        IconButton(
          onPressed: () {
            // QR 코드 인식 기능을 추가하는 부분
          },
          icon: Icon(
            Icons.qr_code_2_rounded,
            size: 35,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent, // 배경색을 투명하게 설정
            shadowColor: Colors.transparent, // 그림자 색상도 투명하게 설정
          ),
        ),
        SizedBox(height: 16), // 버튼과 화면 아래 간격
      ],
    );
  }

  Widget buildScheduleCard(
      String title, String time, String location, int index) {
    Color barColor =
    barColors.length > index ? barColors[index] : Colors.grey; // 기본 색상 처리
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
                        IconButton(
                          icon: Icon(
                            Icons.check_circle_outline,
                            size: 30,
                          ),
                          onPressed: () {
                            // 체크 아이콘 눌렀을 때 동작
                          },
                        ),
                        SizedBox(width: 10),
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

  Widget buildOverlappingCards() {
    // 겹치는 카드들을 쌓아놓은 레이아웃을 구현
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Stack(
        children: schedules.reversed.toList().asMap().entries.map((entry) {
          // 펼친 이후 맨 위에 일정 1이 오게 하려고 리스트를 리버스
          int index = entry.key;
          var schedule = entry.value;
          return Positioned(
            top: index * 50, // 카드 사이의 간격
            left: 0,
            right: 0,
            child: buildScheduleCard(schedule["title"]!, schedule["time"]!,
                schedule["location"]!, index),
          );
        }).toList(),
      ),
    );
  }

  // 둥근 끝을 가진 커스텀 막대
  Widget buildCustomProgressBar(int progress) {
    int totalSteps = 9;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        return Container(
          width: 25,
          height: 10,
          margin: EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: index < progress ? Colors.red : Colors.grey[300],
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(index == 0 ? 5 : 0),
              right: Radius.circular(index == totalSteps - 1 ? 5 : 0),
            ),
          ),
        );
      }),
    );
  }
}