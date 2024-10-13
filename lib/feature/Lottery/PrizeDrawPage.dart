import 'package:attendance_check/feature/Drawer/model/infoModel.dart';
import 'package:attendance_check/feature/Home/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'LotteryData.dart';
import 'widget/button/deleteButton.dart';
import 'widget/button/dialogOkButton.dart';
import 'widget/button/dialogRepickButton.dart';
import 'widget/button/pickButton.dart'; // PickButton import 추가
import 'package:attendance_check/feature/Drawer/drawerScreen.dart';
import 'package:attendance_check/feature/Drawer/model/infoModel.dart';

class PrizeDrawPage extends StatefulWidget {
  // 사용자 정보 받기
  final String role;
  final String id;
  //final String current
  PrizeDrawPage(
      {required this.role,
        required this.id,
      });

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
          DataCell(
            Row(
              children: [
                Text(e.count),
                SizedBox(width: 10.w), // 아이콘과 텍스트 사이 간격
                DeleteButton( // DeleteButton 사용
                  onPressed: () {
                    setState(() {
                      data.remove(e); // 해당 학생 삭제
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();
  }

  // 상품 추첨 로직 (수정됨)
  Future<void> drawLottery() async {
    setState(() {
      isLoading = true; // 로딩 시작
    });

    await Future.delayed(Duration(milliseconds: 3800)); // 초 대기

    // 임시로 당첨자를 추첨 (데모 목적)
    LotteryStudent winner = data[0]; // 첫 번째 학생을 당첨자로 설정 (임의)

    // 알림 창 표시
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('추첨 완료'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 당첨자 정보
              Text('${winner.dept}의 ${winner.name}님이 당첨되었습니다!'),
              SizedBox(height: 16.h), // 여백 추가
            ],
          ),
          actions: [
            DialogOkButton(onPressed: () {
              Navigator.of(context).pop(); // 다이얼로그 닫기
            }),
            DialogRepickButton(onPressed: () {
              Navigator.of(context).pop(); // 다이얼로그 닫기
              drawLottery(); // 재추첨 실행
            }),
          ],
        );
      },
    );

    setState(() {
      isLoading = false; // 로딩 끝
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        iconTheme: IconThemeData(
          color: Colors.black, // AppBar 아이콘 색상 검정으로 설정
        ),
        title: Text('상품 추첨하기', style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
        elevation: 4,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen(role: InfoModel.role!,id: InfoModel.id!,)), // 회원가입 페이지로 이동
            );
          },
        ),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  // 드로어 열기
                  Scaffold.of(context).openEndDrawer();
                },
                color: Colors.black, // 개별 아이콘 색상 명시적으로 설정
              );
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
      endDrawer: drawerScreen(
        role: InfoModel.role!, // 역할 전달
        id: InfoModel.id!,     // ID 전달
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
          PickButton( // PickButton으로 변경
            isLoading: isLoading,
            onPressed: () async {
              await drawLottery(); // 추첨 로직 호출
            },
          ),
        ],
      ),
    );
  }
}
