import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'model/model.dart';
import 'ParticipationData.dart';
import 'package:attendance_check/feature/Drawer/drawerScreen.dart';
import 'package:attendance_check/feature/Home/homeScreen.dart';

class ParticipationStatus extends StatefulWidget {
  final String role;
  final String id;

  ParticipationStatus({required this.role, required this.id});

  @override
  _StudentDataTableState createState() => _StudentDataTableState();
}

class _StudentDataTableState extends State<ParticipationStatus> {
  List<ParticipationStudent> _data = List.from(p_students);
  List<ParticipationStudent> _originalData = List.from(p_students); // 원본 데이터 저장
  bool _isSortAsc = true; // 정렬 기능
  String _searchStudentNum = ""; // 학번 검색 기능
  String _searchName = ""; // 이름 검색 기능

  @override
  Widget build(BuildContext context) {
    // 화면 크기를 MediaQuery로 얻음
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50.h, // 반응형으로 상단바의 높이를 설정
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('참여 학생 현황', style: Theme.of(context).textTheme.titleMedium),
        centerTitle: true,
        elevation: 1,
        leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).colorScheme.onSurface),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomeScreen(role: widget.role, id: widget.id)));
            }),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                color: Theme.of(context).colorScheme.onSurface,
              );
            },
          ),
        ],
      ),
      endDrawer: DrawerScreen(role: widget.role, id: widget.id),
      body: _buildUI(screenHeight, screenWidth),
    );
  }

  Widget _buildUI(double screenHeight, double screenWidth) {
    return RefreshIndicator(
      //아래로 당기면 새로고침
      onRefresh: _refresh,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical, //스크롤
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: DataTable(
            columnSpacing: 1, //열 사이 간격
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
      DataColumn(
        //아이콘용 빈 column
        label: Container(
          width: 20.w,
          height: 30.h,
          child: Row(
            children: [],
          ),
        ),
      ),
      DataColumn(
        label: Container(
          width: 145.w,
          height: 30.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Color(0xffE2E6EB),
          ),
          child: Row(children: [
            SizedBox(width: 10.w),
            Icon(Icons.arrow_drop_down, size: 25.w),
            SizedBox(width: 5.w),
            Text("학과", style: TextStyle(fontSize: 15.sp)),
          ]),
        ),
        onSort: (columnIndex, _) {
          // 학과 정렬
          setState(() {
            if (_isSortAsc) {
              _data.sort(
                (a, b) => a.dept.compareTo(b.dept),
              );
            } else {
              _data.sort(
                (a, b) => b.dept.compareTo(a.dept),
              );
            }
            _isSortAsc = !_isSortAsc;
          });
        },
      ),
      DataColumn(
        label: GestureDetector(
          onTap: () => _showSearchDialog('학번'), // 학번 검색 다이얼로그
          child: Container(
            width: 80.w,
            height: 30.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Color(0xffE2E6EB),
            ),
            child: Row(
              children: [
                SizedBox(width: 10.w),
                Icon(Icons.search, size: 17.sp),
                SizedBox(width: 6.w),
                Text("학번", style: TextStyle(fontSize: 15.sp)),
              ],
            ),
          ),
        ),
      ),
      DataColumn(
        label: GestureDetector(
          onTap: () => _showSearchDialog('이름'), // 이름 검색 다이얼로그
          child: Container(
            width: 70.w,
            height: 30.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Color(0xffE2E6EB),
            ),
            child: Row(
              children: [
                SizedBox(width: 8.w),
                Icon(Icons.search, size: 17.w),
                SizedBox(width: 6.w),
                Text("이름", style: TextStyle(fontSize: 15.sp)),
              ],
            ),
          ),
        ),
      ),
      DataColumn(
        label: Container(
          width: 95.w,
          height: 30.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Color(0xffE2E6EB),
          ),
          child: Row(
            children: [
              SizedBox(width: 2.w),
              Icon(Icons.arrow_drop_down, size: 25.w),
              SizedBox(width: 4.w),
              Text("참여횟수", style: TextStyle(fontSize: 15.sp)),
            ],
          ),
        ),
        onSort: (columnIndex, _) {
          //참여횟수 정렬
          setState(() {
            if (_isSortAsc) {
              _data.sort(
                (a, b) => a.count.compareTo(b.count),
              );
            } else {
              _data.sort(
                (a, b) => b.count.compareTo(a.count),
              );
            }
            _isSortAsc = !_isSortAsc;
          });
        },
      ),
    ];
  }

  //학번, 이름 검색 기능
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
                  if (title == '학번') {
                    _searchStudentNum = searchQuery; // 학번 검색 업데이트
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

// 표 내용(ParticipationData.dart에서 불러옴)
  List<DataRow> _createRows(double screenHeight, double screenWidth) {
    // 필터링 추가
    return _data
        .where((e) =>
            e.num.contains(_searchStudentNum) && e.name.contains(_searchName))
        .map((e) {
      return DataRow(
        cells: [
          DataCell(Row(children: [
            //아이콘만
            Icon(Icons.person, size: 17.w),
          ])),
          DataCell(Row(children: [
            SizedBox(width: 5.w),
            Text(e.dept, style: TextStyle(fontSize: 13.sp)),
          ])),
          DataCell(Row(children: [
            SizedBox(width: 10.w),
            Text(e.num, style: TextStyle(fontSize: 13.sp)),
          ])),
          DataCell(Row(children: [
            SizedBox(width: 15.w),
            Text(e.name, style: TextStyle(fontSize: 13.sp)),
          ])),
          DataCell(Row(children: [
            SizedBox(width: 30.w),
            Text(e.count, style: TextStyle(fontSize: 13.sp)),
            IconButton(
              icon: Icon(Icons.keyboard_arrow_down),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      //일정별 정확한 입퇴실 시간 보여줌
                      backgroundColor: Color(0xff26539C),
                      content: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('일정 1',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              Divider(),
                              Text('입실   ' + e.time,
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(height: 5.h),
                              Text('퇴실   2024 / 10 / 9 / 16:30',
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(height: 10.h),
                              Text('일정 2',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              Divider(),
                              Text('입실   ' + e.time,
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(height: 5.h),
                              Text('퇴실   2024 / 10 / 9 / 16:30',
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(height: 10.h),
                              Text('일정 3',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              Divider(),
                              Text('입실   ' + e.time,
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(height: 5.h),
                              Text('퇴실   2024 / 10 / 9 / 16:30',
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(height: 10.h),
                              Text('일정 4',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              Divider(),
                              Text('입실   ' + e.time,
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(height: 5.h),
                              Text('퇴실   2024 / 10 / 9 / 16:30',
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(height: 10.h),
                              Text('일정 5',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              Divider(),
                              Text('입실   ' + e.time,
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(height: 5.h),
                              Text('퇴실   2024 / 10 / 9 / 16:30',
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(height: 10.h),
                              Text('일정 6',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              Divider(),
                              Text('입실   ' + e.time,
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(height: 5.h),
                              Text('퇴실   2024 / 10 / 9 / 16:30',
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(height: 10.h),
                              Text('일정 7',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              Divider(),
                              Text('입실   ' + e.time,
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(height: 5.h),
                              Text('퇴실   2024 / 10 / 9 / 16:30',
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(height: 10.h),
                              Text('일정 8',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              Divider(),
                              Text('입실   ' + e.time,
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(height: 5.h),
                              Text('퇴실   2024 / 10 / 9 / 16:30',
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(height: 10.h),
                              Text('일정 9',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              Divider(),
                              Text('입실   ' + e.time,
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(height: 5.h),
                              Text('퇴실   2024 / 10 / 9 / 16:30',
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(height: 10.h),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          child:
                              Text('닫기', style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ])),
        ],
      );
    }).toList();
  }
}
