import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Drawer/widget/button.dart';
import '../Home/homeScreen.dart';

void main() {
  runApp(MaterialApp(
    home: FriendsScreen(role: 'User', id: '123'), // 필요한 role과 id를 전달
  ));
}

class FriendsScreen extends StatelessWidget {
  final String role;
  final String id;

  FriendsScreen({required this.role, required this.id}); // 생성자 수정

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 흰색 배경 설정
      appBar: AppBar(
        title: Text('Friends Screen'),
        backgroundColor: Colors.blue, // AppBar 색상
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios,
                  color: Theme.of(context).colorScheme.onSurface, // 아이콘 색상 수정
                  size: 25.sp),
              onPressed: () {
                // HomeScreen으로 네비게이션
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(role: role, id: id), // role과 id 전달
                  ),
                );
              },
            ),
            SizedBox(height: 20), // 아이콘과 텍스트 간격
            Text(
              'Hello, World!',
              style: TextStyle(fontSize: 24, color: Colors.black), // 텍스트 스타일
            ),
            SizedBox(height: 20), // 텍스트와 버튼 간격
            FriendsListButton( // FriendsListButton 추가
              onPressed: () {},
              role: role,
              id: id,
            ),
            SizedBox(height: 20), // FriendsListButton과 친구 추가 버튼 간격
            ElevatedButton(
              onPressed: () {
                // 친구 추가 동작 구현
                // 여기에서 친구 추가 로직을 추가하세요.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('친구 추가되었습니다!')),
                );
              },
              child: Text('친구 추가', style: TextStyle(fontSize: 20)), // 버튼 텍스트
            ),
          ],
        ),
      ),
    );
  }
}
