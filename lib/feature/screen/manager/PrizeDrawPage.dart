import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'LotteryData.dart';

class PrizeDrawPage extends StatelessWidget {
  // final List<Map<String, String>> students = [
  //   {'department': '의료IT공학과', 'name': '홍길동', 'id': '12341234', 'grade': '9'},
  //   {'department': '의료IT공학과', 'name': '홍길동', 'id': '12341234', 'grade': '9'},
  //   {'department': '의료IT공학과', 'name': '홍길동', 'id': '12341234', 'grade': '9'},
  // ];
  //
  // // 텍스트 정보 표시 위젯
  // Widget studentInfo(BuildContext context, String text) {
  //   return Text(
  //     text,
  //     style: Theme.of(context).textTheme.titleSmall?.copyWith(
  //       fontSize: 19.sp, // 폰트 크기 설정
  //       overflow: TextOverflow.ellipsis, // 넘치는 텍스트 생략 처리
  //     ),
  //   );
  // }

  List<LotteryStudent> data = List.from(l_students); // 진짜 리스트
  List<LotteryStudent> data_empty = List.from(l_students_empty); // 비어있는 리스트

  //표 제목
  List<DataColumn> createColumns() {
    return [
      DataColumn(
        label: Text(
          "학과",
          style: TextStyle(
            fontSize: 19.sp, // 내용과 동일한 크기
            fontWeight: FontWeight.bold, // 굵기만 설정
          ),
        ),
      ),
      DataColumn(
        label: Text(
          "학번",
          style: TextStyle(
            fontSize: 19.sp, // 내용과 동일한 크기
            fontWeight: FontWeight.bold, // 굵기만 설정
          ),
        ),
      ),
      DataColumn(
        label: Text(
          "이름",
          style: TextStyle(
            fontSize: 19.sp, // 내용과 동일한 크기
            fontWeight: FontWeight.bold, // 굵기만 설정
          ),
        ),
      ),
      DataColumn(
        label: Text(
          "참여 횟수",
          style: TextStyle(
            fontSize: 19.sp, // 내용과 동일한 크기
            fontWeight: FontWeight.bold, // 굵기만 설정
          ),
        ),
      ),
    ];
  }

  // 표 내용
  List<DataRow> createRows() {
    // data가 비어있지 않으면 data를 사용하고, 비어있으면 data_empty를 사용
    List<LotteryStudent> displayData = data.isNotEmpty ? data : data_empty;

    return displayData.map((e) {
      return DataRow(
        cells: [
          DataCell(
            Text(
              e.dept,
            ),
          ),
          DataCell(
            Text(
              e.num,
            ),
          ),
          DataCell(
            Text(
              e.name,
            ),
          ),
          DataCell(
            Text(
              e.count,
            ),
          ),
        ],
      );
    }).toList();
  }

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
        elevation: 4,
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
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1.w,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // gif 박스
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xff26539C),
                width: 5.w, // ScreenUtil 사용
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
            height: 170.h,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                      columns: createColumns(),
                      rows: createRows(),
                  ),
                ),
              ),
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