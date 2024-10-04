import 'package:flutter/material.dart';

class Startpage extends StatelessWidget {
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
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 180),
            const Text(
              '제 1회',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Text(
              'SW융합대학 학술제',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 170),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, '/signin'); // '/signin' 페이지로 이동
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // 버튼의 배경색을 검정색으로 설정
                    foregroundColor: Colors.white, // 버튼 텍스트 색상을 하얀색으로 설정
                    minimumSize: Size(200, 43), // 버튼 크기 설정
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // 버튼 모서리 둥글게
                    ),
                  ),
                  child: Text('로그인'),
                ),
                Padding(padding: EdgeInsets.all(7.0)),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, '/signup'); // '/signup' 페이지로 이동
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // 버튼의 배경색을 검정색으로 설정
                    foregroundColor: Colors.white, // 버튼 텍스트 색상을 하얀색으로 설정
                    minimumSize: Size(200, 43), // 버튼 크기 설정
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // 버튼 모서리 둥글게
                    ),
                  ),
                  child: Text('회원가입'),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
