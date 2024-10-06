import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'student/MainCardScreen.dart'; // MainCardScreen import
import 'SignUpPage.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedRole = '학부생'; // 기본값으로 '학부생' 설정

  // Firestore 인스턴스
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // 승인 대기 팝업
  void _showApprovalPendingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "승인 대기 중",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          content: Text(
            "관리자 승인이 필요합니다. \n승인이 완료될 때까지 기다려주세요.",
            style: TextStyle(fontSize: 16), // 글씨 크기 조정
            textAlign: TextAlign.center, // 텍스트 가운데 정렬
          ),

          actions: [
            Center( // 확인 버튼을 가운데 배치
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("확인"),
              ),
            ),
          ],
        );
      },
    );
  }

  // 로그인 처리 함수
  Future<void> _login(BuildContext context) async {
    String studentId = _studentIdController.text.trim();
    String password = _passwordController.text.trim();

    if (studentId.isEmpty || password.isEmpty || _selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 필드를 입력하세요.')),
      );
      return;
    }

    try {
      // 학부생일 경우
      if (_selectedRole == '학부생') {
        var snapshot = await firestore
            .collection('student')
            .where('studentId', isEqualTo: studentId)
            .where('password', isEqualTo: password)
            .get();

        if (snapshot.docs.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('로그인 성공!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MainCardScreen()), // CardScreen으로 이동
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('학번 또는 비밀번호가 잘못되었습니다.')),
          );
        }
      }
      // 관리자일 경우
      else if (_selectedRole == '교수(관리자)') {
        var snapshot = await firestore
            .collection('manager')
            .where('managerId', isEqualTo: studentId)
            .where('password', isEqualTo: password)
            .get();

        if (snapshot.docs.isNotEmpty) {
          var managerData = snapshot.docs.first.data();
          if (managerData['isApproved'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('로그인 성공!')),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MainCardScreen()), // CardScreen으로 이동
            );
          } else {
            // 관리자가 승인되지 않은 상태라면 승인 대기 중 팝업 표시
            _showApprovalPendingDialog(context);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('ID 또는 비밀번호가 잘못되었습니다.')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 중 오류가 발생했습니다. 다시 시도하세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Image.asset(
            'assets/logo.png',
            height: 100,
            width: 160,
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 150,
                height: 60,
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: '학부생',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedRole,
                  items: ['학부생', '교수(관리자)']
                      .map((value) => DropdownMenuItem(
                    child: Text(value),
                    value: value,
                  ))
                      .toList(),
                  onChanged: (value) {
                    _selectedRole = value;
                  },
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _studentIdController,
              decoration: InputDecoration(
                labelText: '아이디(학번 또는 관리자 ID)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: '비밀번호(생년월일 6자리)',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                _login(context);
              },
              child: Text('로그인'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                minimumSize: Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: Text(
                '회원가입을 하시겠습니까?',
                style: TextStyle(
                  color: Colors.indigo[800],
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