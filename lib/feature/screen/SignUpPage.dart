import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:attendance_check/database/model/studentModel.dart';
import 'package:attendance_check/database/model/managerModel.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedRole; // 역할 선택 변수
  String? _selectedDepartment; // 학과 선택 변수
  String? _name;
  String? _studentId;
  String? _password;
  String? _tel;
  DateTime? _birthDate;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 회원가입 버튼을 눌렀을 때 호출되는 함수
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_selectedRole == '학부생') {
        // 학부생일 경우
        final student = StudentModel(
          studentId: _studentId!,
          department: _selectedDepartment!,
          name: _name!,
          tel: _tel!,
          password: _password!,
        );

        // Firestore에 학부생 데이터 저장
        await _firestore.collection('student').add(student.toMap());
        print('학부생 데이터 저장 완료!');
      } else if (_selectedRole == '관리자') {
        // 관리자일 경우
        final manager = ManagerModel(
          managerId: _studentId!, // 학번 대신 관리자 ID 사용
          department: _selectedDepartment!,
          name: _name!,
          password: _password!,
        );

        // Firestore에 관리자 데이터 저장
        await _firestore.collection('manager').add(manager.toMap());
        print('관리자 데이터 저장 완료!');
      }

      // 데이터 저장 완료 후 메시지 혹은 다음 페이지 이동
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입이 완료되었습니다!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입 페이지'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 역할 선택 필드
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: '역할을 선택하세요',
                  border: OutlineInputBorder(),
                ),
                items: ['학부생', '관리자']
                    .map((value) => DropdownMenuItem(
                  child: Text(value),
                  value: value,
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value;
                  });
                },
                validator: (value) =>
                value == null ? '역할을 선택하세요' : null,
              ),
              const SizedBox(height: 20),

              // 학과 선택 필드
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: '학과를 선택하세요',
                  border: OutlineInputBorder(),
                ),
                items: ['의료IT공학과', '컴퓨터소프트웨어공학과', '정보보호학과', 'AI빅데이터학과', '사물인터넷학과', '메타버스&게임학과']
                    .map((value) => DropdownMenuItem(
                  child: Text(value),
                  value: value,
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDepartment = value;
                  });
                },
                validator: (value) =>
                value == null ? '학과를 선택하세요' : null,
              ),
              const SizedBox(height: 20),

              // 이름 입력 필드
              TextFormField(
                decoration: InputDecoration(
                  labelText: '이름',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => _name = value,
                keyboardType: TextInputType.name, // 이 부분 추가
                validator: (value) =>
                value == null || value.isEmpty ? '이름을 입력하세요' : null,
              ),
              const SizedBox(height: 20),

              // 학번 또는 관리자 ID 입력 필드
              TextFormField(
                decoration: InputDecoration(
                  labelText: _selectedRole == '관리자' ? '관리자 ID' : '학번',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => _studentId = value,
                validator: (value) =>
                value == null || value.isEmpty ? '학번을 입력하세요' : null,
              ),
              const SizedBox(height: 20),

              // 전화번호 입력 필드 (학부생만)
              if (_selectedRole == '학부생')
                TextFormField(
                  decoration: InputDecoration(
                    labelText: '전화번호',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) => _tel = value,
                  validator: (value) =>
                  value == null || value.isEmpty ? '전화번호를 입력하세요' : null,
                ),
              const SizedBox(height: 20),

              // 비밀번호 입력 필드
              TextFormField(
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                onSaved: (value) => _password = value,
                validator: (value) =>
                value == null || value.isEmpty ? '비밀번호를 입력하세요' : null,
              ),
              const SizedBox(height: 40),

              // 회원가입 버튼
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('회원가입'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50), // 버튼 가로 크기
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
