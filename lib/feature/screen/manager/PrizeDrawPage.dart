import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FlexScheme usedScheme = FlexScheme.blueM3;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PrizeDrawPage(),
      theme: FlexThemeData.light(
        scheme: usedScheme,
        textTheme: const TextTheme(
            titleLarge: TextStyle(fontFamily: "soonchunhyang"),
            titleMedium: TextStyle(fontFamily: "soonchunhyang"),
            titleSmall: TextStyle(fontFamily: "Abel-Regular",fontSize: 32)),
      ),
    );
  }
}

class PrizeDrawPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('상품 추첨하기', style: Theme.of(context).textTheme.titleMedium)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // 마이페이지 완성 후 메뉴바 누르면 마이페이지 오픈!
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xff26539C), // 파란색 경계선
                  width: 5.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(1), // 그림자 색상 및 투명도
                    spreadRadius: 1, // 그림자가 퍼지는 반경
                    blurRadius: 6,   // 그림자 흐림 정도
                    offset: Offset(0, 3), // 그림자의 위치 (x, y 값)
                  ),
                ],
              ),
              width: 300, // 이미지 크기 조정
              height: 200,
              child: Image.asset(
                'assets/surprise.gif', // surprise.gif 파일 경로
                fit: BoxFit.fill,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // 상품 추첨 버튼 동작 추가
              },
              child: Text('상품 추첨하기'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff2C2C2C), // 피그마 버튼 색깔 기존은 Colors.black
                foregroundColor: Colors.white,
                minimumSize: Size(200, 43),
                elevation: 6, // 그림자 깊이
                shadowColor: Colors.grey.withOpacity(1), // 그림자 색상 및 투명도
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
