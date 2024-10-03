import 'package:flutter/material.dart';
import 'schedule_card.dart'; // 분리된 카드 관련 파일 import

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ScheduleScreen(),
    );
  }
}

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int currentProgress = 3; // 현재 참여 상황 (0~9)
  bool isExpanded = false; // 카드를 펼쳤는지 여부

  // 카드 정보와 색상 리스트
  final List<Color> barColors = [
    Color(0xFF3f51b5), // 일정 1
    Color(0xFF7986CB), // 일정 2
    Color(0xFF2962ff), // 일정 3
    Color(0xff6ab0f6), // 일정 4
    Color(0xFF0D47A1), // 일정 5
  ];

  final List<Map<String, String>> schedules = [
    {"title": "일정 1", "time": "09:30 ~ 11:00", "location": "장소:1506"},
    {"title": "일정 2", "time": "11:30 ~ 13:00", "location": "장소:1506"},
    {"title": "일정 3", "time": "13:30 ~ 15:00", "location": "장소:1506"},
    {"title": "일정 4", "time": "15:30 ~ 17:00", "location": "장소:1506"},
    {"title": "일정 5", "time": "17:30 ~ 19:00", "location": "장소:1506"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/logo.png', width: 150, height: 30), // 학교 로고
            Spacer(),
            IconButton(onPressed: () {}, icon: Icon(Icons.menu)), // 메뉴 아이콘
          ],
        ),
      ),
      body: GestureDetector(
        // 화면에서 드래그를 인식하도록
        onVerticalDragEnd: (details) {
          setState(() {
            isExpanded = !isExpanded; // 카드를 펼치도록 설정
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!isExpanded) ...[
                SizedBox(height: 20),
                Text('참여 상황: $currentProgress / 9',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                buildCustomProgressBar(currentProgress), // 참여 상황 알려주는 바
                SizedBox(height: 20),
              ],
              if (isExpanded)
                TextButton(
                  onPressed: () {
                    setState(() {
                      isExpanded = false;
                    });
                  },
                  child: Text("밀어서 접기",
                      style: TextStyle(decoration: TextDecoration.underline)),
                ),
              Expanded(
                child: Stack(
                  children: [
                    if (!isExpanded) buildOverlappingCards(),
                    if (isExpanded)
                      ListView(
                        children: schedules.map((schedule) {
                          int index = schedules.indexOf(schedule);
                          return buildScheduleCard(
                              schedule["title"]!,
                              schedule["time"]!,
                              schedule["location"]!,
                              barColors[4 - index]);
                        }).toList(),
                      ),
                  ],
                ),
              ),
              if (!isExpanded)
                TextButton(
                  onPressed: () {
                    setState(() {
                      isExpanded = true;
                    });
                  },
                  child: Text("밀어서 펼치기",
                      style: TextStyle(decoration: TextDecoration.underline)),
                ),
              if (!isExpanded) SizedBox(height: 30),
              if (!isExpanded)
                IconButton(
                  onPressed: () {
                    // QR 코드 인식 기능 추가
                  },
                  icon: Icon(Icons.qr_code_2_rounded, size: 35),
                ),
              if (!isExpanded) SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOverlappingCards() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Stack(
        children: schedules.reversed.toList().asMap().entries.map((entry) {
          int index = entry.key;
          var schedule = entry.value;
          return Positioned(
            top: index * 50,
            left: 0,
            right: 0,
            child: buildScheduleCard(schedule["title"]!, schedule["time"]!,
                schedule["location"]!, barColors[index]),
          );
        }).toList(),
      ),
    );
  }

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
