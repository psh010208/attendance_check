import 'package:attendance_check/database/db_query/manage_db_query.dart';
import 'package:attendance_check/database/db_query/student_db_query.dart';
import 'package:attendance_check/feature/screen/SignInPage.dart'; // SignInPage import
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // inputFormatters를 사용하기 위한 import
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore 사용을 위한 import
import 'package:attendance_check/database/model/studentModel.dart';
import 'package:attendance_check/database/model/managerModel.dart';

// 회원가입 완료 후 팝업으로 피드백을 주는 위젯
class SignUpDialog extends StatelessWidget {
  final String message; // 팝업에 표시할 메시지
  final Duration delay; // 얼마의 시간을 대기할지

  SignUpDialog({
    required this.message,
    this.delay = const Duration(seconds: 1), // 기본적으로 1초 대기
  });

  @override
  Widget build(BuildContext context) {
    // 일정 시간 후에 팝업을 닫고 로그인 페이지로 이동
    Future.delayed(delay, () {
      Navigator.pop(context); // 팝업 닫기
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Signinpage()), // 로그인 페이지로 이동
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

  // Firestore 서비스 인스턴스
  final StudentDbQuery _studentService = StudentDbQuery();
  final ManagerDbQuery _managerService = ManagerDbQuery();

  // 입력 필드 값 저장을 위한 변수
  String? _selectedRole;
  String? _department;
  String? _name;
  String? _studentId;
  String? _tel;
  String? _password;

  // 회원가입 처리 함수
  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // 입력된 값을 저장

      // 역할에 따라 다른 Firestore 컬렉션에 저장
      try {
        if (_selectedRole == '학부생') {
          // 학부생 정보 저장
          final student = StudentModel(
            studentId: _studentId!,
            department: _department!,
            name: _name!,
            tel: _tel!,
            password: _password!,
          );
          await _studentService.addStudent(student); // Firestore에 저장
        } else if (_selectedRole == '관리자') {
          // 관리자 정보 저장
          final manager = ManagerModel(
            managerId: _studentId!,
            department: _department!,
            name: _name!,
            password: _password!,
          );
          await _managerService.addManager(manager); // Firestore에 저장
        }

        // 회원가입 성공 시 팝업을 띄우고 1초 후에 로그인 페이지로 이동
        showDialog(
          context: context,
          barrierDismissible: false, // 팝업 닫기 방지
          builder: (BuildContext context) {
            return SignUpDialog(
              message: "회원가입 완료! 로그인 화면으로 이동합니다.",
            );
          },
        );
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
          padding: EdgeInsets.only(left: 10, top: 20), // Image 주변에 margin을 적용
          child: Image.asset(
            'assets/logo.png',
            height: 100,
            width: 160,
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: SingleChildScrollView(  // 스크롤 가능하게 설정
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Column(
            children: [
              const SizedBox(height: 80),  // 상단 여백 추가
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 역할 선택 필드
                    DropdownButtonFormField<String>(
                      value: '학부생', // 기본값 설정
                      decoration: InputDecoration(
                        labelText: '사용자 유형',
                        border: OutlineInputBorder(),
                      ),
                      items: ['학부생', '관리자']
                          .map((value) => DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      )).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value;
                        });
                      },
                      validator: (value) =>
                      value == null ? '사용자 유형' : null,
                    ),
                    const SizedBox(height: 20),

                    // 학과 선택 필드
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
                      ]
                          .map((value) => DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _department = value;
                        });
                      },
                      validator: (value) => value == null ? '학과를 선택하세요' : null,
                    ),
                    const SizedBox(height: 20),

                    // 이름 입력 필드
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: '이름',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        _name = value;
                      },
                      validator: (value) =>
                      value == null || value.isEmpty ? '이름을 입력하세요' : null,
                    ),
                    const SizedBox(height: 20),

                    // 학번 입력 필드
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: '학번',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        _studentId = value;
                      },
                      validator: (value) =>
                      value == null || value.isEmpty ? '학번을 입력하세요' : null,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly, // 숫자만 입력 가능
                      ],
                    ),
                    const SizedBox(height: 20),

                    // 비밀번호 입력 필드
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: '생년월일(6자리)',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        _password = value;
                      },
                      obscureText: true, // 비밀번호 가리기
                      validator: (value) =>
                      value == null || value.isEmpty ? '생년월일을 입력하세요' : null,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly, // 숫자만 입력 가능
                      ],
                    ),
                    const SizedBox(height: 20),


                    // 전화번호 입력 필드 (선택 사항)
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
                        FilteringTextInputFormatter.digitsOnly, // 숫자만 입력 가능
                      ],
                    ),
                    const SizedBox(height: 40),

                    // 회원가입 버튼
                    Center( // 버튼을 화면 중앙에 배치
                      child: ElevatedButton(
                        onPressed: () {
                          _submitForm(context); // 회원가입 처리 로직 호출
                        },
                        child: Text('회원가입'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black, // 버튼의 배경색을 검정색으로 설정
                          foregroundColor: Colors.white, // 버튼 텍스트 색상을 하얀색으로 설정
                          minimumSize: Size(200, 50), // 버튼 크기 설정
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // 버튼 모서리 둥글게
                          ),
                        ),
                      ),
                    )

                  ],
                ),
              ),
              const SizedBox(height: 30), // 하단 여백 추가
            ],
          ),
        ),
      ),
    );
  }
}
