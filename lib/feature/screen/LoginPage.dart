import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore 사용을 위한 import
import 'SignUpPage.dart'; // 회원가입 페이지 import
import 'cardScreen.dart'; // CardScreen 페이지 import

class LoginPage extends StatelessWidget {
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedRole;

  // Firestore 인스턴스
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // 로그인 처리 함수
  Future<void> _login(BuildContext context) async {
    String studentId = _studentIdController.text.trim();
    String password = _passwordController.text.trim();
    String? _selectedRole = '학부생';

    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    if (studentId.isEmpty || password.isEmpty || _selectedRole == 'null') {
      // 입력 필드가 비어있을 때 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 필드를 입력하세요.')),
      );
      return;
    }

    try {
      // 학부생일 경우 student 컬렉션에서 확인
      if (_selectedRole == '학부생') {
        var snapshot = await firestore
            .collection('student')
            .where('studentId', isEqualTo: studentId)
            .where('password', isEqualTo: password)
            .get();

        if (snapshot.docs.isNotEmpty) {
          // 로그인 성공
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('로그인 성공!')),
          );
          // CardScreen으로 이동
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => cardScreen()),
          );
        } else {
          // 로그인 실패
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('학번 또는 비밀번호가 잘못되었습니다.')),
          );
        }
      }
      // 관리자인 경우 manager 컬렉션에서 확인
      else if (_selectedRole == '교수(관리자)') {
        var snapshot = await firestore
            .collection('manager')
            .where('managerId', isEqualTo: studentId)
            .where('password', isEqualTo: password)
            .get();

        if (snapshot.docs.isNotEmpty) {
          // 로그인 성공
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('로그인 성공!')),
          );
          // CardScreen으로 이동
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => cardScreen()),
          );
        } else {
          // 로그인 실패
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('ID 또는 비밀번호가 잘못되었습니다.')),
          );
        }
      }
    } catch (e) {
      // Firestore 조회 오류
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 중 오류가 발생했습니다. 다시 시도하세요.')),
      );
    }
  }

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
            // 학부생/관리자 선택
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: '학부생',
                border: OutlineInputBorder(),
              ),
              value: _selectedRole, // 기본값으로 '학부생' 설정
              items: ['학부생', '교수(관리자)']
          .map((value) => DropdownMenuItem(
                child: Text(value),
                value: value,
              ))
                  .toList(),
              onChanged: (value) {
                _selectedRole = value;
              },
              validator: (value) => value == null ? '역할을 선택하세요' : null,
            ),
            const SizedBox(height: 20),

            // 학번 입력 필드
            TextField(
              controller: _studentIdController,
              decoration: InputDecoration(
                labelText: '아이디(학번 또는 관리자 ID)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // 비밀번호 입력 필드
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: '비밀번호(생년월일)',
                border: OutlineInputBorder(),
              ),
              obscureText: true, // 비밀번호 가리기
            ),
            const SizedBox(height: 40),

            // 로그인 버튼
            ElevatedButton(
              onPressed: () {
                // 로그인 처리
                _login(context);
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
