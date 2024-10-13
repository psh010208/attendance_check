import 'package:flutter/material.dart';
import 'ParticipationData.dart';

void main() => runApp(ParticipationStatus());

class ParticipationStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            '참여 학생 현황',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          centerTitle: true,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_back),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.menu),
            )
          ],
          shape: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
        ),
        body: StudentDataTable(),
      ),
    );
  }
}

class StudentDataTable extends StatefulWidget {
  @override
  _DataTableExampleState createState() => _DataTableExampleState();
}

class _DataTableExampleState extends State<StudentDataTable> {
  List<ParticipationStudent> _data = List.from(p_students);
  bool _isSortAsc = true; // 정렬 기능
  String _searchStudentNum = ""; // 학번 검색 기능
  String _searchName = ""; // 이름 검색 기능

  @override
  Widget build(BuildContext context) {
// 화면 크기를 MediaQuery로 얻음
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: _buildUI(screenHeight, screenWidth),
    );
  }

  Widget _buildUI(double screenHeight, double screenWidth) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical, //스크롤
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: DataTable(
          columnSpacing: 10, //열 사이 간격
          columns: _createColumns(),
          rows: _createRows(screenHeight, screenWidth),
        ),
      ),
    );
  }

// 표 제목
  List<DataColumn> _createColumns() {
    return [
      DataColumn(
        label: Container(
          width: 140,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0), // 모서리 반경
            color: Color(0xffE2E6EB), // 배경색
          ),
          child: Row(children: [
            SizedBox(width: 6),
            Icon(Icons.arrow_drop_down, size: 25),
            SizedBox(width: 5),
            const Text("학과"),
          ]),
        ),
        onSort: (columnIndex, _) {  // 학과 정렬
          setState(() {
            if (_isSortAsc) {
              _data.sort(
                    (a, b) => a.dept.compareTo(b.dept),
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
      DataColumn(
        label: GestureDetector(
          onTap: () => _showSearchDialog('학번'), // 학번 검색 다이얼로그
          child: Container(
            width: 85,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0), // 모서리 반경
              color: Color(0xffE2E6EB), // 배경색
            ),
            child: Row(
              children: [
                SizedBox(width: 10),
                Icon(Icons.search, size: 17),
                SizedBox(width: 6),
                const Text("학번"),
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
              borderRadius: BorderRadius.circular(4.0), // 모서리 반경
              color: Color(0xffE2E6EB), // 배경색
            ),
            child: Row(
              children: [
                SizedBox(width: 8),
                Icon(Icons.search, size: 17),
                SizedBox(width: 6),
                const Text("이름"),
              ],
            ),
          ),
        ),
      ),
      DataColumn(
        label: Container(
          width: 95,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0), // 모서리 반경
            color: Color(0xffE2E6EB), // 배경색
          ),
          child: Row(
            children: [
              SizedBox(width: 4),
              Icon(Icons.arrow_drop_down, size: 20),
              SizedBox(width: 4),
              const Text("참여횟수"),
            ],
          ),
        ),
        onSort: (columnIndex, _) {  //참여횟수 정렬
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

  //검색 기능
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
    e.num.contains(_searchStudentNum) &&
        e.name.contains(_searchName))
        .map((e) {
      return DataRow(
        cells: [
          DataCell(Row(children: [
            Icon(Icons.person, size: 20), // 어디 넣어야 할 지 모르겠어서 일단 여기 넣음
            SizedBox(width: 17),
            Text(e.dept),
          ])),
          DataCell(Row(children: [
            SizedBox(width: 10),
            Text(e.num),
          ])),
          DataCell(Row(children: [
            SizedBox(width: 15),
            Text(e.name),
          ])),
          DataCell(Row(children: [
            SizedBox(width: 30),
            Text(e.count),
            IconButton(
              icon: Icon(Icons.keyboard_arrow_down),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text('이 버튼을 눌렀습니다!'),
                      actions: [
                        TextButton(
                          child: Text('닫기'),
                          onPressed: () {
                            Navigator.of(context).pop(); // 팝업 창 닫기
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
