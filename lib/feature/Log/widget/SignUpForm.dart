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
      await FirebaseFirestore.instance.collection('attendance_summary').doc('${_studentId!}-${_selectedRole!}').set({
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
                SizedBox(height: _getRoleBasedSpacing()),
                _buildRoleDropdown(),
                if (_selectedRole == '학부생') ...[
                  _buildDepartmentDropdown(),
                ],
                SizedBox(height: 20.h),
                    _buildStudentNameField(),
                SizedBox(height: 20.h),
                    _buildStudentIdField(),
                SizedBox(height: 20.h),
              _buildSignupButton(),
                //SizedBox(height: 5.h), // 회원가입 버튼과 아래 텍스트 버튼 사이 간격
                _buildSignInPrompt(context), // 로그인으로 전환하는 버튼 추가
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 역할 선택에 따라 간격 설정
  double _getRoleBasedSpacing() {
    return _selectedRole == '관리자' ? 100.h : 50.h; //학부생일 때 여백 크기 변경
  }
// 회원가입 버튼 빌드 함수
  Widget _buildSignupButton() {
    return Flexible(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w,vertical: 10.h), // 좌우 여백을 조정
        child: LogUpButton(
          onPressed: () => _submitForm(context),
          text: '회원가입',
        ),
      ),
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
        '메타버스&게임학과'
      ],
      onChanged: (value) {
        setState(() {
          _department = value;
        });
      },
    );
  }
  // 이름 입력 필드 빌드 함수
  Widget _buildStudentNameField() {
    return buildCustomTextField(
      '이름',
      TextInputType.text,
      false,
          (value) => _name = value,
    );
  }
  // 학번 입력 필드 빌드 함수
  Widget _buildStudentIdField() {
    return buildCustomTextField(
      '학번/사번',
      TextInputType.number,
      false,
          (value) => _studentId = value,
      // validator에 8자리 필수 입력 추가
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '학번/사번을 입력하세요';
        } else if (value.length != 8) {
          return '학번/사번은 8자리여야 합니다';
        }
        return null;
      },
    );
  }
  // 헤더 위젯 빌드 함수
  Widget _buildHeaderWidget() {
    return Flexible(
      child: Container(
        width: MediaQuery.of(context).size.width, // 원하는 너비 지정
        height: MediaQuery.of(context).size.height, // 원하는 높이 지정
        child: SoonCheckWidget(
          bottom: MediaQuery.of(context).size.height * -0.01, // 비례 조정
          left: MediaQuery.of(context).size.width * 0.09, // 원하는 SoonCheckWidget 추가
        ),
      ),
    );
  }
  // '이미 계쩡이 있으신가요?' 버튼을 빌드하는 함수
  Widget _buildSignInPrompt(BuildContext context) {
    return Flexible(
      child: TextButton(
        onPressed: () {
          // 로그인 폼으로 이동하도록 logPage의 isLogin을 false로 변경
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => logPage(isLogin: true)),
          );
        },
        child: Text(
          '이미 계정이 있으신가요? 로그인',
          style: TextStyle(
            fontSize: 15.sp, // 텍스트 크기 반응형으로 설정
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
  // Custom TextField widget to avoid conflicts
  Widget buildCustomTextField(String labelText, TextInputType keyboardType, bool obscureText, FormFieldSetter<String>? onSaved, {FormFieldValidator<String>? validator}) {
    return InfoTextField(
      labelText: labelText,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onSaved: onSaved,
      validator: validator, // validator 추가
    );
  }
}