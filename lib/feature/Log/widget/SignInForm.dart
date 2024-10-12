import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:attendance_check/database/Repository/ManagerRepository.dart';
import 'package:attendance_check/database/model/ManagerModel.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? _selectedRole = '학부생';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> _login(BuildContext context) async {
    String id = idController.text.trim();
    String password = passwordController.text.trim();

    if (id.isEmpty || password.isEmpty || _selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 필드를 입력하세요.')),
      );
      return;
    }

    try {
      if (_selectedRole == '학부생') {
        var snapshot = await firestore
            .collection('student')
            .where('studentId', isEqualTo: id)
            .where('password', isEqualTo: password)
            .get();

        if (snapshot.docs.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('로그인 성공!')),
          );
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => MainCardScreen(id: '12'),  // 실제 id 전달 필요
          //   ),
          // );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('학번 또는 비밀번호가 잘못되었습니다.')),
          );
        }
      } else if (_selectedRole == '교수(관리자)') {
        ManagerRepository managerRepo = ManagerRepository();
        ManagerModel? manager = await managerRepo.fetchManagerById(id);
        if (manager != null && manager.password == password) {
          if (manager.isApprove == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('로그인 성공!')),
            );
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => MainAdminScreen(id: id, role: _selectedRole!),
            //   ),
            // );
          } else {
            _showApprovalPendingDialog(context);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('관리자 ID 또는 비밀번호가 잘못되었습니다.')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 중 오류가 발생했습니다. 다시 시도하세요.')),
      );
    }
  }

  void _showApprovalPendingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text("승인 대기 중", textAlign: TextAlign.center)),
          content: Text(
            "관리자 승인이 필요합니다. \n승인이 완료될 때까지 기다려주세요.",
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: '사용자 유형',
            border: OutlineInputBorder(),
          ),
          value: _selectedRole,
          items: ['학부생', '교수(관리자)'].map((value) {
            return DropdownMenuItem(child: Text(value), value: value);
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedRole = value;
            });
          },
        ),
        const SizedBox(height: 15),
        TextField(
          controller: idController,
          decoration: InputDecoration(
            labelText: '아이디(학번 또는 관리자 ID)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            labelText: '비밀번호(생년월일 6자리)',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () => _login(context),
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
      ],
    );
  }
}