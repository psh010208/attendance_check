import 'package:flutter/material.dart';
import 'LotteryData.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            '추첨 현황',
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
        body: LotteryDataTable(), //body 영역 클래스로 선언
      ),
    );
  }
}

class LotteryDataTable extends StatefulWidget {
  @override
  _DataTableExampleState createState() => _DataTableExampleState();
}

class _DataTableExampleState extends State<LotteryDataTable> {
  List<LotteryStudent> _data = List.from(l_students);
  bool _isSortAsc = true; //정렬 기능

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: SizedBox.expand(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical, //스크롤
          child: FittedBox(
            fit: BoxFit.contain,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: DataTable(
                columnSpacing: 5,  //열 사이 간격
                columns: _createColumns(),
                rows: _createRows(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //표 제목
  List<DataColumn> _createColumns() {
    return [
      DataColumn(
          label: Container(
            width: 115,
            height: 30,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0), // 모서리 반경
                color: Colors.grey // 배경색
            ),
            child: Row(
              children: [
                SizedBox(width: 6),
                Icon(Icons.arrow_drop_down, size: 25),
                SizedBox(width: 5),
                const Text(
                  "학과",
                  //textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          onSort: (columnIndex, _) {  //학과 정렬
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
          }),
      DataColumn(
        label: Container(
          width: 85,
          height: 30,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4.0), // 모서리 반경
              color: Colors.grey // 배경색
          ),
          child: Row(
            children: [
              SizedBox(width: 6),
              Icon(Icons.search, size: 17),
              SizedBox(width: 6),
              const Text(
                "학번",
                //textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      DataColumn(
        label: Container(
          width: 75,
          height: 30,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4.0), // 모서리 반경
              color: Colors.grey // 배경색
          ),
          child: Row(
            children: [
              SizedBox(width: 6),
              Icon(Icons.search, size: 17),
              SizedBox(width: 6),
              const Text(
                "이름",
                //textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      DataColumn(
          label: Container(
            width: 95,
            height: 30,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0), // 모서리 반경
                color: Colors.grey // 배경색
            ),
            child: Row(
              children: [
                SizedBox(width: 4),
                Icon(Icons.arrow_drop_down, size: 25),
                SizedBox(width: 4),
                const Text(
                  "참여횟수",
                  //textAlign: TextAlign.center,
                ),
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
          }),
    ];
  }

  //표 내용(LotteryData.dart에서 불러옴)
  List<DataRow> _createRows() {
    return _data.map((e) {
      return DataRow(
        cells: [
          DataCell(Row(children: [
            SizedBox(width: 6),
            Text(
              e.dept,
            ),
          ])),
          DataCell(Row(children: [
            SizedBox(width: 10),
            Text(
              e.num,
            ),
          ])),
          DataCell(Row(children: [
            SizedBox(width: 15),
            Text(
              e.name,
            ),
          ])),
          DataCell(Row(children: [
            SizedBox(width: 30),
            Text(
              e.count,
            ),
          ])),
        ],
      );
    }).toList();
  }
}
