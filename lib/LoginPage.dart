import 'package:flutter/material.dart';
import 'SignUpPage.dart';  // 회원가입 페이지 import

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인 페이지'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 학부생 선택
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: '학부생',
                border: OutlineInputBorder(),
              ),
              items: ['학부생', '교수(관리자)'] // 선택 옵션
                  .map((value) => DropdownMenuItem(
                child: Text(value),
                value: value,
              ))
                  .toList(),
              onChanged: (value) {
                // 선택시 처리
              },
            ),
            const SizedBox(height: 20),

            // 아이디 입력 필드
            TextField(
              decoration: InputDecoration(
                labelText: '아이디(학번)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // 비밀번호 입력 필드
            TextField(
              decoration: InputDecoration(
                labelText: '비밀번호(생년월일)',
                border: OutlineInputBorder(),
              ),
              obscureText: true, // 비밀번호 가리기
            ),
            const SizedBox(height: 20),

            // 이름 입력 필드
            TextField(
              decoration: InputDecoration(
                labelText: '이름',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 40),

            // 로그인 버튼
            ElevatedButton(
              onPressed: () {
                // 로그인 처리
              },
              child: Text('로그인'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // 버튼 가로크기
              ),
            ),
            const SizedBox(height: 20),

            // 회원가입 유도 텍스트
            GestureDetector(
              onTap: () {
                // 회원가입 페이지로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: Text(
                '회원가입을 하시겠습니까?',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
