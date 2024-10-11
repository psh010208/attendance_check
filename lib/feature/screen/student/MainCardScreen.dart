import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ExpandedCardView.dart';
import 'CollapsedCardView.dart';
import 'package:attendance_check/feature/screen/MyPage.dart';

class MainCardScreen extends StatefulWidget {
  final String id;  // 로그인 시 전달된 studentId

  MainCardScreen({required this.id});

  @override
  _MainCardScreenState createState() => _MainCardScreenState();
}

class _MainCardScreenState extends State<MainCardScreen> {
  bool isExpanded = false;

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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/logo.png', width: 150, height: 30),
          ],
        ),
      ),
      endDrawer: Mypage(id: widget.id, role: '학부생'), // 역할 정보 전달

    );
  }
}
