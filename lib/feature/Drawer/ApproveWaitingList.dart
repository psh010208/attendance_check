import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'WaitingData.dart';
import 'package:attendance_check/feature/Drawer/drawerScreen.dart';
import 'package:attendance_check/feature/Drawer/model/infoModel.dart';

class ApproveWaitingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(310, 690), // 기본 디자인 사이즈 설정
      builder: (context, child) {
        return MaterialApp(
          home: Scaffold(
            body: WaitingStatus(),
          ),
        );
      },
    );
  }
}

class WaitingStatus extends StatefulWidget {
  @override
  _WaitingStatusState createState() => _WaitingStatusState();
}

class _WaitingStatusState extends State<WaitingStatus> {
  List<Waitinglist> _data = List.from(waitinglist);
  List<Waitinglist> _originalData = List.from(waitinglist); // 원본 데이터 저장(검색 기능 때문)
  bool _isSortAsc = true; // 정렬 기능(승인 여부에서 사용)
  String _searchStudentNum = ""; // 사번 검색 기능
  String _searchName = ""; // 이름 검색 기능

  @override
  Widget build(BuildContext context) {
    double screenHeight = 1.sh; // ScreenUtil에서 전체 높이 비율 사용
    double screenWidth = 1.sw; // ScreenUtil에서 전체 너비 비율 사용

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.h), // AppBar의 높이 설정
        child: AppBar(
          backgroundColor: Color(0xffF8FAFD),
          title: Text(
            '승인 대기 명단',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          centerTitle: true,
          elevation: 4,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              // 검색 기능 사용 후 뒤로가기 버튼 누르면 원래 데이터로 돌아가기
              setState(() {
                _data = List.from(_originalData);
                _searchStudentNum = "";
                _searchName = "";
              });
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
      ),
      endDrawer: drawerScreen(
        role: InfoModel.role!, // 역할 전달
        id: InfoModel.id!,     // ID 전달
      ),
      body: _buildUI(screenHeight, screenWidth),
    );
  }

  Widget _buildUI(double screenHeight, double screenWidth) {
    return RefreshIndicator(
      onRefresh: _refresh,
      backgroundColor: Color(0xffF8FAFD),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical, // 스크롤
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: DataTable(
            columnSpacing: 10.w, // 열 사이 간격
            columns: _createColumns(),
            rows: _createRows(screenHeight, screenWidth),
          ),
        ),
      ),
    );
  }

  // 새로고침 함수
  Future<void> _refresh() async {
    setState(() {
      // 새로고침 시 동작할 로직, 데이터를 다시 로드하거나 초기화할 수 있음
      _data = List.from(_originalData); // 예시: 원본 데이터를 다시 불러오기
    });
  }

  // 표 제목
  List<DataColumn> _createColumns() {
    return [
      DataColumn( //아이콘 자리(빈 column)
        label: Container(
          width: 30.w,
          height: 30.h,
          child: Row(
            children: [],
          ),
        ),
      ),
      DataColumn(
        label: GestureDetector(
          onTap: () => _showSearchDialog('사번'), // 학번 검색 다이얼로그
          child: Container(
            width: 85.w,
            height: 30.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
              color: Color(0xffE2E6EB),
            ),
            child: Row(
              children: [
                SizedBox(width: 10.w),
                Icon(Icons.search, size: 17.sp),
                SizedBox(width: 6.w),
                Text("사번", style: TextStyle(fontSize: 15.sp)),
              ],
            ),
          ),
        ),
      ),
      DataColumn(
        label: GestureDetector(
          onTap: () => _showSearchDialog('이름'), // 이름 검색 다이얼로그
          child: Container(
            width: 75.w,
            height: 30.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
              color: Color(0xffE2E6EB),
            ),
            child: Row(
              children: [
                SizedBox(width: 8.w),
                Icon(Icons.search, size: 17.sp),
                SizedBox(width: 6.w),
                Text("이름", style: TextStyle(fontSize: 15.sp)),
              ],
            ),
          ),
        ),
      ),
      DataColumn(
        label: Container(
            width: 98.w,
            height: 30.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
              color: Color(0xffE2E6EB),
            ),
            child: Row(
              children: [
                SizedBox(width: 3.w),
                Icon(Icons.arrow_drop_down, size: 25.sp),
                Text("승인 여부", style: TextStyle(fontSize: 15.sp)),
              ],
            ),
          ),
        onSort: (columnIndex, _) {  //승인 여부 정렬(문자열 Y랑 N으로)
          setState(() {
            if (_isSortAsc) {
              _data.sort(
                    (a, b) => a.approved.toString().compareTo(b.approved.toString()),
              );
            } else {
              _data.sort(
                    (a, b) => b.approved.toString().compareTo(a.approved.toString()),
              );
            }
            _isSortAsc = !_isSortAsc;
          });
        },
        ),
      DataColumn( //승인 버튼 자리(빈 column)
        label: Container(
          width: 20.w,
          height: 30.h,
          child: Row(
            children: [],
          ),
        ),
      ),
    ];
  }

  // 사번, 이름 검색 기능
  void _showSearchDialog(String title) {
    String searchQuery = "";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$title 검색'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            decoration: InputDecoration(hintText: '검색어를 입력하세요'),
          ),
          actions: [
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('확인'),
              onPressed: () {
                setState(() {
                  if (title == '사번') {
                    _searchStudentNum = searchQuery; // 사번 검색 업데이트
                  } else if (title == '이름') {
                    _searchName = searchQuery; // 이름 검색 업데이트
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // 표 내용
  List<DataRow> _createRows(double screenHeight, double screenWidth) {
    return _data
        .where((e) =>
            e.num.contains(_searchStudentNum) && e.name.contains(_searchName))
        .map((e) {
      return DataRow(
        cells: [
          DataCell(Row(children: [  //아이콘만
            Icon(Icons.person, size: 17.sp),
          ])),
          DataCell(Row(children: [
            SizedBox(width: 10.w),
            Text(e.num, style: TextStyle(fontSize: 15.sp)),
          ])),
          DataCell(Row(children: [
            SizedBox(width: 15.w),
            Text(e.name, style: TextStyle(fontSize: 15.sp)),
          ])),
          DataCell(Row(children: [  //승인 여부를 문자열 Y와 N으로 출력
            SizedBox(width: 40.w),
            Text(e.approved ? 'Y' : 'N', style: TextStyle(fontSize: 15.sp)),
          ])),
          DataCell(Row(children: [  //승인 버튼
            IconButton(
              icon: Icon(Icons.add_circle, color: Color(0xff26539C)),
              onPressed: () =>
                  _showApprovalDialog(e.num), // 승인 버튼 클릭 시 다이얼로그 표시
            ),
          ])),
        ],
      );
    }).toList();
  }

  // 승인 다이얼로그 표시
  void _showApprovalDialog(String studentNum) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //backgroundColor: Color(0xff26539C),
          contentPadding: EdgeInsets.all(20),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8, // 화면의 80% 너비
            child: Text(
              "관리자로 승인하시겠습니까?",
              style: TextStyle(fontSize: 18.sp, color: Colors.black),
            ),
          ),
          actions: [
            TextButton(
              child: Text("아니요", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.sp, color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton( //"예"버튼 클릭하면 승인 처리(WaitingData.dart에 approved를 true로 바꿈)
              child: Text("예", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.sp, color: Colors.black)),
              onPressed: () {
                setState(() {
                  // 승인 처리 로직
                  _approveStudent(studentNum);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  // 학생 승인 처리(WaitingData.dart에 approved를 true로 바꿈)
  void _approveStudent(String studentNum) {
    // 승인 대기 목록에서 학생을 찾고 상태를 변경 후 목록에서 제거
    _data.removeWhere((student) {
      if (student.num == studentNum) {
        student.approved = true; // 승인 상태 변경
        return true; // 목록에서 제거
      }
      return false;
    });
  }
}
