import 'package:flutter/material.dart';

class CollapsedCardView_admin extends StatelessWidget {
  final List<Map<String, String>> schedules;
  final List<Color> barColors;
  final int currentProgress;
  final VoidCallback onExpand;

  CollapsedCardView_admin(
      {required this.currentProgress,
        required this.schedules,
        required this.barColors,
        required this.onExpand});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                // 여기에 참여 명단 보기 로직을 추가하세요.
              },
              icon: Icon(Icons.list), // 참여 명단을 나타낼 아이콘
              label: Text(
                '참여 명단 보기',
                style: TextStyle(
                  fontSize: 17, // 텍스트 크기
                  fontWeight: FontWeight.bold, // 텍스트 굵기
                ),
              ), // 버튼에 표시할 텍스트
              style: ElevatedButton.styleFrom(
                iconColor: Colors.blue,  // 버튼 배경색
              ),
            ),
          ],
        ),
        SizedBox(height: 50),
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
                        SizedBox(width: 10),
                        Text(
                          '$location',
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(width: 10),
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