import 'package:flutter/material.dart';
import 'ExpandedCardView.dart';
import 'CollapsedCardView.dart';
import 'MyPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainCardScreen(),
    );
  }
}

class MainCardScreen extends StatefulWidget {
  @override
  _MainCardScreenState createState() => _MainCardScreenState();
}

class _MainCardScreenState extends State<MainCardScreen> {
  int currentProgress = 3;
  bool isExpanded = false;

  // 왼쪽 바에 사용할 색상을 리스트로 정의
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
            Image.asset('assets/logo.png', width: 150, height: 30),
          ],
        ),
      ),
      endDrawer: Mypage(),
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isExpanded
              ? ExpandedCardView(
                  schedules: schedules,
                  barColors: barColors,
                  onCollapse: () {
                    setState(() {
                      isExpanded = false;
                    });
                  },
                )
              : CollapsedCardView(
                  currentProgress: currentProgress,
                  schedules: schedules,
                  barColors: barColors,
                  onExpand: () {
                    setState(() {
                      isExpanded = true;
                    });
                  },
                ),
        ),
      ),
    );
  }
}
