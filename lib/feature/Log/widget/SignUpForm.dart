import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Home/widget/SoonCheck.dart';
import '../Model/logModel.dart';
import '../ViewModel/logViewModel.dart';
import '../logPage.dart';
import 'CustomDropdownFormField.dart';
import 'CustomTextFormField.dart';
import 'LogUpButton.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final LogViewModel logViewModel = LogViewModel();
  final _formKey = GlobalKey<FormState>();
  String? _selectedRole = '학부생';
  String? _department = '의료IT공학과';
  String? _name, _studentId;

  // 회원가입 폼 제출
  Future<void> _submitForm(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      _showErrorDialog(context, '회원가입 실패', '입력되지 않은 정보가 있습니다.');
      return;
    }

    _formKey.currentState!.save();

    if (await _checkDuplicate()) return;

    // 사용자 정보 Firestore에 저장
    final newUser = LogModel(
      studentId: _studentId!,
      department: _department!,
      name: _name!,
      role: _selectedRole!,
      isApproved: _selectedRole == '관리자' ? false : true, // 관리자는 승인 필요
    );

    await logViewModel.signUp(newUser);

    // 학부생일 경우에만 attendance_summary에 학생의 출석 정보 저장 (초기값: total_attendance = 0)
    if (_selectedRole == '학부생') {
      await FirebaseFirestore.instance.collection('attendance_summary').add({
        'student_id': _studentId!,
        'total_attendance': 0, // 출석 횟수 초기값 0
      });
    }

    _showSuccessDialog(context);
  }

  // 학번 중복 체크 함수
  Future<bool> _checkDuplicate() async {
    bool isDuplicate = await logViewModel.isStudentIdDuplicate(_studentId!);
    if (isDuplicate) {
      _showErrorDialog(context, '오류', '이미 사용 중인 학번입니다.');
      return true;
    }
    return false;
  }

  // 에러 메시지 다이얼로그 표시
  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  // 회원가입 성공 메시지 다이얼로그 표시
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('회원가입 성공'),
        content: Text(_selectedRole == '관리자'
            ? '회원가입이 완료되었습니다. 관리자 승인 대기 중입니다.'
            : '회원가입이 완료되었습니다!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => logPage(isLogin: true)),
                    (Route<dynamic> route) => false,
              );
            },
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(child: SoonCheckWidget(bottom: -5.h, left: 5.w)),

                SizedBox(height: _getRoleBasedSpacing()),

                _buildRoleDropdown(),

                if (_selectedRole == '학부생') ...[
                  SizedBox(height: 20.h),
                  _buildDepartmentDropdown(),
                ],

                SizedBox(height: 20.h),

                _buildCustomTextField('이름', TextInputType.text, (value) => _name = value),

                SizedBox(height: 20.h),

                _buildCustomTextField('학번', TextInputType.number, (value) => _studentId = value),

                SizedBox(height: 30.h),

                Flexible(
                  child: Center(
                    child: LogUpButton(
                      onPressed: () => _submitForm(context),
                      text: '회원가입',
                    ),
                  ),
                ),

                SizedBox(height: 130.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 역할 선택에 따라 간격 설정
  double _getRoleBasedSpacing() {
    return _selectedRole == '관리자' ? 100.h : 70.h;
  }

  // 사용자 유형 드롭다운 빌드 함수
  Widget _buildRoleDropdown() {
    return CustomDropdownFormField(
      labelText: '사용자 유형',
      value: _selectedRole,
      items: ['학부생', '관리자'],
      onChanged: (value) {
        setState(() {
          _selectedRole = value;
        });
      },
    );
  }

  // 학과 드롭다운 빌드 함수
  Widget _buildDepartmentDropdown() {
    return CustomDropdownFormField(
      labelText: '학과를 선택하세요',
      value: _department,
      items: [
        '의료IT공학과',
        '컴퓨터소프트웨어공학과',
        '정보보호학과',
        'AI빅데이터학과',
        '사물인터넷학과',
        '메타버스&게임학과'
      ],
      onChanged: (value) {
        setState(() {
          _department = value;
        });
      },
    );
  }

  // 텍스트 필드 빌드 함수
  Widget _buildCustomTextField(
      String labelText, TextInputType keyboardType, FormFieldSetter<String> onSaved) {
    return InfoTextField(
      labelText: labelText,
      keyboardType: keyboardType,
      obscureText: false,
      onSaved: onSaved,
      validator: (value) => value == null || value.isEmpty ? '$labelText을 입력하세요' : null,
    );
  }
}
