import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입 페이지'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 학과 선택 필드
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: '학과를 선택하세요',
                border: OutlineInputBorder(),
              ),
              items: ['의료IT공학과', '컴퓨터소프트웨어공학과', '정보보호학과'] // 예시 학과
                  .map((value) => DropdownMenuItem(
                child: Text(value),
                value: value,
              ))
                  .toList(),
              onChanged: (value) {
                // 학과 선택시 처리
              },
            ),
            const SizedBox(height: 20),

            // 이름 입력 필드
            TextField(
              decoration: InputDecoration(
                labelText: '이름',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // 학번 입력 필드
            TextField(
              decoration: InputDecoration(
                labelText: '학번',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // 생년월일 입력 필드
            TextField(
              decoration: InputDecoration(
                labelText: '생년월일',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 40),

            // 회원가입 버튼
            ElevatedButton(
              onPressed: () {
                // 회원가입 처리
              },
              child: Text('회원가입'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // 버튼 가로 크기
              ),
            ),
          ],
        ),
      ),
    );
  }
}
