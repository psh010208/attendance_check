import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
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
  void _showAttendanceSchedule(String studentId) async {
    try {
      // attendance 테이블에서 해당 학생의 출석 기록 가져오기
      QuerySnapshot attendanceSnapshot = await FirebaseFirestore.instance
          .collection('attendance')
          .where('student_id', isEqualTo: studentId)
          .get();

      // 출석한 일정의 QR 코드 목록 가져오기 (List<dynamic>으로 처리)
      List<dynamic> attendedQrCodes = attendanceSnapshot.docs
          .map((doc) => doc['qr_code'] as List<dynamic>)
          .expand((qrCodes) => qrCodes) // List<List> 형태를 1차원 List로 변환
          .toList();

      // QR 코드 목록이 비어 있는지 확인
      if (attendedQrCodes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('해당 학생의 출석 기록이 없습니다.')),
        );
        return;
      }

      // schedules 테이블에서 해당 QR 코드에 해당하는 일정 가져오기
      QuerySnapshot schedulesSnapshot = await FirebaseFirestore.instance
          .collection('schedules')
          .get();

      List<QueryDocumentSnapshot> matchingSchedules = schedulesSnapshot.docs.where((doc) {
        String scheduleQrCode = doc['qr_code'] as String;
        return attendedQrCodes.contains(scheduleQrCode); // QR 코드 비교
      }).toList();

      // 일정 데이터를 다이얼로그로 표시
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: CustomText(
              id: '출석 일정',
              color: Theme.of(context).colorScheme.outline,
              size: 15.sp,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 출석한 일정표 표시
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: matchingSchedules.length,
                  itemBuilder: (context, index) {
                    final scheduleData = matchingSchedules[index].data() as Map<String, dynamic>;

                    // 시간을 원하는 형식으로 변환
                    DateTime parsedStartTime = scheduleData['start_time'].toDate();
                    String formattedStartTime = DateFormat('hh:mm a').format(parsedStartTime);

                    return Card(
                      color: index % 2 == 0 ?
                      Theme.of(context).primaryColorLight :
                      Theme.of(context).secondaryHeaderColor,
                      child: ListTile(
                        title: Text(scheduleData['schedule_name']),
                        subtitle: Text(formattedStartTime),
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
    } catch (e) {
      print('Error loading attendance schedule: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('일정 로드 중 오류가 발생했습니다: $e')),
      );
    }
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.person, size: 50, color: Theme.of(context).colorScheme.onTertiaryContainer,),
              SizedBox(width: 15.w),

              // department와 name을 각각 따로 정렬
              Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬 설정
                children: [
                  // 첫 번째 그룹: 학과, 학번
                  Row(
                    children: [
                      CustomText(id: student.department, size: 27.sp), // 학과
                      SizedBox(width: 10.w),
                      CustomText(id: ' ${student.studentId}', size: 16.sp), // 학번
                    ],
                  ),

                  // 두 번째 그룹: 이름
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0), // 이름과 첫 번째 그룹 사이의 간격 설정
                    child: CustomText(
                      id: student.name,
                      size: 22.sp,
                      overflow: TextOverflow.ellipsis, // 텍스트가 길면 "..."으로 표시
                      maxLines: 1, // 한 줄까지만 표시
                    ),
                  ),

                  // 세 번째 그룹: 출석 횟수 및 버튼을 하나의 Row로 정렬
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0), // 출석 횟수와 이름 사이의 간격 설정
                    child: Row(
                      children: [
                        // 출석 횟수 텍스트
                        CustomText(
                            id: '출석 횟수: ${student.attendanceCount}',
                            size: 16.sp,
                          color: Theme.of(context).disabledColor,
                        ),
                        SizedBox(width: 50.w), // 버튼과 출석 횟수 간 간격

                        // Container로 감싸서 그라데이션 버튼 적용
                        Container(
                          width: 110.w,
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
                            onPressed: () => _showAttendanceSchedule(student.studentId),
                            child: Text('출석 확인'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent, // 투명하게 설정
                              shadowColor: Colors.transparent, // 그림자 제거
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
          content: Container(
            decoration: BoxDecoration( // BoxDecoration을 사용하여 그라데이션 추가
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).secondaryHeaderColor.withOpacity(0.8),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.3, 0.9],
              ),
            ),
            child: TextField(
              onChanged: (value) {
                _searchName = value;
              },
              decoration: InputDecoration(hintText: '이름 입력'),
            ),
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
          content: Container(
            decoration: BoxDecoration( // BoxDecoration을 사용하여 그라데이션 추가
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).secondaryHeaderColor.withOpacity(0.8),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.3, 0.9],
              ),
            ),
            child: TextField(
              onChanged: (value) {
                _searchStudentId = value;
              },
              decoration: InputDecoration(hintText: '학번 입력'),
            ),
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
