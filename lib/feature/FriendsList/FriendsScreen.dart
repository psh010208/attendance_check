import 'package:flutter/material.dart';
import '../Drawer/widget/button.dart';

void main() {
  runApp(FriendsScreen());
}

class FriendsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white, // 흰색 배경 설정
        appBar: AppBar(
          title: Text('White Background App'),
          backgroundColor: Colors.blue, // AppBar 색상
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star, // 추가된 아이콘 (별 모양)
                size: 50, // 아이콘 크기
                color: Colors.blue, // 아이콘 색상
              ),
              SizedBox(height: 20), // 아이콘과 텍스트 간격
              Text(
                'Hello, World!',
                style: TextStyle(fontSize: 24, color: Colors.black), // 텍스트 스타일
              ),
              SizedBox(height: 20), // 텍스트와 버튼 간격
              FriendsListButton( // FriendsListButton 추가
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => FriendsScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
