import 'package:flutter/material.dart';
import 'package:attendance_check/database/Repository/StudentRepository.dart';
import 'package:attendance_check/database/Repository/ManagerRepository.dart';
import 'package:flutter/services.dart';
import '../../Home/widget/SoonCheck.dart'; // SoonCheck import
import 'CustomTextFormField.dart';
import 'LogUpButton.dart';
import 'CustomDropdownFormField.dart'; // 새로운 CustomDropdownFormField import

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _studentRepository = StudentRepository();
  final _managerRepository = ManagerRepository();

  String? _selectedRole = '학부생';
  String? _department = '의료IT공학과'; // 기본값을 '의료IT공학과'로 설정
  String? _name, _studentId, _tel, _password;

  Future<void> _submitForm(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    // Add your submit logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SoonCheckWidget(bottom: 675, left: -25),
          Padding(
            padding: const EdgeInsets.only(top: 250), // 폼 필드를 더 아래로 밀기
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30), // Horizontal padding
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start, // 위에서 시작하도록 설정
                crossAxisAlignment: CrossAxisAlignment.stretch, // Full width form fields
                children: [
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
                    validator: (value) => value == null ? '사용자 유형을 선택하세요' : null,
                  ),
                  const SizedBox(height: 30),

                  // 학부생을 선택한 경우에만 학과 선택 필드를 보여줌
                  Visibility(
                    visible: _selectedRole == '학부생', // 학부생일 때만 보이도록 설정
                    child: Column(
                      children: [
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
                          validator: (value) => value == null ? '학과를 선택하세요' : null,
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),

                  // 이름 TextField
                  buildCustomTextField('이름', TextInputType.text, false,
                          (value) => _name = value, '이름을 입력하세요'),
                  const SizedBox(height: 30),

                  // 학번 TextField
                  buildCustomTextField('학번', TextInputType.number, false,
                          (value) => _studentId = value, '학번을 입력하세요', FilteringTextInputFormatter.digitsOnly),

                  // 학부생일 때는 위에 학과 선택 필드가 보이기 때문에 더 넓은 간격 추가
                  SizedBox(height: _selectedRole == '관리자' ? 80 : 100),

                  // 회원가입 Button
                  Center(
                    child: LogUpButton(
                      onPressed: () => _submitForm(context),
                      text: '회원가입',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Rename the function to avoid conflict with the widget
  Widget buildCustomTextField(
      String labelText,
      TextInputType keyboardType,
      bool obscureText,
      FormFieldSetter<String>? onSaved,
      String? validatorMessage, [
        TextInputFormatter? inputFormatter,
      ]) {
    return InfoTextField(
      labelText: labelText,
      keyboardType: keyboardType,
      obscureText: obscureText,
      inputFormatters: inputFormatter != null ? [inputFormatter] : null,
      onSaved: onSaved,
      validator: (value) =>
      value == null || value.isEmpty ? validatorMessage : null,
    );
  }
}