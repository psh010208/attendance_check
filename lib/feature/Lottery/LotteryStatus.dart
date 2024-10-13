import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  _LotteryDataTableState createState() => _LotteryDataTableState();
}

class _LotteryDataTableState extends State<LotteryDataTable> {
  bool _isSortAsc = true; // 정렬 기능

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: SizedBox.expand(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('lottery').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator()); // 로딩 중일 때 스피너 표시
            }

            final data = snapshot.data!.docs;

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: DataTable(
                    columnSpacing: 5, // 열 사이 간격
                    columns: _createColumns(),
                    rows: _createRows(data),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // 표 제목
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
        onSort: (columnIndex, _) {
          setState(() {
            _isSortAsc = !_isSortAsc;
          });
        },
      ),
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
        onSort: (columnIndex, _) {
          setState(() {
            _isSortAsc = !_isSortAsc;
          });
        },
      ),
    ];
  }

  // 표 내용 생성
  List<DataRow> _createRows(List<DocumentSnapshot> data) {
    return data.map((doc) {
      final student = doc.data() as Map<String, dynamic>;

      return DataRow(
        cells: [
          DataCell(Text(student['department'] ?? '')),
          DataCell(Text(student['student_id'] ?? '')),
          DataCell(Text(student['student_name'] ?? '')),
          DataCell(Text(student['attendance_count'].toString() ?? '0')),
        ],
      );
    }).toList();
  }
}
