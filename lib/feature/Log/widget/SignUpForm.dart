import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Home/widget/SoonCheck.dart';
import 'CustomDropdownFormField.dart';
import 'CustomTextFormField.dart';
import 'LogUpButton.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedRole = '학부생';
  String? _department = '의료IT공학과';
  String? _name, _studentId;

  Future<void> _submitForm(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    // Add your submit logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w), // 좌우 여백 고정
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Stretching elements
            children: [
              Flexible(
                child: SoonCheckWidget(bottom: -5.h, left: -50.w), // 반응형 위치 설정
              ),

              // "사용자 유형"과 "이름" 사이 간격 설정 (관리자 선택 시 40, 학부생 선택 시 20)
              SizedBox(height: _selectedRole == '관리자' ? 70.h : 70.h),

              // 사용자 유형 Dropdown
              CustomDropdownFormField(
                labelText: '사용자 유형',
                value: _selectedRole,
                items: ['학부생', '관리자'],
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value;
                  });
                },
              ),

              // 학부생일 때만 "학과 선택" 필드 표시
              if (_selectedRole == '학부생') ...[
                SizedBox(height: 20.h), // 간격 유지
                CustomDropdownFormField(
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
                ),
              ],

              // 관리자 선택 시 "이름"과 "학번" 사이 간격 조정
              SizedBox(height: _selectedRole == '관리자' ? 20.h : 20.h),

              // 이름 TextField
              buildCustomTextField('이름', TextInputType.text, false, (value) => _name = value),

              SizedBox(height: 20.h), // "이름"과 "학번" 사이 간격 (일관성 유지)

              // 학번 TextField
              buildCustomTextField('학번', TextInputType.number, false, (value) => _studentId = value),

              Spacer(), // 남은 공간을 밀어주기 위해 사용

              Flexible(
                child: Center(
                  child: LogUpButton(
                    onPressed: () => _submitForm(context),
                    text: '회원가입',
                  ),
                ),
              ),

              SizedBox(height: 130.h), // 버튼 아래 여백 추가
            ],
          ),
        ),
      ),
    );
  }

  // Custom TextField widget to avoid conflicts
  Widget buildCustomTextField(String labelText, TextInputType keyboardType, bool obscureText, FormFieldSetter<String>? onSaved) {
    return InfoTextField(
      labelText: labelText,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onSaved: onSaved,
      validator: (value) => value == null || value.isEmpty ? '$labelText을 입력하세요' : null,
    );
  }
}
