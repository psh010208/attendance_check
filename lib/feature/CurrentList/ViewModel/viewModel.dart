import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/model.dart';

class CurrentViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 학생 출석 현황 리스트 가져오기
  Future<List<currentListModel>> getCurrentList({
    String? searchName,            // 이름 검색
    String? searchStudentId,        // 학번 검색
    String? department,             // 학과별 필터링
    bool sortByAttendance = false,  // 출석 횟수별 정렬
  }) async {
    try {
      // user 테이블에서 기본 정보 가져오기
      QuerySnapshot userSnapshot = await _firestore.collection('user').get();

      // 출석 정보를 저장할 맵
      Map<String, int> attendanceMap = {};

      // attendance_summary 테이블에서 출석 정보 가져오기
      for (var userDoc in userSnapshot.docs) {
        final data = userDoc.data() as Map<String, dynamic>;
        final studentId = data['student_id'] ?? '';

        // student_id가 있는 경우에만 출석 정보를 쿼리
        if (studentId.isNotEmpty) {
          QuerySnapshot attendanceSnapshot = await _firestore
              .collection('attendance_summary')
              .where('student_id', isEqualTo: studentId)
              .get();

          if (attendanceSnapshot.docs.isNotEmpty) {
            final attendanceData = attendanceSnapshot.docs.first.data() as Map<String, dynamic>;
            attendanceMap[studentId] = attendanceData['total_attendance'] ?? 0;
          } else {
            attendanceMap[studentId] = 0; // 출석 데이터가 없으면 0으로 설정
          }
        }
      }

      // user 테이블 데이터를 기반으로 리스트 생성
      List<currentListModel> currentList = userSnapshot.docs.map((userDoc) {
        final data = userDoc.data() as Map<String, dynamic>;
        final studentId = data['student_id'] ?? '';

        return currentListModel(
          studentId: studentId,
          name: data['name'] ?? '', // 이름 가져오기
          department: data['department'] ?? '',
          attendanceCount: attendanceMap[studentId] ?? 0, // 출석 횟수 가져오기
        );
      }).toList();

      // 필터링 (이름 검색, 학번 검색, 학과 필터링)
      if (searchName != null && searchName.isNotEmpty) {
        currentList = currentList.where((student) => student.name.contains(searchName)).toList();
      }
      if (searchStudentId != null && searchStudentId.isNotEmpty) {
        currentList = currentList.where((student) => student.studentId.contains(searchStudentId)).toList();
      }
      if (department != null && department.isNotEmpty) {
        currentList = currentList.where((student) => student.department == department).toList();
      }

      // 출석 횟수별 정렬
      if (sortByAttendance) {
        currentList.sort((a, b) => b.attendanceCount.compareTo(a.attendanceCount));
      }

      return currentList;
    } catch (e) {
      print('Error fetching current list: $e');
      return [];
    }
  }
}
