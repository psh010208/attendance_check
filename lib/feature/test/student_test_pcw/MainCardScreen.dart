import 'package:flutter/material.dart';
import 'MyPage.dart';
import 'ExpandedCardView.dart';
import 'CollapsedCardView.dart';

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

  // 일정 리스트
  final List<Map<String, String>> schedules = [
    {"title": "일정 1", "time": "09:30 ~ 11:00", "location": "장소:1506"},
    {"title": "일정 2", "time": "11:30 ~ 13:00", "location": "장소:1506"},
    {"title": "일정 3", "time": "13:30 ~ 15:00", "location": "장소:1506"},
    {"title": "일정 4", "time": "15:30 ~ 17:00", "location": "장소:1506"},
    {"title": "일정 5", "time": "17:30 ~ 19:00", "location": "장소:1506"},
  ];

  // 일정 추가하는 함수
  void _addSchedule(String title, String time, String location) {
    setState(() {
      schedules.add({"title": title, "time": time, "location": location});
    });
  }

  // 일정 추가 다이얼로그
  void _showAddScheduleDialog(BuildContext context) {
    String title = '';
    String time = '';
    String location = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('새 일정 추가'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: '제목'),
                onChanged: (value) {
                  title = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: '시간'),
                onChanged: (value) {
                  time = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: '위치'),
                onChanged: (value) {
                  location = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('추가'),
              onPressed: () {
                if (title.isNotEmpty && time.isNotEmpty && location.isNotEmpty) {
                  _addSchedule(title, time, location);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/logo.png', width: 150, height: 30),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _showAddScheduleDialog(context); // 일정 추가 다이얼로그 열기
              },
            ),
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
