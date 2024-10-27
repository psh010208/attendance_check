import 'package:attendance_check/feature/Home/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:attendance_check/feature/Log/widget/LogInButton.dart'; // LogInButton 임포트
import 'package:attendance_check/feature/Log/ViewModel/logViewModel.dart'; // LogViewModel 임포트
import 'package:attendance_check/feature/Log/logPage.dart'; // LogPage 임포트

import '../../Home/widget/SoonCheck.dart';
import '../Model/logModel.dart';
import 'CustomDropdownFormField.dart';
import 'CustomTextFormField.dart';

class SignInForm extends StatefulWidget {
  final String? initialRole; // 초기 역할
  final String? initialStudentId; // 초기 학번

  SignInForm({this.initialRole, this.initialStudentId}); // 생성자

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final LogViewModel logViewModel = LogViewModel();
  String? _selectedRole = '학부생';
  String? _department = '의료IT공학과';
  String? _studentId;

  @override
  void initState() {
    super.initState();
    // 초기값 설정
    _selectedRole = widget.initialRole ?? '학부생'; // 초기 역할 설정
    _studentId = widget.initialStudentId ?? '20225524'; // 초기 학번 설정
  }
  Future<void> _submitForm(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    // Firestore에서 학번, 역할, 학과를 통해 로그인 검증
    bool isLoggedIn = await logViewModel.logIn(_studentId!, _selectedRole!, _department!);

    if (isLoggedIn) {
      _navigateToDrawerScreen(); // 홈 화면으로 이동
    } else {
      _handleLoginFailure(context); // 실패 처리
    }
  }


  void _navigateToDrawerScreen() {
    // InfoModel에 정보 저장
    print(_selectedRole);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          role: _selectedRole!, // 홈 화면으로 역할 전달
          id: _studentId!,      // 홈 화면으로 ID 전달
        ),
      ),
          (Route<dynamic> route) => false,
    );
  }


  // 로그인 실패 시 에러 처리 함수
  Future<void> _handleLoginFailure(BuildContext context) async {
    LogModel? user = await logViewModel.getUser(_studentId!);

    if (user != null && user.role == '관리자' && !user.isApproved) {
      _showErrorDialog(context, '로그인 실패', '관리자 승인이 필요합니다. 승인이 완료될 때까지 기다려 주세요.');
    } else {
      _showErrorDialog(context, '로그인 실패', '학번 또는 역할이 올바르지 않습니다.');
    }
  }

  // 에러 메시지 다이얼로그를 표시하는 함수
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      resizeToAvoidBottomInset : false,
      bottomSheet: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.onInverseSurface,
              Theme.of(context).primaryColorLight,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.3,0.9],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeaderWidget(),
                SizedBox(height: _selectedRole == '관리자' ? 100.h : 50.h),  //학부생일 때 여백 크기 수정
                _buildRoleDropdown(),
                if (_selectedRole == '학부생') ...[
                  SizedBox(height: 20.h),
                  _buildDepartmentDropdown(),
                ],
                SizedBox(height: 20.h),
                _buildStudentIdField(),
                SizedBox(height: 30.h),
                _buildLoginButton(),
                //SizedBox(height: 10.h), // 로그인 버튼과 아래 텍스트 버튼 사이 간격
                _buildSignUpPrompt(context), // 회원가입으로 전환하는 버튼 추가
                SizedBox(height: 30.h), //크기 수정
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 헤더 위젯 빌드 함수
  Widget _buildHeaderWidget() {
    return Flexible(
        child: SoonCheckWidget(bottom: -5.h, left: 0.w)
    );
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
        '메타버스&게임학과',
      ],
      onChanged: (value) {
        setState(() {
          _department = value;
        });
      },
    );
  }

  // 학번 입력 필드 빌드 함수
  Widget _buildStudentIdField() {
    return buildCustomTextField(
      '학번/사번',
      TextInputType.number,
      false,
          (value) => _studentId = value,
    );
  }

  // 로그인 버튼 빌드 함수
  Widget _buildLoginButton() {
    return Flexible(
      child: LogInButton(
        onPressed: () => _submitForm(context),
        text: '로그인',
      ),
    );
  }

  // '계정이 없으신가요?' 버튼을 빌드하는 함수
  Widget _buildSignUpPrompt(BuildContext context) {
    return TextButton(
      onPressed: () {
        // 회원가입 폼으로 이동하도록 logPage의 isLogin을 false로 변경
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => logPage(isLogin: false)),
        );
      },
      child: Text(
        '계정이 없으신가요? 회원가입',
        style: TextStyle(
          fontSize: 15.sp, // 텍스트 크기 반응형으로 설정
          color: Theme.of(context).colorScheme.primary,
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