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
          padding: EdgeInsets.symmetric(horizontal: 30.w), // 좌우 여백을 고정
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // 위쪽에 배치
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40.h), // 상단에 빈 공간 추가
              Flexible(
                child: SoonCheckWidget(bottom: -10.h, left: -50.w), // 반응형 위치 설정
              ),
              SizedBox(height: 40.h), // 간격 유지
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
              SizedBox(height: 20.h), // 간격 유지
              if (_selectedRole == '학부생')
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
              SizedBox(height: 20.h), // 간격 유지
              buildCustomTextField('이름', TextInputType.text, false, (value) => _name = value),
              SizedBox(height: 20.h),
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
