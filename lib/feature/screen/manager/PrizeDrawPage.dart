import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';

class PrizeDrawPage extends StatelessWidget {
  final List<Map<String, String>> students = [
    {'department': '의료IT공학과', 'name': '홍길동', 'id': '12341234', 'grade': '9'},
    {'department': '의료IT공학과', 'name': '홍길동', 'id': '12341234', 'grade': '9'},
    {'department': '의료IT공학과', 'name': '홍길동', 'id': '12341234', 'grade': '9'},
  ];

  Widget studentInfo(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontSize: 19.sp, // 폰트 크기 설정
        overflow: TextOverflow.ellipsis, // 넘치는 텍스트 생략 처리
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            '상품 추첨하기',
            style: Theme.of(context).textTheme.titleSmall,
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // gif 박스
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xff26539C),
                width: 5.0.w, // ScreenUtil 사용
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(1),
                  spreadRadius: 1.w,
                  blurRadius: 6.w,
                  offset: Offset(0, 3.h),
                ),
              ],
            ),
            width: 300.w,
            height: 200.h,
            child: Image.asset(
              'assets/surprise.gif',
              fit: BoxFit.fill,
            ),
          ),

          // 학생 리스트 표시 부분
          Container(
            height: students.isEmpty ? 0.h : (students.length > 3 ? 180.h : students.length * 60.h), // ScreenUtil 사용
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
                    title: SingleChildScrollView(
                      scrollDirection: Axis.horizontal, // 가로 스크롤 가능하게 설정
                      child: Row(
                        children: [
                          // 학과명
                          studentInfo(context, student['department']!),

                          SizedBox(width: 8.w), // 간격 추가

                          // 이름
                          studentInfo(context, student['name']!),

                          SizedBox(width: 8.w), // 간격 추가

                          // ID
                          studentInfo(context, student['id']!),

                          SizedBox(width: 8.w), // 간격 추가

                          // 학년
                          studentInfo(context, student['grade']!),
                        ],
                      ),
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
            child: Text('상품 추첨하기', style: TextStyle(fontSize: 16.sp)), // 반응형 텍스트 크기
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff2C2C2C),
              foregroundColor: Colors.white,
              minimumSize: Size(200.w, 40.h), // 반응형 버튼 크기
              elevation: 6,
              shadowColor: Colors.grey.withOpacity(1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r), // 반응형 모서리
              ),
            ),
          ),
        ],
      ),
    );
  }

}