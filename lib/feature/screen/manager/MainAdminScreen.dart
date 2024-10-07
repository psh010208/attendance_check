import 'package:flutter/material.dart';
import 'package:attendance_check/feature/screen/MyPage.dart';

class MainAdminScreen extends StatefulWidget {
  final String id; // 관리자 ID를 전달받음

  MainAdminScreen({required this.id}); // 생성자에서 managerId 전달

  @override
  _MainAdminScreen createState() => _MainAdminScreen();
}

class _MainAdminScreen extends State<MainAdminScreen> {

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
      // Mypage에 managerId 전달, role 정보도 전달
      endDrawer: Mypage(id: widget.id, role: '교수(관리자)'), // 역할 정보 전달
      body: Scaffold(),
    );
  }
}
