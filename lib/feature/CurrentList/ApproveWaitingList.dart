import 'package:flutter/material.dart';
import 'WaitingData.dart';
import 'package:attendance_check/feature/Drawer/drawerScreen.dart';
import 'package:attendance_check/feature/Home/homeScreen.dart';

class ApproveWaitingList extends StatelessWidget {
  final String role;
  final String id;
  ApproveWaitingList(this.role, this.id);

  @override
  Widget build(BuildContext context) {
    print("role: $role, id: $id");

    return MaterialApp(
          home: Scaffold(
            body: WaitingStatus(role: role, id: id), // role과 id 전달
          ),
    );
  }
}

class WaitingStatus extends StatefulWidget {
  final String role;
  final String id;

  WaitingStatus({required this.role, required this.id});

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
    // 화면 크기를 MediaQuery로 얻음
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;


    print("Role in WaitingStatus: ${widget.role}, ID: ${widget.id}"); // 전달된 값 확인

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45), // AppBar의 높이 설정
        child: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.surface,
          ),
          title: Text(
            '승인 대기 명단',
            style: Theme.of(context).textTheme.titleMedium,
          ),
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
          shape: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
        ),
      ),
      endDrawer: DrawerScreen(role: widget.role, id: widget.id),
      body: _buildUI(screenHeight, screenWidth),
    );
  }

  Widget _buildUI(double screenHeight, double screenWidth)
  {
    return RefreshIndicator(
      onRefresh: _refresh,
      backgroundColor: Color(0xffF8FAFD),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical, // 스크롤
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: DataTable(
            columnSpacing: 10, // 열 사이 간격
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
          width: 30,
          height: 30,
          child: Row(
            children: [],
          ),
        ),
      ),
      DataColumn(
        label: GestureDetector(
          onTap: () => _showSearchDialog('사번'), // 학번 검색 다이얼로그
          child: Container(
            width: 85,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Color(0xffE2E6EB),
            ),
            child: Row(
              children: [
                SizedBox(width: 10),
                Icon(Icons.search, size: 17),
                SizedBox(width: 6),
                Text("사번", style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ),
      ),
      DataColumn(
        label: GestureDetector(
          onTap: () => _showSearchDialog('이름'), // 이름 검색 다이얼로그
          child: Container(
            width: 75,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Color(0xffE2E6EB),
            ),
            child: Row(
              children: [
                SizedBox(width: 8),
                Icon(Icons.search, size: 17),
                SizedBox(width: 6),
                Text("이름", style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ),
      ),
      DataColumn(
        label: Container(
          width: 98,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Color(0xffE2E6EB),
          ),
          child: Row(
            children: [
              SizedBox(width: 3),
              Icon(Icons.arrow_drop_down, size: 25),
              Text("승인 여부", style: TextStyle(fontSize: 15)),
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
          width: 20,
          height: 30,
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
            Icon(Icons.person, size: 17),
          ])),
          DataCell(Row(children: [
            SizedBox(width: 10),
            Text(e.num, style: TextStyle(fontSize: 15)),
          ])),
          DataCell(Row(children: [
            SizedBox(width: 15),
            Text(e.name, style: TextStyle(fontSize: 15)),
          ])),
          DataCell(Row(children: [  //승인 여부를 문자열 Y와 N으로 출력
            SizedBox(width: 40),
            Text(e.approved ? 'Y' : 'N', style: TextStyle(fontSize: 15)),
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
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
          actions: [
            TextButton(
              child: Text("아니요", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton( //"예"버튼 클릭하면 승인 처리(WaitingData.dart에 approved를 true로 바꿈)
              child: Text("예", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black)),
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
