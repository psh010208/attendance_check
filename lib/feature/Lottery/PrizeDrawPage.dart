import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'LotteryData.dart';

class PrizeDrawPage extends StatefulWidget {
  @override
  _PrizeDrawPageState createState() => _PrizeDrawPageState();
}

class _PrizeDrawPageState extends State<PrizeDrawPage> {
  List<LotteryStudent> data = List.from(l_students); // 진짜 리스트
  List<LotteryStudent> data_empty = List.from(l_students_empty); // 비어있는 리스트
  bool isLoading = false; // 로딩 상태 관리

  // 표 제목
  List<DataColumn> createColumns() {
    return [
      DataColumn(
        label: Text(
          "학과",
          style: TextStyle(
            fontSize: 19.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      DataColumn(
        label: Text(
          "학번",
          style: TextStyle(
            fontSize: 19.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      DataColumn(
        label: Text(
          "이름",
          style: TextStyle(
            fontSize: 19.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      DataColumn(
        label: Text(
          "참여 횟수",
          style: TextStyle(
            fontSize: 19.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ];
  }

  // 표 내용
  List<DataRow> createRows() {
    List<LotteryStudent> displayData = data.isNotEmpty ? data : data_empty;

    return displayData.map((e) {
      return DataRow(
        cells: [
          DataCell(
            Row(
              children: [
                Icon(CupertinoIcons.person_crop_circle), // 아이콘 추가
                SizedBox(width: 8.w), // 아이콘과 텍스트 사이 간격
                Text(e.dept), // 학과명 텍스트
              ],
            ),
          ),
          DataCell(Text(e.num)),
          DataCell(Text(e.name)),
          DataCell(Text(e.count)),
        ],
      );
    }).toList();
  }

  // 상품 추첨 로직 (임시)
  Future<void> drawLottery() async {
    await Future.delayed(Duration(milliseconds: 3800)); // 초 대기

    // 알림 창 표시
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('추첨 완료'),
          content: Text('상품 추첨이 완료되었습니다!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('상품 추첨하기', style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
        // iOS에서 제목 중앙 정렬
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
                width: 5.w,
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
            child: isLoading
                ? Image.asset( // isLoading이 true일 경우 gif 활성화
              'assets/surprise.gif',
              fit: BoxFit.fill,
            )
                : Image.asset( // isLoading이 false일 경우 png 활성화
              'assets/surprise.png',
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
            onPressed: isLoading
                ? null // isLoading이 true일 경우 버튼을 비활성화
                : () async {
              setState(() {
                isLoading = true; // 로딩 시작
              });
              await drawLottery(); // 추첨 로직 호출
              setState(() {
                isLoading = false; // 로딩 끝
              });
            },
            child: isLoading
                ? CircularProgressIndicator(
              color: Colors.white,
            ) // 로딩 중에는 로딩 버튼으로 바뀜
                : Text('상품 추첨하기', style: TextStyle(fontSize: 16.sp)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff2C2C2C),
              foregroundColor: Colors.white,
              minimumSize: Size(200.w, 40.h),
              elevation: 6,
              shadowColor: Colors.grey.withOpacity(1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
