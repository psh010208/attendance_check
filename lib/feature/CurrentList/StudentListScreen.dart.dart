import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../ApproveList/widget/CustomText.dart';
import '../Home/homeScreen.dart';
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
          title: CustomText(
            id: '출석 일정',
            color: Theme.of(context).secondaryHeaderColor,
            size: 15,
          ),
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
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.person, size: 50, color: Theme.of(context).colorScheme.onTertiaryContainer,),
                  SizedBox(width: 20.w),

                  // department와 name을 가로 정렬
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomText(id: student.department, size: 20.sp),
                          SizedBox(width: 30.w), // department와 name 사이의 간격
                          CustomText(id: student.name, size: 22.sp),
                        ],
                      ),

                      SizedBox(height: 20.h), // department/name과 학번/출석 횟수 간격

                      // 학번과 출석 횟수 세로 정렬
                      CustomText(id: '학번: ${student.studentId}', size: 16.sp),
                      CustomText(id: '출석 횟수: ${student.attendanceCount}', size: 16.sp),
                    ],
                  ),
                ],
              ),
            ),

            // Container로 감싸서 그라데이션 버튼 적용
            Positioned(
              right: 16.w, // 오른쪽 여백
              top: 90.h, // 위쪽 여백
              child: Container(
                width: 95.w,
                height: 30.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.surfaceTint,
                      Theme.of(context).disabledColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.3, 0.9],
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
            ),
          ],
        ),
      ),
    );
  }




  // 카드 디자인
  BoxDecoration _buildCardDecoration(BuildContext context) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [Theme
            .of(context)
            .secondaryHeaderColor
            .withOpacity(0.8), Theme
            .of(context)
            .primaryColorDark
            .withOpacity(0.8)
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.1, 0.9],
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
  Widget _buildFilterButton(String label, VoidCallback onPressed, {double? width}) {
    return Container(
      width: width ?? 100.w, // 버튼 너비 조정 (기본값은 100.w)
      child: ElevatedButton(
        onPressed: onPressed,
        child: Center( // Center 위젯으로 감싸서 중앙 정렬
          child: Text(
            label,
            style: TextStyle(fontSize: 16.sp), // 텍스트 크기 조정
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).unselectedWidgetColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.onInverseSurface,
              Theme.of(context).primaryColorLight,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.3, 0.9],
          ),
        ),
        child: Column(
          children: [
            // 앱바
            AppBar(
              backgroundColor: Theme.of(context).primaryColorLight,
              title: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios,
                        color: Theme
                            .of(context)
                            .colorScheme
                            .scrim,
                        size: 25.sp),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HomeScreen(role: widget.role, id: widget.id),
                        ),
                      );
                    },
                  ),
                  Spacer(),
                  Text('참여 학생 명단', style: TextStyle(fontSize: 22)),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.scrim,
                      size: 25.sp,
                    ),
                    onPressed: () {
                      // 검색 기능 로직
                    },
                  ),
                ],
              ),
              centerTitle: true,
            ),

            // 필터 버튼들
            Column(
              children: [
                SizedBox(height: 20.h,),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onInverseSurface
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildFilterButton('학과별', () {
                            setState(() {
                              _selectedDepartment = '의료IT공학과'; // 필터 예시
                              _loadPendingStudents();
                            });
                          }, width: 90.w), // 개별 너비 설정

                          _buildFilterButton('이름', () {
                            _searchByName();
                          }, width: 70.w), // 개별 너비 설정

                          _buildFilterButton('학번', () {
                            _searchByStudentId();
                          }, width: 70.w), // 개별 너비 설정

                          _buildFilterButton('출석 횟수별', () {
                            setState(() {
                              _sortByAttendance = !_sortByAttendance;
                              _loadPendingStudents();
                            });
                          }, width: 120.w), // 개별 너비 설정
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
      ),
    );
  }
}
