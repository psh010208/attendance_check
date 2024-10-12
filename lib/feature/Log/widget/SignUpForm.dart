import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:attendance_check/database/Repository/StudentRepository.dart';
import 'package:attendance_check/database/Repository/ManagerRepository.dart';
import 'package:attendance_check/database/model/studentModel.dart';
import 'package:attendance_check/database/model/ManagerModel.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final StudentRepository _studentRepository = StudentRepository();
  final ManagerRepository _managerRepository = ManagerRepository();

  String? _selectedRole = '학부생';
  String? _department, _name, _studentId, _tel, _password;

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

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (await _isStudentIdExists()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이미 존재하는 학번입니다. 다른 학번을 입력하세요.')),
        );
        return;
      }

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
          Navigator.pop(context);
        } else if (_selectedRole == '관리자') {
          final manager = ManagerModel(
            managerId: _studentId!,
            department: _department!,
            name: _name!,
            password: _password!,
            isApprove: false,
          );
          await _managerRepository.addManager(manager);
          _showApprovalPendingDialog(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 중 오류가 발생했습니다. 다시 시도하세요.')),
        );
      }
    }
  }

  void _showApprovalPendingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Expanded(child: Text('회원가입 완료! 관리자 승인 후 로그인이 가능합니다.')),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: '사용자 유형',
          border: OutlineInputBorder(),
        ),
        value: _selectedRole,
        items: ['학부생', '관리자'].map((value) {
      return DropdownMenuItem(child:                Text(value), value: value);
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
                return DropdownMenuItem(child: Text(value), value: value);
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
                  _submitForm(context);
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
    );
  }
}
