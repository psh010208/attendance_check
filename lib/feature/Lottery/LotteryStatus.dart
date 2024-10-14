import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Model/model.dart';
import 'ViewModel/viewModel.dart'; // LotteryStudent 모델 가져오기

class LotteryDataTable extends StatefulWidget {
  @override
  _LotteryDataTableState createState() => _LotteryDataTableState();
}

class _LotteryDataTableState extends State<LotteryDataTable> {
  bool _isSortAsc = true; // 정렬 기능
  final LotteryViewModel _viewModel = LotteryViewModel(); // ViewModel 인스턴스화

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: SizedBox.expand(
        child: StreamBuilder<List<LotteryStudent>>(
          stream: _viewModel.getLotteryResults(), // Firestore에서 추첨 결과 가져오는 스트림
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator()); // 로딩 중일 때 스피너 표시
            }

            final data = snapshot.data!; // Firestore에서 가져온 데이터 리스트

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: DataTable(
                    columnSpacing: 5, // 열 사이 간격
                    columns: _createColumns(), // 테이블의 열 생성
                    rows: _createRows(data, context), // context 전달 및 행 생성
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
// DataColumn 생성 함수
  DataColumn _buildDataColumn(String label, IconData icon, double width, Function()? onSort) {
    return DataColumn(
      label: Container(
        width: width,
        height: 30,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4.0),
          color: Colors.grey, // 배경색
        ),
        child: Row(
          children: [
            SizedBox(width: 6),
            Icon(icon, size: 25),
            SizedBox(width: 5),
            Text(label),
          ],
        ),
      ),
      onSort: onSort == null ? null : (columnIndex, _) => onSort(),
    );
  }
  // 열 생성 함수
  List<DataColumn> _createColumns() {
    return [
      _buildDataColumn('학과', Icons.arrow_drop_down, 115, () {
        setState(() {
          _isSortAsc = !_isSortAsc;
        });
      }),
      _buildDataColumn('학번', Icons.search, 85, null),
      _buildDataColumn('이름', Icons.search, 75, null),
      _buildDataColumn('참여횟수', Icons.arrow_drop_down, 95, () {
        setState(() {
          _isSortAsc = !_isSortAsc;
        });
      }),
      DataColumn(label: Text('삭제')) // 삭제 버튼 열 추가
    ];
  }

  // 학생 데이터를 받아서 DataRow로 변환하는 함수
  List<DataRow> _createRows(List<LotteryStudent> data, BuildContext context) {
    return data.map((student) {
      return DataRow(
        cells: [
          _buildDataCell(student.department, context),
          _buildDataCell(student.studentId, context),
          _buildDataCell(student.name, context),
          _buildDataCell(student.attendanceCount.toString(), context),
          DataCell(
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                bool confirmDelete = await _showConfirmationDialog(context);
                if (confirmDelete) {
                  _viewModel.deleteStudent(student.studentId); // 삭제 로직 호출
                }
              },
            ),
          ),
        ],
      );
    }).toList();
  }

  // 각 데이터 셀을 생성하는 함수, 스타일 적용
  DataCell _buildDataCell(String value, BuildContext context) {
    return DataCell(
      Text(
        value,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 100.0, // 폰트 크기 설정
        ),
      ),
    );
  }

  // 삭제 확인 다이얼로그
  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('삭제 확인'),
          content: Text('정말로 삭제하시겠습니까?'),
          actions: [
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop(false); // 취소 시 false 반환
              },
            ),
            TextButton(
              child: Text('삭제'),
              onPressed: () {
                Navigator.of(context).pop(true); // 삭제 시 true 반환
              },
            ),
          ],
        );
      },
    ) ?? false;
  }
}
