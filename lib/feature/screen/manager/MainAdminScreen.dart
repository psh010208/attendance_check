import 'package:flutter/material.dart';
import '../MyPage.dart';

class MainAdminScreen extends StatefulWidget {
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
      endDrawer: Mypage(),
      body: Scaffold(),
    );
  }
}
