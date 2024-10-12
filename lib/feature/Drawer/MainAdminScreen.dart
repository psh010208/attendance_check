import 'package:flutter/material.dart';
import 'drawerScreen.dart';

class MainAdminScreen extends StatefulWidget {


  @override
  _MainAdminScreenState createState() => _MainAdminScreenState();
}

class _MainAdminScreenState extends State<MainAdminScreen> {
  bool isExpanded = false;
  List<dynamic> events = []; //이벤트 리스트


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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        //iconTheme: IconThemeData(color: Colors.black), // AppBar의 아이콘 테마
        actionsIconTheme: IconThemeData(color: Colors.black),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/logo.png', width: 150, height: 30),
          ],
        ),
      ),
      endDrawer: drawerScreen(
        role: '학부생', // 필요한 파라미터 전달
        id: '김형은',      ),
      body: Center(child: Text('Main content here')),
    );
  }
}
