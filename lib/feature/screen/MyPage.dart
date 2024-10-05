import 'package:flutter/material.dart';

class Mypage extends StatelessWidget {
  const Mypage({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center( // Center 위젯으로 변경
              child: Text(
                '내 정보',
                style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Color(0xff0d47a1),
            ),
          ),
          // 첫 번째 ListTile 정의
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text(
              '학생 이름', // 여기에 학생 이름을 추가하세요
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            // subtitle: Text('${student.department} - ${student.name}'), // 학과와 이름 추가
            subtitle: Text(
              '00학과 000',
              style: TextStyle(
                color: Colors.black,
                fontSize: 10,
              ),
            ),
          ),
          // 두 번째 ListTile 정의
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text(
              '학생 이름', // 여기에 학생 이름을 추가하세요
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            // subtitle: Text('${student.department} - ${student.name}'), // 학과와 이름 추가
            subtitle: Text(
              '00학과 000',
              style: TextStyle(
                color: Colors.black,
                fontSize: 10,
              ),
            ),
          ),
          // '밀어서 닫기' 텍스트 추가
          Padding(
            padding: const EdgeInsets.only(top: 300.0), // 원하는 간격 조정
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // Drawer 닫기
              },
              child: Text(
                '밀어서 닫기',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
