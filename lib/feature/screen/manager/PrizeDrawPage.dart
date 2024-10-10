import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final FlexScheme usedScheme = FlexScheme.blueM3;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: const Size(390, 844),
      builder: (context, child) {
        return MaterialApp(
          home: PrizeDrawPage(), // 메인 페이지 설정
          theme: FlexThemeData.light(
            scheme: usedScheme,
            textTheme: TextTheme(
              titleLarge: TextStyle(
                fontFamily: "soonchunhyang",
              ),
              titleSmall: TextStyle(fontFamily: "Abel-Regular", fontSize: 32),
            ),
          ),
        );
      },
    );
  }
}

class PrizeDrawPage extends StatelessWidget {
  final List<Map<String, String>> students = [
    {'department': '의료IT공학과', 'name': '홍길동', 'id': '12341234', 'grade': '9'},
    {'department': '의료IT공학과', 'name': '홍길동', 'id': '12341234', 'grade': '9'},
    {'department': '의료IT공학과', 'name': '홍길동', 'id': '12341234', 'grade': '9'},
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            '상품 추첨하기',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              // 마이페이지 완성 후 메뉴바 누르면 마이페이지 오픈!
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 전체 공간을 균등하게 사용
        children: [
          // gif 박스
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xff26539C),
                width: 5.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(1),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            width: 300,
            height: 200,
            child: Image.asset(
              'assets/surprise.gif',
              fit: BoxFit.fill,
            ),
          ),

          // ListView.builder 부분
          Container(
            height: students.isEmpty ? 0 : (students.length > 3 ? 180 : students.length * 60), // 리스트의 줄 수에 따라 높이 조정
            child: students.isNotEmpty
                ? ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, i) {
                var student = students[i];
                return Card(
                  child: ListTile(
                    leading: Icon(CupertinoIcons.person_crop_circle),
                    trailing: IconButton(
                        onPressed: () {}, // 삭제 기능 만들 예정
                        icon: Icon(CupertinoIcons.delete)),
                    iconColor: Colors.black,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          student['department']!,
                          style: TextStyle(fontSize: 14), // 글씨 크기 조정
                        ),
                        Text(
                          student['name']!,
                          style: TextStyle(fontSize: 14), // 글씨 크기 조정
                        ),
                        Text(
                          student['id']!,
                          style: TextStyle(fontSize: 14), // 글씨 크기 조정
                        ),
                        Text(
                          student['grade']!,
                          style: TextStyle(fontSize: 14), // 글씨 크기 조정
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
                : Container(), // 리스트가 비어있을 때는 빈 컨테이너
          ),

          // 상품 추첨하기 버튼
          ElevatedButton(
            onPressed: () {
              // 상품 추첨 버튼 동작 추가
            },
            child: Text('상품 추첨하기'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff2C2C2C),
              foregroundColor: Colors.white,
              minimumSize: Size(200, 40),
              elevation: 6,
              shadowColor: Colors.grey.withOpacity(1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
