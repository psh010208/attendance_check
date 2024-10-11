import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:attendance_check/database/Repository/StudentRepository.dart';
import 'package:attendance_check/database/Repository/ManagerRepository.dart';
import 'package:attendance_check/database/model/studentModel.dart';
import 'package:attendance_check/database/model/ManagerModel.dart';
import 'package:attendance_check/feature/sign//SignInPage.dart';

// 회원가입 완료 후 보여주는 다이얼로그
class SignUpDialog extends StatelessWidget {
  final String message;

  SignUpDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pop(context); // 팝업 닫기
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()), // 로그인 페이지로 이동
      );
    });

    return AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 20),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }
}

// 관리자 회원가입 시 팝업
class _showApprovalPendingDialog extends StatelessWidget {
  final String message;

  _showApprovalPendingDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pop(context); // 팝업 닫기
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()), // 로그인 페이지로 이동
      );
    });

    return AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 20),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  // Repositories
  final StudentRepository _studentRepository = StudentRepository();
  final ManagerRepository _managerRepository = ManagerRepository();

  // 입력 필드 값 저장
  String? _selectedRole = '학부생';
  String? _department;
  String? _name;
  String? _studentId;
  String? _tel;
  String? _password;

  // 학번 중복 확인 함수
  Future<bool> _isStudentIdExists() async {
    try {
      var studentExists = await _studentRepository.getAllStudents();
      var managerExists = await _managerRepository.getAllManagers();

      return studentExists.any((student) => student.studentId == _studentId) ||
          managerExists.any((manager) => manager.managerId == _studentId);
    } catch (e) {
      print('Error checking ID existence: $e');
      return false;
    }
  }

  // 관리자 회원가입 처리 로직
  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // 입력된 값을 저장

      // 학번 중복 확인
      if (await _isStudentIdExists()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이미 존재하는 학번입니다. 다른 학번을 입력하세요.')),
        );
        return;
      }

      // Firestore에 저장
      try {
        if (_selectedRole == '학부생') {
          final student = StudentModel(
            studentId: _studentId!,
            department: _department!,
            name: _name!,
            tel: _tel!,
            password: _password!,
          );
          await _studentRepository.addStudent(student);

          // 회원가입 성공 시 팝업 띄우고 로그인 페이지로 이동
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return SignUpDialog(message: "회원가입 완료! 로그인 화면으로 이동합니다.");
            },
          );
        }else if (_selectedRole == '관리자') {
          final manager = ManagerModel(
            managerId: _studentId!,
            department: _department!,
            name: _name!,
            password: _password!,
            isApprove: false,
          );
          await _managerRepository.addManager(manager);

          // 관리자 등록 후 승인 대기 팝업 표시
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return _showApprovalPendingDialog(message: "회원가입 완료! 관리자 승인 후 로그인이 가능합니다.");
            },
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 중 오류가 발생했습니다. 다시 시도하세요.')),
        );
      }
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Column(
            children: [
              const SizedBox(height: 80),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedRole, // 여기에서 _selectedRole 사용
                      decoration: InputDecoration(
                        labelText: '사용자 유형',
                        border: OutlineInputBorder(),
                      ),
                      items: ['학부생', '관리자'].map((value) {
                        return DropdownMenuItem(
                          child: Text(value),
                          value: value,
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value;
                        });
                      },
                      validator: (value) => value == null ? '사용자 유형을 선택하세요' : null,
                    ),
                    const SizedBox(height: 20),

                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: '학과를 선택하세요',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        '의료IT공학과',
                        '컴퓨터소프트웨어공학과',
                        '정보보호학과',
                        'AI빅데이터학과',
                        '사물인터넷학과',
                        '메타버스&게임학과'
                      ].map((value) {
                        return DropdownMenuItem(
                          child: Text(value),
                          value: value,
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _department = value;
                        });
                      },
                      validator: (value) => value == null ? '학과를 선택하세요' : null,
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      decoration: InputDecoration(
                        labelText: '이름',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        _name = value;
                      },
                      validator: (value) => value == null || value.isEmpty ? '이름을 입력하세요' : null,
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      decoration: InputDecoration(
                        labelText: '학번',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        _studentId = value;
                      },
                      validator: (value) => value == null || value.isEmpty ? '학번을 입력하세요' : null,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      decoration: InputDecoration(
                        labelText: '생년월일(6자리)',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        _password = value;
                      },
                      obscureText: true,
                      validator: (value) => value == null || value.isEmpty ? '생년월일을 입력하세요' : null,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      decoration: InputDecoration(
                        labelText: '[선택] 전화번호',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        _tel = value;
                      },
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    const SizedBox(height: 40),

                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _submitForm(context); // 회원가입 처리 로직 호출
                        },
                        child: Text('회원가입'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          minimumSize: Size(200, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}