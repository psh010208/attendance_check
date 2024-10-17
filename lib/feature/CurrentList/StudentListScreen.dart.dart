import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../ApproveList/widget/CustomText.dart';
import 'ViewModel/viewModel.dart';
import 'model/model.dart';

class StudentListScreen extends StatefulWidget {
  final String role;
  final String id;

  StudentListScreen({required this.role, required this.id});

  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final CurrentViewModel _viewModel = CurrentViewModel();
  List<currentListModel> _pendingStudents = [];
  bool _isLoading = false;

  String? _searchName;
  String? _searchStudentId;
  String? _selectedDepartment;
  bool _sortByAttendance = false;

  @override
  void initState() {
    super.initState();
    _loadPendingStudents(); // 학생 리스트 로드
  }

  // 학생 데이터 로드하는 로직
  Future<void> _loadPendingStudents() async {
    setState(() {
      _isLoading = true;
    });

    final students = await _viewModel.getCurrentList(
      searchName: _searchName,
      searchStudentId: _searchStudentId,
      department: _selectedDepartment,
      sortByAttendance: _sortByAttendance,
    );

    setState(() {
      _pendingStudents = students;
      _isLoading = false;
    });
  }

  // 출석 횟수 버튼 클릭 시 일정표 보여주기
  void _showAttendanceSchedule() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: CustomText(id:'출석 일정',color: Theme.of(context).colorScheme.scrim,size: 15,),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 일정표 표시
              ListView.builder(
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Card(
                    color: index % 2 == 0 ? Colors.blue[50] : Colors.transparent,
                    child: ListTile(
                      title: Text('일정 ${index + 1}'),
                      subtitle: Text('2024 / 10 / 9 / 14:30'),
                    ),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  // 카드 디자인
  Widget _buildStudentCard(BuildContext context, currentListModel student) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        decoration: _buildCardDecoration(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.person, size: 50, color: Colors.blueAccent),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(id: student.department, size: 18),
                    CustomText(id: student.name, size: 22),
                    CustomText(id: '학번: ${student.studentId}', size: 16),
                    CustomText(id: '출석 횟수: ${student.attendanceCount}', size: 16),
                  ],
                ),
              ),
              // Container로 감싸서 그라데이션 버튼 적용
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.lightBlueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: _showAttendanceSchedule,
                  child: Text('출석 횟수'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // 투명하게 설정
                    shadowColor: Colors.transparent, // 그림자 제거
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 카드 디자인
  BoxDecoration _buildCardDecoration(BuildContext context) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.9), Colors.blueAccent.withOpacity(0.1)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          spreadRadius: 2,
          offset: Offset(0, 5),
        ),
      ],
    );
  }

  // 필터 버튼 디자인
  Widget _buildFilterButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('참여 학생 명단', style: TextStyle(fontSize: 22)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // 검색 기능 로직
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 필터 버튼들
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterButton('학과별 정렬', () {
                  setState(() {
                    _selectedDepartment = '의료IT공학과'; // 필터 예시
                    _loadPendingStudents();
                  });
                }),
                _buildFilterButton('이름 검색', () {
                  _searchByName();
                }),
                _buildFilterButton('학번 검색', () {
                  _searchByStudentId();
                }),
                _buildFilterButton('출석 횟수별 정렬', () {
                  setState(() {
                    _sortByAttendance = !_sortByAttendance;
                    _loadPendingStudents();
                  });
                }),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _pendingStudents.length,
              itemBuilder: (context, index) {
                final student = _pendingStudents[index];
                return _buildStudentCard(context, student);
              },
            ),
          ),
        ],
      ),
    );
  }

  // 이름 검색
  void _searchByName() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('이름으로 검색'),
          content: TextField(
            onChanged: (value) {
              _searchName = value;
            },
            decoration: InputDecoration(hintText: '이름 입력'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _loadPendingStudents();
              },
              child: Text('검색'),
            ),
          ],
        );
      },
    );
  }

  // 학번 검색
  void _searchByStudentId() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('학번으로 검색'),
          content: TextField(
            onChanged: (value) {
              _searchStudentId = value;
            },
            decoration: InputDecoration(hintText: '학번 입력'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _loadPendingStudents();
              },
              child: Text('검색'),
            ),
          ],
        );
      },
    );
  }
}
