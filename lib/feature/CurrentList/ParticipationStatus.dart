import 'package:flutter/material.dart';

import 'ParticipationData.dart';

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
          title: Text('참여 학생 현황',
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
        body: StudentDataTable(), //body 영역 클래스로 선언
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
  bool _isSortAsc = true; //정렬 기능

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildUI(),);
  }
  Widget _buildUI() {
    return SafeArea(
      child: SizedBox.expand(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal, //좌우 스크롤
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical, //상하 스크롤
            child: DataTable(
              columns: _createColumns(),
              rows: _createRows(),
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
        label: const Text("학과"),
        onSort: (columnIndex, _) {
          setState(() {
            if (_isSortAsc) {
              _data.sort(
                    (a, b) => a.dept.compareTo(b.dept),
              );
            } else{
              _data.sort(
                    (a, b) => b.count.compareTo(a.count),
              );
            }
            _isSortAsc = !_isSortAsc;
          });
        }),
      const DataColumn(
        label: Text("학번"),
      ),
      const DataColumn(
        label: Text("이름"),
      ),
      DataColumn(
        label: const Text("참여 횟수"),
          onSort: (columnIndex, _) {
            setState(() {
              if (_isSortAsc) {
                _data.sort(
                      (a, b) => a.count.compareTo(b.count),
                );
              } else{
                _data.sort(
                      (a, b) => b.count.compareTo(a.count),
                );
              }
              _isSortAsc = !_isSortAsc;
            });
          }
      ),
    ];
  }
  
  //표 내용(StudentData.dart에서 불러옴)
  List<DataRow> _createRows() {
    return _data.map((e) {
      return DataRow(
          cells: [
            DataCell(
                Text(
                    e.dept,
                ),
            ),
            DataCell(
              Text(
                e.num.toString(),
              ),
            ),
            DataCell(
              Text(
                e.name,
              ),
            ),
            DataCell(
              Text(
                e.count.toString(),
              ),
            ),
          ],
      );
    }).toList();
  }
}