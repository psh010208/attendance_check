import 'package:flutter/material.dart';
import 'package:flutter/services.dart';  // inputFormatters를 사용하기 위한 import

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입 페이지'),
      ),
      body: SingleChildScrollView(  // 스크롤 가능하게 설정
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                        // 역할 선택 로직
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
                      items: [
                        '의료IT공학과',
                        '컴퓨터소프트웨어공학과',
                        '정보보호학과',
                        'AI빅데이터학과',
                        '사물인터넷학과',
                        '메타버스&게임학과'
                      ].map((value) => DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      )).toList(),
                      onChanged: (value) {
                        // 학과 선택 로직
                      },
                      validator: (value) =>
                      value == null ? '학과를 선택하세요' : null,
                    ),
                    const SizedBox(height: 20),

                    // 이름 입력 필드 (한국어만 입력 가능)
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: '이름',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? '이름을 입력하세요'
                          : null,
                      keyboardType: TextInputType.text,

                    ),
                    const SizedBox(height: 20),

                    // 학번 입력 필드 (숫자만 입력 가능)
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: '학번',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? '학번을 입력하세요'
                          : null,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,  // 숫자만 입력 가능
                      ],
                    ),
                    const SizedBox(height: 20),

                    // 전화번호 입력 필드 (숫자만 입력 가능, 선택 사항)
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: '전화번호 (선택 사항)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,  // 숫자만 입력 가능
                      ],
                    ),
                    const SizedBox(height: 20),

                    // 비밀번호 입력 필드 (숫자만 입력 가능)
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: '비밀번호',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true, // 비밀번호 가리기
                      validator: (value) => value == null || value.isEmpty
                          ? '비밀번호를 입력하세요'
                          : null,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,  // 숫자만 입력 가능
                      ],
                    ),
                    const SizedBox(height: 40),

                    // 회원가입 버튼
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // 회원가입 처리 로직
                        }
                      },
                      child: Text('회원가입'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50), // 버튼 크기
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),  // 하단 여백 추가
            ],
          ),
        ),
      ),
    );
  }
}
